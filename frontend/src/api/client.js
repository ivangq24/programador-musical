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

// Interceptor para logging de requests
apiClient.interceptors.request.use(
  (config) => {
    console.log('🔍 API Request:', config.method?.toUpperCase(), config.url);
    console.log('🔍 Full URL:', config.baseURL + config.url);
    return config;
  },
  (error) => {
    console.error('Request Error:', error);
    return Promise.reject(error);
  }
);

// Interceptor para manejar errores
apiClient.interceptors.response.use(
  (response) => {
    console.log('✅ API Response:', response.status, response.config.url);
    return response;
  },
  (error) => {
    console.error('API Error:', error);
    console.error('Error URL:', error.config?.url);
    console.error('Error Response:', error.response?.data);
    return Promise.reject(error);
  }
);

export default apiClient;

