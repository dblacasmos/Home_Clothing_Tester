<?php
session_start();
require_once '../../config/conexion.php';

// Solo permitir acceso si está logueado y tiene rol "usuario" o "admin"
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario' && $_SESSION['rol'] !== 'admin') {
    header("Location: index.php");
    exit;
}

include '../../includes/header.php'; ?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Historial Compras</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php
        if ($_SESSION['rol'] === 'admin') {
            include '../../includes/nav/nav_admin.php';
        } else {
            include '../../includes/nav/nav_user.php';
        }
        ?>
    </div>

    <?php
    $id_usuario = $_SESSION['id_usuario'];

    if ($_SESSION['rol'] === 'admin') {
        $sql = "SELECT 
                    c.ID_COMPRA AS NUM_COMPRA,
                    u.NOMBRE_USUARIO,
                    c.FECHA_COMPRA,
                    c.TOTAL_COMPRA,
                    m.FORMA_PAGO,
                    s.ESTADO_TRANSACCION
                FROM compra c
                JOIN usuario u ON c.ID_USUARIO = u.ID_USUARIO
                JOIN metodopago m ON c.ID_METODOPAGO = m.ID_METODOPAGO
                JOIN sistemapago s ON c.ID_TRANSACCION = s.ID_TRANSACCION";
        $stmt = $conn->prepare($sql);
    } else {
        $sql = "SELECT 
                    c.ID_COMPRA AS NUM_COMPRA,
                    c.FECHA_COMPRA,
                    c.TOTAL_COMPRA,
                    m.FORMA_PAGO,
                    s.ESTADO_TRANSACCION
                FROM compra c
                JOIN metodopago m ON c.ID_METODOPAGO = m.ID_METODOPAGO
                JOIN sistemapago s ON c.ID_TRANSACCION = s.ID_TRANSACCION
                WHERE c.ID_USUARIO = ?";
        $stmt = $conn->prepare($sql);

        if (!$stmt) {
            die("Error en prepare: " . $conn->error);
        }
        $stmt->bind_param("i", $id_usuario);
    }

    if (!$stmt) {
        die("Error en prepare: " . $conn->error);
    }

    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <main>
        <h2>HISTORIAL DE COMPRAS</h2>
        <table>
            <thead>
                <tr>
                    <th>NUM COMPRA</th>
                    <?php if ($_SESSION['rol'] === 'admin') : ?>
                        <th>USUARIO</th>
                    <?php endif; ?>
                    <th>FECHA</th>
                    <th>TOTAL</th>
                    <th>FORMA PAGO</th>
                    <th>ESTADO TRANSACCION</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['NUM_COMPRA']) ?></td>
                        <?php if ($_SESSION['rol'] === 'admin') : ?>
                            <td><?= htmlspecialchars($row['NOMBRE_USUARIO']) ?></td>
                        <?php endif; ?>
                        <td><?= htmlspecialchars($row['FECHA_COMPRA']) ?></td>
                        <td><?= htmlspecialchars($row['TOTAL_COMPRA']) ?> €</td>
                        <td><?= htmlspecialchars($row['FORMA_PAGO']) ?></td>
                        <td><?= htmlspecialchars($row['ESTADO_TRANSACCION']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>