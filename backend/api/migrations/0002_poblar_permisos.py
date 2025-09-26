# api/migrations/0002_poblar_permisos.py

from django.db import migrations

# Lista de permisos que queremos crear en el sistema
PERMISOS = [
    # Permisos para Empleados
    'crear_empleado',
    'editar_empleado',
    'eliminar_empleado',
    'ver_empleados',

    # Permisos para Roles y Permisos
    'gestionar_roles_permisos',

    # Permisos para Activos Fijos
    'crear_activo',
    'editar_activo',
    'eliminar_activo',
    'ver_activos',

    # Permisos para Presupuestos
    'crear_presupuesto',
    'aprobar_presupuesto',
    'eliminar_presupuesto',
    'ver_presupuestos',
    
    # ... puedes añadir tantos permisos específicos como necesites
]

def poblar_permisos(apps, schema_editor):
    """
    Esta función se ejecuta cuando aplicamos la migración.
    """
    Permiso = apps.get_model('api', 'Permisos')
    for nombre_permiso in PERMISOS:
        # get_or_create evita crear duplicados si el permiso ya existe
        Permiso.objects.get_or_create(nombre=nombre_permiso)

class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'), # Depende de la migración que creó los modelos
    ]

    operations = [
        migrations.RunPython(poblar_permisos),
    ]