import apiClient from '../../client'

// Obtener lista de cortes con filtros
export const getCortes = async (params = {}) => {
  try {
    const response = await apiClient.get('/catalogos/general/cortes/', { params })
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener un corte por ID
export const getCorte = async (id) => {
  try {
    const response = await apiClient.get(`/catalogos/general/cortes/${id}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Crear un nuevo corte
export const createCorte = async (corteData) => {
  try {
    const response = await apiClient.post('/catalogos/general/cortes/', corteData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Actualizar un corte
export const updateCorte = async (id, corteData) => {
  try {
    const response = await apiClient.put(`/catalogos/general/cortes/${id}`, corteData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Eliminar un corte
export const deleteCorte = async (id) => {
  try {
    const response = await apiClient.delete(`/catalogos/general/cortes/${id}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener estadísticas de cortes
export const getCortesStats = async () => {
  try {
    const response = await apiClient.get('/catalogos/general/cortes/stats/summary')
    return response.data
  } catch (error) {

    throw error
  }
}
