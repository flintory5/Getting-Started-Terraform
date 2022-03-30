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
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  cidr = var.vpc_cidr_block[terraform.workspace]

  azs            = slice(data.aws_availability_zones.available.names, 0, (var.vpc_subnet_count[terraform.workspace]))
  public_subnets = [for subnet in range(var.vpc_subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = var.nginx_security_group.sg_name
  vpc_id = module.vpc.vpc_id

  # HTTP access from only vpc address - we just want traffic from the load balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.nginx_security_group.ingress_protocol
    cidr_blocks = [var.vpc_cidr_block[terraform.workspace]]
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
  vpc_id = module.vpc.vpc_id

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