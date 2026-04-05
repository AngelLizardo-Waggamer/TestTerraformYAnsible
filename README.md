# Scripts para probar un despliegue con terraform y ansible
En este repositorio se encuentran los archivos que ocupé para mi actividad 10 de IaC y Seguridad, la cual consistía en desplegar una página sencilla mediante Nginx en una máquina virtual dentro de la nube de AWS pero que debía de ser desplegada mediante Terraform y configurada mediante ansible.

## Despliegue
Como comentaba, la idea era desplegar mediante Nginx la [página](./app/), pero para poder instalar Nginx en el servidor se usó la imagen en el docker hub y se inició un contenedor con el código web estático. En el [dockerfile](./Dockerfile) se puede ver más claramente que el proceso para construir la imagen es tan simple como copiar los archivos al directorio html del contenedor.

## Terraform
Todo el código que compete a terraform se encuentra en la carpeta de [infra](./infra/), en la cual está el archivo [main.tf](./infra/main.tf) que genera tanto el security group necesario para que la instancia de EC2 acepte el tráfico de SSH y web como también la creación de la instancia misma. En la misma carpeta se encuentra un archivo [env.auto.example.tfvars](./infra/env.auto.example.tfvars) el cual es la referencia de las variables que usé de forma local para desplegar la infraestructura.

## Ansible
Las partes relevantes de ansible son principalmente el [playbook](./install_git_docker.example.yml) el cual es la referencia del que usé localmente pues ocupa datos sensibles para funcionar y el archivo de [hosts](./hosts.example), el cual nuevamente es una referencia del que usé localmente ya que contiene datos sensibles como el token de github y una dirección local hacia la llave ssh.

# Créditos
* Aplicación de encriptación: [lzamora16](https://github.com/lzamora16)