provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "rke_basion" {
  key_name   = "rke-basion-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "rke_master" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  key_name = aws_key_pair.rke_basion.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "RKE-Master"
  }
}

resource "aws_instance" "rke_worker1" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.rke_basion.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "RKE-Worker-1"
  }
}

resource "aws_instance" "rke_worker2" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.rke_basion.key_name
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "RKE-Worker-2"
  }
}


output "rke_master_ip" {
  value = aws_instance.rke_master.public_ip
}

output "rke_worker1_ip" {
  value = aws_instance.rke_worker1.public_ip
}

output "rke_worker2_ip" {
  value = aws_instance.rke_worker2.public_ip
}