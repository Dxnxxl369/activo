import apiClient from './authServicio';

export const obtenerRoles = () => apiClient.get('/roles/');
export const actualizarRol = (id, data) => apiClient.put(`/roles/${id}/`, data);
// Si necesitas crear y eliminar roles desde otra vista, añade las funciones aquí.