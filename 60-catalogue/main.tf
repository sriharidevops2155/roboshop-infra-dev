resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"  #roboshop-dev-catalogue
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_id.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}