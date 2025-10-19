/*import apiClient from './authServicio';

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
*/
import apiClient from './authServicio';

// Definimos la ruta base para los presupuestos de forma explícita.
const ENDPOINT = 'presupuestos/';

/**
 * Obtiene la lista de todos los presupuestos.
 */
export const obtenerPresupuestos = () => apiClient.get(ENDPOINT);

/**
 * Crea un nuevo presupuesto.
 * La petición POST SIEMPRE va al endpoint base sin ID.
 * @param {object} data - Los datos del nuevo presupuesto.
 */
export const crearPresupuesto = (data) => {
    // Esta es la línea clave: nos aseguramos de que la URL sea la correcta.
    return apiClient.post(ENDPOINT, data);
};

/**
 * Actualiza un presupuesto existente.
 * La petición PUT SÍ necesita el ID en la URL.
 * @param {number} id - El ID del presupuesto a actualizar.
 * @param {object} data - Los nuevos datos para el presupuesto.
 */
export const actualizarPresupuesto = (id, data) => {
    return apiClient.put(`${ENDPOINT}${id}/`, data);
};

/**
 * Elimina un presupuesto.
 * @param {number} id - El ID del presupuesto a eliminar.
 */
export const eliminarPresupuesto = (id) => {
    return apiClient.delete(`${ENDPOINT}${id}/`);
};

// --- SERVICIOS DE DETALLES (Si los tienes en el mismo archivo) ---

const ENDPOINT_DETALLE = 'detalles-presupuesto/';

export const crearDetallePresupuesto = (data) => apiClient.post(ENDPOINT_DETALLE, data);

export const eliminarDetallePresupuesto = (id) => apiClient.delete(`${ENDPOINT_DETALLE}${id}/`);