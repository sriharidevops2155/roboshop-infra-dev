#!/bin/bash

component=$1
dnf install ansible -y 
ansible-pull -U https://github.com/sriharidevops2155/ansible-roboshop-roles.git -e component=$1 main.yml 