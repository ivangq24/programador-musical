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
  Calendar,
  Clock,
  Eye,
  MoreHorizontal,
  CheckCircle,
  AlertCircle
} from 'lucide-react'
import { getCanciones, getCancionesStats } from '../../../../api/canciones/index'

export default function MantenimientoCanciones() {
  // Estados principales - cargar todas una vez, filtrar del lado del cliente
  const [canciones, setCanciones] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedDifusoras, setSelectedDifusoras] = useState(['XHDQ'])
  const [selectedCategorias, setSelectedCategorias] = useState([])
  const [selectedClasificaciones, setSelectedClasificaciones] = useState(['Balada', 'Pop'])
  const [sortBy, setSortBy] = useState('titulo')
  const [sortOrder, setSortOrder] = useState('asc')
  const [showFilters, setShowFilters] = useState(false)
  const [stats, setStats] = useState({ total_canciones: 0, canciones_activas: 0, canciones_inactivas: 0 })
  const [selectedCanciones, setSelectedCanciones] = useState([])
  const [showBulkActions, setShowBulkActions] = useState(false)
  const [notification, setNotification] = useState(null)

  const difusoras = ['XHDQ', 'XHCAT', 'XHGR', 'XHOZ', 'XHPER']
  const categorias = ['100buni XHDQ', 'AMBIENTE XHDQ', 'ANIVERSAR XHDQ', 'IO', 'BARRILITO XHDO']
  const clasificaciones = ['- NINGUNA -', 'Balada', 'Pop', 'Rock', 'Jazz', 'Salsa', 'Reggaeton']

  // Load all canciones from API - solo una vez al montar
  const loadCanciones = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      
      // Cargar todas las canciones sin filtros - filtrar del lado del cliente
      const params = {
        limit: 1000 // Aumentar límite para cargar más canciones
      }
      
      const response = await getCanciones(params)
      setCanciones(response.canciones || [])
      
      // Cargar estadísticas solo una vez
      try {
        const statsResponse = await getCancionesStats()
        setStats(statsResponse)
      } catch (statsErr) {

        // Usar calculatedStats como fallback
      }
      
    } catch (err) {

      setError('Error al cargar las canciones')
      setCanciones([])
    } finally {
      setLoading(false)
    }
  }, [])

  // Calcular stats memoizados desde canciones
  const calculatedStats = useMemo(() => {
    return {
      total_canciones: canciones.length,
      canciones_activas: canciones.filter(c => c.activo !== false).length,
      canciones_inactivas: canciones.filter(c => c.activo === false).length
    }
  }, [canciones])

  // Filtrar y ordenar canciones del lado del cliente - memoizado
  const filteredCanciones = useMemo(() => {
    let result = [...canciones]

    // Filtrar por búsqueda
    if (searchTerm.trim()) {
      const searchLower = searchTerm.toLowerCase().trim()
      result = result.filter(cancion => 
        cancion.titulo?.toLowerCase().includes(searchLower) ||
        cancion.artista?.toLowerCase().includes(searchLower) ||
        cancion.interprete?.toLowerCase().includes(searchLower)
      )
    }

    // Filtrar por difusoras (si se implementa)
    if (selectedDifusoras.length > 0 && selectedDifusoras[0] !== 'XHDQ') {
      result = result.filter(cancion => 
        selectedDifusoras.includes(cancion.siglas || 'XHDQ')
      )
    }

    // Ordenar
    result.sort((a, b) => {
      let aValue, bValue
      
      switch (sortBy) {
        case 'siglas':
          aValue = a.siglas || 'XHDQ'
          bValue = b.siglas || 'XHDQ'
          break
        case 'categoria':
          aValue = a.categoria || 'limbo'
          bValue = b.categoria || 'limbo'
          break
        case 'idMedia':
          aValue = a.idMedia || `MKB00${(a.id || 0).toString().padStart(3, '0')}`
          bValue = b.idMedia || `MKB00${(b.id || 0).toString().padStart(3, '0')}`
          break
        case 'titulo':
          aValue = a.titulo || ''
          bValue = b.titulo || ''
          break
        case 'interprete':
          aValue = a.interprete || a.artista || ''
          bValue = b.interprete || b.artista || ''
          break
        default:
          aValue = a.titulo || ''
          bValue = b.titulo || ''
      }
      
      if (typeof aValue === 'string' && typeof bValue === 'string') {
        return sortOrder === 'asc' 
          ? aValue.localeCompare(bValue)
          : bValue.localeCompare(aValue)
      }
      
      return sortOrder === 'asc' 
        ? (aValue > bValue ? 1 : -1)
        : (bValue > aValue ? 1 : -1)
    })

    return result
  }, [canciones, searchTerm, selectedDifusoras, sortBy, sortOrder])

  // Load canciones on component mount only
  useEffect(() => {
    loadCanciones()
  }, [loadCanciones])

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  // Handlers memoizados para evitar recreaciones
  const handleSearch = useCallback(() => {
    // La búsqueda ahora es del lado del cliente, no necesita recargar
    // Solo para mantener compatibilidad con el código existente
  }, [])

  const handleClear = useCallback(() => {
    setSearchTerm('')
    setError(null)
  }, [])

  const handleRefresh = useCallback(() => {
    loadCanciones()
  }, [loadCanciones])

  const handleSort = useCallback((column) => {
    setSortBy(prevSortBy => {
      if (prevSortBy === column) {
        setSortOrder(prevOrder => prevOrder === 'asc' ? 'desc' : 'asc')
        return column
      } else {
        setSortOrder('asc')
        return column
      }
    })
  }, [])

  const getSortIcon = useCallback((column) => {
    if (sortBy !== column) return <ChevronDown className="w-4 h-4" />
    return sortOrder === 'asc' ? '▲' : '▼'
  }, [sortBy, sortOrder])

  const handleSelectCancion = useCallback((cancionId) => {
    setSelectedCanciones(prev => 
      prev.includes(cancionId) 
        ? prev.filter(id => id !== cancionId)
        : [...prev, cancionId]
    )
  }, [])

  const handleSelectAll = useCallback(() => {
    setSelectedCanciones(prev => {
      if (prev.length === filteredCanciones.length && filteredCanciones.length > 0) {
        return []
      } else {
        return filteredCanciones.map(c => c.id)
      }
    })
  }, [filteredCanciones])

  const handleBulkAction = useCallback((action) => {

    // TODO: Implementar acciones en lote
  }, [selectedCanciones.length])

  const handleClearFilters = useCallback(() => {
    setSearchTerm('')
    setError(null)
  }, [])

  const showNotification = useCallback((message, type = 'error') => {
    setNotification({ message, type })
  }, [])

  return (
    <>
      {/* Notification Component */}
      {notification && (
        <div className={`fixed top-4 right-4 z-[10000] p-4 rounded-xl shadow-2xl max-w-md transition-all duration-300 ${
otification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-300 text-green-800'
            : 'bg-gradient-to-r from-red-50 to-pink-50 border-2 border-red-300 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <CheckCircle className="w-5 h-5 mr-2 text-green-600" />
              ) : (
                <AlertCircle className="w-5 h-5 mr-2 text-red-600" />
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
          <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-indigo-200/20 rounded-full blur-3xl"></div>
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
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Plus className="w-5 h-5" />
                    <span>Nueva Canción</span>
                  </button>
                  
                  <button
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Download className="w-5 h-5" />
                    <span>Exportar</span>
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
                    placeholder="Buscar por título o artista..."
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
                
                {/* Enhanced Stats Cards */}
                <div className="flex items-center gap-3">
                  <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex items-center space-x-3">
                      <div className="w-4 h-4 bg-blue-500 rounded-full animate-pulse shadow-md"></div>
                      <div className="flex flex-col">
                        <span className="text-blue-800 font-bold text-sm">Activas</span>
                        <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.canciones_activas}</span>
                      </div>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-red-50 to-red-100 border-2 border-red-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex items-center space-x-3">
                      <div className="w-4 h-4 bg-red-500 rounded-full shadow-md"></div>
                      <div className="flex flex-col">
                        <span className="text-red-800 font-bold text-sm">Inactivas</span>
                        <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.canciones_inactivas}</span>
                      </div>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex items-center space-x-3">
                      <div className="w-4 h-4 bg-indigo-500 rounded-full shadow-md"></div>
                      <div className="flex flex-col">
                        <span className="text-indigo-800 font-bold text-sm">Total</span>
                        <span className="bg-indigo-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.total_canciones}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Enhanced Filter Status */}
            {(searchTerm || error) && (
              <div className="px-8 py-4 bg-gradient-to-r from-blue-50 via-indigo-50 to-blue-50 border-b border-blue-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <Filter className="w-5 h-5 text-blue-600" />
                    <p className="text-blue-800 text-sm font-semibold">
                      {error ? 
                        `Error: ${error.message || error}` :
                        searchTerm ? 
                        `Mostrando canciones que coinciden con "${searchTerm}" (${filteredCanciones.length} de ${canciones.length})` :
                        ''
                      }
                    </p>
                  </div>
                  <button
                    onClick={handleClearFilters}
                    className="text-blue-600 hover:text-blue-800 text-sm font-semibold hover:underline transition-colors flex items-center space-x-1 px-3 py-1.5 rounded-lg hover:bg-blue-100"
                  >
                    <X className="w-4 h-4" />
                    <span>Limpiar filtros</span>
                  </button>
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
                        className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500 focus:ring-2 cursor-pointer"
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
                        <span>IdMedia</span>
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
                    <tr key={cancion.id} className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <input
                          type="checkbox"
                          checked={selectedCanciones.includes(cancion.id)}
                          onChange={() => handleSelectCancion(cancion.id)}
                          className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500 focus:ring-2 cursor-pointer"
                          onClick={(e) => e.stopPropagation()}
                        />
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        {cancion.siglas || 'XHDQ'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        {cancion.categoria || 'limbo'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-mono text-gray-700">
                        {cancion.idMedia || `MKB00${cancion.id.toString().padStart(3, '0')}`}
                      </td>
                      <td className="px-6 py-4 text-sm font-medium text-gray-900">
                        <div className="max-w-64 truncate group-hover:text-blue-700 transition-colors" title={cancion.titulo}>
                          {cancion.titulo}
                        </div>
                        <div className="text-xs text-gray-500 mt-1">
                          {cancion.duracion ? `${Math.floor(cancion.duracion / 60)}:${(cancion.duracion % 60).toString().padStart(2, '0')}` : '--:--'}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        <div className="max-w-48 truncate" title={cancion.artista || cancion.interprete}>
                          {cancion.artista || cancion.interprete}
                        </div>
                      </td>
                      <td className={`px-6 py-4 whitespace-nowrap text-sm font-medium sticky right-0 border-l-2 border-gray-300 shadow-lg ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                        <div className="flex justify-center space-x-2">
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                            }}
                            className="p-2.5 text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-blue-200"
                            title="Ver detalles"
                          >
                            <Eye className="w-5 h-5" />
                          </button>
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                            }}
                            className="p-2.5 text-yellow-600 hover:text-yellow-800 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-yellow-200"
                            title="Editar"
                          >
                            <Edit className="w-5 h-5" />
                          </button>
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                            }}
                            className="p-2.5 text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-red-200"
                            title="Eliminar"
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
                   'No hay canciones registradas'}
                </h3>
                <p className="text-gray-600 mb-8 max-w-md mx-auto text-base">
                  {error ? 
                    `Error: ${error.message || error}. Intenta recargar la página.` :
                    searchTerm ? 
                    `No se encontraron canciones que coincidan con "${searchTerm}". Intenta con otros términos de búsqueda.` : 
                    'Comienza agregando tu primera canción al sistema para gestionar tu biblioteca musical.'
                  }
                </p>
                {!searchTerm && !error && (
                  <button
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
    </>
  )
}

