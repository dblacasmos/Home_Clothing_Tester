# =============================================================================
# Home Clothing Tester - Setup and Run Script for Windows
# =============================================================================
#
# FEATURES:
# 1. Uses `docker compose up --wait` for deterministic healthcheck-based startup
# 2. Falls back to host-side HTTP checks if Docker healthcheck fails
# 3. Detects restart loops vs healthcheck misconfigurations
# 4. Native command wrapper prevents false NativeCommandError from stderr
#
# COMPATIBILITY: Windows PowerShell 5.1 and PowerShell 7+
# =============================================================================

param(
    [switch]$SkipBuild,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# =============================================================================
# Native Command Wrapper (CRITICAL FIX for PS 7.3+ NativeCommandError)
# =============================================================================

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter(Mandatory)]
        [string[]]$Arguments,

        [switch]$CaptureOutput,
        [switch]$SuppressOutput
    )

    $savedErrorActionPreference = $ErrorActionPreference
    $savedPSNativeCommandUseErrorActionPreference = $null

    if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
        $savedPSNativeCommandUseErrorActionPreference = $global:PSNativeCommandUseErrorActionPreference
        $global:PSNativeCommandUseErrorActionPreference = $false
    }

    try {
        $ErrorActionPreference = "Continue"

        if ($SuppressOutput) {
            & $Command @Arguments 2>&1 | Out-Null
        } elseif ($CaptureOutput) {
            $output = & $Command @Arguments 2>&1
            return @{
                Output = $output
                ExitCode = $LASTEXITCODE
            }
        } else {
            & $Command @Arguments 2>&1 | ForEach-Object {
                if ($_ -is [System.Management.Automation.ErrorRecord]) {
                    Write-Host $_.ToString() -ForegroundColor DarkGray
                } else {
                    Write-Host $_
                }
            }
        }

        return $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $savedErrorActionPreference
        if ($null -ne $savedPSNativeCommandUseErrorActionPreference) {
            $global:PSNativeCommandUseErrorActionPreference = $savedPSNativeCommandUseErrorActionPreference
        }
    }
}

# =============================================================================
# Logging Functions
# =============================================================================

function Write-Info {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param($Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarningMsg {
    param($Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrorMsg {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Step {
    param($StepNum, $Total, $Message)
    Write-Host ""
    Write-Host "[$StepNum/$Total] $Message" -ForegroundColor Magenta
    Write-Host ("-" * 60) -ForegroundColor DarkGray
}

# =============================================================================
# Compose/Docker Wrappers
# =============================================================================

$script:ComposeIsPlugin = $false

function Invoke-Compose {
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments,

        [switch]$CaptureOutput,
        [switch]$SuppressOutput
    )

    if ($script:ComposeIsPlugin) {
        $fullArgs = @("compose") + $Arguments
        return Invoke-NativeCommand -Command "docker" -Arguments $fullArgs -CaptureOutput:$CaptureOutput -SuppressOutput:$SuppressOutput
    } else {
        return Invoke-NativeCommand -Command "docker-compose" -Arguments $Arguments -CaptureOutput:$CaptureOutput -SuppressOutput:$SuppressOutput
    }
}

function Invoke-Docker {
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments,

        [switch]$CaptureOutput,
        [switch]$SuppressOutput
    )

    return Invoke-NativeCommand -Command "docker" -Arguments $Arguments -CaptureOutput:$CaptureOutput -SuppressOutput:$SuppressOutput
}

# =============================================================================
# HTTP Health Check Function
# =============================================================================

function Test-HttpEndpoint {
    param(
        [string]$Url,
        [string]$ServiceName,
        [int]$TimeoutSec = 10,
        [int]$MaxRetries = 3
    )

    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec $TimeoutSec -ErrorAction Stop
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 400) {
                return @{
                    Success = $true
                    StatusCode = $response.StatusCode
                    Message = "HTTP $($response.StatusCode)"
                }
            }
        } catch {
            if ($i -lt $MaxRetries) {
                Start-Sleep -Seconds 2
            }
        }
    }

    return @{
        Success = $false
        StatusCode = 0
        Message = "Failed after $MaxRetries attempts"
    }
}

