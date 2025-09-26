import apiClient from './authServicio';

export const obtenerPermisos = () => apiClient.get('/permisos/');