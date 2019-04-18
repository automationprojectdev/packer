provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "ionapp" {
  image_id                    = "${var.ami}",
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_id                      = "vpc-06aa6b6d07d07cb3d"
  subnet_id                   = "subnet-07f5aa415b2ac0518"
  vpc_security_group_ids      = ["${aws_security_group.WebServerSG-CustomVPC.id}"]
  key_name                    = "KeyPair-Ohio"

  tags {
    Name = "AutomationforPeople-EC2Instance"
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo su
            cd
            apt-get update -y
            apt-get install apache2 git -y
            service apache2 start
            chkconfig apache2 on
            cd /var/www/html
            git clone https://github.com/vCloudmateguru/ion.git
            #echo "Automation for Peole" >> /var/www/html/index.html
            EOF
}
