<?php
date_default_timezone_set('America/Bogota');

// Datos de conexión (subred privada Vagrant)
$host = '192.168.56.3';  // IP de la VM db
$port = '5432';
$db   = 'appdb';
$user = 'appuser';
$pass = 'appPass123';

// Construir DSN y conectar con PDO
$dsn = "pgsql:host=$host;port=$port;dbname=$db;";

$fecha = date("d/m/Y");
$hora  = date("H:i:s");

echo "<h1>¡Hola desde tu servidor Vagrant!</h1>";
echo "<p>Hoy es <strong>$fecha</strong> y la hora actual es <strong>$hora</strong>.</p>";

try {
  $pdo = new PDO($dsn, $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  ]);

  $stmt = $pdo->query("SELECT id, nombre, precio FROM productos ORDER BY id;");
  $rows = $stmt->fetchAll();

  if (!$rows) {
    echo "<p>No hay productos cargados todavía.</p>";
  } else {
    echo "<h2>Productos</h2>";
    echo "<table border='1' cellpadding='6' cellspacing='0'>
            <tr><th>ID</th><th>Nombre</th><th>Precio</th></tr>";
    foreach ($rows as $r) {
      $id = htmlspecialchars($r['id']);
      $nombre = htmlspecialchars($r['nombre']);
      $precio = number_format((float)$r['precio'], 2, ',', '.');
      echo "<tr><td>$id</td><td>$nombre</td><td>$precio</td></tr>";
    }
    echo "</table>";
  }
} catch (PDOException $e) {
  echo "<p style='color:red'>Error de conexión o consulta: " . htmlspecialchars($e->getMessage()) . "</p>";
}