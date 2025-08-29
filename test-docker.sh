#!/bin/bash

# Test Docker build and run locally before deploying to Render

echo "Building Docker image..."
docker build -t horilla-test .

if [ $? -eq 0 ]; then
    echo "✅ Docker build successful!"
    echo ""
    echo "To test locally with your PostgreSQL database, run:"
    echo "docker run -p 8000:8000 -e DEBUG=True -e DATABASE_URL='your_database_url_here' horilla-test"
    echo ""
    echo "Then visit: http://localhost:8000"
else
    echo "❌ Docker build failed!"
    exit 1
fi