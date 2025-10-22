<?php
session_start();
require_once '../../config/conexion.php';

// Solo usuario "admin"
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
    <title>Consultar Gasto de Usuario</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_admin.php'; ?>
    </div>

    <main>
        <div class="gasto-wrapper">
            <img src="../../assets/media/giphy.gif" alt="Decoración izquierda" class="gasto-img gasto-img-left">

            <div class="container-gasto">
                <h2>CONSULTAR GASTO TOTAL DE UN USUARIO</h2>

                <form method="POST" class="formulario-consulta">
                    <label for="correo_usuario">Correo Usuario:</label>
                    <input type="email" name="correo_usuario" id="correo_usuario" required>
                    <button type="submit">Consultar</button>
                </form>

                <?php
                if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['correo_usuario'])) {
                    $correo_usuario = trim($_POST['correo_usuario']);  // Limpia el correo ingresado
                    $id_admin = $_SESSION['id_usuario'];               // Obtiene el ID del admin actual

                    $stmt_user = $conn->prepare("SELECT ID_USUARIO FROM usuario WHERE CORREO_USUARIO = ?");
                    $stmt_user->bind_param("s", $correo_usuario);      // Coloca el correo como parámetro
                    $stmt_user->execute();
                    $result_user = $stmt_user->get_result();

                    if ($result_user && $row_user = $result_user->fetch_assoc()) {
                        $id_usuario = $row_user['ID_USUARIO'];

                        // // Llama a la función en MySQL que calcula el gasto total
                        $stmt = $conn->prepare("SELECT fun_total_gasto_usuario(?, ?) AS gasto_total");
                        $stmt->bind_param("ii", $id_usuario, $id_admin);
                        $stmt->execute();
                        $result = $stmt->get_result();

                        if ($row = $result->fetch_assoc()) {
                            echo "<p class='resultado-gasto'>Total gastado: <strong>" . number_format($row['gasto_total'], 2) . " €</strong></p>";
                        } else {
                            echo "<p class='resultado-gasto'>No se pudo recuperar el gasto.</p>";
                        }
                        $stmt->close();
                    } else {
                        echo "<p class='resultado-gasto'>No se encontró ningún usuario con ese correo.</p>";
                    }

                    $stmt_user->close();
                }
                ?>
            </div>

            <img src="../../assets/media/giphy.gif" alt="Decoración derecha" class="gasto-img gasto-img-right">
        </div>
    </main>

    <?php include '../../includes/footer.php'; ?>
    <script src="../../assets/js/script.js"></script>
</body>

</html>