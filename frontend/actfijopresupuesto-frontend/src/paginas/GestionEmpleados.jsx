import React, { useState, useEffect } from 'react';
import { obtenerEmpleados, crearEmpleado, actualizarEmpleado, eliminarEmpleado } from '../servicios/empleadoServicio';
import { obtenerEmpresas } from '../servicios/empresaServicio';
import { obtenerDepartamentos } from '../servicios/departamentoServicio';
import { obtenerCargos } from '../servicios/cargoServicio';
import { obtenerRoles } from '../servicios/rolServicio';

const estadoInicialFormulario = {
  username: '', password: '', first_name: '', email: '',
  ci: '', apellido_p: '', apellido_m: '', direccion: '', telefono: '',
  empresa: '', departamento: '', cargo: '', rol: ''
};

export default function GestionEmpleados() {
  const [empleados, setEmpleados] = useState([]);
  const [busqueda, setBusqueda] = useState("");
  const [itemActual, setItemActual] = useState(estadoInicialFormulario);
  const [esModalAbierto, setEsModalAbierto] = useState(false);
  const [esEditando, setEsEditando] = useState(false);
  const [errorFormulario, setErrorFormulario] = useState('');
  const [estaCargando, setEstaCargando] = useState(false);

  const [empresas, setEmpresas] = useState([]);
  const [departamentos, setDepartamentos] = useState([]);
  const [cargos, setCargos] = useState([]);
  const [roles, setRoles] = useState([]);

  const cargarEmpleados = async () => {
    try {
      const res = await obtenerEmpleados(busqueda);
      setEmpleados(res.data);
    } catch (error) {
      console.error("Error cargando empleados:", error);
    }
  };

  useEffect(() => {
    const timerId = setTimeout(() => cargarEmpleados(), 500);
    return () => clearTimeout(timerId);
  }, [busqueda]);

  useEffect(() => {
    const cargarDatosParaFormulario = async () => {
      try {
        const [resEmp, resDep, resCar, resRol] = await Promise.all([
          obtenerEmpresas(), obtenerDepartamentos(), obtenerCargos(), obtenerRoles()
        ]);
        setEmpresas(resEmp.data);
        setDepartamentos(resDep.data);
        setCargos(resCar.data);
        setRoles(resRol.data);
      } catch (error) {
        console.error("Error al cargar datos para el formulario:", error);
      }
    };
    cargarDatosParaFormulario();
  }, []);

  const handleAbrirModal = (item = null) => {
    setErrorFormulario('');
    if (item) {
      setItemActual({
        id: item.id,
        username: item.usuario.username, first_name: item.usuario.first_name, email: item.usuario.email,
        ci: item.ci, apellido_p: item.apellido_p, apellido_m: item.apellido_m,
        direccion: item.direccion, telefono: item.telefono,
        empresa: item.empresa.id, departamento: item.departamento.id,
        cargo: item.cargo.id, rol: item.rol.id,
      });
      setEsEditando(true);
    } else {
      setItemActual(estadoInicialFormulario);
      setEsEditando(false);
    }
    setEsModalAbierto(true);
  };
  
  const handleCerrarModal = () => setEsModalAbierto(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setItemActual({ ...itemActual, [name]: value });
  };

  // <-- AÑADIMOS ESTA FUNCIÓN PARA MANEJAR LA ELIMINACIÓN -->
  const handleEliminar = async (id) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar este empleado?")) {
      try {
        await eliminarEmpleado(id);
        cargarEmpleados(); // Recargamos la lista después de eliminar
      } catch (error) {
        console.error("Error al eliminar el empleado:", error);
        alert("No se pudo eliminar el empleado.");
      }
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorFormulario('');
    setEstaCargando(true);

    if (!itemActual.empresa || !itemActual.departamento || !itemActual.cargo || !itemActual.rol) {
      setErrorFormulario('Por favor, selecciona una opción en todos los campos desplegables.');
      setEstaCargando(false);
      return;
    }

    const datosAEnviar = { ...itemActual };
    
    if (esEditando) {
      if (!datosAEnviar.password) {
        delete datosAEnviar.password;
      }
    }
    
    try {
      if (esEditando) {
        await actualizarEmpleado(itemActual.id, datosAEnviar);
      } else {
        await crearEmpleado(datosAEnviar);
      }
      cargarEmpleados();
      handleCerrarModal();
    } catch (error) {
      console.error("Error al guardar el empleado:", error.response?.data || error);
      const erroresBackend = error.response?.data;
      if (erroresBackend) {
        const mensajesError = Object.entries(erroresBackend).map(([campo, mensajes]) => `${campo}: ${mensajes.join(', ')}`).join('; ');
        setErrorFormulario(mensajesError);
      } else {
        setErrorFormulario('Ocurrió un error al guardar. Revisa los datos.');
      }
    } finally {
        setEstaCargando(false);
    }
  };

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Empleados</h1>
       <div className="flex justify-between items-center mb-4">
        <input
          type="text"
          value={busqueda}
          onChange={(e) => setBusqueda(e.target.value)}
          placeholder="Buscar por nombre, CI o apellido..."
          className="w-1/3 p-2 border rounded"
        />
        <button onClick={() => handleAbrirModal()} className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">
          + Nuevo Empleado
        </button>
      </div>

      <div className="bg-white shadow-md rounded my-6">
          <table className="min-w-max w-full table-auto">
              <thead>
                <tr className="bg-gray-200 text-gray-600 uppercase text-sm leading-normal">
                    <th className="py-3 px-6 text-left">Nombre</th>
                    <th className="py-3 px-6 text-left">CI</th>
                    <th className="py-3 px-6 text-left">Cargo</th>
                    <th className="py-3 px-6 text-center">Acciones</th>
                </tr>
              </thead>
              <tbody className="text-gray-600 text-sm font-light">
                {empleados.map((empleado) => (
                    <tr key={empleado.id} className="border-b border-gray-200 hover:bg-gray-100">
                        <td className="py-3 px-6 text-left">{empleado.usuario.first_name} {empleado.apellido_p}</td>
                        <td className="py-3 px-6 text-left">{empleado.ci}</td>
                        <td className="py-3 px-6 text-left">{empleado.cargo.nombre}</td>
                        <td className="py-3 px-6 text-center">
                            {/* <-- REEMPLAZAMOS EL COMENTARIO POR LOS BOTONES REALES --> */}
                            <div className="flex item-center justify-center">
                                <button onClick={() => handleAbrirModal(empleado)} className="w-8 h-8 rounded-full bg-yellow-500 text-white mr-2 text-sm font-bold">E</button>
                                <button onClick={() => handleEliminar(empleado.id)} className="w-8 h-8 rounded-full bg-red-500 text-white text-sm font-bold">X</button>
                            </div>
                        </td>
                    </tr>
                ))}
              </tbody>
          </table>
      </div>

      {esModalAbierto && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
            {/* El JSX del modal se mantiene exactamente igual que en el paso anterior */}
            <div className="bg-white p-8 rounded-lg shadow-xl w-1/2 max-h-[90vh] overflow-y-auto">
                <h2 className="text-2xl font-bold mb-4">{esEditando ? 'Editar Empleado' : 'Nuevo Empleado'}</h2>
                <form onSubmit={handleSubmit}>
                    <div className="grid grid-cols-2 gap-4">
                        <input name="first_name" value={itemActual.first_name} onChange={handleChange} placeholder="Nombres" required className="p-2 border rounded" />
                        <input name="username" value={itemActual.username} onChange={handleChange} placeholder="Nombre de Usuario" required disabled={esEditando} className="p-2 border rounded" />
                        <input name="email" type="email" value={itemActual.email} onChange={handleChange} placeholder="Email" required className="p-2 border rounded" />
                        {!esEditando && <input name="password" type="password" value={itemActual.password} onChange={handleChange} placeholder="Contraseña" required className="p-2 border rounded" />}
                        <input name="apellido_p" value={itemActual.apellido_p} onChange={handleChange} placeholder="Apellido Paterno" required className="p-2 border rounded" />
                        <input name="apellido_m" value={itemActual.apellido_m} onChange={handleChange} placeholder="Apellido Materno" required className="p-2 border rounded" />
                        <input name="ci" type="number" value={itemActual.ci} onChange={handleChange} placeholder="Cédula de Identidad (CI)" required className="p-2 border rounded" />
                        <input name="telefono" type="number" value={itemActual.telefono} onChange={handleChange} placeholder="Teléfono" className="p-2 border rounded" />
                        <textarea name="direccion" value={itemActual.direccion} onChange={handleChange} placeholder="Dirección" className="col-span-2 p-2 border rounded" />
                        <select name="empresa" value={itemActual.empresa} onChange={handleChange} required className="p-2 border rounded">
                            <option value="">Seleccionar Empresa</option>
                            {empresas.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
                        </select>
                        <select name="departamento" value={itemActual.departamento} onChange={handleChange} required className="p-2 border rounded">
                            <option value="">Seleccionar Departamento</option>
                            {departamentos.map(d => <option key={d.id} value={d.id}>{d.nombre}</option>)}
                        </select>
                        <select name="cargo" value={itemActual.cargo} onChange={handleChange} required className="p-2 border rounded">
                            <option value="">Seleccionar Cargo</option>
                            {cargos.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
                        </select>
                        <select name="rol" value={itemActual.rol} onChange={handleChange} required className="p-2 border rounded">
                            <option value="">Seleccionar Rol</option>
                            {roles.map(r => <option key={r.id} value={r.id}>{r.nombre}</option>)}
                        </select>
                    </div>
                    {errorFormulario && <p className="text-red-500 text-center mt-4">{errorFormulario}</p>}
                    <div className="flex justify-end mt-6">
                        <button type="button" onClick={handleCerrarModal} className="bg-gray-500 text-white px-4 py-2 rounded mr-2" disabled={estaCargando}>Cancelar</button>
                        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded" disabled={estaCargando}>
                            {estaCargando ? 'Guardando...' : 'Guardar'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
      )}
    </div>
  );
}

