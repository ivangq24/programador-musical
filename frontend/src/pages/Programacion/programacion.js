'use client'

import { useState, useEffect } from 'react'
import { PoliticasSection, ProgramacionSection, LogfilesSection } from './components/ProgramacionSections'
import { PoliticasProgramacion, ReporteReglasComponent } from './components/Politicas'
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
      case 'reporte-reglas':
        return <SimplePage title="REPORTE DE REGLAS" color="purple" />
      case 'grupos-reglas':
        return <SimplePage title="GRUPOS DE REGLAS" color="yellow" />
      case 'grupos-relojes':
        return <SimplePage title="GRUPOS DE RELOJES" color="orange" />
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
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex items-center justify-center">
        <div className="w-full max-w-7xl grid grid-cols-3 gap-4 h-full max-h-[500px]">
          <PoliticasSection onItemClick={handleItemClick} />
          <ProgramacionSection onItemClick={handleItemClick} />
          <LogfilesSection onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  )
}
