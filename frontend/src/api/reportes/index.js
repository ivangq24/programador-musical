import apiClient from '../client'

// APIs de reportes y estadísticas
export const getEstadisticasGeneral = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/general', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas generales:', error)
    throw error
  }
}

export const getEstadisticasCategorias = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/categorias', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por categoría:', error)
    throw error
  }
}

export const getEstadisticasCanciones = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/canciones', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por canción:', error)
    throw error
  }
}

export const getEstadisticasArtistas = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/artistas', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por artista:', error)
    throw error
  }
}

export const getEstadisticasAlbums = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/albums', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por álbum:', error)
    throw error
  }
}

export const getDistribucionHoraria = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/distribucion-horaria', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching distribución horaria:', error)
    throw error
  }
}

export const getDistribucionDiaSemana = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/distribucion-dia-semana', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching distribución por día de semana:', error)
    throw error
  }
}

export const getEstadisticasDifusoras = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/difusoras', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por difusora:', error)
    throw error
  }
}

export const getEstadisticasPoliticas = async (params = {}) => {
  try {
    const response = await apiClient.get('/reportes/estadisticas/politicas', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching estadísticas por política:', error)
    throw error
  }
}
