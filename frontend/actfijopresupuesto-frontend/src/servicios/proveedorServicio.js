import apiClient from './authServicio';

export const obtenerProveedores = () => apiClient.get('/proveedores/');
export const crearProveedor = (data) => apiClient.post('/proveedores/', data);
export const actualizarProveedor = (id, data) => apiClient.put(`/proveedores/${id}/`, data);
export const eliminarProveedor = (id) => apiClient.delete(`/proveedores/${id}/`);
