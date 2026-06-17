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

$env:IDENTITY_DB_URL = "jdbc:postgresql://${dbHost}:${dbPort}/${identityDbName}"
$env:IDENTITY_DB_USERNAME = $dbUsername
$env:IDENTITY_DB_PASSWORD = $dbPassword

$env:SPRING_DATASOURCE_URL = "jdbc:postgresql://${dbHost}:${dbPort}/${geoDbName}"
$env:SPRING_DATASOURCE_USERNAME = $dbUsername
$env:SPRING_DATASOURCE_PASSWORD = $dbPassword

$env:MONGODB_URI = if ($env:MONGODB_URI) { $env:MONGODB_URI } else { "mongodb://localhost:27017/ms-reporting_db" }
$env:REPORTING_MONGODB_URI = $env:MONGODB_URI
# ------------------------------------

$identityCommand = @"
`$env:IDENTITY_DB_URL = '$($env:IDENTITY_DB_URL)'
`$env:IDENTITY_DB_USERNAME = '$($env:IDENTITY_DB_USERNAME)'
`$env:IDENTITY_DB_PASSWORD = '$($env:IDENTITY_DB_PASSWORD)'
Set-Location '$identityPath'
.\mvnw.cmd spring-boot:run
"@

$reportingCommand = @"
`$env:MONGODB_URI = '$($env:MONGODB_URI)'
`$env:REPORTING_MONGODB_URI = '$($env:REPORTING_MONGODB_URI)'
Set-Location '$reportingPath'
.\mvnw.cmd spring-boot:run
"@

$geoCommand = @"
`$env:SPRING_DATASOURCE_URL = '$($env:SPRING_DATASOURCE_URL)'
`$env:SPRING_DATASOURCE_USERNAME = '$($env:SPRING_DATASOURCE_USERNAME)'
`$env:SPRING_DATASOURCE_PASSWORD = '$($env:SPRING_DATASOURCE_PASSWORD)'
Set-Location '$geoPath'
.\mvnw.cmd spring-boot:run
"@

$gatewayCommand = @"
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