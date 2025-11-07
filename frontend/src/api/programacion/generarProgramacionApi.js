// API para Generar Programación
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

// Generar programación basada en parámetros
export const generarProgramacion = async (params) => {
  const {
    difusora,
    politica_id,
    set_regla_id,
    fecha_inicio,
    fecha_fin,
    incluir_fines_semana = true,
    parametros_adicionales = {}
  } = params;

  const requestData = {
    difusora,
    politica_id,
    set_regla_id,
    fecha_inicio,
    fecha_fin,
    incluir_fines_semana,
    parametros_adicionales
  };

  return apiRequest('/programacion/generar', {
    method: 'POST',
    body: JSON.stringify(requestData),
  });
};

// Obtener días de programación para un rango de fechas
export const obtenerDiasProgramacion = async (params) => {
  const {
    difusora,
    fecha_inicio,
    fecha_fin,
    politica_id,
    incluir_fines_semana = true
  } = params;

  const queryParams = new URLSearchParams();
  if (politica_id) queryParams.append('politica_id', politica_id);
  if (incluir_fines_semana !== undefined) queryParams.append('incluir_fines_semana', incluir_fines_semana);
  
  const queryString = queryParams.toString();
  const endpoint = `/programacion/dias/${difusora}/${fecha_inicio}/${fecha_fin}${queryString ? `?${queryString}` : ''}`;
  
  return apiRequest(endpoint);
};

// Obtener estadísticas de generación
export const getStatsGeneracion = async () => {
  return apiRequest('/programacion/stats/generacion');
};
