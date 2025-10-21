import React from 'react';
import { 
  Shield, FileText, Target, Clock, Play, History, Upload
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
    { 
      name: 'Reporte de reglas', 
      icon: FileText, 
      id: 'reporte-reglas',
      description: 'Genera reportes de reglas aplicadas',
      color: 'from-violet-500 to-violet-600',
      bgColor: 'bg-violet-50',
      iconColor: 'text-violet-600',
      hoverColor: 'hover:bg-violet-50'
    },
    { 
      name: 'Grupos de reglas', 
      icon: Target, 
      id: 'grupos-reglas',
      description: 'Administra grupos de reglas',
      color: 'from-indigo-500 to-indigo-600',
      bgColor: 'bg-indigo-50',
      iconColor: 'text-indigo-600',
      hoverColor: 'hover:bg-indigo-50'
    },
    { 
      name: 'Grupos de relojes', 
      icon: Clock, 
      id: 'grupos-relojes',
      description: 'Gestiona grupos de relojes',
      color: 'from-blue-500 to-blue-600',
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
      hoverColor: 'hover:bg-blue-50'
    }
  ];

  return (
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-purple-600 via-violet-600 to-indigo-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-purple-600/90 to-violet-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <Shield className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Políticas</h3>
            <p className="text-purple-100 text-sm">Gestión de políticas y reglas</p>
          </div>
        </div>
        {/* Efecto de partículas decorativas */}
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
        <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
      </div>

      {/* Contenido con grid mejorado */}
      <div className="p-6">
        <div className="space-y-3">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => onItemClick && onItemClick(item.id)}
                className={`group relative p-4 rounded-xl border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left bg-white ${item.hoverColor} transform hover:scale-[1.02] hover:-translate-y-1 w-full`}
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
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-green-600 via-emerald-600 to-teal-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-green-600/90 to-emerald-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <Play className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Programación</h3>
            <p className="text-green-100 text-sm">Generación de programación musical</p>
          </div>
        </div>
        {/* Efecto de partículas decorativas */}
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
        <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
      </div>

      {/* Contenido con grid mejorado */}
      <div className="p-6">
        <div className="space-y-3">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => onItemClick && onItemClick(item.id)}
                className={`group relative p-4 rounded-xl border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left bg-white ${item.hoverColor} transform hover:scale-[1.02] hover:-translate-y-1 w-full`}
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
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-orange-600 via-amber-600 to-yellow-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-orange-600/90 to-amber-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <FileText className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Logfiles</h3>
            <p className="text-orange-100 text-sm">Gestión de archivos y auditoría</p>
          </div>
        </div>
        {/* Efecto de partículas decorativas */}
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
        <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
      </div>

      {/* Contenido con grid mejorado */}
      <div className="p-6">
        <div className="space-y-3">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => {
                  console.log('Logfiles button clicked:', item.id, item.name)
                  onItemClick && onItemClick(item.id)
                }}
                className={`group relative p-4 rounded-xl border border-gray-200 hover:border-gray-300 hover:shadow-lg transition-all duration-300 text-left bg-white ${item.hoverColor} transform hover:scale-[1.02] hover:-translate-y-1 w-full`}
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
