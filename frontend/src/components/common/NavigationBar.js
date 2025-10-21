import React from 'react';
import { 
  FolderOpen, 
  Calendar, 
  Music, 
  BarChart3, 
  Settings
} from 'lucide-react';

const NavigationBar = ({ activeTab, setActiveTab }) => {
  const tabs = [
    { id: 'catalogos', name: 'Catálogos', icon: FolderOpen, color: 'from-blue-500 to-blue-600' },
    { id: 'categorias', name: 'Categorías y Canciones', icon: Music, color: 'from-green-500 to-green-600' },
    { id: 'programacion', name: 'Programación', icon: Calendar, color: 'from-purple-500 to-purple-600' },
    { id: 'reportes', name: 'Reportes', icon: BarChart3, color: 'from-orange-500 to-orange-600' },
    { id: 'varios', name: 'Varios', icon: Settings, color: 'from-gray-500 to-gray-600' }
  ];

  return (
    <nav className="nav-bar">
      {tabs.map((tab) => {
        const IconComponent = tab.icon;
        return (
          <button
            key={tab.id}
            className={`nav-tab group ${activeTab === tab.id ? 'active' : ''}`}
            onClick={() => setActiveTab(tab.id)}
            style={{
              '--tab-color': `linear-gradient(135deg, ${tab.color.split(' ')[0].replace('from-', '')}, ${tab.color.split(' ')[2].replace('to-', '')})`
            }}
          >
            <div className="relative">
              <IconComponent size={18} className="transition-all duration-300" />
              {activeTab === tab.id && (
                <div className="absolute inset-0 animate-pulse">
                  <IconComponent size={18} className="opacity-30" />
                </div>
              )}
            </div>
            <span className="relative z-10">{tab.name}</span>
            {activeTab === tab.id && (
              <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent animate-pulse"></div>
            )}
          </button>
        );
      })}
    </nav>
  );
};

export default NavigationBar;
