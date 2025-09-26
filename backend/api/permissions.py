# api/permissions.py

from rest_framework.permissions import BasePermission, SAFE_METHODS

class TienePermisoRequerido(BasePermission):
    """
    Permiso personalizado que verifica si el rol del usuario tiene el permiso
    específico requerido para la acción que se intenta realizar.
    """
    def has_permission(self, request, view):
        # Todos los usuarios autenticados pueden ver (GET, HEAD, OPTIONS)
        if request.method in SAFE_METHODS:
            return True

        # Obtenemos el mapa de permisos del ViewSet
        permiso_map = getattr(view, 'permiso_requerido_map', {})
        # Obtenemos el permiso requerido para la acción actual (ej: 'create', 'update')
        permiso_requerido = permiso_map.get(view.action)

        # Si no se define un permiso para esta acción, se deniega el acceso por seguridad
        if not permiso_requerido:
            return False

        # Verificamos si el rol del empleado tiene el permiso requerido
        # Usamos un bloque try-except para manejar usuarios sin perfil de empleado (como el superuser puro)
        try:
            tiene_permiso = request.user.empleado.rol.permisos.filter(nombre=permiso_requerido).exists()
            return tiene_permiso
        except:
            # Si el superusuario no tiene un perfil de Empleado, le damos acceso total
            if request.user.is_superuser:
                return True
            return False