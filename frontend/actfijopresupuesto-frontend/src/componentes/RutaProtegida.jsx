// src/componentes/RutaProtegida.jsx
import React from 'react';
import { useAuth } from '../contexto/AuthContext';
import { Navigate, Outlet } from 'react-router-dom';

export default function RutaProtegida() {
  const { token } = useAuth();

  if (!token) {
    // Si no hay token, redirigir a la página de login
    return <Navigate to="/login" />;
  }

  // Si hay un token, mostrar el contenido de la ruta (el "Outlet")
  return <Outlet />;
}