#!/bin/bash
sudo yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar el agente de Datadog
DD_API_KEY="${dd_api_key}" DD_SITE="${dd_site}" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

# Configurar tags del agente
echo "tags:" >> /etc/datadog-agent/datadog.yaml
echo "  - project:${project_name}" >> /etc/datadog-agent/datadog.yaml
echo "  - env:${environment}" >> /etc/datadog-agent/datadog.yaml
echo "  - role:frontend" >> /etc/datadog-agent/datadog.yaml

# Reiniciar el agente para aplicar la configuración
systemctl restart datadog-agent

# Descargar y descomprimir el archivo frontend.zip desde S3
aws s3 cp s3://${bucket_name}/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
cd /home/ec2-user
sudo docker build -t lti-frontend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 3000:3000 lti-frontend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
