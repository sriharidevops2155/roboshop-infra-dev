#!/bin/bash

component=$1
env=$2
dnf install ansible -y 
ansible-pull -U https://github.com/sriharidevops2155/tf-ansible-roboshop-roles.git -e component=$1 -e env=$2 main.yml 