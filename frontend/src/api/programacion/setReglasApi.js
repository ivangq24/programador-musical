// API para Set de Reglas
import { buildApiUrl } from '../../utils/apiConfig';

// Función helper para hacer peticiones HTTP
const apiRequest = async (endpoint, options = {}) => {
  const url = buildApiUrl(endpoint);
  
  const defaultOptions = {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
  };

  try {
    const response = await fetch(url, { ...defaultOptions, ...options });
    
    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {

    throw error;
  }
};

// Obtener lista de sets de reglas
export const getSetReglas = async (params = {}) => {
  const queryParams = new URLSearchParams();
  
  if (params.skip !== undefined) queryParams.append('skip', params.skip);
  if (params.limit !== undefined) queryParams.append('limit', params.limit);
  if (params.search) queryParams.append('search', params.search);
  if (params.habilitado !== undefined) queryParams.append('habilitado', params.habilitado);
  
  const queryString = queryParams.toString();
  const endpoint = `/programacion/set-reglas${queryString ? `?${queryString}` : ''}`;
  
  return apiRequest(endpoint);
};

// Obtener un set de reglas específico por ID
export const getSetReglaById = async (id) => {
  return apiRequest(`/programacion/set-reglas/${id}`);
};

// Crear un nuevo set de reglas
export const createSetRegla = async (setReglaData) => {
  return apiRequest('/programacion/set-reglas/', {
    method: 'POST',
    body: JSON.stringify(setReglaData),
  });
};

// Actualizar un set de reglas existente
export const updateSetRegla = async (id, setReglaData) => {
  return apiRequest(`/programacion/set-reglas/${id}`, {
    method: 'PUT',
    body: JSON.stringify(setReglaData),
  });
};

// Eliminar un set de reglas
export const deleteSetRegla = async (id) => {
  return apiRequest(`/programacion/set-reglas/${id}`, {
    method: 'DELETE',
  });
};

// Obtener reglas de un set específico
export const getReglasBySet = async (setReglaId) => {
  return apiRequest(`/programacion/set-reglas/${setReglaId}/reglas`);
};

// Crear una nueva regla para un set
export const createRegla = async (setReglaId, reglaData) => {
  return apiRequest(`/programacion/set-reglas/${setReglaId}/reglas`, {
    method: 'POST',
    body: JSON.stringify(reglaData),
  });
};

// Actualizar una regla existente
export const updateRegla = async (reglaId, reglaData) => {
  return apiRequest(`/programacion/set-reglas/reglas/${reglaId}`, {
    method: 'PUT',
    body: JSON.stringify(reglaData),
  });
};

// Eliminar una regla
export const deleteRegla = async (reglaId) => {
  return apiRequest(`/programacion/set-reglas/reglas/${reglaId}`, {
    method: 'DELETE',
  });
};

// Obtener estadísticas de sets de reglas
export const getSetReglasStats = async () => {
  return apiRequest('/programacion/set-reglas/stats/summary');
};
