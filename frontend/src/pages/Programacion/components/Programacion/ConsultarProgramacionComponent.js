import React, { useState, useEffect, useCallback, useMemo } from 'react'
import { buildApiUrl } from '../../../../utils/apiConfig'

// Helper para logging condicional - solo en desarrollo
const debugLog = (...args) => {
  if (process.env.NODE_ENV === 'development') {
    console.log(...args)
  }
}
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
  Filter,
  CheckCircle
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
  const [showSuccessNotification, setShowSuccessNotification] = useState(false)
  const [successMessage, setSuccessMessage] = useState('')
  const [categoriasDisponibles, setCategoriasDisponibles] = useState([])
  const [selectedEventRow, setSelectedEventRow] = useState(null)
  const [filterCategoria, setFilterCategoria] = useState('')
  // Paginación para eventos - reducir memoria
  const [eventsPage, setEventsPage] = useState(1)
  const eventsPerPage = 30 // Renderizar máximo 30 eventos a la vez (reducido agresivamente)
  
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
    } else if (!isOpen) {
      // Limpiar datos cuando se cierra el modal para liberar memoria
      setProgramacion(null)
      setAvailableSongs([])
      setEventsPage(1)
      setSelectedEventRow(null)
    }
  }, [isOpen, difusora, politica, fecha])

  // Debug: Log cuando showSongSelector cambie - Solo en desarrollo
  useEffect(() => {
    if (process.env.NODE_ENV === 'development' && showSongSelector) {
      debugLog('🎵 Modal de selección de canciones está visible')
    }
  }, [showSongSelector])

  const cargarProgramacion = async () => {
    try {
      setLoading(true)
      setError(null)
      
      debugLog('🔍 ConsultarProgramacionComponent - Parámetros recibidos:', {
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
      
      const url = buildApiUrl(`/programacion/programacion-detallada?${params}`)
      console.log('🔍 URL completa:', url)
      
      const response = await fetch(url, {
        cache: 'no-store',
        headers: {
          'Cache-Control': 'no-cache'
        }
      })
      
      console.log('🔍 Response status:', response.status)
      console.log('🔍 Response ok:', response.ok)
      
      if (response.ok) {
        const data = await response.json()
        setProgramacion(data)
        debugLog('✅ Programación detallada cargada:', data)
        debugLog('✅ Total eventos:', data.total_eventos)
        debugLog('✅ Programación array length:', data.programacion ? data.programacion.length : 'undefined')
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
    console.log('🎵 handleEditSong llamado con evento:', evento)
    console.log('🎵 Tipo de evento:', evento.tipo)
    console.log('🎵 Categoría del evento:', evento.categoria)
    setEditingEvent(evento)
    setShowSongSelector(true)
    console.log('🎵 showSongSelector establecido a true')
    cargarCancionesDisponibles(evento.categoria)
  }

  const cargarCancionesDisponibles = async (categoria) => {
    try {
      setLoadingSongs(true)
      setSongsError(null)
      setAvailableSongs([])
      console.log('🔍 Cargando canciones para categoría:', categoria)
      
      // Primero intentar cargar todas las categorías disponibles
      let todasLasCanciones = []
      
      try {
        // Cargar todas las categorías primero
        const categoriasUrl = buildApiUrl('/categorias/categorias/items')
        const categoriasResponse = await fetch(categoriasUrl, {
          cache: 'no-store',
          headers: {
            'Cache-Control': 'no-cache'
          }
        })
        if (categoriasResponse.ok) {
          const categoriasData = await categoriasResponse.json()
          console.log('✅ Categorías disponibles:', categoriasData)
          
          // Guardar categorías para el dropdown
          setCategoriasDisponibles(categoriasData.map(cat => ({ id: cat.id, nombre: cat.nombre })))
          
          // Cargar canciones de todas las categorías
          const promesasCanciones = categoriasData.map(async (cat) => {
            try {
              const url = buildApiUrl(`/categorias/canciones/?categoria_id=${cat.id}&activa=true`)
              const response = await fetch(url, {
                cache: 'no-store',
                headers: {
                  'Cache-Control': 'no-cache'
                }
              })
              if (response.ok) {
                const data = await response.json()
                return (data.canciones || []).map(cancion => ({
                  ...cancion,
                  categoria: cat.nombre,
                  categoria_id: cat.id,
                  duracion: `${Math.floor(cancion.duracion / 60)}:${(cancion.duracion % 60).toString().padStart(2, '0')}`
                }))
              }
              return []
            } catch (err) {
              console.error(`Error cargando canciones de categoría ${cat.nombre}:`, err)
              return []
            }
          })
          
          const resultados = await Promise.all(promesasCanciones)
          todasLasCanciones = resultados.flat()
          console.log('✅ Total canciones cargadas de todas las categorías:', todasLasCanciones.length)
        }
      } catch (err) {
        console.warn('⚠️ Error cargando categorías, intentando carga directa:', err)
        
        // Fallback: cargar canciones sin filtro de categoría
        try {
          const url = buildApiUrl('/categorias/canciones/?activa=true')
          const response = await fetch(url, {
            cache: 'no-store',
            headers: {
              'Cache-Control': 'no-cache'
            }
          })
          if (response.ok) {
            const data = await response.json()
            todasLasCanciones = (data.canciones || []).map(cancion => ({
              ...cancion,
              categoria: categoria || 'Sin categoría',
              duracion: `${Math.floor(cancion.duracion / 60)}:${(cancion.duracion % 60).toString().padStart(2, '0')}`
            }))
          }
        } catch (fallbackErr) {
          console.error('❌ Error en fallback:', fallbackErr)
        }
      }
      
      if (todasLasCanciones.length > 0) {
        setAvailableSongs(todasLasCanciones)
        setSearchTerm('') // Limpiar búsqueda inicial
        setSelectedCategory(categoria || '') // Filtrar por categoría inicial si se proporciona
        console.log('✅ Canciones disponibles:', todasLasCanciones.length)
      } else {
        setSongsError('No se encontraron canciones disponibles')
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
      console.log('🔍 Cambiando canción:', editingEvent, 'por:', nuevaCancion)
      
      // Actualizar en la base de datos
      const url = buildApiUrl(`/programacion/programacion/${editingEvent.id}/cancion?cancion_id=${nuevaCancion.id}`)
      const response = await fetch(url, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        }
      })
      
      if (!response.ok) {
        const errorData = await response.json()
        throw new Error(errorData.detail || 'Error al actualizar la canción')
      }
      
      const updatedData = await response.json()
      console.log('✅ Canción actualizada en la base de datos:', updatedData)
      
      // Actualizar el estado local con los datos de la respuesta
      setProgramacion(prev => ({
        ...prev,
        programacion: prev.programacion.map(evento => 
          evento.id === editingEvent.id 
            ? { 
                ...evento, 
                descripcion: updatedData.descripcion,
                id_media: updatedData.id_media,
                interprete: updatedData.interprete || nuevaCancion.artista,
                disco: updatedData.disco || nuevaCancion.album,
                duracion_real: updatedData.duracion_real || evento.duracion_real
              }
            : evento
        )
      }))
      
      // Mostrar notificación de éxito
      setError(null)
      setSuccessMessage(`Canción cambiada exitosamente: ${nuevaCancion.titulo}`)
      setShowSuccessNotification(true)
      setShowSongSelector(false)
      setEditingEvent(null)
      
      // Recargar la programación para asegurar que todo esté sincronizado
      await cargarProgramacion()
      
      // Ocultar notificación después de 3 segundos
      setTimeout(() => {
        setShowSuccessNotification(false)
        setSuccessMessage('')
      }, 3000)
    } catch (err) {
      console.error('❌ Error updating song:', err)
      setError(err.message)
      // No cerrar el modal si hay error para que el usuario pueda intentar de nuevo
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
    const searchLower = searchTerm.toLowerCase()
    const matchesSearch = !searchTerm || 
      song.titulo?.toLowerCase().includes(searchLower) ||
      song.artista?.toLowerCase().includes(searchLower) ||
      song.album?.toLowerCase().includes(searchLower)
    const matchesCategory = !selectedCategory || song.categoria === selectedCategory
    return matchesSearch && matchesCategory
  })

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      {/* Success Notification */}
      {showSuccessNotification && (
        <div className="fixed top-4 right-4 z-[70] bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center space-x-2 animate-in fade-in slide-in-from-top-5">
          <CheckCircle className="w-5 h-5" />
          <span className="font-medium">{successMessage}</span>
        </div>
      )}
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
                onClick={() => {
                  if (selectedEventRow) {
                    handleEditSong(selectedEventRow)
                  }
                }}
                disabled={!selectedEventRow || (selectedEventRow.tipo !== 'cancion' && selectedEventRow.tipo !== '1' && !(selectedEventRow.mc === true && selectedEventRow.id_media && selectedEventRow.categoria !== 'Corte Comercial' && selectedEventRow.categoria !== 'ETM'))}
                className={`px-4 py-2 rounded-lg transition-colors flex items-center space-x-2 ${
                  selectedEventRow && (selectedEventRow.tipo === 'cancion' || selectedEventRow.tipo === '1' || (selectedEventRow.mc === true && selectedEventRow.id_media && selectedEventRow.categoria !== 'Corte Comercial' && selectedEventRow.categoria !== 'ETM'))
                    ? 'bg-white text-blue-600 hover:bg-blue-50'
                    : 'bg-gray-400 text-gray-200 cursor-not-allowed'
                }`}
                title={selectedEventRow ? "Cambiar canción de la fila seleccionada" : "Selecciona una fila con canción para editar"}
              >
                <Edit3 className="w-5 h-5" />
                <span className="font-medium">Cambiar Canción</span>
              </button>
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

        {/* Filtro por Categoría */}
        <div className="bg-gradient-to-r from-gray-50 to-blue-50 border-b border-gray-200 px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4 flex-1">
              <div className="flex items-center gap-2">
                <Filter className="w-5 h-5 text-blue-600" />
                <label className="text-sm font-semibold text-gray-700">Filtrar por Categoría:</label>
              </div>
              <select
                value={filterCategoria}
                onChange={(e) => setFilterCategoria(e.target.value)}
                className="flex-1 max-w-md px-4 py-2.5 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 bg-white"
              >
                <option value="">Todas las categorías</option>
                {programacion?.programacion && [...new Set(programacion.programacion.map(e => e.categoria).filter(Boolean))].sort().map((cat) => {
                  const count = programacion.programacion.filter(e => e.categoria === cat).length
                  return (
                    <option key={cat} value={cat}>
                      {cat} ({count})
                    </option>
                  )
                })}
              </select>
              {filterCategoria && (
                <button
                  onClick={() => setFilterCategoria('')}
                  className="px-4 py-2.5 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-medium text-sm"
                >
                  Limpiar
                </button>
              )}
            </div>
            {programacion?.programacion && (
              <div className="text-sm text-gray-600">
                Mostrando <span className="font-semibold text-gray-900">
                  {filterCategoria 
                    ? programacion.programacion.filter(e => e.categoria === filterCategoria).length 
                    : programacion.programacion.length}
                </span> de <span className="font-semibold text-gray-900">{programacion.programacion.length}</span> eventos
              </div>
            )}
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
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-16">Número de reloj</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-16">Clave/Nombre</th>
                      <th className="px-3 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider w-16">MC</th>
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
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {!programacion?.programacion || programacion.programacion.length === 0 ? (
                      <tr>
                        <td colSpan="12" className="px-6 py-8 text-center">
                          <div className="text-gray-400">
                            <Music className="w-12 h-12 mx-auto mb-2 opacity-50" />
                            <p className="text-lg">No hay eventos programados para esta fecha</p>
                          </div>
                        </td>
                      </tr>
                    ) : (() => {
                      // Filtrar eventos por categoría y paginar
                      const eventosFiltrados = programacion?.programacion?.filter(evento => {
                        return !filterCategoria || evento.categoria === filterCategoria
                      }) || []
                      
                      // Paginación: solo renderizar eventos de la página actual
                      const startIndex = (eventsPage - 1) * eventsPerPage
                      const endIndex = startIndex + eventsPerPage
                      const eventosPaginated = eventosFiltrados.slice(startIndex, endIndex)

                      return eventosPaginated.map((evento, index) => (
                      <tr 
                        key={evento.id}
                        onClick={() => {
                          // Solo seleccionar si es una canción
                          if (evento.tipo === 'cancion' || evento.tipo === '1' || 
                              (evento.mc === true && evento.id_media && evento.categoria !== 'Corte Comercial' && evento.categoria !== 'ETM')) {
                            setSelectedEventRow(evento)
                          }
                        }}
                        className={`cursor-pointer transition-all ${
                          selectedEventRow?.id === evento.id 
                            ? 'bg-blue-100 border-l-4 border-blue-500 shadow-md' 
                            : evento.mc 
                              ? 'bg-green-50 hover:bg-green-100' 
                              : 'bg-red-50 hover:bg-red-100'
                        } ${
                          (evento.tipo === 'cancion' || evento.tipo === '1' || 
                           (evento.mc === true && evento.id_media && evento.categoria !== 'Corte Comercial' && evento.categoria !== 'ETM'))
                            ? 'hover:bg-blue-50'
                            : 'cursor-default'
                        }`}
                      >
                        <td className="px-3 py-2 text-sm font-mono text-center">{evento.numero_reloj}</td>
                        <td className="px-3 py-2 text-sm font-mono">{evento.clave_reloj || evento.numero_reloj}</td>
                        <td className="px-3 py-2 text-sm">
                          <span className={`px-2 py-1 rounded text-xs font-medium ${
                            evento.mc ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                          }`}>
                            {evento.mc ? '100' : '-100'} 0
                          </span>
                        </td>
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
                      </tr>
                      ))
                    })()}
                    {/* Paginación de eventos */}
                    {(() => {
                      const eventosFiltrados = programacion?.programacion?.filter(evento => {
                        return !filterCategoria || evento.categoria === filterCategoria
                      }) || []
                      
                      const totalPages = Math.ceil(eventosFiltrados.length / eventsPerPage)
                      
                      return totalPages > 1 && (
                        <tr>
                          <td colSpan="12" className="px-6 py-4 bg-gray-50">
                            <div className="flex items-center justify-between">
                              <div className="text-sm text-gray-700">
                                Mostrando {((eventsPage - 1) * eventsPerPage) + 1} a {Math.min(eventsPage * eventsPerPage, eventosFiltrados.length)} de {eventosFiltrados.length} eventos
                              </div>
                              <div className="flex gap-2">
                                <button
                                  onClick={() => setEventsPage(prev => Math.max(1, prev - 1))}
                                  disabled={eventsPage === 1}
                                  className="px-3 py-1 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                  Anterior
                                </button>
                                <span className="px-3 py-1 text-sm font-medium text-gray-700">
                                  Página {eventsPage} de {totalPages}
                                </span>
                                <button
                                  onClick={() => setEventsPage(prev => Math.min(totalPages, prev + 1))}
                                  disabled={eventsPage >= totalPages}
                                  className="px-3 py-1 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                  Siguiente
                                </button>
                              </div>
                            </div>
                          </td>
                        </tr>
                      )
                    })()}
                    {(() => {
                      const eventosFiltrados = programacion?.programacion?.filter(evento => {
                        return !filterCategoria || evento.categoria === filterCategoria
                      }) || []
                      
                      return eventosFiltrados.length === 0 && filterCategoria ? (
                        <tr>
                          <td colSpan="12" className="px-6 py-8 text-center">
                            <div className="text-gray-400">
                              <Filter className="w-12 h-12 mx-auto mb-2 opacity-50" />
                              <p className="text-lg">No se encontraron eventos en la categoría seleccionada</p>
                              <p className="text-sm mt-2">Intenta seleccionar otra categoría</p>
                            </div>
                          </td>
                        </tr>
                      ) : null
                    })()}
                  </tbody>
                </table>
              </div>

              {/* Footer */}
              <div className="bg-gray-800 text-white p-4 rounded-b-xl">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-6">
                    <span className="text-sm">
                      {(() => {
                        const total = programacion?.programacion?.length || 0
                        if (filterCategoria) {
                          const filtrados = programacion?.programacion?.filter(e => e.categoria === filterCategoria).length || 0
                          return `Eventos Filtrados (${filtrados} de ${total})`
                        }
                        return `Total Eventos (${total})`
                      })()}
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
        <div className="fixed inset-0 bg-black bg-opacity-70 z-[100] flex items-center justify-center p-4" onClick={(e) => {
          if (e.target === e.currentTarget) {
            setShowSongSelector(false)
            setEditingEvent(null)
          }
        }}>
          <div className="bg-white rounded-2xl shadow-2xl max-w-5xl w-full max-h-[90vh] overflow-y-auto" onClick={(e) => e.stopPropagation()}>
            {/* Header */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="p-2 bg-blue-100 rounded-full">
                    <Music className="w-6 h-6 text-blue-600" />
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">Seleccionar Nueva Canción</h3>
                    <p className="text-sm text-gray-600 mt-1">
                      <span className="font-semibold">Canción actual:</span> {editingEvent?.descripcion || 'Sin nombre'}
                      {editingEvent?.artista && ` - ${editingEvent.artista}`}
                    </p>
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
            <div className="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-indigo-50">
              <div className="flex space-x-4">
                <div className="flex-1">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Buscar canción</label>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                    <input
                      type="text"
                      placeholder="Buscar por título, artista o álbum..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="w-full pl-11 pr-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-base"
                    />
                  </div>
                </div>
                <div className="w-64">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">Filtrar por categoría</label>
                  <select
                    value={selectedCategory}
                    onChange={(e) => setSelectedCategory(e.target.value)}
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 font-medium bg-white"
                  >
                    <option value="">Todas las categorías ({availableSongs.length})</option>
                    {categoriasDisponibles.map((cat) => {
                      const count = availableSongs.filter(s => s.categoria === cat.nombre).length
                      return (
                        <option key={cat.id} value={cat.nombre}>
                          {cat.nombre} ({count})
                        </option>
                      )
                    })}
                  </select>
                </div>
              </div>
            </div>

            {/* Songs List */}
            <div className="px-6 py-4">
              {/* Result Counter */}
              {!loadingSongs && !songsError && availableSongs.length > 0 && (
                <div className="mb-4 pb-3 border-b border-gray-200">
                  <div className="flex items-center justify-between">
                    <p className="text-sm text-gray-600">
                      <span className="font-semibold text-gray-900">{filteredSongs.length}</span> de <span className="font-semibold text-gray-900">{availableSongs.length}</span> canciones disponibles
                    </p>
                    {(searchTerm || selectedCategory) && (
                      <button
                        onClick={() => {
                          setSearchTerm('')
                          setSelectedCategory('')
                        }}
                        className="text-sm text-blue-600 hover:text-blue-800 font-medium"
                      >
                        Limpiar filtros
                      </button>
                    )}
                  </div>
                </div>
              )}
              
              {loadingSongs ? (
                <div className="flex items-center justify-center py-12">
                  <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-base text-gray-600 font-medium">Cargando canciones disponibles...</p>
                    <p className="mt-2 text-sm text-gray-500">Esto puede tomar unos segundos</p>
                  </div>
                </div>
              ) : songsError ? (
                <div className="text-center py-12">
                  <div className="text-red-500 text-5xl mb-4">⚠️</div>
                  <p className="text-red-600 text-lg font-semibold mb-2">Error al cargar canciones</p>
                  <p className="text-red-500 text-sm mb-4">{songsError}</p>
                  <button
                    onClick={() => cargarCancionesDisponibles(editingEvent?.categoria)}
                    className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-medium"
                  >
                    Reintentar
                  </button>
                </div>
              ) : filteredSongs.length === 0 ? (
                <div className="text-center py-12">
                  <Music className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-700 text-lg font-semibold mb-2">No se encontraron canciones</p>
                  <p className="text-gray-500 text-sm mb-4">
                    {searchTerm ? (
                      <>No hay canciones que coincidan con <span className="font-medium">"{searchTerm}"</span></>
                    ) : (
                      <>No hay canciones en la categoría <span className="font-medium">{selectedCategory}</span></>
                    )}
                  </p>
                  {(searchTerm || selectedCategory) && (
                    <button
                      onClick={() => {
                        setSearchTerm('')
                        setSelectedCategory('')
                      }}
                      className="text-blue-600 hover:text-blue-800 font-medium underline"
                    >
                      Limpiar filtros para ver todas las canciones
                    </button>
                  )}
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 max-h-[60vh] overflow-y-auto">
                  {filteredSongs.map((song) => (
                    <div
                      key={song.id}
                      onClick={() => handleSongChange(song)}
                      className="p-4 border-2 border-gray-200 rounded-xl hover:bg-blue-50 hover:border-blue-400 hover:shadow-md cursor-pointer transition-all duration-200 group"
                    >
                      <div className="flex items-start space-x-3">
                        <div className="p-2 bg-blue-100 rounded-lg group-hover:bg-blue-200 transition-colors">
                          <Music className="w-5 h-5 text-blue-600" />
                        </div>
                        <div className="flex-1 min-w-0">
                          <h4 className="font-semibold text-gray-900 truncate">{song.titulo}</h4>
                          <p className="text-sm text-gray-600 truncate">{song.artista || 'Sin artista'}</p>
                          {song.album && (
                            <p className="text-xs text-gray-500 truncate mt-1">{song.album}</p>
                          )}
                          <div className="flex items-center space-x-2 mt-2 flex-wrap">
                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoriaColor(song.categoria)}`}>
                              {song.categoria}
                            </span>
                            <span className="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded">
                              {song.duracion}
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="mt-2 pt-2 border-t border-gray-200">
                        <span className="text-xs text-blue-600 font-medium">Click para seleccionar</span>
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
