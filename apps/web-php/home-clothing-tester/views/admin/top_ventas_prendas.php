<?php
session_start();
require_once '../../config/conexion.php';

// Verificar login Usuario con rol admin
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'admin') {
    header("Location: /index.php");
    exit;
}

include '../../includes/header.php';
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Top Ventas Prendas</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>RANKING PRENDAS VENDIDAS</h2>

        <?php
        $sql = "SELECT
                    ID_PRENDA,
                    NOMBRE,
                    UNIDADES_VENDIDAS,
                    IMPORTE_TOTAL
                FROM view_ranking_prendas_vendidas";

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
                    <th>UNIDADES VENDIDAS</th>
                    <th>IMPORTE TOTAL</th>
                </tr> 
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE']) ?></td>
                        <td><?= htmlspecialchars($row['UNIDADES_VENDIDAS']) ?></td>
                        <td><?= htmlspecialchars($row['IMPORTE_TOTAL']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>