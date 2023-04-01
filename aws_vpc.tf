#----------------------------------------
# VPCの作成
#----------------------------------------
resource "aws_vpc" "horiuchi_terraform_sample_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}
#----------------------------------------
# パブリックサブネットの作成
#----------------------------------------
resource "aws_subnet" "horiuchi_terraform_sample_subnet" {
  vpc_id                  = aws_vpc.horiuchi_terraform_sample_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}
#----------------------------------------
# インターネットゲートウェイの作成
#----------------------------------------
resource "aws_internet_gateway" "horiuchi_terraform_sample_igw" {
  vpc_id = aws_vpc.horiuchi_terraform_sample_vpc.id
}
#----------------------------------------
# ルートテーブルの作成
#----------------------------------------
resource "aws_route_table" "horiuchi_terraform_sample_rtb" {
  vpc_id = aws_vpc.horiuchi_terraform_sample_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.horiuchi_terraform_sample_igw.id
  }
}
#----------------------------------------
# サブネットにルートテーブルを紐づけ
#----------------------------------------
resource "aws_route_table_association" "horiuchi_terraform_sample_rt_assoc" {
  subnet_id      = aws_subnet.horiuchi_terraform_sample_subnet.id
  route_table_id = aws_route_table.horiuchi_terraform_sample_rtb.id
}
#----------------------------------------
# セキュリティグループの作成
#----------------------------------------
resource "aws_security_group" "horiuchi_terraform_sample_sg" {
  name   = "horiuchi_terraform_sample-sg"
  vpc_id = aws_vpc.horiuchi_terraform_sample_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
