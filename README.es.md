# 🧥 Home Clothing Tester
[🇪🇸 Español](./README.es.md) | [🇬🇧 English](./README.md)

Home Clothing Tester es una **aplicación web full-stack** orientada a e-commerce que permite explorar un catálogo de prendas, utilizar **camera preview no adaptativo**, gestionar favoritos y cuentas de usuario, y operar el sistema mediante panel de administración y dashboard de métricas.

El proyecto está diseñado como un **sistema desplegable y reproducible** en entorno Windows usando Docker y PowerShell.

---

## 📦 Tecnologías Usadas

### Web / Producto
- PHP (MVC)
- HTML, CSS, JavaScript (Vanilla)
- Camera Preview vía Web APIs (no adaptativo)

### Backend & Datos
- Java (Spring Boot)
- MySQL 8

### Observabilidad
- Streamlit (Dashboard)

### Infraestructura
- Docker & Docker Compose
- PowerShell + WinGet (Windows 10/11)

---

## 🧪 Funcionalidades Principales

### 🔹 Experiencia de Usuario
- Exploración de catálogo de prendas.
- Camera preview integrada (visualización en tiempo real, no adaptativa).
- Autenticación de usuarios.
- Gestión de favoritos persistentes.
- Flujos diferenciados por rol (usuario / administrador).

### 🔹 Operación del Sistema
- Panel de administración de usuarios.
- Control de estado (activo / bloqueado).
- Métricas básicas de uso y ventas.
- Dashboard de reporting con Streamlit.
- Scripts de verificación de integridad tras despliegue.

---

## 📁 Estructura del Proyecto (resumen)

```placetext
home-clothing-tester/
├── apps/
│ ├── backend-api/ # API Java (Spring Boot)
│ └── streamlit/ # Dashboard
├── web-php/ # Aplicación web PHP (MVC)
├── database/ # Scripts de inicialización MySQL
├── docs/ # Diagramas UML y modelos
├── scripts/ # PowerShell (deploy)
├── docker-compose.yml
└── README.md
```

---

## 🚀 Ejecución en Windows (10/11)

### Requisitos
- Windows con **WinGet** instalado.
- Ejecutar PowerShell como **Administrador**.

### Pasos
```powershell
cd scripts
.\setup_and_run.ps1
```

El script:

- Verifica/instala Docker Desktop.
- Espera a que Docker esté operativo.
- Detecta Docker Compose.
- Levanta todos los servicios en contenedores.

---

## 🌐 Servicios y Puertos
- 🌐 Web PHP: http://localhost:8082
- 🔧 API Spring Boot: http://localhost:8080
- 📊 Dashboard Streamlit: http://localhost:8501
- 🛢 MySQL: localhost:3307
- 🗄 phpMyAdmin: http://localhost:8081

---

## 🧪 Scripts de Verificación
Scripts utilitarios para asegurar integridad tras despliegue:
- controllers/admin/comprobar_rutas.php
Verifica la existencia de rutas críticas del proyecto.
- scripts/setup_and_run.ps1
Arranque reproducible del sistema en Windows.

Ejemplo de salida esperada:
```makefile
Resumen: OK=18 | ERRORES=0
```

---

## 📐 Documentación Técnica
- Diagramas de casos de uso.
- Modelo de dominio.
- Modelo entidad–relación (MySQL).

Ubicación:
```bash
docs/uml/
```

## 📋 Créditos
Proyecto y desarrollo: David Blanco
Stack principal: PHP · Java · MySQL · Docker · Streamlit
