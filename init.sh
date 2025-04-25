#!/bin/bash

#Descargamos el repo en .zip desde mi GitHub para poder ejecutar mi docker-compose

wget -P /home/nginx https://github.com/Nataa19/my-app/archive/refs/heads/main.zip

cd /home/nginx && unzip main.zip

#Descargamos el cliente DUC para NO-IP para poder ejecutar el contenedor con la DNS

wget -P /home/nginx --content-disposition https://www.noip.com/download/linux/latest

cd /home/nginx && tar xf noip-duc_3.3.0.tar.gz

cd noip-duc_3.3.0/binaries && sudo apt install ./noip-duc_3.3.0_amd64.deb
