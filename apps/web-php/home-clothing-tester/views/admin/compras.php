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
    <title>Compras</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>LISTADO DE COMPRAS</h2>

        <?php
        $sql = "SELECT
                    ID_COMPRA,
                    ID_USUARIO,
                    ID_METODOPAGO,
                    ID_TRANSACCION,
                    FECHA_COMPRA,
                    TOTAL_COMPRA,
                    ESTADO_COMPRA
                FROM compra";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>NUM COMPRA</th>
                    <th>ID USUARIO</th>
                    <th>ID METODOPAGO</th>
                    <th>ID TRANSACCION</th>
                    <th>FECHA</th>
                    <th>TOTAL</th>
                    <th>ESTADO</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_COMPRA']) ?></td>
                        <td><?= htmlspecialchars($row['ID_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['ID_METODOPAGO']) ?></td>
                        <td><?= htmlspecialchars($row['ID_TRANSACCION']) ?></td>
                        <td><?= htmlspecialchars($row['FECHA_COMPRA']) ?></td>
                        <td><?= htmlspecialchars($row['TOTAL_COMPRA']) ?></td>
                        <td><?= htmlspecialchars($row['ESTADO_COMPRA']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>