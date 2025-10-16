import apiClient from '../client'

// Validar datos del CSV antes de la importación
export const validateCSV = async (csvData) => {
  try {
    const response = await apiClient.post('/programacion/importcsv/validate-csv', csvData)
    return response.data
  } catch (error) {
    console.error('Error validating CSV:', error)
    throw error
  }
}

// Importar canciones desde CSV
export const importCanciones = async (csvData) => {
  try {
    const response = await apiClient.post('/programacion/importcsv/import-canciones', csvData)
    return response.data
  } catch (error) {
    console.error('Error importing canciones:', error)
    throw error
  }
}

// Obtener plantilla CSV
export const getCSVTemplate = async () => {
  try {
    const response = await apiClient.get('/programacion/importcsv/template')
    return response.data
  } catch (error) {
    console.error('Error getting CSV template:', error)
    throw error
  }
}

// Obtener reglas de validación
export const getValidationRules = async () => {
  try {
    const response = await apiClient.get('/programacion/importcsv/validation-rules')
    return response.data
  } catch (error) {
    console.error('Error getting validation rules:', error)
    throw error
  }
}

// Descargar plantilla CSV
export const downloadCSVTemplate = async () => {
  try {
    const response = await apiClient.get('/programacion/importcsv/template')
    const { csv_content, filename } = response.data
    
    // Crear y descargar archivo
    const blob = new Blob([csv_content], { type: 'text/csv;charset=utf-8;' })
    const link = document.createElement('a')
    const url = URL.createObjectURL(blob)
    link.setAttribute('href', url)
    link.setAttribute('download', filename)
    link.style.visibility = 'hidden'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    
    return { success: true, filename }
  } catch (error) {
    console.error('Error downloading CSV template:', error)
    throw error
  }
}
