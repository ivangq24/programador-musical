'use client'

import { useState, useEffect } from 'react'
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
  MoreVertical
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
  // Estados principales
  const [cortes, setCortes] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [showForm, setShowForm] = useState(false)
  const [formMode, setFormMode] = useState('new') // 'new', 'edit', 'view'
  const [selectedCorte, setSelectedCorte] = useState(null)
  
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

  // Datos mock para desarrollo
  const mockCortes = [
    {
      id: 1,
      nombre: 'Corte Comercial - Restaurante ABC',
      descripcion: 'Corte comercial para restaurante local',
      duracion: '00:00:30',
      tipo: 'comercial',
      activo: true,
      observaciones: 'Corte para promoción de menú especial',
      created_at: '2024-01-15T10:30:00Z',
      updated_at: '2024-01-15T10:30:00Z'
    },
    {
      id: 2,
      nombre: 'Corte Comercial - Tienda de Ropa',
      descripcion: 'Corte comercial para tienda de ropa',
      duracion: '00:00:15',
      tipo: 'comercial',
      activo: true,
      observaciones: 'Promoción de temporada de verano',
      created_at: '2024-01-14T09:15:00Z',
      updated_at: '2024-01-14T09:15:00Z'
    },
    {
      id: 3,
      nombre: 'Corte Vacío - Identificación Estación',
      descripcion: 'Corte vacío para identificación de estación',
      duracion: '00:00:10',
      tipo: 'vacio',
      activo: true,
      observaciones: 'Corte vacío para identificación principal',
      created_at: '2024-01-13T14:20:00Z',
      updated_at: '2024-01-13T14:20:00Z'
    },
    {
      id: 4,
      nombre: 'Corte Vacío - Jingle Musical',
      descripcion: 'Corte vacío para jingle musical',
      duracion: '00:00:05',
      tipo: 'vacio',
      activo: true,
      observaciones: 'Jingle vacío para transiciones',
      created_at: '2024-01-12T11:45:00Z',
      updated_at: '2024-01-12T11:45:00Z'
    },
    {
      id: 5,
      nombre: 'Corte Comercial - Gimnasio Fit',
      descripcion: 'Corte comercial para gimnasio',
      duracion: '00:00:20',
      tipo: 'comercial',
      activo: true,
      observaciones: 'Promoción de membresías',
      created_at: '2024-01-11T16:30:00Z',
      updated_at: '2024-01-11T16:30:00Z'
    },
    {
      id: 6,
      nombre: 'Corte Vacío - Slogan Estación',
      descripcion: 'Corte vacío con slogan de estación',
      duracion: '00:00:08',
      tipo: 'vacio',
      activo: false,
      observaciones: 'Corte vacío desactivado temporalmente',
      created_at: '2024-01-10T08:15:00Z',
      updated_at: '2024-01-10T08:15:00Z'
    }
  ]

  // Cargar datos al inicializar
  useEffect(() => {
    loadCortes()
  }, [])

  // Recargar datos cuando cambien los filtros
  useEffect(() => {
    loadCortes()
  }, [filterTipo, searchTerm])

  const loadCortes = async () => {
    setLoading(true)
    setError(null)
    try {
      const params = {
        tipo: filterTipo || undefined,
        activo: undefined, // Mostrar todos por defecto
        search: searchTerm || undefined
      }
      
      const response = await getCortes(params)
      setCortes(response.cortes || [])
    } catch (error) {
      setError('Error al cargar los cortes')
      console.error('Error:', error)
      // Fallback a datos mock en caso de error
      setCortes(mockCortes)
    } finally {
      setLoading(false)
    }
  }

  // Filtrar cortes
  const filteredCortes = cortes.filter(corte => {
    const matchesSearch = corte.nombre.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         corte.descripcion.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesDuracion = !filterDuracion || corte.duracion === filterDuracion
    const matchesTipo = !filterTipo || corte.tipo === filterTipo
    
    return matchesSearch && matchesDuracion && matchesTipo
  })

  // Manejar formulario
  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }))
    
    // Limpiar error del campo
    if (formErrors[name]) {
      setFormErrors(prev => ({
        ...prev,
        [name]: ''
      }))
    }
  }

  const validateForm = () => {
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
  }

  const handleSave = async () => {
    if (!validateForm()) return
    
    setLoading(true)
    setError(null)
    try {
      if (formMode === 'new') {
        const newCorte = await createCorte(formData)
        setCortes(prev => [newCorte, ...prev])
      } else if (formMode === 'edit') {
        const updatedCorte = await updateCorte(selectedCorte.id, formData)
        setCortes(prev => prev.map(corte => 
          corte.id === selectedCorte.id ? updatedCorte : corte
        ))
      }
      
      handleCloseForm()
    } catch (err) {
      setError('Error al guardar el corte')
      console.error('Error saving corte:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleEdit = (corte) => {
    setSelectedCorte(corte)
    setFormData({
      nombre: corte.nombre,
      descripcion: corte.descripcion,
      duracion: corte.duracion,
      tipo: corte.tipo,
      activo: corte.activo,
      observaciones: corte.observaciones
    })
    setFormMode('edit')
    setShowForm(true)
  }

  const handleView = (corte) => {
    setSelectedCorte(corte)
    setFormData({
      nombre: corte.nombre,
      descripcion: corte.descripcion,
      duracion: corte.duracion,
      tipo: corte.tipo,
      activo: corte.activo,
      observaciones: corte.observaciones
    })
    setFormMode('view')
    setShowForm(true)
  }

  const handleDelete = async (corte) => {
    if (window.confirm(`¿Estás seguro de que deseas eliminar el corte "${corte.nombre}"?`)) {
      setLoading(true)
      setError(null)
      try {
        await deleteCorte(corte.id)
        setCortes(prev => prev.filter(c => c.id !== corte.id))
      } catch (err) {
        setError('Error al eliminar el corte')
        console.error('Error deleting corte:', err)
      } finally {
        setLoading(false)
      }
    }
  }

  const handleNew = () => {
    setSelectedCorte(null)
    setFormData({
      nombre: '',
      descripcion: '',
      duracion: '',
      tipo: 'comercial',
      activo: true,
      observaciones: ''
    })
    setFormMode('new')
    setShowForm(true)
  }

  const handleCloseForm = () => {
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
  }

  const getTipoColor = (tipo) => {
    const colors = {
      comercial: 'bg-blue-100 text-blue-800',
      vacio: 'bg-gray-100 text-gray-800'
    }
    return colors[tipo] || 'bg-gray-100 text-gray-800'
  }

  const getTipoLabel = (tipo) => {
    const labels = {
      comercial: 'Comercial',
      vacio: 'Vacío'
    }
    return labels[tipo] || tipo
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 px-6 py-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Gestión de Cortes</h1>
            <p className="text-sm text-gray-600 mt-1">Administra cortes comerciales y vacíos</p>
          </div>
          <button
            onClick={handleNew}
            className="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Plus className="w-4 h-4" />
            <span>Nuevo Corte</span>
          </button>
        </div>
      </div>

      {/* Contenido principal */}
      <div className="flex-1 overflow-hidden">
        <div className="h-full flex flex-col">
          {/* Barra de búsqueda y filtros */}
          <div className="bg-white border-b border-gray-200 px-6 py-4">
            <div className="flex items-center space-x-4">
              {/* Búsqueda */}
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <input
                  type="text"
                  placeholder="Buscar cortes..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
              
              {/* Botón de filtros */}
              <button
                onClick={() => setShowFilters(!showFilters)}
                className={`flex items-center space-x-2 px-4 py-2 rounded-lg border transition-colors ${
                  showFilters 
                    ? 'bg-blue-50 border-blue-300 text-blue-700' 
                    : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
                }`}
              >
                <Filter className="w-4 h-4" />
                <span>Filtros</span>
              </button>
            </div>

            {/* Panel de filtros */}
            {showFilters && (
              <div className="mt-4 p-4 bg-gray-50 rounded-lg">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Tipo</label>
                    <select
                      value={filterTipo}
                      onChange={(e) => setFilterTipo(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Todos los tipos</option>
                      <option value="comercial">Comercial</option>
                      <option value="vacio">Vacío</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Duración</label>
                    <select
                      value={filterDuracion}
                      onChange={(e) => setFilterDuracion(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
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
              </div>
            )}
          </div>

          {/* Tabla de cortes */}
          <div className="flex-1 overflow-auto">
            {loading ? (
              <div className="flex items-center justify-center h-full">
                <div className="text-center">
                  <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                  <p className="mt-4 text-gray-600">Cargando cortes...</p>
                </div>
              </div>
            ) : error ? (
              <div className="flex items-center justify-center h-full">
                <div className="text-center">
                  <AlertCircle className="w-12 h-12 text-red-500 mx-auto mb-4" />
                  <p className="text-red-600">{error}</p>
                  <button
                    onClick={loadCortes}
                    className="mt-4 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
                  >
                    Reintentar
                  </button>
                </div>
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Estado
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Nombre
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Descripción
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Duración
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Tipo
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Fecha Creación
                      </th>
                      <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider w-40">
                        Acciones
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {filteredCortes.length === 0 ? (
                      <tr>
                        <td colSpan="7" className="px-6 py-12 text-center text-gray-500">
                          <Music className="w-12 h-12 text-gray-300 mx-auto mb-4" />
                          <p className="text-lg font-medium">No se encontraron cortes</p>
                          <p className="text-sm">Intenta ajustar los filtros de búsqueda</p>
                        </td>
                      </tr>
                    ) : (
                      filteredCortes.map((corte) => (
                        <tr key={corte.id} className="hover:bg-gray-50">
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                              corte.activo 
                                ? 'bg-green-100 text-green-800' 
                                : 'bg-red-100 text-red-800'
                            }`}>
                              {corte.activo ? 'Activo' : 'Inactivo'}
                            </span>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <div className="text-sm font-medium text-gray-900">{corte.nombre}</div>
                          </td>
                          <td className="px-6 py-4">
                            <div className="text-sm text-gray-900 max-w-xs truncate" title={corte.descripcion}>
                              {corte.descripcion}
                            </div>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <div className="flex items-center text-sm text-gray-900">
                              <Clock className="w-4 h-4 text-gray-400 mr-2" />
                              {corte.duracion}
                            </div>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getTipoColor(corte.tipo)}`}>
                              {getTipoLabel(corte.tipo)}
                            </span>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {new Date(corte.created_at).toLocaleDateString()}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-center">
                            <div className="flex items-center justify-center space-x-2">
                              <button
                                onClick={() => handleView(corte)}
                                className="p-2 text-blue-600 hover:text-blue-900 hover:bg-blue-50 rounded-lg transition-colors"
                                title="Ver detalles"
                              >
                                <Eye className="w-4 h-4" />
                              </button>
                              <button
                                onClick={() => handleEdit(corte)}
                                className="p-2 text-green-600 hover:text-green-900 hover:bg-green-50 rounded-lg transition-colors"
                                title="Editar"
                              >
                                <Edit className="w-4 h-4" />
                              </button>
                              <button
                                onClick={() => handleDelete(corte)}
                                className="p-2 text-red-600 hover:text-red-900 hover:bg-red-50 rounded-lg transition-colors"
                                title="Eliminar"
                              >
                                <Trash2 className="w-4 h-4" />
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Modal de formulario */}
      {showForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
            {/* Header del modal */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-semibold text-gray-900">
                  {formMode === 'new' ? 'Nuevo Corte' : 
                   formMode === 'edit' ? 'Editar Corte' : 'Ver Corte'}
                </h2>
                <button
                  onClick={handleCloseForm}
                  className="text-gray-400 hover:text-gray-600 transition-colors"
                >
                  <X className="w-6 h-6" />
                </button>
              </div>
            </div>

            {/* Contenido del formulario */}
            <div className="px-6 py-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {/* Nombre */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Nombre *
                  </label>
                  <input
                    type="text"
                    name="nombre"
                    value={formData.nombre}
                    onChange={handleInputChange}
                    disabled={formMode === 'view'}
                    className={`w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
                      formErrors.nombre ? 'border-red-300' : 'border-gray-300'
                    } ${formMode === 'view' ? 'bg-gray-50' : ''}`}
                    placeholder="Nombre del corte"
                  />
                  {formErrors.nombre && (
                    <p className="mt-1 text-sm text-red-600">{formErrors.nombre}</p>
                  )}
                </div>

                {/* Descripción */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Descripción
                  </label>
                  <textarea
                    name="descripcion"
                    value={formData.descripcion}
                    onChange={handleInputChange}
                    disabled={formMode === 'view'}
                    rows="3"
                    className={`w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
                      formMode === 'view' ? 'bg-gray-50' : 'border-gray-300'
                    }`}
                    placeholder="Descripción del corte"
                  />
                </div>

                {/* Duración */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Duración * (HH:MM:SS)
                  </label>
                  <input
                    type="text"
                    name="duracion"
                    value={formData.duracion}
                    onChange={handleInputChange}
                    disabled={formMode === 'view'}
                    className={`w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
                      formErrors.duracion ? 'border-red-300' : 'border-gray-300'
                    } ${formMode === 'view' ? 'bg-gray-50' : ''}`}
                    placeholder="00:00:30"
                  />
                  {formErrors.duracion && (
                    <p className="mt-1 text-sm text-red-600">{formErrors.duracion}</p>
                  )}
                </div>

                {/* Tipo */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Tipo *
                  </label>
                  <select
                    name="tipo"
                    value={formData.tipo}
                    onChange={handleInputChange}
                    disabled={formMode === 'view'}
                    className={`w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
                      formMode === 'view' ? 'bg-gray-50' : 'border-gray-300'
                    }`}
                  >
                    <option value="comercial">Comercial</option>
                    <option value="vacio">Vacío</option>
                  </select>
                </div>

                {/* Activo */}
                <div className="md:col-span-2">
                  <label className="flex items-center">
                    <input
                      type="checkbox"
                      name="activo"
                      checked={formData.activo}
                      onChange={handleInputChange}
                      disabled={formMode === 'view'}
                      className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                    <span className="ml-2 text-sm font-medium text-gray-700">
                      Corte activo
                    </span>
                  </label>
                </div>

                {/* Observaciones */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Observaciones
                  </label>
                  <textarea
                    name="observaciones"
                    value={formData.observaciones}
                    onChange={handleInputChange}
                    disabled={formMode === 'view'}
                    rows="3"
                    className={`w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
                      formMode === 'view' ? 'bg-gray-50' : 'border-gray-300'
                    }`}
                    placeholder="Observaciones adicionales"
                  />
                </div>
              </div>
            </div>

            {/* Footer del modal */}
            {formMode !== 'view' && (
              <div className="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
                <button
                  onClick={handleCloseForm}
                  className="px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  Cancelar
                </button>
                <button
                  onClick={handleSave}
                  disabled={loading}
                  className="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  {loading ? (
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  ) : (
                    <Save className="w-4 h-4" />
                  )}
                  <span>{formMode === 'new' ? 'Crear' : 'Guardar'}</span>
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