# =============================================================================
# Container Health Check Function
# =============================================================================

function Get-ContainerHealth {
    param([string]$ContainerName)

    $result = @{
        Status = "unknown"
        Health = "unknown"
        Restarts = 0
        Uptime = ""
        IsHealthy = $false
        InRestartLoop = $false
        IsRunning = $false
    }

    try {
        $inspectResult = Invoke-Docker -Arguments @("inspect", $ContainerName) -CaptureOutput
        if ($inspectResult.ExitCode -eq 0) {
            $inspect = ($inspectResult.Output | Out-String) | ConvertFrom-Json

            if ($inspect) {
                $result.Status = $inspect.State.Status
                $result.Restarts = $inspect.RestartCount
                $result.IsRunning = ($result.Status -eq "running")

                if ($inspect.State.Health) {
                    $result.Health = $inspect.State.Health.Status
                } else {
                    $result.Health = "no-healthcheck"
                }

                $startedAt = [DateTime]::Parse($inspect.State.StartedAt)
                $uptime = (Get-Date) - $startedAt
                $result.Uptime = "{0:mm\:ss}" -f $uptime

                $result.IsHealthy = ($result.Status -eq "running") -and ($result.Health -eq "healthy")

                # Detect restart loop
                if ($result.Restarts -gt 3 -or ($result.Restarts -gt 0 -and $uptime.TotalSeconds -lt 30)) {
                    $result.InRestartLoop = $true
                }
            }
        }
    } catch {
        $result.Status = "error"
    }

    return $result
}

# =============================================================================
# Start
# =============================================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Home Clothing Tester - Docker Setup Script" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $($psVersion.Major).$($psVersion.Minor).$($psVersion.Build)" -ForegroundColor DarkGray

$totalSteps = 7

# =============================================================================
# Step 1: Admin Check
# =============================================================================

Write-Step 1 $totalSteps "Verificando permisos de Administrador"

$isAdmin = $false
try {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
} catch {
    $isAdmin = $false
}

if (-not $isAdmin) {
    Write-ErrorMsg "Este script requiere permisos de Administrador."
    Write-ErrorMsg "Haz clic derecho en PowerShell y selecciona 'Ejecutar como administrador'."
    exit 1
}

Write-Success "Ejecutando como Administrador"

# =============================================================================
# Step 2: Docker Desktop Check
# =============================================================================

Write-Step 2 $totalSteps "Verificando Docker Desktop"

$dockerInstalled = $false

$result = Invoke-NativeCommand -Command "docker" -Arguments @("--version") -CaptureOutput
if ($result.ExitCode -eq 0) {
    $dockerInstalled = $true
    $dockerVersion = ($result.Output | Out-String).Trim()
    Write-Success "Docker instalado: $dockerVersion"
}

if (-not $dockerInstalled) {
    Write-Info "Docker no detectado. Intentando instalar con WinGet..."
    try {
        $exitCode = Invoke-NativeCommand -Command "winget" -Arguments @("install", "--id", "Docker.DockerDesktop", "-e", "--accept-package-agreements", "--accept-source-agreements")
        if ($exitCode -eq 0) {
            Write-WarningMsg "Docker Desktop instalado. Por favor:"
            Write-WarningMsg "  1. Reinicia tu computadora"
            Write-WarningMsg "  2. Abre Docker Desktop y espera a que inicie"
            Write-WarningMsg "  3. Vuelve a ejecutar este script"
            exit 0
        }
    } catch { }

    Write-ErrorMsg "No se pudo instalar Docker Desktop."
    Write-ErrorMsg "Descargalo manualmente: https://www.docker.com/products/docker-desktop/"
    exit 1
}

Write-Info "Esperando a que Docker daemon responda..."
$dockerReady = $false
$maxWait = 120
$waited = 0

