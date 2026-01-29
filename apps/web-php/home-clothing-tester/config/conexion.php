<?php
// Use environment variables with fallbacks for local development
$host = getenv('DB_HOST') ?: 'localhost';
$usuario = getenv('DB_USER') ?: 'root';
$password = getenv('DB_PASS') ?: '';
$bd = getenv('DB_NAME') ?: 'home_clothing_tester';
$port = getenv('DB_PORT') ?: 3306;

$conn = new mysqli($host, $usuario, $password, $bd, (int)$port);

// Set charset to prevent encoding issues
if (!$conn->connect_error) {
    $conn->set_charset('utf8mb4');
}

// Handle connection errors gracefully
if ($conn->connect_error) {
    error_log("Database connection failed: " . $conn->connect_error);
    if (getenv('APP_ENV') === 'development') {
        die("Error de conexión: " . $conn->connect_error);
    } else {
        die("Error de conexión a la base de datos. Contacte al administrador.");
    }
}