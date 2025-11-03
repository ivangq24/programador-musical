'use client'

import { useState, useEffect } from 'react'
import {
  Check,
  Search,
  Tag,
  Music,
  CheckCircle2,
  Circle,
  X,
  RotateCcw,
  CheckSquare
} from 'lucide-react'
import { getCategoriasCanciones, guardarCategoriasPolitica, obtenerCategoriasPolitica } from '../../../../api/canciones/index'

export default function OrdenAsignacion({ onSave, onCancel, politicaId = 1, categoriasSeleccionadas, setCategoriasSeleccionadas }) {
  const [categoriasDisponibles, setCategoriasDisponibles] = useState([])
  const [loading, setLoading] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')

  // Cargar categorías disponibles
  useEffect(() => {
    loadCategorias()
  }, [])

  const loadCategorias = async () => {
    setLoading(true)
    try {
      console.log('🔍 Cargando categorías desde la API...')
      const response = await getCategoriasCanciones()
      console.log('📊 Respuesta completa de la API:', response)
      
      // Manejar diferentes formatos de respuesta: array directo, objeto con items, o objeto con categorias
      let categoriasArray = []
      if (Array.isArray(response)) {
        categoriasArray = response
      } else if (response?.items && Array.isArray(response.items)) {
        categoriasArray = response.items
      } else if (response?.categorias && Array.isArray(response.categorias)) {
        categoriasArray = response.categorias
      }
      
      console.log('📊 Categorías procesadas:', categoriasArray)
      
      // Si las categorías son objetos con nombre, usarlas directamente; si son strings, mapearlas
      const categorias = categoriasArray.map((item, index) => {
        if (typeof item === 'string') {
          return {
            id: index + 1,
            nombre: item,
            activa: true
          }
        } else {
          return {
            id: item.id || index + 1,
            nombre: item.nombre || item.name || '',
            activa: item.activa !== undefined ? item.activa : true
          }
        }
      })
      
      setCategoriasDisponibles(categorias)
      
      // Cargar categorías ya seleccionadas para esta política
      console.log('🔍 Cargando categorías guardadas para política ID:', politicaId)
      const categoriasGuardadas = await obtenerCategoriasPolitica(politicaId)
      console.log('📊 Categorías guardadas:', categoriasGuardadas)
      
      // Solo cargar desde la DB si no hay categorías seleccionadas en el estado del padre
      if (categoriasSeleccionadas.length === 0) {
        if (categoriasGuardadas.categorias && categoriasGuardadas.categorias.length > 0) {
          const categoriasSeleccionadasFormateadas = categoriasGuardadas.categorias
            .map(nombre => categorias.find(c => c.nombre === nombre))
            .filter(Boolean)
          
          setCategoriasSeleccionadas(categoriasSeleccionadasFormateadas)
          console.log('✅ Categorías seleccionadas cargadas desde la DB:', categoriasSeleccionadasFormateadas)
        } else {
          console.log('ℹ️ No hay categorías guardadas para esta política - limpiando estado')
          setCategoriasSeleccionadas([])
        }
      } else {
        console.log('ℹ️ Ya hay categorías seleccionadas en el estado del padre - manteniendo estado actual')
      }
    } catch (error) {
      console.error('Error loading categorías:', error)
      setCategoriasDisponibles([])
    } finally {
      setLoading(false)
    }
  }

  const handleCategoriaToggle = (categoria) => {
    setCategoriasSeleccionadas(prev => {
      const isSelected = prev.some(c => {
        if (typeof c === 'string') {
          return c === categoria.nombre;
        } else {
          return c.id === categoria.id;
        }
      });
      
      if (isSelected) {
        return prev.filter(c => {
          if (typeof c === 'string') {
            return c !== categoria.nombre;
          } else {
            return c.id !== categoria.id;
          }
        });
      } else {
        return [...prev, categoria];
      }
    })
  }

  const handleSelectAllCategories = () => {
    setCategoriasSeleccionadas([...categoriasDisponibles])
  }

  const handleDeselectAllCategories = () => {
    setCategoriasSeleccionadas([])
  }

  const handleSave = async () => {
    try {
      const categoriasNombres = categoriasSeleccionadas.map(c => typeof c === 'string' ? c : c.nombre)
      await guardarCategoriasPolitica(politicaId, categoriasNombres)
      console.log('Categorías guardadas exitosamente:', categoriasNombres)
      
      if (onSave) {
        const configuracion = {
          esquema: 'horas-categorias',
          categorias: categoriasSeleccionadas.map(c => ({ 
            id: typeof c === 'string' ? null : c.id, 
            nombre: typeof c === 'string' ? c : c.nombre 
          }))
        }
        onSave(configuracion)
      }
      return true
    } catch (error) {
      console.error('Error guardando categorías:', error)
      alert('Error al guardar las categorías. Inténtalo de nuevo.')
      return false
    }
  }

  // Filtrar categorías basado en el término de búsqueda
  const categoriasFiltradas = categoriasDisponibles.filter(categoria =>
    categoria.nombre.toLowerCase().includes(searchTerm.toLowerCase())
  )

  // Separar categorías seleccionadas y no seleccionadas
  const categoriasSeleccionadasList = categoriasFiltradas.filter(categoria => {
    return categoriasSeleccionadas.some(c => {
      if (typeof c === 'string') {
        return c === categoria.nombre;
      } else {
        return c.id === categoria.id;
      }
    })
  })

  const categoriasNoSeleccionadas = categoriasFiltradas.filter(categoria => {
    return !categoriasSeleccionadas.some(c => {
      if (typeof c === 'string') {
        return c === categoria.nombre;
      } else {
        return c.id === categoria.id;
      }
    })
  })

  return (
    <div className="space-y-6">
      {/* Header Section */}
      <div className="bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 rounded-2xl p-6 border border-blue-100 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-2xl font-bold text-gray-900 mb-2 flex items-center gap-2">
              <Music className="w-6 h-6 text-purple-600" />
              Configuración de Orden de Asignación
            </h3>
            <p className="text-gray-600 text-sm">
              Selecciona las categorías musicales que se utilizarán en la programación
            </p>
          </div>
          <div className="text-right bg-white rounded-xl px-4 py-3 shadow-sm border border-gray-200">
            <div className="text-3xl font-bold text-blue-600">{categoriasDisponibles.length}</div>
            <div className="text-xs text-gray-600 uppercase tracking-wide">Categorías disponibles</div>
          </div>
        </div>
      </div>

      {/* Main Panel */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
        {/* Panel Header */}
        <div className="bg-gradient-to-r from-green-50 to-emerald-50 px-6 py-5 border-b border-green-100">
          <div className="flex items-center justify-between flex-wrap gap-4">
            <div className="flex items-center space-x-3">
              <div className="p-2.5 bg-green-500 rounded-xl shadow-sm">
                <Tag className="w-5 h-5 text-white" />
              </div>
              <div>
                <h4 className="text-lg font-bold text-gray-900">Categorías Musicales</h4>
                <p className="text-sm text-gray-600 mt-0.5">Selecciona las categorías que deseas incluir</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="bg-white rounded-lg px-4 py-2 border border-green-200 shadow-sm">
                <div className="text-xl font-bold text-green-600 text-center">{categoriasSeleccionadas.length}</div>
                <div className="text-xs text-gray-600 uppercase tracking-wide">Seleccionadas</div>
              </div>
              <button
                onClick={handleDeselectAllCategories}
                className="px-4 py-2 text-sm font-medium bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-all duration-200 hover:shadow-md flex items-center gap-2 border border-gray-300"
              >
                <X className="w-4 h-4" />
                Limpiar todo
              </button>
              <button
                onClick={handleSelectAllCategories}
                className="px-4 py-2 text-sm font-medium bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-all duration-200 hover:shadow-md flex items-center gap-2 shadow-sm"
              >
                <CheckSquare className="w-4 h-4" />
                Seleccionar todo
              </button>
            </div>
          </div>
        </div>
        
        {/* Search Bar */}
        <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              type="text"
              placeholder="Buscar categorías..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
            />
          </div>
        </div>

        {/* Categories Grid */}
        <div className="p-6">
          {loading ? (
            <div className="flex items-center justify-center py-16">
              <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-green-600"></div>
              <span className="ml-4 text-gray-600 font-medium">Cargando categorías...</span>
            </div>
          ) : categoriasFiltradas.length === 0 ? (
            <div className="text-center py-16">
              <Search className="w-12 h-12 text-gray-300 mx-auto mb-3" />
              <p className="text-gray-600 font-medium">No se encontraron categorías</p>
              <p className="text-gray-500 text-sm mt-1">Intenta con otro término de búsqueda</p>
            </div>
          ) : (
            <div className="space-y-6">
              {/* Selected Categories Section */}
              {categoriasSeleccionadasList.length > 0 && (
                <div>
                  <div className="flex items-center gap-2 mb-4">
                    <CheckCircle2 className="w-5 h-5 text-green-500" />
                    <h5 className="font-semibold text-gray-900 text-sm uppercase tracking-wide">
                      Seleccionadas ({categoriasSeleccionadasList.length})
                    </h5>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
                    {categoriasSeleccionadasList.map((categoria) => (
                      <button
                        key={categoria.id}
                        onClick={() => handleCategoriaToggle(categoria)}
                        className="group relative p-4 rounded-xl border-2 border-green-500 bg-gradient-to-br from-green-50 to-emerald-50 text-green-700 shadow-sm transition-all duration-200 hover:shadow-md hover:scale-[1.02] transform"
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-3 flex-1 min-w-0">
                            <div className="flex-shrink-0 w-4 h-4 rounded-full bg-green-500 flex items-center justify-center">
                              <Check className="w-3 h-3 text-white" />
                            </div>
                            <span className="font-semibold text-sm truncate">{categoria.nombre}</span>
                          </div>
                          <CheckCircle2 className="w-5 h-5 text-green-600 flex-shrink-0 ml-2" />
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Available Categories Section */}
              {categoriasNoSeleccionadas.length > 0 && (
                <div>
                  <div className="flex items-center gap-2 mb-4">
                    <Circle className="w-5 h-5 text-gray-400" />
                    <h5 className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
                      Disponibles ({categoriasNoSeleccionadas.length})
                    </h5>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
                    {categoriasNoSeleccionadas.map((categoria) => (
                      <button
                        key={categoria.id}
                        onClick={() => handleCategoriaToggle(categoria)}
                        className="group relative p-4 rounded-xl border-2 border-gray-200 bg-white text-gray-700 hover:border-gray-300 hover:bg-gray-50 transition-all duration-200 hover:shadow-md hover:scale-[1.02] transform"
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-3 flex-1 min-w-0">
                            <div className="flex-shrink-0 w-4 h-4 rounded-full bg-gray-300 border-2 border-gray-400"></div>
                            <span className="font-medium text-sm truncate">{categoria.nombre}</span>
                          </div>
                          <Circle className="w-5 h-5 text-gray-400 flex-shrink-0 ml-2 opacity-0 group-hover:opacity-100 transition-opacity" />
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Empty State */}
              {categoriasSeleccionadasList.length === 0 && categoriasNoSeleccionadas.length === 0 && (
                <div className="text-center py-12">
                  <Music className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-600 font-medium text-lg">No hay categorías para mostrar</p>
                  <p className="text-gray-500 text-sm mt-2">Las categorías aparecerán aquí cuando estén disponibles</p>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Summary Footer */}
      <div className="bg-gradient-to-r from-purple-50 via-blue-50 to-indigo-50 rounded-xl border border-purple-200 p-6 shadow-sm">
        <div className="flex items-center justify-between flex-wrap gap-4">
          <div className="flex items-center gap-6">
            <div className="text-center">
              <div className="text-3xl font-bold text-purple-600">{categoriasSeleccionadas.length}</div>
              <div className="text-xs text-gray-600 uppercase tracking-wide mt-1">Categorías seleccionadas</div>
            </div>
            <div className="h-12 w-px bg-gray-300"></div>
            <div className="text-center">
              <div className="text-3xl font-bold text-blue-600">{categoriasDisponibles.length - categoriasSeleccionadas.length}</div>
              <div className="text-xs text-gray-600 uppercase tracking-wide mt-1">Disponibles</div>
            </div>
          </div>
          <div className="flex items-center gap-3">
            {categoriasSeleccionadas.length === 0 && (
              <div className="text-sm text-amber-600 bg-amber-50 px-4 py-2 rounded-lg border border-amber-200 flex items-center gap-2">
                <Tag className="w-4 h-4" />
                <span>Selecciona al menos una categoría para continuar</span>
              </div>
            )}
            {categoriasSeleccionadas.length > 0 && (
              <div className="text-sm text-green-600 bg-green-50 px-4 py-2 rounded-lg border border-green-200 flex items-center gap-2">
                <CheckCircle2 className="w-4 h-4" />
                <span>Listo para guardar</span>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}