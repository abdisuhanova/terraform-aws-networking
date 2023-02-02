//VPC CREATION
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.env
  }
}

//INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.env
  }
  depends_on = [
    aws_vpc.main
  ]
}

//ROUTE TABLES
resource "aws_route_table" "routes" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.internet
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.env
  }
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.gw
  ]
}

//SUBNETS
data "aws_availability_zones" "available" {}

resource "aws_subnet" "main" {
  count = length(var.subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.subnets_cidr , count.index)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
      Name = "${var.env}-${count.index + 1}"
  }
  depends_on = [
    aws_vpc.main
  ]
}

//ROUTE TABLE CONNECTING
resource "aws_route_table_association" "as" {
  for_each = { for subnet in aws_subnet.main : subnet.id => subnet.id }
  subnet_id = each.value
  route_table_id = aws_route_table.routes.id
  depends_on = [
    aws_route_table.routes,
    aws_subnet.main
  ]
}

//SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = var.env
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = [local.internet]
    }
    
  }
  
  dynamic "egress" {
    for_each = var.egress
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "-1"
      cidr_blocks      = [local.internet]
    }
    
}


depends_on = [
  aws_vpc.main
]
}