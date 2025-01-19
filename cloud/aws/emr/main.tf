provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.CLUSTER_NAME}-key-pair"
  public_key = var.AWS_KEY_PAIR
}

resource "aws_iam_role" "my_emr_role" {
  name               = "${var.CLUSTER_NAME}-emr-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "elasticmapreduce.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "emr_service_attach" {
  role       = aws_iam_role.my_emr_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role_policy_attachment" "emr_ec2_attach" {
  role       = aws_iam_role.my_emr_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "emr_s3_attach" {
  role       = aws_iam_role.my_emr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.CLUSTER_NAME}-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "${var.CLUSTER_NAME}-subnet"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.CLUSTER_NAME}-internet-gateway"
  }
}

data "aws_route_table" "my_default_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "my_default_route" {
  route_table_id         = data.aws_route_table.my_default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

resource "aws_security_group" "master_sg" {
  name                   = "${var.CLUSTER_NAME}-master-sg"
  vpc_id                 = aws_vpc.my_vpc.id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "slave_sg" {
  name                   = "${var.CLUSTER_NAME}-slave-sg"
  vpc_id                 = aws_vpc.my_vpc.id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = "${var.CLUSTER_NAME}-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.my_emr_role.arn}"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.bucket}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "${var.CLUSTER_NAME}-instance-profile"
  role = aws_iam_role.my_emr_role.name
}

resource "aws_emr_cluster" "my_cluster" {
  name          = var.CLUSTER_NAME
  release_label = "emr-7.6.0"
  applications  = ["Hadoop", "Spark"]
  service_role  = aws_iam_role.my_emr_role.arn
  log_uri       = "s3://${aws_s3_bucket.my_bucket.bucket}/logs"

  ec2_attributes {
    instance_profile                  = aws_iam_instance_profile.my_instance_profile.arn
    subnet_id                         = aws_subnet.my_subnet.id
    key_name                          = aws_key_pair.key_pair.key_name
    emr_managed_master_security_group = aws_security_group.master_sg.id
    emr_managed_slave_security_group  = aws_security_group.slave_sg.id
  }

  master_instance_group {
    instance_type  = "m4.xlarge"
    instance_count = 1
  }

  core_instance_group {
    instance_type  = "m4.xlarge"
    instance_count = 1
  }

  tags = {
    Name = var.CLUSTER_NAME
  }

  depends_on = [
    aws_route.my_default_route,
    aws_internet_gateway.my_internet_gateway
  ]
}
