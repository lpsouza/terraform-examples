provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

locals {
  vmname        = "my-vm"
  instance_type = "t2.micro"
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${local.vmname}-key-pair"
  public_key = var.AWS_KEY_PAIR
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.vmname}-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "${local.vmname}-subnet"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.vmname}-internet-gateway"
  }
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "${local.vmname}-security-group"
  description = "Security group for my instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami                         = local.ami
  instance_type               = local.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  user_data = <<-EOF
  #cloud-config
  hostname: ${local.vmname}
  EOF

  # root_block_device {
  #   volume_size = 50
  # }

  tags = {
    Name = local.vmname
  }
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "private_ip" {
  value = aws_instance.my_instance.private_ip
}
