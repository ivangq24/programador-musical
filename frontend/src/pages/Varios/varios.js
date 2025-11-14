'use client'

import { useState, useEffect } from 'react'
import { VariosSection } from './components/VariosSections'
import GestionUsuarios from './components/Usuarios/GestionUsuarios'
import MiPerfil from './components/Perfil/MiPerfil'

export default function VariosPage() {
  const [currentView, setCurrentView] = useState('main')
  const [selectedSection, setSelectedSection] = useState(null)

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'varios') {
        setCurrentView('main')
        setSelectedSection(null)
      }
    }

    window.addEventListener('navigateToMainMenu', handleNavigateToMainMenu)
    return () => window.removeEventListener('navigateToMainMenu', handleNavigateToMainMenu)
  }, [])

  const handleSectionClick = (sectionId) => {
    setSelectedSection(sectionId)
    setCurrentView('section')
  }

  const handleBackToMain = () => {
    setCurrentView('main')
    setSelectedSection(null)
  }

  // Renderizar sección específica
  if (currentView === 'section') {
    switch (selectedSection) {
      case 'mi-perfil':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full max-w-7xl mx-auto">
              <MiPerfil />
            </div>
          </div>
        )
      case 'usuarios':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full max-w-7xl mx-auto">
              <GestionUsuarios />
            </div>
          </div>
        )
      default:
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Módulo de Varios</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
                <button
                  onClick={handleBackToMain}
                  className="mt-4 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
                >
                  Volver
                </button>
              </div>
            </div>
          </div>
        )
    }
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
      {/* Fondo decorativo */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-purple-200/20 rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-indigo-200/20 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-purple-200/10 rounded-full blur-2xl"></div>
      </div>
      
      {/* Contenido principal */}
      <div className="relative z-10 h-full flex items-center justify-center p-6 overflow-y-auto">
        <div className="w-full max-w-5xl py-8">
          <VariosSection onSectionClick={handleSectionClick} />
        </div>
      </div>
    </div>
  )
}
