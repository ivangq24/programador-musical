'use client'

import { useState, useEffect, useMemo, useCallback } from 'react'
import { 
  Plus, 
  Edit, 
  Search, 
  Trash2, 
  Filter, 
  RefreshCw, 
  Download, 
  Printer, 
  Settings, 
  Home,
  ChevronDown,
  X,
  Music,
  User,
  Eye,
  MoreHorizontal,
  CheckCircle,
  AlertCircle,
  EyeOff
} from 'lucide-react'
import FormularioCancion from './FormularioCancion'
import { getCanciones, createCancion, updateCancion, deleteCancion, getCancionesStats } from '../../../../api/canciones/index'
import { getDifusoras } from '../../../../api/difusoras/index'

export default function SimpleMantenimientoCanciones() {
  const [canciones, setCanciones] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedDifusoras, setSelectedDifusoras] = useState([])
  const [selectedCategorias, setSelectedCategorias] = useState([])
  const [selectedClasificaciones, setSelectedClasificaciones] = useState(['Balada', 'Pop'])
  const [sortBy, setSortBy] = useState('titulo')
  const [sortOrder, setSortOrder] = useState('asc')
  const [showFilters, setShowFilters] = useState(false)
  const [showOnlyActive, setShowOnlyActive] = useState(false)
  const [stats, setStats] = useState({ total_canciones: 0, canciones_activas: 0, canciones_inactivas: 0 })
  const [selectedCanciones, setSelectedCanciones] = useState([])
  const [showBulkActions, setShowBulkActions] = useState(false)
  const [showFormulario, setShowFormulario] = useState(false)
  const [cancionEditando, setCancionEditando] = useState(null)
  const [modoConsulta, setModoConsulta] = useState(false)
  const [difusoras, setDifusoras] = useState([])
  const [categorias, setCategorias] = useState([])
  const [notification, setNotification] = useState(null)

  const clasificaciones = ['- NINGUNA -', 'Balada', 'Pop', 'Rock', 'Jazz', 'Salsa', 'Reggaeton']

  // Load all canciones from API - solo una vez al montar
  const loadCanciones = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      
      // Cargar canciones
      const cancionesResponse = await getCanciones()
      setCanciones(cancionesResponse.canciones || [])
      
      // Cargar difusoras
      const difusorasResponse = await getDifusoras({ activa: true })
      setDifusoras(difusorasResponse || [])
      
      // TODO: Cargar categorías reales
      setCategorias(['Pop', 'Rock', 'Balada', 'Jazz', 'Salsa', 'Reggaeton']) // Mock temporal
      
    } catch (err) {
      setError(err.message)
      setCanciones([])
    } finally {
      setLoading(false)
    }
  }, [])

  // Load stats from API
  const loadStats = useCallback(async () => {
    try {
      const statsResponse = await getCancionesStats()
      setStats(statsResponse)
    } catch (err) {
      // Fallback: usar calculatedStats
    }
  }, [])

  // Calcular stats memoizados desde canciones
  const calculatedStats = useMemo(() => {
    const activas = canciones.filter(c => c.activa).length
    const inactivas = canciones.filter(c => !c.activa).length
    return {
      total: canciones.length,
      activas,
      inactivas
    }
  }, [canciones])

  // Load canciones on component mount only
  useEffect(() => {
    loadCanciones()
  }, [loadCanciones])

  // Load stats solo una vez después de cargar las canciones iniciales
  useEffect(() => {
    if (canciones.length > 0 && stats.total_canciones === 0) {
      loadStats()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [canciones.length]) // Solo cuando se cargan las canciones iniciales

  // Show notification - memoizado
  const showNotification = useCallback((message, type = 'error') => {
    setNotification({ message, type })
  }, [])

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  const handleToggleActive = useCallback(() => {
    setShowOnlyActive(prev => !prev)
  }, [])

  const handleSort = (column) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')
    } else {
      setSortBy(column)
      setSortOrder('asc')
    }
  }

  const getSortIcon = (column) => {
    if (sortBy !== column) return <ChevronDown className="w-4 h-4" />
    return sortOrder === 'asc' ? '▲' : '▼'
  }

  const handleSelectCancion = (cancionId) => {
    setSelectedCanciones(prev => 
      prev.includes(cancionId) 
        ? prev.filter(id => id !== cancionId)
        : [...prev, cancionId]
    )
  }

  const handleSelectAll = () => {
    if (selectedCanciones.length === filteredCanciones.length) {
      setSelectedCanciones([])
    } else {
      setSelectedCanciones(filteredCanciones.map(c => c.id))
    }
  }

  // Filtrar canciones del lado del cliente - memoizado para evitar recálculos
  const filteredCanciones = useMemo(() => {
    let result = canciones

    // Filtrar por activas
    if (showOnlyActive) {
      result = result.filter(c => c.activa)
    }

    // Filtrar por búsqueda
    if (searchTerm.trim()) {
      const searchLower = searchTerm.toLowerCase().trim()
      result = result.filter(c => 
        c.titulo?.toLowerCase().includes(searchLower) ||
        c.artista?.toLowerCase().includes(searchLower) ||
        c.album?.toLowerCase().includes(searchLower)
      )
    }

    return result
  }, [canciones, showOnlyActive, searchTerm])

  const handleAddCancion = () => {
    setCancionEditando(null)
    setModoConsulta(false)
    setShowFormulario(true)
  }

  const handleCloseFormulario = () => {
    setShowFormulario(false)
    setCancionEditando(null)
    setModoConsulta(false)
  }

  const handleSaveCancion = useCallback(async (cancionData) => {
    try {
      setLoading(true)
      
      if (cancionEditando) {
        // Actualizar canción existente
        await updateCancion(cancionEditando.id, cancionData)
        showNotification('Canción actualizada correctamente', 'success')
        // Actualizar estado local
        setCanciones(prev => prev.map(c => 
          c.id === cancionEditando.id ? { ...c, ...cancionData } : c
        ))
      } else {
        // Crear nueva canción
        const newCancion = await createCancion(cancionData)
        showNotification('Canción creada correctamente', 'success')
        // Agregar al estado local
        setCanciones(prev => [...prev, newCancion])
      }
      
      setShowFormulario(false)
      setCancionEditando(null)
      setModoConsulta(false)
      
    } catch (error) {
      showNotification(`Error al guardar la canción: ${error.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }, [cancionEditando, showNotification])

  const handleEditCancion = () => {
    if (selectedCanciones.length === 1) {
      const cancion = canciones.find(c => c.id === selectedCanciones[0])
      if (cancion) {
        setCancionEditando(cancion)
        setModoConsulta(false)
        setShowFormulario(true)
      }
    } else if (selectedCanciones.length === 0) {
      alert('Por favor selecciona una canción para editar')
    } else {
      alert('Por favor selecciona solo una canción para editar')
    }
  }

  const handleViewCancion = (cancionId) => {
    const cancion = canciones.find(c => c.id === cancionId)
    if (cancion) {
      setCancionEditando(cancion)
      setModoConsulta(true)
      setShowFormulario(true)
    }
  }

  const handleEditCancionRow = (cancionId) => {
    const cancion = canciones.find(c => c.id === cancionId)
    if (cancion) {
      setCancionEditando(cancion)
      setModoConsulta(false)
      setShowFormulario(true)
    }
  }

  const handleDeleteCancion = useCallback(async (cancionId) => {
    const cancion = canciones.find(c => c.id === cancionId)
    if (!cancion) return
    
    if (window.confirm(`¿Está seguro de eliminar la canción "${cancion.titulo}"?`)) {
      try {
        await deleteCancion(cancionId)
        showNotification('Canción eliminada correctamente', 'success')
        // Actualizar estado local
        setCanciones(prev => prev.filter(c => c.id !== cancionId))
      } catch (err) {
        showNotification(`Error al eliminar la canción: ${err.message}`, 'error')
      }
    }
  }, [canciones, showNotification])

  const handleMoreOptions = (cancionId) => {
    const cancion = canciones.find(c => c.id === cancionId)
    if (cancion) {
      alert(`Más opciones para: ${cancion.titulo}`)
    }
  }

  if (loading && canciones.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center h-64 space-y-4">
        <div className="relative">
          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
        <div className="text-gray-600 font-medium">Cargando canciones...</div>
        <div className="text-sm text-gray-500">Esto puede tomar unos segundos</div>
      </div>
    )
  }

  return (
    <>
      {/* Notification Component - Outside main container to ensure it's always on top */}
      {notification && (
        <div className={`fixed top-4 right-4 z-[10000] p-4 rounded-xl shadow-2xl max-w-md transition-all duration-300 ${
          notification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-300 text-green-800'
            : 'bg-gradient-to-r from-blue-50 to-indigo-50 border-2 border-blue-300 text-blue-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <CheckCircle className="w-5 h-5 mr-2 text-green-600" />
              ) : (
                <AlertCircle className="w-5 h-5 mr-2 text-blue-600" />
              )}
              <span className="font-semibold">{notification.message}</span>
            </div>
            <button
              onClick={() => setNotification(null)}
              className="ml-4 text-gray-500 hover:text-gray-700 transition-colors"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
        {/* Fondo decorativo */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute top-0 left-1/4 w-96 h-96 bg-blue-200/20 rounded-full blur-3xl"></div>
          <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-blue-200/20 rounded-full blur-3xl"></div>
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-blue-200/10 rounded-full blur-2xl"></div>
        </div>

        <div className="relative z-10 p-6">
          <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
            {/* Enhanced Header */}
            <div className="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
              <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                    <Music className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Mantenimiento de Canciones</h1>
                    <p className="text-blue-100 text-sm">Gestiona tu biblioteca musical</p>
                  </div>
                </div>
              
                {/* Action Buttons */}
                <div className="flex flex-wrap gap-3">
                  <button
                    onClick={handleAddCancion}
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Plus className="w-5 h-5" />
                    <span>Nueva Canción</span>
                  </button>
                
                  <button
                    onClick={handleToggleActive}
                    className={`px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 ${
                      showOnlyActive 
                        ? 'bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white border border-white/30' 
                        : 'bg-white/10 hover:bg-white/20 backdrop-blur-sm text-white border border-white/20'
                    }`}
                  >
                    {showOnlyActive ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                    <span>{showOnlyActive ? 'Ver Todas' : 'Solo Activas'}</span>
                  </button>
                
                  <button
                    onClick={() => setShowFilters(!showFilters)}
                    className={`px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 ${
                      showFilters 
                        ? 'bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white border border-white/30' 
                        : 'bg-white/10 hover:bg-white/20 backdrop-blur-sm text-white border border-white/20'
                    }`}
                  >
                    <Filter className="w-5 h-5" />
                    <span>Filtrar</span>
                  </button>
                
                  <button
                    onClick={handleEditCancion}
                    disabled={selectedCanciones.length !== 1}
                    className={`px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 ${
                      selectedCanciones.length === 1
                        ? 'bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white border border-white/30'
                        : 'bg-white/5 backdrop-blur-sm text-white/50 border border-white/10 cursor-not-allowed'
                    }`}
                  >
                    <Edit className="w-5 h-5" />
                    <span>Editar</span>
                  </button>
                
                  <button
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Download className="w-5 h-5" />
                    <span>Exportar CSV</span>
                  </button>
                </div>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
            </div>

          {/* Enhanced Search and Stats */}
          <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
            <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
              <div className="relative max-w-lg flex-1">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Search className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  type="text"
                  placeholder="Buscar por título, artista o álbum..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="block w-full pl-12 pr-12 py-3.5 border-2 border-gray-300 rounded-xl leading-5 bg-white text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-md transition-all duration-200 hover:border-gray-400"
                />
                {searchTerm && (
                  <button
                    onClick={() => setSearchTerm('')}
                    className="absolute inset-y-0 right-0 pr-4 flex items-center hover:bg-gray-100 rounded-r-xl transition-colors"
                  >
                    <X className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                  </button>
                )}
              </div>
              
              {/* Enhanced Stats Cards - usar calculatedStats para mejor performance */}
              <div className="flex items-center gap-3">
                <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-blue-500 rounded-full animate-pulse shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-blue-800 font-bold text-sm">Activas</span>
                      <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.activas}</span>
                    </div>
                  </div>
                </div>
                <div className="bg-gradient-to-br from-gray-50 to-gray-100 border-2 border-gray-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-gray-500 rounded-full shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-gray-800 font-bold text-sm">Inactivas</span>
                      <span className="bg-gray-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.inactivas}</span>
                    </div>
                  </div>
                </div>
                <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-indigo-500 rounded-full shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-indigo-800 font-bold text-sm">Total</span>
                      <span className="bg-indigo-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.total}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Enhanced Filter Status */}
          {(showOnlyActive || searchTerm || error) && (
            <div className="px-8 py-4 bg-gradient-to-r from-blue-50 via-indigo-50 to-blue-50 border-b border-blue-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <Filter className="w-5 h-5 text-blue-600" />
                  <p className="text-blue-800 text-sm font-semibold">
                    {error ? 
                      `Error: ${error.message || error}` :
                      showOnlyActive && searchTerm ? 
                      `Mostrando canciones activas que coinciden con "${searchTerm}" (${filteredCanciones.length} de ${canciones.length})` :
                      showOnlyActive ? 
                      `Mostrando solo canciones activas (${filteredCanciones.length} de ${canciones.length})` :
                      `Mostrando canciones que coinciden con "${searchTerm}" (${filteredCanciones.length} de ${canciones.length})`
                    }
                  </p>
                </div>
                <button
                  onClick={() => {
                    setShowOnlyActive(false)
                    setSearchTerm('')
                    setError(null)
                  }}
                  className="text-blue-600 hover:text-blue-800 text-sm font-semibold hover:underline transition-colors flex items-center space-x-1 px-3 py-1.5 rounded-lg hover:bg-blue-100"
                >
                  <X className="w-4 h-4" />
                  <span>Limpiar filtros</span>
                </button>
              </div>
            </div>
          )}

          {/* Filters Section Moderna */}
          {showFilters && (
            <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Difusoras */}
              <div className="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl p-6 border border-blue-100">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-blue-500 rounded-lg">
                    <Music className="w-4 h-4 text-white" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900">Difusoras</h3>
                </div>
                <div className="max-h-40 overflow-y-auto space-y-2 filter-panel">
                  {difusoras.map((difusora) => (
                    <label key={difusora.id} className="flex items-center space-x-3 p-2 rounded-lg hover:bg-white/50 transition-colors cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedDifusoras.includes(difusora.id)}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setSelectedDifusoras([...selectedDifusoras, difusora.id])
                          } else {
                            setSelectedDifusoras(selectedDifusoras.filter(d => d !== difusora.id))
                          }
                        }}
                        className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500 focus:ring-2"
                      />
                      <span className="text-sm font-medium text-gray-700">{difusora.siglas} - {difusora.nombre}</span>
                      {selectedDifusoras.includes(difusora.id) && (
                        <CheckCircle className="w-4 h-4 text-blue-600" />
                      )}
                    </label>
                  ))}
                </div>
              </div>

              {/* Categorías */}
              <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-100">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-green-500 rounded-lg">
                    <Filter className="w-4 h-4 text-white" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900">Categorías</h3>
                </div>
                <div className="max-h-40 overflow-y-auto space-y-2 filter-panel">
                  {categorias.map((categoria) => (
                    <label key={categoria} className="flex items-center space-x-3 p-2 rounded-lg hover:bg-white/50 transition-colors cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedCategorias.includes(categoria)}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setSelectedCategorias([...selectedCategorias, categoria])
                          } else {
                            setSelectedCategorias(selectedCategorias.filter(c => c !== categoria))
                          }
                        }}
                        className="w-4 h-4 rounded border-gray-300 text-green-600 focus:ring-green-500 focus:ring-2"
                      />
                      <span className="text-sm font-medium text-gray-700">{categoria}</span>
                      {selectedCategorias.includes(categoria) && (
                        <CheckCircle className="w-4 h-4 text-green-600" />
                      )}
                    </label>
                  ))}
                </div>
              </div>

              {/* Clasificaciones */}
              <div className="bg-gradient-to-br from-indigo-50 to-blue-50 rounded-2xl p-6 border border-indigo-100">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-indigo-500 rounded-lg">
                    <Settings className="w-4 h-4 text-white" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900">Clasificaciones</h3>
                </div>
                <div className="max-h-40 overflow-y-auto space-y-2 filter-panel">
                  {clasificaciones.map((clasificacion) => (
                    <label key={clasificacion} className="flex items-center space-x-3 p-2 rounded-lg hover:bg-white/50 transition-colors cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedClasificaciones.includes(clasificacion)}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setSelectedClasificaciones([...selectedClasificaciones, clasificacion])
                          } else {
                            setSelectedClasificaciones(selectedClasificaciones.filter(c => c !== clasificacion))
                          }
                        }}
                        className="w-4 h-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 focus:ring-2"
                      />
                      <span className="text-sm font-medium text-gray-700">{clasificacion}</span>
                      {selectedClasificaciones.includes(clasificacion) && (
                        <CheckCircle className="w-4 h-4 text-indigo-600" />
                      )}
                    </label>
                  ))}
                </div>
              </div>
            </div>
          </div>
          )}

          {/* Enhanced Table */}
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    <input
                      type="checkbox"
                      checked={selectedCanciones.length === filteredCanciones.length && filteredCanciones.length > 0}
                      onChange={handleSelectAll}
                      className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('siglas')}>
                    <div className="flex items-center space-x-2">
                      <span>Siglas</span>
                      {getSortIcon('siglas')}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('categoria')}>
                    <div className="flex items-center space-x-2">
                      <span>Categoría</span>
                      {getSortIcon('categoria')}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('idMedia')}>
                    <div className="flex items-center space-x-2">
                      <span>IDMEDIA</span>
                      {getSortIcon('idMedia')}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('titulo')}>
                    <div className="flex items-center space-x-2">
                      <span>Título</span>
                      {getSortIcon('titulo')}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('interprete')}>
                    <div className="flex items-center space-x-2">
                      <span>Intérpretes</span>
                      {getSortIcon('interprete')}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-bold text-gray-700 uppercase tracking-wider w-48 sticky right-0 bg-gradient-to-r from-gray-100 to-gray-50 border-l-2 border-gray-300 shadow-lg">
                    Acciones
                  </th>
                </tr>
            </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredCanciones.map((cancion, index) => (
                  <tr 
                    key={cancion.id} 
                    onClick={() => handleSelectCancion(cancion.id)}
                    className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}
                  >
                    <td className="px-6 py-4" onClick={(e) => e.stopPropagation()}>
                      <input
                        type="checkbox"
                        checked={selectedCanciones.includes(cancion.id)}
                        onChange={() => handleSelectCancion(cancion.id)}
                        className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                      />
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-2">
                        <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg flex items-center justify-center">
                          <span className="text-white text-xs font-bold">XH</span>
                        </div>
                        <span className="text-sm font-medium text-gray-900">XHDQ</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-2">
                        <div className="w-2 h-2 bg-blue-400 rounded-full"></div>
                        <span className="text-sm text-gray-700">limbo</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-2">
                        <div className="w-8 h-8 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg flex items-center justify-center">
                          <span className="text-gray-600 text-xs font-mono">MKB</span>
                        </div>
                        <span className="text-sm font-mono text-gray-700">MKB00{cancion.id.toString().padStart(3, '0')}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center space-x-3">
                        <div className="p-2 bg-gradient-to-br from-blue-100 to-blue-200 rounded-lg group-hover:from-blue-200 group-hover:to-blue-300 transition-colors">
                          <Music className="w-4 h-4 text-blue-600" />
                        </div>
                        <div>
                          <div className="text-sm font-medium text-gray-900 group-hover:text-blue-700 transition-colors">
                            {cancion.titulo}
                          </div>
                          <div className="text-xs text-gray-500">
                            {cancion.duracion ? `${Math.floor(cancion.duracion / 60)}:${(cancion.duracion % 60).toString().padStart(2, '0')}` : '--:--'}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-3">
                        <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg group-hover:from-green-200 group-hover:to-green-300 transition-colors">
                          <User className="w-4 h-4 text-green-600" />
                        </div>
                        <span className="text-sm font-medium text-gray-700 group-hover:text-green-700 transition-colors">
                          {cancion.artista}
                        </span>
                      </div>
                    </td>
                    <td className={`px-6 py-4 whitespace-nowrap text-sm font-medium sticky right-0 border-l-2 border-gray-300 shadow-lg ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`} onClick={(e) => e.stopPropagation()}>
                      <div className="flex justify-center space-x-2">
                        <button
                          onClick={() => handleViewCancion(cancion.id)}
                          className="p-2.5 text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-blue-200"
                          title="Ver detalles de la canción"
                        >
                          <Eye className="w-5 h-5" />
                        </button>
                        <button
                          onClick={() => handleEditCancionRow(cancion.id)}
                          className="p-2.5 text-yellow-600 hover:text-yellow-800 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-yellow-200"
                          title="Editar canción"
                        >
                          <Edit className="w-5 h-5" />
                        </button>
                        <button
                          onClick={() => handleDeleteCancion(cancion.id)}
                          className="p-2.5 text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-red-200"
                          title="Eliminar canción"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          
          {/* Enhanced Empty State */}
          {filteredCanciones.length === 0 && !loading && (
            <div className="text-center py-20 px-6">
              <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
                <Music className="w-12 h-12 text-gray-400" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">
                {error ? 'Error al cargar canciones' :
                 searchTerm ? 'No se encontraron canciones' : 
                 showOnlyActive ? 'No hay canciones activas' : 
                 'No hay canciones registradas'}
              </h3>
              <p className="text-gray-600 mb-8 max-w-md mx-auto text-base">
                {error ? 
                  `Error: ${error.message || error}. Intenta recargar la página.` :
                  searchTerm ? 
                  `No se encontraron canciones que coincidan con "${searchTerm}". Intenta con otros términos de búsqueda.` : 
                  showOnlyActive ? 
                  'No hay canciones activas en el sistema. Puedes ver todas las canciones o crear una nueva.' : 
                  'Comienza agregando tu primera canción al sistema para gestionar tu biblioteca musical.'
                }
              </p>
              {!searchTerm && !showOnlyActive && !error && (
                <button
                  onClick={handleAddCancion}
                  className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold hover:shadow-xl transform hover:scale-105 hover:-translate-y-1 flex items-center space-x-2 mx-auto"
                >
                  <Plus className="w-5 h-5" />
                  <span>Crear primera canción</span>
                </button>
              )}
            </div>
          )}
          </div>
        </div>
      </div>

      {/* Formulario Modal */}
      {showFormulario && (
        <FormularioCancion
          isOpen={showFormulario}
          onClose={handleCloseFormulario}
          onSave={handleSaveCancion}
          cancionEditando={cancionEditando}
          modoConsulta={modoConsulta}
          difusoras={difusoras}
        />
      )}
    </>
  )
}
