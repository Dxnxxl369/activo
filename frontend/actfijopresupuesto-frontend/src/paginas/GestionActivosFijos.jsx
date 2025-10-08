import React, { useState, useEffect } from 'react';
import { obtenerActivosFijos, crearActivoFijo, actualizarActivoFijo, eliminarActivoFijo } from '../servicios/activoFijoServicio';
import { crearRevalorizacion } from '../servicios/revalorizacionServicio';
import { obtenerEmpresas } from '../servicios/empresaServicio';
import { obtenerCategorias } from '../servicios/categoriaActivoServicio';
import { obtenerEstados } from '../servicios/estadoServicio';
import { obtenerUbicaciones } from '../servicios/ubicacionServicio';
import Tabla from '../componentes/ui/Tabla';
import Modal from '../componentes/ui/Modal';
import VerDetallesModal from '../componentes/ui/VerDetallesModal';

const estadoInicialFormulario = { nombre: '', codigo_interno: '', fecha_adquisicion: '', valor_actual: '', vida_util: '', empresa: '', estado: '', categoria: '', ubicacion: '' };
const estadoInicialRevalorizacion = { 
  tipo: 'fijo', // 'fijo' o 'porcentual'
  valor: '', 
  detalle: '', 
  fecha: new Date().toISOString().split('T')[0] 
};

