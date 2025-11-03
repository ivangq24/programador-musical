import React from 'react';
import { 
  Shield, FileText, Clock, Play, History, Upload
} from 'lucide-react';

// Sección Políticas
export const PoliticasSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Políticas de programación', 
      icon: Shield, 
      id: 'politicas-programacion',
      description: 'Gestiona las políticas de programación',
      color: 'from-purple-500 to-purple-600',
      bgColor: 'bg-purple-50',
      iconColor: 'text-purple-600',
      hoverColor: 'hover:bg-purple-50'
    },
  ];

  return (
    <div className="space-y-5 h-full flex flex-col">
      {/* Header con gradiente mejorado */}
      <div className="bg-white/95 backdrop-blur-sm rounded-xl shadow-lg border border-white/20 overflow-hidden flex-shrink-0">
        <div className="bg-gradient-to-r from-purple-600 via-violet-600 to-indigo-600 p-5 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-purple-600/90 to-violet-600/90"></div>
          <div className="relative z-10 flex items-center space-x-3">
            <div className="w-11 h-11 bg-white/20 rounded-lg flex items-center justify-center backdrop-blur-sm shadow-md">
              <Shield className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white">Políticas</h3>
              <p className="text-purple-100 text-xs">Gestión de políticas y reglas</p>
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
              onClick={() => onItemClick && onItemClick(item.id)}
              className={`group relative bg-white rounded-lg shadow-md border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left overflow-hidden w-full flex-shrink-0`}
            >
              {/* Background con gradiente sutil */}
              <div className={`absolute inset-0 bg-gradient-to-br ${item.bgColor} opacity-30 group-hover:opacity-50 transition-opacity duration-300`}></div>
              
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
              <div className={`absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r ${item.color} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
            </button>
          );
        })}
      </div>
    </div>
  );
};

// Sección Programación
export const ProgramacionSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Generar programación', 
      icon: Play, 
      id: 'generar-programacion',
      description: 'Genera la programación musical',
      color: 'from-green-500 to-green-600',
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
      hoverColor: 'hover:bg-green-50'
    }
  ];

  return (
    <div className="space-y-5 h-full flex flex-col">
      {/* Header con gradiente mejorado */}
      <div className="bg-white/95 backdrop-blur-sm rounded-xl shadow-lg border border-white/20 overflow-hidden flex-shrink-0">
        <div className="bg-gradient-to-r from-green-600 via-emerald-600 to-teal-600 p-5 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-green-600/90 to-emerald-600/90"></div>
          <div className="relative z-10 flex items-center space-x-3">
            <div className="w-11 h-11 bg-white/20 rounded-lg flex items-center justify-center backdrop-blur-sm shadow-md">
              <Play className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white">Programación</h3>
              <p className="text-green-100 text-xs">Generación de programación musical</p>
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
              onClick={() => onItemClick && onItemClick(item.id)}
              className={`group relative bg-white rounded-lg shadow-md border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left overflow-hidden w-full flex-shrink-0`}
            >
              {/* Background con gradiente sutil */}
              <div className={`absolute inset-0 bg-gradient-to-br ${item.bgColor} opacity-30 group-hover:opacity-50 transition-opacity duration-300`}></div>
              
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
              <div className={`absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r ${item.color} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
            </button>
          );
        })}
      </div>
    </div>
  );
};

// Sección Logfiles
export const LogfilesSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Generar logfiles', 
      icon: FileText, 
      id: 'generar-logfiles',
      description: 'Genera archivos de registro',
      color: 'from-orange-500 to-orange-600',
      bgColor: 'bg-orange-50',
      iconColor: 'text-orange-600',
      hoverColor: 'hover:bg-orange-50'
    },
    { 
      name: 'Generar cartas de tiempo', 
      icon: Clock, 
      id: 'cartas-tiempo',
      description: 'Crea cartas de tiempo',
      color: 'from-amber-500 to-amber-600',
      bgColor: 'bg-amber-50',
      iconColor: 'text-amber-600',
      hoverColor: 'hover:bg-amber-50'
    },
    { 
      name: 'Historial por días', 
      icon: History, 
      id: 'historial-dias',
      description: 'Consulta historial diario',
      color: 'from-yellow-500 to-yellow-600',
      bgColor: 'bg-yellow-50',
      iconColor: 'text-yellow-600',
      hoverColor: 'hover:bg-yellow-50'
    },
    { 
      name: 'Auditoría de la transmisión', 
      icon: Shield, 
      id: 'auditoria-transmision',
      description: 'Audita transmisiones',
      color: 'from-red-500 to-red-600',
      bgColor: 'bg-red-50',
      iconColor: 'text-red-600',
      hoverColor: 'hover:bg-red-50'
    }
  ];

  return (
    <div className="space-y-5 h-full flex flex-col">
      {/* Header con gradiente mejorado */}
      <div className="bg-white/95 backdrop-blur-sm rounded-xl shadow-lg border border-white/20 overflow-hidden flex-shrink-0">
        <div className="bg-gradient-to-r from-orange-600 via-amber-600 to-yellow-600 p-5 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-orange-600/90 to-amber-600/90"></div>
          <div className="relative z-10 flex items-center space-x-3">
            <div className="w-11 h-11 bg-white/20 rounded-lg flex items-center justify-center backdrop-blur-sm shadow-md">
              <FileText className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-xl font-bold text-white">Logfiles</h3>
              <p className="text-orange-100 text-xs">Gestión de archivos y auditoría</p>
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
              onClick={() => {
                console.log('Logfiles button clicked:', item.id, item.name)
                onItemClick && onItemClick(item.id)
              }}
              className={`group relative bg-white rounded-lg shadow-md border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left overflow-hidden w-full flex-shrink-0`}
            >
              {/* Background con gradiente sutil */}
              <div className={`absolute inset-0 bg-gradient-to-br ${item.bgColor} opacity-30 group-hover:opacity-50 transition-opacity duration-300`}></div>
              
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
              <div className={`absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r ${item.color} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
            </button>
          );
        })}
      </div>
    </div>
  );
};