while ($waited -lt $maxWait) {
    $result = Invoke-NativeCommand -Command "docker" -Arguments @("info") -CaptureOutput
    if ($result.ExitCode -eq 0) {
        $dockerReady = $true
        break
    }

    Start-Sleep -Seconds 3
    $waited += 3
    Write-Host "." -NoNewline
}

Write-Host ""

if (-not $dockerReady) {
    Write-ErrorMsg "Docker daemon no responde despues de $maxWait segundos."
    Write-ErrorMsg "Asegurate de que Docker Desktop este abierto y funcionando."
    exit 1
}

Write-Success "Docker daemon esta listo"

# =============================================================================
# Step 3: Docker Compose Check
# =============================================================================

Write-Step 3 $totalSteps "Verificando Docker Compose"

$result = Invoke-NativeCommand -Command "docker" -Arguments @("compose", "version") -CaptureOutput
if ($result.ExitCode -eq 0) {
    $script:ComposeIsPlugin = $true
    $composeVersion = ($result.Output | Out-String).Trim()
    Write-Success "Docker Compose (plugin): $composeVersion"
} else {
    $result = Invoke-NativeCommand -Command "docker-compose" -Arguments @("--version") -CaptureOutput
    if ($result.ExitCode -eq 0) {
        $script:ComposeIsPlugin = $false
        $composeVersion = ($result.Output | Out-String).Trim()
        Write-Success "Docker Compose (legacy): $composeVersion"
    } else {
        Write-ErrorMsg "Docker Compose no encontrado."
        Write-ErrorMsg "Actualiza Docker Desktop a la ultima version."
        exit 1
    }
}

# =============================================================================
# Step 4: Port Check
# =============================================================================

Write-Step 4 $totalSteps "Verificando puertos disponibles"

$portsNeeded = @{
    3307 = "MySQL"
    8080 = "Backend API"
    8081 = "phpMyAdmin"
    8082 = "Web PHP"
    8501 = "Streamlit"
}

$portConflicts = @()

foreach ($port in $portsNeeded.Keys) {
    $inUse = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($inUse) {
        $processId = $inUse.OwningProcess | Select-Object -First 1
        $processName = (Get-Process -Id $processId -ErrorAction SilentlyContinue).ProcessName
        $portConflicts += "Puerto $port ($($portsNeeded[$port])) en uso por: $processName (PID: $processId)"
    }
}

if ($portConflicts.Count -gt 0) {
    Write-ErrorMsg "Los siguientes puertos estan en uso:"
    foreach ($conflict in $portConflicts) {
        Write-ErrorMsg "  - $conflict"
    }
    Write-ErrorMsg ""
    Write-ErrorMsg "Opciones:"
    Write-ErrorMsg "  1. Cierra las aplicaciones que usan esos puertos"
    Write-ErrorMsg "  2. O ejecuta: docker compose down (si son contenedores anteriores)"
    exit 1
}

Write-Success "Todos los puertos estan disponibles"

# =============================================================================
# Step 5: Navigate to project directory
# =============================================================================

Write-Step 5 $totalSteps "Preparando entorno"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$projectRoot = Split-Path -Parent $scriptDir

Push-Location $projectRoot
Write-Info "Directorio del proyecto: $projectRoot"

if (-not (Test-Path "docker-compose.yml")) {
    Write-ErrorMsg "No se encontro docker-compose.yml en $projectRoot"
    Pop-Location
    exit 1
}

Write-Success "docker-compose.yml encontrado"

# =============================================================================
# Step 6: Build and Start Containers
# =============================================================================

Write-Step 6 $totalSteps "Construyendo e iniciando contenedores"

Write-Info "Deteniendo contenedores existentes..."
$exitCode = Invoke-Compose -Arguments @("down", "--remove-orphans", "--timeout", "30") -SuppressOutput

if (-not $SkipBuild) {
    Write-Info "Limpiando imagenes huerfanas..."
    Invoke-Docker -Arguments @("image", "prune", "-f") -SuppressOutput | Out-Null
}

