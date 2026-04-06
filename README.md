# 🚀 Actividad 2: Automatización y Despliegue Controlado en AWS con Enfoque DevOps

## 🎯 Objetivo
Diseñar e implementar una solución de automatización en AWS que integre gestión de instancias EC2, respaldos S3, control de versiones y simulación CI/CD.

## 📁 Estructura del Proyecto
```
project-devops/
│
├── ec2/
│   └── gestionar_ec2.py
│
├── s3/
│   └── backup_s3.sh
│
├── logs/
│
├── config/
│   └── config.env
│
└── README.md
```

## 🌿 Flujo Git
- `main` → versión estable
- `develop` → integración  
- `feature/*` → desarrollo de funcionalidades

## ⚙️ Requisitos
- AWS CLI configurado
- Python 3 con boto3
- Git
- Acceso a AWS

## 🚀 Uso
```bash
# Gestionar EC2
python3 ec2/gestionar_ec2.py listar
python3 ec2/gestionar_ec2.py iniciar i-123456

# Backup S3
bash s3/backup_s3.sh ./data mi-bucket-devops

# Orquestación
./deploy.sh iniciar i-123456 ./data mi-bucket-devops
```

## 🔄 Flujo DevOps
Feature → Commit → Push → Merge → Deploy → AWS
