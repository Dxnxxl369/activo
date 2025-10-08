import React from 'react';

export default function Tabla({ columnas, datos, acciones }) {
  return (
    <div className="bg-white shadow-md rounded my-6 overflow-x-auto">
      <table className="min-w-max w-full table-auto">
        <thead>
          <tr className="bg-gray-200 text-gray-600 uppercase text-sm leading-normal">
            {columnas.map((col) => (
              <th key={col.accessor} className={`py-3 px-6 ${col.className}`}>{col.Header}</th>
            ))}
            <th className="py-3 px-6 text-center">Acciones</th>
          </tr>
        </thead>
        <tbody className="text-gray-600 text-sm font-light">
          {datos.map((fila) => (
            <tr key={fila.id} className="border-b border-gray-200 hover:bg-gray-100">
              {columnas.map((col) => (
                <td key={col.accessor} className={`py-3 px-6 ${col.className}`}>
                  {/* Accede al dato. Si es anidado como 'usuario.nombre', lo resuelve */}
                  {col.accessor.split('.').reduce((o, i) => (o ? o[i] : ''), fila)}
                </td>
              ))}
              <td className="py-3 px-6 text-center">
                <div className="flex item-center justify-center">
                  {/* Renderiza los botones de acción que se le pasen */}
                  {acciones(fila)}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}