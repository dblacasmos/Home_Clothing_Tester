<!-- Este script revisa que no falten archivos clave de tu proyecto.
     Es útil para comprobar si todo está bien después de mover carpetas o hacer deploy. -->

<?php
// controllers/comprobar_rutas.php

header('Content-Type: text/plain');

// Lista de rutas a comprobar (relativas a este archivo)
$rutas = [
    '../../includes/header.php',
    '../../includes/footer.php',
    '../../includes/nav/nav_admin.php',
    '../../includes/nav/nav_user.php',
    '../../includes/login_form.php',

    '../../config/conexion.php',

    '../../controllers/comunes/login.php',
    '../../controllers/comunes/logout.php',
    '../../controllers/user/agregar_favorito.php',
    '../../controllers/user/eliminar_favorito.php',

    '../../assets/css/main.css',
    '../../assets/css/admin.css',
    '../../assets/css/usuario.css',
    '../../assets/js/script.js',
    '../../assets/images/icons/Favicon.png',

    '../../views/comunes/index.php',
    '../../views/user/favoritos.php',
    '../../views/admin/lista_usuarios.php'
];

// Mostrar estado de cada ruta
echo "🔎 Verificación de rutas del proyecto:\n\n";

foreach ($rutas as $ruta) {
    if (file_exists($ruta)) {
        echo "✅ OK: $ruta\n";
    } else {
        echo "❌ ERROR: $ruta NO existe\n";
    }
}
