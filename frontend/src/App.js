import React, { useState } from 'react';
import './App.css';
import NavigationBar from './components/NavigationBar';
import BottomBar from './components/BottomBar';
import CatalogosTab from './components/tabs/CatalogosTab';
import CategoriasTab from './components/tabs/CategoriasTab';
import ProgramacionTab from './components/tabs/ProgramacionTab';
import ReportesTab from './components/tabs/ReportesTab';
import VariosTab from './components/tabs/VariosTab';

function App() {
  const [activeTab, setActiveTab] = useState('catalogos');

  const renderActiveTab = () => {
    switch (activeTab) {
      case 'catalogos':
        return <CatalogosTab />;
      case 'categorias':
        return <CategoriasTab />;
      case 'programacion':
        return <ProgramacionTab />;
      case 'reportes':
        return <ReportesTab />;
      case 'varios':
        return <VariosTab />;
      default:
        return <CatalogosTab />;
    }
  };

  return (
    <div className="App">
      {/* Navigation Bar */}
      <NavigationBar activeTab={activeTab} setActiveTab={setActiveTab} />

      {/* Main Content */}
      <main className="main-content">
        {renderActiveTab()}
      </main>

      {/* Bottom Bar */}
      <BottomBar />
    </div>
  );
}

export default App;
