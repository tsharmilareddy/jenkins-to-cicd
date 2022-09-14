
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "apache2" {
  name        = "cicd-apache1"
  description = "connecting to cicd"
  vpc_id      = "	vpc-01c4963a98c786534"

  ingress {
    description = "connecting to cicd"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description = "connecting to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description = "connecting to cicd"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache2"
  }
}



resource "aws_instance" "apache" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id     = "subnet-000b0baeef8df3671"
  key_name      = "chinni"

  vpc_security_group_ids = [aws_security_group.apache2.id]
  user_data              = <<-EOF
 #!/bin/bash
  yum update -y
  yum install httpd -y
  systemctl start httpd
  systemctl enable httpd
  EOF



  tags = {
    Name = "apache"
  }
}