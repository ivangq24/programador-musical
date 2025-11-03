'use client'

import { useState, useRef, useCallback, useMemo } from 'react'
import { validateCSV, importCanciones, downloadCSVTemplate } from '../../../../api/import-csv/index'
import { 
  Upload, 
  FileText, 
  CheckCircle, 
  AlertCircle, 
  Download, 
  X, 
  Eye, 
  EyeOff,
  RefreshCw,
  Database,
  Settings,
  Info,
  ArrowRight,
  ArrowDown,
  Search,
  Filter
} from 'lucide-react'

export default function ImportCSVComponent({ onBack }) {
  const [csvFile, setCsvFile] = useState(null)
  const [csvData, setCsvData] = useState([])
  const [headers, setHeaders] = useState([])
  const [columnMapping, setColumnMapping] = useState({})
  const [previewData, setPreviewData] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [success, setSuccess] = useState(false)
  const [showPreview, setShowPreview] = useState(true)
  const [showMapping, setShowMapping] = useState(false)
  const [importProgress, setImportProgress] = useState(0)
  const [importedCount, setImportedCount] = useState(0)
  const [skippedCount, setSkippedCount] = useState(0)
  const fileInputRef = useRef(null)

  // Expected fields for the system - All fields are optional - Memoizado
  const expectedFields = useMemo(() => [
    { key: 'cancionid', label: 'ID Canción', required: false, type: 'number' },
    { key: 'difusora', label: 'Difusora', required: false, type: 'string' },
    { key: 'categoria', label: 'Categoría', required: false, type: 'string' },
    { key: 'categoriaid', label: 'ID Categoría', required: false, type: 'number' },
    { key: 'idmedia', label: 'ID Media', required: false, type: 'string' },
    { key: 'catidmedia', label: 'Cat ID Media', required: false, type: 'number' },
    { key: 'idusuario1', label: 'ID Usuario 1', required: false, type: 'number' },
    { key: 'idusuario2', label: 'ID Usuario 2', required: false, type: 'number' },
    { key: 'titulo', label: 'Título', required: false, type: 'string' },
    { key: 'interprete', label: 'Intérprete', required: false, type: 'string' },
    { key: 'interprete2', label: 'Intérprete 2', required: false, type: 'string' },
    { key: 'interprete3', label: 'Intérprete 3', required: false, type: 'string' },
    { key: 'interprete4', label: 'Intérprete 4', required: false, type: 'string' },
    { key: 'sello', label: 'Sello', required: false, type: 'string' },
    { key: 'duracion', label: 'Duración', required: false, type: 'number' },
    { key: 'version', label: 'Versión', required: false, type: 'string' },
    { key: 'lenguaje', label: 'Lenguaje', required: false, type: 'string' },
    { key: 'año', label: 'Año', required: false, type: 'number' },
    { key: 'bpm', label: 'BPM', required: false, type: 'number' },
    { key: 'tiempo_entrada', label: 'Tiempo Entrada', required: false, type: 'string' },
    { key: 'tiempo_salida', label: 'Tiempo Salida', required: false, type: 'string' },
    { key: 'archivo', label: 'Archivo', required: false, type: 'string' },
    { key: 'album', label: 'Álbum', required: false, type: 'string' },
    { key: 'autor', label: 'Autor', required: false, type: 'string' },
    { key: 'genero_musical', label: 'Género Musical', required: false, type: 'string' },
    { key: 'energia', label: 'Energía', required: false, type: 'number' },
    { key: 'tiempo', label: 'Tiempo', required: false, type: 'string' },
    { key: 'humor', label: 'Humor', required: false, type: 'string' },
    { key: 'idusuario3', label: 'ID Usuario 3', required: false, type: 'number' },
    { key: 'idusuario4', label: 'ID Usuario 4', required: false, type: 'number' },
    { key: 'idusuario5', label: 'ID Usuario 5', required: false, type: 'number' }
  ], [])

  // Handlers memoizados para evitar recreaciones
  // autoMapColumns debe definirse primero porque parseCSV lo usa
  const autoMapColumns = useCallback((csvHeaders) => {
    const mapping = {}
    
    expectedFields.forEach(field => {
      const fieldKey = field.key.toLowerCase()
      
      // Try exact match first
      let matchedIndex = csvHeaders.findIndex(header => 
        header.toLowerCase() === fieldKey || 
        header.toLowerCase() === fieldKey.replace('_', ' ') ||
        header.toLowerCase() === fieldKey.replace('_', '')
      )
      
      // Try partial matches for common variations
      if (matchedIndex === -1) {
        const variations = [
          fieldKey,
          fieldKey.replace('_', ' '),
          fieldKey.replace('_', ''),
          fieldKey.replace('id', 'id'),
          fieldKey.replace('usuario', 'user'),
          fieldKey.replace('interprete', 'artist'),
          fieldKey.replace('genero', 'genre'),
          fieldKey.replace('musical', 'music')
        ]
        
        for (const variation of variations) {
          matchedIndex = csvHeaders.findIndex(header => 
            header.toLowerCase().includes(variation) ||
            variation.includes(header.toLowerCase())
          )
          if (matchedIndex !== -1) break
        }
      }
      
      mapping[field.key] = matchedIndex !== -1 ? matchedIndex : -1
    })
    
    setColumnMapping(mapping)
  }, [expectedFields])

  // parseCSV debe definirse después de autoMapColumns porque lo usa
  const parseCSV = useCallback((file) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const text = e.target.result
        const lines = text.split('\n').filter(line => line.trim())
        
        if (lines.length < 2) {
          setError('El archivo CSV debe tener al menos una fila de encabezados y una fila de datos')
          return
        }

        const csvHeaders = lines[0].split(',').map(h => h.trim().toLowerCase())
        setHeaders(csvHeaders)
        
        const data = lines.slice(1).map(line => {
          const values = line.split(',').map(v => v.trim())
          const row = {}
          csvHeaders.forEach((header, index) => {
            row[header] = values[index] || ''
          })
          return row
        })
        
        setCsvData(data)
        setPreviewData(data.slice(0, 5)) // Show first 5 rows for preview
        setShowPreview(true) // Automatically show preview when file is loaded
        autoMapColumns(csvHeaders)
      } catch (err) {
        setError('Error al procesar el archivo CSV: ' + err.message)
      }
    }
    reader.readAsText(file)
  }, [autoMapColumns])

  // handleFileUpload debe definirse después de parseCSV porque lo usa
  const handleFileUpload = useCallback((event) => {
    const file = event.target.files[0]
    if (file && file.type === 'text/csv') {
      setCsvFile(file)
      setError(null)
      parseCSV(file)
    } else {
      setError('Por favor selecciona un archivo CSV válido')
    }
  }, [parseCSV])

  const handleImport = useCallback(async () => {
    setLoading(true)
    setError(null)
    setSuccess(false)
    setImportProgress(0)
    setImportedCount(0)
    setSkippedCount(0)

    try {
      // Mapear datos del CSV
      const mappedData = csvData.map((row, index) => {
        const mappedRow = {}
        
        expectedFields.forEach(field => {
          const columnIndex = columnMapping[field.key]
          if (columnIndex !== -1) {
            const value = row[headers[columnIndex]]
            mappedRow[field.key] = value
          } else {
            mappedRow[field.key] = ''
          }
        })
        
        return mappedRow
      })

      // Validar datos antes de importar
      setImportProgress(25)
      const validationResult = await validateCSV(mappedData)
      
      if (validationResult.invalid_rows > 0) {
        setError(`Se encontraron ${validationResult.invalid_rows} filas con errores. Revisa los datos antes de continuar.`)
        setImportProgress(0)
        return
      }

      // Importar datos
      setImportProgress(50)
      const importResult = await importCanciones(mappedData)
      
      setImportedCount(importResult.imported_count)
      setSkippedCount(importResult.skipped_count)
      setImportProgress(100)
      
      if (importResult.errors && importResult.errors.length > 0) {
        setError(`Importación completada con ${importResult.errors.length} errores. ${importResult.imported_count} canciones importadas, ${importResult.skipped_count} omitidas.`)
      } else {
        setSuccess(true)
        setError(null)
      }
      
    } catch (err) {
      console.error('Error importing:', err)
      setError('Error al importar datos: ' + (err.response?.data?.detail || err.message))
      setSuccess(false)
    } finally {
      setLoading(false)
    }
  }, [csvData, headers, columnMapping, expectedFields])

  const resetImport = useCallback(() => {
    setCsvFile(null)
    setCsvData([])
    setHeaders([])
    setColumnMapping({})
    setPreviewData([])
    setError(null)
    setSuccess(false)
    setImportProgress(0)
    setImportedCount(0)
    setSkippedCount(0)
    if (fileInputRef.current) {
      fileInputRef.current.value = ''
    }
  }, [])

  const downloadTemplate = useCallback(async () => {
    try {
      setLoading(true)
      const result = await downloadCSVTemplate()
      setSuccess(true)
      setError(null)
    } catch (error) {
      console.error('Error downloading template:', error)
      setError('Error al descargar la plantilla: ' + error.message)
    } finally {
      setLoading(false)
    }
  }, [])

  const getMappingStatus = useCallback((field) => {
    const columnIndex = columnMapping[field.key]
    if (columnIndex === -1) {
      return { status: 'unmapped', color: 'text-red-500', icon: AlertCircle }
    } else {
      return { status: 'mapped', color: 'text-green-500', icon: CheckCircle }
    }
  }, [columnMapping])

  const handleToggleMapping = useCallback(() => {
    setShowMapping(prev => !prev)
  }, [])

  // Preview headers memoizado para evitar recalcular
  const previewHeaders = useMemo(() => {
    return headers.slice(0, 8)
  }, [headers])

  return (
    <>
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
        {/* Fondo decorativo */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute top-0 left-1/4 w-96 h-96 bg-blue-200/20 rounded-full blur-3xl"></div>
          <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-indigo-200/20 rounded-full blur-3xl"></div>
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-blue-200/10 rounded-full blur-2xl"></div>
        </div>

        <div className="relative z-10 p-6">
          <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
            {/* Enhanced Header */}
            <div className="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
              <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                    <Upload className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Importar Canciones desde CSV</h1>
                    <p className="text-blue-100 text-sm">Importa datos de canciones desde archivos CSV con detección automática de columnas</p>
                  </div>
                </div>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
            </div>

            {/* File Upload Section */}
            <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
              {/* Header with Icon and Title */}
              <div className="flex items-center space-x-3 mb-6">
                <div className="p-3 bg-gradient-to-br from-blue-100 to-blue-200 rounded-xl shadow-lg">
                  <FileText className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <h2 className="text-2xl font-bold text-gray-900">Seleccionar Archivo CSV</h2>
                  <p className="text-gray-600 text-sm">Sube tu archivo CSV o descarga la plantilla</p>
                </div>
              </div>
              
              <div className="space-y-6">
                {/* Drag & Drop Area */}
                <div className="relative">
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept=".csv"
                    onChange={handleFileUpload}
                    className="hidden"
                    id="csv-upload"
                  />
                  
                  {/* Upload Zone */}
                  <div className="border-2 border-dashed border-gray-300 rounded-2xl p-8 text-center hover:border-blue-400 hover:bg-blue-50/30 transition-all duration-300 group bg-white">
                    <div className="flex flex-col items-center space-y-4">
                      <div className="p-4 bg-gradient-to-br from-blue-100 to-blue-200 rounded-full group-hover:from-blue-200 group-hover:to-blue-300 transition-colors duration-300 shadow-lg">
                        <Upload className="w-8 h-8 text-blue-600" />
                      </div>
                      
                      <div className="space-y-2">
                        <h3 className="text-lg font-semibold text-gray-900">
                          {csvFile ? 'Archivo Seleccionado' : 'Arrastra tu archivo CSV aquí'}
                        </h3>
                        <p className="text-gray-600 text-sm">
                          {csvFile ? 'Archivo cargado correctamente' : 'O haz clic para seleccionar un archivo'}
                        </p>
                      </div>
                      
                      <label
                        htmlFor="csv-upload"
                        className="inline-flex items-center space-x-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white px-6 py-3 rounded-xl transition-all duration-300 cursor-pointer font-semibold shadow-lg hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5"
                      >
                        <Upload className="w-5 h-5" />
                        <span>{csvFile ? 'Cambiar Archivo' : 'Seleccionar Archivo CSV'}</span>
                      </label>
                    </div>
                  </div>
                  
                  {/* File Info Display */}
                  {csvFile && (
                    <div className="mt-4 p-4 bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-200 rounded-xl shadow-md">
                      <div className="flex items-center space-x-3">
                        <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg shadow-md">
                          <CheckCircle className="w-5 h-5 text-green-600" />
                        </div>
                        <div className="flex-1">
                          <p className="font-bold text-green-800">{csvFile.name}</p>
                          <p className="text-sm text-green-700 font-medium">
                            {(csvFile.size / 1024).toFixed(1)} KB • Archivo CSV
                          </p>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Action Buttons */}
                <div className="flex flex-col sm:flex-row gap-4">
                  {/* Template Download - Always visible */}
                  <div className="flex-1">
                    <button
                      onClick={downloadTemplate}
                      className="w-full flex items-center justify-center space-x-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white px-6 py-4 rounded-xl transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold"
                    >
                      <Download className="w-5 h-5" />
                      <span>Descargar Plantilla CSV</span>
                    </button>
                  </div>
                  
                  {/* File Actions - Only when file is loaded */}
                  {csvFile && (
                    <div className="flex flex-col sm:flex-row gap-3 flex-1">
                      <button
                        onClick={handleToggleMapping}
                        className="flex items-center justify-center space-x-2 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white px-6 py-4 rounded-xl transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold"
                      >
                        <Settings className="w-5 h-5" />
                        <span>{showMapping ? 'Ocultar' : 'Mostrar'} Mapeo</span>
                      </button>
                      
                      <button
                        onClick={resetImport}
                        className="flex items-center justify-center space-x-2 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white px-6 py-4 rounded-xl transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold"
                      >
                        <X className="w-5 h-5" />
                        <span>Limpiar Todo</span>
                      </button>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Preview Section - Always show when there's data */}
            {csvFile && previewData.length > 0 && (
              <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20 border-t border-gray-200">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-gradient-to-br from-purple-100 to-purple-200 rounded-lg shadow-md">
                    <Eye className="w-5 h-5 text-purple-600" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-900">Vista Previa de Datos</h2>
                </div>
                
                <div className="overflow-x-auto bg-white rounded-xl shadow-lg border border-gray-200">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                      <tr>
                        {previewHeaders.map((header, index) => (
                          <th key={index} className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                            {header}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {previewData.map((row, index) => (
                        <tr key={index} className={`hover:bg-blue-50/50 transition-all duration-200 ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                          {previewHeaders.map((header, colIndex) => (
                            <td key={colIndex} className="px-6 py-4 text-sm text-gray-900">
                              {row[header] || '-'}
                            </td>
                          ))}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* Column Mapping Section - Optional, only show when requested */}
            {csvFile && showMapping && Object.keys(columnMapping).length > 0 && (
              <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20 border-t border-gray-200">
                <div className="flex items-center space-x-2 mb-4">
                  <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg shadow-md">
                    <Settings className="w-5 h-5 text-green-600" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-900">Mapeo Automático de Columnas</h2>
                </div>
                
                <div className="overflow-x-auto bg-white rounded-xl shadow-lg border border-gray-200">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                      <tr>
                        <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                          Campo del Sistema
                        </th>
                        <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                          Columna CSV
                        </th>
                        <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                          Tipo
                        </th>
                        <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                          Estado
                        </th>
                        <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                          Requerido
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {expectedFields.map((field, index) => {
                        const mappingStatus = getMappingStatus(field)
                        const StatusIcon = mappingStatus.icon
                        const columnIndex = columnMapping[field.key]
                        const mappedHeader = columnIndex !== -1 ? headers[columnIndex] : 'No mapeado'
                        
                        return (
                          <tr key={field.key} className={`hover:bg-blue-50/50 transition-all duration-200 ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="text-sm font-semibold text-gray-900">{field.label}</div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="text-sm text-gray-700">{mappedHeader}</div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className="inline-flex px-3 py-1 text-xs font-bold rounded-full bg-gradient-to-r from-blue-100 to-blue-50 text-blue-800 border border-blue-300 shadow-sm">
                                {field.type}
                              </span>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="flex items-center space-x-2">
                                <StatusIcon className={`w-5 h-5 ${mappingStatus.color}`} />
                                <span className={`text-sm font-medium ${mappingStatus.color}`}>
                                  {columnIndex !== -1 ? 'Mapeado' : 'No mapeado'}
                                </span>
                              </div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className={`inline-flex px-3 py-1 text-xs font-bold rounded-full border shadow-sm ${
                                field.required 
                                  ? 'bg-gradient-to-r from-red-100 to-red-50 text-red-800 border-red-300' 
                                  : 'bg-gradient-to-r from-gray-100 to-gray-50 text-gray-800 border-gray-300'
                              }`}>
                                {field.required ? 'Sí' : 'No'}
                              </span>
                            </td>
                          </tr>
                        )
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            )}


            {/* Import Progress */}
            {loading && (
              <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20 border-t border-gray-200">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="p-2 bg-gradient-to-br from-blue-100 to-blue-200 rounded-lg shadow-md">
                    <RefreshCw className="w-5 h-5 text-blue-600 animate-spin" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-900">Importando Datos...</h2>
                </div>
                
                <div className="space-y-4 bg-white rounded-xl p-6 shadow-lg border border-gray-200">
                  <div className="w-full bg-gray-200 rounded-full h-4 shadow-inner">
                    <div 
                      className="bg-gradient-to-r from-blue-600 to-indigo-600 h-4 rounded-full transition-all duration-300 shadow-md"
                      style={{ width: `${importProgress}%` }}
                    ></div>
                  </div>
                  
                  <div className="flex justify-between text-sm font-semibold text-gray-700">
                    <span>Progreso: {importProgress}%</span>
                    <span>Importadas: {importedCount} | Omitidas: {skippedCount}</span>
                  </div>
                </div>
              </div>
            )}

            {/* Results */}
            {success && (
              <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20 border-t border-gray-200">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg shadow-md">
                    <CheckCircle className="w-5 h-5 text-green-600" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-900">Importación Completada</h2>
                </div>
                
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="bg-gradient-to-br from-green-50 to-emerald-50 border-2 border-green-300 rounded-xl p-5 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="text-3xl font-bold text-green-700 mb-1">{importedCount}</div>
                    <div className="text-sm font-semibold text-green-800">Canciones Importadas</div>
                  </div>
                  <div className="bg-gradient-to-br from-yellow-50 to-amber-50 border-2 border-yellow-300 rounded-xl p-5 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="text-3xl font-bold text-yellow-700 mb-1">{skippedCount}</div>
                    <div className="text-sm font-semibold text-yellow-800">Registros Omitidos</div>
                  </div>
                  <div className="bg-gradient-to-br from-blue-50 to-indigo-50 border-2 border-blue-300 rounded-xl p-5 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="text-3xl font-bold text-blue-700 mb-1">{importedCount + skippedCount}</div>
                    <div className="text-sm font-semibold text-blue-800">Total Procesados</div>
                  </div>
                </div>
              </div>
            )}

            {/* Error Display */}
            {error && (
              <div className="px-8 py-6 bg-gradient-to-br from-gray-50 via-white to-blue-50/20 border-t border-gray-200">
                <div className="bg-gradient-to-r from-red-50 to-pink-50 border-2 border-red-300 rounded-xl p-6 shadow-lg">
                  <div className="flex items-center space-x-3 mb-2">
                    <div className="p-2 bg-gradient-to-br from-red-100 to-red-200 rounded-lg shadow-md">
                      <AlertCircle className="w-5 h-5 text-red-600" />
                    </div>
                    <h2 className="text-lg font-bold text-red-900">Error</h2>
                  </div>
                  <p className="text-red-800 font-medium">{error}</p>
                </div>
              </div>
            )}

            {/* Import Button */}
            {csvFile && !loading && !success && (
              <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-t-2 border-gray-300 shadow-inner">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg shadow-md">
                      <Database className="w-5 h-5 text-green-600" />
                    </div>
                    <span className="font-semibold text-gray-900">¿Listo para importar?</span>
                  </div>
                  
                  <button
                    onClick={handleImport}
                    disabled={loading}
                    className="bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white px-8 py-4 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Download className="w-5 h-5" />
                    <span>Importar CSV</span>
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  )
}
