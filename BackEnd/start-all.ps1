$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$identityPath = Join-Path $projectRoot "ms-identity"
$reportingPath = Join-Path $projectRoot "ms-reporting"
$geoPath = Join-Path $projectRoot "ms-geolocation"
$gatewayPath = Join-Path $projectRoot "sanos-y-salvos-gateway"
$frontendPath = Join-Path (Split-Path -Parent $projectRoot) "FrontEnd"

# --- CARGAR CONFIGURACION DESDE .ENV ---
$envFilePath = Join-Path (Split-Path -Parent $projectRoot) ".env"
if (-not (Test-Path $envFilePath)) {
    $envFilePath = Join-Path $projectRoot ".env"
}

if (Test-Path $envFilePath) {
    Write-Host "Info: Cargando variables de entorno desde $envFilePath..." -ForegroundColor Cyan
    Get-Content $envFilePath | Where-Object { $_ -match '=' -and $_ -notmatch '^#' } | ForEach-Object {
        $name, $value = $_ -split '=', 2
        $name = $name.Trim()
        $value = $value.Trim().Trim('"').Trim("'")
        [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
    }
} else {
    Write-Host "Alerta: Archivo .env no encontrado en la raiz. Usando valores por defecto." -ForegroundColor Yellow
}

# Valores por defecto en caso de no estar definidos en .env
$dbHost = if ($env:DB_HOST) { $env:DB_HOST } else { "localhost" }
$dbPort = if ($env:DB_PORT) { $env:DB_PORT } else { "5432" }
$dbUsername = if ($env:DB_USERNAME) { $env:DB_USERNAME } else { "postgres" }
$dbPassword = if ($env:DB_PASSWORD) { $env:DB_PASSWORD } else { "route" }

$identityDbName = if ($env:IDENTITY_DB_NAME) { $env:IDENTITY_DB_NAME } else { "sanos_y_salvos_identity" }
$geoDbName = if ($env:GEOLOCATION_DB_NAME) { $env:GEOLOCATION_DB_NAME } else { "sanos_y_salvos_geo" }

$identityDbUrl = "jdbc:postgresql://${dbHost}:${dbPort}/${identityDbName}"
$identityDbUsername = $dbUsername
$identityDbPassword = $dbPassword

$geoDbUrl = "jdbc:postgresql://${dbHost}:${dbPort}/${geoDbName}"
$geoDbUsername = $dbUsername
$geoDbPassword = $dbPassword

$mongodbUri = if ($env:MONGODB_URI) { $env:MONGODB_URI } else { "mongodb://localhost:27017/ms-reporting_db" }
# ------------------------------------

$identityCommand = @"
`$env:SPRING_DATASOURCE_URL = `$null
`$env:SPRING_DATASOURCE_USERNAME = `$null
`$env:SPRING_DATASOURCE_PASSWORD = `$null
`$env:IDENTITY_DB_URL = '$identityDbUrl'
`$env:IDENTITY_DB_USERNAME = '$identityDbUsername'
`$env:IDENTITY_DB_PASSWORD = '$identityDbPassword'
Set-Location '$identityPath'
.\mvnw.cmd spring-boot:run
"@

$reportingCommand = @"
`$env:MONGODB_URI = '$mongodbUri'
`$env:REPORTING_MONGODB_URI = '$mongodbUri'
Set-Location '$reportingPath'
.\mvnw.cmd spring-boot:run
"@

$geoCommand = @"
`$env:SPRING_DATASOURCE_URL = '$geoDbUrl'
`$env:SPRING_DATASOURCE_USERNAME = '$geoDbUsername'
`$env:SPRING_DATASOURCE_PASSWORD = '$geoDbPassword'
`$env:IDENTITY_DB_URL = `$null
`$env:IDENTITY_DB_USERNAME = `$null
`$env:IDENTITY_DB_PASSWORD = `$null
Set-Location '$geoPath'
.\mvnw.cmd spring-boot:run
"@

$gatewayCommand = @"
`$env:SPRING_DATASOURCE_URL = `$null
`$env:IDENTITY_DB_URL = `$null
Set-Location '$gatewayPath'
.\mvnw.cmd spring-boot:run
"@

$frontendCommand = @"
Set-Location '$frontendPath'
npm run dev
"@

# Lanzar procesos
Start-Process powershell -WorkingDirectory $identityPath -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $identityCommand
Start-Process powershell -WorkingDirectory $reportingPath -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $reportingCommand
Start-Process powershell -WorkingDirectory $geoPath -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $geoCommand
Start-Process powershell -WorkingDirectory $gatewayPath -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $gatewayCommand
Start-Process powershell -WorkingDirectory $frontendPath -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-Command", $frontendCommand

Write-Host "OK: Variables configuradas con contrasena ROUTE." -ForegroundColor Green
Write-Host "Start: Microservicios y FrontEnd lanzados en ventanas independientes."