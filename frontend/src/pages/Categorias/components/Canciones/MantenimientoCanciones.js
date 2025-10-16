'use client'

import { useState, useEffect } from 'react'
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
import { getCanciones, getCancionesStats } from '../../../../api/canciones'

export default function MantenimientoCanciones() {
  const [canciones, setCanciones] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedDifusoras, setSelectedDifusoras] = useState(['XHDQ'])
  const [selectedCategorias, setSelectedCategorias] = useState([])
  const [selectedClasificaciones, setSelectedClasificaciones] = useState(['Balada', 'Pop'])
  const [sortBy, setSortBy] = useState('titulo')
  const [sortOrder, setSortOrder] = useState('asc')
  const [showFilters, setShowFilters] = useState(true)
  const [stats, setStats] = useState({ total_canciones: 0, canciones_activas: 0, canciones_inactivas: 0 })
  const [selectedCanciones, setSelectedCanciones] = useState([])
  const [showBulkActions, setShowBulkActions] = useState(false)

  const difusoras = ['XHDQ', 'XHCAT', 'XHGR', 'XHOZ', 'XHPER']
  const categorias = ['100buni XHDQ', 'AMBIENTE XHDQ', 'ANIVERSAR XHDQ', 'IO', 'BARRILITO XHDO']
  const clasificaciones = ['- NINGUNA -', 'Balada', 'Pop', 'Rock', 'Jazz', 'Salsa', 'Reggaeton']

  const loadCanciones = async () => {
    try {
      setLoading(true)
      setError(null)
      
      const params = {
        search: searchTerm || undefined,
        limit: 100
      }
      
      const response = await getCanciones(params)
      setCanciones(response.canciones || [])
      
      // Cargar estadísticas
      const statsResponse = await getCancionesStats()
      setStats(statsResponse)
      
    } catch (err) {
      console.error('Error cargando canciones:', err)
      setError('Error al cargar las canciones')
      setCanciones([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadCanciones()
  }, [])

  useEffect(() => {
    // Debounce search
    const timeoutId = setTimeout(() => {
      if (searchTerm !== '') {
        loadCanciones()
      }
    }, 500)
    
    return () => clearTimeout(timeoutId)
  }, [searchTerm])

  const handleSearch = () => {
    loadCanciones()
  }

  const handleClear = () => {
    setSearchTerm('')
    loadCanciones()
  }

  const handleRefresh = () => {
    loadCanciones()
  }

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

  const handleBulkAction = (action) => {
    console.log(`Bulk action: ${action} on ${selectedCanciones.length} canciones`)
    // TODO: Implementar acciones en lote
  }

  const filteredCanciones = canciones.filter(cancion => {
    const matchesSearch = searchTerm === '' || 
                         cancion.titulo.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         cancion.artista.toLowerCase().includes(searchTerm.toLowerCase())
    
    return matchesSearch
  })

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100">
      {/* Header Moderno */}
      <div className="bg-white/80 backdrop-blur-sm shadow-lg border-b border-gray-200/50 sticky top-0 z-10">
        <div className="px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="p-3 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl shadow-lg">
                <Music className="w-7 h-7 text-white" />
              </div>
              <div>
                <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                  Mantenimiento de Canciones
                </h1>
                <p className="text-gray-600 text-lg">Gestiona tu biblioteca musical</p>
              </div>
            </div>
            <div className="flex items-center space-x-6">
              <div className="text-right">
                <div className="text-2xl font-bold text-gray-900">
                  {loading ? '...' : filteredCanciones.length}
                </div>
                <div className="text-sm text-gray-500">canciones encontradas</div>
              </div>
              {stats.total_canciones > 0 && (
                <div className="text-right">
                  <div className="text-sm text-gray-500">
                    Total: <span className="font-semibold text-gray-900">{stats.total_canciones}</span>
                  </div>
                  <div className="text-sm text-gray-500">
                    Activas: <span className="font-semibold text-green-600">{stats.canciones_activas}</span>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Action Ribbon Moderno */}
      <div className="bg-white/90 backdrop-blur-sm shadow-sm border-b border-gray-200/50">
        <div className="px-6 py-4">
          <div className="flex items-center justify-between">
            {/* Acciones Principales */}
            <div className="flex items-center space-x-2">
              <div className="flex items-center space-x-1 bg-gray-50 rounded-xl p-1">
                <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-green-500 hover:bg-green-600 text-white transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                  <Plus className="w-4 h-4" />
                  <span className="text-sm font-medium">Añadir</span>
                </button>
                <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-blue-500 hover:bg-blue-600 text-white transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                  <Edit className="w-4 h-4" />
                  <span className="text-sm font-medium">Editar</span>
                </button>
                <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-purple-500 hover:bg-purple-600 text-white transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                  <Eye className="w-4 h-4" />
                  <span className="text-sm font-medium">Consultar</span>
                </button>
                <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-red-500 hover:bg-red-600 text-white transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                  <Trash2 className="w-4 h-4" />
                  <span className="text-sm font-medium">Eliminar</span>
                </button>
              </div>
            </div>

            {/* Acciones Secundarias */}
            <div className="flex items-center space-x-2">
              <button 
                onClick={() => setShowFilters(!showFilters)}
                className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all duration-200 ${
                  showFilters 
                    ? 'bg-yellow-500 text-white shadow-md' 
                    : 'bg-gray-100 hover:bg-yellow-100 text-gray-700'
                }`}
              >
                <Filter className="w-4 h-4" />
                <span className="text-sm font-medium">Filtrar</span>
              </button>
              
              <button 
                onClick={handleRefresh}
                disabled={loading}
                className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition-all duration-200 disabled:opacity-50"
              >
                <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
                <span className="text-sm font-medium">Actualizar</span>
              </button>
              
              <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition-all duration-200">
                <Download className="w-4 h-4" />
                <span className="text-sm font-medium">Exportar</span>
              </button>
              
              <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition-all duration-200">
                <Printer className="w-4 h-4" />
                <span className="text-sm font-medium">Imprimir</span>
              </button>
            </div>

            {/* Acciones Varias */}
            <div className="flex items-center space-x-2">
              <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition-all duration-200">
                <Settings className="w-4 h-4" />
                <span className="text-sm font-medium">Opciones</span>
              </button>
              
              <button className="flex items-center space-x-2 px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 transition-all duration-200">
                <Home className="w-4 h-4" />
                <span className="text-sm font-medium">Salir</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Filters Section Moderna */}
      {showFilters && (
        <div className="bg-white/95 backdrop-blur-sm shadow-lg border-b border-gray-200/50">
          <div className="px-6 py-6">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Difusoras */}
              <div className="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl p-6 border border-blue-100">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-blue-500 rounded-lg">
                    <Music className="w-4 h-4 text-white" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900">Difusoras</h3>
                </div>
                <div className="max-h-40 overflow-y-auto space-y-2">
                  {difusoras.map((difusora) => (
                    <label key={difusora} className="flex items-center space-x-3 p-2 rounded-lg hover:bg-white/50 transition-colors cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedDifusoras.includes(difusora)}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setSelectedDifusoras([...selectedDifusoras, difusora])
                          } else {
                            setSelectedDifusoras(selectedDifusoras.filter(d => d !== difusora))
                          }
                        }}
                        className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500 focus:ring-2"
                      />
                      <span className="text-sm font-medium text-gray-700">{difusora}</span>
                      {selectedDifusoras.includes(difusora) && (
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
                <div className="max-h-40 overflow-y-auto space-y-2">
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
              <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-100">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-purple-500 rounded-lg">
                    <Settings className="w-4 h-4 text-white" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900">Clasificaciones</h3>
                </div>
                <div className="max-h-40 overflow-y-auto space-y-2">
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
                        className="w-4 h-4 rounded border-gray-300 text-purple-600 focus:ring-purple-500 focus:ring-2"
                      />
                      <span className="text-sm font-medium text-gray-700">{clasificacion}</span>
                      {selectedClasificaciones.includes(clasificacion) && (
                        <CheckCircle className="w-4 h-4 text-purple-600" />
                      )}
                    </label>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Search Bar Moderna */}
      <div className="bg-white/95 backdrop-blur-sm shadow-lg border-b border-gray-200/50">
        <div className="px-6 py-6">
          <div className="flex items-center space-x-4">
            <div className="flex-1 relative">
              <div className="relative">
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Buscar canciones por título o artista..."
                  className="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-2xl focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all duration-200 text-lg shadow-lg hover:shadow-xl"
                />
                <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                {searchTerm && (
                  <button
                    onClick={handleClear}
                    className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors"
                  >
                    <X className="w-5 h-5" />
                  </button>
                )}
              </div>
            </div>
            <button
              onClick={handleSearch}
              className="px-6 py-4 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-2xl hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 font-medium"
            >
              Buscar
            </button>
            <button
              onClick={handleClear}
              className="px-6 py-4 bg-gradient-to-r from-gray-100 to-gray-200 text-gray-700 rounded-2xl hover:from-gray-200 hover:to-gray-300 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 font-medium"
            >
              Limpiar
            </button>
          </div>
        </div>
      </div>

      {/* Data Table Moderna */}
      <div className="bg-white/95 backdrop-blur-sm shadow-xl rounded-2xl mx-6 my-6 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full">
            <thead className="bg-gradient-to-r from-gray-50 to-gray-100">
              <tr>
                <th className="px-6 py-4 text-left">
                  <input
                    type="checkbox"
                    checked={selectedCanciones.length === filteredCanciones.length && filteredCanciones.length > 0}
                    onChange={handleSelectAll}
                    className="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  />
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('siglas')}>
                  <div className="flex items-center space-x-2">
                    <span>Siglas</span>
                    {getSortIcon('siglas')}
                  </div>
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('categoria')}>
                  <div className="flex items-center space-x-2">
                    <span>Categoría</span>
                    {getSortIcon('categoria')}
                  </div>
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('idMedia')}>
                  <div className="flex items-center space-x-2">
                    <span>IdMedia</span>
                    {getSortIcon('idMedia')}
                  </div>
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('titulo')}>
                  <div className="flex items-center space-x-2">
                    <span>▲ Título</span>
                    {getSortIcon('titulo')}
                  </div>
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors" onClick={() => handleSort('interprete')}>
                  <div className="flex items-center space-x-2">
                    <span>Intérpretes</span>
                    {getSortIcon('interprete')}
                  </div>
                </th>
                <th className="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider">
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-100">
              {loading ? (
                <tr>
                  <td colSpan="7" className="px-6 py-12 text-center">
                    <div className="flex flex-col items-center justify-center space-y-4">
                      <div className="p-4 bg-blue-100 rounded-full">
                        <RefreshCw className="w-8 h-8 text-blue-600 animate-spin" />
                      </div>
                      <div className="text-lg font-medium text-gray-700">Cargando canciones...</div>
                      <div className="text-sm text-gray-500">Obteniendo datos de la base de datos</div>
                    </div>
                  </td>
                </tr>
              ) : error ? (
                <tr>
                  <td colSpan="7" className="px-6 py-12 text-center">
                    <div className="flex flex-col items-center justify-center space-y-4">
                      <div className="p-4 bg-red-100 rounded-full">
                        <AlertCircle className="w-8 h-8 text-red-600" />
                      </div>
                      <div className="text-lg font-medium text-red-700">Error al cargar canciones</div>
                      <div className="text-sm text-red-500">{error}</div>
                    </div>
                  </td>
                </tr>
              ) : filteredCanciones.length === 0 ? (
                <tr>
                  <td colSpan="7" className="px-6 py-12 text-center">
                    <div className="flex flex-col items-center justify-center space-y-4">
                      <div className="p-4 bg-gray-100 rounded-full">
                        <Music className="w-8 h-8 text-gray-400" />
                      </div>
                      <div className="text-lg font-medium text-gray-700">No se encontraron canciones</div>
                      <div className="text-sm text-gray-500">Intenta ajustar los filtros o la búsqueda</div>
                    </div>
                  </td>
                </tr>
              ) : (
                filteredCanciones.map((cancion, index) => (
                  <tr key={cancion.id} className={`hover:bg-gradient-to-r hover:from-blue-50 hover:to-indigo-50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                    <td className="px-6 py-4">
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
                        <div className="w-2 h-2 bg-orange-400 rounded-full"></div>
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
                        <div className="p-2 bg-gradient-to-br from-purple-100 to-purple-200 rounded-lg group-hover:from-purple-200 group-hover:to-purple-300 transition-colors">
                          <Music className="w-4 h-4 text-purple-600" />
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
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-2">
                        <button className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors">
                          <Eye className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-gray-400 hover:text-green-600 hover:bg-green-50 rounded-lg transition-colors">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors">
                          <Trash2 className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-50 rounded-lg transition-colors">
                          <MoreHorizontal className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Footer Moderno */}
      <div className="bg-white/95 backdrop-blur-sm border-t border-gray-200/50 shadow-lg">
        <div className="px-6 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-6">
              <div className="text-sm text-gray-600">
                <span className="font-semibold text-gray-900">{filteredCanciones.length}</span> de <span className="font-semibold text-gray-900">{canciones.length}</span> canciones
              </div>
              {selectedCanciones.length > 0 && (
                <div className="flex items-center space-x-2">
                  <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                  <span className="text-sm font-medium text-blue-700">
                    {selectedCanciones.length} seleccionadas
                  </span>
                </div>
              )}
            </div>
            <div className="flex items-center space-x-4">
              <button className="px-4 py-2 text-sm bg-gradient-to-r from-gray-100 to-gray-200 text-gray-700 rounded-xl hover:from-gray-200 hover:to-gray-300 transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                ← Anterior
              </button>
              <div className="flex items-center space-x-2">
                <span className="text-sm text-gray-500">Página</span>
                <span className="px-3 py-1 bg-blue-100 text-blue-700 rounded-lg font-medium">1</span>
                <span className="text-sm text-gray-500">de</span>
                <span className="px-3 py-1 bg-gray-100 text-gray-700 rounded-lg font-medium">1</span>
              </div>
              <button className="px-4 py-2 text-sm bg-gradient-to-r from-gray-100 to-gray-200 text-gray-700 rounded-xl hover:from-gray-200 hover:to-gray-300 transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                Siguiente →
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