export default function GestionActivosFijos() {
    const [activos, setActivos] = useState([]);
    const [itemActual, setItemActual] = useState(estadoInicialFormulario);
    const [esModalAbierto, setEsModalAbierto] = useState(false);
    const [esEditando, setEsEditando] = useState(false);
    const [empresas, setEmpresas] = useState([]);
    const [categorias, setCategorias] = useState([]);
    const [estados, setEstados] = useState([]);
    const [ubicaciones, setUbicaciones] = useState([]);
    const [esModalVerAbierto, setEsModalVerAbierto] = useState(false);
    const [itemSeleccionado, setItemSeleccionado] = useState(null);

    const [esModalRevalorizacionAbierto, setEsModalRevalorizacionAbierto] = useState(false);
    const [activoParaRevalorizar, setActivoParaRevalorizar] = useState(null);
    const [datosRevalorizacion, setDatosRevalorizacion] = useState(estadoInicialRevalorizacion);

    const cargarDatos = async () => {
        try {
            const [resActivos, resEmpresas, resCategorias, resEstados, resUbicaciones] = await Promise.all([
                obtenerActivosFijos(),
                obtenerEmpresas(),
                obtenerCategorias(),
                obtenerEstados(),
                obtenerUbicaciones(),
            ]);
            setActivos(resActivos.data);
            setEmpresas(resEmpresas.data);
            setCategorias(resCategorias.data);
            setEstados(resEstados.data);
            setUbicaciones(resUbicaciones.data);
        } catch (error) {
            console.error("Error al cargar datos:", error);
        }
    };

    useEffect(() => {
        cargarDatos();
    }, []);

    const handleAbrirModal = (item = null) => {
        if (item) {
            setItemActual({
                ...item,
                empresa: item.empresa.id,
                categoria: item.categoria.id,
                estado: item.estado.id,
                ubicacion: item.ubicacion.id,
            });
            setEsEditando(true);
        } else {
            setItemActual(estadoInicialFormulario);
            setEsEditando(false);
        }
        setEsModalAbierto(true);
    };

    const handleCerrarModal = () => setEsModalAbierto(false);
    const handleChange = (e) => setItemActual({ ...itemActual, [e.target.name]: e.target.value });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (esEditando) {
                await actualizarActivoFijo(itemActual.id, itemActual);
            } else {
                await crearActivoFijo(itemActual);
            }
            cargarDatos();
            handleCerrarModal();
        } catch (error) {
            console.error("Error al guardar activo:", error);
        }
    };

    const handleEliminar = async (id) => {
        if (window.confirm("¿Seguro que quieres eliminar este activo?")) {
            await eliminarActivoFijo(id);
            cargarDatos();
        }
    };

    const handleAbrirModalVer = (item) => {
        setItemSeleccionado(item);
        setEsModalVerAbierto(true);
    };
    const handleCerrarModalVer = () => {
        setEsModalVerAbierto(false);
        setItemSeleccionado(null);
    };

    const handleAbrirModalRevalorizacion = (activo) => {
        setActivoParaRevalorizar(activo);
        setDatosRevalorizacion(estadoInicialRevalorizacion);
        setEsModalRevalorizacionAbierto(true);
    };

    const handleCerrarModalRevalorizacion = () => setEsModalRevalorizacionAbierto(false);

    const handleChangeRevalorizacion = (e) => {
        setDatosRevalorizacion({ ...datosRevalorizacion, [e.target.name]: e.target.value });
    };
    
    const handleSubmitRevalorizacion = async (e) => {
        e.preventDefault();
        if (!activoParaRevalorizar || datosRevalorizacion.valor === '') return;

        let nuevoValorCalculado;
        const valorActual = parseFloat(activoParaRevalorizar.valor_actual);
        const valorInput = parseFloat(datosRevalorizacion.valor);

        if (datosRevalorizacion.tipo === 'porcentual') {
            // Se calcula el nuevo valor basado en el porcentaje (puede ser negativo)
            nuevoValorCalculado = valorActual * (1 + (valorInput / 100));
        } else { // tipo === 'fijo'
            // El nuevo valor es el monto fijo ingresado
            nuevoValorCalculado = valorInput;
        }

        // Regla de negocio: no permitir que un activo tenga valor negativo
        if (nuevoValorCalculado < 0) {
            alert("El nuevo valor del activo no puede ser negativo.");
            return;
        }

        const datosAEnviar = {
            activo_fijo: activoParaRevalorizar.id,
            nuevo_valor: nuevoValorCalculado.toFixed(2), // Enviamos el valor ya calculado
            detalle: datosRevalorizacion.detalle,
            fecha: datosRevalorizacion.fecha,
        };

        try {
            await crearRevalorizacion(datosAEnviar);
            alert(`Activo revalorizado con éxito. Nuevo valor: ${datosAEnviar.nuevo_valor}`);
            handleCerrarModalRevalorizacion();
            // Actualizamos el estado local para ver el cambio al instante
            const activosActualizados = activos.map(a => 
                a.id === activoParaRevalorizar.id ? { ...a, valor_actual: datosAEnviar.nuevo_valor } : a
            );
            setActivos(activosActualizados);
        } catch (error) {
            console.error("Error al revalorizar el activo:", error);
            alert("Error al guardar la revalorización.");
        }
    };
    
    const columnas = [
        { Header: 'Nombre', accessor: 'nombre', className: 'text-left' },
        { Header: 'Código', accessor: 'codigo_interno', className: 'text-left' },
        { Header: 'Valor Actual', accessor: 'valor_actual', className: 'text-left' },
        { Header: 'Categoría', accessor: 'categoria.nombre', className: 'text-left' },
    ];

    const renderizarAcciones = (fila) => (
        <>
            <button onClick={() => handleAbrirModalVer(fila)} title="Ver Detalles" className="w-8 h-8 rounded-full bg-blue-500 text-white mr-2 text-sm font-bold">V</button>
            <button onClick={() => handleAbrirModal(fila)} title="Editar" className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
            <button onClick={() => handleEliminar(fila.id)} title="Eliminar" className="w-8 h-8 rounded-full bg-red-500 text-white mr-2 text-sm font-bold">X</button>
            <button onClick={() => handleAbrirModalRevalorizacion(fila)} title="Revalorizar Activo" className="w-8 h-8 rounded-full bg-green-500 text-white text-sm font-bold">R</button>
        </>
    );

    return (
        <div className="container mx-auto">
            <h1 className="text-3xl font-bold mb-6">Gestión de Activos Fijos</h1>
            <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
                + Nuevo Activo
            </button>
            
            <Tabla columnas={columnas} datos={activos} acciones={renderizarAcciones} />
            
            <Modal titulo={esEditando ? 'Editar Activo' : 'Nuevo Activo'} estaAbierto={esModalAbierto} onClose={handleCerrarModal}>
                <form onSubmit={handleSubmit}>
                    <div className="grid grid-cols-2 gap-4">
                        <input name="nombre" value={itemActual.nombre} onChange={handleChange} placeholder="Nombre del activo" className="p-2 border rounded" required />
                        <input name="codigo_interno" type="number" value={itemActual.codigo_interno} onChange={handleChange} placeholder="Código Interno" className="p-2 border rounded" required />
                        <input name="fecha_adquisicion" type="date" value={itemActual.fecha_adquisicion} onChange={handleChange} className="p-2 border rounded" required />
                        <input name="valor_actual" type="number" step="0.01" value={itemActual.valor_actual} onChange={handleChange} placeholder="Valor Actual" className="p-2 border rounded" required />
                        <input name="vida_util" type="number" value={itemActual.vida_util} onChange={handleChange} placeholder="Vida Útil (años)" className="p-2 border rounded" required />
                        
                        <select name="empresa" value={itemActual.empresa} onChange={handleChange} className="p-2 border rounded" required>
                            <option value="">Seleccionar Empresa</option>
                            {empresas.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                        </select>
                        <select name="categoria" value={itemActual.categoria} onChange={handleChange} className="p-2 border rounded" required>
                            <option value="">Seleccionar Categoría</option>
                            {categorias.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
                        </select>
                        <select name="estado" value={itemActual.estado} onChange={handleChange} className="p-2 border rounded" required>
                            <option value="">Seleccionar Estado</option>
                            {estados.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                        </select>
                        <select name="ubicacion" value={itemActual.ubicacion} onChange={handleChange} className="p-2 border rounded" required>
                            <option value="">Seleccionar Ubicación</option>
                            {ubicaciones.map(u => <option key={u.id} value={u.id}>{u.nombre}</option>)}
                        </select>
                    </div>
                    <div className="flex justify-end mt-6">
                        <button type="button" onClick={handleCerrarModal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
                        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Guardar</button>
                    </div>
                </form>
            </Modal>

            <VerDetallesModal
                estaAbierto={esModalVerAbierto}
                onClose={handleCerrarModalVer}
                item={itemSeleccionado}
                titulo="Activo Fijo"
            />

            <Modal titulo={`Revalorizar: ${activoParaRevalorizar?.nombre || ''}`} estaAbierto={esModalRevalorizacionAbierto} onClose={handleCerrarModalRevalorizacion}>
                <form onSubmit={handleSubmitRevalorizacion}>
                    <p className="mb-4 text-center">Valor Actual: <span className="font-bold text-lg">${activoParaRevalorizar?.valor_actual}</span></p>

                    {/* Selector de Tipo de Revalorización */}
                    <div className="flex justify-center mb-4 border rounded-lg p-1 bg-gray-100">
                        <button type="button" onClick={() => setDatosRevalorizacion({...datosRevalorizacion, tipo: 'fijo'})}
                            className={`w-1/2 p-2 rounded-md transition ${datosRevalorizacion.tipo === 'fijo' ? 'bg-blue-500 text-white shadow' : 'text-gray-600'}`}>
                            Monto Fijo
                        </button>
                        <button type="button" onClick={() => setDatosRevalorizacion({...datosRevalorizacion, tipo: 'porcentual'})}
                            className={`w-1/2 p-2 rounded-md transition ${datosRevalorizacion.tipo === 'porcentual' ? 'bg-blue-500 text-white shadow' : 'text-gray-600'}`}>
                            Porcentual
                        </button>
                    </div>

                    <div className="grid grid-cols-1 gap-4">
                        {/* Input Condicional */}
                        {datosRevalorizacion.tipo === 'fijo' ? (
                            <input name="valor" type="number" step="0.01" value={datosRevalorizacion.valor} onChange={handleChangeRevalorizacion} 
                                   placeholder="Nuevo Valor Final del Activo" className="p-2 border rounded" required />
                        ) : (
                            <input name="valor" type="number" step="0.01" value={datosRevalorizacion.valor} onChange={handleChangeRevalorizacion}
                                   placeholder="Porcentaje de variación (Ej: 10 o -5)" className="p-2 border rounded" required />
                        )}
                        
                        <textarea name="detalle" value={datosRevalorizacion.detalle} onChange={handleChangeRevalorizacion} placeholder="Detalle o motivo" className="p-2 border rounded" required />
                        <input name="fecha" type="date" value={datosRevalorizacion.fecha} onChange={handleChangeRevalorizacion} className="p-2 border rounded" required />
                    </div>
                    <div className="flex justify-end mt-6">
                        <button type="button" onClick={handleCerrarModalRevalorizacion} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
                        <button type="submit" className="bg-green-500 text-white px-4 py-2 rounded">Aplicar Revalorización</button>
                    </div>
                </form>
            </Modal>
        </div>
    );
}

