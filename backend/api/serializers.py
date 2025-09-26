from rest_framework import serializers
from django.contrib.auth.models import User
from .models import (
    Empresa, Departamento, Permisos, Roles, Cargo, Empleado, Proveedor,
    Estado, CategoriaActivo, Ubicacion, ActivoFijo, Inventario,
    MovimientosInventario, Presupuesto, DetallePresupuesto,
    ContratosProveedores, Auditoria, Reporte, RevalorizacionActivos,
    TipoDepreciacion, DepreciacionActivos, Divisas, DisposicionActivos, Impuestos
)

# Serializer para el modelo User de Django
class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email']

# --- Serializers con CRUD completo requerido ---

class EmpresaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Empresa
        fields = '__all__'

class DepartamentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Departamento
        fields = '__all__'

class PermisosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permisos
        fields = '__all__'

class RolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Roles
        fields = '__all__'
        depth = 1 # Muestra los detalles de los permisos anidados

class CargoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cargo
        fields = '__all__'
        
class DivisasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Divisas
        fields = '__all__'

class ProveedorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Proveedor
        fields = '__all__'

class EmpleadoSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)
    username = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True, style={'input_type': 'password'})
    first_name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)

    class Meta:
        model = Empleado
        fields = [
            'id', 'usuario', 'ci', 'apellido_p', 'apellido_m', 'direccion', 
            'telefono', 'empresa', 'departamento', 'cargo', 'rol', 
            'username', 'password', 'first_name', 'email'
        ]
        depth = 1 # Muestra detalles de Empresa, Departamento, Cargo y Rol

    def create(self, validated_data):
        username = validated_data.pop('username')
        password = validated_data.pop('password')
        first_name = validated_data.pop('first_name')
        email = validated_data.pop('email')
        
        user = User.objects.create_user(
            username=username, password=password, first_name=first_name,
            email=email, last_name=validated_data.get('apellido_p', '')
        )
        
        empleado = Empleado.objects.create(usuario=user, **validated_data)
        return empleado

# ... (todas las otras importaciones y serializers se mantienen igual) ...

class EmpleadoWriteSerializer(serializers.ModelSerializer):
    """
    Serializer para CREAR y ACTUALIZAR empleados.
    Acepta IDs para las relaciones.
    """
    username = serializers.CharField(write_only=True)
    # <-- CAMBIO 1: La contraseña ya no es requerida por defecto
    password = serializers.CharField(write_only=True, required=False, allow_blank=True, style={'input_type': 'password'})
    first_name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)

    empresa = serializers.PrimaryKeyRelatedField(queryset=Empresa.objects.all())
    departamento = serializers.PrimaryKeyRelatedField(queryset=Departamento.objects.all())
    cargo = serializers.PrimaryKeyRelatedField(queryset=Cargo.objects.all())
    rol = serializers.PrimaryKeyRelatedField(queryset=Roles.objects.all())

    class Meta:
        model = Empleado
        fields = [
            'id', 'ci', 'apellido_p', 'apellido_m', 'direccion', 'telefono',
            'empresa', 'departamento', 'cargo', 'rol',
            'username', 'password', 'first_name', 'email'
        ]

    def create(self, validated_data):
        # La lógica de creación se mantiene igual
        username = validated_data.pop('username')
        password = validated_data.pop('password')
        first_name = validated_data.pop('first_name')
        email = validated_data.pop('email')

        user = User.objects.create_user(
            username=username, password=password, first_name=first_name,
            email=email, last_name=validated_data.get('apellido_p', '')
        )
        
        empleado = Empleado.objects.create(usuario=user, **validated_data)
        return empleado

    # <-- CAMBIO 2: Añadimos una lógica de actualización personalizada -->
    def update(self, instance, validated_data):
        # Actualizamos los datos del modelo User por separado, si vienen
        user_data = {}
        if 'first_name' in validated_data:
            user_data['first_name'] = validated_data.pop('first_name')
        if 'email' in validated_data:
            user_data['email'] = validated_data.pop('email')
        
        # Actualizamos la contraseña solo si se proporcionó una nueva
        password = validated_data.pop('password', None)
        user = instance.usuario
        if password:
            user.set_password(password)
        
        # Actualizamos los campos del User
        if user_data:
            for attr, value in user_data.items():
                setattr(user, attr, value)
        user.save()

        # El 'username' no se puede cambiar, así que lo quitamos si viene
        validated_data.pop('username', None)

        # Usamos la lógica de actualización por defecto para los campos restantes del Empleado
        return super().update(instance, validated_data)

class EmpleadoReadSerializer(serializers.ModelSerializer):
    """
    Serializer para LEER (listar/ver) empleados.
    Muestra los objetos anidados para las relaciones.
    """
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = Empleado
        fields = '__all__'
        depth = 1 # depth = 1 es perfecto para la lectura



# --- Serializers para las demás tablas (CRUD general) ---

class EstadoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Estado
        fields = '__all__'

class CategoriaActivoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaActivo
        fields = '__all__'

class UbicacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ubicacion
        fields = '__all__'

class ActivoFijoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivoFijo
        fields = '__all__'
        depth = 1 # Muestra detalles de Empresa, Estado, Categoria y Ubicacion

class InventarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Inventario
        fields = '__all__'
        depth = 1 # Muestra detalles del Activo Fijo

class MovimientosInventarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = MovimientosInventario
        fields = '__all__'

class PresupuestoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Presupuesto
        fields = '__all__'

class DetallePresupuestoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DetallePresupuesto
        fields = '__all__'
        depth = 1 # Muestra detalles del Presupuesto y Categoria

class ContratosProveedoresSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContratosProveedores
        fields = '__all__'
        depth = 1 # Muestra detalles del Proveedor, Empleado y Activo

class AuditoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Auditoria
        fields = '__all__'

class ReporteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reporte
        fields = '__all__'

class RevalorizacionActivosSerializer(serializers.ModelSerializer):
    class Meta:
        model = RevalorizacionActivos
        fields = '__all__'

class TipoDepreciacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TipoDepreciacion
        fields = '__all__'

class DepreciacionActivosSerializer(serializers.ModelSerializer):
    class Meta:
        model = DepreciacionActivos
        fields = '__all__'

class DisposicionActivosSerializer(serializers.ModelSerializer):
    class Meta:
        model = DisposicionActivos
        fields = '__all__'

class ImpuestosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Impuestos
        fields = '__all__'