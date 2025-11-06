'use client'

import React, { useState, useEffect, useCallback, useMemo, memo } from 'react'
import { 
  BarChart3, 
  TrendingUp, 
  Music, 
  Clock, 
  Calendar,
  Filter,
  X,
  RefreshCw,
  PieChart,
  Users,
  Disc,
  Radio
} from 'lucide-react'
import * as reportesApi from '../../../api/reportes'
import { getDifusoras } from '../../../api/difusoras'
import { getCategoriasCanciones } from '../../../api/canciones'
import { politicasApi } from '../../../api/programacion/politicasApi'

// Componente StatCard - Memoizado para evitar re-renders innecesarios
const StatCard = memo(({ title, value, icon: Icon, color = 'blue', subtitle }) => {
  const colorConfig = {
    blue: { 
      bg: 'bg-blue-500', 
      light: 'bg-blue-50', 
      text: 'text-blue-600',
      gradient: 'from-blue-500 to-blue-600',
      lightGradient: 'from-blue-50 to-blue-100'
    },
    green: { 
      bg: 'bg-green-500', 
      light: 'bg-green-50', 
      text: 'text-green-600',
      gradient: 'from-green-500 to-green-600',
      lightGradient: 'from-green-50 to-green-100'
    },
    purple: { 
      bg: 'bg-purple-500', 
      light: 'bg-purple-50', 
      text: 'text-purple-600',
      gradient: 'from-purple-500 to-purple-600',
      lightGradient: 'from-purple-50 to-purple-100'
    },
    orange: { 
      bg: 'bg-orange-500', 
      light: 'bg-orange-50', 
      text: 'text-orange-600',
      gradient: 'from-orange-500 to-orange-600',
      lightGradient: 'from-orange-50 to-orange-100'
    },
    red: { 
      bg: 'bg-red-500', 
      light: 'bg-red-50', 
      text: 'text-red-600',
      gradient: 'from-red-500 to-red-600',
      lightGradient: 'from-red-50 to-red-100'
    },
    indigo: { 
      bg: 'bg-indigo-500', 
      light: 'bg-indigo-50', 
      text: 'text-indigo-600',
      gradient: 'from-indigo-500 to-indigo-600',
      lightGradient: 'from-indigo-50 to-indigo-100'
    }
  }

  const config = colorConfig[color] || colorConfig.blue

  return (
    <div className="group bg-white rounded-2xl shadow-lg hover:shadow-xl border border-gray-200 p-6 transition-all duration-300 hover:-translate-y-1">
      <div className="flex items-start justify-between mb-4">
        <div className="flex-1">
          <p className="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-1">{title}</p>
          {subtitle && (
            <p className="text-xs text-gray-400 mb-3">{subtitle}</p>
          )}
          <p className="text-4xl font-bold text-gray-900">{value}</p>
        </div>
        <div className={`p-4 rounded-2xl bg-gradient-to-br ${config.gradient} shadow-lg group-hover:scale-110 transition-transform duration-300`}>
          <Icon className="w-8 h-8 text-white" />
        </div>
      </div>
      <div className={`h-1 rounded-full bg-gradient-to-r ${config.gradient} mt-4`}></div>
    </div>
  )
})

StatCard.displayName = 'StatCard'

// Componente para gráfico de barras simple - Memoizado
const SimpleBarChart = memo(({ data, dataKey, labelKey, maxValue, height = 200, color = 'bg-blue-500' }) => {
  if (!data || data.length === 0) {
    return (
      <div className="flex items-center justify-center" style={{ height: `${height}px` }}>
        <div className="text-center">
          <BarChart3 className="w-12 h-12 text-gray-300 mx-auto mb-3" />
          <p className="text-gray-500 font-medium">No hay datos disponibles</p>
        </div>
      </div>
    )
  }
  
  return (
    <div className="space-y-3" style={{ height: `${height}px`, overflowY: 'auto' }}>
      {data.slice(0, 20).map((item, index) => {
        const value = item[dataKey]
        const percentage = maxValue > 0 ? (value / maxValue) * 100 : 0
        return (
          <div key={index} className="flex items-center space-x-3 group">
            <div className="w-32 text-xs font-semibold text-gray-700 truncate" title={item[labelKey]}>
              {item[labelKey]}
            </div>
            <div className="flex-1 bg-gray-200 rounded-full h-8 relative overflow-hidden shadow-inner">
              <div 
                className={`${color} h-full rounded-full transition-all duration-700 flex items-center justify-end pr-3 shadow-md group-hover:shadow-lg`}
                style={{ width: `${Math.max(percentage, 3)}%`, minWidth: '30px' }}
              >
                <span className="text-xs text-white font-bold">{value.toLocaleString()}</span>
              </div>
            </div>
            <div className="w-16 text-xs font-bold text-gray-600 text-right">
              {percentage.toFixed(1)}%
            </div>
          </div>
        )
      })}
    </div>
  )
})

SimpleBarChart.displayName = 'SimpleBarChart'

