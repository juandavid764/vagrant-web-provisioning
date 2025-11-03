#!/usr/bin/env bash
set -e

# Actualizar paquetes e instalar PostgreSQL
sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib

# Asegurar que PostgreSQL escuche en la red privada y permita conexiones de la subred 192.168.56.0/24
# (idempotente: solo cambia si está comentado o distinto)
sudo sed -i "s/^#\?listen_addresses.*/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf

# Agregar regla a pg_hba.conf si no existe
HBA="/etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf"
RULE="host    all             all             192.168.56.0/24          md5"
grep -qxF "$RULE" "$HBA" || echo "$RULE" | sudo tee -a "$HBA" >/dev/null

# Reiniciar para aplicar configuración de red
sudo systemctl restart postgresql

# Crear usuario, base, tabla y datos (idempotente)
DB_USER="appuser"
DB_PASS="appPass123"
DB_NAME="appdb"

# Crear usuario si no existe
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 || \
  sudo -u postgres psql -c "CREATE ROLE ${DB_USER} WITH LOGIN PASSWORD '${DB_PASS}';"

# Crear base si no existe
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1 || \
  sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"

# Crear tabla y poblarla
sudo -u postgres psql -d "${DB_NAME}" -v ON_ERROR_STOP=1 -c "
CREATE TABLE IF NOT EXISTS productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  precio NUMERIC(10,2) NOT NULL
);"

# Insertar datos de ejemplo solo si la tabla está vacía
COUNT=$(sudo -u postgres psql -d "${DB_NAME}" -tAc "SELECT COUNT(*) FROM productos;")
if [ \"${COUNT}\" = \"0\" ]; then
  sudo -u postgres psql -d "${DB_NAME}" -c \"
  INSERT INTO productos (nombre, precio) VALUES
    ('Cuaderno', 12000.00),
    ('Bolígrafo', 3500.00),
    ('Regla 30cm', 4500.00);
  \"
fi

# Asegurar arranque
sudo systemctl enable postgresql
sudo systemctl status postgresql --no-pager || true
