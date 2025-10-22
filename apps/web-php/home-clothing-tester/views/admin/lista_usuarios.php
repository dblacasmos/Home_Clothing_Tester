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
    <title>Listado Usuarios</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <h2>LISTADO DE USUARIOS/ADMINS</h2>

        <?php
        $sql = "SELECT
                    ID_USUARIO,
                    ID_ADMIN,
                    NOMBRE_USUARIO,
                    CORREO_USUARIO,
                    PASSWORD AS CONTRASEÑA,
                    ESTADO
                FROM usuario";

        $result = $conn->query($sql);

        if (!$result) {
            die("Error al ejecutar la consulta: " . $conn->error);
        }
        ?>

        <table>
            <thead>
                <tr>
                    <th>ID_USUARIO</th>
                    <th>ES ADMIN</th>
                    <th>NOMBRE</th>
                    <th>CORREO</th>
                    <th>CONTRASEÑA</th>
                    <th>ESTADO</th>
                    <th>CAMBIAR</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = $result->fetch_assoc()) : ?>
                    <tr>
                        <td><?= htmlspecialchars($row['ID_USUARIO']) ?></td>
                        <td><?= !empty($row['ID_ADMIN']) ? 'Sí' : 'No' ?></td>
                        <td><?= htmlspecialchars($row['NOMBRE_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['CORREO_USUARIO']) ?></td>
                        <td><?= htmlspecialchars($row['CONTRASEÑA']) ?></td>

                        <?php
                        $estado = strtolower($row['ESTADO']);
                        $clase_estado = 'estado-texto estado-' . $estado;
                        ?>

                        <td class="<?= $clase_estado ?>">
                            <?= ucfirst($estado) ?>
                        </td>
                        <td class="botones-estado">
                            <!-- ESTADO ACTIVO -->
                            <form method="POST" action="../../controllers/admin/cambiar_estado_usuario.php" onsubmit="return confirm('¿Activar usuario?');">
                                <input type="hidden" name="id_usuario" value="<?= $row['ID_USUARIO'] ?>">
                                <input type="hidden" name="nuevo_estado" value="ACTIVO">
                                <button type="submit" class="boton-activo" <?= $row['ESTADO'] === 'ACTIVO' ? 'disabled' : '' ?>
                                    title="Activar 🟢">🟢
                                </button>
                            </form>

                            <!-- ESTADO INACTIVO -->
                            <form method="POST" action="../../controllers/admin/cambiar_estado_usuario.php" onsubmit="return confirm('¿Inactivar usuario?');">
                                <input type="hidden" name="id_usuario" value="<?= $row['ID_USUARIO'] ?>">
                                <input type="hidden" name="nuevo_estado" value="INACTIVO">
                                <button type="submit" class="boton-inactivo" <?= $row['ESTADO'] === 'INACTIVO' ? 'disabled' : '' ?>
                                    title="Inactivar ⚪">⚪
                                </button>
                            </form>

                            <!-- ESTADO BLOQUEADO -->
                            <form method="POST" action="../../controllers/admin/cambiar_estado_usuario.php" onsubmit="return confirm('¿Bloquear usuario?');">
                                <input type="hidden" name="id_usuario" value="<?= $row['ID_USUARIO'] ?>">
                                <input type="hidden" name="nuevo_estado" value="BLOQUEADO">
                                <button type="submit" class="boton-bloqueado" <?= $row['ESTADO'] === 'BLOQUEADO' ? 'disabled' : '' ?>
                                    title="Bloquear 🔒">🔒
                                </button>
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