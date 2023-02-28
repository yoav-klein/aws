
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 4.51"
        }
    }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "this" {
  name = "cw_test_sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "cw_test_key"
  public_key = file("aws.pub")
}

locals {
    environments = ["prod", "dev"]
    teams = [ "yossi", "gadi", "boris" ]
}

resource "aws_instance" "this" {
    count = 8

    ami = var.ami
    key_name = "cw_test_key"
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.this.id]
    subnet_id = data.aws_subnets.default_subnets.ids[ count.index % length(data.aws_subnets.default_subnets) ]
    monitoring = true
    tags = {
      Name = "cw_test${count.index}"
      team = "${local.teams[ count.index % length(local.teams) ]}"
      environment = "${local.environments[ count.index % length(local.environments) ]}"
  }
   
}

