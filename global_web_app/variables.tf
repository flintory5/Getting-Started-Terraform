variable "aws_region" {
  type        = string
  description = "AWS Region to use for resources"
  default     = "us-east-1"
}

variable "ami_name" {
  type        = string
  description = "Amazon AMI Name to retrieve latest version for EC2 Instances"
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR Block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostnames for vpc"
  default     = true
}

variable "vpc_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR Block for the subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "public_ip" {
  type        = bool
  description = "Enable Ec2 Instances to have public IP when launched"
  default     = true
}

variable "route_table_cidr_block" {
  type        = string
  description = "CIDR Block for the route table"
  default     = "0.0.0.0/0"
}

variable "sg_ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR Blocks for the NGINX ingress (inbound) Sec Group"
  default     = ["0.0.0.0/0"]
}

variable "sg_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR Blocks for the NGINX egress (outbound) Sec Group"
  default     = ["0.0.0.0/0"]
}

variable "nginx_security_group" {
  type        = map(string)
  description = "NGINX Security Group Variables"
  default = {
    sg_name          = "nginx_sg"
    ingress_protocol = "tcp"
    egress_protocol  = "-1"
  }
}

variable "nginx_instance_type" {
  type        = string
  description = "EC2 Instance type for NGINX"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company value for AWS Tag"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "Project value for AWS Tag"
}

variable "billing_code" {
  type        = string
  description = "Billing Code for AWS Tag"
}

variable "alb_tg_port" {
  type        = number
  description = "Application Load Balancer port"
  default     = 80
}

variable "alb_tg_protocol" {
  type        = string
  description = "Application Load Balancer protocol"
  default     = "HTTP"
}
