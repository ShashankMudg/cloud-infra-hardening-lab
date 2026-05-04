data "aws_availability_zones" "azs" {}

locals {
  azs = slice(data.aws_availability_zones.azs.names, 0, var.az_count)
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# PUBLIC
resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
}

resource "aws_security_group" "lambda_sg" {
  name        = "aegissync-lambda-sg"
  description = "Lambda security group"
  vpc_id      = aws_vpc.main.id

  # Outbound allowed (Lambda needs to call APIs, DB, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# PRIVATE
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 10)
  availability_zone = local.azs[count.index]
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# NAT (PER AZ)
resource "aws_eip" "nat" {
  count = var.az_count
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count = var.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}