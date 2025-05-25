#!/bin/bash

echo "Iniciando proceso de generación de ZIP..."

# Definir las rutas de los archivos zip
BACKEND_ZIP="backend.zip"
FRONTEND_ZIP="frontend.zip"

# Remover los antiguos archivos zip si existen
if [ -f "$BACKEND_ZIP" ]; then
    rm "$BACKEND_ZIP"
    echo "Eliminado archivo existente $BACKEND_ZIP"
fi

if [ -f "$FRONTEND_ZIP" ]; then
    rm "$FRONTEND_ZIP"
    echo "Eliminado archivo existente $FRONTEND_ZIP"
fi

# Crear nuevos archivos zip para backend y frontend
if [ -d "backend" ]; then
    cd backend && zip -r "../$BACKEND_ZIP" . && cd ..
    echo "Creado $BACKEND_ZIP"
else
    echo "Error: Directorio backend no encontrado"
    exit 1
fi

if [ -d "frontend" ]; then
    cd frontend && zip -r "../$FRONTEND_ZIP" . && cd ..
    echo "Creado $FRONTEND_ZIP"
else
    echo "Error: Directorio frontend no encontrado"
    exit 1
fi

echo "Proceso de generación de ZIP completado"

# Verificar que los archivos se crearon correctamente
if [ -f "$BACKEND_ZIP" ] && [ -f "$FRONTEND_ZIP" ]; then
    echo "Verificación completada: Ambos archivos ZIP fueron creados correctamente"
    ls -lh "$BACKEND_ZIP" "$FRONTEND_ZIP"
else
    echo "Error: No se pudieron crear todos los archivos ZIP"
    exit 1
fi