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
    <title>Pruebas Virtuales</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>PRUEBAS VIRTUALES</h2>

        <?php
        $sql = "SELECT
                    sra.ID_SISTEMARA,
                    u.CORREO_USUARIO,
                    p.NOMBRE AS NOMBRE_PRENDA,
                    p.COLOR,
                    sra.FECHA,
                    sra.RESULTADO
                FROM sistema_ra sra
                JOIN usuario u ON u.ID_USUARIO = sra.ID_USUARIO
                JOIN prenda p ON p.ID_PRENDA = sra.ID_PRENDA";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>ID PRUEBA VIRTUAL</th>
                    <th>CORREO</th>
                    <th>NOMBRE PRENDA</th>
                    <th>COLOR</th>
                    <th>FECHA</th>
                    <th>RESULTADO</th>
                </tr> 
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_SISTEMARA']) ?></td>
                        <td><?= htmlspecialchars($row['CORREO_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['COLOR']) ?></td>
                        <td><?= htmlspecialchars($row['FECHA']) ?></td>
                        <td><?= htmlspecialchars($row['RESULTADO']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>