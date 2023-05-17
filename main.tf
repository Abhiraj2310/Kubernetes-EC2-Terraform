# Define the AWS provider
provider "aws" {
  access_key = "****"
  secret_key = "****"
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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


# Define the EC2 master instance
resource "aws_instance" "k8s_master_instance" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.medium"
  key_name      = "abhinew"
  subnet_id     = aws_subnet.k8s_private_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_security_group.id]


  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    usermod -aG docker ubuntu
    systemctl enable docker
    systemctl start docker
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt update -y
    apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y
    kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    EOF
}


# Define the EC2 worker instance
resource "aws_instance" "k8s_instance" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.micro"
  key_name      = "abhinew"
  subnet_id     = aws_subnet.k8s_public_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_security_group.id]
  

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    usermod -aG docker ubuntu
    systemctl enable docker
    systemctl start docker
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt update -y
    apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y
    kubeadm reset --force
    EOF
}


