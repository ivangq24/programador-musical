import React from 'react';
import { 
  Shield, FileText, Clock, Play, Calendar
} from 'lucide-react';

// Sección Programación Unificada (similar a Catálogos)
export const ProgramacionSection = ({ onItemClick }) => {
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
      name: 'Generar programación', 
      icon: Play, 
      id: 'generar-programacion',
      description: 'Genera la programación musical',
      color: 'from-green-500 to-green-600',
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
      hoverColor: 'hover:bg-green-50'
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
    <div className="space-y-6">
      {/* Header con gradiente mejorado */}
      <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
        <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 p-8 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
          <div className="relative z-10 flex items-center space-x-5">
            <div className="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-sm shadow-lg">
              <Calendar className="w-8 h-8 text-white" />
            </div>
            <div>
              <h3 className="text-3xl font-bold text-white mb-1">Programación</h3>
              <p className="text-blue-100 text-base">Gestión de programación musical</p>
            </div>
          </div>
          {/* Efecto de partículas decorativas */}
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
          <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
          <div className="absolute top-1/2 right-1/4 w-24 h-24 bg-white/5 rounded-full"></div>
        </div>
      </div>

      {/* Tarjetas de secciones mejoradas */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {items.map((item, itemIndex) => {
          const ItemIcon = item.icon;
          return (
            <button 
              key={itemIndex} 
              onClick={() => {

                onItemClick && onItemClick(item.id)
              }}
              className={`group relative bg-white rounded-2xl shadow-xl border-2 border-gray-200 hover:border-gray-300 hover:shadow-2xl transition-all duration-300 text-left overflow-hidden transform hover:scale-[1.02] hover:-translate-y-2`}
            >
              {/* Background con gradiente sutil */}
              <div className={`absolute inset-0 bg-gradient-to-br ${item.bgColor} opacity-30 group-hover:opacity-50 transition-opacity duration-300`}></div>
              
              {/* Contenido */}
              <div className="relative p-8">
                <div className="flex items-start justify-between mb-4">
                  <div className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${item.color} flex items-center justify-center group-hover:scale-110 transition-transform duration-300 shadow-lg`}>
                    <ItemIcon className="w-8 h-8 text-white" />
                  </div>
                  
                  {/* Indicador de flecha mejorado */}
                  <div className="opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-4 group-hover:translate-x-0">
                    <div className="w-10 h-10 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center shadow-md">
                      <svg className="w-5 h-5 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                      </svg>
                    </div>
                  </div>
                </div>
                
                <div className="space-y-2">
                  <h4 className="text-2xl font-bold text-gray-900 group-hover:text-gray-800 transition-colors">
                    {item.name}
                  </h4>
                  <p className="text-gray-600 text-sm leading-relaxed">
                    {item.description}
                  </p>
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

// Mantener las exportaciones para compatibilidad (aunque ya no se usan)
export const PoliticasSection = ProgramacionSection;
export const LogfilesSection = ProgramacionSection;
