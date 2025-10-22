<?php
session_start();
require_once '../../config/conexion.php';

if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario') {
    header("Location: ../../views/comunes/index.php");
    exit;
}

// Elimina un favorito si llega un id válido por POST
if (isset($_POST['id_favorito'])) {
    $id_favorito = intval($_POST['id_favorito']);

    $stmt = $conn->prepare("DELETE FROM favorito WHERE ID_FAVORITO = ?");
    $stmt->bind_param("i", $id_favorito);

    // Si se elimina correctamente, redirige
    if ($stmt->execute()) {
        header("Location: favoritos.php");
        exit;
    } else {
        // // Si hay error, lo muestra
        die("Error al eliminar el favorito: " . $conn->error);
    }
} else {
    header("Location: ../../views/user/favoritos.php");
    exit;
}
