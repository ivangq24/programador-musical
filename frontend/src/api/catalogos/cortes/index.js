import apiClient from '../../client'

// Obtener lista de cortes con filtros
export const getCortes = async (params = {}) => {
  try {
    const response = await apiClient.get('/catalogos/general/cortes/', { params })
    return response.data
  } catch (error) {
    console.error('Error al obtener cortes:', error)
    throw error
  }
}

// Obtener un corte por ID
export const getCorte = async (id) => {
  try {
    const response = await apiClient.get(`/catalogos/general/cortes/${id}`)
    return response.data
  } catch (error) {
    console.error('Error al obtener corte:', error)
    throw error
  }
}

// Crear un nuevo corte
export const createCorte = async (corteData) => {
  try {
    const response = await apiClient.post('/catalogos/general/cortes/', corteData)
    return response.data
  } catch (error) {
    console.error('Error al crear corte:', error)
    throw error
  }
}

// Actualizar un corte
export const updateCorte = async (id, corteData) => {
  try {
    const response = await apiClient.put(`/catalogos/general/cortes/${id}`, corteData)
    return response.data
  } catch (error) {
    console.error('Error al actualizar corte:', error)
    throw error
  }
}

// Eliminar un corte
export const deleteCorte = async (id) => {
  try {
    const response = await apiClient.delete(`/catalogos/general/cortes/${id}`)
    return response.data
  } catch (error) {
    console.error('Error al eliminar corte:', error)
    throw error
  }
}

// Obtener estadísticas de cortes
export const getCortesStats = async () => {
  try {
    const response = await apiClient.get('/catalogos/general/cortes/stats/summary')
    return response.data
  } catch (error) {
    console.error('Error al obtener estadísticas de cortes:', error)
    throw error
  }
}
