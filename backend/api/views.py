from rest_framework import viewsets
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
	EmpleadoReadSerializer, EmpleadoWriteSerializer
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
    queryset = Proveedor.objects.all()
    serializer_class = ProveedorSerializer

class EmpleadoViewSet(viewsets.ModelViewSet):
    # Ya no definimos un serializer_class estático aquí
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
        return EmpleadoReadSerializer # Usado para 'list' y 'retrieve'

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
    queryset = ActivoFijo.objects.all()
    serializer_class = ActivoFijoSerializer

class InventarioViewSet(viewsets.ModelViewSet):
    queryset = Inventario.objects.all()
    serializer_class = InventarioSerializer

class MovimientosInventarioViewSet(viewsets.ModelViewSet):
    queryset = MovimientosInventario.objects.all()
    serializer_class = MovimientosInventarioSerializer

class PresupuestoViewSet(viewsets.ModelViewSet):
    queryset = Presupuesto.objects.all()
    serializer_class = PresupuestoSerializer

class DetallePresupuestoViewSet(viewsets.ModelViewSet):
    queryset = DetallePresupuesto.objects.all()
    serializer_class = DetallePresupuestoSerializer

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
    queryset = RevalorizacionActivos.objects.all()
    serializer_class = RevalorizacionActivosSerializer

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