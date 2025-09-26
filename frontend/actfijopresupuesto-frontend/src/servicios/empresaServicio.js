// src/servicios/empresaServicio.js
import apiClient from './authServicio'; // Reutilizamos la instancia de axios configurada

export const obtenerEmpresas = () => {
  return apiClient.get('/empresas/');
};

export const crearEmpresa = (empresa) => {
  return apiClient.post('/empresas/', empresa);
};

export const actualizarEmpresa = (id, empresa) => {
  return apiClient.put(`/empresas/${id}/`, empresa);
};

export const eliminarEmpresa = (id) => {
  return apiClient.delete(`/empresas/${id}/`);
};