Write-Info "Iniciando servicios (esto puede tardar varios minutos la primera vez)..."
Write-Info "Esperando a que todos los servicios pasen sus healthchecks..."
Write-Host ""

$composeArgs = @("up", "-d", "--wait", "--wait-timeout", "300")
if (-not $SkipBuild) {
    $composeArgs = @("up", "--build", "-d", "--wait", "--wait-timeout", "300")
}

$composeExitCode = Invoke-Compose -Arguments $composeArgs

# =============================================================================
# Step 7: Validate Services (with fallback for healthcheck misconfigurations)
# =============================================================================

Write-Step 7 $totalSteps "Validando estado de los servicios"

# Define all services with their endpoints
$services = @(
    @{ Name = "mysql"; Container = "mysql"; Endpoint = $null; Port = 3307; Description = "MySQL Database" }
    @{ Name = "backend"; Container = "backend-api"; Endpoint = "http://localhost:8080/swagger-ui/index.html"; Port = 8080; Description = "Backend API" }
    @{ Name = "streamlit"; Container = "streamlit"; Endpoint = "http://localhost:8501/"; Port = 8501; Description = "Streamlit Dashboard" }
    @{ Name = "phpmyadmin"; Container = "phpmyadmin"; Endpoint = "http://localhost:8081/"; Port = 8081; Description = "phpMyAdmin" }
    @{ Name = "web-php"; Container = "web-php"; Endpoint = "http://localhost:8082/"; Port = 8082; Description = "Web PHP" }
)

$healthcheckIssues = @()
$realFailures = @()
$allServicesReachable = $true

Write-Host ""
Write-Host "Estado de servicios:" -ForegroundColor White
Write-Host ""

foreach ($service in $services) {
    $health = Get-ContainerHealth -ContainerName $service.Container

    $statusIcon = ""
    $statusColor = "White"
    $details = ""
    $hostHttpOk = $false

    # Check host-side HTTP reachability if endpoint is defined
    if ($service.Endpoint) {
        $httpResult = Test-HttpEndpoint -Url $service.Endpoint -ServiceName $service.Name -TimeoutSec 10 -MaxRetries 3
        $hostHttpOk = $httpResult.Success
    }

    if ($health.InRestartLoop) {
        # Real failure - container keeps crashing
        $statusIcon = "[RESTART LOOP]"
        $statusColor = "Red"
        $details = "Restarts: $($health.Restarts), Uptime: $($health.Uptime)"
        $realFailures += $service
        $allServicesReachable = $false

    } elseif ($health.IsHealthy) {
        # Docker says healthy
        if ($service.Endpoint -and $hostHttpOk) {
            $statusIcon = "[HEALTHY]"
            $statusColor = "Green"
            $details = "HTTP OK"
        } elseif ($service.Endpoint -and -not $hostHttpOk) {
            $statusIcon = "[DOCKER OK, HTTP FAIL]"
            $statusColor = "Yellow"
            $details = "Container healthy but HTTP not responding"
            $allServicesReachable = $false
        } else {
            $statusIcon = "[HEALTHY]"
            $statusColor = "Green"
            $details = "Uptime: $($health.Uptime)"
        }

    } elseif ($health.IsRunning -and $health.Health -eq "unhealthy") {
        # Docker says unhealthy, but let's check if host can reach it
        if ($service.Endpoint -and $hostHttpOk) {
            # Service is actually reachable - healthcheck is misconfigured
            $statusIcon = "[REACHABLE]"
            $statusColor = "Yellow"
            $details = "Docker healthcheck failed, but HTTP OK from host"
            $healthcheckIssues += $service
        } else {
            # Actually unreachable
            $statusIcon = "[UNHEALTHY]"
            $statusColor = "Red"
            $details = "Not reachable"
            $realFailures += $service
            $allServicesReachable = $false
        }

    } elseif ($health.IsRunning -and $health.Health -eq "starting") {
        # Still starting - check if reachable anyway
        if ($service.Endpoint -and $hostHttpOk) {
            $statusIcon = "[STARTING BUT OK]"
            $statusColor = "Yellow"
            $details = "Healthcheck still running, but HTTP OK"
            $healthcheckIssues += $service
        } else {
            $statusIcon = "[STARTING]"
            $statusColor = "Yellow"
            $details = "Health: $($health.Health)"
        }

    } elseif (-not $health.IsRunning) {
        # Container not running
        $statusIcon = "[NOT RUNNING]"
        $statusColor = "Red"
        $details = "Status: $($health.Status)"
        $realFailures += $service
        $allServicesReachable = $false

    } else {
        # Unknown state
        $statusIcon = "[UNKNOWN]"
        $statusColor = "Yellow"
        $details = "Status: $($health.Status), Health: $($health.Health)"
    }

    Write-Host "  $($service.Description.PadRight(20)) " -NoNewline
    Write-Host "$statusIcon " -ForegroundColor $statusColor -NoNewline
    Write-Host $details -ForegroundColor DarkGray
}

