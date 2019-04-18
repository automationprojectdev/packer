provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "MyInstancefromPacker" {
  instance_type = "t2.micro",
  image_id = "${var.ami}",
  key_name="KeyPair-Ohio"
}
