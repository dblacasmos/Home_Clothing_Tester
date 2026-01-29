<?php
session_start();
include __DIR__ . '/../../includes/get_prendas.php';
?>


<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HOME CLOTHING TESTER</title>
    <link rel="icon" href="/assets/images/icons/Favicon.png" type="image/png">
    <link rel="stylesheet" href="/assets/css/main.css">
    <link rel="stylesheet" href="/assets/css/admin.css">
    <link rel="stylesheet" href="/assets/css/usuario.css">
</head>

<body>

    <?php include __DIR__ . '/../../includes/header.php'; ?>

    <!-- Muestra el menú correcto según el rol -->
    <nav id="sidebarMenu" class="sidebar-menu">
        <?php
        if (!isset($_SESSION['rol'])) {
            include __DIR__ . '/../../includes/nav/nav.php';
        } elseif ($_SESSION['rol'] === 'admin') {
            include __DIR__ . '/../../includes/nav/nav_admin.php';
        } elseif ($_SESSION['rol'] === 'usuario') {
            include __DIR__ . '/../../includes/nav/nav_user.php';
        }
        ?>
    </nav>

    <!-- Formulario de inicio de sesión -->
    <?php include __DIR__ . '/../../includes/login_form.php'; ?>

    <main class="main-horizontal">

        <!-- Muestra las prendas como tarjetas dentro de un carrusel desplazable.-->
        <section class="carrusel-container">
            <button class="flecha izquierda" onclick="scrollCarrusel(-1)">←</button>

            <div class="carrusel" id="carrusel">
                <?php foreach ($ropa as $item): ?>
                    <a href="/views/comunes/catalogo_prendas.php" class="card-link">
                        <div class="card">
                            <img src="<?= htmlspecialchars($item['imagen']) ?>" alt="<?= htmlspecialchars($item['nombre']) ?>">
                            <div class="card-text">
                                <h3><?= htmlspecialchars($item['nombre']) ?></h3>
                                <p><?= htmlspecialchars($item['precio']) ?> &euro;</p>
                            </div>
                        </div>
                    </a>
                <?php endforeach; ?>
            </div>

            <button class="flecha derecha" onclick="scrollCarrusel(1)">→</button>
        </section>

        <!-- Sección de vista previa de cámara -->
        <section class="virtual-section">

            <!-- Solo los usuarios logueados como "usuario" pueden acceder a la vista previa -->
            <?php if (isset($_SESSION['rol']) && $_SESSION['rol'] === 'usuario'): ?>
                <a href="/views/user/prueba_virtual.php" class="prueba-virtual-link">
                    <div id="pruebaVirtual">
                        <h3>VISTA PREVIA DE CAMARA</h3>
                        <img src="/assets/images/layout/prueba-virtual.jpg" alt="Vista Previa">
                        <p>Visualiza prendas con tu webcam<br>
                            (Vista no adaptativa - experimental)
                        </p>
                    </div>
                </a>
            <?php else: ?>

                <!-- Mensaje de Error si no son "usuario" -->
                <div id="pruebaVirtual" class="prueba-virtual-error">
                    <h3>VISTA PREVIA DE CAMARA</h3>
                    <img src="/assets/images/layout/prueba-virtual.jpg" alt="Vista Previa">
                    <p>Debes iniciar sesión como usuario para acceder a la vista previa.</p>
                </div>
            <?php endif; ?>
        </section>

    </main>

    <?php include __DIR__ . '/../../includes/footer.php'; ?>

    <script src="/assets/js/script.js"></script>
</body>

</html>