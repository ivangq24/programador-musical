const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001/api'

export const clientesApi = {
  // Obtener todos los clientes
  getClientes: async () => {
    const response = await fetch(`${API_BASE_URL}/catalogos/generales/clientes`)
    if (!response.ok) {
      throw new Error('Error al obtener clientes')
    }
    return response.json()
  },

  // Obtener un cliente por ID
  getClienteById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/catalogos/generales/clientes/${id}`)
    if (!response.ok) {
      throw new Error('Error al obtener cliente')
    }
    return response.json()
  },

  // Crear un nuevo cliente
  createCliente: async (clienteData) => {
    const response = await fetch(`${API_BASE_URL}/catalogos/generales/clientes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(clienteData),
    })
    if (!response.ok) {
      throw new Error('Error al crear cliente')
    }
    return response.json()
  },

  // Actualizar un cliente
  updateCliente: async (id, clienteData) => {
    const response = await fetch(`${API_BASE_URL}/catalogos/generales/clientes/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(clienteData),
    })
    if (!response.ok) {
      throw new Error('Error al actualizar cliente')
    }
    return response.json()
  },

  // Eliminar un cliente
  deleteCliente: async (id) => {
    const response = await fetch(`${API_BASE_URL}/catalogos/generales/clientes/${id}`, {
      method: 'DELETE',
    })
    if (!response.ok) {
      throw new Error('Error al eliminar cliente')
    }
    return response.json()
  },
}
