'use client'

import { useState, useEffect } from 'react'

export default function Contratos() {
  const [currentView, setCurrentView] = useState('main')

  useEffect(() => {
    const handleNavigateToMainMenu = (event) => {
      if (event.detail.tabId === 'contratos') {
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
            <h2 className="text-2xl font-bold text-gray-900 mb-4">Módulo de Contratos</h2>
            <p className="text-gray-600">Funcionalidad en desarrollo</p>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex items-center justify-center">
        <div className="w-full max-w-7xl grid grid-cols-5 gap-4 h-full max-h-[500px]">
          {/* Contratos */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
            <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-blue-500 to-blue-600">
              <h3 className="text-white font-semibold text-sm">Contratos</h3>
            </div>
            <div className="flex-1 p-3 overflow-hidden">
              <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-blue-100 group-hover:bg-blue-200">
                    <svg className="w-3 h-3 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Alta Contrato</span>
                </button>
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-blue-100 group-hover:bg-blue-200">
                    <svg className="w-3 h-3 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Búsqueda Contratos</span>
                </button>
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-blue-100 group-hover:bg-blue-200">
                    <svg className="w-3 h-3 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Consulta Simple</span>
                </button>
              </div>
            </div>
          </div>

          {/* Pautas */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
            <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-green-500 to-green-600">
              <h3 className="text-white font-semibold text-sm">Pautas</h3>
            </div>
            <div className="flex-1 p-3 overflow-hidden">
              <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-green-100 group-hover:bg-green-200">
                    <svg className="w-3 h-3 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Alta Pauta</span>
                </button>
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-green-100 group-hover:bg-green-200">
                    <svg className="w-3 h-3 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Pauta Bloques</span>
                </button>
              </div>
            </div>
          </div>

          {/* Otros Cargos */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
            <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-purple-500 to-purple-600">
              <h3 className="text-white font-semibold text-sm">Otros Cargos</h3>
            </div>
            <div className="flex-1 p-3 overflow-hidden">
              <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-purple-100 group-hover:bg-purple-200">
                    <svg className="w-3 h-3 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Alta Cargo</span>
                </button>
              </div>
            </div>
          </div>

          {/* Calendarización */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
            <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-orange-500 to-orange-600">
              <h3 className="text-white font-semibold text-sm">Calendarización</h3>
            </div>
            <div className="flex-1 p-3 overflow-hidden">
              <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-orange-100 group-hover:bg-orange-200">
                    <svg className="w-3 h-3 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Calendarización Pauta</span>
                </button>
              </div>
            </div>
          </div>

          {/* Listados */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 flex flex-col">
            <div className="p-3 rounded-t-xl flex-none bg-gradient-to-r from-red-500 to-red-600">
              <h3 className="text-white font-semibold text-sm">Listados</h3>
            </div>
            <div className="flex-1 p-3 overflow-hidden">
              <div className="space-y-2 h-full flex flex-col justify-center overflow-hidden">
                <button className="w-full flex items-center space-x-2 p-2 rounded-lg border border-gray-200 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 group text-left">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center transition-colors flex-none bg-red-100 group-hover:bg-red-200">
                    <svg className="w-3 h-3 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900 leading-tight truncate">Listado Contratos</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
