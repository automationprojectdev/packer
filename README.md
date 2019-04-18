~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Installation of PACKER on Amazon Linux
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#!bin/bash
sudo su
cd
sudo yum update -y
sudo wget https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip
sudo unzip packer_0.8.6_linux_amd64.zip


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
How to Get the AMI-ID from Packer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# run packer (prints to stdout, but stores the output in a variable)
packer_out=$(packer build buildAMIUsingPacker.json | tee /dev/tty)

# packer prints the id of the generated AMI in its last line
ami=$(echo "$packer_out" | tail -c 30 | perl -n -e'/: (ami-.+)$/ && print $1')

cd tfrepo
terraform init
terraform apply
