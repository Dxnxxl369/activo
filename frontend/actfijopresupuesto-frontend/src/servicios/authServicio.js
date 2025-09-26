// src/servicios/authServicio.js
import axios from 'axios';

// Creamos una instancia de Axios con la URL base de nuestra API
const apiClient = axios.create({
  baseURL: 'http://127.0.0.1:8000/api', // La URL de tu backend Django
});

// Interceptor para incluir el token en todas las peticiones
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Token ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const iniciarSesion = async (credenciales) => {
  try {
    const response = await apiClient.post('/login/', credenciales);
    if (response.data.token) {
      // Guardamos el token en el almacenamiento local
      localStorage.setItem('token', response.data.token);
    }
    return response.data;
  } catch (error) {
    console.error('Error en el inicio de sesión:', error);
    throw error;
  }
};

export const cerrarSesion = () => {
  // Simplemente removemos el token del almacenamiento local
  localStorage.removeItem('token');
};

// Podríamos añadir una función para obtener los datos del usuario actual
export const obtenerUsuarioActual = async () => {
  // Este endpoint no lo hemos creado, pero es un buen ejemplo.
  // Por ahora, manejaremos los datos del usuario en el frontend.
};

export default apiClient;