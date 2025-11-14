import { useEffect, useMemo, useState, useCallback } from 'react'
import { ArrowRightLeft, ChevronRight, Search, Shuffle, CheckCircle, AlertTriangle, Music2, X, FolderTree, Clock, Music, ChevronDown } from 'lucide-react'
import { listCategoriasStats, getElementosCategoria, moverCancionesCategoria } from '../../../../api'

export default function MovimientosCategorias() {
  // Estados principales - cargar todas una vez, filtrar del lado del cliente
  const [categorias, setCategorias] = useState([])
  const [origenId, setOrigenId] = useState('')
  const [destinoId, setDestinoId] = useState('')
  const [loading, setLoading] = useState(false)
  const [songs, setSongs] = useState([])
  const [destSongs, setDestSongs] = useState([])
  const [selected, setSelected] = useState(new Set())
  const [query, setQuery] = useState('')
  const [queryDest, setQueryDest] = useState('')
  const [notification, setNotification] = useState(null)

  // Load all categorias from API - solo una vez al montar
  const loadCategorias = useCallback(async () => {
    setLoading(true)
    try {
      const data = await listCategoriasStats()
      setCategorias(data || [])
    } catch (err) {

      setCategorias([])
    } finally {
      setLoading(false)
    }
  }, [])

  // Load songs from origen category - memoizado
  const loadSongs = useCallback(async (catId) => {
    if (!catId) {
      setSongs([])
      setSelected(new Set())
      return
    }
    setLoading(true)
    try {
      const data = await getElementosCategoria(catId)
      setSongs(data || [])
      setSelected(new Set())
    } catch (err) {

      setSongs([])
      setSelected(new Set())
    } finally {
      setLoading(false)
    }
  }, [])

  // Load songs from destino category - memoizado
  const loadDestSongs = useCallback(async (catId) => {
    if (!catId) {
      setDestSongs([])
      return
    }
    setLoading(true)
    try {
      const data = await getElementosCategoria(catId)
      setDestSongs(data || [])
    } catch (err) {

      setDestSongs([])
    } finally {
      setLoading(false)
    }
  }, [])

  // Load categorias on component mount only
  useEffect(() => {
    loadCategorias()
  }, [loadCategorias])

  // Load songs when origenId changes
  useEffect(() => {
    loadSongs(origenId)
  }, [origenId, loadSongs])

  // Load dest songs when destinoId changes
  useEffect(() => {
    loadDestSongs(destinoId)
  }, [destinoId, loadDestSongs])

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  // Filtrar canciones del lado del cliente - memoizado
  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return songs
    return songs.filter(s =>
      (s.titulo || '').toLowerCase().includes(q) ||
      (s.artista || '').toLowerCase().includes(q) ||
      (s.album || '').toLowerCase().includes(q)
    )
  }, [songs, query])

  // Filtrar canciones destino del lado del cliente - memoizado
  const filteredDest = useMemo(() => {
    const q = queryDest.trim().toLowerCase()
    if (!q) return destSongs
    return destSongs.filter(s =>
      (s.titulo || '').toLowerCase().includes(q) ||
      (s.artista || '').toLowerCase().includes(q) ||
      (s.album || '').toLowerCase().includes(q)
    )
  }, [destSongs, queryDest])

  // Handlers memoizados para evitar recreaciones
  const toggleSelect = useCallback((id) => {
    setSelected(prev => {
      const next = new Set(prev)
      if (next.has(id)) {
ext.delete(id)
      } else {
ext.add(id)
      }
      return next
    })
  }, [])

  const selectAll = useCallback(() => {
    setSelected(new Set(filtered.map(s => s.id)))
  }, [filtered])

  const clearSel = useCallback(() => {
    setSelected(new Set())
  }, [])

  const move = useCallback(async () => {
    if (!origenId || !destinoId || origenId === destinoId || selected.size === 0) {
      setNotification({ type: 'error', message: 'Por favor selecciona categorías diferentes y al menos una canción' })
      return
    }
    
    setLoading(true)
    setNotification(null)
    
    try {
      const res = await moverCancionesCategoria({ origenId, destinoId, cancionesIds: Array.from(selected) })
      setNotification({ type: 'success', message: `Se movieron ${res.moved} canciones correctamente` })
      
      // Actualizar estado local en lugar de recargar todo
      const movedIds = Array.from(selected)
      
      // Remover canciones movidas de origen
      setSongs(prev => prev.filter(s => !movedIds.includes(s.id)))
      
      // Agregar canciones movidas a destino (necesitamos obtener los datos completos)
      // Por ahora recargamos solo las canciones, pero podríamos optimizar más
      await loadDestSongs(destinoId)
      
      // Actualizar estadísticas de categorías localmente
      setCategorias(prev => prev.map(c => {
        if (String(c.id) === String(origenId)) {
          return { ...c, num_elementos: Math.max(0, (c.num_elementos || 0) - movedIds.length) }
        }
        if (String(c.id) === String(destinoId)) {
          return { ...c, num_elementos: (c.num_elementos || 0) + movedIds.length }
        }
        return c
      }))
      
      // Limpiar selección
      setSelected(new Set())
    } catch (e) {
      setNotification({ type: 'error', message: `No se pudo completar el movimiento: ${e.message || 'Error desconocido'}` })
    } finally {
      setLoading(false)
    }
  }, [origenId, destinoId, selected, loadDestSongs])

  // Funciones helper memoizadas
  const format = useCallback((sec) => {
    const s = Math.max(0, Math.floor(sec || 0))
    const m = Math.floor(s / 60)
    const r = s % 60
    return `${m}m ${r}s`
  }, [])

  // Categorías memoizadas
  const origenCat = useMemo(() => categorias.find(c => String(c.id) === String(origenId)) || {}, [categorias, origenId])
  const destinoCat = useMemo(() => categorias.find(c => String(c.id) === String(destinoId)) || {}, [categorias, destinoId])

  // Categorías disponibles para destino (excluyendo origen)
  const categoriasDestino = useMemo(() => {
    return categorias.filter(c => String(c.id) !== String(origenId))
  }, [categorias, origenId])

  const handleClearQuery = useCallback(() => {
    setQuery('')
  }, [])

  const handleClearQueryDest = useCallback(() => {
    setQueryDest('')
  }, [])

  const inputClass = "w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
  const selectClass = "w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"

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
                <AlertTriangle className="w-5 h-5 mr-2 text-red-600" />
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
                    <ArrowRightLeft className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Movimientos entre Categorías</h1>
                    <p className="text-blue-100 text-sm">Mueve canciones seleccionadas de una categoría a otra con seguridad</p>
                  </div>
                </div>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
            </div>

            {/* Panel de selección mejorado */}
            <div className="p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                {/* Categoría Origen */}
                <div className="bg-white rounded-xl shadow-lg border-2 border-blue-200 p-6 hover:border-blue-300 transition-all duration-300">
                  <label className="block text-sm font-bold text-gray-700 mb-3">
                    <FolderTree className="w-5 h-5 inline-block mr-2 text-blue-600" />
                    Categoría Origen
                  </label>
                  <div className="relative">
                    <select 
                      value={origenId} 
                      onChange={e=>setOrigenId(e.target.value)} 
                      className={`${selectClass} appearance-none pr-10 cursor-pointer`}
                    >
                      <option value="">Seleccionar categoría origen</option>
                      {categorias.map(c=> <option key={c.id} value={c.id}>{c.nombre} ({c.num_elementos||0} elementos)</option>)}
                    </select>
                    <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
                  </div>
                  {origenId && (
                    <div className="mt-4 grid grid-cols-3 gap-3">
                      <div className="p-4 bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 rounded-xl shadow-md">
                        <div className="text-xs text-blue-700 font-semibold mb-1">Promedio</div>
                        <div className="text-lg font-bold text-blue-900 flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {format(origenCat.duracion_promedio)}
                        </div>
                      </div>
                      <div className="p-4 bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 rounded-xl shadow-md">
                        <div className="text-xs text-indigo-700 font-semibold mb-1">Elementos</div>
                        <div className="text-lg font-bold text-indigo-900 flex items-center">
                          <Music className="w-4 h-4 mr-1" />
                          {origenCat.num_elementos||0}
                        </div>
                      </div>
                      <div className="p-4 bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-300 rounded-xl shadow-md">
                        <div className="text-xs text-green-700 font-semibold mb-1">Total</div>
                        <div className="text-lg font-bold text-green-900 flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {format(origenCat.duracion_total)}
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Categoría Destino */}
                <div className="bg-white rounded-xl shadow-lg border-2 border-green-200 p-6 hover:border-green-300 transition-all duration-300">
                  <label className="block text-sm font-bold text-gray-700 mb-3">
                    <FolderTree className="w-5 h-5 inline-block mr-2 text-green-600" />
                    Categoría Destino
                  </label>
                  <div className="relative">
                    <select 
                      value={destinoId} 
                      onChange={e => setDestinoId(e.target.value)} 
                      className={`${selectClass} appearance-none pr-10 cursor-pointer`}
                    >
                      <option value="">Seleccionar categoría destino</option>
                      {categoriasDestino.map(c => <option key={c.id} value={c.id}>{c.nombre} ({c.num_elementos || 0} elementos)</option>)}
                    </select>
                    <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
                  </div>
                  {destinoId && (
                    <div className="mt-4 grid grid-cols-3 gap-3">
                      <div className="p-4 bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 rounded-xl shadow-md">
                        <div className="text-xs text-blue-700 font-semibold mb-1">Promedio</div>
                        <div className="text-lg font-bold text-blue-900 flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {format(destinoCat.duracion_promedio)}
                        </div>
                      </div>
                      <div className="p-4 bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 rounded-xl shadow-md">
                        <div className="text-xs text-indigo-700 font-semibold mb-1">Elementos</div>
                        <div className="text-lg font-bold text-indigo-900 flex items-center">
                          <Music className="w-4 h-4 mr-1" />
                          {destinoCat.num_elementos||0}
                        </div>
                      </div>
                      <div className="p-4 bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-300 rounded-xl shadow-md">
                        <div className="text-xs text-green-700 font-semibold mb-1">Total</div>
                        <div className="text-lg font-bold text-green-900 flex items-center">
                          <Clock className="w-4 h-4 mr-1" />
                          {format(destinoCat.duracion_total)}
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Listas de canciones mejoradas */}
            <div className="grid grid-cols-1 xl:grid-cols-2 gap-6 p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
              {/* Origen */}
              <div className="bg-white rounded-xl shadow-lg border-2 border-blue-200 overflow-hidden">
                <div className="bg-gradient-to-r from-blue-50 to-indigo-50 px-6 py-4 border-b-2 border-blue-200">
                  <div className="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4">
                    <div className="relative flex-1">
                      <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <Search className="h-5 w-5 text-gray-400" />
                      </div>
                      <input 
                        value={query} 
                        onChange={e => setQuery(e.target.value)} 
                        placeholder="Buscar canciones (origen)..." 
                        className="w-full pl-12 pr-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                      />
                      {query && (
                        <button
                          onClick={handleClearQuery}
                          className="absolute inset-y-0 right-0 pr-4 flex items-center hover:bg-gray-100 rounded-r-xl transition-colors"
                        >
                          <X className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        </button>
                      )}
                    </div>
                    <div className="flex flex-wrap items-center gap-2">
                      <button 
                        onClick={selectAll} 
                        className="px-4 py-2.5 border-2 border-gray-300 rounded-xl hover:bg-gray-50 transition-all duration-200 text-sm font-semibold shadow-md hover:shadow-lg transform hover:scale-105"
                      >
                        Seleccionar todo
                      </button>
                      <button 
                        onClick={clearSel} 
                        className="px-4 py-2.5 border-2 border-gray-300 rounded-xl hover:bg-gray-50 transition-all duration-200 text-sm font-semibold shadow-md hover:shadow-lg transform hover:scale-105"
                      >
                        Limpiar
                      </button>
                      <button 
                        disabled={!origenId || !destinoId || selected.size===0 || loading} 
                        onClick={move} 
                        className="px-6 py-2.5 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 font-semibold"
                      >
                        <Shuffle className="w-5 h-5"/>
                        Mover {selected.size>0? `(${selected.size})`: ''}
                        <ChevronRight className="w-5 h-5"/>
                      </button>
                    </div>
                  </div>
                </div>
                <div className="overflow-hidden">
                  <div className="max-h-96 overflow-y-auto">
                    <table className="min-w-full divide-y divide-gray-200">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-3"></th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Título</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Artista</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Álbum</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Duración</th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        {loading ? (
                          <tr>
                            <td colSpan="5" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center justify-center space-y-3">
                                <Music2 className="w-8 h-8 text-blue-600 animate-pulse"/>
                                <div className="text-gray-600 font-medium">Cargando canciones...</div>
                              </div>
                            </td>
                          </tr>
                        ) : filtered.length===0 ? (
                          <tr>
                            <td colSpan="5" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center justify-center space-y-3">
                                <Music className="w-8 h-8 text-gray-400"/>
                                <div className="text-gray-500 font-medium">Sin canciones</div>
                              </div>
                            </td>
                          </tr>
                        ) : (
                          filtered.map((s, index) => (
                            <tr key={s.id} className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                              <td className="px-4 py-3">
                                <input 
                                  type="checkbox" 
                                  checked={selected.has(s.id)} 
                                  onChange={() => toggleSelect(s.id)}
                                  onClick={(e) => e.stopPropagation()}
                                  className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500 focus:ring-2 cursor-pointer"
                                />
                              </td>
                              <td className="px-4 py-3 text-sm font-medium text-gray-900">{s.titulo}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{s.artista}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{s.album||'-'}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{format(s.duracion)}</td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                </div>
                {selected.size>0 && (
                  <div className="px-6 py-3 bg-gradient-to-r from-blue-50 to-indigo-50 border-t-2 border-blue-200">
                    <div className="text-sm text-blue-800 font-semibold flex items-center">
                      <CheckCircle className="w-4 h-4 mr-2"/>
                      Seleccionadas: <span className="font-bold mx-1">{selected.size}</span> en <span className="font-bold mx-1">{origenCat.nombre||'—'}</span>
                    </div>
                  </div>
                )}
              </div>

              {/* Destino (solo lectura) */}
              <div className="bg-white rounded-xl shadow-lg border-2 border-green-200 overflow-hidden">
                <div className="bg-gradient-to-r from-green-50 to-emerald-50 px-6 py-4 border-b-2 border-green-200">
                  <div className="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4">
                    <div className="relative flex-1">
                      <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <Search className="h-5 w-5 text-gray-400" />
                      </div>
                      <input 
                        value={queryDest} 
                        onChange={e => setQueryDest(e.target.value)} 
                        placeholder="Buscar canciones (destino)..." 
                        className="w-full pl-12 pr-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                      />
                      {queryDest && (
                        <button
                          onClick={handleClearQueryDest}
                          className="absolute inset-y-0 right-0 pr-4 flex items-center hover:bg-gray-100 rounded-r-xl transition-colors"
                        >
                          <X className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                        </button>
                      )}
                    </div>
                    <div className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-100 to-emerald-100 rounded-xl border-2 border-green-300">
                      <Music className="w-5 h-5 text-green-700"/>
                      <span className="text-sm font-bold text-green-800">{filteredDest.length} elementos</span>
                    </div>
                  </div>
                </div>
                <div className="overflow-hidden">
                  <div className="max-h-96 overflow-y-auto">
                    <table className="min-w-full divide-y divide-gray-200">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Título</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Artista</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Álbum</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Duración</th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        {loading ? (
                          <tr>
                            <td colSpan="4" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center justify-center space-y-3">
                                <Music2 className="w-8 h-8 text-green-600 animate-pulse"/>
                                <div className="text-gray-600 font-medium">Cargando canciones...</div>
                              </div>
                            </td>
                          </tr>
                        ) : filteredDest.length===0 ? (
                          <tr>
                            <td colSpan="4" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center justify-center space-y-3">
                                <Music className="w-8 h-8 text-gray-400"/>
                                <div className="text-gray-500 font-medium">Sin canciones</div>
                              </div>
                            </td>
                          </tr>
                        ) : (
                          filteredDest.map((s, index) => (
                            <tr key={s.id} className={`hover:bg-green-50/50 transition-all duration-200 ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                              <td className="px-4 py-3 text-sm font-medium text-gray-900">{s.titulo}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{s.artista}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{s.album||'-'}</td>
                              <td className="px-4 py-3 text-sm text-gray-600">{format(s.duracion)}</td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                </div>
                {destinoId && (
                  <div className="px-6 py-4 bg-gradient-to-r from-green-50 to-emerald-50 border-t-2 border-green-200">
                    <div className="grid grid-cols-3 gap-3">
                      <div className="p-3 bg-white rounded-xl border-2 border-green-300 shadow-md">
                        <div className="text-xs text-green-700 font-semibold mb-1">Promedio</div>
                        <div className="text-base font-bold text-green-900 flex items-center">
                          <Clock className="w-3 h-3 mr-1" />
                          {format(destinoCat.duracion_promedio)}
                        </div>
                      </div>
                      <div className="p-3 bg-white rounded-xl border-2 border-green-300 shadow-md">
                        <div className="text-xs text-green-700 font-semibold mb-1">Elementos</div>
                        <div className="text-base font-bold text-green-900 flex items-center">
                          <Music className="w-3 h-3 mr-1" />
                          {destinoCat.num_elementos||0}
                        </div>
                      </div>
                      <div className="p-3 bg-white rounded-xl border-2 border-green-300 shadow-md">
                        <div className="text-xs text-green-700 font-semibold mb-1">Total</div>
                        <div className="text-base font-bold text-green-900 flex items-center">
                          <Clock className="w-3 h-3 mr-1" />
                          {format(destinoCat.duracion_total)}
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
