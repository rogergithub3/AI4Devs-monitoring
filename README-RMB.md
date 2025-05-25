# - Explicación de los cambios realizados.
## Cambios Realizados

### 1. Infraestructura AWS (Terraform)
- Creación de instancias EC2 t3.micro en la región eu-north-1 (Estocolmo)
- Configuración de un bucket S3 para almacenar los archivos frontend.zip y backend.zip
- Implementación de políticas IAM para permitir acceso desde EC2 a S3
- Configuración de grupos de seguridad para permitir tráfico en puertos 80, 3000 y 8080
- Creación de key pairs para acceso SSH

### 2. Dockerización
- Creación de Dockerfile para frontend:
  - Base: Node 18
  - Puerto expuesto: 3000
  - Instalación de dependencias y build
- Creación de Dockerfile para backend:
  - Base: Node 18
  - Puerto expuesto: 8080
  - Ejecución de migraciones Prisma
  - Build y ejecución de la aplicación

### 3. CI/CD (GitHub Actions)
- Implementación de pipeline en YAML
- Jobs:
  - Build: Instalación de dependencias, tests, build y despliegue
  - Deploy: Despliegue en AWS (S3 y EC2)
- Configuración de Nginx como proxy inverso
- Mejoras en la ejecución de tests Cypress

### 4. Monitoreo (Datadog)
- Integración con AWS para monitoreo de:
  - Instancias EC2
  - Bucket S3
- Configuración de dashboard personalizado
- Implementación de alertas de costes

### Archivos Modificados/Creados
1. `/tf/`:
   - `main.tf`: Configuración principal de Terraform
   - `variables.tf`: Variables de Terraform
   - `outputs.tf`: Outputs de Terraform
   - `datadog.tf`: Configuración de Datadog

2. `/`:
   - `Dockerfile.frontend`: Configuración Docker para frontend
   - `Dockerfile.backend`: Configuración Docker para backend
   - `.github/workflows/pipeline.yml`: Pipeline de CI/CD
   - `nginx.conf`: Configuración de Nginx
   - `scripts/`: Scripts de utilidad para zips y despliegue

3. Documentación:
   - `README.md`: Actualización de la documentación principal
   - `README-RMB.md`: Documentación de cambios y monitoreo
   - `prompts/`: Documentación de prompts utilizados

# - Capturas de pantalla del dashboard y la alerta en Datadog.
[captura_dashboard.png](./prompts/captura_dashboard.png)

# - Documentación de los prompts utilizados en datadog-aws-prompts.md.

Todos los prompts que he utilizado en este proyecto están documentados en el archivo [datadog-aws-prompts.md](./prompts/datadog-aws-prompts.md)


# - Cualquier desafío encontrado y cómo lo resolviste.

No habia trabajado nunca con Terraform ni datadog. Todo ha sido un desafío al realizar la tarea en 1 día.

Dicho esto creo que el desafío más grande ha sido desplegar con Terraform toda la infrastructura en Europa, ya que me cambiaba automáticamente a Virgína.


