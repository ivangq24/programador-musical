import React from 'react';
import { 
  Tags, Database, List, FileAudio, Upload
} from 'lucide-react';

// Sección Categorías
export const CategoriasSection = ({ onItemClick }) => {
  const items = [
    { name: 'Mantenimiento de categorías', icon: Tags, id: 'mantenimiento-categorias' },
    { name: 'Movimientos entre categorías', icon: Database, id: 'movimientos-categorias' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-green-500 to-green-600">
        <h3 className="text-white font-semibold text-sm">Categorías</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => {
                  console.log('Categorias button clicked:', item.id, item.name)
                  onItemClick && onItemClick(item.id)
                }}
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

// Sección Conjuntos
export const ConjuntosSection = ({ onItemClick }) => {
  const items = [
    { name: 'Mantenimiento en conjuntos', icon: List, id: 'mantenimiento-conjuntos' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-blue-500 to-blue-600">
        <h3 className="text-white font-semibold text-sm">Conjuntos</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => {
                  console.log('Conjuntos button clicked:', item.id, item.name)
                  onItemClick && onItemClick(item.id)
                }}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-blue-100 group-hover:bg-blue-200">
                  <ItemIcon className="w-3 h-3 text-blue-600" />
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

// Sección Canciones
export const CancionesSection = ({ onItemClick }) => {
  const items = [
    { name: 'Mantenimiento de canciones', icon: FileAudio, id: 'mantenimiento-canciones' },
    { name: 'Importar a CSV', icon: Upload, id: 'importar-csv' }
  ];

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-red-500 to-red-600">
        <h3 className="text-white font-semibold text-sm">Canciones</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => {
                  console.log('Canciones button clicked:', item.id, item.name)
                  onItemClick && onItemClick(item.id)
                }}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-red-100 group-hover:bg-red-200">
                  <ItemIcon className="w-3 h-3 text-red-600" />
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
