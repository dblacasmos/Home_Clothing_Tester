# 🧥 Home Clothing Tester
[🇪🇸 Español](./README.es.md) | [🇬🇧 English](./README.md)

Home Clothing Tester es una aplicación web que permite a los usuarios visualizar prendas usando su webcam, seleccionar prendas favoritas y gestionar su cuenta. Este README cubre tanto su funcionalidad como su despliegue en entorno Windows usando Docker y PowerShell.

---

## 📦 Tecnologías Usadas

- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Backend**: Java (Spring Boot), PHP 8.2
- **Base de datos**: MySQL 8
- **Dashboard**: Streamlit
- **Contenedores**: Docker + Docker Compose
- **Automatización**: PowerShell + WinGet (Windows 10/11)

---

## 🧪 Funcionalidades Destacadas

### 🔹 Funcionalidad Web

- Vista previa de cámara para visualizar prendas (experimental, no adaptativa).
- Autenticación de usuarios.
- Sistema de favoritos.
- Paneles diferenciados para usuarios y administradores.
- Scripts para verificación de rutas, imágenes y carga dinámica de productos.

### 🔹 Componentes Principales

- `index.php`: Página de inicio con productos.
- `login.php + form_login.php`: Autenticación de usuarios.
- `prueba_virtual.php`: Vista previa de cámara para ver prendas (no adaptativa).
- `agregar_favoritos.php`: Gestión de favoritos.
- `cambiar_estado_usuario.php`: Gestión de estado de usuarios por admin.
- Archivos CSS (`main.css`, `usuario.css`, `admin.css`) y JS (`script.js`, `probador_virtual.js`).

---

## 📁 Estructura del Proyecto

```
home-clothing-tester/
├── apps/
│   ├── backend-api/
│   │   ├── Dockerfile
│   │   ├── pom.xml
│   │   └── src/
│   │       └── main/
│   │           ├── java/com.homeclothing.api/
│   │           │   ├── controller/
│   │           │   ├── dao/
│   │           │   ├── model/
│   │           │   └── service/
│   │           │       └── BackendApiApplication.java
│   │           └── resources/
│   │               └── application.yml
│   └── streamlit/
│       ├── Dockerfile
│       ├── requirements.txt
│       ├── .streamlit/
│       │   └── secrets.toml
│       └── app/
│           ├── __init__.py
│           └── streamlit-dashboard.py
├── web-php/
│   └── home-clothing-tester/
│       ├── assets/
│       │   ├── css/
│       │   ├── js/
│       │   ├── media/
│       │   └── images/
│       │       ├── icons/
│       │       ├── layout/
│       │       ├── models/
│       │       ├── prendas/
│       │       └── simulaciones/
│       ├── config/
│       ├── controllers/
│       │   ├── admin/
│       │   ├── comunes/
│       │   └── user/
│       ├── includes/
│       │   ├── nav/
│       │   │   ├── nav.php
│       │   │   ├── nav_admin.php
│       │   │   └── nav_user.php
│       │   ├── footer.php
│       │   ├── get_prendas.php
│       │   ├── header.php
│       │   └── login_form.php
│       └── views/
│           ├── admin/
│           │   ├── compras.php
│           │   ├── estadisticas_usuarios.php
│           │   ├── gasto_usuario.php
│           │   ├── lista_favoritos_usuarios.php
│           │   ├── lista_usuarios.php
│           │   ├── prendas_disponibles.php
│           │   ├── registros_pruebas_virtuales.php
│           │   ├── top_ventas_categorias.php
│           │   ├── top_ventas_prendas.php
│           │   └── usuarios_bloqueados.php
│           ├── comunes/
│           │   ├── catalogo_prendas.php
│           │   ├── comentarios.php
│           │   ├── historial_compras.php
│           │   └── index.php
│           └── user/
│               ├── detalles_compras.php
│               ├── favoritos.php
│               └── prueba_virtual.php
├── database/
│   ├── phpmyadmin/
│   ├── 00-disable-host-cache.sql
│   ├── 01-db_home_clothing_tester.sql
│   └── Dockerfile
├── docs/
│   ├── data-models/
│   │   ├── catalogo.xsd
│   │   └── catalogo_sample.json
│   └── uml/
│       ├── DiagramClass.png
│       ├── DiagramE-R.png
│       └── DiagramUse.png
├── scripts/
│   ├── reset-and-rebuild.ps1
│   ├── setup_and_run.ps1
├── docker-compose.yml
├── Dockerfile
├── .gitignore
├── home-clothing-tester.iml
└── pom.xml
---

## 🚀 Cómo Ejecutarlo (Windows 10/11)

### Requisitos

- Tener Windows con [WinGet](https://learn.microsoft.com/es-es/windows/package-manager/) instalado.
- Ejecutar como **Administrador**.

### Paso a Paso

1. Abre Intellij IDEA
2. Corre el script:
- scripts
    setup_and_run.ps1

Este script:

- Instala Docker Desktop (si no está).
- Espera que Docker esté corriendo.
- Verifica Docker Compose.
- Lanza los servicios MySQL, API Java y Streamlit en contenedores.

### Puertos por Defecto

- 🛢 MySQL: `localhost:3306`
- 🌐 API (Spring Boot): `localhost:8080`
- 📊 Dashboard (Streamlit): `localhost:8501`

---

## 🧰 Docker Compose

`docker-compose.yml` contiene:

- **MySQL** con volumen persistente y script de inicialización.
- **Backend API** en Java con conexión a la base.
- **Streamlit Dashboard** conectado a MySQL.

---

## 🧪 Scripts de Verificación

- `comprobar_rutas.php`: Verifica rutas de imágenes.
- `comprobar_imagenes.php`: Verifica carga de imágenes.
- `get_prendas.php`: Muestra prendas filtradas dinámicamente.

---

## 📋 Créditos

- Demo y desarrollo: **David Blanco**
- Framework Java: Spring Boot
- PHP con Apache para frontend web

---

