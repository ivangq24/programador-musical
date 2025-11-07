// API para Difusoras
import { buildApiUrl } from '../../../utils/apiConfig';

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

// Obtener lista de difusoras
export const getDifusoras = async (params = {}) => {
  const queryParams = new URLSearchParams();
  
  if (params.skip !== undefined) queryParams.append('skip', params.skip);
  if (params.limit !== undefined) queryParams.append('limit', params.limit);
  if (params.search) queryParams.append('search', params.search);
  if (params.activa !== undefined) queryParams.append('activa', params.activa);
  
  const queryString = queryParams.toString();
  const endpoint = `/catalogos/general/difusoras${queryString ? `?${queryString}` : ''}`;
  
  return apiRequest(endpoint);
};

// Obtener una difusora específica por ID
export const getDifusoraById = async (id) => {
  return apiRequest(`/catalogos/general/difusoras/${id}`);
};

// Crear una nueva difusora
export const createDifusora = async (difusoraData) => {
  return apiRequest('/catalogos/general/difusoras/', {
    method: 'POST',
    body: JSON.stringify(difusoraData),
  });
};

// Actualizar una difusora existente
export const updateDifusora = async (id, difusoraData) => {
  return apiRequest(`/catalogos/general/difusoras/${id}`, {
    method: 'PUT',
    body: JSON.stringify(difusoraData),
  });
};

// Eliminar una difusora
export const deleteDifusora = async (id) => {
  return apiRequest(`/catalogos/general/difusoras/${id}`, {
    method: 'DELETE',
  });
};

// Obtener estadísticas de difusoras
export const getDifusorasStats = async () => {
  return apiRequest('/catalogos/general/difusoras/stats');
};

// Función para exportar difusoras a CSV
export const exportDifusorasToCSV = async (params = {}) => {
  try {
    const difusoras = await getDifusoras(params);
    
    const headers = [
      'ID', 'Siglas', 'Nombre', 'Slogan', 'Orden', 'Máscara Medidas', 'Descripción', 'Estado'
    ];
    
    const csvContent = [
      headers.join(','),
      ...difusoras.map(difusora => [
        difusora.id,
        `"${difusora.siglas}"`,
        `"${difusora.nombre}"`,
        `"${difusora.slogan || ''}"`,
        difusora.orden,
        `"${difusora.mascara_medidas}"`,
        `"${difusora.descripcion || ''}"`,
        difusora.activa ? 'Activa' : 'Inactiva'
      ].join(','))
    ].join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', 'difusoras.csv');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    return { success: true, message: 'Exportación CSV completada' };
  } catch (error) {

    throw new Error(`Error al exportar CSV: ${error.message}`);
  }
};

