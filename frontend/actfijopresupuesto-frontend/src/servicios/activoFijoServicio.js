import apiClient from './authServicio';

const endpoint = '/activos-fijos/';

export const obtenerActivosFijos = () => apiClient.get(endpoint);
export const crearActivoFijo = (data) => apiClient.post(endpoint, data);
export const actualizarActivoFijo = (id, data) => apiClient.put(`${endpoint}${id}/`, data);
export const eliminarActivoFijo = (id) => apiClient.delete(`${endpoint}${id}/`);