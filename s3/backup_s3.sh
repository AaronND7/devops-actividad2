#!/bin/bash

# Script para realizar backup de directorios a S3
# Autor: DevOps Student

# Variables
LOG_FILE="../logs/backup_$(date +%Y%m%d_%H%M%S).log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Función para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Función para validar parámetros
validar_parametros() {
    if [ $# -ne 2 ]; then
        log "ERROR: Se requieren exactamente 2 parámetros"
        echo "Uso: $0 <directorio> <bucket-s3>"
        exit 1
    fi
    
    DIRECTORIO=$1
    BUCKET=$2
    
    # Validar que el directorio exista
    if [ ! -d "$DIRECTORIO" ]; then
        log "ERROR: El directorio $DIRECTORIO no existe"
        exit 1
    fi
    
    # Validar que el directorio no esté vacío
    if [ -z "$(ls -A $DIRECTORIO)" ]; then
        log "ERROR: El directorio $DIRECTORIO está vacío"
        exit 1
    fi
    
    log "✅ Parámetros validados correctamente"
}

# Función para comprimir archivos
comprimir_archivos() {
    log "📦 Iniciando compresión de archivos..."
    
    NOMBRE_COMPRESO="backup_${DIRECTORIO//\//_}_${TIMESTAMP}.tar.gz"
    
    if tar -czf "$NOMBRE_COMPRESO" -C "$(dirname $DIRECTORIO)" "$(basename $DIRECTORIO)"; then
        log "✅ Compresión exitosa: $NOMBRE_COMPRESO"
        return 0
    else
        log "❌ Error en la compresión"
        return 1
    fi
}

# Función para subir a S3
subir_a_s3() {
    log "☁️ Iniciando subida a S3..."
    
    if aws s3 cp "$NOMBRE_COMPRESO" "s3://$BUCKET/"; then
        log "✅ Archivo subido exitosamente a s3://$BUCKET/$NOMBRE_COMPRESO"
        
        # Generar URL presignada (opcional)
        URL_PRESIGNADA=$(aws s3 presign "s3://$BUCKET/$NOMBRE_COMPRESO" --expires-in 3600)
        log "🔗 URL de acceso (1 hora): $URL_PRESIGNADA"
        
        return 0
    else
        log "❌ Error al subir archivo a S3"
        return 1
    fi
}

# Función para limpiar archivos temporales
limpiar_temporales() {
    log "🧹 Limpiando archivos temporales..."
    
    if [ -f "$NOMBRE_COMPRESO" ]; then
        rm "$NOMBRE_COMPRESO"
        log "✅ Archivo temporal eliminado: $NOMBRE_COMPRESO"
    fi
}

# Función principal
main() {
    log "🚀 Iniciando proceso de backup a S3"
    log "Directorio: $1"
    log "Bucket S3: $2"
    
    # Validar parámetros
    validar_parametros "$@"
    
    # Comprimir archivos
    if ! comprimir_archivos; then
        log "❌ Proceso fallido en etapa de compresión"
        exit 1
    fi
    
    # Subir a S3
    if ! subir_a_s3; then
        log "❌ Proceso fallido en etapa de subida"
        limpiar_temporales
        exit 1
    fi
    
    # Limpiar temporales
    limpiar_temporales
    
    log "🎉 Backup completado exitosamente"
    log "📋 Resumen:"
    log "   - Directorio origen: $DIRECTORIO"
    log "   - Bucket destino: $BUCKET"
    log "   - Archivo: $NOMBRE_COMPRESO"
    log "   - Log: $LOG_FILE"
}

# Ejecutar función principal con todos los argumentos
main "$@"
