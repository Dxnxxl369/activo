// src/paginas/GestionEmpresas.jsx
import React, { useState, useEffect } from 'react';
import { obtenerEmpresas, crearEmpresa, actualizarEmpresa, eliminarEmpresa } from '../servicios/empresaServicio';

export default function GestionEmpresas() {
  const [empresas, setEmpresas] = useState([]);
  const [empresaActual, setEmpresaActual] = useState({ nombre: '', nit: '', direccion: '', email: '', telefono: '' });
  const [esModalAbierto, setEsModalAbierto] = useState(false);
  const [esEditando, setEsEditando] = useState(false);

  useEffect(() => {
    cargarEmpresas();
  }, []);

  const cargarEmpresas = async () => {
    try {
      const res = await obtenerEmpresas();
      setEmpresas(res.data);
    } catch (error) {
      console.error("Error al cargar empresas:", error);
    }
  };

  const handleAbrirModal = (empresa = null) => {
    if (empresa) {
      setEmpresaActual(empresa);
      setEsEditando(true);
    } else {
      setEmpresaActual({ nombre: '', nit: '', direccion: '', email: '', telefono: '' });
      setEsEditando(false);
    }
    setEsModalAbierto(true);
  };

  const handleCerrarModal = () => {
    setEsModalAbierto(false);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEmpresaActual({ ...empresaActual, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (esEditando) {
        await actualizarEmpresa(empresaActual.id, empresaActual);
      } else {
        await crearEmpresa(empresaActual);
      }
      cargarEmpresas();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar la empresa:", error);
    }
  };

  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar esta empresa?")) {
      try {
        await eliminarEmpresa(id);
        cargarEmpresas();
      } catch (error) {
        console.error("Error al eliminar la empresa:", error);
      }
    }
  };

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Empresas</h1>
      <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 mb-4">
        + Nueva Empresa
      </button>

      {/* Tabla de Empresas */}
      <div className="bg-white shadow-md rounded my-6">
        <table className="min-w-max w-full table-auto">
          <thead>
            <tr className="bg-gray-200 text-gray-600 uppercase text-sm leading-normal">
              <th className="py-3 px-6 text-left">Nombre</th>
              <th className="py-3 px-6 text-left">NIT</th>
              <th className="py-3 px-6 text-left">Email</th>
              <th className="py-3 px-6 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody className="text-gray-600 text-sm font-light">
            {empresas.map((empresa) => (
              <tr key={empresa.id} className="border-b border-gray-200 hover:bg-gray-100">
                <td className="py-3 px-6 text-left whitespace-nowrap">{empresa.nombre}</td>
                <td className="py-3 px-6 text-left">{empresa.nit}</td>
                <td className="py-3 px-6 text-left">{empresa.email}</td>
                <td className="py-3 px-6 text-center">
                  <div className="flex item-center justify-center">
                    <button onClick={() => handleAbrirModal(empresa)} className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2">E</button>
                    <button onClick={() => handleEliminar(empresa.id)} className="w-8 h-8 rounded-full bg-red-500 text-white">X</button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Modal para Crear/Editar Empresa */}
      {esModalAbierto && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
          <div className="bg-white p-8 rounded-lg shadow-xl w-1/3">
            <h2 className="text-2xl font-bold mb-4">{esEditando ? 'Editar Empresa' : 'Nueva Empresa'}</h2>
            <form onSubmit={handleSubmit}>
              {/* Aquí irían los inputs para nombre, nit, direccion, email, telefono */}
              <input name="nombre" value={empresaActual.nombre} onChange={handleChange} placeholder="Nombre" className="w-full p-2 border rounded mb-2" required />
              <input name="nit" value={empresaActual.nit} onChange={handleChange} placeholder="NIT" className="w-full p-2 border rounded mb-2" required />
              <input name="direccion" value={empresaActual.direccion} onChange={handleChange} placeholder="Dirección" className="w-full p-2 border rounded mb-2" />
              <input name="email" value={empresaActual.email} onChange={handleChange} placeholder="Email" className="w-full p-2 border rounded mb-2" />
              <input name="telefono" value={empresaActual.telefono} onChange={handleChange} placeholder="Teléfono" className="w-full p-2 border rounded mb-4" />
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