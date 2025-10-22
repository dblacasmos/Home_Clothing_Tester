<!-- Este archivo PHP recorre las carpetas dentro de assets/images/
     y muestra en pantalla todas las imágenes que encuentra, agrupadas por carpeta.
     También avisa si no hay carpetas o si no hay imágenes.-->

<?php
$carpetaBase = __DIR__ . '/../../assets/images/';
$subcarpetas = array_filter(glob($carpetaBase . '*'), 'is_dir');

echo "<h2>Imágenes en subcarpetas de assets/images</h2>";

if (empty($subcarpetas)) {
    echo "<p style='color: red;'>❌ No hay subcarpetas en: $carpetaBase</p>";
    exit;
}

foreach ($subcarpetas as $subcarpeta) {
    $nombreSubcarpeta = basename($subcarpeta);
    echo "<h3>📁 $nombreSubcarpeta</h3>";

    $imagenes = glob($subcarpeta . '/*.{jpg,jpeg,png,gif}', GLOB_BRACE);

    if (empty($imagenes)) {
        echo "<p style='color: orange;'>⚠️ No hay imágenes en esta carpeta.</p>";
    } else {
        echo "<div style='display: flex; flex-wrap: wrap; gap: 10px;'>";
        foreach ($imagenes as $imgPath) {
            $relativa = str_replace(realpath($_SERVER['DOCUMENT_ROOT']), '', realpath($imgPath));
            echo "<div><img src='$relativa' width='100'><p style='font-size: 0.8em;'>".basename($imgPath)."</p></div>";
        }
        echo "</div>";
    }
}
?>
