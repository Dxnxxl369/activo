# backend/api/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views  # Correcta importación relativa de las vistas

# El router registra todas las vistas de la API
router = DefaultRouter()
router.register(r'empresas', views.EmpresaViewSet, basename='empresa')
router.register(r'departamentos', views.DepartamentoViewSet, basename='departamento')
router.register(r'permisos', views.PermisosViewSet, basename='permiso')
router.register(r'roles', views.RolesViewSet, basename='rol')
router.register(r'cargos', views.CargoViewSet, basename='cargo')
router.register(r'empleados', views.EmpleadoViewSet, basename='empleado')
router.register(r'proveedores', views.ProveedorViewSet, basename='proveedor')
router.register(r'divisas', views.DivisasViewSet, basename='divisa')
router.register(r'estados', views.EstadoViewSet, basename='estado')
router.register(r'categorias-activos', views.CategoriaActivoViewSet, basename='categoriaactivo')
router.register(r'ubicaciones', views.UbicacionViewSet, basename='ubicacion')
router.register(r'activos-fijos', views.ActivoFijoViewSet, basename='activofijo')
router.register(r'inventarios', views.InventarioViewSet, basename='inventario')
router.register(r'movimientos-inventario', views.MovimientosInventarioViewSet, basename='movimientoinventario')
router.register(r'presupuestos', views.PresupuestoViewSet, basename='presupuesto')
router.register(r'detalles-presupuesto', views.DetallePresupuestoViewSet, basename='detallepresupuesto')
router.register(r'contratos-proveedores', views.ContratosProveedoresViewSet, basename='contratoproveedor')
router.register(r'auditorias', views.AuditoriaViewSet, basename='auditoria')
router.register(r'reportes', views.ReporteViewSet, basename='reporte')
router.register(r'revalorizaciones-activos', views.RevalorizacionActivosViewSet, basename='revalorizacionactivo')
router.register(r'tipos-depreciacion', views.TipoDepreciacionViewSet, basename='tipodepreciacion')
router.register(r'depreciaciones-activos', views.DepreciacionActivosViewSet, basename='depreciacionactivo')
router.register(r'disposiciones-activos', views.DisposicionActivosViewSet, basename='disposicionactivo')
router.register(r'impuestos', views.ImpuestosViewSet, basename='impuesto')


# urlpatterns solo debe incluir las rutas del router
urlpatterns = [
    path('', include(router.urls)),
    path('dashboard/', views.DashboardStatsView.as_view(), name='dashboard-stats'),

]