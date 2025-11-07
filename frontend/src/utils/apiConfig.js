/**
 * Configuración de API para producción AWS
 * Usa variables de entorno para la URL base
 */

// Obtener la URL base de la API desde variables de entorno
export const getApiBaseUrl = () => {
  // En producción (AWS), usar la variable de entorno
  if (typeof window !== 'undefined') {
    // Cliente (browser)
    return process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
  }
  // Servidor (SSR)
  return process.env.API_URL || process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';
};

// Helper para construir URLs completas
export const buildApiUrl = (endpoint) => {
  const baseUrl = getApiBaseUrl();
  // Asegurar que el endpoint empiece con /
  const cleanEndpoint = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;
  // Si baseUrl ya termina con /api/v1, solo agregar el endpoint
  // Si no, agregar /api/v1 antes del endpoint
  if (baseUrl.endsWith('/api/v1')) {
    return `${baseUrl}${cleanEndpoint}`;
  }
  return `${baseUrl}/api/v1${cleanEndpoint}`;
};

// Helper para fetch requests con configuración estándar
export const apiFetch = async (endpoint, options = {}) => {
  const url = buildApiUrl(endpoint);
  
  const defaultOptions = {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    cache: 'no-store',
    ...options,
  };

  try {
    const response = await fetch(url, defaultOptions);
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {

    throw error;
  }
};

export default {
  getApiBaseUrl,
  buildApiUrl,
  apiFetch,
};

