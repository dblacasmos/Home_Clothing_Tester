<?php
session_start();
require_once '../../config/conexion.php';

$id_usuario = $_SESSION['id_usuario'] ?? null;
$rol = $_SESSION['rol'] ?? null;

include '../../includes/header.php';
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Catálogo de Prendas</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">
</head>

<body>
    <div id="sidebarMenu" class="sidebar-menu">
        <?php
        if (!isset($rol)) {
            include '../../includes/nav/nav.php';
        } elseif ($rol === 'admin') {
            include '../../includes/nav/nav_admin.php';
        } elseif ($rol === 'usuario') {
            include '../../includes/nav/nav_user.php';
        }
        ?>
    </div>

    <?php
    if ($rol === 'admin') {
        $sql = "SELECT ID_PRENDA AS NUM_PRENDA, NOMBRE, DESCRIPCION, PRECIO, TALLA, COLOR, STOCKDISPONIBLE, ESTADO_PRENDA, NOMBRE_CATEGORIA, CREADO_POR,
                CONCAT('/home-clothing-tester/assets/images/prendas/', ID_PRENDA, '.jpg') AS Imagen
                FROM view_catalogo_prendas";
    } else {
        $sql = "SELECT ID_PRENDA AS NUM_PRENDA, NOMBRE, DESCRIPCION, PRECIO, TALLA, COLOR, NOMBRE_CATEGORIA,
                CONCAT('/home-clothing-tester/assets/images/prendas/', ID_PRENDA, '.jpg') AS Imagen
                FROM view_catalogo_prendas";
    }

    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <main>
        <h2>CATÁLOGO DE PRENDAS</h2>
        <table>
            <thead>
                <tr>
                    <th>NUMERO</th>
                    <th>NOMBRE</th>
                    <th>DESCRIPCIÓN</th>
                    <th>PRECIO</th>
                    <th>TALLA</th>
                    <th>COLOR</th>
                    <?php if ($rol === 'admin') : ?>
                        <th>STOCKDISPONIBLE</th>
                        <th>ESTADO</th>
                    <?php endif; ?>
                    <th>CATEGORÍA</th>
                    <?php if ($rol === 'admin') : ?>
                        <th>CREADO POR</th>
                    <?php endif; ?>
                    <th>IMAGEN</th>
                    <?php if ($rol === 'usuario') : ?>
                        <th>FAVORITOS</th>
                    <?php endif; ?>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <?php
                    $id_prenda = $row['NUM_PRENDA'];
                    $ya_es_favorito = false;
                    $id_favorito = null;

                    if ($rol === 'usuario' && $id_usuario) {
                        $check_sql = "SELECT ID_FAVORITO FROM favorito WHERE ID_USUARIO = ? AND ID_PRENDA = ?";
                        $check_stmt = $conn->prepare($check_sql);
                        $check_stmt->bind_param("ii", $id_usuario, $id_prenda);
                        $check_stmt->execute();
                        $check_result = $check_stmt->get_result();
                        if ($fav = $check_result->fetch_assoc()) {
                            $ya_es_favorito = true;
                            $id_favorito = $fav['ID_FAVORITO'];
                        }
                        $check_stmt->close();
                    }
                    ?>
                    <tr>
                        <td><?= htmlspecialchars($row['NUM_PRENDA']) ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE']) ?></td>
                        <td><?= htmlspecialchars($row['DESCRIPCION']) ?></td>
                        <td><?= htmlspecialchars($row['PRECIO']) ?> €</td>
                        <td><?= htmlspecialchars($row['TALLA']) ?></td>
                        <td><?= htmlspecialchars($row['COLOR']) ?></td>
                        <?php if ($rol === 'admin') : ?>
                            <td><?= htmlspecialchars($row['STOCKDISPONIBLE']) ?></td>
                            <td><?= htmlspecialchars($row['ESTADO_PRENDA']) ?></td>
                        <?php endif; ?>
                        <td><?= htmlspecialchars($row['NOMBRE_CATEGORIA']) ?></td>
                        <?php if ($rol === 'admin') : ?>
                            <td><?= htmlspecialchars($row['CREADO_POR']) ?></td>
                        <?php endif; ?>
                        <td><img src="<?= $row['Imagen'] ?>" alt="Imagen de <?= htmlspecialchars($row['NOMBRE']) ?>" width="60"></td>
                        <?php if ($rol === 'usuario') : ?>
                            <td>
                                <?php if ($ya_es_favorito): ?>
                                    <form action="../../controllers/user/eliminar_favorito.php" method="POST" onsubmit="return confirm('¿Eliminar de favoritos?');">
                                        <input type="hidden" name="id_favorito" value="<?= htmlspecialchars($id_favorito) ?>">
                                        <button type="submit" class="eliminar-btn" title="Quitar de favoritos">★</button>
                                    </form>
                                <?php else: ?>
                                    <form action="../../controllers/user/agregar_favorito.php" method="POST" onsubmit="return confirm('¿Agregar a favoritos?');">
                                        <input type="hidden" name="id_prenda" value="<?= htmlspecialchars($id_prenda) ?>">
                                        <button type="submit" class="agregar-btn" title="Agregar a favoritos">☆</button>
                                    </form>
                                <?php endif; ?>
                            </td>
                        <?php endif; ?>
                    </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </main>

    <?php include '../../includes/footer.php'; ?>
    <script src="../../assets/js/script.js"></script>
</body>

</html>