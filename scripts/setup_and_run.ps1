Write-Host "=== Arrancando setup_and_run.ps ==="
<#
.SYNOPSIS
    Setup and run Dockerized Home Clothing Tester on Windows.

.DESCRIPTION
    Este script comprueba/instala Docker Desktop usando WinGet,
    espera hasta que Docker esté listo, y luego ejecuta docker-compose
    para levantar MySQL, la API Java (Spring Boot) y el dashboard Streamlit.

.NOTES
    - Requiere Windows 10/11 con WinGet instalado.
    - Debe ejecutarse como Administrador (Run as Administrator).

.EXAMPLE
    PS C:\Users\User\home-clothing-tester> .\setup_and_run.ps
#>

function Write-Info {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-WarningColor {
    param($Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrorColor {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}


# 1) Verifica que corras como Administrador
if (-not ([bool] (net session) 2>$null)) {
    Write-ErrorColor "Debes ejecutar este script como Administrador (Run as Administrator)."
    exit 1
}


# 2) Comprueba/Instala Docker Desktop
Write-Info "Verificando Docker Desktop..."

# Comprueba si docker.exe existe en PATH
try {
    $dockerVersion = & docker --version 2>&1
} catch {
    $dockerVersion = $null
}

if (-not $dockerVersion) {
    Write-Info "Docker no esta instalado. Instalando Docker Desktop usando WinGet..."
    try {
        winget install --id Docker.DockerDesktop -e --accept-package-agreements --accept-source-agreements
    } catch {
        Write-ErrorColor "No se pudo instalar Docker Desktop con WinGet. Instalalo manualmente desde https://www.docker.com/products/docker-desktop/"
        exit 1
    }
    Start-Sleep -Seconds 5
} else {
    Write-Info "Docker Desktop ya esta instalado: $dockerVersion"
}


# 3) Asegúrate de que Docker Desktop esté corriendo
Write-Info "Esperando a que Docker Desktop este listo..."
$timeout = 300    # segundos
$elapsed = 0
while ($elapsed -lt $timeout) {
    try {
        $info = & docker info 2>$null
        if ($info) {
            Write-Info "Docker esta corriendo."
            break
        }
    } catch {
        # Nada: Docker no responde aún
    }
    Start-Sleep -Seconds 5
    $elapsed += 5
}

if ($elapsed -ge $timeout) {
    Write-ErrorColor "Docker no respondio tras $timeout segundos. Revisa Docker Desktop y vuelve a intentar."
    exit 1
}


# 4) Verifica Docker Compose (incluido con Docker Desktop 20.10+)
Write-Info "Comprobando Docker Compose..."
$composeVersion = $null
try {
    $composeVersion = & docker-compose --version 2>&1
} catch {
    try {
        $composeVersion = & docker compose version 2>&1
    } catch {
        $composeVersion = $null
    }
}

if ($composeVersion) {
    Write-Info "Docker Compose detectado: $composeVersion"
} else {
    Write-WarningColor "No se encontro 'docker-compose' ni 'docker compose'. Asegurate de que Docker Desktop este instalado y actualizado."
    exit 1
}


# 5) Levanta los contenedores con Docker Compose
Write-Info "Parando contenedores antiguos (si existen) y levantando nuevos..."
# Movernos a la carpeta del script
Push-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# Parar servicios existentes y limpiar redes huerfanas
if ($composeVersion -match "docker-compose") {
    $Env:COMPOSE_DOCKER_CLI_BUILD = "0"
    & docker compose down --remove-orphans
    & docker compose up --build -d
} else {
    & docker compose down --remove-orphans
    & docker compose up --build -d
}

# Espera breve para que se inicialicen
Start-Sleep -Seconds 5


# 6) Mostrar estado y puertos
Write-Info "Estado de contenedores:"
if ($composeVersion -match "docker-compose") {
    & docker compose ps
} else {
    & docker compose ps
}

Write-Host ""
Write-Host "---------------------------------------------" -ForegroundColor Green
Write-Host " Servicios corriendo en Windows:" -ForegroundColor Green
Write-Host "---------------------------------------------" -ForegroundColor Green
Write-Host " - API Spring:   http://localhost:8080/swagger-ui/index.html" -ForegroundColor Green
Write-Host " - Streamlit:    localhost:8501"        -ForegroundColor Green
Write-Host "---------------------------------------------" -ForegroundColor Green
Write-Host ""

# Restaurar ubicación anterior
Pop-Location
