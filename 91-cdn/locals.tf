locals {
    acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
}