#!/bin/bash

echo "Starting Horilla application..."

# Wait for database to be ready
echo "Waiting for database connection..."
python3 manage.py check --database default

# Run migrations
echo "Running database migrations..."
if [ "$DEBUG" = "True" ]; then
    echo "Development mode: Creating migrations..."
    python3 manage.py makemigrations --noinput || echo "No new migrations to create"
fi
python3 manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python3 manage.py collectstatic --noinput

# Create superuser if it doesn't exist (only in development)
if [ "$DEBUG" = "True" ]; then
    echo "Creating default admin user..."
    python3 manage.py createhorillauser --first_name admin --last_name admin --username admin --password admin --email admin@example.com --phone 1234567890 || echo "Admin user already exists"
fi

# Start the application
echo "Starting Gunicorn server..."
exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 3 --timeout 120 horilla.wsgi:application
