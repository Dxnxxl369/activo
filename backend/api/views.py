from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from django.db import transaction
from django.db.models import Q

from .permissions import TienePermisoRequerido

from .models import (
    Empresa, Departamento, Permisos, Roles, Cargo, Empleado, Proveedor,
    Estado, CategoriaActivo, Ubicacion, ActivoFijo, Inventario,
    MovimientosInventario, Presupuesto, DetallePresupuesto,
    ContratosProveedores, Auditoria, Reporte, RevalorizacionActivos,
    TipoDepreciacion, DepreciacionActivos, Divisas, DisposicionActivos, Impuestos
)

from .serializers import (
    EmpresaSerializer, DepartamentoSerializer, PermisosSerializer, RolesSerializer,
    CargoSerializer, EmpleadoSerializer, ProveedorSerializer, DivisasSerializer,
    EstadoSerializer, CategoriaActivoSerializer, UbicacionSerializer, ActivoFijoSerializer,
    InventarioSerializer, MovimientosInventarioSerializer, PresupuestoSerializer,
    DetallePresupuestoSerializer, ContratosProveedoresSerializer, AuditoriaSerializer,
    ReporteSerializer, RevalorizacionActivosSerializer, TipoDepreciacionSerializer,
    DepreciacionActivosSerializer, DisposicionActivosSerializer, ImpuestosSerializer,
	EmpleadoReadSerializer, EmpleadoWriteSerializer,
    ActivoFijoReadSerializer, ActivoFijoWriteSerializer,
    DetallePresupuestoReadSerializer, DetallePresupuestoWriteSerializer,
    RevalorizacionActivosReadSerializer, RevalorizacionActivosWriteSerializer,
)

class EmpresaViewSet(viewsets.ModelViewSet):
    queryset = Empresa.objects.all()
    serializer_class = EmpresaSerializer

class DepartamentoViewSet(viewsets.ModelViewSet):
    queryset = Departamento.objects.all()
    serializer_class = DepartamentoSerializer

class PermisosViewSet(viewsets.ModelViewSet):
    queryset = Permisos.objects.all()
    serializer_class = PermisosSerializer

class RolesViewSet(viewsets.ModelViewSet):
    queryset = Roles.objects.all()
    serializer_class = RolesSerializer
    permission_classes = [TienePermisoRequerido]
    # Mapa que define qué permiso se necesita para cada acción de escritura
    permiso_requerido_map = {
        'create': 'gestionar_roles_permisos',
        'update': 'gestionar_roles_permisos',
        'partial_update': 'gestionar_roles_permisos',
        'destroy': 'gestionar_roles_permisos',
    }
# Puedes añadir permission_classes = [TienePermisoRequerido] a 
# cualquier ViewSet que necesites proteger de esta forma 
# (por ejemplo, PermisosViewSet, DepartamentoViewSet, CargoViewSet, etc.).

class CargoViewSet(viewsets.ModelViewSet):
    queryset = Cargo.objects.all()
    serializer_class = CargoSerializer

class DivisasViewSet(viewsets.ModelViewSet):
    queryset = Divisas.objects.all()
    serializer_class = DivisasSerializer

class ProveedorViewSet(viewsets.ModelViewSet):
    serializer_class = ProveedorSerializer
    queryset = Proveedor.objects.all()

    def get_queryset(self):
        """
        Filtra para mostrar solo los proveedores activos en la lista principal.
        """
        return Proveedor.objects.filter(estado='activo')

    def perform_destroy(self, instance):
        """
        En lugar de borrar el objeto de la base de datos,
        simplemente cambia su estado a 'inactivo'.
        """
        instance.estado = 'inactivo'
        instance.save()

    # --- ACCIÓN NUEVA: LISTAR INACTIVOS ---
    @action(detail=False, methods=['get'])
    def inactivos(self, request):
        """
        Devuelve una lista de todos los proveedores con estado 'inactivo'.
        Se accede a través de la URL: /api/proveedores/inactivos/
        """
        proveedores_inactivos = Proveedor.objects.filter(estado='inactivo')
        serializer = self.get_serializer(proveedores_inactivos, many=True)
        return Response(serializer.data)

    # --- ACCIÓN NUEVA: REACTIVAR ---
    @action(detail=True, methods=['post'])
    def reactivar(self, request, pk=None):
        """
        Cambia el estado de un proveedor específico de 'inactivo' a 'activo'.
        Se accede a través de la URL: /api/proveedores/{id}/reactivar/
        """
        proveedor = self.get_object()
        if proveedor.estado == 'inactivo':
            proveedor.estado = 'activo'
            proveedor.save()
            return Response({'status': 'proveedor reactivado'}, status=status.HTTP_200_OK)
        else:
            return Response({'status': 'el proveedor ya estaba activo'}, status=status.HTTP_400_BAD_REQUEST)

class EmpleadoViewSet(viewsets.ModelViewSet):
    permission_classes = [TienePermisoRequerido]
    permiso_requerido_map = {
        'create': 'crear_empleado',
        'update': 'editar_empleado',
        'partial_update': 'editar_empleado',
        'destroy': 'eliminar_empleado',
    }

    def get_serializer_class(self):
        """
        Determina qué serializer usar basado en la acción (lectura o escritura).
        """
        if self.action in ['create', 'update', 'partial_update']:
            return EmpleadoWriteSerializer
        return EmpleadoReadSerializer

    def get_queryset(self):
        queryset = Empleado.objects.all()
        termino_busqueda = self.request.query_params.get('buscar', None)
        if termino_busqueda:
            queryset = queryset.filter(
                Q(ci__icontains=termino_busqueda) |
                Q(usuario__first_name__icontains=termino_busqueda) |
                Q(apellido_p__icontains=termino_busqueda) |
                Q(apellido_m__icontains=termino_busqueda)
            )
        return queryset

