from django.db import models
from django.contrib.auth.models import User

# --- Modelos de Configuración y Entidades Principales ---

class Empresa(models.Model):
    nombre = models.CharField(max_length=150, verbose_name="Nombre de la Empresa")
    nit = models.IntegerField(unique=True, verbose_name="NIT")
    direccion = models.CharField(max_length=255, verbose_name="Dirección")
    email = models.EmailField(unique=True, verbose_name="Email")
    telefono = models.IntegerField(verbose_name="Teléfono")

    class Meta:
        verbose_name = "Empresa"
        verbose_name_plural = "Empresas"

    def __str__(self):
        return self.nombre

class Departamento(models.Model):
    nombre = models.CharField(max_length=100, verbose_name="Nombre del Departamento")
    descripcion = models.TextField(verbose_name="Descripción", blank=True, null=True)

    class Meta:
        verbose_name = "Departamento"
        verbose_name_plural = "Departamentos"

    def __str__(self):
        return self.nombre

class Permisos(models.Model):
    nombre = models.CharField(max_length=100, unique=True, verbose_name="Nombre del Permiso")
    descripcion = models.TextField(verbose_name="Descripción", blank=True, null=True)

    class Meta:
        verbose_name = "Permiso"
        verbose_name_plural = "Permisos"

    def __str__(self):
        return self.nombre

class Roles(models.Model):
    nombre = models.CharField(max_length=100, unique=True, verbose_name="Nombre del Rol")
    permisos = models.ManyToManyField(Permisos, verbose_name="Permisos", blank=True)

    class Meta:
        verbose_name = "Rol"
        verbose_name_plural = "Roles"

    def __str__(self):
        return self.nombre

class Cargo(models.Model):
    nombre = models.CharField(max_length=100, verbose_name="Nombre del Cargo")
    sueldo = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Sueldo")

    class Meta:
        verbose_name = "Cargo"
        verbose_name_plural = "Cargos"

    def __str__(self):
        return self.nombre

class Empleado(models.Model):
    usuario = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name="Usuario de Sistema")
    ci = models.IntegerField(unique=True, verbose_name="Cédula de Identidad")
    apellido_p = models.CharField(max_length=50, verbose_name="Apellido Paterno")
    apellido_m = models.CharField(max_length=50, verbose_name="Apellido Materno")
    direccion = models.CharField(max_length=255, verbose_name="Dirección")
    telefono = models.IntegerField(verbose_name="Teléfono")
    empresa = models.ForeignKey(Empresa, on_delete=models.PROTECT, verbose_name="Empresa")
    departamento = models.ForeignKey(Departamento, on_delete=models.PROTECT, verbose_name="Departamento")
    cargo = models.ForeignKey(Cargo, on_delete=models.PROTECT, verbose_name="Cargo")
    rol = models.ForeignKey(Roles, on_delete=models.PROTECT, verbose_name="Rol")

    class Meta:
        verbose_name = "Empleado"
        verbose_name_plural = "Empleados"

    def __str__(self):
        # Asumimos que el nombre del empleado está en el campo 'first_name' del modelo User
        return f"{self.usuario.first_name} {self.apellido_p}"

class Proveedor(models.Model):
    nombre = models.CharField(max_length=150, verbose_name="Nombre del Proveedor")
    nit = models.CharField(max_length=20, unique=True, verbose_name="NIT")
    direccion = models.CharField(max_length=255, verbose_name="Dirección", blank=True, null=True)
    email = models.EmailField(verbose_name="Email", blank=True, null=True)
    pais = models.CharField(max_length=50, verbose_name="País", blank=True, null=True)
    estado = models.CharField(max_length=10, default='activo', verbose_name="Estado")
    
    class Meta:
        verbose_name = "Proveedor"
        verbose_name_plural = "Proveedores"

    def __str__(self):
        return self.nombre

# --- Modelos relacionados a Activos Fijos ---

class Estado(models.Model):
    nombre = models.CharField(max_length=50, verbose_name="Nombre del Estado")
    class Meta:
        verbose_name = "Estado"
        verbose_name_plural = "Estados"
    def __str__(self):
        return self.nombre

class CategoriaActivo(models.Model):
    nombre = models.CharField(max_length=100, verbose_name="Nombre de Categoría")
    descripcion = models.TextField(verbose_name="Descripción", blank=True, null=True)
    class Meta:
        verbose_name = "Categoría de Activo"
        verbose_name_plural = "Categorías de Activos"
    def __str__(self):
        return self.nombre

class Ubicacion(models.Model):
    nombre = models.CharField(max_length=100, verbose_name="Nombre de Ubicación")
    direccion = models.CharField(max_length=255, verbose_name="Dirección", blank=True, null=True)
    descripcion = models.TextField(verbose_name="Descripción", blank=True, null=True)
    class Meta:
        verbose_name = "Ubicación"
        verbose_name_plural = "Ubicaciones"
    def __str__(self):
        return self.nombre

