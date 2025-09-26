import apiClient from './authServicio';

export const obtenerDepartamentos = () => apiClient.get('/departamentos/');
export const crearDepartamento = (data) => apiClient.post('/departamentos/', data);
export const actualizarDepartamento = (id, data) => apiClient.put(`/departamentos/${id}/`, data);
export const eliminarDepartamento = (id) => apiClient.delete(`/departamentos/${id}/`);