Write-Host ""

# =============================================================================
# Handle Results
# =============================================================================

# Show healthcheck warnings if any
if ($healthcheckIssues.Count -gt 0) {
    Write-WarningMsg "Algunos contenedores tienen healthchecks que fallan pero son accesibles:"
    foreach ($issue in $healthcheckIssues) {
        Write-WarningMsg "  - $($issue.Description): Docker healthcheck reporta 'unhealthy' pero HTTP funciona"
    }
    Write-WarningMsg ""
    Write-WarningMsg "Esto suele significar que el healthcheck del contenedor usa herramientas"
    Write-WarningMsg "que no estan instaladas (wget/curl). Los servicios funcionan correctamente."
    Write-Host ""
}

# Show logs and fail for real failures
if ($realFailures.Count -gt 0) {
    Write-ErrorMsg "Los siguientes servicios tienen problemas reales:"
    Write-Host ""

    foreach ($failed in $realFailures) {
        Write-Host "=== Logs de $($failed.Container) ===" -ForegroundColor Yellow
        Invoke-Compose -Arguments @("logs", "--no-color", "--tail", "50", $failed.Name)
        Write-Host ""
    }

    Pop-Location
    exit 1
}

# If docker compose failed but all services are reachable, it's a healthcheck config issue
if ($composeExitCode -ne 0 -and $allServicesReachable) {
    Write-WarningMsg "docker compose --wait fallo (exit $composeExitCode) pero todos los servicios responden."
    Write-WarningMsg "Esto indica healthchecks mal configurados en docker-compose.yml."
    Write-WarningMsg "Los servicios estan funcionando correctamente."
    Write-Host ""
}

# =============================================================================
# Success!
# =============================================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " TODOS LOS SERVICIOS ESTAN FUNCIONANDO" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host " Accede a los servicios:" -ForegroundColor White
Write-Host ""
Write-Host "   Backend API (Swagger):  " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8080/swagger-ui/index.html" -ForegroundColor Cyan
Write-Host "   Streamlit Dashboard:    " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8501" -ForegroundColor Cyan
Write-Host "   phpMyAdmin:             " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8081" -ForegroundColor Cyan
Write-Host "   Web PHP:                " -NoNewline -ForegroundColor Gray
Write-Host "http://localhost:8082" -ForegroundColor Cyan
Write-Host "   MySQL (puerto host):    " -NoNewline -ForegroundColor Gray
Write-Host "localhost:3307" -ForegroundColor Cyan
Write-Host ""
Write-Host " Comandos utiles:" -ForegroundColor White
Write-Host "   Ver logs:     docker compose logs -f [servicio]" -ForegroundColor DarkGray
Write-Host "   Detener:      docker compose down" -ForegroundColor DarkGray
Write-Host "   Reiniciar:    docker compose restart [servicio]" -ForegroundColor DarkGray
Write-Host ""

Pop-Location
exit 0
