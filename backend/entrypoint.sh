#!/bin/bash

# Production entrypoint script for FastAPI backend

set -e

echo "Starting Programador Musical Backend..."

# Wait for database to be ready
echo "Waiting for database to be ready..."
python -c "
import time
import sys
from sqlalchemy import create_engine
from app.core.config import settings

max_retries = 30
retry_count = 0

while retry_count < max_retries:
    try:
        engine = create_engine(settings.database_url)
        connection = engine.connect()
        connection.close()
        print('Database is ready!')
        break
    except Exception as e:
        retry_count += 1
        print(f'Database not ready (attempt {retry_count}/{max_retries}): {e}')
        time.sleep(2)
else:
    print('Failed to connect to database after maximum retries')
    sys.exit(1)
"

# Initialize database
echo "Initializing database..."

# Extract database connection info from DATABASE_URL if individual vars not available
if [ -z "$DATABASE_HOST" ] && [ -n "$DATABASE_URL" ]; then
    export DATABASE_HOST=$(echo $DATABASE_URL | sed 's/.*@\([^:]*\):.*/\1/')
    export DATABASE_NAME=$(echo $DATABASE_URL | sed 's/.*\/\([^?]*\).*/\1/')
    export DATABASE_USERNAME=$(echo $DATABASE_URL | sed 's/.*:\/\/\([^:]*\):.*/\1/')
    export DATABASE_PASSWORD=$(echo $DATABASE_URL | sed 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/')
fi

# Try to run database.sql first (full schema with data)
if [ -f "database.sql" ]; then
    echo "Running database.sql initialization..."
    echo "Connecting to: $DATABASE_HOST as $DATABASE_USERNAME"
    echo "Database: $DATABASE_NAME"
    
    # Check if tables already exist
    if PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -c "SELECT COUNT(*) FROM difusoras;" 2>/dev/null; then
        echo "Database already initialized with data"
    else
        echo "Initializing database with schema and data..."
        if PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -f database.sql; then
            echo "Database.sql executed successfully"
        else
            echo "Database.sql failed, database may already be initialized"
        fi
    fi
else
    echo "database.sql not found, skipping SQL initialization"
fi

# Skip Python initialization for now (causing transaction issues)
echo "Skipping Python database initialization..."

# Run alembic migrations
echo "Running alembic migrations..."
alembic upgrade head || {
    echo "Warning: Alembic migration failed. This may be normal if migrations are already applied."
    echo "Continuing with application startup..."
}

# Start the application
echo "Starting FastAPI application..."
exec uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4