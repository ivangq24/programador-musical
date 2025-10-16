import apiClient from '../client.js';

// Políticas de Programación
export const politicasApi = {
  // Obtener todas las políticas
  getAll: async () => {
    const response = await apiClient.get('/programacion/politicas/');
    return response.data;
  },

  // Obtener política por ID
  getById: async (id) => {
    const response = await apiClient.get(`/politicas/${id}`);
    return response.data;
  },

  // Crear nueva política
  create: async (politicaData) => {
    const response = await apiClient.post('/politicas', politicaData);
    return response.data;
  },

  // Actualizar política
  update: async (id, politicaData) => {
    const response = await apiClient.put(`/politicas/${id}`, politicaData);
    return response.data;
  },

  // Eliminar política
  delete: async (id) => {
    const response = await apiClient.delete(`/politicas/${id}`);
    return response.data;
  }
};

// Días Modelo
export const diasModeloApi = {
  // Obtener días modelo por política
  getByPolitica: async (politicaId) => {
    const response = await apiClient.get(`/programacion/politicas/${politicaId}/dias-modelo`);
    return response.data;
  },

  // Crear nuevo día modelo
  create: async (politicaId, diaModeloData) => {
    const response = await apiClient.post(`/programacion/politicas/${politicaId}/dias-modelo`, diaModeloData);
    return response.data;
  },

  // Actualizar día modelo
  update: async (diaModeloId, diaModeloData) => {
    const response = await apiClient.put(`/programacion/politicas/dias-modelo/${diaModeloId}`, diaModeloData);
    return response.data;
  },

  // Eliminar día modelo
  delete: async (diaModeloId) => {
    const response = await apiClient.delete(`/programacion/politicas/dias-modelo/${diaModeloId}`);
    return response.data;
  }
};

// Relojes
export const relojesApi = {
  // Obtener todos los relojes
  getAll: async () => {
    const response = await apiClient.get('/politicas/relojes');
    return response.data;
  },

  // Obtener relojes por política
  getByPolitica: async (politicaId) => {
    const response = await apiClient.get(`/programacion/politicas/${politicaId}/relojes`);
    return response.data;
  },

  // Obtener reloj por ID
  getById: async (id) => {
    const response = await apiClient.get(`/programacion/politicas/relojes/${id}`);
    return response.data;
  },

  // Crear nuevo reloj
  create: async (politicaId, relojData) => {
    const response = await apiClient.post(`/programacion/politicas/${politicaId}/relojes`, relojData);
    return response.data;
  },

  // Actualizar reloj
  update: async (id, relojData) => {
    const response = await apiClient.put(`/programacion/politicas/relojes/${id}`, relojData);
    return response.data;
  },

  // Eliminar reloj
  delete: async (id) => {
    const response = await apiClient.delete(`/programacion/politicas/relojes/${id}`);
    return response.data;
  }
};

// Eventos de Reloj
export const eventosRelojApi = {
  // Obtener eventos por reloj
  getByReloj: async (relojId) => {
    const response = await apiClient.get(`/programacion/politicas/relojes/${relojId}/eventos`);
    return response.data;
  },

  // Crear nuevo evento
  create: async (relojId, eventoData) => {
    const response = await apiClient.post(`/programacion/politicas/relojes/${relojId}/eventos`, eventoData);
    return response.data;
  },

  // Actualizar evento
  update: async (eventoId, eventoData) => {
    const response = await apiClient.put(`/programacion/politicas/eventos/${eventoId}`, eventoData);
    return response.data;
  },

  // Eliminar evento
  delete: async (eventoId) => {
    const response = await apiClient.delete(`/programacion/politicas/eventos/${eventoId}`);
    return response.data;
  },

  // Reordenar eventos
  reordenar: async (relojId, eventosOrden) => {
    const response = await apiClient.put(`/programacion/politicas/relojes/${relojId}/eventos/reordenar`, eventosOrden);
    return response.data;
  }
};

// Export por defecto para compatibilidad
export default {
  politicas: politicasApi,
  diasModelo: diasModeloApi,
  relojes: relojesApi,
  eventos: eventosRelojApi
};