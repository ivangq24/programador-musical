import React from 'react';
import { BarChart3 } from 'lucide-react';

// Sección Reportes
export const ReportesSection = ({ onItemClick }) => {
  const items = [
    { 
      id: 'estadisticas', 
      name: 'Estadísticas de Programación', 
      icon: BarChart3, 
      description: 'Análisis completo de categorías, canciones, artistas y más',
      color: 'from-blue-500 to-blue-600',
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
      hoverColor: 'hover:bg-blue-50'
    }
  ];

  const handleItemClick = (itemId) => {
    if (onItemClick) {
      onItemClick(itemId);
    }
  };

  return (
    <div className="space-y-5 h-full flex flex-col">
      {/* Header con gradiente mejorado */}
      <div className="bg-white/95 backdrop-blur-sm rounded-xl shadow-lg border border-white/20 overflow-hidden flex-shrink-0">
        <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 p-5 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
          <div className="relative z-10 flex items-center space-x-3">
            <div className="w-11 h-11 bg-white/20 rounded-lg flex items-center justify-center backdrop-blur-sm shadow-md">
              <BarChart3 className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white">Reportes</h3>
              <p className="text-blue-100 text-xs">Análisis y estadísticas del sistema</p>
            </div>
          </div>
        </div>
      </div>

      {/* Tarjetas de secciones mejoradas */}
      <div className="space-y-3 flex-1 overflow-y-auto">
        {items.map((item, itemIndex) => {
          const ItemIcon = item.icon;
          return (
            <button 
              key={itemIndex} 
              onClick={() => handleItemClick(item.id)}
              className={`group relative bg-white rounded-lg shadow-md border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left overflow-hidden w-full flex-shrink-0`}
            >
              {/* Background con gradiente sutil */}
              <div className={`absolute inset-0 bg-gradient-to-br ${item.bgColor} opacity-20 group-hover:opacity-40 transition-opacity duration-300`}></div>
              
              {/* Contenido */}
              <div className="relative p-5">
                <div className="flex items-start space-x-3">
                  <div className={`w-14 h-14 rounded-lg bg-gradient-to-br ${item.color} flex items-center justify-center group-hover:scale-105 transition-transform duration-300 shadow-md flex-shrink-0`}>
                    <ItemIcon className="w-7 h-7 text-white" />
                  </div>
                  
                  <div className="flex-1 min-w-0">
                    <h4 className="text-base font-semibold text-gray-900 group-hover:text-gray-800 transition-colors mb-1">
                      {item.name}
                    </h4>
                    <p className="text-gray-600 text-xs leading-relaxed">
                      {item.description}
                    </p>
                  </div>
                  
                  {/* Indicador de flecha */}
                  <div className="opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0 flex-shrink-0">
                    <div className="w-8 h-8 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center shadow-sm">
                      <svg className="w-4 h-4 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                      </svg>
                    </div>
                  </div>
                </div>
              </div>
              
              {/* Borde inferior con gradiente en hover */}
              <div className={`absolute bottom-0 left-0 right-0 h-0.5 bg-gradient-to-r ${item.color} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
            </button>
          );
        })}
      </div>
    </div>
  );
};
