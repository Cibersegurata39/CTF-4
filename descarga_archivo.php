<?php
//URL del archivo a descargar (localizado en la otra maquina)
$url = 'http://10.0.2.15:8080/chisel';
//Ruta donde guardar el arhcivo (en mi maquina)
$destino = '/tmp/chisel';
//Descarga del archivo
$contenido = file_get_contents($url);
if ($contenido === FALSE) {
        echo 'Error';
} else {
        //Guardado
        file_put_contents($destino, $contenido);
        echo ‘Guardado’;
}
?> 
