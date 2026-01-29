<?php
require_once __DIR__ . '/../config/conexion.php';



//  Consulta SQL: obtener prendas del catálogo
// Note: Image paths use absolute URL from document root
$sql = "SELECT
    ID_PRENDA AS id,
    NOMBRE AS nombre,
    PRECIO AS precio,
    CONCAT('/assets/images/prendas/', ID_PRENDA, '.jpg') AS imagen
FROM view_catalogo_prendas
LIMIT 10";

//  Inicializa un array para guardar los resultados
$ropa = [];

// Ejecuta la consulta y guarda los resultados
if ($stmt = $conn->prepare($sql)) {
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $ropa[] = $row;
        }
    }
    $stmt->close();
} else {
    // // Si falla, guarda el error en el log
    error_log("Error en la consulta de prendas: " . $conn->error);
}
