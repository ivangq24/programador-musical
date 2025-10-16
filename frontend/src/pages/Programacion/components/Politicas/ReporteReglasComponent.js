'use client'

import { useState } from 'react'
import { ArrowLeft, FileText, Download, Filter, Calendar } from 'lucide-react'

export default function ReporteReglasComponent({ onBack }) {
  const [filtros, setFiltros] = useState({
    fechaInicio: '',
    fechaFin: '',
    difusora: '',
    politica: ''
  })

  const [reporteData, setReporteData] = useState([
    {
      id: 1,
      regla: 'Regla de Rotación',
      tipo: 'Rotación',
      politica: 'Política General',
      difusora: 'XHDQ',
      estado: 'Activa',
      ultimaModificacion: '2025-01-15'
    },
    {
      id: 2,
      regla: 'Regla de Separación',
      tipo: 'Separación',
      politica: 'Política Matutina',
      difusora: 'XRAD',
      estado: 'Inactiva',
      ultimaModificacion: '2025-01-10'
    }
  ])

  const handleFiltroChange = (campo, valor) => {
    setFiltros(prev => ({ ...prev, [campo]: valor }))
  }

  const handleGenerarReporte = () => {
    console.log('Generando reporte con filtros:', filtros)
    // Aquí se implementaría la lógica para generar el reporte
  }

  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center space-x-4">
            <h1 className="text-2xl font-bold text-gray-900">Reporte de Reglas</h1>
          </div>
        </div>

        {/* Filtros */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 mb-6">
          <div className="flex items-center space-x-2 mb-4">
            <Filter className="w-5 h-5 text-gray-600" />
            <h2 className="text-lg font-semibold text-gray-900">Filtros</h2>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Fecha Inicio</label>
              <input
                type="date"
                value={filtros.fechaInicio}
                onChange={(e) => handleFiltroChange('fechaInicio', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Fecha Fin</label>
              <input
                type="date"
                value={filtros.fechaFin}
                onChange={(e) => handleFiltroChange('fechaFin', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Difusora</label>
              <select
                value={filtros.difusora}
                onChange={(e) => handleFiltroChange('difusora', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Todas</option>
                <option value="XHDQ">XHDQ</option>
                <option value="XRAD">XRAD</option>
                <option value="XHPER">XHPER</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Política</label>
              <select
                value={filtros.politica}
                onChange={(e) => handleFiltroChange('politica', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Todas</option>
                <option value="general">Política General</option>
                <option value="matutina">Política Matutina</option>
                <option value="vespertina">Política Vespertina</option>
              </select>
            </div>
          </div>
          
          <div className="mt-4 flex space-x-3">
            <button
              onClick={handleGenerarReporte}
              className="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              <FileText className="w-4 h-4" />
              <span>Generar Reporte</span>
            </button>
            <button className="flex items-center space-x-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
              <Download className="w-4 h-4" />
              <span>Exportar</span>
            </button>
          </div>
        </div>

        {/* Tabla de datos */}
        <div className="flex-1 bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
          <div className="overflow-auto h-full">
            <table className="w-full">
              <thead className="bg-gray-50 sticky top-0">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Regla</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipo</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Política</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Difusora</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Última Modificación</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {reporteData.map((row) => (
                  <tr key={row.id} className="hover:bg-gray-50">
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.regla}</td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.tipo}</td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.politica}</td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.difusora}</td>
                    <td className="px-4 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                        row.estado === 'Activa' 
                          ? 'bg-green-100 text-green-800' 
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {row.estado}
                      </span>
                    </td>
                    <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.ultimaModificacion}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}
