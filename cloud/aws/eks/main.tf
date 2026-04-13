terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}


provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.CLUSTER_NAME}-key-pair"
  public_key = var.AWS_KEY_PAIR
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.CLUSTER_NAME}-vpc"
  }
}

resource "aws_subnet" "my_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.AWS_REGION}a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.CLUSTER_NAME}-subnet-a"
  }
}

resource "aws_subnet" "my_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.AWS_REGION}b"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.CLUSTER_NAME}-subnet-b"
  }
}

resource "aws_subnet" "my_subnet_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.AWS_REGION}c"
  tags = {
    Name = "${var.CLUSTER_NAME}-subnet-c"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.CLUSTER_NAME}-igw"
  }
}

resource "aws_route_table" "my_route_table_igw" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
  tags = {
    Name = "${var.CLUSTER_NAME}-route-table-igw"
  }
}

resource "aws_route_table_association" "my_subnet_c_association" {
  subnet_id      = aws_subnet.my_subnet_c.id
  route_table_id = aws_route_table.my_route_table_igw.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.CLUSTER_NAME}-nat-eip"
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my_subnet_a.id

  tags = {
    Name = "${var.CLUSTER_NAME}-nat-gateway"
  }
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
  tags = {
    Name = "${var.CLUSTER_NAME}-default-route-table"
  }
}

resource "aws_security_group" "my_cluster_security_group" {
  name        = "${var.CLUSTER_NAME}-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "cluster_ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_cluster_security_group.id
}

resource "aws_security_group_rule" "cluster_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_cluster_security_group.id
}

resource "aws_security_group" "my_ng_security_group" {
  name        = "${var.CLUSTER_NAME}-ng-sg"
  description = "Security group for EKS node group"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "ng_ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_ng_security_group.id
}

resource "aws_security_group_rule" "ng_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_ng_security_group.id
}

resource "aws_iam_role" "my_cluster_role" {
  name = "${var.CLUSTER_NAME}-role"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    "arn:aws:iam::aws:policy/AmazonPrometheusQueryAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "my_node_group_role" {
  name = "${var.CLUSTER_NAME}-ng-role"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonPrometheusQueryAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "node_group_role" {
  name = "${var.CLUSTER_NAME}-ng-profile"
  role = aws_iam_role.my_node_group_role.name
}

resource "aws_eks_cluster" "my_cluster" {
  name     = var.CLUSTER_NAME
  role_arn = aws_iam_role.my_cluster_role.arn
  version  = var.EKS_VERSION

  vpc_config {
    subnet_ids = [
      aws_subnet.my_subnet_a.id,
      aws_subnet.my_subnet_b.id
    ]
    security_group_ids = [aws_security_group.my_cluster_security_group.id]
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "${var.CLUSTER_NAME}-ng"
  node_role_arn   = aws_iam_role.my_node_group_role.arn

  subnet_ids = [
    aws_subnet.my_subnet_a.id,
    aws_subnet.my_subnet_b.id
  ]

  scaling_config {
    desired_size = var.EKS_DESIRED_NODES
    min_size     = var.EKS_MIN_NODES
    max_size     = var.EKS_MAX_NODES
  }

  capacity_type = "SPOT"

  launch_template {
    id      = aws_launch_template.my_node_group_template.id
    version = "$Latest"
  }

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}

resource "aws_launch_template" "my_node_group_template" {
  name_prefix            = "${var.CLUSTER_NAME}-ng-template-"
  instance_type          = var.INSTANCE_TYPE
  image_id               = data.aws_ami.my_eks_ami.id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_ng_security_group.id]

  user_data = base64encode(<<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -ex
B64_CLUSTER_CA=${aws_eks_cluster.my_cluster.certificate_authority[0].data}
API_SERVER_URL=${aws_eks_cluster.my_cluster.endpoint}
K8S_CLUSTER_DNS_IP=10.100.0.10
/etc/eks/bootstrap.sh ${aws_eks_cluster.my_cluster.name} --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup-image=${data.aws_ami.my_eks_ami.id},eks.amazonaws.com/capacityType=SPOT,eks.amazonaws.com/nodegroup=${var.CLUSTER_NAME}-ng' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP
--//--
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = var.CLUSTER_NAME
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "my_eks_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amazon-eks-arm64-node-${var.EKS_VERSION}*"]
  }
}
