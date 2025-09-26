import React, { useState, useEffect } from 'react';
import { obtenerDepartamentos, crearDepartamento, actualizarDepartamento, eliminarDepartamento } from '../servicios/departamentoServicio';

export default function GestionDepartamentos() {
  const [departamentos, setDepartamentos] = useState([]);
  const [itemActual, setItemActual] = useState({ nombre: '', descripcion: '' });
  const [esModalAbierto, setEsModalAbierto] = useState(false);
  const [esEditando, setEsEditando] = useState(false);

  useEffect(() => {
    cargarItems();
  }, []);

  const cargarItems = async () => {
    try {
      const res = await obtenerDepartamentos();
      setDepartamentos(res.data);
    } catch (error) {
      console.error("Error al cargar departamentos:", error);
    }
  };

  const handleAbrirModal = (item = null) => {
    if (item) {
      setItemActual(item);
      setEsEditando(true);
    } else {
      setItemActual({ nombre: '', descripcion: '' });
      setEsEditando(false);
    }
    setEsModalAbierto(true);
  };

  const handleCerrarModal = () => {
    setEsModalAbierto(false);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setItemActual({ ...itemActual, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (esEditando) {
        await actualizarDepartamento(itemActual.id, itemActual);
      } else {
        await crearDepartamento(itemActual);
      }
      cargarItems();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar el departamento:", error);
    }
  };

  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar este departamento?")) {
      try {
        await eliminarDepartamento(id);
        cargarItems();
      } catch (error) {
        console.error("Error al eliminar el departamento:", error);
      }
    }
  };

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Departamentos</h1>
      <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
        + Nuevo Departamento
      </button>

      <div className="bg-white shadow-md rounded my-6">
        <table className="min-w-max w-full table-auto">
          <thead>
            <tr className="bg-gray-200 text-gray-600 uppercase text-sm leading-normal">
              <th className="py-3 px-6 text-left">Nombre</th>
              <th className="py-3 px-6 text-left">Descripción</th>
              <th className="py-3 px-6 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody className="text-gray-600 text-sm font-light">
            {departamentos.map((item) => (
              <tr key={item.id} className="border-b border-gray-200 hover:bg-gray-100">
                <td className="py-3 px-6 text-left whitespace-nowrap">{item.nombre}</td>
                <td className="py-3 px-6 text-left">{item.descripcion}</td>
                <td className="py-3 px-6 text-center">
                  <div className="flex item-center justify-center">
                    <button onClick={() => handleAbrirModal(item)} className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
                    <button onClick={() => handleEliminar(item.id)} className="w-8 h-8 rounded-full bg-red-500 text-white text-sm font-bold">X</button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {esModalAbierto && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
          <div className="bg-white p-8 rounded-lg shadow-xl w-1/3">
            <h2 className="text-2xl font-bold mb-4">{esEditando ? 'Editar Departamento' : 'Nuevo Departamento'}</h2>
            <form onSubmit={handleSubmit}>
              <input name="nombre" value={itemActual.nombre} onChange={handleChange} placeholder="Nombre" className="w-full p-2 border rounded mb-2" required />
              <textarea name="descripcion" value={itemActual.descripcion} onChange={handleChange} placeholder="Descripción" className="w-full p-2 border rounded mb-4" />
              <div className="flex justify-end">
                <button type="button" onClick={handleCerrarModal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancelar</button>
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Guardar</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}