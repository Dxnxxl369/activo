import apiClient from './authServicio';

// El término de búsqueda es opcional
export const obtenerEmpleados = (terminoBusqueda = '') => {
  const url = terminoBusqueda ? `/empleados/?buscar=${terminoBusqueda}` : '/empleados/';
  return apiClient.get(url);
};

export const crearEmpleado = (data) => apiClient.post('/empleados/', data);
export const actualizarEmpleado = (id, data) => apiClient.put(`/empleados/${id}/`, data);
export const eliminarEmpleado = (id) => apiClient.delete(`/empleados/${id}/`);