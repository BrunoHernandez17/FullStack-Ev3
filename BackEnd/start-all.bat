@echo off
:: Configuración por defecto para iniciar los servicios locales
set DB_HOST=localhost
set DB_PORT=5432
set DB_USERNAME=postgres
set DB_PASSWORD=route

set IDENTITY_DB_NAME=sanos_y_salvos_identity
set GEOLOCATION_DB_NAME=sanos_y_salvos_geo

set LOCAL_IDENTITY_URL=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%IDENTITY_DB_NAME%
set LOCAL_GEO_URL=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%GEOLOCATION_DB_NAME%
set LOCAL_MONGODB_URI=mongodb://localhost:27017/ms-reporting_db

echo Iniciando servicios de Sanos y Salvos...

:: Limpiamos variables de entorno conflictivas en el proceso padre antes de lanzar los sub-procesos
set SPRING_DATASOURCE_URL=
set SPRING_DATASOURCE_USERNAME=
set SPRING_DATASOURCE_PASSWORD=
set IDENTITY_DB_URL=
set IDENTITY_DB_USERNAME=
set IDENTITY_DB_PASSWORD=
set MONGODB_URI=
set REPORTING_MONGODB_URI=

start "ms-identity" cmd /k "cd ms-identity && title ms-identity && set IDENTITY_DB_URL=%LOCAL_IDENTITY_URL%&& set IDENTITY_DB_USERNAME=%DB_USERNAME%&& set IDENTITY_DB_PASSWORD=%DB_PASSWORD%&& .\mvnw.cmd spring-boot:run"

start "ms-reporting" cmd /k "cd ms-reporting && title ms-reporting && set MONGODB_URI=%LOCAL_MONGODB_URI%&& set REPORTING_MONGODB_URI=%LOCAL_MONGODB_URI%&& .\mvnw.cmd spring-boot:run"

start "ms-geolocation" cmd /k "cd ms-geolocation && title ms-geolocation && set SPRING_DATASOURCE_URL=%LOCAL_GEO_URL%&& set SPRING_DATASOURCE_USERNAME=%DB_USERNAME%&& set SPRING_DATASOURCE_PASSWORD=%DB_PASSWORD%&& .\mvnw.cmd spring-boot:run"

start "sanos-y-salvos-gateway" cmd /k "cd sanos-y-salvos-gateway && title gateway && .\mvnw.cmd spring-boot:run"

start "FrontEnd" cmd /k "cd ..\FrontEnd && title FrontEnd && npm run dev"

echo Todos los servicios se estan iniciando en ventanas separadas.
