import apiClient from '../client'

export const listCategorias = async () => {
  const { data } = await apiClient.get('/categorias/categorias/items')
  return data
}

export const listCategoriasStats = async () => {
  const { data } = await apiClient.get('/categorias/categorias/items-stats')
  return data
}

export const createCategoria = async (categoria) => {
  const { data } = await apiClient.post('/categorias/categorias', categoria)
  return data
}

export const updateCategoria = async (id, categoria) => {
  const { data } = await apiClient.put(`/categorias/categorias/${id}`, categoria)
  return data
}

export const deleteCategoria = async (id) => {
  const { data } = await apiClient.delete(`/categorias/categorias/${id}`)
  return data
}

export const getElementosCategoria = async (id) => {
  const { data } = await apiClient.get(`/categorias/categorias/${id}/elementos`)
  return data
}

export const moverCancionesCategoria = async ({ origenId, destinoId, cancionesIds }) => {
  const params = new URLSearchParams({ origen_id: origenId, destino_id: destinoId })
  const { data } = await apiClient.post(`/categorias/movimientos/mover?${params.toString()}`, cancionesIds)
  return data
}


