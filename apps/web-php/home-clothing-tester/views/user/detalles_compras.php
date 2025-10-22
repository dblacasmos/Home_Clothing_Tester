<?php
session_start();
require_once '../../config/conexion.php';

// Solo permitir acceso si está logueado y tiene rol "usuario"
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario') {
    header("Location: ../comunes/index.php");
    exit;
}

include '../../includes/header.php'; ?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Detalles de Compra</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_user.php'; ?>
    </div>

    <?php
    $id_usuario = $_SESSION['id_usuario'];

    $sql = "SELECT
             dc.ID_DETALLECOMPRA AS DETALLES_COMPRA,
             dc.CANTIDAD,
             dc.PRECIO_UNIDAD,
             dc.SUBTOTAL,
             p.NOMBRE AS NOMBRE_PRENDA,
             CONCAT('/home-clothing-tester/assets/images/prendas/',
             p.ID_PRENDA, '.jpg') AS Imagen
        FROM detallecompra dc
        INNER JOIN compra c ON dc.ID_COMPRA = c.ID_COMPRA
        INNER JOIN prenda p ON dc.ID_PRENDA = p.ID_PRENDA
        WHERE c.ID_USUARIO = ?";

    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        die("Error en prepare: " . $conn->error);
    }

    $stmt->bind_param("i", $id_usuario);
    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <main>
        <h2>DETALLES DE COMPRA</h2>
        <table>
            <thead>
                <tr>
                    <th>DETALLE COMPRA</th>
                    <th>PRENDA</th>
                    <th>CANTIDAD</th>
                    <th>PRECIO UNIDAD</th>
                    <th>SUBTOTAL</th>
                    <th>IMAGEN</th>
                </tr>
            </thead>
            <tbody>

                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['DETALLES_COMPRA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['CANTIDAD']) ?></td>
                        <td><?= number_format($row['PRECIO_UNIDAD'], 2) ?> €</td>
                        <td><?= number_format($row['SUBTOTAL'], 2) ?> €</td>
                        <td><img src="<?= $row['Imagen'] ?>" alt="Imagen de <?= $row['NOMBRE_PRENDA'] ?>" width="60"></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>