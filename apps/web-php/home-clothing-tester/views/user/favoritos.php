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
    <title>Mis Favoritos</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_user.php'; ?>
    </div>

    <?php
    $id_usuario = $_SESSION['id_usuario'];

    $sql = "SELECT
             f.ID_FAVORITO AS NUM_FAV,
             p.NOMBRE AS NOMBRE_PRENDA,
             p.DESCRIPCION,
             p.PRECIO,
             p.TALLA,
             p.COLOR,
             /* Concatena texto para generar una URL de imagen con el ID de la prenda,
              formando una ruta completa al archivo .jpg. */
             CONCAT('/home-clothing-tester/assets/images/prendas/',
             p.ID_PRENDA, '.jpg') AS Imagen
        FROM favorito f
        INNER JOIN prenda p ON f.ID_PRENDA = p.ID_PRENDA
        WHERE f.ID_USUARIO = ?";

    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        die("Error en prepare: " . $conn->error);
    }

    $stmt->bind_param("i", $id_usuario);
    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <main>
        <h2>MIS FAVORITOS</h2>
        <table>
            <thead>
                <tr>
                    <th>NUM FAVORITO</th>
                    <th>NOMBRE</th>
                    <th>DESCRIPCION</th>
                    <th>TALLA</th>
                    <th>COLOR</th>
                    <th>PRECIO</th>
                    <th>IMAGEN</th>
                    <th>ELIMINAR</th>
                </tr>
            </thead>
            <tbody>

                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['NUM_FAV']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['DESCRIPCION']) ?></td>
                        <td><?= htmlspecialchars($row['TALLA']) ?></td>
                        <td><?= htmlspecialchars($row['COLOR']) ?></td>
                        <td><?= htmlspecialchars($row['PRECIO']) ?>€</td>
                        <td><img src="<?= $row['Imagen'] ?>" alt="Imagen de <?= $row['NOMBRE_PRENDA'] ?>" width="60"></td>
                        <td>
                            <form action="../../controllers/user/eliminar_favorito.php" method="POST" onsubmit="return confirm('¿Estás seguro de que deseas eliminar este favorito?');">
                                <input type="hidden" name="id_favorito" value="<?= $row['NUM_FAV'] ?>">
                                <button type="submit" class="eliminar-btn">❌</button>
                            </form>
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