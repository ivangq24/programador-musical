import React from 'react';
import { 
  Building, Tags, Database, Users, UserCheck, Music, Clock, Scissors
} from 'lucide-react';

// Sección General
export const GeneralSection = ({ onSectionClick }) => {
  const items = [
    { name: 'Difusoras', icon: Building },
    { name: 'Cortes', icon: Scissors },
    { name: 'Tipo de clasificaciones', icon: Tags },
    { name: 'Clasificaciones', icon: Database },
    { name: 'Interpretes', icon: Users },
    { name: 'Personas', icon: UserCheck },
    { name: 'Sellos discográficos', icon: Music },
    { name: 'Dayparts', icon: Clock }
  ];

  const handleItemClick = (itemName) => {
    if (onSectionClick) {
      onSectionClick(itemName);
    }
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-indigo-500 to-indigo-600">
        <h3 className="text-white font-semibold text-sm">Generales</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => handleItemClick(item.name)}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-indigo-100 group-hover:bg-indigo-200">
                  <ItemIcon className="w-3 h-3 text-indigo-600" />
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

// Sección Usuarios
export const UsuariosSection = ({ onSectionClick }) => {
  const items = [
    { name: 'Grupos de usuarios', icon: Users },
    { name: 'Usuarios', icon: UserCheck }
  ];

  const handleItemClick = (itemName) => {
    if (onSectionClick) {
      onSectionClick(itemName);
    }
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
      <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-orange-500 to-orange-600">
        <h3 className="text-white font-semibold text-sm">Usuarios</h3>
      </div>
      <div className="flex-1 p-3 overflow-hidden">
        <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
          {items.map((item, itemIndex) => {
            const ItemIcon = item.icon;
            return (
              <button 
                key={itemIndex} 
                onClick={() => handleItemClick(item.name)}
                className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left"
              >
                <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-orange-100 group-hover:bg-orange-200">
                  <ItemIcon className="w-3 h-3 text-orange-600" />
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
