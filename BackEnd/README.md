# Sanos y Salvos Backend

Backend del proyecto **Sanos y Salvos**, construido con una arquitectura basada en microservicios usando **Spring Boot**. El sistema incluye servicios para autenticacion, reportes de mascotas, geolocalizacion y un API Gateway para centralizar el acceso.

## Descripcion General

Este repositorio contiene varios servicios independientes:

- `ms-identity`: registro, login y gestion basica de usuarios.
- `ms-reporting`: creacion y listado de reportes de mascotas.
- `ms-geolocation`: almacenamiento y consulta de ubicaciones.
- `sanos-y-salvos-gateway`: gateway de entrada para enrutar solicitudes a los microservicios.

## Arquitectura

| Componente | Puerto | Funcion | Base de datos |
| --- | --- | --- | --- |
| `ms-identity` | `8081` | Registro, login y usuarios | PostgreSQL |
| `ms-reporting` | `8082` | Reportes de mascotas | MongoDB |
| `ms-geolocation` | `8083` | Geolocalizacion | PostgreSQL |
| `api-gateway` | `8080` | Enrutamiento centralizado | No aplica |

## Tecnologias

- Java 21
- Spring Boot 4
- Spring Data JPA
- Spring Data MongoDB
- Spring Cloud Gateway
- PostgreSQL
- MongoDB
- Maven Wrapper
- Lombok

## Estructura Del Proyecto

```text
.
|- ms-identity/
|- ms-reporting/
|- ms-geolocation/
|- sanos-y-salvos-gateway/
|- backend/
|- start-all.ps1
`- README.md
```

## Requisitos Previos

Antes de ejecutar el proyecto, asegurate de tener instalado:

- Java 21
- Maven (opcional, porque el proyecto incluye `mvnw` y `mvnw.cmd`)
- PostgreSQL
- MongoDB
- PowerShell, si vas a usar `start-all.ps1`

## Bases De Datos

### PostgreSQL

Se esperan al menos estas bases:

- `sanos_y_salvos_identity`
- `sanos_y_salvos_geo`

### MongoDB

Se utiliza la base:

- `ms-reporting_db`

## Variables De Entorno

### `ms-identity`

```properties
IDENTITY_DB_URL=jdbc:postgresql://localhost:5432/sanos_y_salvos_identity
IDENTITY_DB_USERNAME=postgres
IDENTITY_DB_PASSWORD=route
```

### `ms-reporting`

```properties
REPORTING_MONGODB_URI=mongodb://localhost:27017/ms-reporting_db
```

### `ms-geolocation`

```properties
SPRING_DATASOURCE_PASSWORD=route
```

Notas:

- `ms-geolocation` usa por defecto `jdbc:postgresql://localhost:5432/sanos_y_salvos_geo`
- `ms-geolocation` usa por defecto el usuario `postgres`
- `ms-identity` y `ms-reporting` soportan variables de entorno configurables desde sus `application.properties`

## Ejecucion Del Proyecto

### Opcion 1: Levantar servicios manualmente

#### 1. Iniciar `ms-identity`

En Windows:

```powershell
cd .\ms-identity
.\mvnw.cmd spring-boot:run
```

En Linux o macOS:

```bash
cd ms-identity
./mvnw spring-boot:run
```

#### 2. Iniciar `ms-reporting`

En Windows:

```powershell
cd .\ms-reporting
.\mvnw.cmd spring-boot:run
```

#### 3. Iniciar `ms-geolocation`

En Windows:

```powershell
cd .\ms-geolocation
.\mvnw.cmd spring-boot:run
```

#### 4. Iniciar el gateway

En Windows:

```powershell
cd .\sanos-y-salvos-gateway
.\mvnw.cmd spring-boot:run
```

### Opcion 2: Script PowerShell

El repositorio incluye un script llamado `start-all.ps1`.

```powershell
.\start-all.ps1
```

Importante:

- Este script configura variables de entorno de forma manual.
- Actualmente inicia `ms-identity` y `ms-reporting`.
- La contrasena configurada por defecto para PostgreSQL es `route`.
- Si deseas levantar `ms-geolocation` y el gateway, debes hacerlo manualmente.

## Rutas Del Gateway

Una vez levantado el gateway en `http://localhost:8080`, las rutas principales son:

| Ruta gateway | Destino |
| --- | --- |
| `/api/auth/**` | `ms-identity` |
| `/api/reportes/**` | `ms-reporting` |
| `/api/geo/**` | `ms-geolocation` |

## Endpoints Principales

### Identity

Base URL directa: `http://localhost:8081`

Base URL por gateway: `http://localhost:8080/api/auth`

| Metodo | Endpoint | Descripcion |
| --- | --- | --- |
| `GET` | `/api/auth/usuarios` | Lista usuarios |
| `POST` | `/api/auth/register` | Registra un usuario |
| `POST` | `/api/auth/usuarios` | Crea un usuario |
| `POST` | `/api/auth/login` | Inicia sesion |

#### Ejemplo de registro

```json
{
  "email": "usuario@correo.com",
  "password": "123456",
  "nombre": "Juan Perez",
  "rol": "USER"
}
```

#### Ejemplo de login

```json
{
  "email": "usuario@correo.com",
  "password": "123456"
}
```

### Reporting

Base URL directa: `http://localhost:8082`

Base URL por gateway: `http://localhost:8080/api/reportes`

| Metodo | Endpoint | Descripcion |
| --- | --- | --- |
| `GET` | `/api/reportes` | Lista reportes |
| `POST` | `/api/reportes` | Crea un reporte |

#### Ejemplo de reporte

```json
{
  "tipoAnimal": "Perro",
  "descripcion": "Perro extraviado cerca de la plaza",
  "ubicacionId": 1,
  "usuarioId": 1,
  "estado": "ACTIVO"
}
```

### Geolocation

Base URL directa: `http://localhost:8083`

Base URL por gateway: `http://localhost:8080/api/geo`

| Metodo | Endpoint | Descripcion |
| --- | --- | --- |
| `POST` | `/api/geo/ubicar` | Registra una ubicacion |
| `GET` | `/api/geo/historial` | Lista ubicaciones registradas |

#### Ejemplo de ubicacion

```json
{
  "latitud": -33.4489,
  "longitud": -70.6693,
  "nombreSector": "Santiago Centro"
}
```

`fechaRegistro` se asigna automaticamente si no se envia en el request.

## Pruebas

Para ejecutar pruebas en un microservicio:

```powershell
cd .\ms-identity
.\mvnw.cmd test
```

Repite el mismo patrón en `ms-reporting`, `ms-geolocation` o `sanos-y-salvos-gateway`.

## Observaciones

- El login actual genera un token UUID de forma simple y no implementa JWT.
- Las contraseñas se almacenan en texto plano, por lo que no se recomienda este enfoque para produccion.
- El gateway principal del proyecto esta configurado con Spring Cloud Gateway en el puerto `8080`.
- Existe un archivo `index.js` dentro del directorio del gateway, pero la configuracion principal del enrutamiento del backend se encuentra en `application.yml`.

## Autores

Proyecto desarrollado para **Sanos y Salvos**.
