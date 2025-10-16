'use client'

import { useState, useEffect } from 'react'
import { GeneralSection, UsuariosSection } from './components/CatalogosSections'
import Difusoras from './components/Difusoras'
import Cortes from './components/Cortes/Cortes'

export default function CatalogosPage() {
  const [currentView, setCurrentView] = useState('main')
  const [selectedSection, setSelectedSection] = useState(null)

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'catalogos') {
        setCurrentView('main')
        setSelectedSection(null)
      }
    }

    window.addEventListener('navigateToMainMenu', handleNavigateToMainMenu)
    return () => window.removeEventListener('navigateToMainMenu', handleNavigateToMainMenu)
  }, [])

  const handleSectionClick = (sectionName) => {
    setSelectedSection(sectionName)
    setCurrentView('section')
  }

  const handleBackToMain = () => {
    setCurrentView('main')
    setSelectedSection(null)
  }

  // Render different sections based on selection
  const renderSection = () => {
    switch (selectedSection) {
      case 'Difusoras':
        return <Difusoras onDifusoraSelect={(difusora) => console.log('Difusora seleccionada:', difusora)} />
      case 'Cortes':
        return <Cortes />
      case 'Tipo de clasificaciones':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Tipo de Clasificaciones</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Clasificaciones':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Clasificaciones</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Interpretes':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Intérpretes</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Personas':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Personas</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Sellos discográficos':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Sellos Discográficos</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Dayparts':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Dayparts</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Grupos de usuarios':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Grupos de Usuarios</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      case 'Usuarios':
        return (
          <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
            <div className="h-full flex items-center justify-center">
              <div className="text-center">
                <h2 className="text-2xl font-bold text-gray-900 mb-4">Usuarios</h2>
                <p className="text-gray-600">Funcionalidad en desarrollo</p>
              </div>
            </div>
          </div>
        )
      default:
        return null
    }
  }

  if (currentView === 'section' && selectedSection) {
    return (
      <div className="relative">
        {/* Section content */}
        {renderSection()}
      </div>
    )
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex items-center justify-center">
        <div className="w-full max-w-7xl grid grid-cols-2 gap-4 h-full max-h-[500px]">
          <GeneralSection onSectionClick={handleSectionClick} />
          <UsuariosSection onSectionClick={handleSectionClick} />
        </div>
      </div>
    </div>
  )
}
