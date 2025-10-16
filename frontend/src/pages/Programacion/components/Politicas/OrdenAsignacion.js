'use client'

import { useState, useEffect } from 'react'
import {
  ChevronUp,
  ChevronDown,
  Check,
  X,
  Clock,
  Tag,
  ArrowRight,
  ArrowLeft,
  Settings,
  RotateCcw
} from 'lucide-react'
import { getCategoriasCanciones, guardarCategoriasPolitica, obtenerCategoriasPolitica } from '../../../../api/canciones'

export default function OrdenAsignacion({ onSave, onCancel, politicaId = 1 }) {
  const [esquemaOrden, setEsquemaOrden] = useState('horas-categorias') // 'horas-categorias' o 'categorias-horas'
  const [categoriasSeleccionadas, setCategoriasSeleccionadas] = useState([])
  const [categoriasDisponibles, setCategoriasDisponibles] = useState([])
  const [loading, setLoading] = useState(false)

  // Horas fijas del 00 al 23 - solo para mostrar
  const horasFijas = Array.from({ length: 24 }, (_, i) => {
    const hora = i.toString().padStart(2, '0')
    return { id: hora, nombre: hora }
  })

  // Cargar categorías disponibles
  useEffect(() => {
    loadCategorias()
  }, [])

  const loadCategorias = async () => {
    setLoading(true)
    try {
      // Cargar categorías disponibles desde la API
      const response = await getCategoriasCanciones()
      const categorias = response.categorias.map((nombre, index) => ({
        id: index + 1,
        nombre: nombre,
        activa: true
      }))
      
      setCategoriasDisponibles(categorias)
      
      // Cargar categorías ya seleccionadas para esta política
      const categoriasGuardadas = await obtenerCategoriasPolitica(politicaId)
      if (categoriasGuardadas.categorias && categoriasGuardadas.categorias.length > 0) {
        // Mapear las categorías guardadas al formato esperado
        const categoriasSeleccionadasFormateadas = categoriasGuardadas.categorias.map((nombre, index) => {
          const categoriaDisponible = categorias.find(c => c.nombre === nombre)
          return categoriaDisponible || { id: index + 1000, nombre: nombre, activa: true }
        })
        setCategoriasSeleccionadas(categoriasSeleccionadasFormateadas)
        console.log('Categorías cargadas desde la DB:', categoriasSeleccionadasFormateadas)
      }
    } catch (error) {
      console.error('Error loading categorías:', error)
      // En caso de error, mostrar lista vacía
      setCategoriasDisponibles([])
    } finally {
      setLoading(false)
    }
  }

  const handleEsquemaChange = (esquema) => {
    setEsquemaOrden(esquema)
  }


  const handleCategoriaToggle = (categoria) => {
    setCategoriasSeleccionadas(prev => {
      if (prev.some(c => c.id === categoria.id)) {
        return prev.filter(c => c.id !== categoria.id)
      } else {
        return [...prev, categoria]
      }
    })
  }

  const moveCategoriaUp = (index) => {
    if (index > 0) {
      const newCategorias = [...categoriasSeleccionadas]
      const temp = newCategorias[index]
      newCategorias[index] = newCategorias[index - 1]
      newCategorias[index - 1] = temp
      setCategoriasSeleccionadas(newCategorias)
    }
  }

  const moveCategoriaDown = (index) => {
    if (index < categoriasSeleccionadas.length - 1) {
      const newCategorias = [...categoriasSeleccionadas]
      const temp = newCategorias[index]
      newCategorias[index] = newCategorias[index + 1]
      newCategorias[index + 1] = temp
      setCategoriasSeleccionadas(newCategorias)
    }
  }

  const handleSave = async () => {
    try {
      const configuracion = {
        esquema: esquemaOrden,
        categorias: categoriasSeleccionadas.map(c => ({ id: c.id, nombre: c.nombre }))
      }
      
      // Guardar las categorías en la base de datos
      const categoriasNombres = categoriasSeleccionadas.map(c => c.nombre)
      await guardarCategoriasPolitica(politicaId, categoriasNombres)
      
      console.log('Categorías guardadas exitosamente:', categoriasNombres)
      
      onSave(configuracion)
      return true
    } catch (error) {
      console.error('Error guardando categorías:', error)
      // Mostrar mensaje de error al usuario
      alert('Error al guardar las categorías. Inténtalo de nuevo.')
      return false
    }
  }

  // Exponer la función handleSave al componente padre usando useImperativeHandle
  useEffect(() => {
    if (typeof onSave === 'function') {
      // Si onSave es una función, la llamamos con la función handleSave
      onSave.handleSave = handleSave
    }
  }, [categoriasSeleccionadas, esquemaOrden])

  const handleReset = () => {
    setCategoriasSeleccionadas([])
    setEsquemaOrden('horas-categorias')
  }


  const handleSelectAllCategories = () => {
    setCategoriasSeleccionadas([...categoriasDisponibles])
  }

  const handleDeselectAllCategories = () => {
    setCategoriasSeleccionadas([])
  }

  return (
    <div className="space-y-6">


      {/* Contenido Principal */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Horas */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center mb-4">
            <h4 className="text-lg font-semibold text-gray-900 flex items-center space-x-2">
              <Clock className="w-5 h-5 text-blue-600" />
              <span>Horas</span>
            </h4>
          </div>
          
          <div className="max-h-80 overflow-y-auto border border-gray-200 rounded-lg">
            <div className="grid grid-cols-6 gap-2 p-3">
              {horasFijas.map((hora) => (
                <div
                  key={hora.id}
                  className="p-2 rounded-lg border-2 border-gray-200 bg-gray-50 text-center"
                >
                  <div className="text-sm font-semibold text-gray-700">{hora.nombre}</div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Categorías */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h4 className="text-lg font-semibold text-gray-900 flex items-center space-x-2">
              <Tag className="w-5 h-5 text-green-600" />
              <span>Categorías</span>
            </h4>
          </div>
          
          <div className="max-h-80 overflow-y-auto border border-gray-200 rounded-lg">
            {loading ? (
              <div className="flex items-center justify-center p-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
                <span className="ml-3 text-gray-600">Cargando categorías...</span>
              </div>
            ) : (
              <div className="space-y-2 p-3">
                {categoriasDisponibles.map((categoria) => (
                <button
                  key={categoria.id}
                  onClick={() => handleCategoriaToggle(categoria)}
                  className={`w-full p-3 rounded-lg border-2 transition-all duration-200 text-left ${
                    categoriasSeleccionadas.some(c => c.id === categoria.id)
                      ? 'border-green-500 bg-green-50 text-green-700 shadow-sm'
                      : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <span className="font-medium">{categoria.nombre}</span>
                    {categoriasSeleccionadas.some(c => c.id === categoria.id) && (
                      <Check className="w-4 h-4 text-green-600" />
                    )}
                  </div>
                </button>
                ))}
              </div>
            )}
          </div>
          
        </div>
      </div>


      {/* Resumen de Configuración */}
      <div className="bg-gradient-to-r from-purple-50 to-blue-50 rounded-xl border border-purple-200 p-6">
        <h4 className="text-lg font-semibold text-gray-900 mb-4">Resumen de Configuración</h4>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="text-center">
            <div className="text-2xl font-bold text-purple-600">
              {esquemaOrden === 'horas-categorias' ? 'Horas → Categorías' : 'Categorías → Horas'}
            </div>
            <div className="text-sm text-gray-600">Esquema de orden</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-blue-600">24</div>
            <div className="text-sm text-gray-600">Horas disponibles</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-green-600">{categoriasSeleccionadas.length}</div>
            <div className="text-sm text-gray-600">Categorías seleccionadas</div>
            <div className="text-xs text-gray-500 mt-1">
              {categoriasSeleccionadas.length === 0 ? 'Sin categorías' : 
               categoriasSeleccionadas.length === categoriasDisponibles.length ? 'Todas las categorías' : 
               `${categoriasSeleccionadas.length} categorías específicas`}
            </div>
          </div>
        </div>
      </div>

    </div>
  )
}
