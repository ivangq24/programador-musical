'use client'

import { useState, useEffect } from 'react'
import { usuariosApi } from '../../../../api/auth/usuariosApi'
import { 
  User, 
  Mail, 
  Shield, 
  Building, 
  Edit, 
  Lock, 
  Trash2,
  Save,
  X,
  Loader2,
  AlertCircle,
  CheckCircle,
  Eye,
  EyeOff
} from 'lucide-react'
import { useAuth } from '@/hooks/useAuth'
import { useRouter } from 'next/navigation'
import EditarPerfilModal from './EditarPerfilModal'
import CambiarContrasenaModal from './CambiarContrasenaModal'
import EliminarCuentaModal from './EliminarCuentaModal'

export default function MiPerfil() {
  const { user: authUser, logout } = useAuth()
  const router = useRouter()
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [showEditModal, setShowEditModal] = useState(false)
  const [showPasswordModal, setShowPasswordModal] = useState(false)
  const [showDeleteModal, setShowDeleteModal] = useState(false)
  
  const loadProfile = async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await usuariosApi.getMyProfile()
      setProfile(data)
    } catch (err) {
      console.error('Error cargando perfil:', err)
      setError(err.response?.data?.detail || err.message || 'Error al cargar perfil')
    } finally {
      setLoading(false)
    }
  }
  
  useEffect(() => {
    loadProfile()
  }, [])
  
  const handleUpdateSuccess = () => {
    setShowEditModal(false)
    loadProfile()
    // Actualizar el usuario en el hook de auth si es necesario
    window.location.reload() // Simple refresh para actualizar datos
  }
  
  const handlePasswordSuccess = () => {
    setShowPasswordModal(false)
    // Mostrar mensaje de éxito
    alert('Contraseña cambiada exitosamente')
  }
  
  const handleDeleteSuccess = async () => {
    setShowDeleteModal(false)
    // Cerrar sesión y redirigir
    await logout()
    router.push('/auth/login')
  }
  
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
  
  if (loading) {
    return (
      <div className="h-full flex items-center justify-center">
        <Loader2 className="w-8 h-8 text-indigo-600 animate-spin" />
      </div>
    )
  }
  
  if (error && !profile) {
    return (
      <div className="h-full flex items-center justify-center">
        <div className="bg-red-50 border border-red-200 rounded-xl p-6 max-w-md">
          <div className="flex items-center space-x-3 mb-4">
            <AlertCircle className="w-6 h-6 text-red-600" />
            <h3 className="text-lg font-semibold text-red-800">Error</h3>
          </div>
          <p className="text-red-700 mb-4">{error}</p>
          <button
            onClick={loadProfile}
            className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
          >
            Reintentar
          </button>
        </div>
      </div>
    )
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
                <User className="w-8 h-8 text-white" />
              </div>
              <div>
                <h3 className="text-3xl font-bold text-white mb-1">Mi Perfil</h3>
                <p className="text-indigo-100 text-base">Gestiona tu información personal y cuenta</p>
              </div>
            </div>
          </div>
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
          <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
        </div>
      </div>
      
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
      
      {/* Información del usuario */}
      {profile && (
        <div className="flex-1 overflow-y-auto space-y-6">
          {/* Tarjeta de información */}
          <div className="bg-white rounded-2xl shadow-xl border border-gray-200 p-6">
            <div className="flex items-start justify-between mb-6">
              <div className="flex items-center space-x-4">
                <div className="w-20 h-20 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center">
                  <span className="text-white font-bold text-3xl">
                    {profile.nombre.charAt(0).toUpperCase()}
                  </span>
                </div>
                <div>
                  <h4 className="text-2xl font-bold text-gray-900">{profile.nombre}</h4>
                  <p className="text-gray-600">{profile.email}</p>
                </div>
              </div>
              <span className={`px-4 py-2 rounded-full text-sm font-semibold border ${getRolColor(profile.rol)}`}>
                {getRolName(profile.rol)}
              </span>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center">
                  <Mail className="w-5 h-5 text-indigo-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Email</p>
                  <p className="font-medium text-gray-900">{profile.email}</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                  <Shield className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Rol</p>
                  <p className="font-medium text-gray-900">{getRolName(profile.rol)}</p>
                </div>
              </div>
              
              {profile.difusoras && profile.difusoras.length > 0 && (
                <div className="flex items-start space-x-3 md:col-span-2">
                  <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                    <Building className="w-5 h-5 text-green-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-sm text-gray-500 mb-2">Difusoras Asignadas</p>
                    <div className="flex flex-wrap gap-2">
                      {profile.difusoras.map((sigla, idx) => (
                        <span
                          key={idx}
                          className="px-3 py-1 bg-indigo-50 text-indigo-700 rounded-md text-sm font-medium"
                        >
                          {sigla}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
          
          {/* Acciones */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <button
              onClick={() => setShowEditModal(true)}
              className="bg-white rounded-2xl shadow-xl border border-gray-200 p-6 hover:shadow-2xl transition-all duration-300 text-left group"
            >
              <div className="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center mb-4 group-hover:bg-indigo-200 transition-colors">
                <Edit className="w-6 h-6 text-indigo-600" />
              </div>
              <h5 className="font-bold text-gray-900 mb-2">Editar Perfil</h5>
              <p className="text-sm text-gray-600">Actualiza tu nombre y email</p>
            </button>
            
            <button
              onClick={() => setShowPasswordModal(true)}
              className="bg-white rounded-2xl shadow-xl border border-gray-200 p-6 hover:shadow-2xl transition-all duration-300 text-left group"
            >
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mb-4 group-hover:bg-blue-200 transition-colors">
                <Lock className="w-6 h-6 text-blue-600" />
              </div>
              <h5 className="font-bold text-gray-900 mb-2">Cambiar Contraseña</h5>
              <p className="text-sm text-gray-600">Actualiza tu contraseña de acceso</p>
            </button>
            
            <button
              onClick={() => setShowDeleteModal(true)}
              className="bg-white rounded-2xl shadow-xl border border-red-200 p-6 hover:shadow-2xl transition-all duration-300 text-left group"
            >
              <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center mb-4 group-hover:bg-red-200 transition-colors">
                <Trash2 className="w-6 h-6 text-red-600" />
              </div>
              <h5 className="font-bold text-gray-900 mb-2">Eliminar Cuenta</h5>
              <p className="text-sm text-gray-600">Elimina tu cuenta permanentemente</p>
            </button>
          </div>
        </div>
      )}
      
      {/* Modales */}
      {showEditModal && profile && (
        <EditarPerfilModal
          profile={profile}
          onClose={() => setShowEditModal(false)}
          onSuccess={handleUpdateSuccess}
        />
      )}
      
      {showPasswordModal && (
        <CambiarContrasenaModal
          onClose={() => setShowPasswordModal(false)}
          onSuccess={handlePasswordSuccess}
        />
      )}
      
      {showDeleteModal && (
        <EliminarCuentaModal
          onClose={() => setShowDeleteModal(false)}
          onSuccess={handleDeleteSuccess}
        />
      )}
    </div>
  )
}

