<?php
session_start();
require_once __DIR__ . '/../../config/conexion.php';

// Recoge los datos enviados desde un formulario (por método POST)
$correo = trim($_POST['correo_usuario'] ?? '');
$password = trim($_POST['password'] ?? '');

// Validate input
if (empty($correo) || empty($password)) {
    $_SESSION['login_error'] = 'Por favor, complete todos los campos.';
    header('Location: /');
    exit;
}

// Prepara una consulta para buscar al usuario con ese correo y contraseña
$sql = "SELECT u.ID_USUARIO, u.CORREO_USUARIO, u.PASSWORD, u.ESTADO, u.ID_ADMIN, a.ID_ADMIN AS ES_ADMIN
        FROM usuario u
        LEFT JOIN administrador a ON u.ID_ADMIN = a.ID_ADMIN
        WHERE u.CORREO_USUARIO = ? AND u.PASSWORD = ?";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    error_log("Login prepare error: " . $conn->error);
    $_SESSION['login_error'] = 'Error del servidor. Intente más tarde.';
    header('Location: /');
    exit;
}

$stmt->bind_param("ss", $correo, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $usuario = $result->fetch_assoc();

    // Check if user is blocked
    if ($usuario['ESTADO'] === 'BLOQUEADO') {
        $_SESSION['login_error'] = 'Su cuenta ha sido bloqueada. Contacte al administrador.';
        header('Location: /');
        exit;
    }

    // Check if user is inactive
    if ($usuario['ESTADO'] === 'INACTIVO') {
        $_SESSION['login_error'] = 'Su cuenta está inactiva.';
        header('Location: /');
        exit;
    }

    // Regenerate session ID to prevent session fixation
    session_regenerate_id(true);

    $_SESSION['id_usuario'] = $usuario['ID_USUARIO'];
    $_SESSION['correo'] = $usuario['CORREO_USUARIO'];
    $_SESSION['rol'] = ($usuario['ES_ADMIN']) ? 'admin' : 'usuario';

    header('Location: /');
    exit;
} else {
    $_SESSION['login_error'] = 'Usuario o contraseña incorrectos.';
    header('Location: /');
    exit;
}

$stmt->close();
