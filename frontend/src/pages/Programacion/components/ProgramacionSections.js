import React from 'react';
import { 
  Shield, FileText, Target, Clock, Play, History, Upload
} from 'lucide-react';

// Sección Políticas
export const PoliticasSection = ({ onItemClick }) => {
  const items = [
    { name: 'Políticas de programación', icon: Shield, id: 'politicas-programacion' },
    { name: 'Reporte de reglas', icon: FileText, id: 'reporte-reglas' },
    { name: 'Grupos de reglas', icon: Target, id: 'grupos-reglas' },
    { name: 'Grupos de relojes', icon: Clock, id: 'grupos-relojes' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-purple-500 to-purple-600">
        <h3 className="text-white font-semibold text-sm">Políticas</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => onItemClick && onItemClick(item.id)}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-purple-100 group-hover:bg-purple-200">
                  <ItemIcon className="w-3 h-3 text-purple-600" />
                </div>
                <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">{item.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// Sección Programación
export const ProgramacionSection = ({ onItemClick }) => {
  const items = [
    { name: 'Generar programación', icon: Play, id: 'generar-programacion' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-green-500 to-green-600">
        <h3 className="text-white font-semibold text-sm">Programación</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => onItemClick && onItemClick(item.id)}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-green-100 group-hover:bg-green-200">
                  <ItemIcon className="w-3 h-3 text-green-600" />
                </div>
                <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">{item.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// Sección Logfiles
export const LogfilesSection = ({ onItemClick }) => {
  const items = [
    { name: 'Generar logfiles', icon: FileText, id: 'generar-logfiles' },
    { name: 'Generar cartas de tiempo', icon: Clock, id: 'cartas-tiempo' },
    { name: 'Historial por días', icon: History, id: 'historial-dias' },
    { name: 'Auditoría de la transmisión', icon: Shield, id: 'auditoria-transmision' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-yellow-500 to-yellow-600">
        <h3 className="text-white font-semibold text-sm">Logfiles</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => {
                  console.log('Logfiles button clicked:', item.id, item.name)
                  onItemClick && onItemClick(item.id)
                }}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-yellow-100 group-hover:bg-yellow-200">
                  <ItemIcon className="w-3 h-3 text-yellow-600" />
                </div>
                <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">{item.name}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};
