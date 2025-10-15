##from django.contrib import admin
##from django.urls import path, include
##
##urlpatterns = [
##    path('admin/', admin.site.urls),
##    path('api/', include('api.urls')),
##]

# backend/ActFijoPresupuesto/urls.py

from django.contrib import admin
from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    # 1. La ruta del panel de administración de Django
    path('admin/', admin.site.urls),

    # 2. La ruta de login para obtener el token
    path('api/login/', obtain_auth_token, name='api_token_auth'),

    # 3. Incluye TODAS las rutas de la aplicación 'api' bajo el prefijo /api/
    path('api/', include('api.urls')),
]