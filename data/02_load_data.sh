#!/bin/bash
set -e

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -U postgres -d tpch; do
  echo "PostgreSQL is not ready yet, waiting..."
  sleep 2
done

echo "PostgreSQL is ready, starting data load..."

# Load tables in dependency order (parent tables first)
TABLES=(region nation part supplier partsupp customer orders lineitem)

for tbl in "${TABLES[@]}"; do
  echo "Loading $tbl..."
  if [ -f "/docker-entrypoint-initdb.d/$tbl.tbl" ]; then
    echo "File /docker-entrypoint-initdb.d/$tbl.tbl exists, preprocessing and loading..."
    # Remove trailing pipe and load data
    sed 's/|$//' "/docker-entrypoint-initdb.d/$tbl.tbl" | psql -U postgres -d tpch -c "\COPY $tbl FROM stdin WITH (FORMAT csv, DELIMITER '|', NULL '')"
    echo "Successfully loaded $tbl"
  else
    echo "ERROR: File /docker-entrypoint-initdb.d/$tbl.tbl not found!"
    exit 1
  fi
done

echo "All tables loaded successfully!"