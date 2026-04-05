variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}

variable "instance_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_pair_name" {}

provider "aws" {
	region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnets" "default_vpc_subnets" {
	filter {
		name   = "vpc-id"
		values = [data.aws_vpc.default.id]
	}

	filter {
		name   = "default-for-az"
		values = ["true"]
	}
}

resource "aws_security_group" "nginx_web_sg" {
	name        = "${var.instance_name}-nginx-sg"
	description = "Permite trafico web para Nginx y SSH para Ansible"
	vpc_id      = data.aws_vpc.default.id

	ingress {
		description = "HTTP"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "SSH"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.instance_name}-nginx-sg"
	}
}

resource "aws_instance" "nginx_host" {
	ami                         = var.ami_id
	instance_type               = var.instance_type
	key_name                    = var.key_pair_name
	subnet_id                   = data.aws_subnets.default_vpc_subnets.ids[0]
	vpc_security_group_ids      = [aws_security_group.nginx_web_sg.id]
	associate_public_ip_address = true

	tags = {
		Name = var.instance_name
	}
}

output "ec2_public_ip" {
	value = aws_instance.nginx_host.public_ip
}
