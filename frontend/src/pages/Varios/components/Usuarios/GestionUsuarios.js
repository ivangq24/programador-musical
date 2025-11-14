'use client'

import { useState, useEffect, useCallback } from 'react'
import { usuariosApi } from '../../../../api/auth/usuariosApi'
import { getDifusoras } from '../../../../api/catalogos/generales/difusorasApi'
import { 
  Users, 
  UserPlus, 
  Search, 
  Filter, 
  Edit, 
  Trash2, 
  Shield,
  Building,
  X,
  Check,
  XCircle,
  Loader2,
  AlertCircle,
  ChevronDown
} from 'lucide-react'
import InvitarUsuarioForm from './InvitarUsuarioForm'
import AsignarDifusorasModal from './AsignarDifusorasModal'

export default function GestionUsuarios() {
  const [usuarios, setUsuarios] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [showInvitarForm, setShowInvitarForm] = useState(false)
  const [showAsignarModal, setShowAsignarModal] = useState(false)
  const [usuarioSeleccionado, setUsuarioSeleccionado] = useState(null)
  const [difusoras, setDifusoras] = useState([])
  
  // Filtros
  const [search, setSearch] = useState('')
  const [rolFilter, setRolFilter] = useState('')
  const [activoFilter, setActivoFilter] = useState('')
  
  // Cargar usuarios
  const loadUsuarios = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      
      const params = {}
      if (search) params.search = search
      if (rolFilter) params.rol = rolFilter
      if (activoFilter !== '') params.activo = activoFilter === 'true'
      
      const data = await usuariosApi.getUsuarios(params)
      setUsuarios(data)
    } catch (err) {

      setError(err.response?.data?.detail || err.message || 'Error al cargar usuarios')
    } finally {
      setLoading(false)
    }
  }, [search, rolFilter, activoFilter])
  
  // Cargar difusoras
  const loadDifusoras = useCallback(async () => {
    try {
      const data = await getDifusoras({ activa: true })
      setDifusoras(data)
    } catch (err) {

    }
  }, [])
  
  useEffect(() => {
    loadUsuarios()
    loadDifusoras()
  }, [loadUsuarios, loadDifusoras])
  
  // Manejar invitación exitosa
  const handleInvitarSuccess = () => {
    setShowInvitarForm(false)
    loadUsuarios()
  }
  
  // Manejar asignación exitosa
  const handleAsignarSuccess = () => {
    setShowAsignarModal(false)
    setUsuarioSeleccionado(null)
    loadUsuarios()
  }
  
  // Abrir modal de asignar difusoras
  const handleAsignarDifusoras = (usuario) => {
    setUsuarioSeleccionado(usuario)
    setShowAsignarModal(true)
  }
  
  // Actualizar usuario
  const handleUpdateUsuario = async (usuarioId, updates) => {
    try {
      await usuariosApi.updateUsuario(usuarioId, updates)
      loadUsuarios()
    } catch (err) {

      setError(err.response?.data?.detail || err.message || 'Error al actualizar usuario')
    }
  }
  
  // Cambiar estado activo/inactivo
  const handleToggleActivo = async (usuario) => {
    await handleUpdateUsuario(usuario.id, { activo: !usuario.activo })
  }
  
  // Cambiar rol
  const handleChangeRol = async (usuario, newRol) => {
    if (!confirm(`¿Cambiar rol de ${usuario.nombre} a ${newRol}?`)) {
      return
    }
    await handleUpdateUsuario(usuario.id, { rol: newRol })
  }
  
  // Obtener color del rol
  const getRolColor = (rol) => {
    switch (rol) {
      case 'admin':
        return 'bg-red-100 text-red-800 border-red-300'
      case 'manager':
        return 'bg-blue-100 text-blue-800 border-blue-300'
      case 'operador':
        return 'bg-green-100 text-green-800 border-green-300'
      default:
        return 'bg-gray-100 text-gray-800 border-gray-300'
    }
  }
  
  // Obtener nombre del rol
  const getRolName = (rol) => {
    switch (rol) {
      case 'admin':
        return 'Administrador'
      case 'manager':
        return 'Gerente'
      case 'operador':
        return 'Operador'
      default:
        return rol
    }
  }
  
  return (
    <div className="h-full flex flex-col bg-gradient-to-br from-slate-50 via-white to-slate-100">
      {/* Header */}
      <div className="bg-white rounded-2xl shadow-2xl border border-white/20 overflow-hidden mb-6">
        <div className="bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 p-8 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-indigo-600/90 to-purple-600/90"></div>
          <div className="relative z-10 flex items-center justify-between">
            <div className="flex items-center space-x-5">
              <div className="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                <Users className="w-8 h-8 text-white" />
              </div>
              <div>
                <h3 className="text-3xl font-bold text-white mb-1">Gestión de Usuarios</h3>
                <p className="text-indigo-100 text-base">Administra usuarios y permisos del sistema</p>
              </div>
            </div>
            <button
              onClick={() => setShowInvitarForm(true)}
              className="px-6 py-3 bg-white/20 hover:bg-white/30 backdrop-blur-sm rounded-xl text-white font-semibold flex items-center space-x-2 transition-all duration-200 shadow-lg hover:shadow-xl"
            >
              <UserPlus className="w-5 h-5" />
              <span>Invitar Usuario</span>
            </button>
          </div>
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
          <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
        </div>
      </div>
      
      {/* Filtros */}
      <div className="bg-white rounded-2xl shadow-xl border border-gray-200 p-6 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Buscar por nombre o email..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
            />
          </div>
          
          <div className="relative">
            <select
              value={rolFilter}
              onChange={(e) => setRolFilter(e.target.value)}
              className="w-full px-4 py-2 pr-10 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all hover:border-gray-400 bg-white cursor-pointer appearance-none"
            >
              <option value="">Todos los roles</option>
              <option value="admin">Administrador</option>
              <option value="manager">Gerente</option>
              <option value="operador">Operador</option>
            </select>
            <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
          </div>
          
          <div className="relative">
            <select
              value={activoFilter}
              onChange={(e) => setActivoFilter(e.target.value)}
              className="w-full px-4 py-2 pr-10 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all hover:border-gray-400 bg-white cursor-pointer appearance-none"
            >
              <option value="">Todos los estados</option>
              <option value="true">Activos</option>
              <option value="false">Inactivos</option>
            </select>
            <ChevronDown className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
          </div>
        </div>
      </div>
      
      {/* Error */}
      {error && (
        <div className="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 flex items-center space-x-3">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0" />
          <p className="text-red-800">{error}</p>
          <button
            onClick={() => setError(null)}
            className="ml-auto text-red-600 hover:text-red-800"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      )}
      
      {/* Lista de usuarios */}
      <div className="flex-1 overflow-y-auto">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <Loader2 className="w-8 h-8 text-indigo-600 animate-spin" />
          </div>
        ) : usuarios.length === 0 ? (
          <div className="bg-white rounded-2xl shadow-xl border border-gray-200 p-12 text-center">
            <Users className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600 text-lg">No se encontraron usuarios</p>
            <p className="text-gray-500 text-sm mt-2">Intenta ajustar los filtros de búsqueda</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 gap-4">
            {usuarios.map((usuario) => (
              <div
                key={usuario.id}
                className="bg-white rounded-2xl shadow-xl border border-gray-200 hover:shadow-2xl transition-all duration-300 p-6"
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center space-x-4 mb-3">
                      <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center">
                        <span className="text-white font-bold text-lg">
                          {usuario.nombre.charAt(0).toUpperCase()}
                        </span>
                      </div>
                      <div>
                        <h4 className="text-xl font-bold text-gray-900">{usuario.nombre}</h4>
                        <p className="text-gray-600 text-sm">{usuario.email}</p>
                      </div>
                      <span className={`px-3 py-1 rounded-full text-xs font-semibold border ${getRolColor(usuario.rol)}`}>
                        {getRolName(usuario.rol)}
                      </span>
                      {usuario.activo ? (
                        <span className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold flex items-center space-x-1">
                          <Check className="w-3 h-3" />
                          <span>Activo</span>
                        </span>
                      ) : (
                        <span className="px-3 py-1 bg-red-100 text-red-800 rounded-full text-xs font-semibold flex items-center space-x-1">
                          <XCircle className="w-3 h-3" />
                          <span>Inactivo</span>
                        </span>
                      )}
                    </div>
                    
                    {/* Difusoras asignadas */}
                    {usuario.difusoras && usuario.difusoras.length > 0 && (
                      <div className="mt-4 flex items-center space-x-2 flex-wrap gap-2">
                        <Building className="w-4 h-4 text-gray-400" />
                        {usuario.difusoras.map((sigla, idx) => (
                          <span
                            key={idx}
                            className="px-2 py-1 bg-indigo-50 text-indigo-700 rounded-md text-xs font-medium"
                          >
                            {sigla}
                          </span>
                        ))}
                      </div>
                    )}
                  </div>
                  
                  {/* Acciones */}
                  <div className="flex items-center space-x-2 ml-4">
                    <button
                      onClick={() => handleAsignarDifusoras(usuario)}
                      className="p-2 text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors"
                      title="Asignar difusoras"
                    >
                      <Building className="w-5 h-5" />
                    </button>
                    
                    <div className="relative">
                      <select
                        value={usuario.rol}
                        onChange={(e) => handleChangeRol(usuario, e.target.value)}
                        className="px-3 py-1 pr-8 border-2 border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-all hover:border-gray-400 bg-white cursor-pointer appearance-none"
                        title="Cambiar rol"
                      >
                        <option value="operador">Operador</option>
                        <option value="manager">Gerente</option>
                        <option value="admin">Administrador</option>
                      </select>
                      <ChevronDown className="absolute right-2 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                    </div>
                    
                    <button
                      onClick={() => handleToggleActivo(usuario)}
                      className={`p-2 rounded-lg transition-colors ${
                        usuario.activo
                          ? 'text-red-600 hover:bg-red-50'
                          : 'text-green-600 hover:bg-green-50'
                      }`}
                      title={usuario.activo ? 'Desactivar' : 'Activar'}
                    >
                      {usuario.activo ? (
                        <XCircle className="w-5 h-5" />
                      ) : (
                        <Check className="w-5 h-5" />
                      )}
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
      
      {/* Modales */}
      {showInvitarForm && (
        <InvitarUsuarioForm
          onClose={() => setShowInvitarForm(false)}
          onSuccess={handleInvitarSuccess}
          difusoras={difusoras}
        />
      )}
      
      {showAsignarModal && usuarioSeleccionado && (
        <AsignarDifusorasModal
          usuario={usuarioSeleccionado}
          difusoras={difusoras}
          onClose={() => {
            setShowAsignarModal(false)
            setUsuarioSeleccionado(null)
          }}
          onSuccess={handleAsignarSuccess}
        />
      )}
    </div>
  )
}

