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
#Bucket Creation using AWS CLI
aws s3api create-bucket --bucket <Name of the bucket> --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1

# run packer (prints to stdout, but stores the output in a variable)
packer_out=$(packer build buildAMIUsingPacker.json | tee /dev/tty)

# packer prints the id of the generated AMI in its last line
ami_id=$(echo "$packer_out" | tail -c 30 | perl -n -e'/: (ami-.+)$/ && print $1')

# create a file amivar_web.tf to store ami_id
echo 'variable "ami" { default = "'${ami_id}'" }' > amivar_web.tf

# Copies the file to any s3 Bucket
aws s3 cp amivar_web.tf s3://<CreatedBucketName>/amivar_web.tf

cd tfrepo
aws s3 cp s3://<CreatedBucketName>/amivar_web.tf amivar_web.tf
terraform init
terraform apply -input=false -auto-approve
