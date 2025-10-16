'use client'

import { useState, useEffect } from 'react'
import { VariosSection } from './components/VariosSections'

export default function VariosPage() {
  const [currentView, setCurrentView] = useState('main')

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'varios') {
        setCurrentView('main')
      }
    }

    window.addEventListener('navigateToMainMenu', handleNavigateToMainMenu)
    return () => window.removeEventListener('navigateToMainMenu', handleNavigateToMainMenu)
  }, [])

  if (currentView !== 'main') {
    return (
      <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
        <div className="h-full flex items-center justify-center">
          <div className="text-center">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">Módulo de Varios</h2>
            <p className="text-gray-600">Funcionalidad en desarrollo</p>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex items-center justify-center">
        <div className="w-full max-w-7xl grid grid-cols-1 gap-4 h-full max-h-[500px]">
          <VariosSection />
        </div>
      </div>
    </div>
  )
}
