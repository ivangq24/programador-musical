import React, { useState, useEffect } from 'react'
import { 
  Calendar, 
  Clock, 
  Music, 
  Film, 
  Volume2, 
  Play, 
  Pause, 
  Square,
  ChevronLeft,
  ChevronRight,
  X,
  Download,
  Printer,
  Edit3,
  Palette,
  Save,
  RotateCcw,
  Search,
  Filter
} from 'lucide-react'

const ConsultarProgramacionComponent = ({ 
  isOpen, 
  onClose, 
  difusora, 
  politica, 
  fecha 
}) => {
  const [programacion, setProgramacion] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [currentEventIndex, setCurrentEventIndex] = useState(0)
  const [editingEvent, setEditingEvent] = useState(null)
  const [showColorConfig, setShowColorConfig] = useState(false)
  const [showSongSelector, setShowSongSelector] = useState(false)
  const [availableSongs, setAvailableSongs] = useState([])
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('')
  const [loadingSongs, setLoadingSongs] = useState(false)
  const [songsError, setSongsError] = useState(null)
  const [colorConfig, setColorConfig] = useState({
    cortes_comerciales: '#10b981',
    exact_time_markers: '#6b7280',
    cartuchos_fijos: '#8b5cf6',
    notas_operador: '#fbbf24',
    vacios: '#3b82f6',
    twofers: '#06b6d4',
    caracteristica_especifica: '#84cc16',
    canciones_manuales: '#f97316',
    comandos_das: '#ec4899',
    primer_evento_hora: '#3b82f6',
    ultimo_evento_hora: '#06b6d4',
    primer_evento_reloj: '#10b981',
    ultimo_evento_reloj: '#14b8a6',
    eventos_sin_cancion: '#6b7280',
    transparencia: 100
  })

  useEffect(() => {
    if (isOpen && difusora && politica && fecha) {
      cargarProgramacion()
    }
  }, [isOpen, difusora, politica, fecha])

  const cargarProgramacion = async () => {
    try {
      setLoading(true)
      setError(null)
      
      console.log('🔍 ConsultarProgramacionComponent - Parámetros recibidos:', {
        isOpen,
        difusora,
        politica,
        fecha
      })
      
      // Convertir fecha de YYYY-MM-DD a DD/MM/YYYY
      let fechaFormateada
      if (fecha && fecha.includes('-')) {
        const [year, month, day] = fecha.split('-')
        fechaFormateada = `${day}/${month}/${year}`
      } else if (fecha && fecha.includes('/')) {
        // Si ya está en formato DD/MM/YYYY, usarla directamente
        fechaFormateada = fecha
      } else {
        throw new Error('Formato de fecha inválido')
      }
      
      console.log('🔍 Fecha original:', fecha)
      console.log('🔍 Fecha formateada:', fechaFormateada)
      
      const params = new URLSearchParams({
        difusora: difusora,
        politica_id: politica,
        fecha: fechaFormateada
      })
      
      console.log('🔍 URL completa:', `http://localhost:8000/api/v1/programacion/programacion-detallada?${params}`)
      
      const response = await fetch(`http://localhost:8000/api/v1/programacion/programacion-detallada?${params}`)
      
      console.log('🔍 Response status:', response.status)
      console.log('🔍 Response ok:', response.ok)
      
      if (response.ok) {
        const data = await response.json()
        setProgramacion(data)
        console.log('✅ Programación detallada cargada:', data)
        console.log('✅ Total eventos:', data.total_eventos)
        console.log('✅ Programación array length:', data.programacion ? data.programacion.length : 'undefined')
      } else {
        const errorData = await response.json()
        console.error('❌ Error response:', errorData)
        throw new Error(`Error al cargar programación: ${errorData.detail || response.statusText}`)
      }
      
    } catch (err) {
      console.error('Error loading programacion:', err)
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const getTipoIcon = (tipo) => {
    switch (tipo) {
      case 'cancion':
        return <Music className="w-4 h-4 text-blue-600" />
      case 'corte_comercial':
        return <Volume2 className="w-4 h-4 text-green-600" />
      case 'vacio':
        return <Square className="w-4 h-4 text-gray-400" />
      default:
        return <Clock className="w-4 h-4 text-gray-600" />
    }
  }

  const getCategoriaColor = (categoria) => {
    const colors = {
      'Pop': 'bg-blue-100 text-blue-800',
      'Rock': 'bg-red-100 text-red-800',
      'Jazz': 'bg-purple-100 text-purple-800',
      'Comercial': 'bg-green-100 text-green-800',
      'Vacio': 'bg-gray-100 text-gray-800'
    }
    return colors[categoria] || 'bg-gray-100 text-gray-800'
  }

  const handleEditSong = (evento) => {
    setEditingEvent(evento)
    setShowSongSelector(true)
    cargarCancionesDisponibles(evento.categoria)
  }

  const cargarCancionesDisponibles = async (categoria) => {
    try {
      setLoadingSongs(true)
      setSongsError(null)
      console.log('🔍 Cargando canciones para categoría:', categoria)
      
      // Mapear nombre de categoría a ID
      const categoriaMap = {
        'Pop': 3,
        'Rock': 4, 
        'Jazz': 5
      }
      
      const categoriaId = categoriaMap[categoria] || categoria
      console.log('🔍 Categoria ID:', categoriaId)
      
      const response = await fetch(`http://localhost:8000/api/v1/categorias/canciones/?categoria_id=${categoriaId}&activa=true`)
      console.log('🔍 Response status:', response.status)
      
      if (response.ok) {
        const data = await response.json()
        console.log('✅ Canciones cargadas:', data)
        
        // Mapear datos para incluir categoria como string
        const cancionesMapeadas = (data.canciones || []).map(cancion => ({
          ...cancion,
          categoria: categoria, // Agregar categoria como string
          duracion: `${Math.floor(cancion.duracion / 60)}:${(cancion.duracion % 60).toString().padStart(2, '0')}` // Convertir segundos a MM:SS
        }))
        
        setAvailableSongs(cancionesMapeadas)
        console.log('✅ Canciones mapeadas:', cancionesMapeadas)
      } else {
        console.error('❌ Error en response:', response.status, response.statusText)
        setSongsError(`Error ${response.status}: ${response.statusText}`)
        setAvailableSongs([])
      }
    } catch (err) {
      console.error('❌ Error loading songs:', err)
      setSongsError(`Error de conexión: ${err.message}`)
      setAvailableSongs([])
    } finally {
      setLoadingSongs(false)
    }
  }

  const handleSongChange = async (nuevaCancion) => {
    try {
      // Aquí iría la lógica para actualizar la canción en la programación
      console.log('Cambiando canción:', editingEvent, 'por:', nuevaCancion)
      
      // Simular actualización
      setProgramacion(prev => ({
        ...prev,
        programacion: prev.programacion.map(evento => 
          evento.id === editingEvent.id 
            ? { ...evento, descripcion: nuevaCancion.titulo, id_media: nuevaCancion.id }
            : evento
        )
      }))
      
      setShowSongSelector(false)
      setEditingEvent(null)
    } catch (err) {
      console.error('Error updating song:', err)
    }
  }

  const handleColorConfigChange = (key, value) => {
    setColorConfig(prev => ({
      ...prev,
      [key]: value
    }))
  }

  const getEventColor = (evento) => {
    // Lógica para determinar el color basado en la configuración
    if (evento.tipo === 'corte_comercial') return colorConfig.cortes_comerciales
    if (evento.tipo === 'vacio') return colorConfig.vacios
    if (evento.categoria === 'Pop') return colorConfig.canciones_manuales
    return colorConfig.cortes_comerciales
  }

  const filteredSongs = availableSongs.filter(song => {
    const matchesSearch = song.titulo.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesCategory = !selectedCategory || song.categoria === selectedCategory
    return matchesSearch && matchesCategory
  })

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl shadow-2xl w-full max-w-7xl h-[90vh] flex flex-col">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-6 rounded-t-xl">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-bold">
                {difusora} - {programacion?.dia_semana}, {programacion?.fecha}
              </h2>
              <p className="text-blue-100 mt-1">
                Política: {politica} - Día Modelo: L-V
              </p>
            </div>
            <div className="flex items-center space-x-4">
              <button
                onClick={() => setShowColorConfig(true)}
                className="p-2 hover:bg-blue-500 rounded-lg transition-colors"
                title="Configurar colores"
              >
                <Palette className="w-6 h-6" />
              </button>
              <button
                onClick={onClose}
                className="p-2 hover:bg-blue-500 rounded-lg transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
          </div>
          
          {/* Timeline */}
          <div className="mt-4 bg-blue-500 rounded-lg p-3">
            <div className="flex items-center space-x-2">
              <div className="flex space-x-1">
                {programacion?.programacion?.slice(0, 20).map((evento, index) => (
                  <div
                    key={index}
                    className={`w-2 h-6 rounded-sm ${
                      evento.tipo === 'cancion' ? 'bg-yellow-400' :
                      evento.tipo === 'corte_comercial' ? 'bg-green-400' :
                      'bg-gray-400'
                    }`}
                    title={`${evento.hora_real} - ${evento.descripcion}`}
                  />
                ))}
              </div>
              <span className="text-blue-100 text-sm">
                {programacion?.programacion?.length || 0} eventos
              </span>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-hidden flex flex-col">
          {loading ? (
            <div className="flex-1 flex items-center justify-center">
              <div className="text-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-4 text-gray-600">Cargando programación...</p>
              </div>
            </div>
          ) : error ? (
            <div className="flex-1 flex items-center justify-center">
              <div className="text-center">
                <div className="text-red-500 text-6xl mb-4">⚠️</div>
                <p className="text-red-600 text-lg">{error}</p>
                <button
                  onClick={cargarProgramacion}
                  className="mt-4 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
                >
                  Reintentar
                </button>
              </div>
            </div>
          ) : (
            <>
              {/* Table */}
              <div className="flex-1 overflow-auto">
                <table className="w-full">
                  <thead className="bg-gray-50 sticky top-0">
                    <tr>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-8">S</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-16">MC</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-16"># Reloj</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-12">#</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Hora Real</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-24">Hora Transmisión</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Duración Real</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-12">Tipo</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Hora Planeada</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Dur. Planeada</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-24">Categoría</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Id Media</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider">Descripción</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-20">Acciones</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {!programacion?.programacion || programacion.programacion.length === 0 ? (
                      <tr>
                        <td colSpan="13" className="px-6 py-8 text-center">
                          <div className="text-gray-400">
                            <Music className="w-12 h-12 mx-auto mb-2 opacity-50" />
                            <p className="text-lg">No hay eventos programados para esta fecha</p>
                          </div>
                        </td>
                      </tr>
                    ) : programacion?.programacion?.map((evento, index) => (
                      <tr 
                        key={evento.id}
                        className={`hover:bg-gray-50 ${
                          evento.mc ? 'bg-green-50' : 'bg-red-50'
                        }`}
                      >
                        <td className="px-3 py-2">
                          <div className="flex flex-col space-y-1">
                            <div 
                              className="w-1 h-3 rounded" 
                              style={{ backgroundColor: getEventColor(evento) }}
                            />
                          </div>
                        </td>
                        <td className="px-3 py-2 text-sm">
                          <span className={`px-2 py-1 rounded text-xs font-medium ${
                            evento.mc ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                          }`}>
                            {evento.mc ? '100' : '-100'} 0
                          </span>
                        </td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.numero_reloj}</td>
                        <td className="px-3 py-2 text-sm">{evento.numero_evento}</td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.hora_real}</td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.hora_transmision}</td>
                        <td className="px-3 py-2 text-sm font-mono flex items-center space-x-1">
                          {getTipoIcon(evento.tipo)}
                          <span>{evento.duracion_real}</span>
                        </td>
                        <td className="px-3 py-2 text-sm">
                          {getTipoIcon(evento.tipo)}
                        </td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.hora_planeada}</td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.duracion_planeada}</td>
                        <td className="px-3 py-2 text-sm">
                          <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoriaColor(evento.categoria)}`}>
                            {evento.categoria}
                          </span>
                        </td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.id_media}</td>
                        <td className="px-3 py-2 text-sm">{evento.descripcion}</td>
                        <td className="px-3 py-2 text-sm">
                          <div className="flex space-x-1">
                            {evento.tipo === 'cancion' && (
                              <button
                                onClick={() => handleEditSong(evento)}
                                className="p-1 text-blue-600 hover:bg-blue-100 rounded transition-colors"
                                title="Cambiar canción"
                              >
                                <Edit3 className="w-4 h-4" />
                              </button>
                            )}
                            <button
                              onClick={() => setEditingEvent(evento)}
                              className="p-1 text-purple-600 hover:bg-purple-100 rounded transition-colors"
                              title="Configurar color"
                            >
                              <Palette className="w-4 h-4" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))
                    }
                  </tbody>
                </table>
              </div>

              {/* Footer */}
              <div className="bg-gray-800 text-white p-4 rounded-b-xl">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-6">
                    <span className="text-sm">
                      Total Eventos ({programacion?.programacion?.length || 0})
                    </span>
                    <span className="text-sm">
                      Cortes Comerciales ({programacion?.programacion?.filter(e => e.tipo === 'corte_comercial').length || 0})
                    </span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <button className="p-2 hover:bg-gray-700 rounded-lg transition-colors">
                      <Download className="w-4 h-4" />
                    </button>
                    <button className="p-2 hover:bg-gray-700 rounded-lg transition-colors">
                      <Printer className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Modal de Configuración de Colores */}
      {showColorConfig && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-[60] flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            {/* Header */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="p-2 bg-purple-100 rounded-full">
                    <Palette className="w-6 h-6 text-purple-600" />
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900">Configuración de Colores de Eventos</h3>
                    <p className="text-sm text-gray-600">Personaliza los colores de los diferentes tipos de eventos</p>
                  </div>
                </div>
                <button
                  onClick={() => setShowColorConfig(false)}
                  className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Content */}
            <div className="px-6 py-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Tipos de Eventos */}
                <div>
                  <h4 className="text-md font-semibold text-gray-900 mb-4">Tipos de Eventos</h4>
                  <div className="space-y-4">
                    {[
                      { key: 'cortes_comerciales', label: 'Cortes Comerciales', color: colorConfig.cortes_comerciales },
                      { key: 'exact_time_markers', label: 'Exact Time Markers', color: colorConfig.exact_time_markers },
                      { key: 'cartuchos_fijos', label: 'Cartuchos Fijos', color: colorConfig.cartuchos_fijos },
                      { key: 'notas_operador', label: 'Notas para el Operador', color: colorConfig.notas_operador },
                      { key: 'vacios', label: 'Vacíos', color: colorConfig.vacios },
                      { key: 'twofers', label: 'Twofers', color: colorConfig.twofers },
                      { key: 'caracteristica_especifica', label: 'Característica Específica', color: colorConfig.caracteristica_especifica },
                      { key: 'canciones_manuales', label: 'Canciones Manuales', color: colorConfig.canciones_manuales },
                      { key: 'comandos_das', label: 'Comandos DAS', color: colorConfig.comandos_das }
                    ].map((item) => (
                      <div key={item.key} className="flex items-center justify-between">
                        <span className="text-sm font-medium text-gray-700">{item.label}</span>
                        <div className="flex items-center space-x-2">
                          <div 
                            className="w-8 h-8 rounded border border-gray-300"
                            style={{ backgroundColor: item.color }}
                          />
                          <input
                            type="color"
                            value={item.color}
                            onChange={(e) => handleColorConfigChange(item.key, e.target.value)}
                            className="w-8 h-8 rounded border border-gray-300 cursor-pointer"
                          />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Condiciones Especiales */}
                <div>
                  <h4 className="text-md font-semibold text-gray-900 mb-4">Condiciones Especiales</h4>
                  <div className="space-y-4">
                    {[
                      { key: 'primer_evento_hora', label: 'Primer evento de la Hora', color: colorConfig.primer_evento_hora },
                      { key: 'ultimo_evento_hora', label: 'Último evento de la Hora', color: colorConfig.ultimo_evento_hora },
                      { key: 'primer_evento_reloj', label: 'Primer evento del Reloj', color: colorConfig.primer_evento_reloj },
                      { key: 'ultimo_evento_reloj', label: 'Último evento del Reloj', color: colorConfig.ultimo_evento_reloj },
                      { key: 'eventos_sin_cancion', label: 'Eventos sin Canción Asignada', color: colorConfig.eventos_sin_cancion }
                    ].map((item) => (
                      <div key={item.key} className="flex items-center justify-between">
                        <span className="text-sm font-medium text-gray-700">{item.label}</span>
                        <div className="flex items-center space-x-2">
                          <div 
                            className="w-8 h-8 rounded border border-gray-300"
                            style={{ backgroundColor: item.color }}
                          />
                          <input
                            type="color"
                            value={item.color}
                            onChange={(e) => handleColorConfigChange(item.key, e.target.value)}
                            className="w-8 h-8 rounded border border-gray-300 cursor-pointer"
                          />
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Transparencia */}
                  <div className="mt-6">
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Transparencia a usar
                    </label>
                    <div className="flex items-center space-x-2">
                      <input
                        type="range"
                        min="0"
                        max="100"
                        value={colorConfig.transparencia}
                        onChange={(e) => handleColorConfigChange('transparencia', parseInt(e.target.value))}
                        className="flex-1"
                      />
                      <span className="text-sm font-medium text-gray-700 w-12">
                        {colorConfig.transparencia}%
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Footer */}
            <div className="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
              <button
                onClick={() => setShowColorConfig(false)}
                className="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
              >
                Cancelar
              </button>
              <button
                onClick={() => setShowColorConfig(false)}
                className="px-4 py-2 bg-green-600 text-white hover:bg-green-700 rounded-lg transition-colors flex items-center space-x-2"
              >
                <Save className="w-4 h-4" />
                <span>Aceptar</span>
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal de Selección de Canciones */}
      {showSongSelector && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-[60] flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            {/* Header */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="p-2 bg-blue-100 rounded-full">
                    <Music className="w-6 h-6 text-blue-600" />
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900">Seleccionar Nueva Canción</h3>
                    <p className="text-sm text-gray-600">Reemplazar: {editingEvent?.descripcion}</p>
                  </div>
                </div>
                <button
                  onClick={() => setShowSongSelector(false)}
                  className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Search and Filters */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex space-x-4">
                <div className="flex-1">
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                    <input
                      type="text"
                      placeholder="Buscar canciones..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div className="w-48">
                  <select
                    value={selectedCategory}
                    onChange={(e) => setSelectedCategory(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="">Todas las categorías</option>
                    <option value="Pop">Pop</option>
                    <option value="Rock">Rock</option>
                    <option value="Jazz">Jazz</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Songs List */}
            <div className="px-6 py-4">
              {loadingSongs ? (
                <div className="flex items-center justify-center py-8">
                  <div className="text-center">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-2 text-sm text-gray-600">Cargando canciones...</p>
                  </div>
                </div>
              ) : songsError ? (
                <div className="text-center py-8">
                  <div className="text-red-500 text-4xl mb-2">⚠️</div>
                  <p className="text-red-600 text-lg">{songsError}</p>
                  <button
                    onClick={() => cargarCancionesDisponibles(editingEvent?.categoria)}
                    className="mt-4 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
                  >
                    Reintentar
                  </button>
                </div>
              ) : filteredSongs.length === 0 ? (
                <div className="text-center py-8">
                  <div className="text-gray-400 text-4xl mb-2">🎵</div>
                  <p className="text-gray-600 text-lg">No se encontraron canciones</p>
                  <p className="text-gray-500 text-sm mt-1">
                    {searchTerm ? `para "${searchTerm}"` : `en la categoría ${selectedCategory || 'seleccionada'}`}
                  </p>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {filteredSongs.map((song) => (
                    <div
                      key={song.id}
                      onClick={() => handleSongChange(song)}
                      className="p-4 border border-gray-200 rounded-lg hover:bg-blue-50 hover:border-blue-300 cursor-pointer transition-colors"
                    >
                      <div className="flex items-start space-x-3">
                        <div className="p-2 bg-blue-100 rounded-lg">
                          <Music className="w-5 h-5 text-blue-600" />
                        </div>
                        <div className="flex-1">
                          <h4 className="font-medium text-gray-900">{song.titulo}</h4>
                          <p className="text-sm text-gray-600">{song.artista}</p>
                          <div className="flex items-center space-x-2 mt-2">
                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoriaColor(song.categoria)}`}>
                              {song.categoria}
                            </span>
                            <span className="text-xs text-gray-500">{song.duracion}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Footer */}
            <div className="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
              <button
                onClick={() => setShowSongSelector(false)}
                className="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ConsultarProgramacionComponent
