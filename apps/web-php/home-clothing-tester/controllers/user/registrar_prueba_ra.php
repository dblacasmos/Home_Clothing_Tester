<?php
session_start();
require_once '../../config/conexion.php';

// // Indica que el contenido que se devolverá es de tipo JSON
header('Content-Type: application/json');

// Leer los datos enviados desde JavaScript (formato JSON)
$data = json_decode(file_get_contents('php://input'), true);

// Extraer y validar los datos recibidos
$id_usuario = isset($data['id_usuario']) ? intval($data['id_usuario']) : 0;
$id_prenda = isset($data['id_prenda']) ? trim($data['id_prenda']) : '';
$resultado = isset($data['resultado']) ? trim($data['resultado']) : '';

// Prepara la respuesta base
$response = ['success' => false];

// Validar que los datos estén completos y sean válidos
if ($id_usuario > 0 && $id_prenda !== '' && $resultado !== '') {

    // Ejecutar el INSERT en la base de datos
    $sql = "INSERT INTO sistema_ra (ID_USUARIO, ID_PRENDA, RESULTADO) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        $stmt->bind_param("iss", $id_usuario, $id_prenda, $resultado);
        if ($stmt->execute()) {
            $response['success'] = true;

        // Mostrar mensaje de error
        } else {
            $response['error'] = '❌ Error al ejecutar consulta: ' . $stmt->error;
        }
        $stmt->close();
    } else {
        $response['error'] = '❌ Error en prepare(): ' . $conn->error;
    }
} else {
    $response['error'] = '❌ Datos incompletos para registrar la prueba.';
}

// Devolver la respuesta en formato JSON
echo json_encode($response);