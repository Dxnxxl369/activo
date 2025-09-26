// src/paginas/Dashboard.jsx
import React from 'react';
import { useAuth } from '../contexto/AuthContext';

export default function Dashboard() {
  const { logout } = useAuth();
  return (
    <div>
      <h1 className="text-2xl">¡Bienvenido al Dashboard!</h1>
      <p>Esta es una página protegida.</p>
      <button 
        onClick={logout} 
        className="px-4 py-2 mt-4 text-white bg-red-600 rounded hover:bg-red-800"
      >
        Cerrar Sesión
      </button>
    </div>
  );
}