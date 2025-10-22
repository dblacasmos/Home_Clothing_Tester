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
    <title>Favoritos Usuarios</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>FAVORITOS DE USUARIOS</h2>

        <?php
        $sql = "SELECT
                    ID_USUARIO,
                    NOMBRE_USUARIO,
                    ID_PRENDA,
                    NOMBRE_PRENDA,
                    FECHA_ADD
                FROM view_favoritos_usuario";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>ID USUARIO</th>
                    <th>NOMBRE</th>
                    <th>ID PRENDA</th>
                    <th>PRENDA</th>
                    <th>FECHA ADD</th>
                </tr> 
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['ID_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['FECHA_ADD']) ?></td>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>