"use client";

import { useEffect, useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { CheckCircle, XCircle, Loader2 } from 'lucide-react';

function VerifyEmailContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [status, setStatus] = useState('verifying'); // 'verifying' | 'success' | 'error'
  const [message, setMessage] = useState('Verificando tu email...');

  useEffect(() => {
    const handleVerification = async () => {
      try {
        // Cognito redirige aquí con parámetros de verificación
        const code = searchParams.get('code');
        const token = searchParams.get('token');
        const username = searchParams.get('username');

        if (!code && !token) {
          setStatus('error');
          setMessage('Link de verificación inválido o expirado.');
          return;
        }

        // Si hay un código, significa que Cognito ya verificó el email
        // Solo necesitamos confirmar al usuario
        if (code) {
          setStatus('success');
          setMessage('¡Email verificado exitosamente! Ya puedes iniciar sesión.');
          setTimeout(() => {
            router.push('/auth/login');
          }, 3000);
        } else if (token) {
          // Verificar el token con el backend
          try {
            const baseURL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
            const response = await fetch(`${baseURL}/auth/verify-email?token=${token}&username=${username || ''}`, {
              method: 'GET',
            });

            if (response.ok) {
              setStatus('success');
              setMessage('¡Email verificado exitosamente! Ya puedes iniciar sesión.');
              setTimeout(() => {
                router.push('/auth/login');
              }, 3000);
            } else {
              const data = await response.json();
              setStatus('error');
              setMessage(data.detail || 'Error al verificar el email. El link puede haber expirado.');
            }
          } catch (err) {
            setStatus('error');
            setMessage('Error al verificar el email. Intenta nuevamente.');
          }
        }
      } catch (err) {
        console.error('Error en verificación:', err);
        setStatus('error');
        setMessage('Error al procesar la verificación. Intenta nuevamente.');
      }
    };

    handleVerification();
  }, [router, searchParams]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full text-center">
        {status === 'verifying' && (
          <>
            <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Verificando email</h2>
            <p className="text-gray-600">{message}</p>
          </>
        )}
        
        {status === 'success' && (
          <>
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircle className="w-8 h-8 text-green-600" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">¡Email verificado!</h2>
            <p className="text-gray-600 mb-6">{message}</p>
            <p className="text-sm text-gray-500">Redirigiendo al login...</p>
          </>
        )}
        
        {status === 'error' && (
          <>
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <XCircle className="w-8 h-8 text-red-600" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Error de verificación</h2>
            <p className="text-gray-600 mb-6">{message}</p>
            <button
              onClick={() => router.push('/auth/login')}
              className="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors"
            >
              Ir al Login
            </button>
          </>
        )}
      </div>
    </div>
  );
}

export default function VerifyEmailPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center p-4">
        <div className="text-center">
          <Loader2 className="w-12 h-12 text-blue-600 mx-auto mb-4 animate-spin" />
          <p className="text-gray-600">Cargando...</p>
        </div>
      </div>
    }>
      <VerifyEmailContent />
    </Suspense>
  );
}

