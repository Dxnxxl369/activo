import React, { useState, useEffect } from 'react';
import { 
    obtenerPresupuestos, crearPresupuesto, actualizarPresupuesto, eliminarPresupuesto, 
    crearDetallePresupuesto, eliminarDetallePresupuesto 
} from '../servicios/presupuestoServicio';
import { obtenerCategorias } from '../servicios/categoriaActivoServicio';
import { obtenerEmpresas } from '../servicios/empresaServicio';
import Modal from '../componentes/ui/Modal';
import VerDetallesModal from '../componentes/ui/VerDetallesModal';

// Estados iniciales para los formularios, para una fácil limpieza.
const estadoInicialDetalle = { categoria_activo: '', monto_asignado: '', fecha: new Date().toISOString().split('T')[0] };
const estadoInicialPrincipal = { descripcion: '', fecha_inicio: '', fecha_fin: '', monto_total: '', empresa: '' };

export default function GestionPresupuestos() {
    // Estado para las listas de datos
    const [presupuestos, setPresupuestos] = useState([]);
    const [categorias, setCategorias] = useState([]);
    const [empresas, setEmpresas] = useState([]);
    
    // Estado para la interacción principal (maestro-detalle)
    const [presupuestoSeleccionado, setPresupuestoSeleccionado] = useState(null);
    const [nuevoDetalle, setNuevoDetalle] = useState(estadoInicialDetalle);
    
    // Estado para el modal de Crear/Editar Presupuesto Principal
    const [itemActual, setItemActual] = useState(estadoInicialPrincipal);
    const [esModalPrincipalAbierto, setEsModalPrincipalAbierto] = useState(false);
    const [esEditando, setEsEditando] = useState(false);

    // Estado para el modal de Ver Detalles
    const [esModalVerAbierto, setEsModalVerAbierto] = useState(false);
    const [itemSeleccionado, setItemSeleccionado] = useState(null);

    // Carga inicial de todos los datos necesarios para la página
    const cargarDatos = async () => {
        try {
            const [resPres, resCat, resEmp] = await Promise.all([
                obtenerPresupuestos(), 
                obtenerCategorias(),
                obtenerEmpresas()
            ]);
            setPresupuestos(resPres.data);
            setCategorias(resCat.data);
            setEmpresas(resEmp.data);
        } catch (error) {
            console.error("Error al cargar datos:", error);
        }
    };
    
    useEffect(() => {
        cargarDatos();
    }, []);

    const handleSeleccionarPresupuesto = (presupuesto) => {
        setPresupuestoSeleccionado(presupuesto);
    };
    
    // --- Handlers para el CRUD del Presupuesto Principal ---
    const handleAbrirModalPrincipal = (item = null) => {
        if (item) {
            setItemActual({ ...item, empresa: item.empresa.id });
            setEsEditando(true);
        } else {
            setItemActual(estadoInicialPrincipal);
            setEsEditando(false);
        }
        setEsModalPrincipalAbierto(true);
    };
    //const handleCerrarModalPrincipal = () => setEsModalPrincipalAbierto(false);
    const handleCerrarModalPrincipal = () => {
        setEsModalPrincipalAbierto(false);
        // Añade estas dos líneas para limpiar el estado del formulario:
        setItemActual(estadoInicialPrincipal); // Resetea los campos del formulario
        setEsEditando(false);                  // Asegura que la próxima vez no esté en modo edición
    };
    const handleChangePrincipal = (e) => setItemActual({ ...itemActual, [e.target.name]: e.target.value });
    const handleSubmitPrincipal = async (e) => {
        e.preventDefault();
        console.log("Enviando datos:", itemActual, "¿Modo edición?", esEditando);
        try {
            if (esEditando) {
                await actualizarPresupuesto(itemActual.id, itemActual);
            } else {
                const { id, ...datosParaCrear } = itemActual;
                await crearPresupuesto(datosParaCrear);
            }
            cargarDatos();
            handleCerrarModalPrincipal();
        } catch (error) {
            console.error("Error al guardar el presupuesto:", error);
            if (error.response) {
            console.error("Detalles del error del backend:", error.response.data);
        }
        }
    };
    const handleEliminarPrincipal = async (id, e) => {
        e.stopPropagation();
        if (window.confirm("¿Seguro que quieres eliminar este presupuesto y todas sus asignaciones?")) {
            try {
                await eliminarPresupuesto(id);
                setPresupuestoSeleccionado(null);
                cargarDatos();
            } catch (error) {
                console.error("Error al eliminar presupuesto:", error);
            }
        }
    };
    
    // --- Handlers para el formulario de Asignaciones (Detalles) ---
    const handleChangeDetalle = (e) => {
        setNuevoDetalle({ ...nuevoDetalle, [e.target.name]: e.target.value });
    };
    const handleSubmitDetalle = async (e) => {
        e.preventDefault();
        if (!presupuestoSeleccionado) return;
        
        const datosAEnviar = { ...nuevoDetalle, presupuesto: presupuestoSeleccionado.id };
        try {
            await crearDetallePresupuesto(datosAEnviar);
            alert('Asignación creada con éxito');
            setNuevoDetalle(estadoInicialDetalle);
            await cargarDatos(); // Recargamos todo para ver el nuevo detalle reflejado
        } catch (error) {
            console.error("Error al crear la asignación:", error);
            alert('Error al crear la asignación');
        }
    };
    
    // --- Handlers para el modal de Ver Detalles ---
    const handleAbrirModalVer = (item) => {
        setItemSeleccionado(item);
        setEsModalVerAbierto(true);
    };
    const handleCerrarModalVer = () => {
        setEsModalVerAbierto(false);
        setItemSeleccionado(null);
    };

    const handleEliminarDetalle = async (detalleId) => {
        if (window.confirm("¿Estás seguro de que deseas eliminar esta asignación de presupuesto?")) {
            try {
                await eliminarDetallePresupuesto(detalleId);
                alert('Asignación eliminada con éxito.');
                // Recargamos todos los datos para que la lista se actualice
                await cargarDatos();
            } catch (error) {
                console.error("Error al eliminar la asignación:", error);
                alert('No se pudo eliminar la asignación.');
            }
        }
    };
    
    return (
        <div className="container mx-auto">
            <h1 className="text-3xl font-bold mb-6">Gestión y Asignación de Presupuestos</h1>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* Columna Izquierda: Lista de Presupuestos Principales */}
                <div className="md:col-span-1 bg-white p-4 rounded-lg shadow">
                    <div className="flex justify-between items-center mb-2">
                        <h2 className="text-xl font-semibold">Presupuestos</h2>
                        <button onClick={() => handleAbrirModalPrincipal()} className="bg-blue-500 text-white px-3 py-1 rounded-md text-sm hover:bg-blue-600" title="Crear Nuevo Presupuesto">
                            + Nuevo
                        </button>
                    </div>
                    <ul>
                        {presupuestos.map(p => (
                            <li key={p.id} onClick={() => handleSeleccionarPresupuesto(p)}
                                className={`p-2 rounded cursor-pointer flex justify-between items-center ${presupuestoSeleccionado?.id === p.id ? 'bg-blue-500 text-white' : 'hover:bg-gray-200'}`}>
                                <span className="truncate pr-2">{p.descripcion} (${p.monto_total})</span>
                                <div className="flex-shrink-0">
                                    <button onClick={(e) => { e.stopPropagation(); handleAbrirModalVer(p); }} title="Ver Detalles" className="text-xs px-2 py-1 rounded bg-blue-400 text-white mr-1">V</button>
                                    <button onClick={(e) => { e.stopPropagation(); handleAbrirModalPrincipal(p); }} title="Editar" className="text-xs px-2 py-1 rounded bg-yellow-400 text-white mr-1">E</button>
                                    <button onClick={(e) => handleEliminarPrincipal(p.id, e)} title="Eliminar" className="text-xs px-2 py-1 rounded bg-red-500 text-white">X</button>
                                </div>
                            </li>
                        ))}
                    </ul>
                </div>

                {/* Columna Derecha: Detalles y Formulario de Asignación */}
                <div className="md:col-span-2 bg-white p-6 rounded-lg shadow">
                    {presupuestoSeleccionado ? (
                        <>
                            <h2 className="text-xl font-semibold mb-4">Detalles de: "{presupuestoSeleccionado.descripcion}"</h2>
                            
                            <form onSubmit={handleSubmitDetalle} className="mb-6 p-4 border rounded-lg bg-gray-50">
                                <h3 className="font-semibold mb-2">Nueva Asignación</h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <select name="categoria_activo" value={nuevoDetalle.categoria_activo} onChange={handleChangeDetalle} className="p-2 border rounded" required>
                                        <option value="">Seleccionar Categoría</option>
                                        {categorias.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
                                    </select>
                                    <input name="monto_asignado" type="number" step="0.01" value={nuevoDetalle.monto_asignado} onChange={handleChangeDetalle} placeholder="Monto a asignar" className="p-2 border rounded" required/>
                                </div>
                                <button type="submit" className="mt-4 bg-green-500 text-white px-4 py-2 rounded-md hover:bg-green-600">Asignar</button>
                            </form>

                            <h3 className="font-semibold mb-2">Asignaciones Actuales</h3>
                            <ul>
                                {presupuestos.find(p => p.id === presupuestoSeleccionado.id)?.detallepresupuesto_set?.map(d => (
                                    <li key={d.id} className="flex justify-between items-center p-2 border-b group">
                                        <span>{d.categoria_activo.nombre} ({new Date(d.fecha).toLocaleDateString()})</span>
                                        <div className="flex items-center">
                                            <span className="font-bold mr-4">${d.monto_asignado}</span>
                                            <button 
                                                onClick={() => handleEliminarDetalle(d.id)} 
                                                className="text-red-500 hover:text-red-700 opacity-0 group-hover:opacity-100 transition-opacity"
                                                title="Eliminar esta asignación"
                                            >
                                                &times; {/* Esto crea un ícono de 'X' */}
                                            </button>
                                        </div>
                                    </li>
                                )) || <li className="text-gray-500">No hay asignaciones para este presupuesto.</li>}
                            </ul>
                        </>
                    ) : (
                        <div className="flex items-center justify-center h-full">
                            <p className="text-gray-500">Selecciona un presupuesto para ver sus detalles y realizar asignaciones.</p>
                        </div>
                    )}
                </div>
            </div>

            <Modal titulo={esEditando ? 'Editar Presupuesto' : 'Nuevo Presupuesto'} estaAbierto={esModalPrincipalAbierto} onClose={handleCerrarModalPrincipal}>
                <form onSubmit={handleSubmitPrincipal}>
                    <div className="grid grid-cols-2 gap-4">
                        <input name="descripcion" value={itemActual.descripcion} onChange={handleChangePrincipal} placeholder="Descripción del presupuesto" className="col-span-2 p-2 border rounded" required />
                        <input name="fecha_inicio" type="date" value={itemActual.fecha_inicio} onChange={handleChangePrincipal} className="p-2 border rounded" required />
                        <input name="fecha_fin" type="date" value={itemActual.fecha_fin} onChange={handleChangePrincipal} className="p-2 border rounded" required />
                        <input name="monto_total" type="number" step="0.01" value={itemActual.monto_total} onChange={handleChangePrincipal} placeholder="Monto Total" className="p-2 border rounded" required />
                        <select name="empresa" value={itemActual.empresa} onChange={handleChangePrincipal} className="p-2 border rounded" required>
                            <option value="">Seleccionar Empresa</option>
                            {empresas.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                        </select>
                    </div>
                    <div className="flex justify-end mt-6">
                        <button type="button" onClick={handleCerrarModalPrincipal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
                        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Guardar</button>
                    </div>
                </form>
            </Modal>

            <VerDetallesModal
                estaAbierto={esModalVerAbierto}
                onClose={handleCerrarModalVer}
                item={itemSeleccionado}
                titulo="Presupuesto"
            />
        </div>
    );
}

