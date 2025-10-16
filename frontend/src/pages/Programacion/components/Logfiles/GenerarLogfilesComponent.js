'use client'

import { useState } from 'react'
import { FileText, Clock, History, Shield, ArrowLeft } from 'lucide-react'

export default function GenerarLogfilesComponent({ onBack }) {
  const [selectedOption, setSelectedOption] = useState('')

  const logfileOptions = [
    { id: 'generar-logfiles', name: 'Generar logfiles', icon: FileText, description: 'Generar archivos de log del sistema' },
    { id: 'cartas-tiempo', name: 'Generar cartas de tiempo', icon: Clock, description: 'Crear cartas de tiempo para programación' },
    { id: 'historial-dias', name: 'Historial por días', icon: History, description: 'Consultar historial de programación por días' },
    { id: 'auditoria-transmision', name: 'Auditoría de la transmisión', icon: Shield, description: 'Revisar auditoría de transmisiones' }
  ]

  const handleOptionSelect = (optionId) => {
    setSelectedOption(optionId)
    console.log(`Seleccionada opción: ${optionId}`)
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center space-x-4">
            <h1 className="text-2xl font-bold text-gray-900">Logfiles</h1>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 grid grid-cols-2 gap-6">
          {logfileOptions.map((option) => {
            const IconComponent = option.icon
            return (
              <div
                key={option.id}
                onClick={() => handleOptionSelect(option.id)}
                className={`p-6 rounded-xl border-2 cursor-pointer transition-all duration-200 ${
                  selectedOption === option.id
                    ? 'border-blue-500 bg-blue-50 shadow-lg'
                    : 'border-gray-200 bg-white hover:border-gray-300 hover:shadow-md'
                }`}
              >
                <div className="flex items-start space-x-4">
                  <div className={`p-3 rounded-lg ${
                    selectedOption === option.id ? 'bg-blue-100' : 'bg-gray-100'
                  }`}>
                    <IconComponent className={`w-6 h-6 ${
                      selectedOption === option.id ? 'text-blue-600' : 'text-gray-600'
                    }`} />
                  </div>
                  <div className="flex-1">
                    <h3 className={`text-lg font-semibold mb-2 ${
                      selectedOption === option.id ? 'text-blue-900' : 'text-gray-900'
                    }`}>
                      {option.name}
                    </h3>
                    <p className="text-sm text-gray-600">
                      {option.description}
                    </p>
                  </div>
                </div>
              </div>
            )
          })}
        </div>

        {/* Footer */}
        {selectedOption && (
          <div className="mt-6 p-4 bg-gray-50 rounded-lg">
            <p className="text-sm text-gray-600">
              Opción seleccionada: <span className="font-medium">{logfileOptions.find(opt => opt.id === selectedOption)?.name}</span>
            </p>
            <div className="mt-3 flex space-x-3">
              <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                Continuar
              </button>
              <button 
                onClick={() => setSelectedOption('')}
                className="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-colors"
              >
                Cancelar
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
