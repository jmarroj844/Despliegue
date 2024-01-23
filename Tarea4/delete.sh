if ! command -v aws &> /dev/null; then
    echo "AWS CLI no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y awscli
fi

stack_name="JosemiPila"

aws cloudformation delete-stack --stack-name $stack_name

aws cloudformation wait stack-delete-complete --stack-name $stack_name

echo "Stack eliminado exitosamente: $stack_name"
