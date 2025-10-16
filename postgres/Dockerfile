# Dockerfile optimizado para DESARROLLO
FROM postgres:17

# Establecer variables de entorno para desarrollo
ENV POSTGRES_DB=programador-musical
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_INITDB_ARGS="--encoding=UTF-8 --lc-collate=C --lc-ctype=C"

# Instalar herramientas adicionales para desarrollo
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-contrib \
        postgresql-client \
        vim \
        curl \
        htop \
        procps \
        less \
        nano \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Crear directorio para logs de desarrollo
RUN mkdir -p /var/log/postgresql

# Copiar scripts de inicialización
COPY database.sql /docker-entrypoint-initdb.d/01-database.sql

# Configurar permisos para el script de inicialización
RUN chmod 644 /docker-entrypoint-initdb.d/01-database.sql

# Exponer puerto
EXPOSE 5432

# Comando por defecto (ya está en la imagen base)
CMD ["postgres"]
