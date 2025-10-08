import apiClient from './authServicio';

const endpoint = '/estados/';

export const obtenerEstados = () => apiClient.get(endpoint);
// Podrías añadir crear, actualizar, etc., si necesitas un CRUD para Estados