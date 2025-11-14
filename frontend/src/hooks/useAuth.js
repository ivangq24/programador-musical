import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { getCurrentUser, getUserInfo, signOut as cognitoSignOut, isAuthenticated } from '@/lib/auth';

export function useAuth() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [authenticated, setAuthenticated] = useState(false);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const cognitoEnabled = process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID && 
                            process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID !== '';
      
      // Detectar si estamos en producción
      const isProduction = process.env.NODE_ENV === 'production' || 
                          process.env.NEXT_PUBLIC_ENVIRONMENT === 'production';
      
      // Si Cognito no está configurado
      if (!cognitoEnabled) {
        // En producción, NO permitir acceso sin Cognito configurado
        if (isProduction) {
          setAuthenticated(false);
          setUser(null);
          setLoading(false);
          return;
        }
        // En desarrollo, permitir acceso sin autenticación
        setAuthenticated(true);
        setUser({ name: 'Usuario Desarrollo', email: 'dev@example.com', rol: 'admin' });
        setLoading(false);
        return;
      }

      const isAuth = await isAuthenticated();
      if (isAuth) {
        const userInfo = await getUserInfo();
        setUser(userInfo);
        setAuthenticated(true);
      } else {
        setAuthenticated(false);
        setUser(null);
      }
    } catch (error) {
      setAuthenticated(false);
      setUser(null);
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    cognitoSignOut();
    setUser(null);
    setAuthenticated(false);
    router.push('/auth/login');
  };

  return {
    user,
    loading,
    authenticated,
    logout,
    checkAuth
  };
}

