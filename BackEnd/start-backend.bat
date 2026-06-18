@echo off
:: Configuración por defecto para iniciar los servicios de backend y base de datos locales (sin el Frontend)
set DB_HOST=localhost
set DB_PORT=5432
set DB_USERNAME=postgres
set DB_PASSWORD=route

set IDENTITY_DB_NAME=sanos_y_salvos_identity
set GEOLOCATION_DB_NAME=sanos_y_salvos_geo

set LOCAL_IDENTITY_URL=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%IDENTITY_DB_NAME%
set LOCAL_GEO_URL=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%GEOLOCATION_DB_NAME%
set LOCAL_MONGODB_URI=mongodb://localhost:27017/ms-reporting_db

echo Iniciando base de datos y microservicios de Sanos y Salvos...

:: Limpiamos variables de entorno conflictivas en el proceso padre antes de lanzar los sub-procesos
set SPRING_DATASOURCE_URL=
set SPRING_DATASOURCE_USERNAME=
set SPRING_DATASOURCE_PASSWORD=
set IDENTITY_DB_URL=
set IDENTITY_DB_USERNAME=
set IDENTITY_DB_PASSWORD=
set MONGODB_URI=
set REPORTING_MONGODB_URI=

:: Intentamos iniciar los servicios de base de datos de Windows en caso de que estén apagados
echo Intentando verificar/iniciar PostgreSQL y MongoDB locales...
net start postgresql-x64-16 >nul 2>&1
net start MongoDB >nul 2>&1

:: Iniciar microservicios de Spring Boot
start "ms-identity" cmd /k "cd ms-identity && title ms-identity && set IDENTITY_DB_URL=%LOCAL_IDENTITY_URL%&& set IDENTITY_DB_USERNAME=%DB_USERNAME%&& set IDENTITY_DB_PASSWORD=%DB_PASSWORD%&& .\mvnw.cmd spring-boot:run"

start "ms-reporting" cmd /k "cd ms-reporting && title ms-reporting && set MONGODB_URI=%LOCAL_MONGODB_URI%&& set REPORTING_MONGODB_URI=%LOCAL_MONGODB_URI%&& .\mvnw.cmd spring-boot:run"

start "ms-geolocation" cmd /k "cd ms-geolocation && title ms-geolocation && set SPRING_DATASOURCE_URL=%LOCAL_GEO_URL%&& set SPRING_DATASOURCE_USERNAME=%DB_USERNAME%&& set SPRING_DATASOURCE_PASSWORD=%DB_PASSWORD%&& .\mvnw.cmd spring-boot:run"

:: Iniciar el API Gateway
start "sanos-y-salvos-gateway" cmd /k "cd sanos-y-salvos-gateway && title gateway && .\mvnw.cmd spring-boot:run"

echo Todos los servicios de base de datos y backend se estan iniciando en ventanas separadas (Frontend excluido).
