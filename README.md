# 1.  Installation of PACKER on Amazon Linux
sudo su
cd
sudo yum update -y
sudo wget https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip
sudo unzip packer_0.8.6_linux_amd64.zip
packer -v

# 2.How to Get the AMI-ID from Packer

# 2.1   Bucket Creation using AWS CLI
aws s3api create-bucket --bucket (buckername) --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1

# 2.2   Run packer (prints to stdout, but stores the output in a variable)
packer_out=$(packer build buildAMIUsingPacker.json | tee /dev/tty)

# 2.3   Packer prints the id of the generated AMI in its last line
ami_id=$(echo "$packer_out" | tail -c 30 | perl -n -e'/: (ami-.+)$/ && print $1')

# 2.4   Create a file amivar_web.tf to store ami_id
echo 'variable "ami" { default = "'${ami_id}'" }' > amivar_web.tf

# 2.5 copies the file to any s3 Bucket
aws s3 cp amivar_web.tf s3://(CreatedBucketName)/amivar_web.tf
cd tfrepo
aws s3 cp s3://<CreatedBucketName>/amivar_web.tf amivar_web.tf
terraform init
terraform apply -input=false -auto-approve
