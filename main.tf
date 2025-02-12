# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region
}

# Local variables block
locals {
  aws_key = "SWEN_Key_Pair"   # SSH key pair name
}

# Security group for HTTP and SSH access
resource "aws_security_group" "my_sg" {
  name        = "my_security_group"
  description = "Allow HTTP and SSH traffic"

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance resource
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.amazonlinux.id  # Replace with your preferred AMI
  instance_type          = var.instance_type            # Define instance type from variables
  key_name               = local.aws_key
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  # Automate the execution of wp_install.sh on startup
  user_data = filebase64("wp_install.sh")

  # Add tags for easy identification
  tags = {
    Name = "my ec2"
  }
}
