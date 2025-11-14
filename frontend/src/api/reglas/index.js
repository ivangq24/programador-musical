import client from '../client'

// Obtener todas las reglas de una política
export const getReglasByPolitica = async (politicaId) => {
  try {
    const response = await client.get(`/programacion/politicas/${politicaId}/reglas`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener una regla específica
export const getRegla = async (reglaId) => {
  try {
    const response = await client.get(`/programacion/reglas/${reglaId}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Crear una nueva regla
export const createRegla = async (reglaData) => {
  try {
    const response = await client.post('/programacion/reglas', reglaData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Actualizar una regla existente
export const updateRegla = async (reglaId, reglaData) => {
  try {
    const response = await client.put(`/programacion/reglas/${reglaId}`, reglaData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Eliminar una regla
export const deleteRegla = async (reglaId) => {
  try {
    const response = await client.delete(`/programacion/reglas/${reglaId}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Obtener una separación específica
export const getSeparacion = async (separacionId) => {
  try {
    const response = await client.get(`/programacion/separaciones/${separacionId}`)
    return response.data
  } catch (error) {

    throw error
  }
}

// Actualizar una separación existente
export const updateSeparacion = async (separacionId, separacionData) => {
  try {
    const response = await client.put(`/programacion/separaciones/${separacionId}`, separacionData)
    return response.data
  } catch (error) {

    throw error
  }
}

// Eliminar una separación
export const deleteSeparacion = async (separacionId) => {
  try {
    const response = await client.delete(`/programacion/separaciones/${separacionId}`)
    return response.data
  } catch (error) {

    throw error
  }
}
