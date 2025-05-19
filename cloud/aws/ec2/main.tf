provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.EC2_VM_NAME}-key-pair"
  public_key = var.AWS_KEY_PAIR
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.EC2_VM_NAME}-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags = {
    Name = "${var.EC2_VM_NAME}-subnet"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.EC2_VM_NAME}-internet-gateway"
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
  name        = "${var.EC2_VM_NAME}-security-group"
  description = "Security group for my instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = var.EC2_AMI
  instance_type = var.EC2_INSTANCE_TYPE
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = aws_key_pair.key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  user_data = <<-EOF
  #cloud-config
  hostname: ${var.EC2_VM_NAME}
  EOF

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = var.EC2_VM_NAME
  }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_instance.id
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "private_ip" {
  value = aws_instance.my_instance.private_ip
}