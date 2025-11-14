'use client'

import { useState, useEffect } from 'react'
import { ProgramacionSection } from './components/ProgramacionSections'
import { PoliticasProgramacion } from './components/Politicas'
import { GenerarProgramacionComponent } from './components/Programacion'
import SimplePage from './components/SimplePage'

export default function ProgramacionPage() {
  const [currentView, setCurrentView] = useState('main')
  const [selectedSection, setSelectedSection] = useState(null)

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'programacion') {
        setCurrentView('main')
        setSelectedSection(null)
      }
    }

    window.addEventListener('navigateToMainMenu', handleNavigateToMainMenu)
    return () => window.removeEventListener('navigateToMainMenu', handleNavigateToMainMenu)
  }, [])

  const handleItemClick = (itemId) => {




    setSelectedSection(itemId)
    setCurrentView('section')


  }

  const handleBackToMain = () => {
    setCurrentView('main')
    setSelectedSection(null)
  }

  // Renderizar componente específico según la sección seleccionada
  const renderSection = () => {




    switch (selectedSection) {
      case 'politicas-programacion':
        return <PoliticasProgramacion />
      case 'generar-programacion':
        return <GenerarProgramacionComponent />
      default:
        return null
    }
  }

  if (currentView === 'section' && selectedSection) {
    return renderSection()
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
      {/* Fondo decorativo */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-purple-200/20 rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-green-200/20 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-orange-200/10 rounded-full blur-2xl"></div>
      </div>
      
      {/* Contenido principal */}
      <div className="relative z-10 h-full flex items-center justify-center p-6 overflow-y-auto">
        <div className="w-full max-w-5xl py-8">
          <ProgramacionSection onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  )
}
