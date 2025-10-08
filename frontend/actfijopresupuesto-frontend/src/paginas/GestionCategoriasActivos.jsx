import React, { useState, useEffect } from 'react';
import { obtenerCategorias, crearCategoria, actualizarCategoria, eliminarCategoria } from '../servicios/categoriaActivoServicio';
import Modal from '../componentes/ui/Modal';
import Tabla from '../componentes/ui/Tabla';

const estadoInicialFormulario = { nombre: '', descripcion: '' };

export default function GestionCategoriasActivos() {
  const [categorias, setCategorias] = useState([]);
  const [itemActual, setItemActual] = useState(estadoInicialFormulario);
  const [esModalAbierto, setEsModalAbierto] = useState(false);
  const [esEditando, setEsEditando] = useState(false);

  useEffect(() => {
    cargarItems();
  }, []);

  const cargarItems = async () => {
    try {
      const res = await obtenerCategorias();
      setCategorias(res.data);
    } catch (error) {
      console.error("Error al cargar categorías:", error);
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
        await actualizarCategoria(itemActual.id, itemActual);
      } else {
        await crearCategoria(itemActual);
      }
      cargarItems();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar la categoría:", error);
    }
  };

  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar esta categoría?")) {
      try {
        await eliminarCategoria(id);
        cargarItems();
      } catch (error) {
        console.error("Error al eliminar la categoría:", error);
      }
    }
  };

  const columnas = [
      { Header: 'Nombre', accessor: 'nombre', className: 'text-left' },
      { Header: 'Descripción', accessor: 'descripcion', className: 'text-left' },
  ];

  const renderizarAcciones = (fila) => (
      <>
          <button onClick={() => handleAbrirModal(fila)} className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
          <button onClick={() => handleEliminar(fila.id)} className="w-8 h-8 rounded-full bg-red-500 text-white text-sm font-bold">X</button>
      </>
  );

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Categorías de Activos</h1>
      <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
        + Nueva Categoría
      </button>

      <Tabla columnas={columnas} datos={categorias} acciones={renderizarAcciones} />

      <Modal titulo={esEditando ? 'Editar Categoría' : 'Nueva Categoría'} estaAbierto={esModalAbierto} onClose={handleCerrarModal}>
          <form onSubmit={handleSubmit}>
            <input name="nombre" value={itemActual.nombre} onChange={handleChange} placeholder="Nombre de la categoría" className="w-full p-2 border rounded mb-2" required />
            <textarea name="descripcion" value={itemActual.descripcion} onChange={handleChange} placeholder="Descripción" className="w-full p-2 border rounded mb-4" />
            <div className="flex justify-end">
              <button type="button" onClick={handleCerrarModal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
              <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Guardar</button>
            </div>
          </form>
      </Modal>
    </div>
  );
}
