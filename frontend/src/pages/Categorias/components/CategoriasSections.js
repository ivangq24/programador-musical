import React from 'react';
import { 
  Tags, Database, List, FileAudio, Upload
} from 'lucide-react';

// Sección Categorías
export const CategoriasSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Mantenimiento de categorías', 
      icon: Tags, 
      id: 'mantenimiento-categorias',
      description: 'Gestiona las categorías musicales',
      color: 'from-green-500 to-green-600',
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
      hoverColor: 'hover:bg-green-50'
    },
    { 
      name: 'Movimientos entre categorías', 
      icon: Database, 
      id: 'movimientos-categorias',
      description: 'Administra transferencias entre categorías',
      color: 'from-emerald-500 to-emerald-600',
      bgColor: 'bg-emerald-50',
      iconColor: 'text-emerald-600',
      hoverColor: 'hover:bg-emerald-50'
    }
  ];

  return (
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-green-600 via-emerald-600 to-teal-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-green-600/90 to-emerald-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <Tags className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Categorías</h3>
            <p className="text-green-100 text-sm">Gestión de categorías musicales</p>
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
                  console.log('Categorias button clicked:', item.id, item.name)
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

// Sección Conjuntos
export const ConjuntosSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Mantenimiento en conjuntos', 
      icon: List, 
      id: 'mantenimiento-conjuntos',
      description: 'Gestiona grupos de elementos',
      color: 'from-blue-500 to-blue-600',
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
      hoverColor: 'hover:bg-blue-50'
    }
  ];

  return (
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-blue-600 via-cyan-600 to-teal-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-cyan-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <List className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Conjuntos</h3>
            <p className="text-blue-100 text-sm">Gestión de grupos y conjuntos</p>
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
                  console.log('Conjuntos button clicked:', item.id, item.name)
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

// Sección Canciones
export const CancionesSection = ({ onItemClick }) => {
  const items = [
    { 
      name: 'Mantenimiento de canciones', 
      icon: FileAudio, 
      id: 'mantenimiento-canciones',
      description: 'Gestiona el catálogo de canciones',
      color: 'from-red-500 to-red-600',
      bgColor: 'bg-red-50',
      iconColor: 'text-red-600',
      hoverColor: 'hover:bg-red-50'
    },
    { 
      name: 'Importar a CSV', 
      icon: Upload, 
      id: 'importar-csv',
      description: 'Importa datos desde archivos CSV',
      color: 'from-orange-500 to-orange-600',
      bgColor: 'bg-orange-50',
      iconColor: 'text-orange-600',
      hoverColor: 'hover:bg-orange-50'
    }
  ];

  return (
    <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
      {/* Header con gradiente mejorado */}
      <div className="bg-gradient-to-r from-red-600 via-pink-600 to-orange-600 p-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-red-600/90 to-pink-600/90"></div>
        <div className="relative z-10 flex items-center space-x-4">
          <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
            <FileAudio className="w-6 h-6 text-white" />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-white">Canciones</h3>
            <p className="text-red-100 text-sm">Gestión del catálogo musical</p>
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
                  console.log('Canciones button clicked:', item.id, item.name)
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
