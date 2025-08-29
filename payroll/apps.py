"""
App configuration for the 'payroll' app.
"""

from django.apps import AppConfig
from django.db.models.signals import post_migrate


class PayrollConfig(AppConfig):
    """
    AppConfig for the 'payroll' app.
    """

    default_auto_field = "django.db.models.BigAutoField"
    name = "payroll"

    def ready(self) -> None:
        ready = super().ready()
        from django.urls import include, path

        from horilla.horilla_settings import APPS
        from horilla.urls import urlpatterns
        from payroll import signals

        APPS.append("payroll")
        urlpatterns.append(
            path("payroll/", include("payroll.urls.urls")),
        )
        import os
        import sys
        
        # Only start scheduler when not during migrations and scheduler is enabled
        if not any(
            cmd in sys.argv
            for cmd in ["makemigrations", "migrate", "compilemessages", "flush", "shell"]
        ) and os.environ.get('DISABLE_SCHEDULER') != 'true':
            try:
                from payroll.scheduler import auto_payslip_generate
                auto_payslip_generate()
            except Exception as e:
                print(f"Failed to start payroll scheduler: {e}")

        return ready
