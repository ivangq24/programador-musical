'use client'

import { useState } from 'react'
import { usuariosApi } from '../../../../api/auth/usuariosApi'
import { X, UserPlus, Mail, User, Shield, Building, Loader2, AlertCircle, CheckCircle, Copy } from 'lucide-react'

export default function InvitarUsuarioForm({ onClose, onSuccess, difusoras = [] }) {
  const [formData, setFormData] = useState({
    email: '',
ombre: '',
    rol: 'operador',
    difusoras_ids: []
  })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [success, setSuccess] = useState(null)
  const [temporaryPassword, setTemporaryPassword] = useState(null)
  const [response, setResponse] = useState(null)
  
  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value
    }))
  }
  
  const handleDifusoraToggle = (difusoraId) => {
    setFormData(prev => ({
      ...prev,
      difusoras_ids: prev.difusoras_ids.includes(difusoraId)
        ? prev.difusoras_ids.filter(id => id !== difusoraId)
        : [...prev.difusoras_ids, difusoraId]
    }))
  }
  
  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setSuccess(null)
    
    try {
      const response = await usuariosApi.invitarUsuario(formData)
      setResponse(response)
      setTemporaryPassword(response.temporary_password)
      setSuccess(response.message)
      // No llamar onSuccess inmediatamente, esperar a que el usuario copie la contraseña
    } catch (err) {

      setError(err.response?.data?.detail || err.message || 'Error al invitar usuario')
    } finally {
      setLoading(false)
    }
  }
  
  const handleCopyPassword = () => {
    if (temporaryPassword) {
avigator.clipboard.writeText(temporaryPassword)
      alert('Contraseña copiada al portapapeles')
    }
  }
  
  const handleClose = () => {
    if (success) {
      onSuccess()
    } else {
      onClose()
    }
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
  
  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="bg-gradient-to-r from-indigo-600 to-purple-600 p-6 rounded-t-2xl flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <UserPlus className="w-6 h-6 text-white" />
            </div>
            <div>
              <h3 className="text-2xl font-bold text-white">Invitar Usuario</h3>
              <p className="text-indigo-100 text-sm">Crea un nuevo usuario en el sistema</p>
            </div>
          </div>
          <button
            onClick={handleClose}
            className="p-2 hover:bg-white/20 rounded-lg transition-colors"
          >
            <X className="w-6 h-6 text-white" />
          </button>
        </div>
        
        {/* Contenido */}
        <div className="p-6">
          {success ? (
            <div className="space-y-4">
              <div className={`rounded-xl p-4 flex items-start space-x-3 ${
                response?.email_sent 
                  ? 'bg-green-50 border border-green-200' 
                  : 'bg-yellow-50 border border-yellow-200'
              }`}>
                {response?.email_sent ? (
                  <CheckCircle className="w-6 h-6 text-green-600 flex-shrink-0 mt-0.5" />
                ) : (
                  <AlertCircle className="w-6 h-6 text-yellow-600 flex-shrink-0 mt-0.5" />
                )}
                <div className="flex-1">
                  <p className={`font-semibold ${
                    response?.email_sent ? 'text-green-800' : 'text-yellow-800'
                  }`}>
                    {response?.email_sent 
                      ? '✅ Usuario invitado y email enviado exitosamente' 
                      : '⚠️ Usuario creado, pero email no enviado'}
                  </p>
                  <p className={`text-sm mt-1 ${
                    response?.email_sent ? 'text-green-700' : 'text-yellow-700'
                  }`}>
                    {success}
                  </p>
                  {!response?.email_sent && response?.email_message && (
                    <p className="text-xs text-yellow-600 mt-2">
                      {response.email_message}
                    </p>
                  )}
                </div>
              </div>
              
              {temporaryPassword && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                  <p className="text-yellow-800 font-semibold mb-2">Contraseña Temporal</p>
                  <div className="flex items-center space-x-2">
                    <code className="flex-1 bg-white px-4 py-2 rounded-lg border border-yellow-300 font-mono text-sm">
                      {temporaryPassword}
                    </code>
                    <button
                      onClick={handleCopyPassword}
                      className="p-2 bg-yellow-100 hover:bg-yellow-200 text-yellow-800 rounded-lg transition-colors"
                      title="Copiar contraseña"
                    >
                      <Copy className="w-5 h-5" />
                    </button>
                  </div>
                  <p className="text-yellow-700 text-xs mt-2">
                    ⚠️ <strong>IMPORTANTE:</strong> Comparte esta contraseña con el usuario. El usuario recibirá un email con un <strong>link de verificación</strong>. Debe hacer clic en el link para verificar su email, luego puede iniciar sesión con esta contraseña. Después del primer inicio de sesión, deberá cambiar la contraseña.
                  </p>
                </div>
              )}
              
              <button
                onClick={handleClose}
                className="w-full px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors"
              >
                Cerrar
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Email */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Mail className="w-4 h-4 inline mr-2" />
                  Email
                </label>
                <input
                  type="email"
ame="email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="usuario@ejemplo.com"
                />
              </div>
              
              {/* Nombre */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <User className="w-4 h-4 inline mr-2" />
                  Nombre Completo
                </label>
                <input
                  type="text"
ame="nombre"
                  value={formData.nombre}
                  onChange={handleChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="Juan Pérez"
                />
              </div>
              
              {/* Rol */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  <Shield className="w-4 h-4 inline mr-2" />
                  Rol
                </label>
                <div className="grid grid-cols-3 gap-3">
                  {['operador', 'manager', 'admin'].map((rol) => (
                    <button
                      key={rol}
                      type="button"
                      onClick={() => setFormData(prev => ({ ...prev, rol }))}
                      className={`p-4 rounded-xl border-2 transition-all ${
                        formData.rol === rol
                          ? 'border-indigo-500 bg-indigo-50'
                          : 'border-gray-200 hover:border-gray-300'
                      }`}
                    >
                      <div className={`inline-block px-3 py-1 rounded-full text-xs font-semibold mb-2 ${getRolColor(rol)}`}>
                        {rol === 'admin' ? 'Administrador' : rol === 'manager' ? 'Gerente' : 'Operador'}
                      </div>
                      <p className="text-sm text-gray-600 mt-1">
                        {rol === 'admin'
                          ? 'Acceso completo al sistema'
                          : rol === 'manager'
                          ? 'Gestiona múltiples difusoras'
                          : 'Opera una difusora'}
                      </p>
                    </button>
                  ))}
                </div>
              </div>
              
              {/* Difusoras (solo para manager y operador) */}
              {formData.rol !== 'admin' && difusoras.length > 0 && (
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    <Building className="w-4 h-4 inline mr-2" />
                    Difusoras Asignadas
                  </label>
                  <div className="max-h-48 overflow-y-auto border border-gray-200 rounded-lg p-3 space-y-2">
                    {difusoras.map((difusora) => (
                      <label
                        key={difusora.id}
                        className="flex items-center space-x-3 p-2 hover:bg-gray-50 rounded-lg cursor-pointer"
                      >
                        <input
                          type="checkbox"
                          checked={formData.difusoras_ids.includes(difusora.id)}
                          onChange={() => handleDifusoraToggle(difusora.id)}
                          className="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500"
                        />
                        <div className="flex-1">
                          <p className="font-medium text-gray-900">{difusora.siglas}</p>
                          <p className="text-sm text-gray-600">{difusora.nombre}</p>
                        </div>
                      </label>
                    ))}
                  </div>
                  {formData.rol === 'operador' && formData.difusoras_ids.length > 1 && (
                    <p className="text-yellow-600 text-sm mt-2">
                      ⚠️ Los operadores normalmente solo deberían tener una difusora asignada
                    </p>
                  )}
                </div>
              )}
              
              {/* Error */}
              {error && (
                <div className="bg-red-50 border border-red-200 rounded-xl p-4 flex items-start space-x-3">
                  <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                  <p className="text-red-800 text-sm">{error}</p>
                </div>
              )}
              
              {/* Botones */}
              <div className="flex items-center space-x-3 pt-4">
                <button
                  type="button"
                  onClick={onClose}
                  className="flex-1 px-6 py-3 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-colors"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {loading ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      <span>Inviting...</span>
                    </>
                  ) : (
                    <>
                      <UserPlus className="w-5 h-5" />
                      <span>Invitar Usuario</span>
                    </>
                  )}
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}

