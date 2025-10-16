import { useState, useEffect } from 'react'

export const useCatalogos = () => {
  const [catalogos, setCatalogos] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const fetchCatalogos = async () => {
    setLoading(true)
    try {
      // Aquí iría la llamada a la API
      // const response = await catalogosApi.getCatalogos()
      // setCatalogos(response.data)
      setLoading(false)
    } catch (err) {
      setError(err.message)
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchCatalogos()
  }, [])

  return {
    catalogos,
    loading,
    error,
    refetch: fetchCatalogos
  }
}
