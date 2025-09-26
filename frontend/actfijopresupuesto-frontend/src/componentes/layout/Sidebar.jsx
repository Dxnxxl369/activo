// src/componentes/layout/Sidebar.jsx
import React from 'react';
import { NavLink } from 'react-router-dom';

// Un simple array para los enlaces de navegación
const navLinks = [
  { nombre: 'Dashboard', ruta: '/dashboard' },
  { nombre: 'Empresas', ruta: '/empresas' },
  { nombre: 'Empleados', ruta: '/empleados' },
  { nombre: 'Departamentos', ruta: '/departamentos' },
  { nombre: 'Cargos', ruta: '/cargos' },
  { nombre: 'Roles y Permisos', ruta: '/roles' },
];

export default function Sidebar() {
  // Estilos para los enlaces, incluyendo el estado activo
  const linkStyle = "block py-2.5 px-4 rounded transition duration-200 hover:bg-blue-700 hover:text-white";
  const activeLinkStyle = { backgroundColor: '#1D4ED8', color: 'white' };

  return (
    <div className="bg-blue-800 text-white w-64 h-screen p-4">
      <h2 className="text-2xl font-bold mb-10">ActFijo App</h2>
      <nav>
        {navLinks.map((link) => (
          <NavLink
            key={link.nombre}
            to={link.ruta}
            style={({ isActive }) => (isActive ? activeLinkStyle : undefined)}
            className={linkStyle}
          >
            {link.nombre}
          </NavLink>
        ))}
      </nav>
    </div>
  );
}