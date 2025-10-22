<?php
session_start();
require_once '../../config/conexion.php';
include '../../includes/get_prendas.php';  // Carga las prendas desde la base de datos
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HOME CLOTHING TESTER</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/admin.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">
</head>

<body>

    <?php
    include '../../includes/header.php';
    ?>

    <!-- Muestra el menú correcto según el rol -->
    <nav id="sidebarMenu" class="sidebar-menu">
        <?php
        if (!isset($_SESSION['rol'])) {
            include '../../includes/nav/nav.php';
        } elseif ($_SESSION['rol'] === 'admin') {
            include '../../includes/nav/nav_admin.php';
        } elseif ($_SESSION['rol'] === 'usuario') {
            include '../../includes/nav/nav_user.php';
        }
        ?>
    </nav>

    <!-- Formulario de inicio de sesión -->
    <?php include '../../includes/login_form.php'; ?>

    <main class="main-horizontal">

        <!-- Muestra las prendas como tarjetas dentro de un carrusel desplazable.-->
        <section class="carrusel-container">
            <button class="flecha izquierda" onclick="scrollCarrusel(-1)">←</button>

            <div class="carrusel" id="carrusel">
                <?php foreach ($ropa as $item): ?>
                    <a href="catalogo_prendas.php" class="card-link">
                        <div class="card">
                            <img src="<?= $item['imagen'] ?>" alt="<?= $item['nombre'] ?>">
                            <div class="card-text">
                                <h3><?= $item['nombre'] ?></h3>
                                <p><?= $item['precio'] ?> €</p>
                            </div>
                        </div>
                    </a>
                <?php endforeach; ?>
            </div>

            <button class="flecha derecha" onclick="scrollCarrusel(1)">→</button>
        </section>

        <!-- Sección de prueba virtual -->
        <section class="virtual-section">

            <!-- Solo los usuarios logueados como "usuario" pueden acceder a la prueba virtual -->
            <?php if (isset($_SESSION['rol']) && $_SESSION['rol'] === 'usuario'): ?>
                <a href="../user/prueba_virtual.php" class="prueba-virtual-link">
                    <div id="pruebaVirtual">
                        <h3>PRUEBA VIRTUAL</h3>
                        <img src="../../assets/images/layout/prueba-virtual.jpg" alt="Prueba Virtual">
                        <p>Descubre la nueva forma de probarse ropa<br>
                            REALIDAD AUMENTADA
                        </p>
                    </div>
                </a>
            <?php else: ?>

                <!-- Mensaje de Error si no son "usuario" -->
                <div id="pruebaVirtual" class="prueba-virtual-error">
                    <h3>PRUEBA VIRTUAL</h3>
                    <img src="../../assets/images/layout/prueba-virtual.jpg" alt="Prueba Virtual">
                    <p>
                        ❌ Debes iniciar sesión como usuario para acceder a la prueba virtual.
                    </p>
                </div>
            <?php endif; ?>
        </section>

    </main>

    <?php include '../../includes/footer.php'; ?>

    <script src="../../assets/js/script.js"></script>
</body>

</html>