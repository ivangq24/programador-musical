'use client'

import { useState, useEffect } from 'react'
import { CategoriasSection, ConjuntosSection, CancionesSection } from './components/CategoriasSections'
import SimplePage from '../Programacion/components/SimplePage'
import { ImportCSVComponent } from '../Programacion/components/ImportCSV'
import { MantenimientoCanciones } from './components/Canciones'

export default function CategoriasPage() {
  const [currentView, setCurrentView] = useState('main')
  const [selectedSection, setSelectedSection] = useState(null)

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'categorias') {
        setCurrentView('main')
        setSelectedSection(null)
      }
    }

    window.addEventListener('navigateToMainMenu', handleNavigateToMainMenu)
    return () => window.removeEventListener('navigateToMainMenu', handleNavigateToMainMenu)
  }, [])

  const handleItemClick = (itemId) => {
    console.log('=== CATEGORIAS NAVIGATION DEBUG ===')
    console.log('Item clicked:', itemId)
    console.log('Current view before:', currentView)
    console.log('Selected section before:', selectedSection)
    setSelectedSection(itemId)
    setCurrentView('section')
    console.log('Navigation state updated')
    console.log('===================================')
  }

  const handleBackToMain = () => {
    setCurrentView('main')
    setSelectedSection(null)
  }

  // Renderizar componente específico según la sección seleccionada
  const renderSection = () => {
    console.log('=== CATEGORIAS RENDER SECTION DEBUG ===')
    console.log('Rendering section:', selectedSection)
    console.log('Current view:', currentView)
    console.log('========================================')
    switch (selectedSection) {
      case 'mantenimiento-categorias':
        return <SimplePage title="MANTENIMIENTO DE CATEGORÍAS" color="green" />
      case 'movimientos-categorias':
        return <SimplePage title="MOVIMIENTOS ENTRE CATEGORÍAS" color="green" />
      case 'mantenimiento-conjuntos':
        return <SimplePage title="MANTENIMIENTO EN CONJUNTOS" color="blue" />
      case 'mantenimiento-canciones':
        return <MantenimientoCanciones />
      case 'importar-csv':
        return <ImportCSVComponent onBack={handleBackToMain} />
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
          <CategoriasSection onItemClick={handleItemClick} />
          <ConjuntosSection onItemClick={handleItemClick} />
          <CancionesSection onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  )
}
