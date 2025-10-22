FROM mysql:8.0

# Copia los scripts SQL al directorio de inicialización de MySQL
COPY ./database /docker-entrypoint-initdb.d