<?php
session_start();
require_once __DIR__ . '/../../config/conexion.php';

if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario') {
    header("Location: /");
    exit;
}

// Security: verify the favorite belongs to the logged-in user
if (isset($_POST['id_favorito'])) {
    $id_favorito = intval($_POST['id_favorito']);
    $id_usuario = $_SESSION['id_usuario'];

    // Only delete if the favorite belongs to this user
    $stmt = $conn->prepare("DELETE FROM favorito WHERE ID_FAVORITO = ? AND ID_USUARIO = ?");
    $stmt->bind_param("ii", $id_favorito, $id_usuario);

    if ($stmt->execute()) {
        header("Location: /views/comunes/catalogo_prendas.php");
        exit;
    } else {
        error_log("Error deleting favorite: " . $conn->error);
        header("Location: /views/comunes/catalogo_prendas.php");
        exit;
    }
} else {
    header("Location: /views/user/favoritos.php");
    exit;
}
