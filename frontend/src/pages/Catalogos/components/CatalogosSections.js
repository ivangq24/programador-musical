import React from 'react';
import { 
  Building, Tags, Database, Users, UserCheck, Music, Clock, Scissors
} from 'lucide-react';

// Sección General
export const GeneralSection = ({ onSectionClick }) => {
  const items = [
    { 
      name: 'Difusoras', 
      icon: Building, 
      description: 'Gestiona estaciones de radio',
      color: 'from-blue-500 to-blue-600',
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
      hoverColor: 'hover:bg-blue-50'
    },
    { 
      name: 'Cortes', 
      icon: Scissors, 
      description: 'Administra cortes comerciales',
      color: 'from-green-500 to-green-600',
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
      hoverColor: 'hover:bg-green-50'
    },
    { 
      name: 'Tipo de clasificaciones', 
      icon: Tags, 
      description: 'Configura tipos de clasificación',
      color: 'from-purple-500 to-purple-600',
      bgColor: 'bg-purple-50',
      iconColor: 'text-purple-600',
      hoverColor: 'hover:bg-purple-50'
    },
    { 
      name: 'Clasificaciones', 
      icon: Database, 
      description: 'Gestiona clasificaciones musicales',
      color: 'from-indigo-500 to-indigo-600',
      bgColor: 'bg-indigo-50',
      iconColor: 'text-indigo-600',
      hoverColor: 'hover:bg-indigo-50'
    },
    { 
      name: 'Interpretes', 
      icon: Users, 
      description: 'Administra intérpretes musicales',
      color: 'from-pink-500 to-pink-600',
      bgColor: 'bg-pink-50',
      iconColor: 'text-pink-600',
      hoverColor: 'hover:bg-pink-50'
    },
    { 
      name: 'Personas', 
      icon: UserCheck, 
      description: 'Gestiona personal del sistema',
      color: 'from-orange-500 to-orange-600',
      bgColor: 'bg-orange-50',
      iconColor: 'text-orange-600',
      hoverColor: 'hover:bg-orange-50'
    },
    { 
      name: 'Sellos discográficos', 
      icon: Music, 
      description: 'Administra sellos discográficos',
      color: 'from-teal-500 to-teal-600',
      bgColor: 'bg-teal-50',
      iconColor: 'text-teal-600',
      hoverColor: 'hover:bg-teal-50'
    },
    { 
      name: 'Dayparts', 
      icon: Clock, 
      description: 'Configura horarios de programación',
      color: 'from-cyan-500 to-cyan-600',
      bgColor: 'bg-cyan-50',
      iconColor: 'text-cyan-600',
      hoverColor: 'hover:bg-cyan-50'
    }
  ];

  const handleItemClick = (itemName) => {
    if (onSectionClick) {
      onSectionClick(itemName);
    }
  };

  return (
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-indigo-600/90 to-purple-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <Database className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Catálogos Generales</h3>
            <p className="text-indigo-100 text-sm">Configuración del sistema</p>
          </div>
        </div>
        {/* Efecto de partículas decorativas */}
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
        <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
      </div>

      {/* Contenido con grid mejorado */}
      <div className="p-6">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => handleItemClick(item.name)}
                className={`group relative p-4 rounded-xl border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left bg-white ${item.hoverColor} transform hover:scale-[1.02] hover:-translate-y-1`}
              >
                <div className="flex items-start space-x-4">
                  <div className={`w-12 h-12 rounded-xl ${item.bgColor} flex items-center justify-center group-hover:scale-110 transition-transform duration-300 shadow-sm`}>
                    <ItemIcon className={`w-6 h-6 ${item.iconColor}`} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="font-semibold text-gray-900 group-hover:text-gray-700 transition-colors text-sm">
                      {item.name}
                    </h4>
                    <p className="text-xs text-gray-600 mt-1 line-clamp-2">
                      {item.description}
                    </p>
                  </div>
                </div>
                
                {/* Efecto de gradiente en hover */}
                <div className={`absolute inset-0 rounded-xl bg-gradient-to-r ${item.color} opacity-0 group-hover:opacity-5 transition-opacity duration-300`}></div>
                
                {/* Indicador de flecha */}
                <div className="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-2 group-hover:translate-x-0">
                  <div className="w-6 h-6 bg-gray-100 rounded-full flex items-center justify-center shadow-sm">
                    <svg className="w-3 h-3 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                    </svg>
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      </div>

    </div>
  );
};

