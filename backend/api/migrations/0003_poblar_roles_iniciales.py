# api/migrations/0003_poblar_roles_iniciales.py

from django.db import migrations

def poblar_roles_iniciales(apps, schema_editor):
    """
    Crea los roles iniciales 'Administrador' y 'Empleado General'
    y asigna los permisos correspondientes.
    """
    Permiso = apps.get_model('api', 'Permisos')
    Rol = apps.get_model('api', 'Roles')

    # --- Rol de Administrador (con todos los permisos) ---
    admin_rol, creado = Rol.objects.get_or_create(nombre='Administrador')
    if creado:
        todos_los_permisos = Permiso.objects.all()
        admin_rol.permisos.set(todos_los_permisos)
        admin_rol.save()

    # --- Rol de Empleado General (solo con permisos de visualización) ---
    empleado_rol, creado = Rol.objects.get_or_create(nombre='Empleado General')
    if creado:
        permisos_de_vista = Permiso.objects.filter(nombre__icontains='ver_')
        empleado_rol.permisos.set(permisos_de_vista)
        empleado_rol.save()


class Migration(migrations.Migration):

    dependencies = [
        # Esta migración debe correr DESPUÉS de la que puebla los permisos
        ('api', '0002_poblar_permisos'),
    ]

    operations = [
        migrations.RunPython(poblar_roles_iniciales),
    ]