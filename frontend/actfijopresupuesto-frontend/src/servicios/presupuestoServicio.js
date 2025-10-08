import apiClient from './authServicio';

const endpointPresupuesto = '/presupuestos/';
const endpointDetalle = '/detalles-presupuesto/';

// Funciones para el Presupuesto Principal
export const obtenerPresupuestos = () => apiClient.get(endpointPresupuesto);
export const crearPresupuesto = (data) => apiClient.post(endpointPresupuesto, data);
export const actualizarPresupuesto = (id, data) => apiClient.put(`${endpointPresupuesto}${id}/`, data);
export const eliminarPresupuesto = (id) => apiClient.delete(`${endpointPresupuesto}${id}/`);

// Funciones para los Detalles/Asignaciones
export const crearDetallePresupuesto = (data) => apiClient.post(endpointDetalle, data);
export const eliminarDetallePresupuesto = (id) => apiClient.delete(`${endpointDetalle}${id}/`);