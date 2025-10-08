import React, { useState, useEffect } from 'react';
import { obtenerProveedores, crearProveedor, actualizarProveedor, eliminarProveedor } from '../servicios/proveedorServicio';
import Tabla from '../componentes/ui/Tabla';
import Modal from '../componentes/ui/Modal';
import VerDetallesModal from '../componentes/ui/VerDetallesModal';

const estadoInicialFormulario = { nombre: '', nit: '', direccion: '', email: '', pais: '' };

export default function GestionProveedores() {
  const [proveedores, setProveedores] = useState([]);
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
      const res = await obtenerProveedores();
      setProveedores(res.data);
    } catch (error) {
      console.error("Error al cargar proveedores:", error);
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

  const handleChange = (e) => {
    setItemActual({ ...itemActual, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (esEditando) {
        await actualizarProveedor(itemActual.id, itemActual);
      } else {
        await crearProveedor(itemActual);
      }
      cargarItems();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar el proveedor:", error);
    }
  };

  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas desactivar este proveedor? Ya no aparecerá en las listas.")) {
      try {
        await eliminarProveedor(id); 
        cargarItems();
      } catch (error) {
        console.error("Error al desactivar el proveedor:", error);
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
    { Header: 'NIT', accessor: 'nit', className: 'text-left' },
    { Header: 'Email', accessor: 'email', className: 'text-left' },
    { Header: 'País', accessor: 'pais', className: 'text-left' },
  ];

  const renderizarAcciones = (fila) => (
    <>
      <button onClick={() => handleAbrirModalVer(fila)} title="Ver Detalles" className="w-8 h-8 rounded-full bg-blue-500 text-white mr-2 text-sm font-bold">V</button>
      <button onClick={() => handleAbrirModal(fila)} title="Editar" className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
      <button onClick={() => handleEliminar(fila.id)} title="Eliminar/Desactivar" className="w-8 h-8 rounded-full bg-red-500 text-white text-sm font-bold">X</button>
    </>
  );

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Proveedores</h1>
      <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
        + Nuevo Proveedor
      </button>

      <Tabla 
        columnas={columnas} 
        datos={proveedores} 
        acciones={renderizarAcciones} 
      />

      <Modal titulo={esEditando ? 'Editar Proveedor' : 'Nuevo Proveedor'} estaAbierto={esModalAbierto} onClose={handleCerrarModal}>
        <form onSubmit={handleSubmit}>
          <input name="nombre" value={itemActual.nombre} onChange={handleChange} placeholder="Nombre del Proveedor" className="w-full p-2 border rounded mb-2" required />
          <input name="nit" value={itemActual.nit} onChange={handleChange} placeholder="NIT" className="w-full p-2 border rounded mb-2" required />
          <input name="email" type="email" value={itemActual.email} onChange={handleChange} placeholder="Email" className="w-full p-2 border rounded mb-2" />
          <input name="direccion" value={itemActual.direccion} onChange={handleChange} placeholder="Dirección" className="w-full p-2 border rounded mb-2" />
          <input name="pais" value={itemActual.pais} onChange={handleChange} placeholder="País" className="w-full p-2 border rounded mb-4" />
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
        titulo="Proveedor"
      />
    </div>
  );
}
