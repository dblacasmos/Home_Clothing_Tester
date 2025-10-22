<?php
session_start();
session_destroy();      // Destruye toda la información de la sesión (cierra la sesión del usuario)
header('Location: /home-clothing-tester/views/comunes/index.php'); // Redirige al usuario a la página de inicio
exit;
