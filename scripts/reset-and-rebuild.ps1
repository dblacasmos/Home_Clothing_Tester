Write-Host ">>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<"
Write-Host "Reiniciando el entorno Docker..."
Write-Host ">>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<"

# Ruta completa al docker-compose.yml
$composeFile = "$PSScriptRoot\..\docker-compose.yml"
Start-Sleep -Seconds 3

# Ejecutar docker-compose con ruta absoluta
Write-Host "Deteniendo y eliminando contenedores y volúmenes..."
docker-compose -f $composeFile down -v
Start-Sleep -Seconds 3

Write-Host "Reconstruyendo imágenes..."
docker-compose -f $composeFile build
Start-Sleep -Seconds 3

Write-Host "Iniciando contenedores..."
docker-compose -f $composeFile up -d
Start-Sleep -Seconds 3

Write-Host "Abriendo Streamlit en el navegador..."
Start-Process "http://localhost:8501"
Start-Sleep -Seconds 2

Write-Host "Abriendo Spring Boot-Swagger en el navegador..."
Start-Process "http://localhost:8080/swagger-ui/index.html"
Start-Sleep -Seconds 2

Write-Host "Abriendo Web en el navegador..."
Start-Process "http://localhost:3000"
Start-Sleep -Seconds 2

# Comprobación de dockers
Write-Host "Comprobando servicios..."
docker compose ps

Write-Host "Entorno reiniciado correctamente."
Pause