class EstadoViewSet(viewsets.ModelViewSet):
    queryset = Estado.objects.all()
    serializer_class = EstadoSerializer

class CategoriaActivoViewSet(viewsets.ModelViewSet):
    queryset = CategoriaActivo.objects.all()
    serializer_class = CategoriaActivoSerializer

class UbicacionViewSet(viewsets.ModelViewSet):
    queryset = Ubicacion.objects.all()
    serializer_class = UbicacionSerializer

class ActivoFijoViewSet(viewsets.ModelViewSet):
    """
    Gestiona los Activos Fijos del sistema.
    Utiliza serializers y querysets dinámicos para máxima flexibilidad.
    """
    # (Si tienes alguna clase de permisos aquí, déjala como está)
    # permission_classes = [IsAuthenticated, ...]

    def get_queryset(self):
        """
        Define dinámicamente el conjunto de datos que el ViewSet manejará.
        Este método es más flexible y permite añadir lógica de filtrado en el futuro.
        """
        return ActivoFijo.objects.all()

    def get_serializer_class(self):
        """
        Este método es la clave. Determina qué serializer usar
        basado en la acción que se está realizando (GET, POST, PUT).
        """
        # Si la acción es crear, actualizar o actualizar parcialmente...
        if self.action in ['create', 'update', 'partial_update']:
            # ...usa el serializer diseñado para escribir (que acepta IDs).
            return ActivoFijoWriteSerializer
        
        # Para cualquier otra acción (como 'list' o 'retrieve')...
        # ...usa el serializer diseñado para leer (que muestra los detalles con depth=1).
        return ActivoFijoReadSerializer

class InventarioViewSet(viewsets.ModelViewSet):
    queryset = Inventario.objects.all()
    serializer_class = InventarioSerializer

class MovimientosInventarioViewSet(viewsets.ModelViewSet):
    queryset = MovimientosInventario.objects.all()
    serializer_class = MovimientosInventarioSerializer

class PresupuestoViewSet(viewsets.ModelViewSet):
    """
    Gestiona los Presupuestos. Usa un serializer que anida los detalles.
    """
    queryset = Presupuesto.objects.all()
    serializer_class = PresupuestoSerializer

    #def perform_create(self, serializer):
    #    """
    #    Asigna automáticamente la empresa del empleado que crea el presupuesto.
    #    """
    #    try:
    #        # 1. Obtiene el usuario que hace la petición (request.user).
    #        # 2. Busca el perfil de Empleado asociado a ese usuario.
    #        empleado = Empleado.objects.get(usuario=self.request.user)
    #        # 3. Guarda el presupuesto asignando la empresa de ese empleado.
    #        serializer.save(empresa=empleado.empresa)
    #    except Empleado.DoesNotExist:
    #        raise ValidationError("El usuario no está vinculado a un empleado y no puede crear presupuestos.")

class DetallePresupuestoViewSet(viewsets.ModelViewSet):
    queryset = DetallePresupuesto.objects.all()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return DetallePresupuestoWriteSerializer
        return DetallePresupuestoReadSerializer

class ContratosProveedoresViewSet(viewsets.ModelViewSet):
    queryset = ContratosProveedores.objects.all()
    serializer_class = ContratosProveedoresSerializer

class AuditoriaViewSet(viewsets.ModelViewSet):
    queryset = Auditoria.objects.all()
    serializer_class = AuditoriaSerializer

class ReporteViewSet(viewsets.ModelViewSet):
    queryset = Reporte.objects.all()
    serializer_class = ReporteSerializer

class RevalorizacionActivosViewSet(viewsets.ModelViewSet):
    """
    Gestiona las revalorizaciones y actualiza el activo correspondiente en una transacción.
    """
    queryset = RevalorizacionActivos.objects.all()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return RevalorizacionActivosWriteSerializer
        return RevalorizacionActivosReadSerializer

    def perform_create(self, serializer):
        """
        Sobrescribe el método de creación para realizar una transacción atómica:
        1. Guarda el registro de la revalorización.
        2. Actualiza el valor_actual del ActivoFijo asociado.
        """
        try:
            with transaction.atomic():            
                revalorizacion = serializer.save()                
                activo = revalorizacion.activo_fijo
                activo.valor_actual = revalorizacion.nuevo_valor                
                activo.save()        
                print(f"Activo '{activo.nombre}' (ID: {activo.id}) actualizado. Nuevo valor: {activo.valor_actual}")

        except Exception as e:
            # Si algo falla, la transacción se revierte y nada se guarda.
            print(f"Error en la transacción de revalorización: {e}")
            # Esto ayudará a levantar un error más claro si algo sale mal.
            raise

class TipoDepreciacionViewSet(viewsets.ModelViewSet):
    queryset = TipoDepreciacion.objects.all()
    serializer_class = TipoDepreciacionSerializer

class DepreciacionActivosViewSet(viewsets.ModelViewSet):
    queryset = DepreciacionActivos.objects.all()
    serializer_class = DepreciacionActivosSerializer

class DisposicionActivosViewSet(viewsets.ModelViewSet):
    queryset = DisposicionActivos.objects.all()
    serializer_class = DisposicionActivosSerializer

class ImpuestosViewSet(viewsets.ModelViewSet):
    queryset = Impuestos.objects.all()
    serializer_class = ImpuestosSerializer