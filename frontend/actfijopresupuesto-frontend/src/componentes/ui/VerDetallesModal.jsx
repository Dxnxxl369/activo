import React from 'react';
import Modal from './Modal';

const formatearClave = (clave) => {
  return clave
    .replace(/_/g, ' ')
    .replace('_set', ' (Historial)') 
    .replace(/\b\w/g, l => l.toUpperCase());
};

const RenderizarValor = ({ valor, clave }) => {
  // Si el valor es un array y la clave termina en '_set', lo mostramos como una tabla.
  if (Array.isArray(valor) && clave.endsWith('_set')) {
    if (valor.length === 0) {
      return <span className="text-gray-500">No hay registros en el historial.</span>;
    }
    
    // --- INICIO: LÓGICA DINÁMICA DE COLUMNAS ---
    let columnas;
    if (clave === 'revalorizacionactivos_set') {
      columnas = [
        { Header: 'Fecha', accessor: 'fecha' },
        { Header: 'Detalle', accessor: 'detalle' },
        { Header: 'Nuevo Valor', accessor: 'nuevo_valor' },
      ];
    } else if (clave === 'detallepresupuesto_set') {
      columnas = [
        { Header: 'Fecha', accessor: 'fecha' },
        { Header: 'Categoría', accessor: 'categoria_activo.nombre' },
        { Header: 'Monto Asignado', accessor: 'monto_asignado' },
      ];
    } else {
      // Columnas por defecto si no se reconoce el historial
      // Intenta adivinar las columnas del primer registro si no hay una configuración específica
      columnas = Object.keys(valor[0]).filter(k => k !== 'id').map(k => ({ Header: formatearClave(k), accessor: k }));
    }

    return (
      <div className="mt-2 border rounded-lg overflow-hidden">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-100">
            <tr>
              {columnas.map(col => <th key={col.Header} className="px-4 py-2 text-left font-semibold text-gray-600">{col.Header}</th>)}
            </tr>
          </thead>
          <tbody className="bg-white">
            {valor.map((registro) => (
              <tr key={registro.id} className="border-t">
                {columnas.map(col => (
                  <td key={col.accessor} className="px-4 py-2">
                    {/* Resuelve valores anidados como 'categoria_activo.nombre' */}
                    {col.accessor.split('.').reduce((o, i) => (o ? o[i] : ''), registro)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  if (typeof valor === 'object' && valor !== null && !Array.isArray(valor)) {
    return (
      <div className="pl-4 border-l ml-2">
        {Object.entries(valor).map(([subClave, subValor]) => (
          <div key={subClave} className="grid grid-cols-2 gap-x-2">
            <span className="font-semibold text-gray-600">{formatearClave(subClave)}:</span>
            <span className="text-gray-800"><RenderizarValor valor={subValor} clave={subClave} /></span>
          </div>
        ))}
      </div>
    );
  }
  
  return String(valor);
};





export default function VerDetallesModal({ estaAbierto, onClose, item, titulo }) {
  if (!item) return null;

  return (
    <Modal estaAbierto={estaAbierto} onClose={onClose} titulo={`Detalles de ${titulo}`}>
      <dl>
  {Object.entries(item).map(([clave, valor]) => (
    <div key={clave} className="grid grid-cols-1 gap-2 mb-2 border-b pb-2">
      <dt className="font-bold text-gray-700">{formatearClave(clave)}:</dt>
      {/* --- MODIFICACIÓN: Pasamos la 'clave' como prop --- */}
      <dd className="text-gray-900 pl-2"><RenderizarValor valor={valor} clave={clave} /></dd>
    </div>
  ))}
</dl>
      <div className="flex justify-end mt-6">
        <button onClick={onClose} className="bg-gray-500 text-white px-4 py-2 rounded">
          Cerrar
        </button>
      </div>
    </Modal>
  );
}