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

# Función para validar parámetros
validar_parametros() {
    if [ $# -lt 2 ]; then
        log "ERROR: Se requieren al menos 2 parámetros"
        echo "Uso: $0 <accion-ec2> <instance-id> [directorio] [bucket-s3]"
        exit 1
    fi
    
    log "✅ Parámetros validados correctamente"
}

# Función principal
main() {
    log "🚀 Iniciando proceso de deploy - CI/CD Simulado"
    log "Parámetros recibidos: $*"
    
    # Cargar configuración si existe
    CONFIG_FILE="config/config.env"
    cargar_configuracion
    
    # Establecer valores por defecto si no están en config
    REGION=${REGION:-"us-east-1"}
    
    # Validar parámetros
    validar_parametros "$@"
    
    # Parámetros
    ACCION_EC2=$1
    INSTANCE_ID=$2
    DIRECTORIO=${3:-$DIRECTORY}
    BUCKET=${4:-$BUCKET_NAME}
    
    # Ejecutar operación EC2
    log "🔄 Etapa 1: Gestión EC2"
    if ! ejecutar_ec2 "$ACCION_EC2" "$INSTANCE_ID"; then
        log "❌ Deploy fallido en etapa EC2"
        exit 1
    fi
    
    # Si se proporcionaron directorio y bucket, ejecutar backup
    if [ -n "$DIRECTORIO" ] && [ -n "$BUCKET" ]; then
        log "🔄 Etapa 2: Backup S3"
        if ! ejecutar_backup_s3 "$DIRECTORIO" "$BUCKET"; then
            log "❌ Deploy fallido en etapa de backup"
            exit 1
        fi
    else
        log "ℹ️  No se ejecutó backup (faltan parámetros directorio/bucket)"
    fi
    
    log "🎉 Deploy completado exitosamente"
    log "✅ Flujo DevOps completado: Feature → Commit → Push → Merge → Deploy → AWS"
}

# Crear directorio de logs si no existe
mkdir -p logs

# Ejecutar función principal con todos los argumentos
main "$@"
