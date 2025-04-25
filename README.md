¡Bienvenido!

Tener en cuenta que si precisas ver el tutorial con complemento gráfico (screenshots) visita el 'README.pdf'.
También tenemos que tener en cuenta que el script se ejecuta SOLO bajo condición de usuario root. Esto es aclarado antes de ejecutarlo en terminal si no eres usuario root.

1. Levantar una VM con ubuntu server.    

a. Para crear una VM con ubuntu server lo primero que debemos de hacer es ir a la sección "Droplets" del menú lateral izquierdo. En esta misma sección seleccionaremos el botón a la derecha que nos dice "Create Droplet”.

b. Seleccionamos la región y un Datacenter, en este caso existen 3 y seleccione Datacenter 1.

c. Elegimos la imagen del Sistema Operativo y la versión del mismo, en mi caso elegir una Ubuntu LTS para mejor funcionamiento y mitigar posibles errores.

d. Seleccionamos el plan y la CPU Options, donde especifica la cantidad de RAM y núcleos de procesador nos van a otorgar.

e. Lo que sigue es configurar el método de Autenticación, en mi caso configure una SSH Key que ya previamente tenía generada en mi Ubuntu /home/.ssh

f. Por último, le asignamos un nombre al Droplet, lo asociamos a un proyecto y podemos crear la VM.

2. Configurar la VM con un script escrito en bash para que el mismo se pueda reutilizar: 
    1. Configurar la zona horaria en Argentina.

    Lo primero es setear la configuración de la zona horaria a la local Argentina:
    -Tambien se agrega una validación para chequear la configuración actual de la zona horaria, si es la que precisamos dará un mensaje 'echo' "Zona horaria ya configurada" sino ejecuta el comando: timedatectl set-timezone America/Argentina/Cordoba 
    
    2. Configurar el nombre del host como “bootcampwebexperto”.

    -'echo bootcampwebexperto > /etc/hostname'

    3. Crear un usuario sudo que se llame webexperto.
    -'adduser webexperto && sudo usermod -aG sudo webexperto'

    4. Crear un usuario para conectarse vía ssh.
    -'adduser --disabled-password --gecos "" userssh'

    5. Que actualice las dependencias.
    -'apt -qq update && sudo apt -qq upgrade -y'. Con "--qq" lo ejecutamos de manera silence.

    6. Validar si está instalado docker y sino instalarlo.
    -La validación de Docker se ejecuta mediante una sentencia if-else dónde detectamos si el comando 'docker' existe, si es asi arroja un 'echo' diciendo "Docker está instalado." sino instala varios paquetes desde un 'curl'.

    7. Validar si está instalado docker-compose y sino instalarlo.
    -Con Docker Compose hacemos el mismo paso de validación pero con su respectivo comando y para descargarlo también aplicamos 'curl' a su repositorio de GitHub.

    8. Crear grupo docker e iniciar el servicio.
    -Añadimos el grupo de docker 'groupadd docker'.

    9. Instalar mc.
    -Instalamos Midnight Comander y aceptamos todo 'apt install mc -y'.

    10. Instalar vim.
    -Mismo proceso que mc.

    11. Instalar net-tools.
    -Para Net-Tools el mismo proceso 'apt install net-tools -y'.

    12. Crear un usuario nginx y dar permisos de docker.
    - Añadimos un usuario Nginx suprimiendo la contraseña y en la misma ejecución añadiendolo al grupo de Docker para que pueda ejecutar sus comandos.

