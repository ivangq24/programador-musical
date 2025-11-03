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

// Interceptor para manejar errores
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error);
    return Promise.reject(error);
  }
);

export default apiClient;

