resource "aws_instance" "ionapp" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id                   = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids      = ["${aws_security_group.WebServer.id}"]
  key_name                    = "${var.key_name}"

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
