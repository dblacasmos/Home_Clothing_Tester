<?php
session_start();
require_once '../../config/conexion.php';

// Solo permitir acceso si está logueado y tiene rol "usuario" o "admin"
if (!isset($_SESSION['id_usuario']) || $_SESSION['rol'] !== 'usuario' && $_SESSION['rol'] !== 'admin') {
    header("Location: index.php");
    exit;
}

include '../../includes/header.php'; 
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Estadisticas Comentarios</title>
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
                    ID_PRENDA AS NUM_PRENDA,
                    NOMBRE AS NOMBRE_PRENDA,
                    TOTAL_COMENTARIOS,
                    NOTA_MEDIA
                FROM view_estadisticas_comentarios";
        $stmt = $conn->prepare($sql);
    } else {
        $sql = "SELECT 
                    NOMBRE AS NOMBRE_PRENDA,
                    TOTAL_COMENTARIOS,
                    NOTA_MEDIA
                FROM view_estadisticas_comentarios;";
        $stmt = $conn->prepare($sql);
    }

    if (!$stmt) {
        die("Error en prepare: " . $conn->error);
    }

    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <main>
        <h2>ESTADISTICAS COMENTARIOS</h2>
        <table>
            <thead>
                <tr>
                    <?php if ($_SESSION['rol'] === 'admin') : ?>
                        <th>NUM PRENDA</th>
                    <?php endif; ?>
                    <th>NOMBRE</th>
                    <th>NUM COMENTARIOS</th>
                    <th>CALIFICACION MEDIA</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <?php if ($_SESSION['rol'] === 'admin') : ?>
                            <td><?= htmlspecialchars($row['NUM_PRENDA']) ?></td>
                        <?php endif; ?>
                        <td><?= htmlspecialchars($row['NOMBRE_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['TOTAL_COMENTARIOS']) ?></td>
                        <td>
                            <?php
                            $nota = floatval($row['NOTA_MEDIA']);
                            $porcentaje = ($nota / 5) * 100;
                            ?>
                            <div class="star-rating" style="--rating: <?= $porcentaje ?>%;" title="<?= number_format($nota, 2) ?> de 5"></div>
                        </td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>