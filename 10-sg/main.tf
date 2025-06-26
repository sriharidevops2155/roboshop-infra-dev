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
