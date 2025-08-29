# Deploying Horilla to Render

This guide will help you deploy the Horilla Django application to Render using Docker.

## Prerequisites

1. A Render account (https://render.com)
2. Your code pushed to a Git repository (GitHub, GitLab, etc.)
3. PostgreSQL database (you already have this configured)

## Deployment Steps

### Option 1: Using render.yaml (Recommended)

1. **Push your code** to your Git repository with the updated files
2. **Connect to Render**:
   - Go to https://render.com/dashboard
   - Click "New" → "Blueprint"
   - Connect your Git repository
   - Render will automatically detect the `render.yaml` file

3. **Update environment variables** in Render dashboard:
   - `SECRET_KEY`: Generate a new one at https://djecrety.ir
   - `ALLOWED_HOSTS`: Update with your actual Render domain
   - `CSRF_TRUSTED_ORIGINS`: Update with your actual Render domain

### Option 2: Manual Setup

1. **Create a new Web Service**:
   - Go to https://render.com/dashboard
   - Click "New" → "Web Service"
   - Connect your Git repository

2. **Configure the service**:
   - **Name**: horilla-app (or your preferred name)
   - **Environment**: Docker
   - **Region**: Choose your preferred region
   - **Branch**: main (or your default branch)
   - **Dockerfile Path**: ./Dockerfile

3. **Set Environment Variables**:
   ```
   DEBUG=False
   SECRET_KEY=your-production-secret-key-here
   DATABASE_URL=your_database_connection_string_here
   ALLOWED_HOSTS=your-app-name.onrender.com,*.onrender.com
   CSRF_TRUSTED_ORIGINS=https://your-app-name.onrender.com,https://*.onrender.com
   TIME_ZONE=UTC
   ```

4. **Deploy**: Click "Create Web Service"

## Post-Deployment Steps

1. **Update domains**: After deployment, update the `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS` environment variables with your actual Render domain.

2. **Create superuser** (if needed):
   - Go to your Render dashboard
   - Open the Shell for your service
   - Run: `python manage.py createsuperuser`

3. **Test the deployment**:
   - Visit your app URL
   - Check the health endpoint: `https://your-app.onrender.com/health/`

## Important Notes

- **Database**: Your PostgreSQL database is already configured and will be used automatically
- **Static files**: Handled by WhiteNoise middleware
- **Media files**: Currently stored locally (consider using cloud storage for production)
- **SSL**: Automatically handled by Render
- **Logs**: Available in the Render dashboard

## Troubleshooting

1. **Build fails**: Check the build logs in Render dashboard
2. **Database connection issues**: Verify the DATABASE_URL is correct
3. **Static files not loading**: Ensure `collectstatic` runs successfully
4. **CSRF errors**: Update `CSRF_TRUSTED_ORIGINS` with your domain

## Security Recommendations

1. Generate a new `SECRET_KEY` for production
2. Set `DEBUG=False` in production
3. Regularly update dependencies
4. Monitor application logs
5. Consider using environment-specific settings files

## Files Modified for Render Deployment

- `Dockerfile`: Updated for production deployment
- `entrypoint.sh`: Enhanced for Render environment
- `horilla/settings.py`: Added Render-specific configurations
- `render.yaml`: Blueprint for easy deployment
- `.env.render`: Template for environment variables