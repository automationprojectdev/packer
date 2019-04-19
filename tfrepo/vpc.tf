resource "aws_vpc" "mainvpc" {
  cidr_block = "${var.vpc-fullcidr}"

  tags {
    Name = "MainVPC-Ohio"
  }
}
