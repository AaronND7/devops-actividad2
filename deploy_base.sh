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
