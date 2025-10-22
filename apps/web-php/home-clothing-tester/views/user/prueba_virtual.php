<?php
session_start();
require_once '../../config/conexion.php';

// // Recupera los datos del usuario logueado
$id_usuario = $_SESSION['id_usuario'] ?? null;
$rol = $_SESSION['rol'] ?? null;

// Si no hay sesión o no es un usuario normal, muestra un mensaje y termina
if (!$id_usuario || $rol !== 'usuario') {
    echo '<div class="prueba-virtual-error">
            <h3>Acceso restringido</h3>
            <p>Debes iniciar sesión como usuario para usar la prueba virtual.</p>
          </div>';
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Prueba Virtual</title>
    <link rel="icon" href="../../assets/images/icons/Favicon.png" type="image/png">

    <!-- Estilos -->
    <link rel="stylesheet" href="../../assets/css/main.css">
    <link rel="stylesheet" href="../../assets/css/usuario.css">

    <!-- TensorFlow y modelos para detectar la cara -->
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@4.15.0"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow-models/face-landmarks-detection@1.0.2"></script>
    <script src="https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh"></script>

     <!-- Librería 3D para cargar modelos GLTF -->
    <script src="https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.160.0/examples/js/loaders/GLTFLoader.js"></script>
</head>

<body>
    <?php include '../../includes/header.php'; ?>

    <div id="sidebarMenu" class="sidebar-menu">
        <?php include '../../includes/nav/nav_user.php'; ?>
    </div>

    <!-- Zona principal con cámara y selección de prenda -->
    <main class="contenedor">
        <!-- Video en vivo -->
        <div class="video-container">
            <video id="video" autoplay playsinline></video>
        </div>

        <!-- Controles para elegir cámara y prenda -->
        <div class="panel-control">
            <h1>Prueba Virtual de Ropa</h1>
            <label for="camara">Selecciona cámara:</label>
            <select id="camara"></select>

            <label for="prenda">Selecciona una prenda:</label>
            <select id="prenda">
                <!-- Cada opción tiene un ID y una imagen asociada -->
                <option value="1" data-img="camiseta-azul.png">Camiseta Azul</option>
                <option value="2" data-img="camiseta-blanca.png">Camiseta Blanca</option>
                <option value="3" data-img="camiseta-negra-skull.png">Camiseta Negra Skull</option>
                <option value="4" data-img="gorra-azul.png">Gorra Azul</option>
                <option value="5" data-img="jeans-claros.png">Jeans Claros</option>
            </select>

            <div class="preview">
                <!-- Muestra una imagen dependiendo de la prenda seleccionada -->
                <img id="1" class="prenda-preview" src="../../assets/images/simulaciones/camiseta-azul.png" alt="Prenda seleccionada">
                <img id="2" class="prenda-preview" src="../../assets/images/simulaciones/camiseta-blanca.png" alt="Prenda seleccionada">
                <img id="3" class="prenda-preview" src="../../assets/images/simulaciones/camiseta-negra-skull.png" alt="Prenda seleccionada">
                <img id="4" class="prenda-preview" src="../../assets/images/simulaciones/gorra-azul.png" alt="Prenda seleccionada">
                <img id="5" class="prenda-preview" src="../../assets/images/simulaciones/jeans-claros.png" alt="Prenda seleccionada">
            </div>

            <div class="acciones">
                <button onclick="rotarVista()">Rotar Vista</button>
                <button onclick="probarPrenda()">Probar</button>
            </div>

            <!-- Aquí aparece el mensaje de éxito o error -->
            <div id="mensaje-registro" class="mensaje-registro oculto"></div>
        </div>
    </main>


    <?php include '../../includes/footer.php'; ?>

    <!-- Paso el ID del usuario a JavaScript -->
    <script>
        // Paso el ID del usuario a JavaScript
        window.ID_USUARIO = <?php echo json_encode($_SESSION['id_usuario'] ?? 0); ?>;
    </script>

    // Script del probador virtual + script general
    <script src="../../assets/js/probador_virtual.js"></script>
    <script src="../../assets/js/script.js"></script>
</body>

</html>