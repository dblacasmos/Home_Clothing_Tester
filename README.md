# 🧥 Home Clothing Tester
[🇪🇸 Español](./README.es.md) | [🇬🇧 English](./README.md)

Home Clothing Tester is a **full-stack web application** oriented to e-commerce use cases. It allows users to explore a clothing catalog, use a **non-adaptive camera preview**, manage favorites and user accounts, and operate the system through an administration panel and a metrics dashboard.

The project is designed as a **deployable and reproducible system** on Windows environments using Docker and PowerShell.

---

## 📦 Technologies Used

### Web / Product
- PHP (MVC)
- HTML, CSS, JavaScript (Vanilla)
- Camera Preview via Web APIs (non-adaptive)

### Backend & Data
- Java (Spring Boot)
- MySQL 8

### Observability
- Streamlit (Dashboard)

### Infrastructure
- Docker & Docker Compose
- PowerShell + WinGet (Windows 10/11)

---

## 🧪 Main Features

### 🔹 User Experience
- Clothing catalog exploration.
- Integrated camera preview (real-time visualization, non-adaptive).
- User authentication.
- Persistent favorites management.
- Role-based flows (user / administrator).

### 🔹 System Operation
- User administration panel.
- User state control (active / blocked).
- Basic usage and sales metrics.
- Reporting dashboard built with Streamlit.
- Post-deployment integrity verification scripts.

---

## 📁 Project Structure (summary)

```text
home-clothing-tester/
├── apps/
│   ├── backend-api/        # Java API (Spring Boot)
│   └── streamlit/          # Dashboard
├── web-php/                # PHP web application (MVC)
├── database/               # MySQL initialization scripts
├── docs/                   # UML diagrams and models
├── scripts/                # PowerShell deployment scripts
├── docker-compose.yml
└── README.md
```

---

## 🚀 Running the Project (Windows 10/11)
Requirements
- Windows with WinGet installed.
- PowerShell executed as Administrator.

Steps
```powershell
cd scripts
.\setup_and_run.ps1
```

The script:
- Verifies or installs Docker Desktop.
- Waits until Docker is fully running.
- Detects Docker Compose.
- Starts all services using containers.

---

## 🌐 Services & Ports
- 🌐 PHP Web App: http://localhost:8082
- 🔧 Spring Boot API: http://localhost:8080
- 📊 Streamlit Dashboard: http://localhost:8501
- 🛢 MySQL: localhost:3307
- 🗄 phpMyAdmin: http://localhost:8081

---

## 🧪 Verification Scripts
Utility scripts used to ensure system integrity after deployment:
- controllers/admin/comprobar_rutas.php
Verifies the existence of critical project paths.
- scripts/setup_and_run.ps1
Reproducible system startup on Windows.

Expected output example:

```text
Summary: OK=18 | ERRORS=0
```

---

## 📐 Technical Documentation
- Use case diagrams.
- Domain model.
- Entity–relationship model (MySQL).

Location:
```bash
docs/uml/
```

---

## 📋 Credits
Project and development: David Blanco
Main stack: PHP · Java · MySQL · Docker · Streamlit
