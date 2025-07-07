module "user" {
    source = "git::https://github.com/sriharidevops2155/terraform-aws-roboshop.git?ref=main"
    component = "user"
    rule_priority = 20
}