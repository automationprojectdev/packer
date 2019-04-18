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
packer build -machine-readable test-cluster.json | tee test-cluster.log
export AMI_ID=$(grep 'artifact,0,id' test-cluster.log | cut -d: -f2)

packer build buildAMIUsingPacker.json | tee test-cluster.log
export AMI_ID=$(grep 'artifact,0,id' test-cluster.log | cut -d: -f2)
echo 'varibale "INSTANCE_AMI" {default = "'${AMI_ID}'"}'  > amivar.tf
aws s3 cp amivar.tf s3://node-aws-demo123123123/amivar.tf

aws s3 cp s3://node-aws-demo123123123/amivar.tf  amivar.tf
terraform init
terraform apply -y

packer build buildAMIUsingPacker.json | tee test-cluster.log
export AMI_ID=$(grep 'artifact,0,id' test-cluster.log | cut -d: -f2)
echo 'varibale "INSTANCE_AMI" {default = "'${AMI_ID}'"}'  > amivar.tf
aws s3 cp amivar.tf s3://node-aws-demo123123123/amivar.tf

aws s3 cp s3://node-aws-demo123123123/amivar.tf  amivar.tf
terraform init
terraform apply -y

# run packer (prints to stdout, but stores the output in a variable)
packer_out=$(packer build buildAMIUsingPacker.json | tee /dev/tty)

# packer prints the id of the generated AMI in its last line
ami=$(echo "$packer_out" | tail -c 30 | perl -n -e'/: (ami-.+)$/ && print $1')

# create the 'ami.tf' file from the template:
export AMI_GENERATED_BY_PACKER="$ami" && envsubst < ami.tf.template > ami.tf
