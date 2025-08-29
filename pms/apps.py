"""
Django application configuration for the PMS (Performance Management System) app.
"""

from django.apps import AppConfig


class PmsConfig(AppConfig):
    """
    This class provides configuration settings for the PMS app, such as the default
    database field type and the app's name.
    """

    default_auto_field = "django.db.models.BigAutoField"
    name = "pms"

    def ready(self):
        from django.urls import include, path

        from horilla.horilla_settings import APPS
        from horilla.urls import urlpatterns

        APPS.append("pms")
        urlpatterns.append(
            path("pms/", include("pms.urls")),
        )
        super().ready()
        
        import os
        import sys
        
        # Only start automation when not during migrations and scheduler is enabled
        if not any(
            cmd in sys.argv
            for cmd in ["makemigrations", "migrate", "compilemessages", "flush", "shell"]
        ) and os.environ.get('DISABLE_SCHEDULER') != 'true':
            try:
                from pms.signals import start_automation
                start_automation()
            except Exception as e:
                print(f"Failed to start PMS automation: {e}")
