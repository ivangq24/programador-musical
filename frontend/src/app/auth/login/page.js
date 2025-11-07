"use client";

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { signIn, signUp, confirmSignUp, resendConfirmationCode, forgotPassword, confirmPassword, setupMFA, signInWithMFA, getCurrentUser, completeNewPasswordChallenge } from '@/lib/auth';

export default function LoginPage() {
  const [mode, setMode] = useState('login'); // 'login' | 'create-admin' | 'verify' | 'mfa-setup' | 'mfa-verify' | 'forgot-password' | 'reset-password' | 'new-password'
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [name, setName] = useState('');
  const [nombreEmpresa, setNombreEmpresa] = useState('');
  const [telefono, setTelefono] = useState('');
  const [direccion, setDireccion] = useState('');
  const [ciudad, setCiudad] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [mfaCode, setMfaCode] = useState('');
  const [mfaSecret, setMfaSecret] = useState('');
  const [mfaQrCode, setMfaQrCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [setupComplete, setSetupComplete] = useState(null); // null = verificando, true = configurado, false = no configurado
  const [checkingSetup, setCheckingSetup] = useState(true);
  const router = useRouter();

  useEffect(() => {
    // Verificar si ya está autenticado
    getCurrentUser()
      .then(() => {
        router.push('/');
      })
      .catch(() => {
        // No autenticado, verificar si el sistema está configurado
        checkSetup();
      });
    
    // En producción, deshabilitar el modo de registro
    // Si alguien intenta acceder al modo register, redirigir a login
    if (mode === 'register') {
      setMode('login');
      setError('El registro está deshabilitado. Contacta al administrador para obtener acceso.');
    }
  }, [router]);

  const checkSetup = async () => {
    try {
      setCheckingSetup(true);
      // Usar fetch directo para evitar problemas de autenticación
      const baseURL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
      const response = await fetch(`${baseURL}/auth/check-setup`);
      
      if (!response.ok) {
        throw new Error('Error al verificar configuración');
      }
      
      const data = await response.json();
      setSetupComplete(data.setup_complete || false);
    } catch (err) {

      // Si falla, asumir que NO está configurado para mostrar la opción de crear admin
      setSetupComplete(false);
    } finally {
      setCheckingSetup(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setSuccess('');

    if (mode === 'login') {
      try {
        const tokens = await signIn(email, password);
        
        // Guardar tokens
        localStorage.setItem('accessToken', tokens.accessToken);
        localStorage.setItem('idToken', tokens.idToken);
        localStorage.setItem('refreshToken', tokens.refreshToken);
        
        // Redirigir a la página principal
        router.push('/');
      } catch (err) {

        
        // Manejar requerimientos de MFA
        if (err.message === 'MFA_SETUP_REQUIRED') {
          const secret = localStorage.getItem('mfa_secret');
          if (secret) {
            setMfaSecret(secret);
            // Generar QR code (usando librería como qrcode.react o simplemente mostrar el secret)
            setMode('mfa-setup');
            setSuccess('Configura MFA escaneando el código QR con una aplicación autenticadora');
          } else {
            setError('Error al configurar MFA. Intenta nuevamente.');
          }
        } else if (err.message === 'TOTP_REQUIRED' || err.message === 'MFA_REQUIRED') {
          setMode('mfa-verify');
          setError('Ingresa el código de tu aplicación autenticadora');
        } else if (err.message === 'NEW_PASSWORD_REQUIRED') {
          setMode('new-password');
          setSuccess('Debes establecer una nueva contraseña para continuar.');
          setPassword('');
          // El email ya está en el estado, se usará para completeNewPasswordChallenge
        } else {
          setError(err.message || 'Error al iniciar sesión. Verifica tus credenciales.');
        }
      } finally {
        setLoading(false);
      }
    } else if (mode === 'mfa-setup') {
      // Configurar MFA con el código del usuario
      try {
        await setupMFA(email, mfaCode);
        setSuccess('MFA configurado exitosamente. Ya puedes iniciar sesión.');
        setTimeout(() => {
          setMode('login');
          setMfaCode('');
          setMfaSecret('');
          localStorage.removeItem('mfa_secret');
        }, 2000);
      } catch (err) {
        setError(err.message || 'Código MFA inválido. Intenta nuevamente.');
      } finally {
        setLoading(false);
      }
    } else if (mode === 'mfa-verify') {
      // Verificar código MFA en login
      try {
        // Re-autenticar con código MFA
        const tokens = await signInWithMFA(email, password, mfaCode);
        localStorage.setItem('accessToken', tokens.accessToken);
        localStorage.setItem('idToken', tokens.idToken);
        localStorage.setItem('refreshToken', tokens.refreshToken);
        router.push('/');
      } catch (err) {
        setError(err.message || 'Código MFA inválido. Intenta nuevamente.');
      } finally {
        setLoading(false);
      }
    } else if (mode === 'create-admin') {
      // Validar contraseñas
      if (password !== confirmPassword) {
        setError('Las contraseñas no coinciden');
        setLoading(false);
        return;
      }

      // Validar longitud mínima de contraseña
      if (password.length < 12) {
        setError('La contraseña debe tener al menos 12 caracteres');
        setLoading(false);
        return;
      }

      try {
        const baseURL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
        const response = await fetch(`${baseURL}/auth/create-first-admin`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            email,
ombre: name,
            password,
            confirm_password: confirmPassword,
ombre_empresa: nombreEmpresa || null,
            telefono: telefono || null,
            direccion: direccion || null,
            ciudad: ciudad || null,
          }),
        });

        const data = await response.json();

        if (!response.ok) {
          // Mejorar el mensaje de error para que sea más legible
          let errorMessage = data.detail || data.message || 'Error al crear el administrador';
          
          // Si el error es sobre Cognito, formatearlo mejor y agregar instrucciones
          if (errorMessage.includes('Cognito') || errorMessage.includes('AWS') || errorMessage.includes('credenciales')) {
            errorMessage = errorMessage.replace(/\n/g, '<br>');
            errorMessage += '<br><br><strong>Alternativa:</strong> Puedes crear el administrador usando el script desde la terminal:<br><code>./aws/create-first-admin.sh tu-email@ejemplo.com "Tu Nombre" "TuPassword123!@#"</code>';
          }
          
          throw new Error(errorMessage);
        }

        setSuccess('Administrador creado exitosamente. Iniciando sesión...');
        
        // Intentar iniciar sesión automáticamente
        setTimeout(async () => {
          try {
            const tokens = await signIn(email, password);
            localStorage.setItem('accessToken', tokens.accessToken);
            localStorage.setItem('idToken', tokens.idToken);
            localStorage.setItem('refreshToken', tokens.refreshToken);
            router.push('/');
          } catch (err) {
            // Si falla el login automático, cambiar a modo login
            setMode('login');
            setSuccess('Cuenta creada. Por favor inicia sesión.');
            setPassword('');
            setConfirmPassword('');
            setName('');
            setNombreEmpresa('');
            setTelefono('');
            setDireccion('');
            setCiudad('');
          }
        }, 2000);
      } catch (err) {

        setError(err.message || 'Error al crear el administrador');
      } finally {
        setLoading(false);
      }
    } else if (mode === 'verify') {
      // Este modo ya no se usa con verificación por link
      // Pero lo mantenemos por compatibilidad
      setError('La verificación se realiza mediante un link que se envía a tu email. Revisa tu bandeja de entrada.');
      setLoading(false);
    } else if (mode === 'forgot-password') {
      // Solicitar reseteo de contraseña
      try {
        await forgotPassword(email);
        setSuccess('Se ha enviado un link de recuperación a tu email. Revisa tu bandeja de entrada y haz clic en el link para restablecer tu contraseña.');
        // No cambiar a reset-password, el usuario usará el link del email
        setTimeout(() => {
          setMode('login');
        }, 3000);
      } catch (err) {

        setError(err.message || 'Error al solicitar reseteo de contraseña.');
      } finally {
        setLoading(false);
      }
    } else if (mode === 'new-password') {
      // Establecer nueva contraseña (cambio de contraseña temporal)
      if (password !== confirmPassword) {
        setError('Las contraseñas no coinciden');
        setLoading(false);
        return;
      }

      if (password.length < 12) {
        setError('La contraseña debe tener al menos 12 caracteres');
        setLoading(false);
        return;
      }

      try {
        // Intentar completar el cambio de contraseña
        const tokens = await completeNewPasswordChallenge(password, email);
        
        // Guardar tokens
        localStorage.setItem('accessToken', tokens.accessToken);
        localStorage.setItem('idToken', tokens.idToken);
        localStorage.setItem('refreshToken', tokens.refreshToken);
        
        setSuccess('Contraseña establecida exitosamente. Iniciando sesión...');
        setTimeout(() => {
          router.push('/');
        }, 1500);
      } catch (err) {

        
        // Si el error es por falta de usuario pendiente, intentar re-autenticar
        if (err.message.includes('No hay usuario pendiente') || err.message.includes('sesión de cambio de contraseña expiró')) {
          setError('La sesión expiró. Por favor, inicia sesión nuevamente con tu contraseña temporal.');
          // Limpiar el estado
          localStorage.removeItem('pending_password_change_email');
          setTimeout(() => {
            setMode('login');
            setPassword('');
            setConfirmPassword('');
            setError('Inicia sesión nuevamente con tu contraseña temporal para establecer tu nueva contraseña.');
          }, 3000);
        } else {
          setError(err.message || 'Error al establecer la contraseña. Verifica que cumpla con los requisitos.');
        }
      } finally {
        setLoading(false);
      }
    } else if (mode === 'reset-password') {
      // Confirmar nueva contraseña
      if (password !== confirmPassword) {
        setError('Las contraseñas no coinciden');
        setLoading(false);
        return;
      }

      if (password.length < 12) {
        setError('La contraseña debe tener al menos 12 caracteres');
        setLoading(false);
        return;
      }

      try {
        await confirmPassword(email, verificationCode, password);
        setSuccess('Contraseña actualizada exitosamente. Ya puedes iniciar sesión.');
        setTimeout(() => {
          setMode('login');
          setPassword('');
          setConfirmPassword('');
          setVerificationCode('');
          setSuccess('');
        }, 2000);
      } catch (err) {

        setError(err.message || 'Error al resetear la contraseña. Verifica el código.');
      } finally {
        setLoading(false);
      }
    }
  };

  const handleResendCode = async () => {
    setLoading(true);
    setError('');
    try {
      await resendConfirmationCode(email);
      setSuccess('Código de verificación reenviado. Revisa tu email.');
    } catch (err) {
      setError(err.message || 'Error al reenviar el código.');
    } finally {
      setLoading(false);
    }
  };


  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center p-4">
      {/* Fondo decorativo */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-blue-200/20 rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-purple-200/20 rounded-full blur-3xl"></div>
      </div>

      <div className="relative z-10 w-full max-w-md">
        {/* Card de login */}
        <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
          {/* Header con gradiente */}
          <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 p-8 relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
            <div className="relative z-10 text-center">
              <div className="w-20 h-20 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-sm shadow-lg mx-auto mb-4">
                <svg className="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <h1 className="text-3xl font-bold text-white mb-2">Programador Musical</h1>
              <p className="text-blue-100 text-sm">
                {mode === 'login' && 'Inicia sesión para continuar'}
                {mode === 'create-admin' && 'Crea tu cuenta de administrador'}
                {mode === 'verify' && 'Verifica tu email'}
                {mode === 'new-password' && 'Establece tu nueva contraseña'}
                {mode === 'forgot-password' && 'Recuperar contraseña'}
                {mode === 'reset-password' && 'Nueva contraseña'}
                {mode === 'mfa-setup' && 'Configurar autenticación de dos factores'}
                {mode === 'mfa-verify' && 'Verificar código de autenticación'}
              </p>
            </div>
            {/* Efecto de partículas decorativas */}
            <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
            <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
          </div>

          {/* Formulario */}
          <div className="p-8">
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Campos para crear administrador */}
              {mode === 'create-admin' && (
                <>
                  <div>
                    <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                      Nombre completo <span className="text-red-500">*</span>
                    </label>
                    <input
                      id="name"
                      type="text"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      required
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder="Juan Pérez"
                      disabled={loading}
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="nombreEmpresa" className="block text-sm font-medium text-gray-700 mb-2">
                      Nombre de la Empresa/Organización
                    </label>
                    <input
                      id="nombreEmpresa"
                      type="text"
                      value={nombreEmpresa}
                      onChange={(e) => setNombreEmpresa(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder="Mi Empresa S.A."
                      disabled={loading}
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="telefono" className="block text-sm font-medium text-gray-700 mb-2">
                      Teléfono
                    </label>
                    <input
                      id="telefono"
                      type="tel"
                      value={telefono}
                      onChange={(e) => setTelefono(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder="+1 234 567 8900"
                      disabled={loading}
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="direccion" className="block text-sm font-medium text-gray-700 mb-2">
                      Dirección
                    </label>
                    <input
                      id="direccion"
                      type="text"
                      value={direccion}
                      onChange={(e) => setDireccion(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder="Calle, Número, Ciudad"
                      disabled={loading}
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="ciudad" className="block text-sm font-medium text-gray-700 mb-2">
                      Ciudad
                    </label>
                    <input
                      id="ciudad"
                      type="text"
                      value={ciudad}
                      onChange={(e) => setCiudad(e.target.value)}
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder="Ciudad de México"
                      disabled={loading}
                    />
                  </div>
                </>
              )}

              {/* Campo Email */}
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                  Correo electrónico
                </label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                  placeholder="usuario@example.com"
                  disabled={loading || mode === 'verify'}
                />
              </div>

              {/* Campo Contraseña (no en verificación ni forgot-password) */}
              {mode !== 'verify' && mode !== 'forgot-password' && (
                <>
                  <div>
                    <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
                      {mode === 'new-password' ? 'Nueva contraseña' : 'Contraseña'}
                    </label>
                    <input
                      id="password"
                      type="password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                      placeholder={(mode === 'create-admin' || mode === 'reset-password' || mode === 'new-password') ? 'Mínimo 12 caracteres' : '••••••••'}
                      disabled={loading}
                    />
                    {(mode === 'create-admin' || mode === 'reset-password' || mode === 'new-password') && (
                      <p className="mt-1 text-xs text-gray-500">
                        Mínimo 12 caracteres, incluir mayúsculas, minúsculas, números y símbolos
                      </p>
                    )}
                  </div>

                  {/* Campo Confirmar Contraseña (solo en create-admin, reset-password y new-password) */}
                  {(mode === 'create-admin' || mode === 'reset-password' || mode === 'new-password') && (
                    <div>
                      <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700 mb-2">
                        Confirmar contraseña
                      </label>
                      <input
                        id="confirmPassword"
                        type="password"
                        value={confirmPassword}
                        onChange={(e) => setConfirmPassword(e.target.value)}
                        required
                        className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm"
                        placeholder="Repite tu contraseña"
                        disabled={loading}
                      />
                    </div>
                  )}
                </>
              )}

              {/* Campo Código de Verificación (en reset-password también) */}
              {(mode === 'verify' || mode === 'reset-password') && (
                <div>
                  <label htmlFor="verificationCode" className="block text-sm font-medium text-gray-700 mb-2">
                    Código de verificación
                  </label>
                  <input
                    id="verificationCode"
                    type="text"
                    value={verificationCode}
                    onChange={(e) => setVerificationCode(e.target.value)}
                    required
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/50 backdrop-blur-sm text-center text-lg tracking-widest"
                    placeholder="123456"
                    disabled={loading}
                    maxLength={6}
                  />
                  <p className="mt-2 text-sm text-gray-600 text-center">
                    {mode === 'verify' 
                      ? `Ingresa el código que enviamos a ${email}`
                      : `Ingresa el código que enviamos a ${email} para resetear tu contraseña`
                    }
                  </p>
                  {mode === 'verify' && (
                    <button
                      type="button"
                      onClick={handleResendCode}
                      disabled={loading}
                      className="mt-2 w-full text-sm text-blue-600 hover:text-blue-700 underline disabled:opacity-50"
                    >
                      Reenviar código
                    </button>
                  )}
                </div>
              )}

              {/* Mensaje de error */}
              {error && (
                <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-sm">
                  <div dangerouslySetInnerHTML={{ __html: error }} />
                </div>
              )}

              {/* Mensaje de éxito */}
              {success && (
                <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl text-sm">
                  {success}
                </div>
              )}

              {/* Botón de acción principal */}
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-3 px-4 rounded-xl font-semibold hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transform hover:scale-[1.02]"
              >
                {loading ? (
                  <span className="flex items-center justify-center">
                    <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {mode === 'login' && 'Iniciando sesión...'}
                    {mode === 'create-admin' && 'Creando administrador...'}
                    {mode === 'verify' && 'Verificando...'}
                    {mode === 'forgot-password' && 'Enviando código...'}
                    {mode === 'reset-password' && 'Cambiando contraseña...'}
                    {mode === 'new-password' && 'Estableciendo contraseña...'}
                    {mode === 'mfa-setup' && 'Configurando MFA...'}
                    {mode === 'mfa-verify' && 'Verificando código...'}
                  </span>
                ) : (
                  <>
                    {mode === 'login' && 'Iniciar sesión'}
                    {mode === 'create-admin' && 'Crear Administrador'}
                    {mode === 'verify' && 'Verificar email'}
                    {mode === 'forgot-password' && 'Enviar código'}
                    {mode === 'reset-password' && 'Cambiar contraseña'}
                    {mode === 'new-password' && 'Establecer contraseña'}
                    {mode === 'mfa-setup' && 'Confirmar MFA'}
                    {mode === 'mfa-verify' && 'Verificar código'}
                  </>
                )}
              </button>
            </form>

            {/* Enlace "Olvidé mi contraseña" (solo en login) */}
            {mode === 'login' && (
              <div className="mt-4 text-center">
                <button
                  type="button"
                  onClick={() => {
                    setMode('forgot-password');
                    setError('');
                    setSuccess('');
                    setPassword('');
                  }}
                  className="text-sm text-blue-600 hover:text-blue-700 font-medium underline"
                >
                  ¿Olvidaste tu contraseña?
                </button>
              </div>
            )}

            {/* Cambiar entre login y crear cuenta */}
            {!checkingSetup && mode !== 'verify' && mode !== 'forgot-password' && mode !== 'reset-password' && mode !== 'new-password' && (
              <div className="mt-6 text-center text-sm">
                {mode === 'login' ? (
                  <>
                    {setupComplete === false ? (
                      <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-4">
                        <p className="text-gray-700 mb-3 font-medium">
                          Bienvenido al sistema. Es la primera vez que accedes.
                        </p>
                        <button
                          type="button"
                          onClick={() => {
                            setMode('create-admin');
                            setError('');
                            setSuccess('');
                            setPassword('');
                            setConfirmPassword('');
                            setName('');
                            setNombreEmpresa('');
                            setTelefono('');
                            setDireccion('');
                            setCiudad('');
                          }}
                          className="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-2 px-4 rounded-lg font-semibold hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-200 shadow-md hover:shadow-lg"
                        >
                          Crear cuenta de administrador
                        </button>
                      </div>
                    ) : setupComplete === true ? (
                      <>
                        <button
                          type="button"
                          onClick={() => setMode('forgot-password')}
                          className="text-blue-600 hover:text-blue-700 text-sm underline"
                        >
                          ¿Olvidaste tu contraseña?
                        </button>
                        <p className="text-gray-600 text-sm mt-2">
                          ¿Necesitas acceso? Contacta al administrador del sistema.
                        </p>
                      </>
                    ) : null}
                  </>
                ) : (
                  <p className="text-gray-600">
                    ¿Ya tienes cuenta?{' '}
                    <button
                      type="button"
                      onClick={() => {
                        setMode('login');
                        setError('');
                        setSuccess('');
                        setPassword('');
                        setConfirmPassword('');
                        setName('');
                      }}
                      className="text-blue-600 hover:text-blue-700 font-medium underline"
                    >
                      Inicia sesión aquí
                    </button>
                  </p>
                )}
              </div>
            )}

            {/* Volver a login desde forgot-password o reset-password */}
            {(mode === 'forgot-password' || mode === 'reset-password') && (
              <div className="mt-4 text-center text-sm">
                <button
                  type="button"
                  onClick={() => {
                    setMode('login');
                    setError('');
                    setSuccess('');
                    setPassword('');
                    setConfirmPassword('');
                    setVerificationCode('');
                  }}
                  className="text-blue-600 hover:text-blue-700 font-medium underline"
                >
                  ← Volver a iniciar sesión
                </button>
              </div>
            )}


            {/* Información adicional */}
            <div className="mt-6 text-center text-sm text-gray-600">
              <p>¿Necesitas ayuda? Contacta al administrador del sistema</p>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-6 text-center text-sm text-gray-600">
          <p>© 2025 Programador Musical. Todos los derechos reservados.</p>
        </div>
      </div>
    </div>
  );
}

