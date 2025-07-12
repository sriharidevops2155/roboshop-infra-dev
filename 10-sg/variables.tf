variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend_sg"
}

variable "frontend_sg_description" {
  default = "Created sg for frontend"
}

variable "bastion_sg_name" {
  default = "bastion_sg"
}

variable "bastion_sg_description" {
  default = "Created sg bastion instances"
}

variable "backend_alb_sg_name" {
  default = "backend_alb_sg"
}

variable "backend_alb_sg_description" {
  default = "Created backend alb for instances"
}

variable "mongodb_ports" { #Just keep as Mongodb Ports 
  default = [22,27017]
}

variable "redis_ports" {
  default = [22,3306]
}

variable "mysql_ports" {
  default = [22,3306]
}

variable "rabbitmq_ports" {
  default = [22,5672]
}
