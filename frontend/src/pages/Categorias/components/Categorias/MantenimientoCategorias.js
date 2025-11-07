import { useEffect, useMemo, useState, useCallback } from 'react'
import { Plus, Edit, Trash2, Search, X, CheckCircle, AlertCircle, FolderTree, Clock, Music, Filter } from 'lucide-react'
import { listCategoriasStats, createCategoria, updateCategoria, deleteCategoria, getElementosCategoria } from '../../../../api'
import { getDifusoras } from '../../../../api/catalogos'

export default function MantenimientoCategorias() {
  // Estados principales - cargar todas una vez, filtrar del lado del cliente
  const [categorias, setCategorias] = useState([])
  const [loading, setLoading] = useState(false)
  const [selectedId, setSelectedId] = useState(null)
  const [query, setQuery] = useState('')
  const [showModal, setShowModal] = useState(false)
  const [form, setForm] = useState({ difusora: '', clave: '', nombre: '', descripcion: '', activa: true })
  const [mode, setMode] = useState('add') // add | edit | consult
  const [activeTab, setActiveTab] = useState('generales')
  const [difusoras, setDifusoras] = useState([])
  const [elementos, setElementos] = useState([])
  const [notification, setNotification] = useState(null)

  // Filtrar categorías del lado del cliente - memoizado
  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return categorias
    return categorias.filter(c => 
      (c.nombre || '').toLowerCase().includes(q) || 
      (c.descripcion || '').toLowerCase().includes(q)
    )
  }, [categorias, query])

  // Load all categorias from API - solo una vez al montar
  const load = useCallback(async () => {
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

  // Load difusoras - solo una vez al montar
  const loadDifusoras = useCallback(async () => {
    try {
      const d = await getDifusoras()
      setDifusoras(d || [])
    } catch (err) {

      setDifusoras([])
    }
  }, [])

  // Load categorias on component mount only
  useEffect(() => {
    load()
  }, [load])

  // Load difusoras on component mount only
  useEffect(() => {
    loadDifusoras()
  }, [loadDifusoras])

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
  const showNotif = useCallback((message, type = 'success') => {
    setNotification({ message, type })
  }, [])

  const onAdd = useCallback(() => {
    setMode('add')
    setForm({ difusora: '', clave: '', nombre: '', descripcion: '', activa: true })
    setActiveTab('generales')
    setElementos([])
    setShowModal(true)
  }, [])

  const onEdit = useCallback(() => {
    const cat = categorias.find(c => c.id === selectedId)
    if (!cat) return
    setMode('edit')
    setForm({ 
      difusora: cat.difusora || '', 
      clave: cat.clave || '', 
ombre: cat.nombre || '', 
      descripcion: cat.descripcion || '', 
      activa: !!cat.activa 
    })
    setActiveTab('generales')
    
    // Cargar elementos de la categoría
    ;(async () => {
      try {
        const els = await getElementosCategoria(cat.id)
        setElementos(els || [])
      } catch (err) {

        setElementos([])
      }
    })()
    
    setShowModal(true)
  }, [categorias, selectedId])

  const onDelete = useCallback(async () => {
    if (!selectedId) return
    if (!window.confirm('¿Estás seguro de que deseas eliminar esta categoría?')) return
    
    try {
      await deleteCategoria(selectedId)
      showNotif('Categoría eliminada correctamente', 'success')
      // Actualizar estado local en lugar de recargar todo
      setCategorias(prev => prev.filter(c => c.id !== selectedId))
      setSelectedId(null)
    } catch (err) {
      showNotif(`Error al eliminar la categoría: ${err.message}`, 'error')
    }
  }, [selectedId, showNotif])

  const onSave = useCallback(async () => {
    if (!form.nombre.trim()) {
      showNotif('El nombre es requerido', 'error')
      return
    }
    
    try {
      if (mode === 'add') {
        const newCategoria = await createCategoria(form)
        showNotif('Categoría creada correctamente', 'success')
        // Actualizar estado local en lugar de recargar todo
        setCategorias(prev => [...prev, newCategoria || { ...form, id: Date.now() }])
      } else {
        await updateCategoria(selectedId, form)
        showNotif('Categoría actualizada correctamente', 'success')
        // Actualizar estado local en lugar de recargar todo
        setCategorias(prev => prev.map(c => 
          c.id === selectedId ? { ...c, ...form } : c
        ))
      }
      setShowModal(false)
    } catch (err) {
      showNotif(`Error al guardar la categoría: ${err.message}`, 'error')
    }
  }, [form, mode, selectedId, showNotif])

  // Funciones helper memoizadas
  const formatSeconds = useCallback((total) => {
    const seconds = Math.max(0, Math.floor(total || 0))
    const m = Math.floor(seconds / 60)
    const s = seconds % 60
    return `${m} min ${s} seg`
  }, [])

  // Selected category memoizado
  const selectedCat = useMemo(() => {
    return categorias.find(c => c.id === selectedId)
  }, [categorias, selectedId])

  const handleCloseModal = useCallback(() => {
    setShowModal(false)
  }, [])

  const handleClearQuery = useCallback(() => {
    setQuery('')
  }, [])

  const handleConsult = useCallback(() => {
    if (!selectedId) return
    setMode('consult')
    onEdit()
  }, [selectedId, onEdit])

  const handleSelectCategory = useCallback((catId) => {
    setSelectedId(catId)
  }, [])

  const inputClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
    mode === 'consult' ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
  }`

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
                    <FolderTree className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Mantenimiento de Categorías</h1>
                    <p className="text-blue-100 text-sm">Administra y organiza tus categorías musicales</p>
                  </div>
                </div>
                
                {/* Action Buttons */}
                <div className="flex flex-wrap gap-3">
                  <button 
                    onClick={onAdd} 
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Plus className="w-5 h-5" />
                    <span>Añadir</span>
                  </button>
                  <button 
                    onClick={onEdit} 
                    disabled={!selectedId} 
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Edit className="w-5 h-5" />
                    <span>Editar</span>
                  </button>
                  <button 
                    onClick={onDelete} 
                    disabled={!selectedId} 
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Trash2 className="w-5 h-5" />
                    <span>Eliminar</span>
                  </button>
                  <button 
                    onClick={handleConsult} 
                    disabled={!selectedId} 
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Search className="w-5 h-5" />
                    <span>Consultar</span>
                  </button>
                </div>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
            </div>

            {/* Enhanced Search */}
            <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
              <div className="relative max-w-lg">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Search className="h-5 w-5 text-gray-400" />
                </div>
                <input 
                  value={query} 
                  onChange={e => setQuery(e.target.value)} 
                  placeholder="Buscar categorías..." 
                  className="block w-full pl-12 pr-12 py-3.5 border-2 border-gray-300 rounded-xl leading-5 bg-white text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-md transition-all duration-200 hover:border-gray-400"
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
            </div>

            {/* Enhanced Table */}
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                  <tr>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Nombre</th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Descripción</th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider"># Elementos</th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Duración Prom</th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Activa</th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Creada</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {loading ? (
                    <tr>
                      <td colSpan="6" className="px-6 py-20 text-center">
                        <div className="flex flex-col items-center justify-center space-y-4">
                          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
                          <div className="text-gray-600 font-medium">Cargando categorías...</div>
                        </div>
                      </td>
                    </tr>
                  ) : filtered.length === 0 ? (
                    <tr>
                      <td colSpan="6" className="px-6 py-20 text-center">
                        <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
                          <FolderTree className="w-12 h-12 text-gray-400" />
                        </div>
                        <h3 className="text-2xl font-bold text-gray-900 mb-3">No se encontraron categorías</h3>
                        <p className="text-gray-600 mb-6 max-w-md mx-auto text-base">
                          {query ? 'Intenta ajustar los términos de búsqueda.' : 'Comienza agregando tu primera categoría al sistema.'}
                        </p>
                        {!query && (
                          <button
                            onClick={onAdd}
                            className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold hover:shadow-xl transform hover:scale-105 hover:-translate-y-1 flex items-center space-x-2 mx-auto"
                          >
                            <Plus className="w-5 h-5" />
                            <span>Crear primera categoría</span>
                          </button>
                        )}
                      </td>
                    </tr>
                  ) : (
                    filtered.map((cat, index) => (
                      <tr 
                        key={cat.id} 
                        onClick={() => handleSelectCategory(cat.id)} 
                        className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'} ${selectedId===cat.id?'bg-blue-100 ring-2 ring-blue-500':''}`}
                      >
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900 group-hover:text-blue-700 transition-colors">
                          {cat.nombre}
                        </td>
                        <td className="px-6 py-4 text-sm text-gray-600">
                          <div className="max-w-xs truncate" title={cat.descripcion}>
                            {cat.descripcion || '-'}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm bg-gradient-to-r from-indigo-100 to-indigo-50 text-indigo-800 border-indigo-300">
                            {cat.num_elementos ?? 0}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center text-sm font-medium text-gray-900">
                            <Clock className="w-4 h-4 text-gray-400 mr-2" />
                            {formatSeconds(cat.duracion_promedio ?? 0)}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm ${
                            cat.activa 
                              ? 'bg-gradient-to-r from-green-100 to-green-50 text-green-800 border-green-300' 
                              : 'bg-gradient-to-r from-red-100 to-red-50 text-red-800 border-red-300'
                          }`}>
                            {cat.activa ? 'Sí' : 'No'}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                          {new Date(cat.created_at).toLocaleDateString()}
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Enhanced Modal */}
        {showModal && (
          <div 
            className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200"
            onClick={(e) => {
              if (e.target === e.currentTarget) {
                handleCloseModal()
              }
            }}
          >
            <div 
              className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100"
              onClick={(e) => e.stopPropagation()}
            >
              {/* Enhanced Window Header */}
              <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 relative overflow-hidden border-b border-blue-800/20">
                <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
                <div className="relative z-10 flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                      <FolderTree className="w-6 h-6 text-white" />
                    </div>
                    <h1 className="text-2xl font-bold text-white">
                      {mode==='add'?'Nueva Categoría': mode==='edit'?'Editar Categoría':'Consultar Categoría'}
                    </h1>
                  </div>
                  <button
                    onClick={handleCloseModal}
                    className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110"
                    title="Cerrar"
                  >
                    <X className="w-5 h-5" />
                  </button>
                </div>
                {/* Efecto de partículas decorativas */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
                <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
              </div>

              {/* Tabs */}
              <div className="px-6 pt-4 bg-gradient-to-r from-gray-50 to-blue-50/20 border-b border-gray-200">
                <div className="flex gap-4">
                  <button 
                    className={`pb-3 px-4 font-semibold transition-all duration-200 ${
                      activeTab==='generales'
                        ?'border-b-3 border-blue-600 text-blue-600' 
                        :'text-gray-600 hover:text-gray-900'
                    }`} 
                    onClick={()=>setActiveTab('generales')}
                  >
                    Datos generales
                  </button>
                  <button 
                    className={`pb-3 px-4 font-semibold transition-all duration-200 ${
                      activeTab==='estadisticas'
                        ?'border-b-3 border-blue-600 text-blue-600' 
                        :'text-gray-600 hover:text-gray-900'
                    }`} 
                    onClick={()=>setActiveTab('estadisticas')}
                  >
                    Estadísticas
                  </button>
                  <button 
                    className={`pb-3 px-4 font-semibold transition-all duration-200 ${
                      activeTab==='elementos'
                        ?'border-b-3 border-blue-600 text-blue-600' 
                        :'text-gray-600 hover:text-gray-900'
                    }`} 
                    onClick={()=>setActiveTab('elementos')}
                  >
                    Elementos
                  </button>
                </div>
              </div>

              {/* Contenido scrollable */}
              <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
                {activeTab === 'generales' && (
                  <div className="space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Difusora
                        </label>
                        <select 
                          disabled={mode==='consult'} 
                          value={form.difusora} 
                          onChange={e=>setForm({...form, difusora:e.target.value})} 
                          className={inputClass}
                        >
                          <option value="">Seleccionar difusora</option>
                          {Array.isArray(difusoras) && difusoras.map((d)=> (
                            <option key={d.id||d.siglas} value={d.siglas||d.nombre}>{d.siglas || d.nombre}</option>
                          ))}
                        </select>
                      </div>
                      <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm md:mt-0 mt-4">
                        <input 
                          type="checkbox" 
                          disabled={mode==='consult'} 
                          checked={!!form.activa} 
                          onChange={e=>setForm({...form, activa:e.target.checked})}
                          className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer disabled:cursor-not-allowed"
                        />
                        <span className="text-base font-semibold text-gray-700 cursor-pointer">Habilitada</span>
                      </div>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Clave
                        </label>
                        <input 
                          disabled={mode==='consult'} 
                          value={form.clave} 
                          onChange={e=>setForm({...form, clave:e.target.value})} 
                          className={inputClass}
                          placeholder="Clave de la categoría"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Nombre <span className="text-red-500">*</span>
                        </label>
                        <input 
                          disabled={mode==='consult'} 
                          value={form.nombre} 
                          onChange={e=>setForm({...form, nombre:e.target.value})} 
                          className={inputClass}
                          placeholder="Nombre de la categoría"
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">
                        Descripción
                      </label>
                      <textarea 
                        disabled={mode==='consult'} 
                        value={form.descripcion||''} 
                        onChange={e=>setForm({...form, descripcion:e.target.value})} 
                        rows="4"
                        className={inputClass}
                        placeholder="Descripción de la categoría"
                      />
                    </div>
                  </div>
                )}

                {activeTab === 'estadisticas' && (
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
                    <div className="p-5 bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                      <div className="text-sm text-blue-700 font-semibold mb-2">Duración promedio</div>
                      <div className="text-2xl font-bold text-blue-900">{formatSeconds((selectedCat||{}).duracion_promedio || 0)}</div>
                    </div>
                    <div className="p-5 bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                      <div className="text-sm text-indigo-700 font-semibold mb-2">Número de elementos</div>
                      <div className="text-2xl font-bold text-indigo-900">{(selectedCat||{}).num_elementos || 0}</div>
                    </div>
                    <div className="p-5 bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-300 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                      <div className="text-sm text-green-700 font-semibold mb-2">Duración total</div>
                      <div className="text-2xl font-bold text-green-900">{formatSeconds((selectedCat||{}).duracion_total || 0)}</div>
                    </div>
                    <div className="p-5 bg-gradient-to-br from-purple-50 to-purple-100 border-2 border-purple-300 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                      <div className="text-sm text-purple-700 font-semibold mb-2">Duración mínima</div>
                      <div className="text-2xl font-bold text-purple-900">{formatSeconds((selectedCat||{}).duracion_min || 0)}</div>
                    </div>
                    <div className="p-5 bg-gradient-to-br from-pink-50 to-pink-100 border-2 border-pink-300 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                      <div className="text-sm text-pink-700 font-semibold mb-2">Duración máxima</div>
                      <div className="text-2xl font-bold text-pink-900">{formatSeconds((selectedCat||{}).duracion_max || 0)}</div>
                    </div>
                  </div>
                )}

                {activeTab === 'elementos' && (
                  <div className="border-2 border-gray-200 rounded-xl overflow-hidden shadow-lg max-h-[55vh] overflow-y-auto">
                    <table className="min-w-full divide-y divide-gray-200">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Título</th>
                          <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Artista</th>
                          <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Álbum</th>
                          <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Duración</th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-200">
                        {elementos.length === 0 ? (
                          <tr>
                            <td colSpan="4" className="px-6 py-12 text-center">
                              <div className="mx-auto w-16 h-16 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-4 shadow-lg">
                                <Music className="w-8 h-8 text-gray-400" />
                              </div>
                              <p className="text-gray-500 font-medium">Sin elementos</p>
                            </td>
                          </tr>
                        ) : (
                          elementos.map((el, index) => (
                            <tr key={el.id} className={`hover:bg-blue-50/50 transition-all duration-200 ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                              <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{el.titulo}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{el.artista}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{el.album || '-'}</td>
                              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{formatSeconds(el.duracion)}</td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>

              {/* Enhanced Footer */}
              <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end space-x-3 shadow-inner">
                <button 
                  onClick={handleCloseModal} 
                  className="px-8 py-3 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
                >
                  <X className="w-5 h-5" />
                  <span>{mode==='consult'?'Cerrar':'Cancelar'}</span>
                </button>
                {mode!=='consult' && (
                  <button 
                    onClick={onSave} 
                    className="px-8 py-3 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
                  >
                    <CheckCircle className="w-5 h-5" />
                    <span>Guardar</span>
                  </button>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </>
  )
}
