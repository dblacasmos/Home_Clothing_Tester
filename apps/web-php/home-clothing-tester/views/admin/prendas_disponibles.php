<?php
session_start();
require_once '../../config/conexion.php';

// Verificar login Usuario con rol admin
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'admin') {
    header("Location: ../comunes/index.php");
    exit;
}

include '../../includes/header.php';
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Prendas Disponibles</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>PRENDAS DISPONIBLES</h2>

        <?php
        $sql = "SELECT
                    ID_PRENDA,
                    NOMBRE,
                    DESCRIPCION,
                    PRECIO,
                    TALLA,
                    COLOR,
                    STOCKDISPONIBLE,
                    ESTADO_PRENDA,
                    NOMBRE_CATEGORIA
                FROM view_prendas_disponibles";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>ID PRENDA</th>
                    <th>NOMBRE</th>
                    <th>DESCRIPCION</th>
                    <th>PRECIO</th>
                    <th>TALLA</th>
                    <th>COLOR</th>
                    <th>STOCKDISPONIBLE</th>
                    <th>ESTADO</th>
                    <th>CATEGORIA</th>
                </tr> 
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE']) ?></td>
                        <td><?= htmlspecialchars($row['DESCRIPCION']) ?></td>
                        <td><?= htmlspecialchars($row['PRECIO']) ?></td>
                        <td><?= htmlspecialchars($row['TALLA']) ?></td>
                        <td><?= htmlspecialchars($row['COLOR']) ?></td>
                        <td><?= htmlspecialchars($row['STOCKDISPONIBLE']) ?></td>
                        <td><?= htmlspecialchars($row['ESTADO_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_CATEGORIA']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>