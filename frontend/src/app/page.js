"use client";

import { useState } from "react";
import Image from "next/image";
import CatalogosPage from "@/pages/Catalogos/catalogos";
import CategoriasPage from "@/pages/Categorias/categorias";
import ProgramacionPage from "@/pages/Programacion/programacion";
import ReportesPage from "@/pages/Reportes/reportes";
import VariosPage from "@/pages/Varios/varios";

export default function Home() {
  const [activeTab, setActiveTab] = useState("catalogos");

  const handleTabClick = (tabId) => {
    // Si la tab ya está activa, navegar al menú principal
    if (activeTab === tabId) {
      // Disparar un evento personalizado para que cada componente maneje su navegación
      window.dispatchEvent(new CustomEvent('navigateToMainMenu', { 
        detail: { tabId } 
      }));
    }
    
    setActiveTab(tabId);
    // Hacer scroll hacia el inicio de la página
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const tabs = [
    {
      id: "catalogos",
      label: "Catálogos",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
        </svg>
      )
    },
    {
      id: "categorias",
      label: "Categorías y Canciones",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19V6a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
      )
    },
    {
      id: "programacion",
      label: "Programación",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      )
    },
    {
      id: "reportes",
      label: "Reportes",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
      )
    },
    {
      id: "varios",
      label: "Varios",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4" />
        </svg>
      )
    }
  ];

  const renderTabContent = () => {
    switch (activeTab) {
      case "catalogos":
        return <CatalogosPage />;
      case "categorias":
        return <CategoriasPage />;
      case "programacion":
        return <ProgramacionPage />;
      case "reportes":
        return <ReportesPage />;
      case "varios":
        return <VariosPage />;
      default:
        return <CatalogosPage />;
    }
  };

  return (
    <div className="h-screen bg-gradient-to-br from-gray-50 to-blue-50/30 overflow-hidden">
      {/* Enhanced Navigation */}
      <nav className="bg-white border-b border-gray-200 sticky top-0 z-40 shadow-sm">
        <div className="px-6">
          <div className="flex space-x-1 overflow-x-auto">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => handleTabClick(tab.id)}
                className={`group flex items-center space-x-2 px-4 py-3 text-sm font-medium whitespace-nowrap transition-all duration-200 relative ${
                  activeTab === tab.id
                    ? "text-blue-700 bg-blue-50"
                    : "text-gray-600 hover:text-blue-600 hover:bg-blue-50/50"
                }`}
              >
                <div
                  className={`p-1.5 rounded-lg transition-all duration-200 ${
                    activeTab === tab.id
                      ? "bg-blue-600 text-white"
                      : "bg-gray-100 text-gray-600 group-hover:bg-blue-100 group-hover:text-blue-600"
                  }`}
                >
                  {tab.icon}
                </div>
                <span className="font-semibold">{tab.label}</span>
                
                {/* Active indicator */}
                {activeTab === tab.id && (
                  <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-blue-600"></div>
                )}
              </button>
            ))}
          </div>
        </div>
      </nav>

      {/* Content Area */}
      <main className="relative h-full overflow-hidden">
        <div className="transition-opacity duration-300 ease-in-out h-full">
          {renderTabContent()}
        </div>
      </main>
    </div>
  );
}
