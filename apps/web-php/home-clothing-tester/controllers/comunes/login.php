<?php
session_start();
require_once '../../config/conexion.php';

// Recoge los datos enviados desde un formulario (por método POST)
// Si no se recibe nada, se guarda un string vacío ''
$correo = trim($_POST['correo_usuario'] ?? '');
$password = trim($_POST['password'] ?? '');

// Prepara una consulta para buscar al usuario con ese correo y contraseña
// También verifica si el usuario es administrador usando LEFT JOIN
$sql = "SELECT u.ID_USUARIO, u.CORREO_USUARIO, u.PASSWORD, u.ID_ADMIN, a.ID_ADMIN AS ES_ADMIN
        FROM usuario u 
        LEFT JOIN administrador a ON u.ID_ADMIN = a.ID_ADMIN
        WHERE u.CORREO_USUARIO = ? AND u.PASSWORD = ?";

// Prepara la consulta con seguridad (para evitar inyecciones SQL)
$stmt = $conn->prepare($sql);

if (!$stmt) {

// Si algo falla al preparar la consulta, termina el script y muestra un error
    die("Error en prepare(): " . $conn->error);
}

// Enlaza los valores del correo y contraseña en la consulta preparada
$stmt->bind_param("ss", $correo, $password);
$stmt->execute();

// Obtiene el resultado de la consulta
$result = $stmt->get_result();

if ($result->num_rows === 1) {

     // Extrae los datos del usuario como un array que se asocia
    $usuario = $result->fetch_assoc();

    // Guarda información del usuario en variables de sesión
    $_SESSION['id_usuario'] = $usuario['ID_USUARIO'];
    $_SESSION['correo'] = $usuario['CORREO_USUARIO'];

    // Si el campo ES_ADMIN tiene valor, lo marca como admin, si no, como usuario
    $_SESSION['rol'] = ($usuario['ES_ADMIN']) ? 'admin' : 'usuario';

    header('Location: ../../views/comunes/index.php');
    exit;
} else {
    // Guardar mensaje de error para mostrar en index
    $_SESSION['login_error'] = 'Usuario o contraseña incorrectos.';

    // Redirige a la página de inicio
    header('Location: ../../views/comunes/index.php');
    exit;
}
