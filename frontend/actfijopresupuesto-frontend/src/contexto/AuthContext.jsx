// src/contexto/AuthContext.jsx
import React, { createContext, useState, useContext, useEffect } from 'react';
import { iniciarSesion as iniciarSesionApi, cerrarSesion as cerrarSesionApi } from '../servicios/authServicio';

// 1. Creamos el Contexto
const AuthContext = createContext();

// 2. Creamos un hook personalizado para usar el contexto más fácilmente
export const useAuth = () => {
  return useContext(AuthContext);
};

// 3. Creamos el Proveedor del Contexto
export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(localStorage.getItem('token') || null);
  // Podríamos guardar el objeto de usuario completo aquí también
  // const [usuario, setUsuario] = useState(null);

  useEffect(() => {
    // Sincroniza el estado con el localStorage al cargar
    const tokenGuardado = localStorage.getItem('token');
    if (tokenGuardado) {
      setToken(tokenGuardado);
    }
  }, []);

  const login = async (username, password) => {
    try {
      const data = await iniciarSesionApi({ username, password });
      setToken(data.token);
      // Aquí podríamos decodificar el token para obtener datos del usuario
      // o hacer otra petición para obtener el perfil del usuario
      return true; // Éxito
    } catch (error) {
      console.error('Fallo el login desde el contexto', error);
      return false; // Fracaso
    }
  };

  const logout = () => {
    cerrarSesionApi();
    setToken(null);
    // setUsuario(null);
  };

  const valor = {
    token,
    // usuario,
    login,
    logout,
  };

  return <AuthContext.Provider value={valor}>{children}</AuthContext.Provider>;
};