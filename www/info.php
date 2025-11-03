<?php
// Establecer la zona horaria (puedes cambiarla si estás en otro país)
date_default_timezone_set('America/Bogota');

// Obtener la fecha y hora actual
$fecha = date("d/m/Y");
$hora = date("H:i:s");

// Mostrar información dinámica
echo "<h1>¡Hola desde tu servidor Vagrant! 👋</h1>";
echo "<p>Hoy es <strong>$fecha</strong> y la hora actual es <strong>$hora</strong>.</p>";
?>
