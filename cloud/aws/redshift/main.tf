provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
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


resource "aws_redshift_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.my_subnet.id]

  tags = {
    Name = "example"
  }

  depends_on = [aws_internet_gateway.my_internet_gateway]
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier                  = var.CLUSTER_NAME
  node_type                           = var.NODE_TYPE
  number_of_nodes                     = var.NODE_COUNT
  database_name                       = var.DBNAME
  skip_final_snapshot                 = true
  automated_snapshot_retention_period = 0

  cluster_subnet_group_name = aws_redshift_subnet_group.example.name

  master_username = var.MASTER_USERNAME
  master_password = var.MASTER_PASSWORD

  iam_roles = [aws_iam_role.redshift_role.arn]
}

resource "aws_iam_role" "redshift_role" {
  name               = "redshift_s3_access"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "redshift_access" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }
  }
}
