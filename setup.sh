#!/bin/bash

#Solo un root podrá ejecutar el script

clear
if [ "$(id -u)" -ne 0 ]; then
    echo "Bienvenido $USER, este Script precisa que estes logeado como root." >&2
    exit 1
fi

#Verificar si estamos en la zona horaria correcta y sino la seteo

ZonaArg="America/Argentina/Cordoba"
ZonaAct=$(timedatectl show --property=Timezone --value)
	
	if [ $ZonaAct == $ZonaArg ]; then

		echo "Zona horaria ya configurada"

	else
		timedatectl set-timezone America/Argentina/Cordoba

	fi

#Cambiamos el nombre del host

echo bootcampwebexperto > /etc/hostname

#Añadimos el usuario webexperto y le damos permisos sudo

adduser webexperto --quiet --disabled-password --gecos "" && echo webexperto:webexperto | chpasswd  && sudo usermod -aG sudo webexperto

#Añadimos un usuario para conectarnos por ssh

adduser --quiet --disabled-password --gecos "" userssh && echo userssh:userssh | sudo chpasswd

sshd="/etc/ssh/sshd_config"

sed -i '/^PermitRootLogin/d; /^AllowUsers/d' "$sshd"

echo -e "PermitRootLogin no\nAllowUsers userssh" >> "$sshd"

service ssh restart

publickeynb="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhXrz4Ts8LDCAu5gOxAQCdH2VNixGmnGemmv+drDLcZ canteronatanael8@gmail.com"

#Actualizamos dependencias

apt -qq update && sudo apt -qq upgrade -y

#Verificamos que tengamos Docker, sino es el caso entonces descargamos Docker

	if command -v docker &>/dev/null; then
    		echo "Docker está instalado."
	else
		curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
	
	fi

#Verificamos que tengamos Docker Compose, sino es el caso entonces descargamos Docker Compose

	if command -v docker-compose &>/dev/null || docker compose version &>/dev/null; then
    		echo "Docker Compose está instalado."
	else
		
		curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

	fi

#Creamos el grupo docker

groupadd docker

#Descargamos Vim

apt install vim -y

#Descargamos mc

apt install mc -y

#Descargamos net-tools

apt install net-tools -y

#Añadimos el user 'nginx' y lo agregamos al grupo docker

adduser --quiet --disabled-password --gecos "" nginx && echo nginx:nginx | chpasswd && sudo usermod -aG docker nginx && newgrp docker

#EXTRA
#Descargamos el repo en .zip desde mi GitHub para poder ejecutar mi docker-compose

mkdir -p /home/nginx

wget -P /home/nginx https://github.com/Nataa19/my-app/archive/refs/heads/main.zip

cd /home/nginx && unzip main.zip

#Descargamos el cliente DUC para NO-IP para poder ejecutar el contenedor con la DNS

wget -P /home/nginx --content-disposition https://www.noip.com/download/linux/latest

cd /home/nginx && tar xf noip-duc_3.3.0.tar.gz

cd noip-duc_3.3.0/binaries && sudo apt install ./noip-duc_3.3.0_amd64.deb

chmod 777 /home/nginx/main.zip
chmod -R 777 /home/nginx/my-app-main
chmod 777 /home/nginx/noip-duc_3.3.0.tar.gz
chmod -R 777 /home/nginx/noip-duc_3.3.0

echo noip-duc -g all.ddnskey.com --username pzvfdr6 --password wcd8dNYoLeqD > /home/nginx/initduc.txt 

