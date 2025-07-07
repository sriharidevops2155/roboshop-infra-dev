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

module "user" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "user_sg"
    sg_description = "Security group for user"
    vpc_id = local.vpc_id
}

module "cart" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "cart_sg"
    sg_description = "Security group for cart"
    vpc_id = local.vpc_id
}

module "shipping" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "shipping_sg"
    sg_description = "Security group for shipping"
    vpc_id = local.vpc_id
}

module "payment" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "payment_sg"
    sg_description = "Security group for payment"
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

module "frontend" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    vpc_id = local.vpc_id
}

module "frontend_alb" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "frontend_alb_sg"
    sg_description = "Security group for frontend_alb"
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

module "vpn" {
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/sriharidevops2155/terraform-aws-sg.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "vpn_sg"
    sg_description = "Security group for VPN"
    vpc_id = local.vpc_id
}

#Mongodb
resource "aws_security_group_rule" "mongodb_vpn_ssh" { #Mongo db is accepting connections from VPN
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_bastion_ssh" { #Mongo db is accepting connections from bastion
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {#Mongo db is accepting connections from Catalogue
  type              = "ingress"
  from_port         = 27017
  to_port           = 27019
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id ###It is coming from catalogue
  security_group_id = module.mongodb.sg_id # it is going to mongodb 
}

resource "aws_security_group_rule" "mongodb_user" {#Mongo db is accepting connections from user
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id ###It is coming from catalogue
  security_group_id = module.mongodb.sg_id # it is going to mongodb 
}

#Redis
resource "aws_security_group_rule" "redis_vpn_ssh" {#Redis is accepting connections from SSH
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_bastion_ssh" {#Redis is accepting connections from SSH
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_user" {#Redis is accepting connections from User
  type              = "ingress"
  from_port         = 6739
  to_port           = 6739
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id ###It can be either VPN or bastion
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_cart" {#Redis is accepting connections from Cart
  type              = "ingress"
  from_port         = 6739
  to_port           = 6739
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id ###It can be either VPN or bastion
  security_group_id = module.redis.sg_id
}

#Mysql
resource "aws_security_group_rule" "mysql_vpn_ssh" {#mysql is accepting connections from SSH
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_bastion_ssh" {#mysql is accepting connections from SSH
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {#mysql is accepting connections from shipping
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id ###It can be either VPN or bastion
  security_group_id = module.mysql.sg_id
}

#RabbitMQ
resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {#rabbitmq is accepting connections from vpn
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastion_ssh" {#rabbitmq is accepting connections from vpn
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {#rabbitmq is accepting connections from Payment
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id ###It can be either VPN or bastion
  security_group_id = module.rabbitmq.sg_id
}

#Catalogue
resource "aws_security_group_rule" "catalogue_vpn_ssh" {#Catalogue is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_bastion_ssh" {#Catalogue is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_vpn_http" {#Catalogue is accepting connections from http
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

resource "aws_security_group_rule" "catalogue_backend_alb" {#Catalogue is accepting connections from backendalb
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.catalogue.sg_id # We are creating this rule in calataogue secuirty group 
}

#User
resource "aws_security_group_rule" "user_vpn_ssh" {#user is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_bastion_ssh" {#user is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {#user is accepting connections from http
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {#user is accepting connections from alb
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.user.sg_id
}

#Cart
resource "aws_security_group_rule" "cart_vpn_ssh" {#cart is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_bastion_ssh" {#cart is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {#cart is accepting connections from http
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {#cart is accepting connections from alb
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.cart.sg_id
}

#Shipping
resource "aws_security_group_rule" "shipping_vpn_ssh" {#shipping is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {#shipping is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ###It can be either VPN or bastion
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {#shipping is accepting connections from http
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {#shipping is accepting connections from alb
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.shipping.sg_id
}

#Payment
resource "aws_security_group_rule" "payment_vpn_ssh" {#Payment is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ##It can be either VPN or bastion
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_bastion_ssh" {#Payment is accepting connections from ssh
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ##It can be either VPN or bastion
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {#Payment is accepting connections from http
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id ###It can be either VPN or bastion
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {#Payment is accepting connections from alb
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id ###It can be either VPN or bastion
  security_group_id = module.payment.sg_id
}

#Backend ALB
resource "aws_security_group_rule" "backend_alb_vpn" {#backend is accepting connections from vpn
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_bastion" {#backend is accepting connections from vpn
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {#backend is accepting connections from frontend
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

#Frontend 
resource "aws_security_group_rule" "frontend_vpn" {#frontend is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {#frontend is accepting connections from vpn
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}


resource "aws_security_group_rule" "frontend_frontend_alb" {#frontend is accepting connections from alb
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.backend_alb.sg_id
}

#Frontend ALB
resource "aws_security_group_rule" "frontend_alb_http" {#frontend ALB is accepting connections from http
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_https" {#frontend ALB is accepting connections from https
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "bastion_laptop" {#Bastion laptop is accepting connections from laptops
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#VPN ports 22, 443 , 1194 , 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_hhtps" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}


/* #Backend ALB Accepting connections from my bastion host or port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}
 */