// Componente para gráfico de pastel simple - Memoizado
const SimplePieChart = memo(({ data, labelKey, valueKey, colors, limit = 10 }) => {
  if (!data || data.length === 0) {
    return <div className="text-gray-500 text-center py-8">No hay datos</div>
  }
  
  const total = data.slice(0, limit).reduce((sum, item) => sum + item[valueKey], 0)
  const items = data.slice(0, limit)
  
  let currentAngle = 0
  const segments = items.map((item, index) => {
    const value = item[valueKey]
    const percentage = (value / total) * 100
    const angle = (value / total) * 360
    const startAngle = currentAngle
    currentAngle += angle
    
    return {
      ...item,
      percentage,
      angle,
      startAngle,
      color: colors[index % colors.length]
    }
  })

  const size = 200
  const radius = size / 2 - 10
  const centerX = size / 2
  const centerY = size / 2

  const createPath = (startAngle, angle) => {
    const start = {
      x: centerX + radius * Math.cos((startAngle - 90) * Math.PI / 180),
      y: centerY + radius * Math.sin((startAngle - 90) * Math.PI / 180)
    }
    const end = {
      x: centerX + radius * Math.cos((startAngle + angle - 90) * Math.PI / 180),
      y: centerY + radius * Math.sin((startAngle + angle - 90) * Math.PI / 180)
    }
    const largeArc = angle > 180 ? 1 : 0
    return `M ${centerX} ${centerY} L ${start.x} ${start.y} A ${radius} ${radius} 0 ${largeArc} 1 ${end.x} ${end.y} Z`
  }

  return (
    <div className="flex items-center space-x-8">
      <svg width={size} height={size} className="transform -rotate-90">
        {segments.map((segment, index) => (
          <path
            key={index}
            d={createPath(segment.startAngle, segment.angle)}
            fill={segment.color}
            stroke="white"
            strokeWidth="2"
            className="hover:opacity-80 transition-opacity"
            title={`${segment[labelKey]}: ${segment.percentage.toFixed(1)}%`}
          />
        ))}
      </svg>
      <div className="flex-1 space-y-2">
        {items.map((item, index) => {
          const segment = segments[index]
          return (
            <div key={index} className="flex items-center space-x-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: segment.color }}></div>
              <span className="text-sm text-gray-700 flex-1">{item[labelKey]}</span>
              <span className="text-sm font-semibold text-gray-900">{item[valueKey]}</span>
              <span className="text-xs text-gray-500">({segment.percentage.toFixed(1)}%)</span>
            </div>
          )
        })}
      </div>
    </div>
  )
})

SimplePieChart.displayName = 'SimplePieChart'

// Componente para gráfico de horas del día - Memoizado
const HourlyChart = memo(({ data, height = 250 }) => {
  if (!data || data.length === 0) {
    return (
      <div className="flex items-center justify-center" style={{ height: `${height}px` }}>
        <div className="text-center">
          <div className="text-gray-400 text-lg mb-2">No hay datos disponibles</div>
          <div className="text-gray-500 text-sm">Selecciona un rango de fechas con programación</div>
        </div>
      </div>
    )
  }
  
  const horasCompletas = Array.from({ length: 24 }, (_, i) => {
    const horaData = data.find(d => d.hora === i)
    return horaData || { hora: i, cantidad_eventos: 0, cantidad_canciones: 0, tiempo_total_segundos: 0 }
  })
  
  const maxValue = Math.max(...horasCompletas.map(d => d.cantidad_eventos || 0), 1)
  
  return (
    <div className="relative bg-gray-50 rounded-lg p-4" style={{ minHeight: `${height}px` }}>
      <div className="relative flex items-end justify-between gap-1" style={{ height: `${height - 60}px` }}>
        {horasCompletas.map((item, index) => {
          const cantidad = item.cantidad_eventos || 0
          const percentage = maxValue > 0 ? (cantidad / maxValue) * 100 : 0
          return (
            <div 
              key={index} 
              className="flex-1 flex flex-col items-center group relative hover:z-10"
              title={`${item.hora}:00 - ${cantidad} eventos, ${item.cantidad_canciones || 0} canciones`}
            >
              <div 
                className="w-full bg-gradient-to-t from-blue-600 to-blue-400 rounded-t transition-all hover:from-blue-700 hover:to-blue-500 cursor-pointer"
                style={{ 
                  height: `${Math.max(percentage, 2)}%`,
                  minHeight: '2px'
                }}
              >
                {cantidad > 0 && (
                  <div className="hidden group-hover:block absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-2 py-1 bg-gray-800 text-white text-xs rounded whitespace-nowrap">
                    {cantidad} eventos
                  </div>
                )}
              </div>
            </div>
          )
        })}
      </div>
      <div className="mt-2 flex items-center justify-between gap-1">
        {horasCompletas.filter((_, i) => i % 4 === 0).map((item, index) => (
          <span key={index} className="text-xs text-gray-600 flex-1 text-center">
            {item.hora}
          </span>
        ))}
      </div>
      <div className="mt-1 text-xs text-gray-500 text-center">
        Horas del día (0-23)
      </div>
    </div>
  )
})

HourlyChart.displayName = 'HourlyChart'

