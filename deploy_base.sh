#!/bin/bash

# Script de orquestación para CI/CD simulado
# Autor: DevOps Student

# Variables
LOG_FILE="logs/deploy_$(date +%Y%m%d_%H%M%S).log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Función para cargar configuración
cargar_configuracion() {
    if [ -f "$CONFIG_FILE" ]; then
        log "📋 Cargando configuración desde $CONFIG_FILE"
        source "$CONFIG_FILE"
        log "✅ Configuración cargada exitosamente"
        return 0
    else
        log "⚠️  Archivo de configuración no encontrado, usando parámetros de línea de comandos"
        return 1
    fi
}

# Función para ejecutar script EC2
ejecutar_ec2() {
    local accion=$1
    local instance_id=$2
    
    log "🖥️  Ejecutando operación EC2: $accion"
    
    if [ "$accion" = "listar" ]; then
        python3 ec2/gestionar_ec2.py listar --region $REGION
    elif [ "$accion" = "iniciar" ]; then
        python3 ec2/gestionar_ec2.py iniciar --instance-id "$instance_id" --region $REGION
    elif [ "$accion" = "detener" ]; then
        python3 ec2/gestionar_ec2.py detener --instance-id "$instance_id" --region $REGION
    elif [ "$accion" = "terminar" ]; then
        python3 ec2/gestionar_ec2.py terminar --instance-id "$instance_id" --region $REGION
    else
        log "❌ Acción EC2 no reconocida: $accion"
        return 1
    fi
    
    if [ $? -eq 0 ]; then
        log "✅ Operación EC2 completada exitosamente"
        return 0
    else
        log "❌ Error en operación EC2"
        return 1
    fi
}

# Función para ejecutar backup S3
ejecutar_backup_s3() {
    local directorio=$1
    local bucket=$2
    
    log "☁️  Ejecutando backup S3"
    
    if [ -z "$directorio" ] || [ -z "$bucket" ]; then
        log "❌ Se requieren directorio y bucket para el backup"
        return 1
    fi
    
    bash s3/backup_s3.sh "$directorio" "$bucket"
    
    if [ $? -eq 0 ]; then
        log "✅ Backup S3 completado exitosamente"
        return 0
    else
        log "❌ Error en backup S3"
        return 1
    fi
}
