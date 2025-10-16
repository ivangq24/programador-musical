import apiClient from '../client'

// Obtener difusoras con filtros
export const getDifusoras = async (params = {}) => {
  try {
    const response = await apiClient.get('/catalogos/difusoras/', { params })
    return response.data
  } catch (error) {
    console.error('Error fetching difusoras:', error)
    throw error
  }
}

// Obtener una difusora específica
export const getDifusora = async (difusoraId) => {
  try {
    const response = await apiClient.get(`/catalogos/difusoras/${difusoraId}`)
    return response.data
  } catch (error) {
    console.error('Error fetching difusora:', error)
    throw error
  }
}

// Crear nueva difusora
export const createDifusora = async (difusoraData) => {
  try {
    const response = await apiClient.post('/catalogos/difusoras/', difusoraData)
    return response.data
  } catch (error) {
    console.error('Error creating difusora:', error)
    throw error
  }
}

// Actualizar difusora
export const updateDifusora = async (difusoraId, difusoraData) => {
  try {
    const response = await apiClient.put(`/catalogos/difusoras/${difusoraId}`, difusoraData)
    return response.data
  } catch (error) {
    console.error('Error updating difusora:', error)
    throw error
  }
}

// Eliminar difusora
export const deleteDifusora = async (difusoraId) => {
  try {
    const response = await apiClient.delete(`/catalogos/difusoras/${difusoraId}`)
    return response.data
  } catch (error) {
    console.error('Error deleting difusora:', error)
    throw error
  }
}

// Obtener estadísticas de difusoras
export const getDifusorasStats = async () => {
  try {
    const response = await apiClient.get('/catalogos/difusoras/stats/summary')
    return response.data
  } catch (error) {
    console.error('Error fetching difusoras stats:', error)
    throw error
  }
}
