provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami = "ami-0c2ab3b8efb09f272"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl ifconfig.me`
echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "WebServer built by Terraform"
    Owner = "Andy"
  }
}

resource "aws_security_group" "web" {
  name = "WebServer-SG"
  description = "Security Group for a Webserver"

  ingress {
    from_port = 80
    protocol  = "TCP"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol  = "TCP"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServer SG by Terraform"
    Owner = "Andy"
  }
}