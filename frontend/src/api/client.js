import axios from 'axios';

// Configuración del cliente API - Usa variables de entorno para AWS
const getBaseURL = () => {
  // En producción (AWS), usar la variable de entorno
  if (typeof window !== 'undefined') {
    // Cliente (browser)
    return process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
  }
  // Servidor (SSR)
  return process.env.API_URL || process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
};

const baseURL = getBaseURL();
console.log('API Base URL:', baseURL);
console.log('NEXT_PUBLIC_API_URL:', process.env.NEXT_PUBLIC_API_URL);

const apiClient = axios.create({
  baseURL: baseURL,
  timeout: 30000, // Aumentado para AWS
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor para agregar token de autenticación y logging
apiClient.interceptors.request.use(
  async (config) => {
    // Obtener token del localStorage o de Cognito
    if (typeof window !== 'undefined') {
      const accessToken = localStorage.getItem('accessToken');
      if (accessToken) {
        config.headers.Authorization = `Bearer ${accessToken}`;
      }
    }
    
    // Logging
    console.log('🔍 API Request:', config.method?.toUpperCase(), config.url);
    console.log('🔍 Full URL:', config.baseURL + config.url);
    
    return config;
  },
  (error) => {
    console.error('Request Error:', error);
    return Promise.reject(error);
  }
);

// Interceptor para manejar errores y logging
apiClient.interceptors.response.use(
  (response) => {
    console.log('✅ API Response:', response.status, response.config.url);
    return response;
  },
  async (error) => {
    console.error('API Error:', error);
    console.error('Error URL:', error.config?.url);
    console.error('Error Response:', error.response?.data);
    
    // Manejar errores de autenticación
    if (error.response?.status === 401) {
      // Token expirado o inválido
      if (typeof window !== 'undefined') {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('idToken');
        localStorage.removeItem('refreshToken');
        // Redirigir a login
        window.location.href = '/auth/login';
      }
    }
    
    return Promise.reject(error);
  }
);

export default apiClient;

