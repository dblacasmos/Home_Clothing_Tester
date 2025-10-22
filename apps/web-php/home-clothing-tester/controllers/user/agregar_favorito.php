<?php
session_start();
require_once '../../config/conexion.php';

// Si no hay sesión iniciada o el rol no es "usuario", redirige al inicio
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario') {
    header("Location: ../../views/comunes/index.php");
    exit;
}

//  Si llega un formulario por POST y tiene una prenda
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id_prenda'])) {
    $id_usuario = $_SESSION['id_usuario'];      // ID del usuario que inició sesión
    $id_prenda = intval($_POST['id_prenda']);   // ID de la prenda que se va a guardar

    // Verifica si ya está en favoritos
    $check_sql = "SELECT 1 FROM favorito WHERE ID_USUARIO = ? AND ID_PRENDA = ?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->bind_param("ii", $id_usuario, $id_prenda);
    $check_stmt->execute();
    $check_stmt->store_result();

    // Si no está, la agrega
    if ($check_stmt->num_rows === 0) {
        // No está, insertamos
        $insert_sql = "INSERT INTO favorito (ID_USUARIO, ID_PRENDA) VALUES (?, ?)";
        $insert_stmt = $conn->prepare($insert_sql);
        $insert_stmt->bind_param("ii", $id_usuario, $id_prenda);
        $insert_stmt->execute();
        $insert_stmt->close();
    }

    $check_stmt->close();
}

// Redirecciona al catálogo nuevamente
header("Location: ../../views/comunes/catalogo.php");
exit;
