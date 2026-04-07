# 🚀 Actividad 2: Automatización y Despliegue Controlado en AWS con Enfoque DevOps

## 🎯 Objetivo
Diseñar e implementar una solución de automatización en AWS que integre gestión de instancias EC2, respaldos S3, control de versiones y simulación CI/CD.

## � Descripción del Proyecto
Este proyecto implementa un flujo DevOps completo que automatiza la gestión de infraestructura en AWS mediante scripts de Python y Bash. Incluye gestión de instancias EC2, backups automáticos a S3, control de versiones con Git y GitHub, y un orquestador que simula un pipeline CI/CD.

## �📁 Estructura del Proyecto
```
project-devops/
│
├── ec2/
│   └── gestionar_ec2.py      # Script Python para gestión EC2
│
├── s3/
│   └── backup_s3.sh          # Script Bash para backups S3
│
├── logs/                      # Directorio para logs de ejecución
│
├── config/
│   └── config.env            # Archivo de configuración
│
├── deploy.sh                  # Orquestador CI/CD simulado
└── README.md                  # Documentación del proyecto
```

## 🌿 Flujo Git
- `main` → versión estable (producción)
- `develop` → integración (staging)
- `feature/*` → desarrollo de funcionalidades

**Flujo de trabajo:**
1. Crear rama `feature/*`
2. Desarrollar funcionalidad con commits progresivos
3. Push a GitHub y crear Pull Request
4. Merge a `develop`
5. Merge a `main`

## ⚙️ Requisitos
- AWS CLI configurado
- Python 3 con boto3 instalado
- Git configurado
- GitHub CLI (gh) instalado
- Acceso a servicios AWS (EC2, S3)

## 🚀 Instrucciones de Uso

### Configuración inicial
```bash
# Clonar repositorio
git clone https://github.com/AaronND7/devops-actividad2.git
cd devops-actividad2

# Configurar variables (opcional)
cp config/config.env.example config/config.env
# Editar config.env con tus valores
```

### Gestión de instancias EC2
```bash
# Listar todas las instancias
python3 ec2/gestionar_ec2.py listar

# Iniciar una instancia
python3 ec2/gestionar_ec2.py iniciar i-1234567890abcdef0

# Detener una instancia
python3 ec2/gestionar_ec2.py detener i-1234567890abcdef0

# Terminar una instancia
python3 ec2/gestionar_ec2.py terminar i-1234567890abcdef0
```

### Backup a S3
```bash
# Crear backup de directorio
bash s3/backup_s3.sh ./data mi-bucket-devops

# El script creará:
# - Archivo comprimido: backup_data_YYYYMMDD_HHMMSS.tar.gz
# - Log de ejecución: logs/backup_YYYYMMDD_HHMMSS.log
# - Subida automática a S3
```

### Orquestación CI/CD (deploy.sh)
```bash
# Ejecutar flujo completo (EC2 + S3)
./deploy.sh listar i-1234567890abcdef0 ./data mi-bucket-devops

# Solo gestión EC2
./deploy.sh iniciar i-1234567890abcdef0

# Solo backup S3
./deploy.sh listar i-1234567890abcdef0 ./data mi-bucket-devops
```

## � Ejemplos de uso prácticos

### Escenario 1: Inicializar instancia y hacer backup
```bash
# 1. Iniciar instancia EC2
python3 ec2/gestionar_ec2.py iniciar i-0a204a4a3b31776da

# 2. Esperar a que esté running
python3 ec2/gestionar_ec2.py listar

# 3. Hacer backup de datos importantes
bash s3/backup_s3.sh ./important-data mi-backup-prod

# 4. Or todo junto con deploy.sh
./deploy.sh iniciar i-0a204a4a3b31776da ./important-data mi-backup-prod
```

### Escenario 2: Monitoreo y backup programado
```bash
# 1. Ver estado actual
python3 ec2/gestionar_ec2.py listar

# 2. Backup de logs del día
bash s3/backup_s3.sh ./logs mi-logs-bucket

# 3. Orquestación completa
./deploy.sh listar i-0a204a4a3b31776da ./logs mi-logs-bucket
```

## �🔄 Flujo DevOps Completo
```
Feature Development → Git Commits → GitHub Push → 
Pull Request → Code Review → Merge to Develop → 
Merge to Main → Deploy.sh Execution → 
AWS Integration (EC2 + S3) → Production
```

## 🔧 Configuración de Variables
El archivo `config/config.env` contiene:
```bash
REGION=us-east-1
INSTANCE_ID=i-1234567890abcdef0
BUCKET_NAME=mi-bucket-devops
DIRECTORY=./data
LOG_LEVEL=INFO
LOG_RETENTION_DAYS=30
```

## 📊 Logs y Monitoreo
- **Logs de deploy:** `logs/deploy_YYYYMMDD_HHMMSS.log`
- **Logs de backup:** `logs/backup_YYYYMMDD_HHMMSS.log`
- **Logs de EC2:** Integrados en deploy.sh

## 🚨 Buenas Prácticas Implementadas
- ✅ Sin hardcoding - todo parametrizado
- ✅ Commits progresivos y descriptivos
- ✅ Configuración separada del código
- ✅ Manejo de errores robusto
- ✅ Logging centralizado
- ✅ Scripts reutilizables

## 🔗 Enlaces Útiles
- **Repositorio GitHub:** https://github.com/AaronND7/devops-actividad2
- **Documentación AWS:** https://docs.aws.amazon.com/
- **Python Boto3:** https://boto3.amazonaws.com/

## 📞 Soporte
Para problemas o preguntas:
1. Revisar logs en directorio `logs/`
2. Verificar configuración en `config/config.env`
3. Validar credenciales de AWS
4. Revisar documentación de comandos específicos

---
**Autor:** Aaron Navarro Díaz  
**Fecha:** 6 de abril de 2026  
**Versión:** 1.0
