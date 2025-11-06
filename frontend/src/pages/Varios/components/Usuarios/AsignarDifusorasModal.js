'use client'

import { useState, useEffect } from 'react'
import { usuariosApi } from '../../../../api/auth/usuariosApi'
import { X, Building, Loader2, AlertCircle, CheckCircle } from 'lucide-react'

export default function AsignarDifusorasModal({ usuario, difusoras = [], onClose, onSuccess }) {
  const [selectedDifusoras, setSelectedDifusoras] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [success, setSuccess] = useState(false)
  
  // Cargar difusoras ya asignadas
  useEffect(() => {
    if (usuario && usuario.difusoras) {
      // Convertir siglas a IDs
      const assignedIds = difusoras
        .filter(d => usuario.difusoras.includes(d.siglas))
        .map(d => d.id)
      setSelectedDifusoras(assignedIds)
    }
  }, [usuario, difusoras])
  
  const handleDifusoraToggle = (difusoraId) => {
    setSelectedDifusoras(prev =>
      prev.includes(difusoraId)
        ? prev.filter(id => id !== difusoraId)
        : [...prev, difusoraId]
    )
  }
  
  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    
    try {
      // Primero, remover todas las asignaciones actuales
      const currentIds = difusoras
        .filter(d => usuario.difusoras?.includes(d.siglas))
        .map(d => d.id)
      
      // Remover las que ya no están seleccionadas
      for (const id of currentIds) {
        if (!selectedDifusoras.includes(id)) {
          try {
            await usuariosApi.removerDifusora(usuario.id, id)
          } catch (err) {
            console.warn('Error removiendo difusora:', err)
          }
        }
      }
      
      // Agregar las nuevas asignaciones
      const newIds = selectedDifusoras.filter(id => !currentIds.includes(id))
      if (newIds.length > 0) {
        await usuariosApi.asignarDifusorasMultiple(usuario.id, newIds)
      }
      
      setSuccess(true)
      setTimeout(() => {
        onSuccess()
      }, 1000)
    } catch (err) {
      console.error('Error asignando difusoras:', err)
      setError(err.response?.data?.detail || err.message || 'Error al asignar difusoras')
    } finally {
      setLoading(false)
    }
  }
  
  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="bg-gradient-to-r from-indigo-600 to-purple-600 p-6 rounded-t-2xl flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <Building className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-2xl font-bold text-white">Asignar Difusoras</h3>
              <p className="text-indigo-100 text-sm">{usuario?.nombre}</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-white/20 rounded-lg transition-colors"
          >
            <X className="w-6 h-6 text-white" />
          </button>
        </div>
        
        {/* Contenido */}
        <div className="p-6">
          {success ? (
            <div className="text-center py-8">
              <div className="bg-green-50 border border-green-200 rounded-xl p-4 inline-flex items-center space-x-3">
                <CheckCircle className="w-6 h-6 text-green-600" />
                <p className="text-green-800 font-semibold">Difusoras asignadas exitosamente</p>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              <div>
                <p className="text-sm text-gray-600 mb-4">
                  Selecciona las difusoras que {usuario?.nombre} podrá gestionar:
                </p>
                
                {difusoras.length === 0 ? (
                  <div className="text-center py-8 text-gray-500">
                    <Building className="w-12 h-12 mx-auto mb-3 text-gray-400" />
                    <p>No hay difusoras disponibles</p>
                  </div>
                ) : (
                  <div className="max-h-64 overflow-y-auto border border-gray-200 rounded-lg p-3 space-y-2">
                    {difusoras.map((difusora) => (
                      <label
                        key={difusora.id}
                        className="flex items-center space-x-3 p-3 hover:bg-gray-50 rounded-lg cursor-pointer border border-transparent hover:border-gray-200 transition-colors"
                      >
                        <input
                          type="checkbox"
                          checked={selectedDifusoras.includes(difusora.id)}
                          onChange={() => handleDifusoraToggle(difusora.id)}
                          className="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500"
                        />
                        <div className="flex-1">
                          <p className="font-medium text-gray-900">{difusora.siglas}</p>
                          <p className="text-sm text-gray-600">{difusora.nombre}</p>
                        </div>
                        {difusora.activa ? (
                          <span className="px-2 py-1 bg-green-100 text-green-800 rounded text-xs font-semibold">
                            Activa
                          </span>
                        ) : (
                          <span className="px-2 py-1 bg-gray-100 text-gray-800 rounded text-xs font-semibold">
                            Inactiva
                          </span>
                        )}
                      </label>
                    ))}
                  </div>
                )}
              </div>
              
              {/* Error */}
              {error && (
                <div className="bg-red-50 border border-red-200 rounded-xl p-4 flex items-start space-x-3">
                  <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                  <p className="text-red-800 text-sm">{error}</p>
                </div>
              )}
              
              {/* Botones */}
              <div className="flex items-center space-x-3 pt-4">
                <button
                  type="button"
                  onClick={onClose}
                  className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-colors"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {loading ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      <span>Guardando...</span>
                    </>
                  ) : (
                    <>
                      <Building className="w-5 h-5" />
                      <span>Guardar Asignaciones</span>
                    </>
                  )}
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}

