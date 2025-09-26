import React, { useState, useEffect } from 'react';
import { obtenerRoles, actualizarRol } from '../servicios/rolServicio';
import { obtenerPermisos } from '../servicios/permisoServicio';

export default function GestionRoles() {
  const [roles, setRoles] = useState([]);
  const [permisos, setPermisos] = useState([]);
  const [rolSeleccionado, setRolSeleccionado] = useState(null);
  const [permisosAsignados, setPermisosAsignados] = useState(new Set());

  useEffect(() => {
    const cargarDatos = async () => {
      const resRoles = await obtenerRoles();
      setRoles(resRoles.data);
      const resPermisos = await obtenerPermisos();
      setPermisos(resPermisos.data);
    };
    cargarDatos();
  }, []);

  const handleSeleccionarRol = (rol) => {
    setRolSeleccionado(rol);
    // Creamos un Set con los IDs de los permisos que el rol ya tiene
    const idsPermisosActuales = new Set(rol.permisos.map(p => p.id));
    setPermisosAsignados(idsPermisosActuales);
  };

  const handleTogglePermiso = (permisoId) => {
    const nuevosPermisos = new Set(permisosAsignados);
    if (nuevosPermisos.has(permisoId)) {
      nuevosPermisos.delete(permisoId);
    } else {
      nuevosPermisos.add(permisoId);
    }
    setPermisosAsignados(nuevosPermisos);
  };

  const handleGuardarCambios = async () => {
    if (!rolSeleccionado) return;
    const datosActualizados = {
      nombre: rolSeleccionado.nombre,
      permisos: Array.from(permisosAsignados), // Convertimos el Set a un Array de IDs
    };
    try {
      await actualizarRol(rolSeleccionado.id, datosActualizados);
      alert('Rol actualizado con éxito');
      // Opcional: Recargar los roles para ver los cambios reflejados
      const resRoles = await obtenerRoles();
      setRoles(resRoles.data);
    } catch (error) {
      console.error("Error al actualizar el rol:", error);
      alert('Error al actualizar el rol');
    }
  };

  return (
    <div className="container mx-auto">
      <h1 className="text-3xl font-bold mb-6">Gestión de Roles y Permisos</h1>
      <div className="grid grid-cols-3 gap-6">
        {/* Columna de Roles */}
        <div className="col-span-1 bg-white p-4 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-2">Roles</h2>
          <ul>
            {roles.map(rol => (
              <li key={rol.id}
                onClick={() => handleSeleccionarRol(rol)}
                className={`p-2 rounded cursor-pointer ${rolSeleccionado?.id === rol.id ? 'bg-blue-500 text-white' : 'hover:bg-gray-200'}`}
              >
                {rol.nombre}
              </li>
            ))}
          </ul>
        </div>

        {/* Columna de Permisos */}
        <div className="col-span-2 bg-white p-4 rounded-lg shadow">
          {rolSeleccionado ? (
            <>
              <h2 className="text-xl font-semibold mb-2">Permisos para "{rolSeleccionado.nombre}"</h2>
              <div className="grid grid-cols-2 gap-2">
                {permisos.map(permiso => (
                  <label key={permiso.id} className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      checked={permisosAsignados.has(permiso.id)}
                      onChange={() => handleTogglePermiso(permiso.id)}
                      className="form-checkbox h-5 w-5 text-blue-600"
                    />
                    <span>{permiso.nombre}</span>
                  </label>
                ))}
              </div>
              <button onClick={handleGuardarCambios} className="mt-6 bg-green-500 text-white px-6 py-2 rounded-md hover:bg-green-600">
                Guardar Cambios
              </button>
            </>
          ) : (
            <p className="text-gray-500">Selecciona un rol para ver y asignar permisos.</p>
          )}
        </div>
      </div>
    </div>
  );
}