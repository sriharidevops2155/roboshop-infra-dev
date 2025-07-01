variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "Created sg for frontend"
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "Created sg bastion instances"
}

variable "backend_alb_sg_name" {
  default = "backend-alb"
}

variable "backend_alb_sg_description" {
  default = "Created backend alb for instances"
}

variable "mongodb_ports_vpn" {
  default = [22,27017]
}

variable "redis_ports_vpn" {
  default = [22,3306]
}

variable "mysql_ports_vpn" {
  default = [22,3306]
}

variable "rabbitmq_ports_vpn" {
  default = [22,5672]
}
