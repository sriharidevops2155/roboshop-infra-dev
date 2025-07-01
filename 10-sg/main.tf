module "frontend" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    vpc_id = local.vpc_id
}

module "bastion" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    vpc_id = local.vpc_id
}

module "backend_alb" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.backend_alb_sg_name
    sg_description = var.backend_alb_sg_description
    vpc_id = local.vpc_id
}

module "vpn_sg" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "vpn_sg"
    sg_description = "Security group for VPN"
    vpc_id = local.vpc_id
}

module "mongodb" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "mongodb_sg"
    sg_description = "Security group for Mongodb"
    vpc_id = local.vpc_id
}

module "redis" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "redis_sg"
    sg_description = "Security group for redis"
    vpc_id = local.vpc_id
}

module "mysql" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "mysql_sg"
    sg_description = "Security group for mysql"
    vpc_id = local.vpc_id
}

module "rabbitmq" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "rabbitmq_sg"
    sg_description = "Security group for rabbitmq"
    vpc_id = local.vpc_id
}

module "catalogue" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "catalogue_sg"
    sg_description = "Security group for catalogue"
    vpc_id = local.vpc_id
}

#Bastion gonna accept connections from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.bastion.sg_id
}

#Backend ALB Accepting connections from my bastion host or port no 80
resource "aws_security_group_rule" "backend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

#VPN ports 22, 443 , 1194 , 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_hhtps" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

#Backend ALB Accepting connections from my VPN host or port no 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "redis_vpn_ssh" {
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27019
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id ###It is coming from catalogue
  security_group_id = module.mongodb.sg_id # it is going to mongodb 
}


