¡Bienvenido!

Tener en cuenta que si precisas ver el tutorial con complemento gráfico (screenshots) visita el ['README.pdf'](https://github.com/Nataa19/my-app/blob/main/README.pdf).
También tenemos que tener en cuenta que el script se ejecuta SOLO bajo condición de usuario root. Esto es aclarado antes de ejecutarlo en terminal si no eres usuario root.

Para este proyecto se utiliza:
    
    * Digital Ocean como Host IP
    * SO Ubuntu 24.04 LTS
    * Scripting Bash
    * Docker y Docker Compose
    * No-IP como DNS free
    * Nginx como Server Proxy
    * Let´s Encrypt para generar certificados SSL free
    * Un proyecto de web HTML sencillo

1. Levantar una VM con ubuntu server.    

a. Para crear una VM con ubuntu server lo primero que debemos de hacer es ir a la sección **"Droplets"** del menú lateral izquierdo. En esta misma sección seleccionaremos el botón a la derecha que nos dice **"Create Droplet”**.

b. Seleccionamos la región y un **Datacenter**, en este caso existen 3 y seleccione **Datacenter 1**.

c. Elegimos la imagen del Sistema Operativo y la versión del mismo, en mi caso elegir una Ubuntu LTS para mejor funcionamiento y mitigar posibles errores.

d. Seleccionamos el plan y la CPU Options, donde especifica la cantidad de RAM y núcleos de procesador nos van a otorgar.

e. Lo que sigue es configurar el método de Autenticación, en mi caso configure una **SSH Key** que ya previamente tenía generada en mi Ubuntu `/home/.ssh`

f. Por último, le asignamos un nombre al Droplet, lo asociamos a un proyecto y podemos crear la VM.

2. Configurar la VM con un script escrito en bash para que el mismo se pueda reutilizar: 

    1. Configurar la zona horaria en Argentina.

    Lo primero es setear la configuración de la zona horaria a la local Argentina:
    
    -Tambien se agrega una validación para chequear la configuración actual de la zona horaria, si es la que precisamos dará un mensaje `echo` Zona horaria ya configurada, sino ejecuta el comando: 

  `timedatectl set-timezone America/Argentina/Cordoba` 
    
 2. Configurar el nombre del host como **“bootcampwebexperto”**.

  `echo bootcampwebexperto > /etc/hostname`

 3. Crear un usuario sudo que se llame webexperto.

  `adduser webexperto && sudo usermod -aG sudo webexperto`

 4. Crear un usuario para conectarse vía ssh.

  `adduser --disabled-password --gecos "" userssh`

 5. Que actualice las dependencias.

  `apt -qq update && sudo apt -qq upgrade -y`
  
  Con `--qq` lo ejecutamos de manera silence.

 6. Validar si está instalado docker y sino instalarlo.
    
    -La validación de Docker se ejecuta mediante una sentencia if-else dónde detectamos si el comando `docker` existe, si es asi arroja un `echo` diciendo "Docker está instalado." sino instala varios paquetes desde un `curl`.

 7. Validar si está instalado docker-compose y sino instalarlo.
    
    -Con Docker Compose hacemos el mismo paso de validación pero con su respectivo comando y para descargarlo también aplicamos `curl` a su repositorio de GitHub.

 8. Crear grupo docker e iniciar el servicio.
  
  `Añadimos el grupo de docker 'groupadd docker`

 9. Instalar mc.

  Instalamos Midnight Comander y aceptamos todo `apt install mc -y`

 10. Instalar vim.
    
    -Mismo proceso que mc

 11. Instalar net-tools.
    
    -Para Net-Tools el mismo proceso:
   
  `apt install net-tools -y`

 12. Crear un usuario nginx, le asignamos de password el mismo name de user y dar permisos de docker.
    
  - Añadimos un usuario Nginx suprimiendo la contraseña y en la misma ejecución añadiendolo al grupo de Docker para que pueda ejecutar sus comandos.

    ##EXTRA
    #Descargamos el repo en .zip desde mi GitHub para poder ejecutar mi `docker-compose`

  `wget -P /home/nginx https://github.com/Nataa19/my-app/archive/refs/heads/main.zip`

    #Descargamos el cliente DUC para NO-IP para poder ejecutar el contenedor con la DNS

  `wget -P /home/nginx --content-disposition https://www.noip.com/download/linux/latest`



Al reiniciar el Droplet ahora tenemos que loguearnos via ssh con el usuario permitido para la misma conexión, el “userssh”.

Cuando ingresemos a la home correspondiente del usuario, veremos 5 archivos.

    * main.zip
    * my-app-main
    * noip-duc_3.3.0.tar.gz
    * noip-duc_3.3.0

Esto se debe a que descargamos de mi propio GitHub el repo con todo el contenido necesario para runnear la web ‘main.zip’. 
Además de eso nos va a descargar el comprimido para instalar el DUC (Dynamic Update Client) ‘noip-duc_3.3.0.tar.gz’ que nos solicita No-IP para generar la asociación del DNS con el Droplet y su IP.

###Docker Compose

Ahora vamos a entrar en el proceso de creación y ejecución del docker-compose definido para este proyecto.

Primeramente tenemos que cambiar de usuario durante la sesión del actual “userssh”, por “nginx”. Este último es quien tiene los permisos del grupo docker, es decir es quien puede ejecutar los comandos del binario de `dockerd`.

Para la creación del compose nos basamos en un repositorio de GitHub de PeladoNerd. En el mismo tenemos como servicios un sitio web estático, un generador de certificados ssl y un servidor proxy.

Este archivo compose.yml configura un proxy inverso Nginx (nginx-proxy) que gestiona el tráfico HTTP y HTTPS. Utiliza un compañero (letsencrypt) para obtener y renovar automáticamente certificados SSL/TLS para tu dominio (nataec.ddns.net). El servicio www contiene la aplicación web real (en este caso, un servidor Nginx sirviendo contenido desde ./sitio1) y está configurado para ser accesible a través del proxy utilizando las variables de entorno VIRTUAL_HOST y LETSENCRYPT_HOST. Las dependencias aseguran que los servicios se inicien en el orden correcto. Los volúmenes se utilizan para compartir la configuración de Nginx, los certificados SSL/TLS, los archivos del sitio web y el socket de Docker entre los contenedores y el host.


#####En el archivo 'README.pdf' tenemos una explicación detallada de todo el compose###

Por último tendremos que hacer un `curl -I nataec.ddns.net` para recibir el status de redireccionamiento de **http>https**. Sino podemos visitar el sitio
Otra verificacion que podemos realizar es resolver el DNS con `nslookup nataec.ddns.net`.

