/**
 * API para gestión de usuarios
 */
import apiClient from '../client';

export const usuariosApi = {
  /**
   * Obtiene lista de usuarios con filtros
   */
  getUsuarios: async (params = {}) => {
    const { skip = 0, limit = 100, search, rol, activo } = params;
    const queryParams = new URLSearchParams();
    
    if (skip > 0) queryParams.append('skip', skip);
    if (limit !== 100) queryParams.append('limit', limit);
    if (search) queryParams.append('search', search);
    if (rol) queryParams.append('rol', rol);
    if (activo !== undefined) queryParams.append('activo', activo);
    
    const queryString = queryParams.toString();
    const url = `/auth/usuarios${queryString ? `?${queryString}` : ''}`;
    
    const response = await apiClient.get(url);
    return response.data;
  },

  /**
   * Obtiene un usuario por ID
   */
  getUsuario: async (usuarioId) => {
    const response = await apiClient.get(`/auth/usuarios/${usuarioId}`);
    return response.data;
  },

  /**
   * Invita un nuevo usuario
   */
  invitarUsuario: async (usuarioData) => {
    const response = await apiClient.post('/auth/usuarios/invitar', usuarioData);
    return response.data;
  },

  /**
   * Actualiza un usuario
   */
  updateUsuario: async (usuarioId, usuarioData) => {
    const response = await apiClient.put(`/auth/usuarios/${usuarioId}`, usuarioData);
    return response.data;
  },

  /**
   * Asigna una difusora a un usuario
   */
  asignarDifusora: async (usuarioId, difusoraId) => {
    const response = await apiClient.post(`/auth/usuarios/${usuarioId}/difusoras?difusora_id=${difusoraId}`);
    return response.data;
  },

  /**
   * Asigna múltiples difusoras a un usuario
   */
  asignarDifusorasMultiple: async (usuarioId, difusorasIds) => {
    const response = await apiClient.post(`/auth/usuarios/${usuarioId}/difusoras/multiple`, difusorasIds);
    return response.data;
  },

  /**
   * Remueve una difusora de un usuario
   */
  removerDifusora: async (usuarioId, difusoraId) => {
    const response = await apiClient.delete(`/auth/usuarios/${usuarioId}/difusoras/${difusoraId}`);
    return response.data;
  },

  /**
   * Obtiene información del perfil del usuario actual
   */
  getMyProfile: async () => {
    const response = await apiClient.get('/auth/me');
    return response.data;
  },

  /**
   * Actualiza el perfil del usuario actual
   */
  updateMyProfile: async (profileData) => {
    const response = await apiClient.put('/auth/me', profileData);
    return response.data;
  },

  /**
   * Cambia la contraseña del usuario actual
   */
  changePassword: async (passwordData) => {
    const response = await apiClient.post('/auth/me/change-password', passwordData);
    return response.data;
  },

  /**
   * Elimina la cuenta del usuario actual
   */
  deleteMyAccount: async () => {
    const response = await apiClient.delete('/auth/me');
    return response.data;
  },
};

