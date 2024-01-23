#!/bin/bash

if ! command -v aws &> /dev/null; then
    echo "AWS CLI no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y awscli
fi


stack_name="JosemiPila"

template_file="main.yml"

aws cloudformation create-stack \
    --stack-name $stack_name \
    --template-body file://$template_file

aws cloudformation wait stack-create-complete --stack-name $stack_name

echo "Stack desplegado exitosamente: $stack_name"
