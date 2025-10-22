# 🧥 Home Clothing Tester
[🇬🇧 English](./README.md) | [🇪🇸 Spanish](./README.es.md)

Home Clothing Tester is a web application that allows users to **virtually try on clothes using their camera**, select favorite garments, and manage their accounts.  
This README covers both its functionality and deployment in a Windows environment using **Docker** and **PowerShell**.

---

## 📦 Technologies Used

- **Frontend:** HTML, CSS, JS (Vanilla), TensorFlow.js, MediaPipe, Three.js  
- **Backend:** Java (Spring Boot)  
- **Database / Backend Integration:** MySQL 8 / React  
- **Dashboard:** Streamlit  
- **Containers:** Docker + Docker Compose  
- **Automation:** PowerShell + WinGet (Windows 10/11)

---

## 🧪 Main Features

### 🔹 Web Functionality

- Try on clothes virtually using your camera.  
- User authentication system.  
- Favorites management system.  
- Separate dashboards for users and administrators.  
- Scripts for verifying paths, images, and dynamic product loading.

### 🔹 Main Components

- `index.php`: Homepage with product listings.  
- `login.php + form_login.php`: User authentication.  
- `prueba_virtual.php`: Virtual fitting room (TensorFlow.js).  
- `agregar_favoritos.php`: Manage favorite items.  
- `cambiar_estado_usuario.php`: Admin tool for managing user states.  
- CSS files (`main.css`, `usuario.css`, `admin.css`) and JS files (`script.js`, `probador_virtual.js`).

---

## 📁 Project Structure

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
```

---

## 🚀 How to Run (Windows 10/11)

### Requirements

- Windows with [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/) installed.  
- Run as **Administrator**.

### Step by Step

1. Open **IntelliJ IDEA**.  
2. Run the script:  
   ```bash
   scripts/setup_and_run.ps1
   ```

This script will:

- Install Docker Desktop (if not installed).  
- Wait until Docker is running.  
- Verify Docker Compose installation.  
- Launch MySQL, Java API, and Streamlit dashboard containers.

### Default Ports

- 🛢 MySQL: `localhost:3306`  
- 🌐 API (Spring Boot): `localhost:8080`  
- 📊 Dashboard (Streamlit): `localhost:8501`

---

## 🧰 Docker Compose

`docker-compose.yml` includes:

- **MySQL** with a persistent volume and initialization script.  
- **Java Backend API** connected to the database.  
- **Streamlit Dashboard** connected to MySQL.

---

## 🧪 Verification Scripts

- `comprobar_rutas.php`: Verifies image paths.  
- `comprobar_imagenes.php`: Checks image loading.  
- `get_prendas.php`: Displays dynamically filtered garments.

---

## 📋 Credits

- Demo & Development: **David Blanco**  
- Java Framework: Spring Boot  
- Frontend JS: TensorFlow.js, MediaPipe, Three.js

---
