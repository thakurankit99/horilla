#!/bin/bash

echo "Starting Horilla application..."

# Disable schedulers during startup
export DISABLE_SCHEDULER=true

# Wait for database to be ready
echo "Waiting for database connection..."
python3 manage.py check --database default

# Run migrations
echo "Running database migrations..."

# Always try to create migrations first (safe in production)
echo "Creating any new migrations..."
python3 manage.py makemigrations --noinput 2>/dev/null || echo "No new migrations needed"

echo "Applying migrations..."
python3 manage.py migrate --noinput

# Verify database setup
echo "Verifying database setup..."
python3 manage.py check --database default

# Collect static files
echo "Collecting static files..."
python3 manage.py collectstatic --noinput

# Create superuser if it doesn't exist (only in development)
if [ "$DEBUG" = "True" ]; then
    echo "Creating default admin user..."
    python3 manage.py createhorillauser --first_name admin --last_name admin --username admin --password admin --email admin@example.com --phone 1234567890 || echo "Admin user already exists"
fi

# Re-enable schedulers for the application
export DISABLE_SCHEDULER=false

# Start the application
echo "Starting Gunicorn server..."
exec gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 3 --timeout 120 horilla.wsgi:application
