'use client'

import { useState, useEffect } from 'react'
import { PoliticasSection, ProgramacionSection, LogfilesSection } from './components/ProgramacionSections'
import { PoliticasProgramacion } from './components/Politicas'
import { GenerarProgramacionComponent } from './components/Programacion'
import { GenerarLogfilesComponent } from './components/Logfiles'
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
    console.log('=== NAVIGATION DEBUG ===')
    console.log('Item clicked:', itemId)
    console.log('Current view before:', currentView)
    console.log('Selected section before:', selectedSection)
    setSelectedSection(itemId)
    setCurrentView('section')
    console.log('Navigation state updated')
    console.log('========================')
  }

  const handleBackToMain = () => {
    setCurrentView('main')
    setSelectedSection(null)
  }

  // Renderizar componente específico según la sección seleccionada
  const renderSection = () => {
    console.log('=== RENDER SECTION DEBUG ===')
    console.log('Rendering section:', selectedSection)
    console.log('Current view:', currentView)
    console.log('============================')
    switch (selectedSection) {
      case 'politicas-programacion':
        return <PoliticasProgramacion />
      case 'generar-programacion':
        return <GenerarProgramacionComponent />
      case 'generar-logfiles':
        return <GenerarLogfilesComponent />
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
      <div className="relative z-10 h-full flex items-center justify-center p-5">
        <div className="w-full max-w-6xl grid grid-cols-1 lg:grid-cols-3 gap-5 h-full max-h-[calc(100vh-120px)]">
          <PoliticasSection onItemClick={handleItemClick} />
          <ProgramacionSection onItemClick={handleItemClick} />
          <LogfilesSection onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  )
}
