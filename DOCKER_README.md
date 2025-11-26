# Telederma - Despliegue con Docker

## Requisitos
- Docker 20.10+
- Docker Compose 2.0+

## Despliegue rápido

### 1. Configurar variables de entorno
```bash
cp .env.example .env
# Editar .env con tus valores
```

### 2. Generar SECRET_KEY_BASE
```bash
docker run --rm ruby:3.4.1 ruby -rsecurerandom -e "puts SecureRandom.hex(64)"
```

### 3. Desplegar
```bash
./docker-deploy.sh
```

## Comandos útiles

### Ver logs
```bash
docker-compose logs -f web
```

### Ejecutar consola Rails
```bash
docker-compose exec web bundle exec rails console
```

### Ejecutar migraciones
```bash
docker-compose exec web bundle exec rails db:migrate
```

### Reiniciar
```bash
docker-compose restart web
```

### Detener
```bash
docker-compose down
```

## Migrar datos existentes

### 1. Exportar base de datos actual
```bash
pg_dump -U postgres telederma_production > backup.sql
```

### 2. Copiar uploads
```bash
tar -czvf uploads.tar.gz public/uploads/
```

### 3. En el nuevo servidor, importar datos
```bash
# Copiar backup.sql y uploads.tar.gz al nuevo servidor
docker-compose exec -T db psql -U telederma telederma_production < backup.sql
tar -xzvf uploads.tar.gz -C /var/lib/docker/volumes/teledermaweb_uploads_data/_data/
```

## Estructura de volúmenes
- `postgres_data`: Datos de PostgreSQL
- `uploads_data`: Archivos subidos (imágenes, documentos)
- `pdf_temp`: PDFs temporales generados
