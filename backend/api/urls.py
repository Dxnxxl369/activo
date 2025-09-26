from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework.authtoken.views import obtain_auth_token
from .views import (
    EmpresaViewSet, DepartamentoViewSet, PermisosViewSet, RolesViewSet,
    CargoViewSet, EmpleadoViewSet, ProveedorViewSet, DivisasViewSet,
    EstadoViewSet, CategoriaActivoViewSet, UbicacionViewSet, ActivoFijoViewSet,
    InventarioViewSet, MovimientosInventarioViewSet, PresupuestoViewSet,
    DetallePresupuestoViewSet, ContratosProveedoresViewSet, AuditoriaViewSet,
    ReporteViewSet, RevalorizacionActivosViewSet, TipoDepreciacionViewSet,
    DepreciacionActivosViewSet, DisposicionActivosViewSet, ImpuestosViewSet
)

router = DefaultRouter()

router.register(r'empresas', EmpresaViewSet, basename='empresa')
router.register(r'departamentos', DepartamentoViewSet, basename='departamento')
router.register(r'permisos', PermisosViewSet, basename='permiso')
router.register(r'roles', RolesViewSet, basename='rol')
router.register(r'cargos', CargoViewSet, basename='cargo')
router.register(r'empleados', EmpleadoViewSet, basename='empleado')
router.register(r'proveedores', ProveedorViewSet, basename='proveedor')
router.register(r'divisas', DivisasViewSet, basename='divisa')
router.register(r'estados', EstadoViewSet, basename='estado')
router.register(r'categorias-activos', CategoriaActivoViewSet, basename='categoriaactivo')
router.register(r'ubicaciones', UbicacionViewSet, basename='ubicacion')
router.register(r'activos-fijos', ActivoFijoViewSet, basename='activofijo')
router.register(r'inventarios', InventarioViewSet, basename='inventario')
router.register(r'movimientos-inventario', MovimientosInventarioViewSet, basename='movimientoinventario')
router.register(r'presupuestos', PresupuestoViewSet, basename='presupuesto')
router.register(r'detalles-presupuesto', DetallePresupuestoViewSet, basename='detallepresupuesto')
router.register(r'contratos-proveedores', ContratosProveedoresViewSet, basename='contratoproveedor')
router.register(r'auditorias', AuditoriaViewSet, basename='auditoria')
router.register(r'reportes', ReporteViewSet, basename='reporte')
router.register(r'revalorizaciones-activos', RevalorizacionActivosViewSet, basename='revalorizacionactivo')
router.register(r'tipos-depreciacion', TipoDepreciacionViewSet, basename='tipodepreciacion')
router.register(r'depreciaciones-activos', DepreciacionActivosViewSet, basename='depreciacionactivo')
router.register(r'disposiciones-activos', DisposicionActivosViewSet, basename='disposicionactivo')
router.register(r'impuestos', ImpuestosViewSet, basename='impuesto')

urlpatterns = [
    path('', include(router.urls)),
    path('login/', obtain_auth_token, name='api_token_auth'),
]