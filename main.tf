# Reuse a public subnet and its VPC to keep the lab small.
data "aws_subnet" "public" {
  id = var.public_subnet_id
}

data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_security_group" "nginx" {
  name_prefix = "terraform-nginx-lab-"
  description = "Allow HTTP and restricted SSH for the Nginx lab"
  vpc_id      = data.aws_subnet.public.vpc_id

  ingress {
    description = "Public HTTP for the lab page"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from the operator public IPv4 address"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Outbound traffic for Ubuntu package installation"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "terraform-nginx-lab-sg" }
}

resource "aws_instance" "nginx" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  key_name                    = var.key_name

  # Replacing the instance reruns cloud-init when the bootstrap script changes.
  user_data                   = file("${path.module}/user-data.sh")
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags        = { Name = "terraform-nginx-lab" }
  volume_tags = { Name = "terraform-nginx-lab-root" }
}
