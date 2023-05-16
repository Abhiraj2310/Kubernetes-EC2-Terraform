# Define the AWS provider
provider "aws" {
  access_key = "<AKIA2H36PBWVVAB24IWK>"
  secret_key = "<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>"
  region     = "us-east-1"
}

# Define the VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define the public subnet
resource "aws_subnet" "k8s_public_subnet" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Define the private subnet
resource "aws_subnet" "k8s_private_subnet" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.0.2.0/24"
}

# Define the security group
resource "aws_security_group" "k8s_security_group" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the EC2 instance
resource "aws_instance" "k8s_instance" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.micro"
  key_name      = "abhinew.pem"
  subnet_id     = aws_subnet.k8s_public_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_security_group.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl enable docker",
      "sudo systemctl start docker"
      
    ]
  }
}



