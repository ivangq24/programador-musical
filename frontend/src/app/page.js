"use client";

import { useState, useEffect } from "react";
import { useRouter, usePathname } from "next/navigation";
import Image from "next/image";
import CatalogosPage from "@/pages/Catalogos/catalogos";
import CategoriasPage from "@/pages/Categorias/categorias";
import ProgramacionPage from "@/pages/Programacion/programacion";
import ReportesPage from "@/pages/Reportes/reportes";
import VariosPage from "@/pages/Varios/varios";
import { useAuth } from "@/hooks/useAuth";

export default function Home() {
  const [activeTab, setActiveTab] = useState("programacion");
  const { user, loading, authenticated, logout } = useAuth();
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    // Detectar si estamos en producción
    const isProduction = process.env.NODE_ENV === 'production' || 
                        process.env.NEXT_PUBLIC_ENVIRONMENT === 'production';
    
    // Redirigir a login si no está autenticado
    const cognitoEnabled = process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID && 
                          process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID !== '';
    
    // En producción, SIEMPRE requerir autenticación (incluso si Cognito no está configurado)
    // En desarrollo, solo requerir si Cognito está habilitado
    const shouldRequireAuth = isProduction || cognitoEnabled;
    
    // Solo redirigir si:
    // 1. No está cargando (la verificación de auth terminó)
    // 2. Se debe requerir autenticación
    // 3. No está autenticado
    // 4. No estamos ya en una página de autenticación
    if (!loading && shouldRequireAuth && !authenticated) {
      const authPaths = ['/auth/login', '/auth/setup', '/auth/verify-email', '/auth/callback'];
      if (!authPaths.includes(pathname || '')) {
        router.push('/auth/login');
      }
    }
  }, [loading, authenticated, router, pathname]);

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
      id: "programacion",
      label: "Programación",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
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
      id: "catalogos",
      label: "Catálogos",
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
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

  // Detectar si estamos en producción
  const isProduction = process.env.NODE_ENV === 'production' || 
                      process.env.NEXT_PUBLIC_ENVIRONMENT === 'production';
  
  // Mostrar loading mientras verifica autenticación
  const cognitoEnabled = process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID && 
                        process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID !== '';
  
  const shouldRequireAuth = isProduction || cognitoEnabled;
  
  // Si está cargando y se requiere autenticación, mostrar loading
  if (loading && shouldRequireAuth) {
    return (
      <div className="h-screen flex items-center justify-center bg-gradient-to-br from-gray-50 to-blue-50/30">
        <div className="text-center">
          <svg className="animate-spin h-12 w-12 text-blue-600 mx-auto mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <p className="text-gray-600">Verificando autenticación...</p>
        </div>
      </div>
    );
  }
  
  // Si no está autenticado y se requiere autenticación, no renderizar el contenido
  // (la redirección se maneja en el useEffect)
  if (!loading && shouldRequireAuth && !authenticated) {
    const authPaths = ['/auth/login', '/auth/setup', '/auth/verify-email', '/auth/callback'];
    if (!authPaths.includes(pathname || '')) {
      // Mostrar loading mientras redirige
      return (
        <div className="h-screen flex items-center justify-center bg-gradient-to-br from-gray-50 to-blue-50/30">
          <div className="text-center">
            <svg className="animate-spin h-12 w-12 text-blue-600 mx-auto mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <p className="text-gray-600">Redirigiendo al login...</p>
          </div>
        </div>
      );
    }
  }

  return (
    <div className="h-screen bg-gradient-to-br from-gray-50 to-blue-50/30 overflow-hidden">
      {/* Enhanced Navigation */}
      <nav className="bg-white border-b border-gray-200 sticky top-0 z-40 shadow-sm">
        <div className="px-6">
          <div className="flex items-center justify-between">
            <div className="flex space-x-1 overflow-x-auto flex-1">
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
            
            {/* User menu - solo mostrar si Cognito está habilitado */}
            {process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID && 
             process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID !== '' && 
             authenticated && user && (
              <div className="flex items-center space-x-3 ml-4">
                <div className="flex items-center space-x-2 px-3 py-2 bg-blue-50 rounded-lg">
                  <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white text-sm font-semibold">
                    {user.name?.charAt(0).toUpperCase() || user.email?.charAt(0).toUpperCase()}
                  </div>
                  <div className="text-sm">
                    <div className="font-medium text-gray-700">{user.name || 'Usuario'}</div>
                    <div className="text-xs text-gray-500 capitalize">{user.rol}</div>
                  </div>
                </div>
                <button
                  onClick={logout}
                  className="px-3 py-2 text-sm font-medium text-gray-600 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors duration-200"
                  title="Cerrar sesión"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                  </svg>
                </button>
              </div>
            )}
          </div>
        </div>
      </nav>

      {/* Content Area */}
      <main className="relative h-[calc(100vh-70px)] overflow-y-auto allow-scroll">
        <div className="transition-opacity duration-300 ease-in-out min-h-full">
          {renderTabContent()}
        </div>
      </main>
    </div>
  );
}
