locals {
  ami_id = data.aws_ami.rhel.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
  database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_id.value)[0]

  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
}