class ActivoFijo(models.Model):
    nombre = models.CharField(max_length=150, verbose_name="Nombre del Activo")
    codigo_interno = models.IntegerField(unique=True, verbose_name="Código Interno")
    fecha_adquisicion = models.DateField(verbose_name="Fecha de Adquisición")
    valor_actual = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Valor Actual")
    vida_util = models.IntegerField(verbose_name="Vida Útil (años)")
    empresa = models.ForeignKey(Empresa, on_delete=models.PROTECT, verbose_name="Empresa")
    estado = models.ForeignKey(Estado, on_delete=models.PROTECT, verbose_name="Estado")
    categoria = models.ForeignKey(CategoriaActivo, on_delete=models.PROTECT, verbose_name="Categoría")
    ubicacion = models.ForeignKey(Ubicacion, on_delete=models.PROTECT, verbose_name="Ubicación")

    class Meta:
        verbose_name = "Activo Fijo"
        verbose_name_plural = "Activos Fijos"
    def __str__(self):
        return f"{self.nombre} ({self.codigo_interno})"

class Inventario(models.Model):
    activo_fijo = models.OneToOneField(ActivoFijo, on_delete=models.CASCADE, primary_key=True, verbose_name="Activo Fijo")
    cantidad = models.IntegerField(verbose_name="Cantidad")
    class Meta:
        verbose_name = "Inventario"
        verbose_name_plural = "Inventarios"
    def __str__(self):
        return f"Inventario de {self.activo_fijo.nombre}"

class MovimientosInventario(models.Model):
    inventario = models.ForeignKey(Inventario, on_delete=models.CASCADE, verbose_name="Inventario")
    fecha = models.DateField(auto_now_add=True, verbose_name="Fecha")
    tipo_movimiento = models.CharField(max_length=50, verbose_name="Tipo de Movimiento")
    cantidad = models.IntegerField(verbose_name="Cantidad")
    descripcion = models.TextField(verbose_name="Descripción")
    class Meta:
        verbose_name = "Movimiento de Inventario"
        verbose_name_plural = "Movimientos de Inventario"
    def __str__(self):
        return f"{self.tipo_movimiento} en {self.inventario.activo_fijo.nombre}"

# --- Modelos relacionados a Presupuestos y Contratos ---

class Presupuesto(models.Model):
    descripcion = models.CharField(max_length=255, verbose_name="Descripción")
    fecha_inicio = models.DateField(verbose_name="Fecha de Inicio")
    fecha_fin = models.DateField(verbose_name="Fecha de Fin")
    monto_total = models.DecimalField(max_digits=15, decimal_places=2, verbose_name="Monto Total")
    empresa = models.ForeignKey(Empresa, on_delete=models.CASCADE, verbose_name="Empresa")

    class Meta:
        verbose_name = "Presupuesto"
        verbose_name_plural = "Presupuestos"
    def __str__(self):
        return self.descripcion

class DetallePresupuesto(models.Model):
    presupuesto = models.ForeignKey(Presupuesto, on_delete=models.CASCADE, verbose_name="Presupuesto")
    categoria_activo = models.ForeignKey(CategoriaActivo, on_delete=models.PROTECT, verbose_name="Categoría de Activo")
    fecha = models.DateField(verbose_name="Fecha")
    monto_asignado = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Monto Asignado")
    class Meta:
        verbose_name = "Detalle de Presupuesto"
        verbose_name_plural = "Detalles de Presupuesto"
    def __str__(self):
        return f"Detalle de {self.presupuesto.descripcion} para {self.categoria_activo.nombre}"

class ContratosProveedores(models.Model):
    proveedor = models.ForeignKey(Proveedor, on_delete=models.PROTECT, verbose_name="Proveedor")
    empleado = models.ForeignKey(Empleado, on_delete=models.PROTECT, verbose_name="Empleado Responsable")
    activo_fijo = models.ForeignKey(ActivoFijo, on_delete=models.SET_NULL, null=True, blank=True, verbose_name="Activo Fijo Relacionado")
    condiciones = models.TextField(verbose_name="Condiciones")
    fecha_inicio = models.DateField(verbose_name="Fecha de Inicio")
    fecha_final = models.DateField(verbose_name="Fecha Final")
    cantidad = models.IntegerField(verbose_name="Cantidad")
    monto = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Monto")
    estado = models.CharField(max_length=50, verbose_name="Estado del Contrato")
    class Meta:
        verbose_name = "Contrato con Proveedor"
        verbose_name_plural = "Contratos con Proveedores"
    def __str__(self):
        return f"Contrato con {self.proveedor.nombre}"

