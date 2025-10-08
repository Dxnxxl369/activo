import apiClient from './authServicio';

const endpoint = '/categorias-activos/';

export const obtenerCategorias = () => apiClient.get(endpoint);
export const crearCategoria = (data) => apiClient.post(endpoint, data);
export const actualizarCategoria = (id, data) => apiClient.put(`${endpoint}${id}/`, data);
export const eliminarCategoria = (id) => apiClient.delete(`${endpoint}${id}/`);
