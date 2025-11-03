'use client'

import { useState, useEffect, useMemo, useCallback } from 'react'
import { 
  Plus, 
  Edit, 
  Trash2, 
  Search, 
  Filter, 
  Clock, 
  Music, 
  Save, 
  X,
  AlertCircle,
  CheckCircle,
  Eye,
  Download,
  Scissors
} from 'lucide-react'
import { 
  getCortes, 
  getCorte, 
  createCorte, 
  updateCorte, 
  deleteCorte, 
  getCortesStats 
} from '../../../../api/catalogos/cortes'

export default function Cortes() {
  // Estados principales - cargar todas una vez, filtrar del lado del cliente
  const [cortes, setCortes] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [showForm, setShowForm] = useState(false)
  const [formMode, setFormMode] = useState('new') // 'new', 'edit', 'view'
  const [selectedCorte, setSelectedCorte] = useState(null)
  const [notification, setNotification] = useState(null)
  const [stats, setStats] = useState({ total: 0, activos: 0, inactivos: 0, comerciales: 0, vacios: 0 })
  
  // Estados para filtros y búsqueda
  const [searchTerm, setSearchTerm] = useState('')
  const [showFilters, setShowFilters] = useState(false)
  const [filterDuracion, setFilterDuracion] = useState('')
  const [filterTipo, setFilterTipo] = useState('')
  
  // Estados del formulario
  const [formData, setFormData] = useState({
    nombre: '',
    descripcion: '',
    duracion: '',
    tipo: 'comercial', // 'comercial' o 'vacio'
    activo: true,
    observaciones: ''
  })
  
  const [formErrors, setFormErrors] = useState({})

  // Load all cortes from API - solo una vez al montar
  const loadCortes = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      // Cargar todos los cortes sin filtros - filtrar del lado del cliente
      const response = await getCortes({})
      setCortes(response || [])
    } catch (err) {
      setError('Error al cargar los cortes')
      console.error('Error:', err)
      setCortes([])
    } finally {
      setLoading(false)
    }
  }, [])

  // Calcular stats memoizados desde cortes
  const calculatedStats = useMemo(() => {
    const comerciales = cortes.filter(c => c.tipo === 'comercial').length
    const vacios = cortes.filter(c => c.tipo === 'vacio').length
    return {
      total: cortes.length,
      activos: cortes.filter(c => c.activo).length,
      inactivos: cortes.filter(c => !c.activo).length,
      comerciales,
      vacios
    }
  }, [cortes])

  // Filtrar cortes del lado del cliente - memoizado para evitar recálculos
  const filteredCortes = useMemo(() => {
    let result = cortes

    // Filtrar por búsqueda
    if (searchTerm.trim()) {
      const searchLower = searchTerm.toLowerCase().trim()
      result = result.filter(corte => 
        corte.nombre?.toLowerCase().includes(searchLower) ||
        corte.descripcion?.toLowerCase().includes(searchLower)
      )
    }

    // Filtrar por tipo
    if (filterTipo) {
      result = result.filter(corte => corte.tipo === filterTipo)
    }

    // Filtrar por duración
    if (filterDuracion) {
      result = result.filter(corte => corte.duracion === filterDuracion)
    }

    return result
  }, [cortes, searchTerm, filterTipo, filterDuracion])

  // Load cortes on component mount only
  useEffect(() => {
    loadCortes()
  }, [loadCortes])

  // Load stats solo una vez después de cargar los cortes iniciales
  useEffect(() => {
    if (cortes.length > 0 && stats.total === 0) {
      getCortesStats().then(statsData => {
        setStats(statsData)
      }).catch(() => {
        // Fallback: usar calculatedStats que ya está memoizado
      })
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cortes.length]) // Solo cuando se cargan los cortes iniciales


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

  // Manejar formulario - memoizado
  const handleInputChange = useCallback((e) => {
    const { name, value, type, checked } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }))
    
    // Limpiar error del campo
    setFormErrors(prev => {
      if (prev[name]) {
        return { ...prev, [name]: '' }
      }
      return prev
    })
  }, [])

  const validateForm = useCallback(() => {
    const errors = {}
    
    if (!formData.nombre.trim()) {
      errors.nombre = 'El nombre es requerido'
    }
    
    if (!formData.duracion.trim()) {
      errors.duracion = 'La duración es requerida'
    } else if (!/^\d{2}:\d{2}:\d{2}$/.test(formData.duracion)) {
      errors.duracion = 'Formato de duración inválido (HH:MM:SS)'
    }
    
    setFormErrors(errors)
    return Object.keys(errors).length === 0
  }, [formData])

  // Handlers memoizados para evitar recreaciones
  // handleCloseForm debe definirse antes de handleSave porque handleSave lo usa
  const handleCloseForm = useCallback(() => {
    setShowForm(false)
    setSelectedCorte(null)
    setFormData({
      nombre: '',
      descripcion: '',
      duracion: '',
      tipo: 'comercial',
      activo: true,
      observaciones: ''
    })
    setFormErrors({})
    setFormMode('new')
  }, [])

  const handleSave = useCallback(async () => {
    const isValid = validateForm()
    if (!isValid) return
    
    setLoading(true)
    setError(null)
    try {
      if (formMode === 'new') {
        const newCorte = await createCorte(formData)
        showNotification('Corte creado correctamente', 'success')
        // Actualizar estado local en lugar de recargar todo
        // Si el API no retorna el objeto completo, usar formData con el ID
        setCortes(prev => [...prev, newCorte || { ...formData, id: Date.now() }])
      } else if (formMode === 'edit' && selectedCorte) {
        await updateCorte(selectedCorte.id, formData)
        showNotification('Corte actualizado correctamente', 'success')
        // Actualizar estado local en lugar de recargar todo
        setCortes(prev => prev.map(c => 
          c.id === selectedCorte.id ? { ...c, ...formData } : c
        ))
      }
      
      handleCloseForm()
    } catch (err) {
      showNotification(`Error al guardar el corte: ${err.message}`, 'error')
      console.error('Error saving corte:', err)
    } finally {
      setLoading(false)
    }
  }, [formData, formMode, selectedCorte, validateForm, showNotification, handleCloseForm])

  const handleEdit = useCallback((corte) => {
    setSelectedCorte(corte)
    setFormData({
      nombre: corte.nombre || '',
      descripcion: corte.descripcion || '',
      duracion: corte.duracion || '',
      tipo: corte.tipo || 'comercial',
      activo: corte.activo ?? true,
      observaciones: corte.observaciones || ''
    })
    setFormMode('edit')
    setShowForm(true)
  }, [])

  const handleView = useCallback((corte) => {
    setSelectedCorte(corte)
    setFormData({
      nombre: corte.nombre || '',
      descripcion: corte.descripcion || '',
      duracion: corte.duracion || '',
      tipo: corte.tipo || 'comercial',
      activo: corte.activo ?? true,
      observaciones: corte.observaciones || ''
    })
    setFormMode('view')
    setShowForm(true)
  }, [])

  const handleDelete = useCallback(async (corte) => {
    if (!corte) return
    
    if (window.confirm(`¿Estás seguro de que deseas eliminar el corte "${corte.nombre}"?`)) {
      setLoading(true)
      setError(null)
      try {
        await deleteCorte(corte.id)
        showNotification('Corte eliminado correctamente', 'success')
        // Actualizar estado local en lugar de recargar todo
        setCortes(prev => prev.filter(c => c.id !== corte.id))
      } catch (err) {
        showNotification(`Error al eliminar el corte: ${err.message}`, 'error')
        console.error('Error deleting corte:', err)
      } finally {
        setLoading(false)
      }
    }
  }, [showNotification])

  const handleNew = useCallback(() => {
    setSelectedCorte(null)
    setFormData({
      nombre: '',
      descripcion: '',
      duracion: '',
      tipo: 'comercial',
      activo: true,
      observaciones: ''
    })
    setFormErrors({})
    setFormMode('new')
    setShowForm(true)
  }, [])

  // Funciones helper memoizadas
  const getTipoColor = useCallback((tipo) => {
    const colors = {
      comercial: 'bg-gradient-to-r from-blue-100 to-blue-50 text-blue-800 border-blue-300',
      vacio: 'bg-gradient-to-r from-gray-100 to-gray-50 text-gray-800 border-gray-300'
    }
    return colors[tipo] || 'bg-gradient-to-r from-gray-100 to-gray-50 text-gray-800 border-gray-300'
  }, [])

  const getTipoLabel = useCallback((tipo) => {
    const labels = {
      comercial: 'Comercial',
      vacio: 'Vacío'
    }
    return labels[tipo] || tipo
  }, [])

  // Handler para limpiar filtros
  const handleClearFilters = useCallback(() => {
    setFilterTipo('')
    setFilterDuracion('')
    setShowFilters(false)
  }, [])

  // Handler para toggle de filtros
  const handleToggleFilters = useCallback(() => {
    setShowFilters(prev => !prev)
  }, [])

  const inputClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
    formMode === 'view' ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
  }`

  if (loading && cortes.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center h-64 space-y-4">
        <div className="relative">
          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
        <div className="text-gray-600 font-medium">Cargando cortes...</div>
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
                    <Scissors className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Gestión de Cortes</h1>
                    <p className="text-blue-100 text-sm">Administra cortes comerciales y vacíos</p>
                  </div>
                </div>
                
                {/* Action Buttons */}
                <div className="flex flex-wrap gap-3">
                  <button
                    onClick={handleNew}
                    className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                  >
                    <Plus className="w-5 h-5" />
                    <span>Nuevo Corte</span>
                  </button>
                  <button
                    onClick={handleToggleFilters}
                    className={`backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border ${
                      showFilters 
                        ? 'bg-white/30 border-white/40' 
                        : 'bg-white/20 hover:bg-white/30 border-white/30'
                    }`}
                  >
                    <Filter className="w-5 h-5" />
                    <span>Filtros</span>
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
                    placeholder="Buscar por nombre o descripción..."
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
                <div className="flex items-center gap-3 flex-wrap">
                  <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex items-center space-x-3">
                      <div className="w-4 h-4 bg-blue-500 rounded-full animate-pulse shadow-md"></div>
                      <div className="flex flex-col">
                        <span className="text-blue-800 font-bold text-sm">Activos</span>
                        <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.activos}</span>
                      </div>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-red-50 to-red-100 border-2 border-red-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex items-center space-x-3">
                      <div className="w-4 h-4 bg-red-500 rounded-full shadow-md"></div>
                      <div className="flex flex-col">
                        <span className="text-red-800 font-bold text-sm">Inactivos</span>
                        <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.inactivos}</span>
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
            {(showFilters || filterTipo || filterDuracion) && (
              <div className="px-8 py-4 bg-gradient-to-r from-blue-50 via-indigo-50 to-blue-50 border-b border-blue-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <Filter className="w-5 h-5 text-blue-600" />
                    <p className="text-blue-800 text-sm font-semibold">
                      {filterTipo && filterDuracion 
                        ? `Mostrando cortes de tipo "${filterTipo}" con duración "${filterDuracion}" (${filteredCortes.length} de ${cortes.length})`
                        : filterTipo 
                        ? `Mostrando cortes de tipo "${filterTipo}" (${filteredCortes.length} de ${cortes.length})`
                        : filterDuracion
                        ? `Mostrando cortes con duración "${filterDuracion}" (${filteredCortes.length} de ${cortes.length})`
                        : `Mostrando todos los cortes (${filteredCortes.length})`
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

            {/* Enhanced Filters Panel */}
            {showFilters && (
              <div className="px-8 py-4 bg-gradient-to-r from-gray-50 to-blue-50/20 border-b border-gray-200">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">Tipo</label>
                    <select
                      value={filterTipo}
                      onChange={(e) => setFilterTipo(e.target.value)}
                      className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 bg-white shadow-md transition-all duration-200 hover:border-gray-400"
                    >
                      <option value="">Todos los tipos</option>
                      <option value="comercial">Comercial</option>
                      <option value="vacio">Vacío</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">Duración</label>
                    <select
                      value={filterDuracion}
                      onChange={(e) => setFilterDuracion(e.target.value)}
                      className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 bg-white shadow-md transition-all duration-200 hover:border-gray-400"
                    >
                      <option value="">Todas las duraciones</option>
                      <option value="00:00:05">00:00:05</option>
                      <option value="00:00:08">00:00:08</option>
                      <option value="00:00:10">00:00:10</option>
                      <option value="00:00:15">00:00:15</option>
                      <option value="00:00:20">00:00:20</option>
                      <option value="00:00:25">00:00:25</option>
                      <option value="00:00:30">00:00:30</option>
                      <option value="00:01:00">00:01:00</option>
                    </select>
                  </div>
                </div>
                <div className="mt-4 flex justify-end">
                  <button
                    onClick={handleToggleFilters}
                    className="text-blue-600 hover:text-blue-800 text-sm font-semibold hover:underline transition-colors flex items-center space-x-1 px-3 py-1.5 rounded-lg hover:bg-blue-100"
                  >
                    <X className="w-4 h-4" />
                    <span>Cerrar filtros</span>
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
                      Estado
                    </th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Nombre
                    </th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Descripción
                    </th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Duración
                    </th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Tipo
                    </th>
                    <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                      Fecha Creación
                    </th>
                    <th className="px-6 py-4 text-center text-xs font-bold text-gray-700 uppercase tracking-wider w-48 sticky right-0 bg-gradient-to-r from-gray-100 to-gray-50 border-l-2 border-gray-300 shadow-lg">
                      Acciones
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {filteredCortes.length === 0 ? (
                    <tr>
                      <td colSpan="7" className="px-6 py-20 text-center">
                        <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
                          <Music className="w-12 h-12 text-gray-400" />
                        </div>
                        <h3 className="text-2xl font-bold text-gray-900 mb-3">No se encontraron cortes</h3>
                        <p className="text-gray-600 mb-6 max-w-md mx-auto text-base">
                          {error ? 
                            `Error: ${error}. Intenta recargar la página.` :
                            searchTerm || filterTipo || filterDuracion ?
                            'Intenta ajustar los filtros de búsqueda.' :
                            'Comienza agregando tu primer corte al sistema.'
                          }
                        </p>
                        {!searchTerm && !filterTipo && !filterDuracion && (
                          <button
                            onClick={handleNew}
                            className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold hover:shadow-xl transform hover:scale-105 hover:-translate-y-1 flex items-center space-x-2 mx-auto"
                          >
                            <Plus className="w-5 h-5" />
                            <span>Crear primer corte</span>
                          </button>
                        )}
                      </td>
                    </tr>
                  ) : (
                    filteredCortes.map((corte, index) => (
                      <tr key={corte.id} className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm ${
                            corte.activo 
                              ? 'bg-gradient-to-r from-green-100 to-green-50 text-green-800 border-green-300' 
                              : 'bg-gradient-to-r from-red-100 to-red-50 text-red-800 border-red-300'
                          }`}>
                            {corte.activo ? 'Activo' : 'Inactivo'}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                          <div className="max-w-64 truncate group-hover:text-blue-700 transition-colors" title={corte.nombre}>
                            {corte.nombre}
                          </div>
                        </td>
                        <td className="px-6 py-4 text-sm text-gray-600">
                          <div className="max-w-80 truncate" title={corte.descripcion}>
                            {corte.descripcion || '-'}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center text-sm font-medium text-gray-900">
                            <Clock className="w-4 h-4 text-gray-400 mr-2" />
                            {corte.duracion}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm ${getTipoColor(corte.tipo)}`}>
                            {getTipoLabel(corte.tipo)}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {corte.created_at ? new Date(corte.created_at).toLocaleDateString() : '-'}
                        </td>
                        <td className={`px-6 py-4 whitespace-nowrap text-sm font-medium sticky right-0 border-l-2 border-gray-300 shadow-lg ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                          <div className="flex justify-center space-x-2">
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                handleView(corte)
                              }}
                              className="p-2.5 text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-blue-200"
                              title="Ver detalles"
                            >
                              <Eye className="w-5 h-5" />
                            </button>
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                handleEdit(corte)
                              }}
                              className="p-2.5 text-yellow-600 hover:text-yellow-800 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-yellow-200"
                              title="Editar"
                            >
                              <Edit className="w-5 h-5" />
                            </button>
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                handleDelete(corte)
                              }}
                              className="p-2.5 text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-red-200"
                              title="Eliminar"
                            >
                              <Trash2 className="w-5 h-5" />
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
        </div>

        {/* Enhanced Form Modal */}
        {showForm && (
          <div 
            className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200"
            onClick={(e) => {
              if (e.target === e.currentTarget) {
                handleCloseForm()
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
                      <Scissors className="w-6 h-6 text-white" />
                    </div>
                    <h1 className="text-2xl font-bold text-white">
                      {formMode === 'new' ? 'Nuevo Corte' : 
                       formMode === 'edit' ? 'Editar Corte' : 'Consultar Corte'}
                    </h1>
                  </div>
                  <button
                    onClick={handleCloseForm}
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

              {/* Enhanced Form Content */}
              <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
                <div className="space-y-6">
                  {/* Activo checkbox */}
                  <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm">
                    <input
                      type="checkbox"
                      name="activo"
                      checked={formData.activo}
                      onChange={handleInputChange}
                      disabled={formMode === 'view'}
                      className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer disabled:cursor-not-allowed"
                    />
                    <label className="text-base font-semibold text-gray-700 cursor-pointer">Activo</label>
                  </div>

                  {/* Form fields */}
                  <div className="space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      {/* Nombre */}
                      <div className="md:col-span-2">
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Nombre <span className="text-red-500">*</span>
                        </label>
                        <input
                          type="text"
                          name="nombre"
                          value={formData.nombre}
                          onChange={handleInputChange}
                          disabled={formMode === 'view'}
                          className={inputClass}
                          placeholder="Nombre del corte"
                        />
                        {formErrors.nombre && (
                          <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                            <AlertCircle className="w-4 h-4" />
                            <span>{formErrors.nombre}</span>
                          </p>
                        )}
                      </div>

                      {/* Descripción */}
                      <div className="md:col-span-2">
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Descripción
                        </label>
                        <textarea
                          name="descripcion"
                          value={formData.descripcion || ''}
                          onChange={handleInputChange}
                          disabled={formMode === 'view'}
                          rows="3"
                          className={inputClass}
                          placeholder="Descripción del corte"
                        />
                      </div>

                      {/* Duración */}
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Duración <span className="text-red-500">*</span> (HH:MM:SS)
                        </label>
                        <input
                          type="text"
                          name="duracion"
                          value={formData.duracion}
                          onChange={handleInputChange}
                          disabled={formMode === 'view'}
                          className={inputClass}
                          placeholder="00:00:30"
                        />
                        {formErrors.duracion && (
                          <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                            <AlertCircle className="w-4 h-4" />
                            <span>{formErrors.duracion}</span>
                          </p>
                        )}
                      </div>

                      {/* Tipo */}
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Tipo <span className="text-red-500">*</span>
                        </label>
                        <select
                          name="tipo"
                          value={formData.tipo}
                          onChange={handleInputChange}
                          disabled={formMode === 'view'}
                          className={inputClass}
                        >
                          <option value="comercial">Comercial</option>
                          <option value="vacio">Vacío</option>
                        </select>
                      </div>

                      {/* Observaciones */}
                      <div className="md:col-span-2">
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Observaciones
                        </label>
                        <textarea
                          name="observaciones"
                          value={formData.observaciones || ''}
                          onChange={handleInputChange}
                          disabled={formMode === 'view'}
                          rows="4"
                          className={inputClass}
                          placeholder="Observaciones adicionales"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              {/* Enhanced Footer with Action Buttons */}
              {formMode !== 'view' && (
                <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end space-x-3 shadow-inner">
                  <button
                    type="button"
                    onClick={handleCloseForm}
                    disabled={loading}
                    className="px-8 py-3 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-xl transition-all duration-300 disabled:opacity-50 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
                  >
                    <X className="w-5 h-5" />
                    <span>Cancelar</span>
                  </button>
                  <button
                    type="button"
                    onClick={handleSave}
                    disabled={loading}
                    className="px-8 py-3 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white rounded-xl transition-all duration-300 disabled:opacity-50 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
                  >
                    {loading ? (
                      <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    ) : (
                      <CheckCircle className="w-5 h-5" />
                    )}
                    <span>{loading ? 'Guardando...' : formMode === 'new' ? 'Crear' : 'Guardar'}</span>
                  </button>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </>
  )
}
