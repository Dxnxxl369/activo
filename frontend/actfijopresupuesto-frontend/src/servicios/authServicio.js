// src/servicios/authServicio.js
/*import axios from 'axios';

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

export default apiClient;*/

// src/servicios/authServicio.js
import axios from 'axios';

// Define la URL base de tu API de Django. Es más seguro definirla sin /api al final.
const API_URL = 'http://127.0.0.1:8000';

/**
 * Realiza la petición POST al backend para iniciar sesión.
 * @param {object} credenciales - Un objeto con { username, password }.
 * @returns {Promise<object>} La data de la respuesta, que incluye el token.
 */
export const iniciarSesion = async (credenciales) => {
  try {
    // La línea clave: hacemos la petición a la URL COMPLETA y CORRECTA.
    const response = await axios.post(`${API_URL}/api/login/`, credenciales, {
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Si la petición es exitosa, guardamos el token en localStorage.
    if (response.data.token) {
      localStorage.setItem('token', response.data.token);
    }

    // Devolvemos la data para que AuthContext la pueda usar.
    return response.data;

  } catch (error) {
    // Si hay un error (ej. 401 Unauthorized), lo mostramos en consola
    // y lo "lanzamos" de nuevo para que el AuthContext sepa que falló.
    console.error('Error en el servicio de autenticación:', error.response ? error.response.data : 'Error de red');
    throw error;
  }
};

/**
 * Limpia el token del localStorage al cerrar sesión.
 */
export const cerrarSesion = () => {
  localStorage.removeItem('token');
};

// (El resto del código como el interceptor puede quedarse si lo necesitas para otras llamadas)
// Creamos una instancia de Axios para peticiones autenticadas
const apiClient = axios.create({
  baseURL: `${API_URL}/api/`,
});

apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      // Formato correcto para la autenticación por token de DRF
      config.headers.Authorization = `Token ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default apiClient;