# --- Modelos de Gestión (Auditoría, Reportes, etc.) ---

class Auditoria(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.PROTECT, verbose_name="Empleado que realiza")
    accion = models.CharField(max_length=100, verbose_name="Acción Realizada")
    detalle = models.TextField(verbose_name="Detalle")
    fecha_limite = models.DateField(verbose_name="Fecha Límite")
    area_afectada = models.CharField(max_length=100, verbose_name="Área Afectada")
    class Meta:
        verbose_name = "Auditoría"
        verbose_name_plural = "Auditorías"
    def __str__(self):
        return f"Auditoría: {self.accion} por {self.empleado}"

class Reporte(models.Model):
    empleado = models.ForeignKey(Empleado, on_delete=models.PROTECT, verbose_name="Empleado que genera")
    nombre = models.CharField(max_length=150, verbose_name="Nombre del Reporte")
    tipo_reporte = models.CharField(max_length=50, verbose_name="Tipo de Reporte")
    fecha = models.DateField(auto_now_add=True, verbose_name="Fecha de Generación")
    descripcion = models.TextField(verbose_name="Descripción")
    class Meta:
        verbose_name = "Reporte"
        verbose_name_plural = "Reportes"
    def __str__(self):
        return self.nombre

# --- Modelos de Ciclo de Vida del Activo ---

class RevalorizacionActivos(models.Model):
    activo_fijo = models.ForeignKey(ActivoFijo, on_delete=models.CASCADE, verbose_name="Activo Fijo")
    fecha = models.DateField(verbose_name="Fecha de Revalorización")
    nuevo_valor = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Nuevo Valor")
    detalle = models.TextField(verbose_name="Detalle")
    class Meta:
        verbose_name = "Revalorización de Activo"
        verbose_name_plural = "Revalorizaciones de Activos"
    def __str__(self):
        return f"Revalorización de {self.activo_fijo.nombre}"

class TipoDepreciacion(models.Model):
    nombre = models.CharField(max_length=100, verbose_name="Nombre del Tipo")
    detalle = models.TextField(verbose_name="Detalle", blank=True, null=True)
    class Meta:
        verbose_name = "Tipo de Depreciación"
        verbose_name_plural = "Tipos de Depreciación"
    def __str__(self):
        return self.nombre

class DepreciacionActivos(models.Model):
    activo_fijo = models.ForeignKey(ActivoFijo, on_delete=models.CASCADE, verbose_name="Activo Fijo")
    tipo_depreciacion = models.ForeignKey(TipoDepreciacion, on_delete=models.PROTECT, verbose_name="Tipo de Depreciación")
    fecha = models.DateField(verbose_name="Fecha de Depreciación")
    monto_depreciado = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Monto Depreciado")
    class Meta:
        verbose_name = "Depreciación de Activo"
        verbose_name_plural = "Depreciaciones de Activos"
    def __str__(self):
        return f"Depreciación de {self.activo_fijo.nombre}"

class Divisas(models.Model):
    nombre = models.CharField(max_length=50, verbose_name="Nombre de la Divisa")
    codigo = models.CharField(max_length=3, verbose_name="Código")
    simbolo = models.CharField(max_length=5, verbose_name="Símbolo")
    tasa_cambio = models.DecimalField(max_digits=10, decimal_places=6, verbose_name="Tasa de Cambio")
    class Meta:
        verbose_name = "Divisa"
        verbose_name_plural = "Divisas"
    def __str__(self):
        return f"{self.nombre} ({self.codigo})"

class DisposicionActivos(models.Model):
    activo_fijo = models.ForeignKey(ActivoFijo, on_delete=models.CASCADE, verbose_name="Activo Fijo")
    divisa = models.ForeignKey(Divisas, on_delete=models.PROTECT, verbose_name="Divisa")
    fecha = models.DateField(verbose_name="Fecha de Disposición")
    motivo = models.CharField(max_length=255, verbose_name="Motivo")
    valor_disposicion = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Valor de Disposición")
    detalle = models.TextField(verbose_name="Detalle")
    class Meta:
        verbose_name = "Disposición de Activo"
        verbose_name_plural = "Disposiciones de Activos"
    def __str__(self):
        return f"Disposición de {self.activo_fijo.nombre}"

class Impuestos(models.Model):
    disposicion_activo = models.ForeignKey(DisposicionActivos, on_delete=models.CASCADE, verbose_name="Disposición de Activo")
    nombre = models.CharField(max_length=100, verbose_name="Nombre del Impuesto")
    cantidad = models.DecimalField(max_digits=12, decimal_places=2, verbose_name="Cantidad")
    class Meta:
        verbose_name = "Impuesto"
        verbose_name_plural = "Impuestos"
    def __str__(self):
        return self.nombre