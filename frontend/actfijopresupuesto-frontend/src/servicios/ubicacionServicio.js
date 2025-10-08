import apiClient from './authServicio';

const endpoint = '/ubicaciones/';

export const obtenerUbicaciones = () => apiClient.get(endpoint);
export const crearUbicacion = (data) => apiClient.post(endpoint, data);
export const actualizarUbicacion = (id, data) => apiClient.put(`${endpoint}${id}/`, data);
export const eliminarUbicacion = (id) => apiClient.delete(`${endpoint}${id}/`);
