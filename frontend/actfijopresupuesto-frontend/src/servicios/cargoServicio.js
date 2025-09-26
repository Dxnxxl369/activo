import apiClient from './authServicio';

export const obtenerCargos = () => apiClient.get('/cargos/');
export const crearCargo = (data) => apiClient.post('/cargos/', data);
export const actualizarCargo = (id, data) => apiClient.put(`/cargos/${id}/`, data);
export const eliminarCargo = (id) => apiClient.delete(`/cargos/${id}/`);