const EstadisticasReportes = () => {
  const [loading, setLoading] = useState(false)
  const [general, setGeneral] = useState(null)
  const [categorias, setCategorias] = useState([])
  const [canciones, setCanciones] = useState([])
  const [artistas, setArtistas] = useState([])
  const [albums, setAlbums] = useState([])
  const [distribucionHoraria, setDistribucionHoraria] = useState([])
  const [distribucionDiaSemana, setDistribucionDiaSemana] = useState([])
  const [difusoras, setDifusoras] = useState([])
  const [politicas, setPoliticas] = useState([])

  const [difusorasDisponibles, setDifusorasDisponibles] = useState([])
  const [categoriasDisponibles, setCategoriasDisponibles] = useState([])
  const [politicasDisponibles, setPoliticasDisponibles] = useState([])

  const [fechaInicio, setFechaInicio] = useState('')
  const [fechaFin, setFechaFin] = useState('')
  const [difusora, setDifusora] = useState('')
  const [politicaId, setPoliticaId] = useState('')
  const [categoriaFiltro, setCategoriaFiltro] = useState('')

  useEffect(() => {
    const hoy = new Date()
    const hace30Dias = new Date(hoy)
    hace30Dias.setDate(hace30Dias.getDate() - 30)
    
    setFechaInicio(hace30Dias.toISOString().split('T')[0])
    setFechaFin(hoy.toISOString().split('T')[0])

    const cargarDifusoras = async () => {
      try {
        const data = await getDifusoras({ activa: true, limit: 1000 })
        setDifusorasDisponibles(data || [])
      } catch (error) {
        try {
          const data = await getDifusoras({ limit: 1000 })
          setDifusorasDisponibles(data || [])
        } catch (err) {
          setDifusorasDisponibles([])
        }
      }
    }

    const cargarCategorias = async () => {
      try {
        const data = await getCategoriasCanciones()
        const categorias = Array.isArray(data) ? data : (data?.items || data?.categorias || [])
        const categoriasActivas = categorias.filter(cat => cat.activa !== false)
        setCategoriasDisponibles(categoriasActivas || [])
      } catch (error) {
        setCategoriasDisponibles([])
      }
    }

    const cargarPoliticas = async () => {
      try {
        const data = await politicasApi.getAll()
        setPoliticasDisponibles(Array.isArray(data) ? data : [])
      } catch (error) {
        setPoliticasDisponibles([])
      }
    }

    cargarDifusoras()
    cargarCategorias()
    cargarPoliticas()
  }, [])

  // Función para cargar estadísticas - Memoizada con useCallback
  const cargarEstadisticas = useCallback(async () => {
    setLoading(true)
    try {
      const params = {}
      if (fechaInicio) params.fecha_inicio = fechaInicio
      if (fechaFin) params.fecha_fin = fechaFin
      if (difusora) params.difusora = difusora
      if (politicaId) params.politica_id = parseInt(politicaId)
      
      const paramsCanciones = { ...params }
      if (categoriaFiltro) paramsCanciones.categoria = categoriaFiltro

      const [
        generalData,
        categoriasData,
        cancionesData,
        artistasData,
        albumsData,
        horariaData,
        diaSemanaData,
        difusorasData,
        politicasData
      ] = await Promise.all([
        reportesApi.getEstadisticasGeneral(params),
        reportesApi.getEstadisticasCategorias(params),
        reportesApi.getEstadisticasCanciones(paramsCanciones),
        reportesApi.getEstadisticasArtistas(params),
        reportesApi.getEstadisticasAlbums(params),
        reportesApi.getDistribucionHoraria(params),
        reportesApi.getDistribucionDiaSemana(params),
        reportesApi.getEstadisticasDifusoras(params),
        reportesApi.getEstadisticasPoliticas(params)
      ])

      setGeneral(generalData)
      setCategorias(categoriasData)
      setCanciones(cancionesData)
      setArtistas(artistasData)
      setAlbums(albumsData)
      setDistribucionHoraria(horariaData)
      setDistribucionDiaSemana(diaSemanaData)
      setDifusoras(difusorasData)
      setPoliticas(politicasData)
    } catch (error) {
      console.error('Error al cargar estadísticas:', error)
      // Mejorar manejo de errores - mostrar notificación en lugar de alert
      const errorMessage = error?.response?.data?.detail || error?.message || 'Error desconocido al cargar las estadísticas'
      console.error('Detalles del error:', errorMessage)
      // Por ahora mantenemos alert, pero se puede mejorar con un sistema de notificaciones
      alert(`Error al cargar las estadísticas: ${errorMessage}. Por favor, intenta de nuevo.`)
    } finally {
      setLoading(false)
    }
  }, [fechaInicio, fechaFin, difusora, politicaId, categoriaFiltro])

  useEffect(() => {
    if (fechaInicio && fechaFin) {
      cargarEstadisticas()
    }
  }, [fechaInicio, fechaFin, difusora, politicaId, categoriaFiltro, cargarEstadisticas])

  // Función para limpiar filtros - Memoizada
  const limpiarFiltros = useCallback(() => {
    const hoy = new Date()
    const hace30Dias = new Date(hoy)
    hace30Dias.setDate(hace30Dias.getDate() - 30)
    
    setFechaInicio(hace30Dias.toISOString().split('T')[0])
    setFechaFin(hoy.toISOString().split('T')[0])
    setDifusora('')
    setPoliticaId('')
    setCategoriaFiltro('')
  }, [])

  // Función para formatear tiempo - Memoizada
  const formatTime = useCallback((seconds) => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = seconds % 60
    if (hours > 0) {
      return `${hours}h ${minutes}m`
    }
    return `${minutes}m ${secs}s`
  }, [])

  // Cálculos memoizados para optimizar renderizado
  const maxCategorias = useMemo(() => 
    Math.max(...categorias.map(c => c.cantidad_reproducciones), 1),
    [categorias]
  )

  const maxArtistas = useMemo(() => 
    Math.max(...artistas.map(a => a.cantidad_reproducciones), 1),
    [artistas]
  )

  const maxDiaSemana = useMemo(() => 
    Math.max(...distribucionDiaSemana.map(d => d.cantidad_eventos), 1),
    [distribucionDiaSemana]
  )

  const totalEventosDiaSemana = useMemo(() => 
    distribucionDiaSemana.reduce((sum, d) => sum + d.cantidad_eventos, 0),
    [distribucionDiaSemana]
  )

  // Top canciones limitado y memoizado
  const topCanciones = useMemo(() => 
    canciones.slice(0, 100),
    [canciones]
  )

  // Top artistas limitado y memoizado
  const topArtistas = useMemo(() => 
    artistas.slice(0, 20),
    [artistas]
  )

  return (
    <div className="h-full bg-gradient-to-br from-slate-50 via-blue-50/30 to-slate-100 overflow-auto">
      <div className="max-w-7xl mx-auto p-6 space-y-6">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 via-blue-700 to-indigo-700 rounded-2xl shadow-2xl border-0 p-8 text-white relative overflow-hidden">
          <div className="absolute inset-0 bg-black/10"></div>
          <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full -mr-32 -mt-32"></div>
          <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full -ml-24 -mb-24"></div>
          
          <div className="relative flex items-center justify-between">
            <div className="flex-1">
              <div className="flex items-center gap-4 mb-3">
                <div className="p-3 bg-white/20 rounded-xl backdrop-blur-sm">
                  <BarChart3 className="w-8 h-8 text-white" />
                </div>
                <div>
                  <h1 className="text-4xl font-bold mb-2">Estadísticas de Programación</h1>
                  <p className="text-blue-100 text-lg">Análisis completo e inteligente de la programación musical</p>
                </div>
              </div>
              
              {general && (
                <div className="mt-6 grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div className="bg-white/10 backdrop-blur-sm rounded-lg p-3 border border-white/20">
                    <div className="text-blue-100 text-xs font-medium mb-1">Rango de Fechas</div>
                    <div className="text-white font-semibold text-sm">
                      {fechaInicio} - {fechaFin}
                    </div>
                  </div>
                  {difusora && (
                    <div className="bg-white/10 backdrop-blur-sm rounded-lg p-3 border border-white/20">
                      <div className="text-blue-100 text-xs font-medium mb-1">Difusora</div>
                      <div className="text-white font-semibold text-sm">{difusora}</div>
                    </div>
                  )}
                  {categoriaFiltro && (
                    <div className="bg-white/10 backdrop-blur-sm rounded-lg p-3 border border-white/20">
                      <div className="text-blue-100 text-xs font-medium mb-1">Categoría</div>
                      <div className="text-white font-semibold text-sm truncate">{categoriaFiltro}</div>
                    </div>
                  )}
                  {politicaId && (
                    <div className="bg-white/10 backdrop-blur-sm rounded-lg p-3 border border-white/20">
                      <div className="text-blue-100 text-xs font-medium mb-1">Política</div>
                      <div className="text-white font-semibold text-sm">ID: {politicaId}</div>
                    </div>
                  )}
                </div>
              )}
            </div>
            
            <button
              onClick={cargarEstadisticas}
              disabled={loading}
              className="ml-6 flex items-center space-x-2 px-6 py-3 bg-white text-blue-700 rounded-xl hover:bg-blue-50 disabled:opacity-50 transition-all shadow-lg hover:shadow-xl hover:scale-105 font-semibold"
            >
              <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : ''}`} />
              <span>Actualizar</span>
            </button>
          </div>
        </div>

        {/* Filtros */}
        <div className="bg-white rounded-2xl shadow-lg border border-gray-200 p-6">
          <div className="flex items-center gap-2 mb-4">
            <Filter className="w-5 h-5 text-blue-600" />
            <h3 className="text-lg font-semibold text-gray-900">Filtros de Búsqueda</h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-6 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                <Calendar className="w-4 h-4 text-gray-500" />
                Fecha Inicio
              </label>
              <input
                type="date"
                value={fechaInicio}
                onChange={(e) => setFechaInicio(e.target.value)}
                className="w-full px-4 py-2.5 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all hover:border-gray-400"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                <Calendar className="w-4 h-4 text-gray-500" />
                Fecha Fin
              </label>
              <input
                type="date"
                value={fechaFin}
                onChange={(e) => setFechaFin(e.target.value)}
                className="w-full px-4 py-2.5 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all hover:border-gray-400"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                <Radio className="w-4 h-4 text-gray-500" />
                Difusora
              </label>
              <select
                value={difusora}
                onChange={(e) => setDifusora(e.target.value)}
                className="w-full px-4 py-2.5 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all hover:border-gray-400 bg-white cursor-pointer"
              >
                <option value="">Todas las difusoras</option>
                {difusorasDisponibles.length === 0 ? (
                  <option disabled>Cargando difusoras...</option>
                ) : (
                  difusorasDisponibles.map((dif) => (
                    <option key={dif.id} value={dif.siglas || dif.nombre}>
                      {dif.nombre} {dif.siglas ? `(${dif.siglas})` : ''}
                    </option>
                  ))
                )}
              </select>
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                <Music className="w-4 h-4 text-gray-500" />
                Categoría
              </label>
              <select
                value={categoriaFiltro}
                onChange={(e) => setCategoriaFiltro(e.target.value)}
                className="w-full px-4 py-2.5 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all hover:border-gray-400 bg-white cursor-pointer"
              >
                <option value="">Todas las categorías</option>
                {categoriasDisponibles.length === 0 ? (
                  <option disabled>Cargando categorías...</option>
                ) : (
                  categoriasDisponibles.map((cat) => (
                    <option key={cat.id} value={cat.nombre}>
                      {cat.nombre}
                    </option>
                  ))
                )}
              </select>
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                <BarChart3 className="w-4 h-4 text-gray-500" />
                Política
              </label>
              <select
                value={politicaId}
                onChange={(e) => setPoliticaId(e.target.value)}
                className="w-full px-4 py-2.5 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all hover:border-gray-400 bg-white cursor-pointer"
              >
                <option value="">Todas las políticas</option>
                {politicasDisponibles.length === 0 ? (
                  <option disabled>Cargando políticas...</option>
                ) : (
                  politicasDisponibles.map((politica) => (
                    <option key={politica.id} value={politica.id}>
                      {politica.nombre} ({politica.clave})
                    </option>
                  ))
                )}
              </select>
            </div>
            <div className="flex items-end">
              <button
                onClick={limpiarFiltros}
                className="w-full px-4 py-3 bg-gradient-to-r from-gray-100 to-gray-200 text-gray-700 rounded-xl hover:from-gray-200 hover:to-gray-300 transition-all font-semibold shadow-sm hover:shadow-md flex items-center justify-center gap-2"
              >
                <X className="w-4 h-4" />
                Limpiar
              </button>
            </div>
          </div>
        </div>

        {/* Loading */}
        {loading && (
          <div className="text-center py-20">
            <div className="inline-flex flex-col items-center">
              <div className="relative">
                <div className="w-16 h-16 border-4 border-blue-200 rounded-full"></div>
                <div className="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin absolute top-0 left-0"></div>
              </div>
              <p className="text-gray-600 mt-6 text-lg font-medium">Cargando estadísticas...</p>
              <p className="text-gray-400 mt-2 text-sm">Por favor espera un momento</p>
            </div>
          </div>
        )}

        {/* Contenido Principal */}
        {!loading && general && (
          <div className="space-y-6">
            {/* Estadísticas Generales */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <StatCard
                title="Total Eventos"
                value={general.total_eventos.toLocaleString()}
                icon={Calendar}
                color="blue"
                subtitle="Eventos programados"
              />
              <StatCard
                title="Total Canciones"
                value={general.total_canciones.toLocaleString()}
                icon={Music}
                color="green"
                subtitle="Canciones reproducidas"
              />
              <StatCard
                title="Tiempo Total"
                value={general.tiempo_total_formato}
                icon={Clock}
                color="purple"
                subtitle="Duración acumulada"
              />
              <StatCard
                title="Cortes Comerciales"
                value={general.total_cortes_comerciales.toLocaleString()}
                icon={Radio}
                color="orange"
                subtitle="Cortes emitidos"
              />
            </div>

            {/* Estadísticas por Categoría - Sección completa */}
            <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
              <div className="bg-gradient-to-r from-blue-600 to-indigo-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                      <PieChart className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold">Estadísticas por Categoría</h2>
                      <p className="text-blue-100 text-sm mt-1">Análisis de reproducciones por categoría musical</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-3xl font-bold">{categorias.length}</div>
                    <div className="text-blue-100 text-sm">Categorías</div>
                  </div>
                </div>
              </div>
              <div className="p-6">
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                  <div className="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl p-6 border border-blue-100">
                    <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                      <PieChart className="w-5 h-5 text-blue-600" />
                      Distribución de Reproducciones
                    </h3>
                    <SimplePieChart
                      data={categorias}
                      labelKey="categoria"
                      valueKey="cantidad_reproducciones"
                      colors={[
                        '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
                        '#ec4899', '#06b6d4', '#84cc16', '#f97316', '#6366f1'
                      ]}
                      limit={10}
                    />
                  </div>
                  <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                    <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                      <TrendingUp className="w-5 h-5 text-green-600" />
                      Top 20 Categorías
                    </h3>
                    <div className="max-h-96 overflow-y-auto pr-2">
                    <SimpleBarChart
                      data={categorias}
                      labelKey="categoria"
                      dataKey="cantidad_reproducciones"
                      maxValue={maxCategorias}
                      height={400}
                      color="bg-gradient-to-r from-green-500 to-emerald-500"
                    />
                    </div>
                  </div>
                </div>
                <div className="bg-gray-50 rounded-xl p-6 border border-gray-200">
                  <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                    <BarChart3 className="w-5 h-5 text-indigo-600" />
                    Detalle Completo por Categoría
                  </h3>
                  <div className="overflow-x-auto overflow-y-auto max-h-96">
                    <table className="w-full">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">#</th>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Categoría</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Reproducciones</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">% Reproducciones</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">% Tiempo</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 bg-white">
                        {categorias.length === 0 ? (
                          <tr>
                            <td colSpan="6" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center">
                                <PieChart className="w-12 h-12 text-gray-300 mb-3" />
                                <p className="text-gray-500 font-medium">No hay estadísticas de categorías</p>
                                <p className="text-gray-400 text-sm mt-1">Selecciona un rango de fechas con programación</p>
                              </div>
                            </td>
                          </tr>
                        ) : (
                          categorias.map((cat, index) => (
                            <tr key={index} className="hover:bg-gradient-to-r hover:from-blue-50 hover:to-indigo-50 transition-all duration-200 group">
                              <td className="px-4 py-4 text-sm font-bold text-gray-500">{index + 1}</td>
                              <td className="px-4 py-4">
                                <span className="px-3 py-1.5 bg-gradient-to-r from-blue-500 to-indigo-500 text-white rounded-full text-xs font-bold shadow-sm">
                                  {cat.categoria}
                                </span>
                              </td>
                              <td className="px-4 py-4 text-sm font-bold text-gray-900 text-right">
                                {cat.cantidad_reproducciones.toLocaleString()}
                              </td>
                              <td className="px-4 py-4 text-sm font-semibold text-gray-700 text-right">{cat.tiempo_total_formato}</td>
                              <td className="px-4 py-4 text-right">
                                <div className="flex items-center justify-end space-x-3">
                                  <span className="text-sm font-semibold text-gray-700 min-w-[50px]">{cat.porcentaje_reproducciones.toFixed(1)}%</span>
                                  <div className="w-32 bg-gray-200 rounded-full h-2.5 shadow-inner">
                                    <div 
                                      className="bg-gradient-to-r from-blue-500 to-blue-600 h-2.5 rounded-full transition-all duration-500 shadow-sm" 
                                      style={{ width: `${cat.porcentaje_reproducciones}%` }}
                                    />
                                  </div>
                                </div>
                              </td>
                              <td className="px-4 py-4 text-right">
                                <div className="flex items-center justify-end space-x-3">
                                  <span className="text-sm font-semibold text-gray-700 min-w-[50px]">{cat.porcentaje_tiempo.toFixed(1)}%</span>
                                  <div className="w-32 bg-gray-200 rounded-full h-2.5 shadow-inner">
                                    <div 
                                      className="bg-gradient-to-r from-green-500 to-emerald-500 h-2.5 rounded-full transition-all duration-500 shadow-sm" 
                                      style={{ width: `${cat.porcentaje_tiempo}%` }}
                                    />
                                  </div>
                                </div>
                              </td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            {/* Canciones de Categoría Filtrada */}
            {categoriaFiltro && canciones.length > 0 && (
              <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
                <div className="bg-gradient-to-r from-blue-600 to-indigo-600 p-6 text-white">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                        <Music className="w-6 h-6" />
                      </div>
                      <div>
                        <h2 className="text-2xl font-bold">Canciones de {categoriaFiltro}</h2>
                        <p className="text-blue-100 text-sm mt-1">Todas las canciones de esta categoría con sus reproducciones</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-3xl font-bold">{canciones.length}</div>
                      <div className="text-blue-100 text-sm">Canciones</div>
                    </div>
                  </div>
                </div>
                <div className="p-6">
                  <div className="overflow-x-auto overflow-y-auto max-h-96">
                    <table className="w-full">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">#</th>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Título</th>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Artista</th>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Álbum</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Reproducciones</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 bg-white">
                        {canciones.map((cancion, index) => (
                          <tr key={index} className="hover:bg-gradient-to-r hover:from-blue-50 hover:to-indigo-50 transition-all duration-200 group">
                            <td className="px-4 py-4 text-sm font-bold text-gray-500">{index + 1}</td>
                            <td className="px-4 py-4">
                              <div className="font-bold text-gray-900">{cancion.titulo || 'Sin título'}</div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <Users className="w-4 h-4 text-gray-400" />
                                <span className="text-gray-700">{cancion.artista || 'Sin artista'}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <Disc className="w-4 h-4 text-gray-400" />
                                <span className="text-gray-600">{cancion.album || 'Sin álbum'}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4 text-right">
                              <div className="flex items-center justify-end gap-3">
                                <span className="text-lg font-bold text-blue-600">{cancion.cantidad_reproducciones.toLocaleString()}</span>
                                <span className="text-sm text-gray-500">veces</span>
                              </div>
                            </td>
                            <td className="px-4 py-4 text-right">
                              <div className="text-sm font-semibold text-gray-700">{cancion.tiempo_total_formato}</div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {/* Top Canciones */}
            <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
              <div className="bg-gradient-to-r from-green-600 to-emerald-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                      <Music className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold flex items-center gap-2">
                        Top Canciones
                        {categoriaFiltro && (
                          <span className="text-sm font-normal text-green-100 bg-white/20 px-3 py-1 rounded-full">
                            {categoriaFiltro}
                          </span>
                        )}
                      </h2>
                      <p className="text-green-100 text-sm mt-1">Canciones más reproducidas en el período</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-3xl font-bold">{canciones.length}</div>
                    <div className="text-green-100 text-sm">Canciones</div>
                  </div>
                </div>
              </div>
              {categoriaFiltro && (
                <div className="mx-6 mt-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-500 rounded-lg">
                  <p className="text-sm text-blue-800 font-medium">
                    <Filter className="w-4 h-4 inline mr-2" />
                    Filtro activo: Mostrando solo canciones de la categoría <strong>&quot;{categoriaFiltro}&quot;</strong>
                  </p>
                </div>
              )}
              <div className="p-6">
                <div className="overflow-x-auto overflow-y-auto max-h-96">
                  <table className="w-full">
                    <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                      <tr>
                        <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">#</th>
                        <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Canción</th>
                        <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Artista</th>
                        <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Álbum</th>
                        <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Categoría</th>
                        <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Reproducciones</th>
                        <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-200 bg-white">
                      {canciones.length === 0 ? (
                        <tr>
                          <td colSpan="7" className="px-4 py-12 text-center">
                            <div className="flex flex-col items-center">
                              <Music className="w-12 h-12 text-gray-300 mb-3" />
                              <p className="text-gray-500 font-medium">
                                {categoriaFiltro 
                                  ? `No hay canciones en la categoría "${categoriaFiltro}"`
                                  : 'No hay canciones para el rango de fechas seleccionado'}
                              </p>
                              <p className="text-gray-400 text-sm mt-1">Intenta ajustar los filtros</p>
                            </div>
                          </td>
                        </tr>
                      ) : (
                        topCanciones.map((cancion, index) => (
                          <tr key={index} className="hover:bg-gradient-to-r hover:from-green-50 hover:to-emerald-50 transition-all duration-200 group">
                            <td className="px-4 py-4">
                              <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm ${
                                index < 3 
                                  ? 'bg-gradient-to-r from-yellow-400 to-orange-400 text-white shadow-lg' 
                                  : 'bg-gray-100 text-gray-600'
                              }`}>
                                {index + 1}
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="font-bold text-gray-900">{cancion.titulo || 'Sin título'}</div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <Users className="w-4 h-4 text-gray-400" />
                                <span className="text-gray-700">{cancion.artista || 'Sin artista'}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <Disc className="w-4 h-4 text-gray-400" />
                                <span className="text-gray-600">{cancion.album || 'Sin álbum'}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <span className="px-3 py-1 bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-full text-xs font-bold shadow-sm">
                                {cancion.categoria || 'Sin categoría'}
                              </span>
                            </td>
                            <td className="px-4 py-4 text-right">
                              <div className="text-lg font-bold text-gray-900">{cancion.cantidad_reproducciones.toLocaleString()}</div>
                              <div className="text-xs text-gray-500">reproducciones</div>
                            </td>
                            <td className="px-4 py-4 text-right">
                              <div className="text-sm font-semibold text-gray-700">{cancion.tiempo_total_formato}</div>
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                  {canciones.length > 100 && (
                    <div className="mt-6 text-center">
                      <div className="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 rounded-full text-sm text-gray-600">
                        <span className="font-semibold">Mostrando las primeras 100</span>
                        <span className="text-gray-400">de</span>
                        <span className="font-bold text-gray-900">{canciones.length} canciones</span>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Top Artistas */}
            <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
              <div className="bg-gradient-to-r from-purple-600 to-pink-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                      <Users className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold">Top Artistas</h2>
                      <p className="text-purple-100 text-sm mt-1">Artistas más reproducidos en el período</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-3xl font-bold">{artistas.length}</div>
                    <div className="text-purple-100 text-sm">Artistas</div>
                  </div>
                </div>
              </div>
              <div className="p-6">
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                  <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl p-6 border border-purple-100">
                    <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                      <TrendingUp className="w-5 h-5 text-purple-600" />
                      Top Artistas
                    </h3>
                    <SimpleBarChart
                      data={artistas}
                      labelKey="artista"
                      dataKey="cantidad_reproducciones"
                      maxValue={maxArtistas}
                      height={400}
                      color="bg-gradient-to-r from-purple-500 to-pink-500"
                    />
                  </div>
                  <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
                    <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                      <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                        <Users className="w-5 h-5 text-purple-600" />
                        Detalle de Artistas
                      </h3>
                    </div>
                    <div className="overflow-x-auto overflow-y-auto max-h-96">
                      <table className="w-full">
                        <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                          <tr>
                            <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Artista</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Reproducciones</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Canciones Únicas</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200">
                          {artistas.length === 0 ? (
                            <tr>
                              <td colSpan="4" className="px-4 py-12 text-center">
                                <div className="flex flex-col items-center">
                                  <Users className="w-12 h-12 text-gray-300 mb-3" />
                                  <p className="text-gray-500 font-medium">No hay datos de artistas</p>
                                </div>
                              </td>
                            </tr>
                          ) : (
                            topArtistas.map((artista, index) => (
                              <tr key={index} className="hover:bg-gradient-to-r hover:from-purple-50 hover:to-pink-50 transition-all duration-200">
                                <td className="px-4 py-3">
                                  <div className="flex items-center gap-2">
                                    <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm ${
                                      index < 3 
                                        ? 'bg-gradient-to-r from-purple-500 to-pink-500 text-white shadow-lg' 
                                        : 'bg-gray-100 text-gray-600'
                                    }`}>
                                      {index + 1}
                                    </div>
                                    <span className="font-bold text-gray-900">{artista.artista}</span>
                                  </div>
                                </td>
                                <td className="px-4 py-3 text-sm font-bold text-gray-900 text-right">
                                  {artista.cantidad_reproducciones.toLocaleString()}
                                </td>
                                <td className="px-4 py-3 text-sm font-semibold text-gray-700 text-right">
                                  {artista.cantidad_canciones_unicas.toLocaleString()}
                                </td>
                                <td className="px-4 py-3 text-sm font-semibold text-gray-700 text-right">
                                  {artista.tiempo_total_formato}
                                </td>
                              </tr>
                            ))
                          )}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Distribución Horaria */}
            <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
              <div className="bg-gradient-to-r from-orange-600 to-red-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                      <Clock className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold">Distribución por Hora del Día</h2>
                      <p className="text-orange-100 text-sm mt-1">Análisis de eventos por hora (0-23)</p>
                    </div>
                  </div>
                </div>
              </div>
              <div className="p-6 bg-gradient-to-br from-orange-50 to-red-50">
                <HourlyChart data={distribucionHoraria} height={350} />
              </div>
            </div>

            {/* Distribución por Día de Semana */}
            <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
              <div className="bg-gradient-to-r from-indigo-600 to-blue-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                      <Calendar className="w-6 h-6" />
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold">Distribución por Día de Semana</h2>
                      <p className="text-indigo-100 text-sm mt-1">Análisis de eventos por día de la semana</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-3xl font-bold">{totalEventosDiaSemana}</div>
                    <div className="text-indigo-100 text-sm">Total Eventos</div>
                  </div>
                </div>
              </div>
              <div className="p-6">
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                  <div className="bg-gradient-to-br from-indigo-50 to-blue-50 rounded-xl p-6 border border-indigo-100">
                    <h3 className="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                      <BarChart3 className="w-5 h-5 text-indigo-600" />
                      Eventos por Día
                    </h3>
                    <SimpleBarChart
                      data={distribucionDiaSemana}
                      labelKey="dia_semana"
                      dataKey="cantidad_eventos"
                      maxValue={maxDiaSemana}
                      height={300}
                      color="bg-gradient-to-r from-indigo-500 to-blue-500"
                    />
                  </div>
                  <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
                    <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                      <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                        <Calendar className="w-5 h-5 text-indigo-600" />
                        Detalle por Día
                      </h3>
                    </div>
                    <div className="overflow-x-auto overflow-y-auto max-h-96">
                      <table className="w-full">
                        <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                          <tr>
                            <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Día</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Eventos</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Canciones</th>
                            <th className="px-4 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200">
                          {distribucionDiaSemana.map((dia, index) => (
                            <tr key={index} className="hover:bg-gradient-to-r hover:from-indigo-50 hover:to-blue-50 transition-all duration-200">
                              <td className="px-4 py-3">
                                <span className="px-3 py-1.5 bg-gradient-to-r from-indigo-500 to-blue-500 text-white rounded-full text-xs font-bold shadow-sm">
                                  {dia.dia_semana}
                                </span>
                              </td>
                              <td className="px-4 py-3 text-sm font-bold text-gray-900 text-right">{dia.cantidad_eventos.toLocaleString()}</td>
                              <td className="px-4 py-3 text-sm font-semibold text-gray-700 text-right">{dia.cantidad_canciones.toLocaleString()}</td>
                              <td className="px-4 py-3 text-sm font-semibold text-gray-700 text-right">{formatTime(dia.tiempo_total_segundos)}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Estadísticas por Difusora */}
            {difusoras.length > 0 && (
              <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
                <div className="bg-gradient-to-r from-red-600 to-rose-600 p-6 text-white">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                        <Radio className="w-6 h-6" />
                      </div>
                      <div>
                        <h2 className="text-2xl font-bold">Estadísticas por Difusora</h2>
                        <p className="text-red-100 text-sm mt-1">Comparativa de difusoras en el período</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-3xl font-bold">{difusoras.length}</div>
                      <div className="text-red-100 text-sm">Difusoras</div>
                    </div>
                  </div>
                </div>
                <div className="p-6">
                  <div className="overflow-x-auto overflow-y-auto max-h-96">
                    <table className="w-full">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Difusora</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Eventos</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Canciones</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 bg-white">
                        {difusoras.map((dif, index) => (
                          <tr key={index} className="hover:bg-gradient-to-r hover:from-red-50 hover:to-rose-50 transition-all duration-200">
                            <td className="px-4 py-4">
                              <span className="px-3 py-1.5 bg-gradient-to-r from-red-500 to-rose-500 text-white rounded-full text-xs font-bold shadow-sm">
                                {dif.difusora}
                              </span>
                            </td>
                            <td className="px-4 py-4 text-sm font-bold text-gray-900 text-right">
                              {dif.cantidad_eventos.toLocaleString()}
                            </td>
                            <td className="px-4 py-4 text-sm font-semibold text-gray-700 text-right">
                              {dif.cantidad_canciones.toLocaleString()}
                            </td>
                            <td className="px-4 py-4 text-sm font-semibold text-gray-700 text-right">
                              {dif.tiempo_total_formato}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {/* Estadísticas por Política */}
            {politicas.length > 0 && (
              <div className="bg-white rounded-2xl shadow-xl border border-gray-200 overflow-hidden">
                <div className="bg-gradient-to-r from-cyan-600 to-teal-600 p-6 text-white">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                        <BarChart3 className="w-6 h-6" />
                      </div>
                      <div>
                        <h2 className="text-2xl font-bold">Estadísticas por Política</h2>
                        <p className="text-cyan-100 text-sm mt-1">Comparativa de políticas en el período</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-3xl font-bold">{politicas.length}</div>
                      <div className="text-cyan-100 text-sm">Políticas</div>
                    </div>
                  </div>
                </div>
                <div className="p-6">
                  <div className="overflow-x-auto overflow-y-auto max-h-96">
                    <table className="w-full">
                      <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                        <tr>
                          <th className="px-4 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Política</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Eventos</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Canciones</th>
                          <th className="px-4 py-4 text-right text-xs font-bold text-gray-700 uppercase tracking-wider border-b-2 border-gray-300">Tiempo Total</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 bg-white">
                        {politicas.length === 0 ? (
                          <tr>
                            <td colSpan="4" className="px-4 py-12 text-center">
                              <div className="flex flex-col items-center">
                                <BarChart3 className="w-12 h-12 text-gray-300 mb-3" />
                                <p className="text-gray-500 font-medium">No hay datos de políticas</p>
                              </div>
                            </td>
                          </tr>
                        ) : (
                          politicas.map((pol, index) => (
                            <tr key={index} className="hover:bg-gradient-to-r hover:from-cyan-50 hover:to-teal-50 transition-all duration-200">
                              <td className="px-4 py-4">
                                <span className="px-3 py-1.5 bg-gradient-to-r from-cyan-500 to-teal-500 text-white rounded-full text-xs font-bold shadow-sm">
                                  {(pol && pol.politica) || (pol && pol.nombre) || 'Política sin nombre'}
                                </span>
                              </td>
                              <td className="px-4 py-4 text-sm font-bold text-gray-900 text-right">
                                {pol.cantidad_eventos ? pol.cantidad_eventos.toLocaleString() : '0'}
                              </td>
                              <td className="px-4 py-4 text-sm font-semibold text-gray-700 text-right">
                                {pol.cantidad_canciones ? pol.cantidad_canciones.toLocaleString() : '0'}
                              </td>
                              <td className="px-4 py-4 text-sm font-semibold text-gray-700 text-right">
                                {pol.tiempo_total_formato || '00:00:00'}
                              </td>
                            </tr>
                          ))
                        )}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

export default EstadisticasReportes
