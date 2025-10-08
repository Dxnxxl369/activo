import React, { useState, useEffect } from 'react';
import { obtenerUbicaciones, crearUbicacion, actualizarUbicacion, eliminarUbicacion } from '../servicios/ubicacionServicio';
import Tabla from '../componentes/ui/Tabla';
import Modal from '../componentes/ui/Modal';
import VerDetallesModal from '../componentes/ui/VerDetallesModal';

const estadoInicialFormulario = { nombre: '', direccion: '', descripcion: '' };

export default function GestionUbicaciones() {
  const [ubicaciones, setUbicaciones] = useState([]);
  const [itemActual, setItemActual] = useState(estadoInicialFormulario);
  const [esModalAbierto, setEsModalAbierto] = useState(false);
  const [esEditando, setEsEditando] = useState(false);

  const [esModalVerAbierto, setEsModalVerAbierto] = useState(false);
  const [itemSeleccionado, setItemSeleccionado] = useState(null);

  useEffect(() => {
    cargarItems();
  }, []);

  const cargarItems = async () => {
    try {
      const res = await obtenerUbicaciones();
      setUbicaciones(res.data);
    } catch (error) {
      console.error("Error al cargar ubicaciones:", error);
    }
  };

  const handleAbrirModal = (item = null) => {
    if (item) {
      setItemActual(item);
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
        await actualizarUbicacion(itemActual.id, itemActual);
      } else {
        await crearUbicacion(itemActual);
      }
      cargarItems();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar la ubicación:", error);
    }
  };

  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar esta ubicación?")) {
      try {
        await eliminarUbicacion(id);
        cargarItems();
      } catch (error) {
        console.error("Error al eliminar la ubicación:", error);
      }
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
  
  const columnas = [
      { Header: 'Nombre', accessor: 'nombre', className: 'text-left' },
      { Header: 'Dirección', accessor: 'direccion', className: 'text-left' },
      { Header: 'Descripción', accessor: 'descripcion', className: 'text-left' },
  ];

  const renderizarAcciones = (fila) => (
      <>
          <button onClick={() => handleAbrirModalVer(fila)} title="Ver Detalles" className="w-8 h-8 rounded-full bg-blue-500 text-white mr-2 text-sm font-bold">V</button>
          <button onClick={() => handleAbrirModal(fila)} className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
          <button onClick={() => handleEliminar(fila.id)} className="w-8 h-8 rounded-full bg-red-500 text-white text-sm font-bold">X</button>
      </>
  );

  

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Ubicaciones</h1>
      <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
        + Nueva Ubicación
      </button>

      <Tabla columnas={columnas} datos={ubicaciones} acciones={renderizarAcciones} />

      <Modal titulo={esEditando ? 'Editar Ubicación' : 'Nueva Ubicación'} estaAbierto={esModalAbierto} onClose={handleCerrarModal}>
          <form onSubmit={handleSubmit}>
            <input name="nombre" value={itemActual.nombre} onChange={handleChange} placeholder="Nombre (Ej: Oficina Central, Almacén 2)" className="w-full p-2 border rounded mb-2" required />
            <input name="direccion" value={itemActual.direccion} onChange={handleChange} placeholder="Dirección Completa" className="w-full p-2 border rounded mb-2" />
            <textarea name="descripcion" value={itemActual.descripcion} onChange={handleChange} placeholder="Descripción adicional" className="w-full p-2 border rounded mb-4" />
            <div className="flex justify-end">
              <button type="button" onClick={handleCerrarModal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
              <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Guardar</button>
            </div>
          </form>
      </Modal>

      <VerDetallesModal
        estaAbierto={esModalVerAbierto}
        onClose={handleCerrarModalVer}
        item={itemSeleccionado}
        titulo="Ubicación"
      />

    </div>
  );
}
