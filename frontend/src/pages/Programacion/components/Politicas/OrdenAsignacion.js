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
import { getCategoriasCanciones, guardarCategoriasPolitica, obtenerCategoriasPolitica } from '../../../../api/canciones/index'

export default function OrdenAsignacion({ onSave, onCancel, politicaId = 1, categoriasSeleccionadas, setCategoriasSeleccionadas }) {
  const [esquemaOrden, setEsquemaOrden] = useState('horas-categorias') // 'horas-categorias' o 'categorias-horas'
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
      console.log('🔍 Cargando categorías desde la API...')
      // Cargar categorías disponibles desde la API
      const response = await getCategoriasCanciones()
      console.log('📊 Respuesta completa de la API:', response)
      console.log('📊 Categorías recibidas:', response.categorias)
      console.log('📊 Total de categorías:', response.categorias?.length || 0)
      
      const categorias = response.categorias.map((nombre, index) => ({
        id: index + 1,
        nombre: nombre,
        activa: true
      }))
      
      console.log('📊 Categorías formateadas:', categorias)
      setCategoriasDisponibles(categorias)
      
      // Cargar categorías ya seleccionadas para esta política
      console.log('🔍 Cargando categorías guardadas para política ID:', politicaId)
      const categoriasGuardadas = await obtenerCategoriasPolitica(politicaId)
      console.log('📊 Categorías guardadas:', categoriasGuardadas)
      
      // Solo cargar desde la DB si no hay categorías seleccionadas en el estado del padre
      if (categoriasSeleccionadas.length === 0) {
        if (categoriasGuardadas.categorias && categoriasGuardadas.categorias.length > 0) {
          // Mapear SOLO las categorías guardadas que están disponibles
          const categoriasSeleccionadasFormateadas = categoriasGuardadas.categorias
            .map(nombre => categorias.find(c => c.nombre === nombre))
            .filter(Boolean) // Eliminar las que no se encontraron (como "Jazz")
          
          console.log('📊 Categorías guardadas originales:', categoriasGuardadas.categorias)
          console.log('📊 Categorías seleccionadas formateadas (solo disponibles):', categoriasSeleccionadasFormateadas)
          console.log('📊 Categorías disponibles para comparar:', categorias)
          
          setCategoriasSeleccionadas(categoriasSeleccionadasFormateadas)
          console.log('✅ Categorías seleccionadas cargadas desde la DB (solo disponibles):', categoriasSeleccionadasFormateadas)
        } else {
          console.log('ℹ️ No hay categorías guardadas para esta política - limpiando estado')
          setCategoriasSeleccionadas([])
        }
      } else {
        console.log('ℹ️ Ya hay categorías seleccionadas en el estado del padre - manteniendo estado actual')
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
    console.log('🔍 handleCategoriaToggle - Categoría:', categoria);
    console.log('🔍 handleCategoriaToggle - Estado actual:', categoriasSeleccionadas);
    
    setCategoriasSeleccionadas(prev => {
      // Verificar si está seleccionada considerando tanto strings como objetos
      const isSelected = prev.some(c => {
        if (typeof c === 'string') {
          return c === categoria.nombre;
        } else {
          return c.id === categoria.id;
        }
      });
      console.log('🔍 handleCategoriaToggle - ¿Está seleccionada?', isSelected);
      
      let newState;
      if (isSelected) {
        // Remover tanto si es string como si es objeto
        newState = prev.filter(c => {
          if (typeof c === 'string') {
            return c !== categoria.nombre;
          } else {
            return c.id !== categoria.id;
          }
        });
        console.log('🔍 handleCategoriaToggle - Removiendo categoría');
      } else {
        newState = [...prev, categoria];
        console.log('🔍 handleCategoriaToggle - Agregando categoría');
      }
      
      console.log('🔍 handleCategoriaToggle - Nuevo estado:', newState);
      return newState;
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


      {/* Nuevo diseño mejorado */}
      <div className="space-y-6">
        {/* Header con información */}
        <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-6 border border-blue-200">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">Configuración de Orden de Asignación</h3>
              <p className="text-gray-600">Selecciona las categorías musicales que se utilizarán en la programación</p>
            </div>
            <div className="text-right">
              <div className="text-2xl font-bold text-blue-600">{categoriasDisponibles.length}</div>
              <div className="text-sm text-gray-600">Categorías disponibles</div>
            </div>
          </div>
        </div>

        {/* Panel de categorías mejorado */}
        <div className="bg-white rounded-xl border border-gray-200 shadow-sm">
          <div className="p-6 border-b border-gray-200">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="p-2 bg-green-100 rounded-lg">
                  <Tag className="w-5 h-5 text-green-600" />
                </div>
                <div>
                  <h4 className="text-lg font-semibold text-gray-900">Categorías Musicales</h4>
                  <p className="text-sm text-gray-600">Selecciona las categorías que deseas incluir</p>
                </div>
              </div>
              <div className="flex items-center space-x-4">
                <div className="text-center">
                  <div className="text-2xl font-bold text-green-600">{categoriasSeleccionadas.length}</div>
                  <div className="text-xs text-gray-600">Seleccionadas</div>
                </div>
                <button
                  onClick={() => setCategoriasSeleccionadas([])}
                  className="px-3 py-1 text-xs bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors"
                >
                  Limpiar todo
                </button>
                <button
                  onClick={() => setCategoriasSeleccionadas([...categoriasDisponibles])}
                  className="px-3 py-1 text-xs bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-lg transition-colors"
                >
                  Seleccionar todo
                </button>
              </div>
            </div>
          </div>
          
          <div className="p-6">
            {loading ? (
              <div className="flex items-center justify-center py-12">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
                <span className="ml-3 text-gray-600">Cargando categorías...</span>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                {/* Mostrar categorías disponibles */}
                {categoriasDisponibles.map((categoria) => {
                  // Si categoriasSeleccionadas contiene strings, comparar por nombre
                  // Si contiene objetos, comparar por ID
                  const isSelected = categoriasSeleccionadas.some(c => {
                    if (typeof c === 'string') {
                      return c === categoria.nombre;
                    } else {
                      return c.id === categoria.id;
                    }
                  });
                  console.log(`🔍 Categoría ${categoria.nombre} (ID: ${categoria.id}) - ¿Está seleccionada?`, isSelected);
                  console.log(`🔍 categoriasSeleccionadas:`, categoriasSeleccionadas);
                  
                  return (
                    <button
                      key={categoria.id}
                      onClick={() => handleCategoriaToggle(categoria)}
                      className={`group relative p-4 rounded-xl border-2 transition-all duration-200 text-left hover:shadow-md ${
                        isSelected
                          ? 'border-green-500 bg-green-50 text-green-700 shadow-sm'
                          : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                      }`}
                    >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-3">
                        <div className={`w-3 h-3 rounded-full ${
                          isSelected
                            ? 'bg-green-500'
                            : 'bg-gray-300'
                        }`}></div>
                        <span className="font-medium text-sm">{categoria.nombre}</span>
                      </div>
                      {isSelected && (
                        <Check className="w-4 h-4 text-green-600" />
                      )}
                    </div>
                  </button>
                  );
                })}
                
                {/* Mostrar categorías seleccionadas que no están en disponibles (temporales) */}
                {categoriasSeleccionadas
                  .filter(cat => cat.temporal && !categoriasDisponibles.some(c => c.nombre === cat.nombre))
                  .map((categoria) => (
                    <button
                      key={categoria.id}
                      onClick={() => handleCategoriaToggle(categoria)}
                      className="group relative p-4 rounded-xl border-2 border-orange-500 bg-orange-50 text-orange-700 shadow-sm transition-all duration-200 text-left hover:shadow-md"
                    >
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-3">
                          <div className="w-3 h-3 rounded-full bg-orange-500"></div>
                          <span className="font-medium text-sm">{categoria.nombre}</span>
                          <span className="text-xs bg-orange-200 text-orange-800 px-2 py-1 rounded-full">
                            No disponible
                          </span>
                        </div>
                        <Check className="w-4 h-4 text-orange-600" />
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
            {/* Debug info */}
            <div className="text-xs text-gray-400 mt-1">
              Debug: {JSON.stringify(categoriasSeleccionadas.map(c => typeof c === 'string' ? c : c.nombre))}
            </div>
          </div>
        </div>
      </div>

    </div>
  )
}
