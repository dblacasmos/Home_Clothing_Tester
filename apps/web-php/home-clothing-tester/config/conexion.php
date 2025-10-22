<?php
$host = "localhost";            // Dirección del servidor MySQL (localhost = mismo equipo)
$usuario = "root";              // Usuario de la base de datos
$password = "";                 // Contraseña del usuario (vacía en este caso)
$bd = "home_clothing_tester";   // Nombre de la base de datos a la que se quiere conectar

$conn = new mysqli($host, $usuario, $password, $bd);

//Verificar si hubo error
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}