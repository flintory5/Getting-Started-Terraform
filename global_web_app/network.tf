##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = var.ami_name
}

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}

resource "aws_subnet" "subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_subnet_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.public_ip
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = var.nginx_security_group.sg_name
  vpc_id = aws_vpc.vpc.id

  # HTTP access from only vpc address - we just want traffic from the load balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.nginx_security_group.ingress_protocol
    cidr_blocks = [var.vpc_cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.nginx_security_group.egress_protocol
    cidr_blocks = var.sg_egress_cidr_blocks
  }

  tags = local.common_tags
}

resource "aws_security_group" "alb-sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.nginx_security_group.ingress_protocol
    cidr_blocks = var.sg_ingress_cidr_blocks
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.nginx_security_group.egress_protocol
    cidr_blocks = var.sg_egress_cidr_blocks
  }

  tags = local.common_tags
}