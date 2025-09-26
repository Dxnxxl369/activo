// src/componentes/layout/LayoutPrincipal.jsx
import React from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import { useAuth } from '../../contexto/AuthContext';

export default function LayoutPrincipal() {
  const { logout } = useAuth(); // Asumimos que el usuario se mostrará aquí

  return (
    <div className="flex h-screen bg-gray-100">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="flex justify-end items-center p-4 bg-white border-b">
          {/* Aquí iría el nombre de usuario, notificaciones, etc. */}
          <button
            onClick={logout}
            className="px-4 py-2 text-white bg-red-600 rounded-md hover:bg-red-700"
          >
            Cerrar Sesión
          </button>
        </header>
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-100 p-8">
          {/* Outlet renderizará la página actual (Dashboard, Empresas, etc.) */}
          <Outlet />
        </main>
      </div>
    </div>
  );
}