#!/bin/bash
set -e

echo "=== Desplegando Telederma con Docker ==="

# Verificar .env
if [ ! -f .env ]; then
    echo "ERROR: Crea el archivo .env basándote en .env.example"
    exit 1
fi

# Construir imagen
echo ">>> Construyendo imagen..."
docker-compose build

# Iniciar base de datos
echo ">>> Iniciando base de datos..."
docker-compose up -d db
sleep 5

# Ejecutar migraciones
echo ">>> Ejecutando migraciones..."
docker-compose run --rm web bundle exec rails db:migrate

# Iniciar aplicación
echo ">>> Iniciando aplicación..."
docker-compose up -d

echo "=== Telederma disponible en http://localhost:3000 ==="
