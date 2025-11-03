import apiClient from '../client'

// Obtener canciones con filtros
export const getCanciones = async (params = {}) => {
  try {
    const response = await apiClient.get('/categorias/canciones', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching canciones:', error)
    throw error
  }
}

// Obtener una canción específica
export const getCancion = async (cancionId) => {
  try {
    const response = await apiClient.get(`/categorias/canciones/${cancionId}`)
    return response.data
  } catch (error) {
    console.error('Error fetching cancion:', error)
    throw error
  }
}

// Crear nueva canción
export const createCancion = async (cancionData) => {
  try {
    const response = await apiClient.post('/categorias/canciones', cancionData)
    return response.data
  } catch (error) {
    console.error('Error creating cancion:', error)
    throw error
  }
}

// Actualizar canción
export const updateCancion = async (cancionId, cancionData) => {
  try {
    const response = await apiClient.put(`/categorias/canciones/${cancionId}`, cancionData)
    return response.data
  } catch (error) {
    console.error('Error updating cancion:', error)
    throw error
  }
}

// Eliminar canción
export const deleteCancion = async (cancionId) => {
  try {
    const response = await apiClient.delete(`/categorias/canciones/${cancionId}`)
    return response.data
  } catch (error) {
    console.error('Error deleting cancion:', error)
    throw error
  }
}

// Obtener estadísticas de canciones
export const getCancionesStats = async () => {
  try {
    const response = await apiClient.get('/categorias/stats')
    return response.data
  } catch (error) {
    console.error('Error fetching canciones stats:', error)
    throw error
  }
}

// Obtener categorías únicas de las canciones
export const getCategoriasCanciones = async () => {
  try {
    const response = await apiClient.get('/categorias/categorias/items')
    return response.data
  } catch (error) {
    console.error('Error fetching categorias:', error)
    throw error
  }
}

// Guardar categorías de una política
export const guardarCategoriasPolitica = async (politicaId, categorias) => {
  try {
    const response = await apiClient.post(`/categorias/canciones/politica/${politicaId}/categorias`, categorias)
    return response.data
  } catch (error) {
    console.error('Error guardando categorías de política:', error)
    throw error
  }
}

// Obtener categorías de una política
export const obtenerCategoriasPolitica = async (politicaId) => {
  try {
    const response = await apiClient.get(`/categorias/canciones/politica/${politicaId}/categorias`)
    return response.data
  } catch (error) {
    console.error('Error obteniendo categorías de política:', error)
    throw error
  }
}
