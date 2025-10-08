import apiClient from './authServicio';

// Nota: El endpoint exacto puede variar según cómo lo definas en el backend.
// Asumimos que las revalorizaciones se crean relacionadas a un activo.
const endpoint = '/revalorizaciones-activos/';

export const crearRevalorizacion = (data) => apiClient.post(endpoint, data);