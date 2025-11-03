'use client'

import { useState, useEffect } from 'react'
import { GeneralSection } from './components/CatalogosSections'
import Difusoras from './components/Difusoras'
import Cortes from './components/Cortes/Cortes'
import { Building } from 'lucide-react'

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
    <div className="h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
      {/* Fondo decorativo */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-blue-200/20 rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-purple-200/20 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-indigo-200/10 rounded-full blur-2xl"></div>
      </div>
      
      {/* Contenido principal */}
      <div className="relative z-10 h-full flex items-center justify-center p-6 overflow-y-auto">
        <div className="w-full max-w-5xl py-8">
          <GeneralSection onSectionClick={handleSectionClick} />
        </div>
      </div>
    </div>
  )
}
