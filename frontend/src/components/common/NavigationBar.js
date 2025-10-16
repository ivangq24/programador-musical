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
    { id: 'catalogos', name: 'Catálogos', icon: FolderOpen },
    { id: 'categorias', name: 'Categorías y Canciones', icon: Music },
    { id: 'programacion', name: 'Programación', icon: Calendar },
    { id: 'reportes', name: 'Reportes', icon: BarChart3 },
    { id: 'varios', name: 'Varios', icon: Settings }
  ];

  return (
    <nav className="nav-bar">
      {tabs.map((tab) => {
        const IconComponent = tab.icon;
        return (
          <button
            key={tab.id}
            className={`nav-tab ${activeTab === tab.id ? 'active' : ''}`}
            onClick={() => setActiveTab(tab.id)}
          >
            <IconComponent size={16} />
            <span>{tab.name}</span>
          </button>
        );
      })}
    </nav>
  );
};

export default NavigationBar;
