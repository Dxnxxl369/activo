// src/App.jsx
import { Routes, Route } from 'react-router-dom';
import Login from './paginas/Login';
import Dashboard from './paginas/Dashboard'; 
import RutaProtegida from './componentes/RutaProtegida';
import LayoutPrincipal from './componentes/layout/LayoutPrincipal';
import GestionEmpresas from './paginas/GestionEmpresas';
import GestionDepartamentos from './paginas/GestionDepartamentos'; 
import GestionCargos from './paginas/GestionCargos'; 
import GestionEmpleados from './paginas/GestionEmpleados';
import GestionRoles from './paginas/GestionRoles';

function App() {
  return (
    <Routes>
      {/* Rutas Públicas */}
      <Route path="/login" element={<Login />} />
      <Route path="/" element={<Login />} />

      {/* Rutas Privadas con el Layout Principal */}
      <Route element={<RutaProtegida />}>
        <Route element={<LayoutPrincipal />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/empresas" element={<GestionEmpresas />} />
          <Route path="/departamentos" element={<GestionDepartamentos />} />
          <Route path="/cargos" element={<GestionCargos />} />
          <Route path="/empleados" element={<GestionEmpleados />} />
          <Route path="/roles" element={<GestionRoles />} />
        </Route>
      </Route>
    </Routes>
  );
}

export default App;