'use client'

import { useState, useEffect, useRef } from 'react'
import ConsultarProgramacionComponent from './ConsultarProgramacionComponent'
import { DateRangePicker } from 'react-date-range'
import { es } from 'date-fns/locale'
import 'react-date-range/dist/styles.css'
import 'react-date-range/dist/theme/default.css'
import '../../../../styles/dateRangePicker.css'
import { 
  Calendar, 
  RefreshCw, 
  Play, 
  Edit, 
  Search, 
  Trash2, 
  FileText, 
  Layers, 
  ChevronUp, 
  Filter, 
  Download,
  Settings,
  Clock,
  CheckCircle,
  AlertCircle,
  Info,
  X,
  Plus,
  Minus,
  ChevronDown,
  ChevronRight,
  BarChart3,
  Target,
  Zap,
  Shield,
  Music,
  Radio
} from 'lucide-react'

export default function GenerarProgramacionComponent() {
  const [difusora, setDifusora] = useState('')
  const [politica, setPolitica] = useState('')
  const [setReglaSeleccionado, setSetReglaSeleccionado] = useState('')
  // Función para obtener la fecha de hoy en formato YYYY-MM-DD
  const getTodayDate = () => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  }

  const [fechaInicio, setFechaInicio] = useState(getTodayDate())
  const [fechaFin, setFechaFin] = useState(getTodayDate())
  const [showDatePicker, setShowDatePicker] = useState(false)
  const datePickerRef = useRef(null)
  const [dateRange, setDateRange] = useState([
    {
      startDate: new Date(),
      endDate: new Date(),
      key: 'selection'
    }
  ])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [notification, setNotification] = useState(null)
  const [showFilters, setShowFilters] = useState(true)
  const [showStats, setShowStats] = useState(true)
  const [selectedDays, setSelectedDays] = useState(0)
  const [totalDays, setTotalDays] = useState(1)
  const [difusoras, setDifusoras] = useState([])
  const [loadingDifusoras, setLoadingDifusoras] = useState(false)
  const [politicas, setPoliticas] = useState([])
  const [loadingPoliticas, setLoadingPoliticas] = useState(false)
  const [setReglas, setSetReglas] = useState([])
  const [loadingSetReglas, setLoadingSetReglas] = useState(false)
  const [diasModelo, setDiasModelo] = useState([])
  const [programacionData, setProgramacionData] = useState([])
  const [showConsultarModal, setShowConsultarModal] = useState(false)
  const [fechaConsultar, setFechaConsultar] = useState(null)
  const [showOverwriteModal, setShowOverwriteModal] = useState(false)
  const [diasConProgramacion, setDiasConProgramacion] = useState([])
  const [selectedDiaModelo, setSelectedDiaModelo] = useState('')

  // Removido: setsReglas hardcodeado, ahora se carga desde la API

  // Show notification
  const showNotification = (message, type = 'error') => {
    setNotification({ message, type })
  }

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  // Close date picker when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (datePickerRef.current && !datePickerRef.current.contains(event.target)) {
        setShowDatePicker(false)
      }
    }

    if (showDatePicker) {
      document.addEventListener('mousedown', handleClickOutside)
      return () => document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [showDatePicker])

  // Handle date range change
  const handleDateRangeChange = (ranges) => {
    const { startDate, endDate } = ranges.selection
    setDateRange([ranges.selection])
    
    // Convert to YYYY-MM-DD format
    const formatDate = (date) => {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    }
    
    setFechaInicio(formatDate(startDate))
    setFechaFin(formatDate(endDate))
  }

  // Check if date picker should be enabled
  const isDatePickerEnabled = difusora && politica

  // Format date range for display
  const getDateRangeDisplay = () => {
    if (!fechaInicio || !fechaFin) return 'Seleccionar fechas'
    
    const formatDisplayDate = (dateStr) => {
      const [year, month, day] = dateStr.split('-')
      return `${day}/${month}/${year}`
    }
    
    const inicio = formatDisplayDate(fechaInicio)
    const fin = formatDisplayDate(fechaFin)
    
    if (inicio === fin) {
      return inicio
    }
    
    return `${inicio} - ${fin}`
  }

  // Load difusoras from API
  const loadDifusoras = async () => {
    try {
      setLoadingDifusoras(true)
      setError(null)
      
      // Import the API function dynamically to avoid circular dependencies
      const { getDifusoras } = await import('../../../../api/catalogos/generales/difusorasApi')
      const data = await getDifusoras({ activa: true }) // Only load active difusoras
      
      setDifusoras(data)
      
      // Set first difusora as default if none selected
      if (data.length > 0 && !difusora) {
        setDifusora(data[0].siglas)
      }
    } catch (err) {
      console.error('Error loading difusoras:', err)
      setError(`Error al cargar difusoras: ${err.message}`)
      showNotification(`Error al cargar difusoras: ${err.message}`, 'error')
      
      // No usar datos fallback - mantener array vacío en caso de error
      setDifusoras([])
    } finally {
      setLoadingDifusoras(false)
    }
  }

  // Load politicas from API (temporarily disabled due to backend issues)
  const loadPoliticas = async () => {
    try {
      setLoadingPoliticas(true)
      setError(null)
      
      const response = await fetch('http://localhost:8000/api/v1/programacion/politicas/')
      const data = await response.json()
      
      if (response.ok) {
        setPoliticas(data)
        console.log('✅ Políticas cargadas desde API:', data)
      } else {
        throw new Error(data.detail || 'Error al cargar políticas')
      }
    } catch (err) {
      console.error('Error loading politicas:', err)
      setError(`Error al cargar políticas: ${err.message}`)
      showNotification(`Error al cargar políticas: ${err.message}`, 'error')
      
      // No usar datos fallback - mantener array vacío en caso de error
      setPoliticas([])
    } finally {
      setLoadingPoliticas(false)
    }
  }

  // Load set de reglas from API
  const loadSetReglas = async () => {
    try {
      setLoadingSetReglas(true)
      setError(null)
      
      const response = await fetch('http://localhost:8000/api/v1/programacion/set-reglas/?habilitado=true')
      const data = await response.json()
      
      if (response.ok) {
        setSetReglas(data)
        console.log('✅ Set de reglas cargados desde API:', data)
      } else {
        throw new Error(data.detail || 'Error al cargar set de reglas')
      }
      
    } catch (err) {
      console.error('Error loading set de reglas:', err)
      setError(`Error al cargar set de reglas: ${err.message}`)
      showNotification(`Error al cargar set de reglas: ${err.message}`, 'error')
      
      // No usar datos fallback - mantener array vacío en caso de error
      setSetReglas([])
    } finally {
      setLoadingSetReglas(false)
    }
  }

  // Función para cargar días modelo
  const loadDiasModelo = async () => {
    try {
      if (!politica) {
        // Si no hay política seleccionada, usar datos por defecto
        const defaultDiasModelo = [
          { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
          { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
          { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
        ]
        setDiasModelo(defaultDiasModelo)
        return
      }
      
      // Consultar días modelo de la política seleccionada
      const response = await fetch(`http://localhost:8000/api/v1/programacion/politicas/${politica}/dias-modelo`)
      
      if (response.ok) {
        const diasModelo = await response.json()
        if (diasModelo && diasModelo.length > 0) {
          setDiasModelo(diasModelo)
          console.log('✅ Días modelo cargados desde DB para política:', politica, diasModelo)
        } else {
          // Si no hay días modelo en la DB, usar datos por defecto
          const defaultDiasModelo = [
            { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
            { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
            { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
          ]
          setDiasModelo(defaultDiasModelo)
          console.log('✅ Días modelo cargados (fallback - no hay datos en DB):', defaultDiasModelo)
        }
      } else {
        // Fallback a datos por defecto si hay error en la API
        const defaultDiasModelo = [
          { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
          { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
          { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
        ]
        setDiasModelo(defaultDiasModelo)
        console.log('✅ Días modelo cargados (fallback - error API):', defaultDiasModelo)
      }
      
    } catch (err) {
      console.error('Error loading días modelo:', err)
      // Fallback a datos por defecto en caso de error
      const defaultDiasModelo = [
        { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
        { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
        { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
      ]
      setDiasModelo(defaultDiasModelo)
      console.log('✅ Días modelo cargados (fallback - error):', defaultDiasModelo)
    }
  }

  // Función para determinar el día modelo por defecto según el día de la semana
  const getDiaModeloPorDefecto = (diaSemana) => {
    if (!diasModelo || diasModelo.length === 0) {
      return ''
    }

    // Mapeo de días de la semana a días modelo por defecto
    const mapeoDias = {
      'Lunes': 'Día Laboral',
      'Martes': 'Día Laboral', 
      'Miércoles': 'Día Laboral',
      'Jueves': 'Día Laboral',
      'Viernes': 'Día Laboral',
      'Sábado': 'Fin de Semana',
      'Domingo': 'Fin de Semana'
    }

    const diaModeloPorDefecto = mapeoDias[diaSemana]
    
    // Buscar el día modelo que coincida con el nombre por defecto
    const diaModeloEncontrado = diasModelo.find(dia => 
      dia.nombre === diaModeloPorDefecto || 
      dia.clave === 'DIA_LABORAL' && (diaSemana === 'Lunes' || diaSemana === 'Martes' || diaSemana === 'Miércoles' || diaSemana === 'Jueves' || diaSemana === 'Viernes') ||
      dia.clave === 'FIN_SEMANA' && (diaSemana === 'Sábado' || diaSemana === 'Domingo')
    )

    return diaModeloEncontrado ? diaModeloEncontrado.nombre : ''
  }

  // Load difusoras, politicas and set de reglas on component mount
  useEffect(() => {
    loadDifusoras()
    loadPoliticas()
    loadSetReglas()
    loadDiasModelo() // Cargar días modelo al inicio
  }, [])

  // Auto-load days when dates change
  useEffect(() => {
    if (fechaInicio && fechaFin && difusora && politica) {
      handleCargarDias(false) // No mostrar notificaciones en carga automática
    }
  }, [fechaInicio, fechaFin, difusora, politica])

  // Auto-load días modelo when política changes
  useEffect(() => {
    if (politica) {
      loadDiasModelo()
    }
  }, [politica])

  // Actualizar días modelo por defecto cuando cambien los días modelo disponibles
  useEffect(() => {
    if (diasModelo.length > 0 && programacionData.length > 0) {
      const diasActualizados = programacionData.map(dia => {
        // Solo actualizar si no tiene día modelo asignado
        if (!dia.diaModelo) {
          const diaModeloPorDefecto = getDiaModeloPorDefecto(dia.dia)
          if (diaModeloPorDefecto) {
            console.log(`🔄 Actualizando día modelo por defecto para ${dia.dia}: ${diaModeloPorDefecto}`)
            return { ...dia, diaModelo: diaModeloPorDefecto }
          }
        }
        return dia
      })
      
      // Solo actualizar si hay cambios
      const hayCambios = diasActualizados.some((dia, index) => 
        dia.diaModelo !== programacionData[index].diaModelo
      )
      
      if (hayCambios) {
        setProgramacionData(diasActualizados)
      }
    }
  }, [diasModelo])

  // Función para cargar el día de hoy automáticamente
  const cargarHoy = () => {
    const hoy = getTodayDate()
    setFechaInicio(hoy)
    setFechaFin(hoy)
    showNotification('Fechas actualizadas al día de hoy', 'success')
    // Los días se cargarán automáticamente por el useEffect
  }

  // Función para generar programación
  const handleGenerarProgramacion = async () => {
    try {
      setLoading(true)
      
      // Verificar que hay filas seleccionadas
      const filasSeleccionadas = programacionData.filter(row => row.selected)
      if (filasSeleccionadas.length === 0) {
        showNotification('Debe seleccionar al menos un día para generar programación', 'warning')
        return
      }
      
      // Verificar si hay días con programación existente
      const diasConProgramacionExistente = filasSeleccionadas.filter(row => row.status === 'Con Programación')
      
      if (diasConProgramacionExistente.length > 0) {
        // Mostrar modal de confirmación
        setDiasConProgramacion(diasConProgramacionExistente)
        setShowOverwriteModal(true)
        setLoading(false)
        return
      }
      
      // Convertir fechas de YYYY-MM-DD a DD/MM/YYYY para el backend
      const convertirFecha = (fechaYYYYMMDD) => {
        const [year, month, day] = fechaYYYYMMDD.split('-')
        return `${day}/${month}/${year}`
      }
      
      const params = new URLSearchParams({
        difusora: difusora,
        politica_id: politica,
        fecha_inicio: convertirFecha(fechaInicio),
        fecha_fin: convertirFecha(fechaFin)
      })
      
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/programacion/generar-programacion-completa?${params}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      })
      
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`)
      }
      
      const result = await response.json()
      
      showNotification(`Programación generada: ${result.dias_generados} días`, 'success')
      
      // Recargar la lista de días para mostrar los cambios
      console.log('🔄 Recargando días después de generación...')
      await handleCargarDias(false)
      console.log('✅ Días recargados después de generación')
      
      // Obtener estadísticas actualizadas de la programación generada
      await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error al generar programación:', err)
      showNotification(`Error al generar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }

  // Función para confirmar sobreescritura de programación
  const handleConfirmarSobreescritura = async () => {
    try {
      setLoading(true)
      setShowOverwriteModal(false)
      
      // Convertir fechas de YYYY-MM-DD a DD/MM/YYYY para el backend
      const convertirFecha = (fechaYYYYMMDD) => {
        const [year, month, day] = fechaYYYYMMDD.split('-')
        return `${day}/${month}/${year}`
      }
      
      const params = new URLSearchParams({
        difusora: difusora,
        politica_id: politica,
        fecha_inicio: convertirFecha(fechaInicio),
        fecha_fin: convertirFecha(fechaFin)
      })
      
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/programacion/generar-programacion-completa?${params}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      })
      
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`)
      }
      
      const result = await response.json()
      
      showNotification(`Programación regenerada: ${result.dias_generados} días`, 'success')
      
      // Recargar la lista de días para mostrar los cambios
      console.log('🔄 Recargando días después de regeneración...')
      await handleCargarDias(false)
      console.log('✅ Días recargados después de regeneración')
      
      // Obtener estadísticas actualizadas de la programación generada
      await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error al regenerar programación:', err)
      showNotification(`Error al regenerar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }

  // Función para cancelar sobreescritura
  const handleCancelarSobreescritura = () => {
    setShowOverwriteModal(false)
    setDiasConProgramacion([])
    setSelectedDiaModelo('')
    setLoading(false)
  }

  // Función para cargar estadísticas de programación
  const cargarEstadisticasProgramacion = async () => {
    try {
      if (!difusora || !politica) return
      
      // Convertir fechas de YYYY-MM-DD a DD/MM/YYYY para el backend
      const convertirFecha = (fechaYYYYMMDD) => {
        const [year, month, day] = fechaYYYYMMDD.split('-')
        return `${day}/${month}/${year}`
      }
      
      const params = new URLSearchParams({
        difusora: difusora,
        politica_id: politica,
        fecha_inicio: convertirFecha(fechaInicio),
        fecha_fin: convertirFecha(fechaFin)
      })
      
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/programacion/programacion-estadisticas?${params}`)
      
      if (response.ok) {
        const data = await response.json()
        
        // Actualizar los datos de la tabla con las estadísticas reales
        const diasActualizados = programacionData.map(dia => {
          const estadistica = data.dias_estadisticas.find(stat => stat.fecha === dia.fecha)
          if (estadistica) {
            return {
              ...dia,
              status: "Con Programación",
              eventos: estadistica.num_eventos,
              canciones: estadistica.num_canciones,
              asignadas: estadistica.num_asignadas,
              porcentaje: estadistica.porcentaje,
              mc: estadistica.minutos_comerciales
            }
          }
          return dia
        })
        
        setProgramacionData(diasActualizados)
        console.log('✅ Estadísticas de programación actualizadas:', data)
      }
      
    } catch (err) {
      console.error('Error al cargar estadísticas de programación:', err)
    }
  }

  const handleCargarDias = async (showNotification = true) => {
    try {
      setLoading(true)
      setError(null)
      
      if (!difusora) {
        throw new Error('Debe seleccionar una difusora')
      }
      
      console.log('Cargando días...', { difusora, politica, fechaInicio, fechaFin })
      
      // Convertir fechas de YYYY-MM-DD a DD/MM/YYYY para el backend
      const convertirFecha = (fechaYYYYMMDD) => {
        const [year, month, day] = fechaYYYYMMDD.split('-')
        return `${day}/${month}/${year}`
      }
      
      // Llamar a la API para obtener días de programación con las fechas seleccionadas
      const params = new URLSearchParams({
        fecha_inicio: convertirFecha(fechaInicio),
        fecha_fin: convertirFecha(fechaFin),
        difusora: difusora,
        ...(politica && { politica_id: politica })
      })
      
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/programacion/dias-simple?${params}`)
      const data = await response.json()
      
      if (response.ok) {
        // Convertir datos de la API al formato esperado por el componente
        const diasConvertidos = data.dias.map((dia, index) => {
          console.log('🔍 Día modelo recibido del backend:', dia.dia_modelo);
          
          // Si no hay día modelo asignado, aplicar el día modelo por defecto según el día de la semana
          let diaModeloAsignado = dia.dia_modelo || ''
          if (!diaModeloAsignado) {
            diaModeloAsignado = getDiaModeloPorDefecto(dia.dia_semana)
            console.log(`🎯 Aplicando día modelo por defecto para ${dia.dia_semana}: ${diaModeloAsignado}`)
          }
          
          return {
            id: index + 1,
            fecha: dia.fecha,
            dia: dia.dia_semana,
            diaModelo: diaModeloAsignado,
            status: dia.status,
            eventos: dia.num_eventos,
            canciones: dia.num_canciones,
            asignadas: dia.num_asignadas,
            porcentaje: dia.porcentaje,
            mc: dia.minutos_comerciales,
            selected: false,
            priority: dia.tiene_programacion ? 'high' : 'low',
            duration: '24h',
            genre: 'Mixed'
          };
        })
        
        setProgramacionData(diasConvertidos)
        setTotalDays(diasConvertidos.length)
        setSelectedDays(0)
        
        if (showNotification) {
          showNotification(`Días cargados correctamente: ${diasConvertidos.length} días`, 'success')
        }
        console.log('✅ Días cargados desde API:', diasConvertidos)
        console.log('📊 Días con programación:', diasConvertidos.filter(d => d.status === 'Con Programación').length)
      } else {
        throw new Error(data.detail || 'Error al cargar días')
      }
      
    } catch (err) {
      console.error('Error loading days:', err)
      setError(err.message)
      if (showNotification) {
        showNotification(`Error al cargar días: ${err.message}`, 'error')
      }
    } finally {
      setLoading(false)
    }
  }


  const handleEditarProgramacion = () => {
    // Verificar que hay filas seleccionadas
    const filasSeleccionadas = programacionData.filter(row => row.selected)
    if (filasSeleccionadas.length === 0) {
      showNotification('Debe seleccionar al menos un día para editar', 'warning')
      return
    }

    if (filasSeleccionadas.length > 1) {
      showNotification('Solo puede editar un día a la vez', 'warning')
      return
    }

    const filaSeleccionada = filasSeleccionadas[0]
    
    // Verificar que el día tiene programación
    if (filaSeleccionada.status !== 'Con Programación') {
      showNotification('Solo se pueden editar días que ya tienen programación', 'warning')
      return
    }

    console.log('Editando programación para:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para la consulta
    const [dia, mes, año] = filaSeleccionada.fecha.split('/')
    const fechaParaEdicion = `${año}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`
    
    console.log('🔍 Fecha para edición:', fechaParaEdicion)
    setFechaConsultar(fechaParaEdicion)
    setShowConsultarModal(true)
  }

  const handleConsultarProgramacion = () => {
    // Verificar que hay filas seleccionadas
    const filasSeleccionadas = programacionData.filter(row => row.selected)
    if (filasSeleccionadas.length === 0) {
      showNotification('Debe seleccionar al menos un día para consultar', 'warning')
      return
    }
    
    if (filasSeleccionadas.length > 1) {
      showNotification('Solo puede consultar un día a la vez', 'warning')
      return
    }
    
    const filaSeleccionada = filasSeleccionadas[0]
    console.log('🔍 Fila seleccionada:', filaSeleccionada)
    console.log('🔍 Fecha de la fila:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para el componente de consulta
    let fechaParaConsulta
    if (filaSeleccionada.fecha && filaSeleccionada.fecha.includes('/')) {
      const [day, month, year] = filaSeleccionada.fecha.split('/')
      fechaParaConsulta = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
    } else {
      fechaParaConsulta = filaSeleccionada.fecha
    }
    
    console.log('🔍 Fecha para consulta:', fechaParaConsulta)
    setFechaConsultar(fechaParaConsulta)
    setShowConsultarModal(true)
  }

  const handleEliminarProgramacion = async () => {
    // Verificar que hay filas seleccionadas
    const filasSeleccionadas = programacionData.filter(row => row.selected)
    if (filasSeleccionadas.length === 0) {
      showNotification('Debe seleccionar al menos un día para eliminar', 'warning')
      return
    }

    // Confirmar eliminación
    const confirmar = window.confirm(
      `¿Está seguro de que desea eliminar la programación de ${filasSeleccionadas.length} día(s)?\n\nEsta acción no se puede deshacer.`
    )
    
    if (!confirmar) return

    try {
      setLoading(true)
      
      // Eliminar programación para cada día seleccionado
      for (const fila of filasSeleccionadas) {
        const [dia, mes, año] = fila.fecha.split('/')
        const fechaFormateada = `${año}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`
        
        const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/programacion/eliminar-programacion`, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            difusora: difusora,
            politica_id: politica,
            fecha: fechaFormateada
          })
        })

        if (!response.ok) {
          throw new Error(`Error al eliminar programación para ${fila.fecha}`)
        }
      }

      showNotification(`Programación eliminada: ${filasSeleccionadas.length} día(s)`, 'success')
      
      // Recargar días
      await handleCargarDias(false)
      await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error eliminando programación:', err)
      showNotification(`Error al eliminar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }

  const handleImprimirCarta = () => {
    // Verificar que hay filas seleccionadas
    const filasSeleccionadas = programacionData.filter(row => row.selected)
    if (filasSeleccionadas.length === 0) {
      showNotification('Debe seleccionar al menos un día para imprimir', 'warning')
      return
    }

    if (filasSeleccionadas.length > 1) {
      showNotification('Solo puede imprimir un día a la vez', 'warning')
      return
    }

    const filaSeleccionada = filasSeleccionadas[0]
    
    // Verificar que el día tiene programación
    if (filaSeleccionada.status !== 'Con Programación') {
      showNotification('Solo se pueden imprimir días que ya tienen programación', 'warning')
      return
    }

    console.log('Imprimiendo carta de tiempo para:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para la consulta
    const [dia, mes, año] = filaSeleccionada.fecha.split('/')
    const fechaParaImpresion = `${año}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`
    
    // Abrir ventana de impresión
    const url = `${process.env.NEXT_PUBLIC_API_URL}/programacion/carta-tiempo?difusora=${difusora}&politica_id=${politica}&fecha=${fechaParaImpresion}`
    window.open(url, '_blank')
    
    showNotification('Abriendo carta de tiempo para impresión...', 'info')
  }

  const handleGenerarLogFile = async () => {
    // Verificar que hay filas seleccionadas
    const filasSeleccionadas = programacionData.filter(row => row.selected)
    if (filasSeleccionadas.length === 0) {
      showNotification('Debe seleccionar al menos un día para generar LogFile', 'warning')
      return
    }

    try {
      setLoading(true)
      
      // Generar LogFile para cada día seleccionado
      for (const fila of filasSeleccionadas) {
        const [dia, mes, año] = fila.fecha.split('/')
        const fechaFormateada = `${dia}/${mes}/${año}` // Formato DD/MM/YYYY para el endpoint
        
        const url = `${process.env.NEXT_PUBLIC_API_URL}/programacion/generar-logfile?difusora=${difusora}&politica_id=${politica}&fecha=${fechaFormateada}`
        
        // Abrir el log file en una nueva ventana para descarga
        window.open(url, '_blank')
      }

      showNotification(`LogFile generado: ${filasSeleccionadas.length} día(s)`, 'success')
      
    } catch (err) {
      console.error('Error generando LogFile:', err)
      showNotification(`Error al generar LogFile: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }

  const handleRowSelect = (id) => {
    setProgramacionData(prev => 
      prev.map(row => 
        row.id === id ? { ...row, selected: !row.selected } : row
      )
    )
  }

  const handleSelectAll = () => {
    const allSelected = programacionData.every(row => row.selected)
    setProgramacionData(prev => 
      prev.map(row => ({ ...row, selected: !allSelected }))
    )
  }

  // Calculate stats
  const stats = {
    total: programacionData.length,
    selected: programacionData.filter(row => row.selected).length,
    completed: programacionData.filter(row => row.status === 'Con Programación').length,
    pending: programacionData.filter(row => row.status === 'Pendiente').length,
    errors: programacionData.filter(row => row.status === 'Error').length,
    totalEvents: programacionData.reduce((sum, row) => sum + row.eventos, 0),
    totalSongs: programacionData.reduce((sum, row) => sum + row.canciones, 0),
    avgPercentage: programacionData.length > 0 ? 
      (programacionData.reduce((sum, row) => sum + row.porcentaje, 0) / programacionData.length).toFixed(1) : 0
  }

  // Update selected days count
  useEffect(() => {
    setSelectedDays(programacionData.filter(row => row.selected).length)
    setTotalDays(programacionData.length)
  }, [programacionData])

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Con Programación':
        return <CheckCircle className="w-4 h-4 text-green-500" />
      case 'Sin Configuración':
        return <Settings className="w-4 h-4 text-orange-500" />
      case 'Pendiente':
        return <Clock className="w-4 h-4 text-yellow-500" />
      case 'Error':
        return <AlertCircle className="w-4 h-4 text-red-500" />
      default:
        return <Info className="w-4 h-4 text-gray-500" />
    }
  }

  const getPriorityColor = (priority) => {
    switch (priority) {
      case 'high':
        return 'bg-red-100 text-red-800 border-red-200'
      case 'medium':
        return 'bg-yellow-100 text-yellow-800 border-yellow-200'
      case 'low':
        return 'bg-gray-100 text-gray-800 border-gray-200'
      default:
        return 'bg-gray-100 text-gray-800 border-gray-200'
    }
  }

  const getGenreIcon = (genre) => {
    switch (genre) {
      case 'Pop':
        return <Music className="w-4 h-4 text-pink-500" />
      case 'Rock':
        return <Zap className="w-4 h-4 text-orange-500" />
      case 'Clásica':
        return <Shield className="w-4 h-4 text-purple-500" />
      default:
        return <Radio className="w-4 h-4 text-blue-500" />
    }
  }

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center h-64 space-y-4">
        <div className="relative">
          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
        <div className="text-gray-600 font-medium">Cargando programación...</div>
        <div className="text-sm text-gray-500">Esto puede tomar unos segundos</div>
      </div>
    )
  }

  return (
    <div className="p-6 bg-gradient-to-br from-gray-50 via-white to-gray-100 min-h-screen">
      {/* Enhanced Notification Component */}
      {notification && (
        <div className={`fixed top-4 right-4 z-50 p-4 rounded-xl shadow-2xl max-w-md transition-all duration-500 transform ${
          notification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 text-green-800'
            : notification.type === 'info'
            ? 'bg-gradient-to-r from-blue-50 to-cyan-50 border border-blue-200 text-blue-800'
            : 'bg-gradient-to-r from-red-50 to-pink-50 border border-red-200 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <CheckCircle className="w-5 h-5 mr-3 text-green-500" />
              ) : notification.type === 'info' ? (
                <Info className="w-5 h-5 mr-3 text-blue-500" />
              ) : (
                <AlertCircle className="w-5 h-5 mr-3 text-red-500" />
              )}
              <span className="font-medium">{notification.message}</span>
            </div>
            <button
              onClick={() => setNotification(null)}
              className="ml-4 text-gray-500 hover:text-gray-700 transition-colors"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* Enhanced Header with Stats */}
      <div className="bg-white rounded-2xl shadow-lg border border-gray-200 mb-6 overflow-hidden">
        <div className="bg-gradient-to-r from-green-500 via-emerald-500 to-teal-500 px-6 py-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
            <div className="text-white">
              <div className="flex items-center space-x-3 mb-2">
                <div className="p-2 bg-white bg-opacity-20 rounded-lg">
                  <Radio className="w-6 h-6" />
                </div>
                <h1 className="text-3xl font-bold">Generar Programación</h1>
              </div>
              <p className="text-green-100 text-sm">Configura y genera la programación musical para tus difusoras</p>
            </div>
            
            {/* Quick Stats */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-white bg-opacity-20 rounded-lg p-3 text-center">
                <div className="text-2xl font-bold text-white">{stats.total}</div>
                <div className="text-green-100 text-xs">Total Días</div>
              </div>
              <div className="bg-white bg-opacity-20 rounded-lg p-3 text-center">
                <div className="text-2xl font-bold text-white">{stats.selected}</div>
                <div className="text-green-100 text-xs">Seleccionados</div>
              </div>
              <div className="bg-white bg-opacity-20 rounded-lg p-3 text-center">
                <div className="text-2xl font-bold text-white">{stats.completed}</div>
                <div className="text-green-100 text-xs">Completados</div>
              </div>
              <div className="bg-white bg-opacity-20 rounded-lg p-3 text-center">
                <div className="text-2xl font-bold text-white">{stats.avgPercentage}%</div>
                <div className="text-green-100 text-xs">Promedio</div>
              </div>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-wrap gap-3">
            <button
              onClick={cargarHoy}
              className="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Calendar className="w-5 h-5" />
              <span>Hoy</span>
            </button>
            
            
            <button
              onClick={handleGenerarProgramacion}
              disabled={loading || selectedDays === 0}
              className="bg-purple-600 hover:bg-purple-700 text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1 disabled:opacity-50 disabled:transform-none"
            >
              <Play className="w-5 h-5" />
              <span>Generar Programación</span>
            </button>

            <button
              onClick={handleEditarProgramacion}
              className="bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Edit className="w-5 h-5" />
              <span>Editar</span>
            </button>

            <button
              onClick={handleConsultarProgramacion}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Search className="w-5 h-5" />
              <span>Consultar</span>
            </button>

            <button
              onClick={handleEliminarProgramacion}
              className="bg-red-600 hover:bg-red-700 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Trash2 className="w-5 h-5" />
              <span>Eliminar</span>
            </button>

            <button
              onClick={handleImprimirCarta}
              className="bg-gray-600 hover:bg-gray-700 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <FileText className="w-5 h-5" />
              <span>Imprimir</span>
            </button>

            <button
              onClick={handleGenerarLogFile}
              className="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Layers className="w-5 h-5" />
              <span>LogFile</span>
            </button>

            <button
              onClick={() => setShowFilters(!showFilters)}
              className="bg-gray-600 hover:bg-gray-700 text-white px-4 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium hover:shadow-xl transform hover:-translate-y-1"
            >
              <Filter className="w-5 h-5" />
              <span>{showFilters ? 'Ocultar' : 'Mostrar'} Filtros</span>
            </button>
          </div>
        </div>

        {/* Collapsible Filters */}
        {showFilters && (
          <div className="px-6 py-5 bg-gray-50 border-b border-gray-200 transition-all duration-300">
            <div className="flex items-center space-x-2 mb-4">
              <Settings className="w-5 h-5 text-gray-600" />
              <h2 className="text-lg font-semibold text-gray-900">Filtros de Programación</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Difusora</label>
                <div className="relative">
                  <select 
                    value={difusora} 
                    onChange={(e) => setDifusora(e.target.value)}
                    disabled={loadingDifusoras}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 appearance-none bg-white disabled:bg-gray-100 disabled:cursor-not-allowed"
                  >
                    {loadingDifusoras ? (
                      <option value="">Cargando difusoras...</option>
                    ) : difusoras.length === 0 ? (
                      <option value="">No hay difusoras disponibles</option>
                    ) : (
                      <>
                        <option value="">Seleccionar difusora...</option>
                        {difusoras.map(d => (
                          <option key={d.id} value={d.siglas}>
                            {d.siglas} - {d.nombre}
                          </option>
                        ))}
                      </>
                    )}
                  </select>
                  <ChevronDown className="absolute right-3 top-3.5 w-5 h-5 text-gray-400 pointer-events-none" />
                  {loadingDifusoras && (
                    <div className="absolute right-10 top-3.5">
                      <div className="w-4 h-4 border-2 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
                    </div>
                  )}
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Política</label>
                <div className="relative">
                  <select 
                    value={politica} 
                    onChange={(e) => setPolitica(e.target.value)}
                    disabled={loadingPoliticas}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 appearance-none bg-white disabled:bg-gray-100 disabled:cursor-not-allowed"
                  >
                    {loadingPoliticas ? (
                      <option value="">Cargando políticas...</option>
                    ) : politicas.length === 0 ? (
                      <option value="">No hay políticas disponibles</option>
                    ) : (
                      <>
                        <option value="">Seleccionar política...</option>
                        {politicas.map(p => (
                          <option key={p.id} value={p.id}>
                            {p.clave} ({p.difusora})
                          </option>
                        ))}
                      </>
                    )}
                  </select>
                  <ChevronDown className="absolute right-3 top-3.5 w-5 h-5 text-gray-400 pointer-events-none" />
                  {loadingPoliticas && (
                    <div className="absolute right-10 top-3.5">
                      <div className="w-4 h-4 border-2 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
                    </div>
                  )}
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Set Reglas</label>
                <div className="relative">
                  <select 
                    value={setReglaSeleccionado} 
                    onChange={(e) => setSetReglaSeleccionado(e.target.value)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 appearance-none bg-white"
                  >
                    <option value="">Seleccionar...</option>
                    {loadingSetReglas ? (
                      <option value="">Cargando set de reglas...</option>
                    ) : setReglas.length === 0 ? (
                      <option value="">No hay set de reglas disponibles</option>
                    ) : (
                      setReglas.map(s => (
                        <option key={s.id} value={s.id}>{s.nombre}</option>
                      ))
                    )}
                  </select>
                  <ChevronDown className="absolute right-3 top-3.5 w-5 h-5 text-gray-400 pointer-events-none" />
                </div>
              </div>
              
              <div className="col-span-2">
                <label className="block text-sm font-medium mb-2">
                  <span className={!isDatePickerEnabled ? 'text-gray-400' : 'text-gray-700'}>
                    Rango de Fechas
                  </span>
                  {!isDatePickerEnabled && (
                    <span className="ml-2 text-xs text-amber-600 font-normal">
                      (Requiere difusora y política)
                    </span>
                  )}
                </label>
                <div className="relative" ref={datePickerRef}>
                  <button
                    type="button"
                    onClick={() => {
                      // Validar que difusora y política estén seleccionadas
                      if (!isDatePickerEnabled) {
                        showNotification('Debe seleccionar primero la difusora y la política', 'error')
                        return
                      }
                      console.log('Date picker toggled:', !showDatePicker)
                      setShowDatePicker(!showDatePicker)
                    }}
                    disabled={!isDatePickerEnabled}
                    className={`w-full px-4 py-3 pr-10 border rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-300 text-left ${
                      !isDatePickerEnabled
                        ? 'border-gray-200 bg-gray-50 text-gray-400 cursor-not-allowed'
                        : 'border-gray-300 bg-white hover:bg-gray-50 text-gray-900 hover:border-green-300 hover:shadow-sm'
                    }`}
                  >
                    <span className={!isDatePickerEnabled ? 'text-gray-400' : 'text-gray-900'}>
                      {!isDatePickerEnabled ? 'Seleccione difusora y política primero' : getDateRangeDisplay()}
                    </span>
                  </button>
                  <Calendar className={`absolute right-3 top-3.5 w-5 h-5 pointer-events-none transition-colors ${
                    !isDatePickerEnabled ? 'text-gray-400' : 'text-gray-600'
                  }`} />
                  
                  {/* Backdrop */}
                  {showDatePicker && (
                    <div 
                      className="fixed inset-0 bg-black bg-opacity-40 z-[9998] animate-in fade-in duration-300"
                      onClick={() => setShowDatePicker(false)}
                    />
                  )}
                  
                  {/* Modal estilo Airbnb */}
                  {showDatePicker && (
                    <div 
                      className="fixed left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2 z-[9999] bg-white rounded-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-300 shadow-2xl"
                      style={{ 
                        width: '650px',
                        maxHeight: '90vh',
                        overflowY: 'auto'
                      }}
                      onClick={(e) => e.stopPropagation()}
                    >
                      {/* Header */}
                      <div className="sticky top-0 z-10 bg-white border-b border-gray-200 px-6 py-4">
                        <div className="flex items-center justify-between">
                          <h3 className="text-lg font-semibold text-gray-900">Seleccionar fechas</h3>
                          <button
                            type="button"
                            onClick={() => setShowDatePicker(false)}
                            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                          >
                            <X className="w-5 h-5 text-gray-500" />
                          </button>
                        </div>
                      </div>

                      {/* Tabs */}
                      <div className="px-6 pt-4">
                        <div className="flex gap-4 border-b border-gray-200">
                          <button className="pb-3 px-4 border-b-2 border-gray-900 font-semibold text-gray-900 text-sm">
                            Fechas
                          </button>
                          <button className="pb-3 px-4 text-gray-500 hover:text-gray-900 text-sm">
                            Flexible
                          </button>
                        </div>
                      </div>

                      {/* Calendar */}
                      <div className="flex justify-center py-6">
                        <DateRangePicker
                          ranges={dateRange}
                          onChange={handleDateRangeChange}
                          locale={es}
                          dateDisplayFormat="dd/MM/yyyy"
                          showSelectionPreview={true}
                          moveRangeOnFirstSelection={false}
                          months={2}
                          direction="horizontal"
                          rangeColors={['#10b981']}
                          showDateDisplay={false}
                        />
                      </div>

                      {/* Footer */}
                      <div className="sticky bottom-0 bg-white border-t border-gray-200 px-6 py-4 flex items-center justify-between">
                        <button
                          type="button"
                          onClick={() => {
                            setDateRange([{
                              startDate: new Date(),
                              endDate: new Date(),
                              key: 'selection'
                            }])
                            setFechaInicio(getTodayDate())
                            setFechaFin(getTodayDate())
                          }}
                          className="text-sm font-semibold text-gray-900 underline hover:bg-gray-50 px-4 py-2 rounded-lg transition-colors"
                        >
                          Borrar fechas
                        </button>
                        <button
                          type="button"
                          onClick={() => {
                            console.log('Date picker closed')
                            setShowDatePicker(false)
                          }}
                          className="px-6 py-3 bg-gradient-to-r from-green-600 to-emerald-600 text-white rounded-lg hover:from-green-700 hover:to-emerald-700 transition-all font-semibold shadow-lg shadow-green-500/20"
                        >
                          Aplicar
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Enhanced Filter Status */}
        {error && (
          <div className="px-6 py-4 bg-red-50 border-b border-red-200">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <AlertCircle className="w-5 h-5 text-red-600" />
                <p className="text-red-800 text-sm font-medium">
                  Error: {error}
                </p>
              </div>
              <div className="flex items-center space-x-2">
                <button
                  onClick={() => {
                    loadDifusoras()
                    loadPoliticas()
                    loadSetReglas()
                  }}
                  disabled={loadingDifusoras || loadingPoliticas || loadingSetReglas}
                  className="text-blue-600 hover:text-blue-800 text-sm font-medium hover:underline transition-colors disabled:opacity-50"
                >
                  Recargar datos
                </button>
                <button
                  onClick={() => setError(null)}
                  className="text-red-600 hover:text-red-800 text-sm font-medium hover:underline transition-colors"
                >
                  Limpiar error
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Enhanced Table */}
      <div className="bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden">
        <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold text-gray-900">Días de Programación</h3>
            <div className="flex items-center space-x-4 text-sm text-gray-600">
              <span className="flex items-center space-x-1">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>{stats.completed} Completados</span>
              </span>
              <span className="flex items-center space-x-1">
                <Clock className="w-4 h-4 text-yellow-500" />
                <span>{stats.pending} Pendientes</span>
              </span>
              <span className="flex items-center space-x-1">
                <AlertCircle className="w-4 h-4 text-red-500" />
                <span>{stats.errors} Errores</span>
              </span>
            </div>
          </div>
        </div>

        {/* Loading indicator for auto-loading */}
        {loading && (
          <div className="bg-blue-50 border-l-4 border-blue-400 p-3 mb-4">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="w-4 h-4 border-2 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
              </div>
              <div className="ml-3">
                <p className="text-sm text-blue-700">
                  Actualizando días del período seleccionado...
                </p>
              </div>
            </div>
          </div>
        )}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  <input 
                    type="checkbox" 
                    className="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
                    checked={programacionData.every(row => row.selected)}
                    onChange={handleSelectAll}
                  />
                </th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Fecha</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Día</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Día Modelo</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"># Eventos</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"># Canciones</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Asignadas</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">%</th>
                <th className="px-4 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">MC</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {programacionData.map((row, index) => (
                <tr 
                  key={row.id} 
                  className={`hover:bg-green-50 transition-all duration-200 cursor-pointer ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50'} ${row.selected ? 'bg-blue-50 border-l-4 border-blue-500' : ''}`}
                  onClick={(e) => {
                    // Prevenir la selección si se hace clic en el checkbox o en un select
                    if (e.target.type === 'checkbox' || e.target.tagName === 'SELECT') {
                      return
                    }
                    handleRowSelect(row.id)
                  }}
                >
                  <td className="px-4 py-4 whitespace-nowrap">
                    <input 
                      type="checkbox" 
                      className="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
                      checked={row.selected}
                      onChange={(e) => {
                        e.stopPropagation() // Prevenir que el clic se propague a la fila
                        handleRowSelect(row.id)
                      }}
                    />
                  </td>
                  <td className="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{row.fecha}</td>
                  <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">{row.dia}</td>
                  <td className="px-4 py-4 whitespace-nowrap">
                    {row.diaModelo && row.status === 'Con Programación' ? (
                      <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800 border border-blue-200">
                        {row.diaModelo}
                      </span>
                    ) : (
                      <select
                        value={row.diaModelo || ''}
                        onChange={(e) => {
                          e.stopPropagation() // Prevenir que el clic se propague a la fila
                          const newData = programacionData.map(item => 
                            item.id === row.id 
                              ? { ...item, diaModelo: e.target.value }
                              : item
                          )
                          setProgramacionData(newData)
                        }}
                        onClick={(e) => e.stopPropagation()} // Prevenir propagación en el clic también
                        className="w-full px-2 py-1 text-xs border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white"
                        disabled={false}
                      >
                        <option value="">Seleccionar...</option>
                        {diasModelo && diasModelo.length > 0 ? (
                          diasModelo.map((dia) => (
                            <option key={dia.id} value={dia.nombre}>
                              {dia.nombre}
                            </option>
                          ))
                        ) : (
                          <>
                            <option value="DIA_LABORAL">Día Laboral</option>
                            <option value="FIN_SEMANA">Fin de Semana</option>
                            <option value="DIA_GENERAL">Día General</option>
                          </>
                        )}
                      </select>
                    )}
                  </td>
                  <td className="px-4 py-4 whitespace-nowrap">
                    <div className="flex items-center space-x-2">
                      {getStatusIcon(row.status)}
                      <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full border ${
                        row.status === 'Con Programación' ? 'bg-green-100 text-green-800 border-green-200' :
                        row.status === 'Sin Configuración' ? 'bg-orange-100 text-orange-800 border-orange-200' :
                        row.status === 'Pendiente' ? 'bg-yellow-100 text-yellow-800 border-yellow-200' :
                        'bg-red-100 text-red-800 border-red-200'
                      }`}>
                        {row.status}
                      </span>
                    </div>
                  </td>
                  <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">{row.eventos.toLocaleString()}</td>
                  <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">{row.canciones.toLocaleString()}</td>
                  <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">{row.asignadas.toLocaleString()}</td>
                  <td className="px-4 py-4 whitespace-nowrap">
                    <div className="flex items-center space-x-2">
                      <div className="w-16 bg-gray-200 rounded-full h-2">
                        <div 
                          className={`h-2 rounded-full transition-all duration-300 ${
                            row.porcentaje >= 90 ? 'bg-green-500' :
                            row.porcentaje >= 70 ? 'bg-yellow-500' :
                            'bg-red-500'
                          }`}
                          style={{ width: `${Math.min(row.porcentaje, 100)}%` }}
                        ></div>
                      </div>
                      <span className="text-xs font-medium text-gray-600">{row.porcentaje}%</span>
                    </div>
                  </td>
                  <td className="px-4 py-4 whitespace-nowrap">
                    <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-orange-100 text-orange-800 border border-orange-200">
                      {row.mc}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        
        {/* Enhanced Empty State - Only show when no data and not loading */}
        {programacionData.length === 0 && !loading && (
          <div className="text-center py-16 px-6">
            <div className="mx-auto h-20 w-20 text-gray-400 mb-6">
              <Radio className="w-full h-full" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              No hay días de programación
            </h3>
            <p className="text-gray-500 mb-4 max-w-md mx-auto">
              {!difusora ? 
                'Selecciona una difusora para comenzar.' : 
                !politica ? 
                'Selecciona una política para cargar los días.' :
                'Configura el rango de fechas y los días se cargarán automáticamente.'
              }
            </p>
            {difusora && politica && fechaInicio && fechaFin && (
              <div className="mt-6 flex flex-col items-center space-y-3">
                <p className="text-sm text-gray-600">
                  Los días se cargan automáticamente cuando seleccionas difusora y política.
                </p>
                <button
                  onClick={() => handleCargarDias(true)}
                  className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-medium"
                >
                  <Calendar className="w-5 h-5" />
                  <span>Cargar Días del Período</span>
                </button>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Selection Counter */}
      <div className="mt-6 bg-white rounded-2xl shadow-lg border border-gray-200 p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
              <span className="text-sm font-medium text-gray-700">Días Seleccionados</span>
            </div>
            <div className="text-2xl font-bold text-blue-600">{selectedDays}</div>
            <span className="text-gray-500">de</span>
            <div className="text-2xl font-bold text-gray-600">{totalDays}</div>
            <span className="text-gray-500">días totales</span>
          </div>
          
          <div className="flex items-center space-x-4 text-sm text-gray-600">
            <span className="flex items-center space-x-1">
              <CheckCircle className="w-4 h-4 text-green-500" />
              <span>{stats.completed} Completados</span>
            </span>
            <span className="flex items-center space-x-1">
              <Clock className="w-4 h-4 text-yellow-500" />
              <span>{stats.pending} Pendientes</span>
            </span>
            <span className="flex items-center space-x-1">
              <AlertCircle className="w-4 h-4 text-red-500" />
              <span>{stats.errors} Errores</span>
            </span>
          </div>
        </div>
      </div>

      {/* Modal de Consultar Programación */}
      <ConsultarProgramacionComponent
        isOpen={showConsultarModal}
        onClose={() => setShowConsultarModal(false)}
        difusora={difusora}
        politica={politica}
        fecha={fechaConsultar}
      />

      {/* Modal de Confirmación de Sobreescritura */}
      {showOverwriteModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-[9999] flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            {/* Header */}
            <div className="px-6 py-4 border-b border-gray-200">
              <div className="flex items-center space-x-3">
                <div className="p-2 bg-amber-100 rounded-full">
                  <AlertCircle className="w-6 h-6 text-amber-600" />
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-gray-900">Programación Existente Detectada</h3>
                  <p className="text-sm text-gray-600">Algunos días ya tienen programación generada</p>
                </div>
              </div>
            </div>

            {/* Content */}
            <div className="px-6 py-4">
              <div className="mb-4">
                <p className="text-gray-700 mb-3">
                  Los siguientes días ya tienen programación generada:
                </p>
                <div className="bg-gray-50 rounded-lg p-4 space-y-2">
                  {diasConProgramacion.map((dia, index) => (
                    <div key={index} className="flex items-center justify-between py-2 px-3 bg-white rounded-lg border">
                      <div className="flex items-center space-x-3">
                        <Calendar className="w-4 h-4 text-gray-500" />
                        <span className="font-medium text-gray-900">{dia.fecha}</span>
                        <span className="text-sm text-gray-600">({dia.dia})</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className="text-sm text-gray-500">{dia.eventos} eventos</span>
                        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                          {dia.status}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  ¿Desea sobreescribir la programación existente?
                </label>
                <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
                  <div className="flex items-start space-x-3">
                    <AlertCircle className="w-5 h-5 text-amber-600 mt-0.5" />
                    <div>
                      <p className="text-sm text-amber-800 font-medium">Advertencia</p>
                      <p className="text-sm text-amber-700 mt-1">
                        Al confirmar, se eliminará toda la programación existente para estos días y se generará una nueva programación.
                        Esta acción no se puede deshacer.
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Opción de modificar día modelo */}
              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Día Modelo (Opcional)
                </label>
                <select
                  value={selectedDiaModelo}
                  onChange={(e) => setSelectedDiaModelo(e.target.value)}
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                >
                  <option value="">Mantener día modelo actual</option>
                  {diasModelo.map((dia) => (
                    <option key={dia.id} value={dia.id}>
                      {dia.nombre} - {dia.descripcion}
                    </option>
                  ))}
                </select>
                <p className="text-xs text-gray-500 mt-1">
                  Si selecciona un día modelo diferente, se aplicará a todos los días seleccionados
                </p>
              </div>
            </div>

            {/* Footer */}
            <div className="px-6 py-4 bg-gray-50 border-t border-gray-200 flex justify-end space-x-3">
              <button
                onClick={handleCancelarSobreescritura}
                className="px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors font-medium"
              >
                Cancelar
              </button>
              <button
                onClick={handleConfirmarSobreescritura}
                disabled={loading}
                className="px-6 py-2 bg-gradient-to-r from-amber-600 to-orange-600 text-white rounded-lg hover:from-amber-700 hover:to-orange-700 transition-all font-medium shadow-lg shadow-amber-500/20 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? 'Regenerando...' : 'Sí, Sobreescribir'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
