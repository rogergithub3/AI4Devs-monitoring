#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar el agente de Datadog
DD_API_KEY="${dd_api_key}" DD_SITE="${dd_site}" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

# Configurar tags del agente
echo "tags:" >> /etc/datadog-agent/datadog.yaml
echo "  - project:${project_name}" >> /etc/datadog-agent/datadog.yaml
echo "  - env:${environment}" >> /etc/datadog-agent/datadog.yaml
echo "  - role:backend" >> /etc/datadog-agent/datadog.yaml

# Reiniciar el agente para aplicar la configuración
systemctl restart datadog-agent

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://${bucket_name}/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
