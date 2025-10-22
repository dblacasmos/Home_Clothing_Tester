<?php
ob_start();                                  // Inicia el búfer de salida
session_start();                             // Inicia o continúa la sesión del usuario (permite usar $_SESSION)
require_once '../../config/conexion.php';    // Carga el archivo que conecta con la base de datos

// SOLO PARA ADMIN
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'admin') {

    // Si no hay sesión iniciada o no es admin, lo redirige a la página principal
    header("Location: ../../views/comunes/index.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Obtiene los datos enviados desde el formulario
    $id_usuario = $_POST['id_usuario'] ?? null;         // ID del usuario a modificar
    $nuevo_estado = $_POST['nuevo_estado'] ?? null;     // Estado nuevo a asignar (ej: ACTIVO)
    $id_admin = $_SESSION['id_usuario'];                // ID del admin que está haciendo el cambio

    // Valida que el estado sea válido
    $estados_validos = ['ACTIVO', 'INACTIVO', 'BLOQUEADO'];

    if ($id_usuario && in_array($nuevo_estado, $estados_validos)) {

        $stmt = $conn->prepare("CALL proc_cambiar_estado_usuario(?, ?, ?)");  // Llama a un procedimiento almacenado
        if (!$stmt) {
            die("❌ Error en prepare: " . $conn->error); // Muestra error si falla el prepare
        }

        $stmt->bind_param("isi", $id_usuario, $nuevo_estado, $id_admin); // Envía los parámetros (ID usuario, estado, ID admin)
        $stmt->execute();   // Ejecuta la consulta en la base de datos

        $stmt->close();     // Cierra la consulta
    } 
}

// Después de hacer el cambio, redirige a la lista de usuarios
header("Location: ../../views/admin/lista_usuarios.php");
exit;