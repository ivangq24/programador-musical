import apiClient from '../client'

// Obtener difusoras con filtros
export const getDifusoras = async (params = {}) => {
  try {
    const response = await apiClient.get('/catalogos/general/difusoras', { params })
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener una difusora específica
export const getDifusora = async (difusoraId) => {
  try {
    const response = await apiClient.get(`/catalogos/general/difusoras/${difusoraId}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Crear nueva difusora
export const createDifusora = async (difusoraData) => {
  try {
    const response = await apiClient.post('/catalogos/general/difusoras', difusoraData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Actualizar difusora
export const updateDifusora = async (difusoraId, difusoraData) => {
  try {
    const response = await apiClient.put(`/catalogos/general/difusoras/${difusoraId}`, difusoraData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Eliminar difusora
export const deleteDifusora = async (difusoraId) => {
  try {
    const response = await apiClient.delete(`/catalogos/general/difusoras/${difusoraId}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener estadísticas de difusoras
export const getDifusorasStats = async () => {
  try {
    const response = await apiClient.get('/catalogos/general/difusoras/stats')
    return response.data
  } catch (error) {

    throw error
  }
}
