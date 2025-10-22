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
    <title>Top Ventas Categorías</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>RANKING CATEGORIAS VENDIDAS</h2>

        <?php
        $sql = "SELECT
                    ID_CATEGORIA,
                    NOMBRE_CATEGORIA,
                    UNIDADES_VENDIDAS,
                    INGRESOS_TOTALES
                FROM view_ventas_por_categoria";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>ID CATEGORIA</th>
                    <th>NOMBRE CATEGORIA</th>
                    <th>UNIDADES VENDIDAS</th>
                    <th>INGRESOS TOTALES</th>
                </tr> 
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_CATEGORIA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_CATEGORIA']) ?></td>
                        <td><?= htmlspecialchars($row['UNIDADES_VENDIDAS']) ?></td>
                        <td><?= htmlspecialchars($row['INGRESOS_TOTALES']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>