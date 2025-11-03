'use client'

import { useState, useEffect, useRef, useCallback, useMemo, lazy, Suspense, memo } from 'react'
import { buildApiUrl } from '../../../../utils/apiConfig'
import { es } from 'date-fns/locale'
// Lazy load de componentes pesados para optimizar bundle size
const ConsultarProgramacionComponent = lazy(() => import('./ConsultarProgramacionComponent'))
// DateRangePicker se carga normalmente ya que es necesario para el render inicial del modal
import { DateRangePicker } from 'react-date-range'
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

// Helper para logging condicional - solo en desarrollo
const debugLog = (...args) => {
  if (process.env.NODE_ENV === 'development') {
    console.log(...args)
  }
}

export default function GenerarProgramacionComponent() {
  const [difusora, setDifusora] = useState('')
  const [politica, setPolitica] = useState('')
  // Función para obtener la fecha de hoy en formato YYYY-MM-DD - Memoizada
  const getTodayDate = useCallback(() => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  }, [])

  const [fechaInicio, setFechaInicio] = useState(() => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  })
  const [fechaFin, setFechaFin] = useState(() => {
    const today = new Date()
    return today.toISOString().split('T')[0]
  })
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
  const [diasModelo, setDiasModelo] = useState([])
  const [programacionData, setProgramacionData] = useState([])
  const [dataVersion, setDataVersion] = useState(0) // Para forzar re-render cuando cambie el día modelo
  const [showConsultarModal, setShowConsultarModal] = useState(false)
  const [fechaConsultar, setFechaConsultar] = useState(null)
  const [showOverwriteModal, setShowOverwriteModal] = useState(false)
  const [diasConProgramacion, setDiasConProgramacion] = useState([])
  const [selectedDiaModelo, setSelectedDiaModelo] = useState('')
  // Paginación para optimizar renderizado de tablas grandes
  const [currentPage, setCurrentPage] = useState(1)
  const itemsPerPage = 15 // Renderizar máximo 15 elementos a la vez (reducido agresivamente para memoria)

  // Removido: setsReglas hardcodeado, ahora se carga desde la API

  // Show notification - Memoizada
  const showNotification = useCallback((message, type = 'error') => {
    setNotification({ message, type })
  }, [])

  // Auto-hide notification
  useEffect(() => {
    if (!notification) return
    
    const timer = setTimeout(() => {
      setNotification(null)
    }, 5000)
    return () => clearTimeout(timer)
  }, [notification])

  // Close date picker when clicking outside
  useEffect(() => {
    if (!showDatePicker) return
    
    const handleClickOutside = (event) => {
      if (datePickerRef.current && !datePickerRef.current.contains(event.target)) {
        setShowDatePicker(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [showDatePicker])

  // Handle date range change - Memoizada
  const handleDateRangeChange = useCallback((ranges) => {
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
  }, [])

  // Check if date picker should be enabled - Memoizado
  const isDatePickerEnabled = useMemo(() => difusora && politica, [difusora, politica])

  // Filter políticas based on selected difusora - Memoizado
  const filteredPoliticas = useMemo(() => {
    if (!difusora) {
      return politicas // Show all if no difusora selected
    }
    
    return politicas.filter(p => 
      p.difusora === difusora || p.difusora === 'TODAS'
    )
  }, [difusora, politicas])

  // Función helper para obtener políticas filtradas (para compatibilidad)
  const getFilteredPoliticas = useCallback(() => {
    return filteredPoliticas
  }, [filteredPoliticas])

  // Format date range for display - Memoizado (debe definirse antes de getDateRangeDisplay)
  const dateRangeDisplay = useMemo(() => {
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
  }, [fechaInicio, fechaFin])

  // Función helper para obtener el display del rango de fechas (para compatibilidad)
  const getDateRangeDisplay = useCallback(() => {
    return dateRangeDisplay
  }, [dateRangeDisplay])

  // Load difusoras from API - Memoizada
  const loadDifusoras = useCallback(async () => {
    try {
      setLoadingDifusoras(true)
      setError(null)
      
      // Import the API function dynamically to avoid circular dependencies
      const { getDifusoras } = await import('../../../../api/catalogos/generales/difusorasApi')
      const data = await getDifusoras({ activa: true }) // Only load active difusoras
      
      setDifusoras(data)
      
      // Set first difusora as default if none selected - usar callback para evitar dependencia
      if (data.length > 0) {
        setDifusora(prev => {
          // Solo actualizar si no hay una seleccionada
          if (!prev) {
            return data[0].siglas
          }
          return prev
        })
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
  }, [showNotification]) // Removida dependencia de difusora para evitar ciclo infinito

  // Load politicas from API - Memoizada y optimizada para AWS
  const loadPoliticas = useCallback(async () => {
    try {
      setLoadingPoliticas(true)
      setError(null)
      
      const url = buildApiUrl('/programacion/politicas/')
      const response = await fetch(url, {
        cache: 'no-store',
        headers: {
          'Cache-Control': 'no-cache'
        }
      })
      const data = await response.json()
      
      if (response.ok) {
        setPoliticas(data)
        debugLog('✅ Políticas cargadas desde API:', data)
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
  }, [showNotification])


  // Función para cargar días modelo - Memoizada
  const loadDiasModelo = useCallback(async () => {
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
      const url = buildApiUrl(`/programacion/politicas/${politica}/dias-modelo`)
      const response = await fetch(url, {
        cache: 'no-store',
        headers: {
          'Cache-Control': 'no-cache'
        }
      })
      
      if (response.ok) {
        const diasModelo = await response.json()
        if (diasModelo && diasModelo.length > 0) {
          setDiasModelo(diasModelo)
          // Seleccionar por defecto el primero si no hay uno global elegido aún
          // Usar callback para evitar dependencia circular
          setSelectedDiaModelo(prev => {
            if (!prev || prev === '') {
              return String(diasModelo[0].id)
            }
            return prev
          })
          debugLog('✅ Días modelo cargados desde DB para política:', politica, diasModelo)
        } else {
          // Si no hay días modelo en la DB, usar datos por defecto
          const defaultDiasModelo = [
            { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
            { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
            { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
          ]
          setDiasModelo(defaultDiasModelo)
          debugLog('✅ Días modelo cargados (fallback - no hay datos en DB):', defaultDiasModelo)
        }
      } else {
        // Fallback a datos por defecto si hay error en la API
        const defaultDiasModelo = [
          { id: 1, clave: 'DIA_LABORAL', nombre: 'Día Laboral', descripcion: 'Día modelo para días laborales' },
          { id: 2, clave: 'FIN_SEMANA', nombre: 'Fin de Semana', descripcion: 'Día modelo para fines de semana' },
          { id: 3, clave: 'DIA_GENERAL', nombre: 'Día General', descripcion: 'Día modelo general' }
        ]
        setDiasModelo(defaultDiasModelo)
        debugLog('✅ Días modelo cargados (fallback - error API):', defaultDiasModelo)
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
      debugLog('✅ Días modelo cargados (fallback - error):', defaultDiasModelo)
    }
  }, [politica]) // Removida dependencia de selectedDiaModelo para evitar ciclo infinito

  // Función para determinar el día modelo por defecto según el día de la semana - Memoizada
  const getDiaModeloPorDefecto = useCallback((diaSemana) => {
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
  }, [diasModelo])

  // handleCargarDias debe definirse antes de los useEffect que lo usan
  const handleCargarDias = useCallback(async (showNotificationParam = true) => {
    try {
      setLoading(true)
      setError(null)
      
      if (!difusora) {
        throw new Error('Debe seleccionar una difusora')
      }
      
      debugLog('Cargando días...', { difusora, politica, fechaInicio, fechaFin })
      
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
        ...(politica && { politica_id: politica }),
        _t: Date.now() // Timestamp para evitar caché
      })
      
      const url = buildApiUrl(`/programacion/dias-simple?${params}`)
      const response = await fetch(url, {
        cache: 'no-store',
        headers: {
          'Cache-Control': 'no-cache'
        }
      })
      const data = await response.json()
      
      debugLog('🔍 Respuesta completa del backend:', data)
      
      if (response.ok) {
        // Convertir datos de la API al formato esperado por el componente
        const diasConvertidos = data.dias.map((dia, index) => {
          debugLog('🔍 Día modelo recibido del backend:', dia.dia_modelo);
          debugLog('🔍 Status del día:', dia.status);
          
          // Usar el día modelo que viene del backend si ya existe programación
          // Si no hay programación, usar el día modelo por defecto de la política
          let diaModeloAsignado = ''
          if (dia.status === 'Con Programación' && dia.dia_modelo) {
            diaModeloAsignado = dia.dia_modelo
            debugLog('✅ Asignando día modelo del backend (con programación):', diaModeloAsignado);
          } else if (dia.status !== 'Con Programación' && dia.dia_modelo) {
            // Usar el día modelo por defecto de la política
            diaModeloAsignado = dia.dia_modelo
            debugLog('✅ Asignando día modelo por defecto de la política:', diaModeloAsignado);
          } else {
            debugLog('⚠️ No hay día modelo disponible - Status:', dia.status, 'Día modelo:', dia.dia_modelo);
          }
          // Si no hay programación, NO asignar automáticamente
          // El usuario debe seleccionar explícitamente el día modelo
          
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
        
        // Limpiar datos antiguos antes de cargar nuevos para liberar memoria
        setProgramacionData([])
        // Usar setTimeout para permitir que el garbage collector limpie
        setTimeout(() => {
          setProgramacionData(diasConvertidos)
          setDataVersion(prev => prev + 1)
          setTotalDays(diasConvertidos.length)
          setSelectedDays(0)
          setCurrentPage(1)
        }, 0)
        
        if (showNotificationParam) {
          showNotification(`Días cargados correctamente: ${diasConvertidos.length} días`, 'success')
        }
        debugLog('✅ Días cargados desde API:', diasConvertidos)
        debugLog('📊 Días con programación:', diasConvertidos.filter(d => d.status === 'Con Programación').length)
        debugLog('🔍 Día modelo en el estado:', diasConvertidos[0]?.diaModelo);
        debugLog('🔍 Estado completo del primer día:', diasConvertidos[0]);
      } else {
        throw new Error(data.detail || 'Error al cargar días')
      }
      
    } catch (err) {
      console.error('Error loading days:', err)
      setError(err.message)
      if (showNotificationParam) {
        showNotification(`Error al cargar días: ${err.message}`, 'error')
      }
    } finally {
      setLoading(false)
    }
  }, [difusora, politica, fechaInicio, fechaFin, showNotification])

  // Load difusoras, politicas and set de reglas on component mount - Optimizado
  useEffect(() => {
    // Solo cargar al montar el componente, no cuando cambian las funciones
    loadDifusoras()
    loadPoliticas()
    // No cargar días modelo aquí porque política puede estar vacío
    // Se cargará automáticamente cuando se seleccione una política
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []) // Dependencias vacías - solo ejecutar al montar

  // Auto-load days when dates change - Optimizado
  useEffect(() => {
    // Usar un pequeño delay para evitar ejecutar durante el render
    if (fechaInicio && fechaFin && difusora && politica) {
      const timeoutId = setTimeout(() => {
        handleCargarDias(false) // No mostrar notificaciones en carga automática
      }, 0)
      return () => clearTimeout(timeoutId)
    }
  }, [fechaInicio, fechaFin, difusora, politica, handleCargarDias])

  // Auto-load días modelo when política changes - Optimizado
  useEffect(() => {
    if (politica) {
      loadDiasModelo()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [politica]) // Solo depender de politica, loadDiasModelo ya maneja politica internamente

  // Clear política when difusora changes and current política is not available for new difusora - Optimizado
  useEffect(() => {
    if (difusora && politica) {
      const currentPoliticaExists = filteredPoliticas.some(p => p.id === parseInt(politica))
      
      if (!currentPoliticaExists) {
        debugLog('🔄 Difusora cambió, limpiando política seleccionada')
        setPolitica('')
      }
    }
  }, [difusora, politica, filteredPoliticas])

  // COMENTADO: No asignar días modelo automáticamente
  // El usuario debe seleccionar explícitamente el día modelo para cada día
  // useEffect(() => {
  //   if (diasModelo.length > 0 && programacionData.length > 0) {
  //     const diasActualizados = programacionData.map(dia => {
  //       // Solo actualizar si no tiene día modelo asignado
  //       if (!dia.diaModelo) {
  //         const diaModeloPorDefecto = getDiaModeloPorDefecto(dia.dia)
  //         if (diaModeloPorDefecto) {
  //           console.log(`🔄 Actualizando día modelo por defecto para ${dia.dia}: ${diaModeloPorDefecto}`)
  //           return { ...dia, diaModelo: diaModeloPorDefecto }
  //         }
  //       }
  //       return dia
  //     })
  //     
  //     // Solo actualizar si hay cambios
  //     const hayCambios = diasActualizados.some((dia, index) => 
  //       dia.diaModelo !== programacionData[index].diaModelo
  //     )
  //     
  //     if (hayCambios) {
  //       setProgramacionData(diasActualizados)
  //     }
  //   }
  // }, [diasModelo])

  // Debug: Log cuando cambie programacionData - Solo en desarrollo
  // Removido para reducir overhead de memoria
  // useEffect(() => {
  //   if (process.env.NODE_ENV === 'development' && programacionData.length > 0) {
  //     debugLog('🔄 programacionData actualizado:', programacionData[0]?.diaModelo);
  //     debugLog('🔄 Estado completo del primer día:', programacionData[0]);
  //   }
  // }, [programacionData])
  
  // Limpiar datos cuando el componente se desmonta
  useEffect(() => {
    return () => {
      // Cleanup: limpiar datos grandes al desmontar
      setProgramacionData([])
      setPoliticas([])
      setDiasModelo([])
      setDifusoras([])
    }
  }, [])

  // Función para cargar el día de hoy automáticamente - Memoizada
  const cargarHoy = useCallback(() => {
    const hoy = getTodayDate()
    setFechaInicio(hoy)
    setFechaFin(hoy)
    showNotification('Fechas actualizadas al día de hoy', 'success')
    // Los días se cargarán automáticamente por el useEffect
  }, [getTodayDate, showNotification])

  // Función para generar programación - Memoizada
  const handleGenerarProgramacion = useCallback(async () => {
    try {
      setLoading(true)
      
      // Verificar que hay filas seleccionadas
      const filasSeleccionadas = programacionData.filter(row => row.selected)
      if (filasSeleccionadas.length === 0) {
        showNotification('Debe seleccionar al menos un día para generar programación', 'warning')
        return
      }
      
      // Verificar que todos los días seleccionados tengan un día modelo asignado
      const diasSinDiaModelo = filasSeleccionadas.filter(row => !row.diaModelo || row.diaModelo.trim() === '')
      if (diasSinDiaModelo.length > 0) {
        const fechasSinDiaModelo = diasSinDiaModelo.map(dia => dia.fecha).join(', ')
        showNotification(`Los siguientes días no tienen día modelo seleccionado: ${fechasSinDiaModelo}. Debe seleccionar un día modelo para cada día antes de generar la programación.`, 'error')
        setLoading(false)
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
      
      // Preparar los días modelo seleccionados para enviar al backend
      const diasModeloSeleccionados = filasSeleccionadas.map(dia => {
        let diaModeloNombre = dia.diaModelo
        if ((!diaModeloNombre || diaModeloNombre.trim()==='') && selectedDiaModelo) {
          const dm = diasModelo.find(d => d.id.toString() === selectedDiaModelo)
          if (dm) diaModeloNombre = dm.nombre
        }
        return { fecha: dia.fecha, dia_modelo: diaModeloNombre }
      })
      
      const url = buildApiUrl(`/programacion/generar-programacion-completa?${params}`)
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          dias_modelo: diasModeloSeleccionados
        })
      })
      
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`)
      }
      
      const result = await response.json()
      
      showNotification(`Programación generada: ${result.dias_generados} días`, 'success')
      
      // Recargar la lista de días para mostrar los cambios
      debugLog('🔄 Recargando días después de generación...')
      await handleCargarDias(false)
      debugLog('✅ Días recargados después de generación')
      
      // NO cargar estadísticas aquí - handleCargarDias ya actualiza todo correctamente
      // await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error al generar programación:', err)
      showNotification(`Error al generar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }, [programacionData, showNotification, handleCargarDias, difusora, politica, fechaInicio, fechaFin, diasModelo, selectedDiaModelo])

  // Función para confirmar sobreescritura de programación - Memoizada
  const handleConfirmarSobreescritura = useCallback(async () => {
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
      
      // Obtener las filas seleccionadas
      const filasSeleccionadas = programacionData.filter(row => row.selected)
      
      // Preparar los días modelo seleccionados para enviar al backend
      debugLog('🔍 DEBUG: selectedDiaModelo from modal:', selectedDiaModelo)
      debugLog('🔍 DEBUG: diasModelo array:', diasModelo)
      debugLog('🔍 DEBUG: filasSeleccionadas:', filasSeleccionadas)
      
      const diasModeloSeleccionados = filasSeleccionadas.map(dia => {
        // Si se seleccionó un día modelo diferente en el modal, usar ese
        // Si no, usar el día modelo actual de la fila
        let diaModeloNombre = dia.diaModelo
        
        debugLog('🔍 DEBUG: Processing day:', dia.fecha, 'current diaModelo:', dia.diaModelo)
        
        if (selectedDiaModelo && selectedDiaModelo !== '') {
          debugLog('🔍 DEBUG: selectedDiaModelo is not empty, looking for ID:', selectedDiaModelo)
          const diaModeloSeleccionado = diasModelo.find(dm => dm.id.toString() === selectedDiaModelo)
          debugLog('🔍 DEBUG: diaModeloSeleccionado found:', diaModeloSeleccionado)
          if (diaModeloSeleccionado) {
            diaModeloNombre = diaModeloSeleccionado.nombre
            debugLog('🔍 DEBUG: Using selected day model name:', diaModeloNombre)
          }
        } else {
          debugLog('🔍 DEBUG: No selectedDiaModelo, using current:', diaModeloNombre)
        }
        
        return {
          fecha: dia.fecha,
          dia_modelo: diaModeloNombre
        }
      })
      
      debugLog('🔍 DEBUG: Días modelo seleccionados para enviar:', diasModeloSeleccionados)
      debugLog('🔍 DEBUG: selectedDiaModelo:', selectedDiaModelo)
      
      const url = buildApiUrl(`/programacion/generar-programacion-completa?${params}`)
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          dias_modelo: diasModeloSeleccionados
        })
      })
      
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`)
      }
      
      const result = await response.json()
      
      showNotification(`Programación regenerada: ${result.dias_generados} días`, 'success')
      
      // Recargar la lista de días para mostrar los cambios
      debugLog('🔄 Recargando días después de regeneración...')
      await handleCargarDias(false)
      debugLog('✅ Días recargados después de regeneración')
      
      // NO cargar estadísticas aquí - handleCargarDias ya actualiza todo correctamente
      // await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error al regenerar programación:', err)
      showNotification(`Error al regenerar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }, [programacionData, difusora, politica, fechaInicio, fechaFin, diasModelo, selectedDiaModelo, showNotification, handleCargarDias])

  // Función para cancelar sobreescritura - Memoizada
  const handleCancelarSobreescritura = useCallback(() => {
    setShowOverwriteModal(false)
    setDiasConProgramacion([])
    setSelectedDiaModelo('')
    setLoading(false)
  }, [])

  // FUNCIÓN ELIMINADA: cargarEstadisticasProgramacion
  // Ya no es necesaria porque handleCargarDias ya actualiza las estadísticas correctamente
  // NOTA: handleCargarDias está definido más arriba (línea 346), antes de los useEffect que lo usan

  const handleEditarProgramacion = useCallback(() => {
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

    debugLog('Editando programación para:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para la consulta
    const [dia, mes, año] = filaSeleccionada.fecha.split('/')
    const fechaParaEdicion = `${año}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`
    
    debugLog('🔍 Fecha para edición:', fechaParaEdicion)
    setFechaConsultar(fechaParaEdicion)
    setShowConsultarModal(true)
  }, [programacionData, showNotification])

  const handleConsultarProgramacion = useCallback(() => {
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
    debugLog('🔍 Fila seleccionada:', filaSeleccionada)
    debugLog('🔍 Fecha de la fila:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para el componente de consulta
    let fechaParaConsulta
    if (filaSeleccionada.fecha && filaSeleccionada.fecha.includes('/')) {
      const [day, month, year] = filaSeleccionada.fecha.split('/')
      fechaParaConsulta = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
    } else {
      fechaParaConsulta = filaSeleccionada.fecha
    }
    
    debugLog('🔍 Fecha para consulta:', fechaParaConsulta)
    setFechaConsultar(fechaParaConsulta)
    setShowConsultarModal(true)
  }, [programacionData, showNotification])

  const handleEliminarProgramacion = useCallback(async () => {
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
        
        const url = buildApiUrl('/programacion/eliminar-programacion')
        const response = await fetch(url, {
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
      // NO cargar estadísticas aquí - handleCargarDias ya actualiza todo correctamente
      // await cargarEstadisticasProgramacion()
      
    } catch (err) {
      console.error('Error eliminando programación:', err)
      showNotification(`Error al eliminar programación: ${err.message}`, 'error')
    } finally {
      setLoading(false)
    }
  }, [programacionData, difusora, politica, showNotification, handleCargarDias])

  const handleImprimirCarta = useCallback(() => {
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

    debugLog('Imprimiendo carta de tiempo para:', filaSeleccionada.fecha)
    
    // Convertir fecha de DD/MM/YYYY a YYYY-MM-DD para la consulta
    const [dia, mes, año] = filaSeleccionada.fecha.split('/')
    const fechaParaImpresion = `${año}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`
    
    // Abrir ventana de impresión
    const url = buildApiUrl(`/programacion/carta-tiempo?difusora=${difusora}&politica_id=${politica}&fecha=${fechaParaImpresion}`)
    window.open(url, '_blank')
    
    showNotification('Abriendo carta de tiempo para impresión...', 'info')
  }, [programacionData, difusora, politica, showNotification])

  const handleGenerarLogFile = useCallback(async () => {
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
        
        const url = buildApiUrl(`/programacion/generar-logfile?difusora=${difusora}&politica_id=${politica}&fecha=${fechaFormateada}`)
        
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
  }, [programacionData, difusora, politica, showNotification])

  // Memoizar handleRowSelect para evitar re-renders innecesarios
  const handleRowSelect = useCallback((id) => {
    setProgramacionData(prev => 
      prev.map(row => 
        row.id === id ? { ...row, selected: !row.selected } : row
      )
    )
    setDataVersion(prev => prev + 1) // Incrementar versión para forzar re-render
  }, [])

  // Memoizar handleSelectAll
  const handleSelectAll = useCallback(() => {
    setProgramacionData(prev => {
      const allSelected = prev.every(row => row.selected)
      return prev.map(row => ({ ...row, selected: !allSelected }))
    })
    setDataVersion(prev => prev + 1) // Incrementar versión para forzar re-render
  }, [])

  // Calculate stats - Memoizado para evitar cálculos innecesarios
  const stats = useMemo(() => ({
    total: programacionData.length,
    selected: programacionData.filter(row => row.selected).length,
    completed: programacionData.filter(row => row.status === 'Con Programación').length,
    pending: programacionData.filter(row => row.status === 'Pendiente').length,
    errors: programacionData.filter(row => row.status === 'Error').length,
    totalEvents: programacionData.reduce((sum, row) => sum + row.eventos, 0),
    totalSongs: programacionData.reduce((sum, row) => sum + row.canciones, 0),
    avgPercentage: programacionData.length > 0 ? 
      (programacionData.reduce((sum, row) => sum + row.porcentaje, 0) / programacionData.length).toFixed(2) : 0
  }), [programacionData])

  // Update selected days count - Memoizado para evitar cálculos innecesarios
  useEffect(() => {
    const selected = programacionData.filter(row => row.selected).length
    setSelectedDays(selected)
    setTotalDays(programacionData.length)
  }, [programacionData])
  
  // Limpiar datos cuando se cambia de difusora o política para liberar memoria
  useEffect(() => {
    if (difusora || politica) {
      // No limpiar aquí porque queremos mantener los datos
      // Solo resetear página cuando cambian los filtros
      setCurrentPage(1)
    }
  }, [difusora, politica])

  // Memoizar getStatusIcon para evitar recrear funciones en cada render
  const getStatusIcon = useCallback((status) => {
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
  }, [])

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

  // Memoizar las filas de la tabla fuera del JSX para evitar problemas con hooks
  const tableRows = useMemo(() => {
    // Paginación: solo renderizar los elementos de la página actual
    const startIndex = (currentPage - 1) * itemsPerPage
    const endIndex = startIndex + itemsPerPage
    const paginatedData = programacionData.slice(startIndex, endIndex)
    
    // Limitar estrictamente el número de elementos renderizados
    if (paginatedData.length === 0) return null
    
    return paginatedData.map((row, index) => {
      const actualIndex = startIndex + index
      // Crear objeto ligero solo con las propiedades necesarias para render
      const rowData = {
        id: row.id,
        fecha: row.fecha,
        dia: row.dia,
        diaModelo: row.diaModelo,
        status: row.status,
        eventos: row.eventos,
        canciones: row.canciones,
        asignadas: row.asignadas,
        porcentaje: row.porcentaje,
        mc: row.mc,
        selected: row.selected
      }
      return (
        <tr 
          key={`${rowData.id}-${rowData.fecha}-v${dataVersion}`} 
          className={`hover:bg-blue-50/50 transition-colors cursor-pointer ${actualIndex % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'} ${rowData.selected ? 'bg-blue-50 border-l-4 border-blue-500' : ''}`}
          onClick={(e) => {
            // Prevenir la selección si se hace clic en el checkbox o en un select
            if (e.target.type === 'checkbox' || e.target.tagName === 'SELECT') {
              return
            }
            handleRowSelect(rowData.id)
          }}
        >
          <td className="px-6 py-4 whitespace-nowrap" onClick={(e) => e.stopPropagation()}>
            <input 
              type="checkbox" 
              className="w-5 h-5 rounded border-gray-300 text-blue-600 focus:ring-blue-500 cursor-pointer" 
              checked={rowData.selected}
              onChange={(e) => {
                e.stopPropagation()
                handleRowSelect(rowData.id)
              }}
            />
          </td>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{rowData.fecha}</td>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">{rowData.dia}</td>
          <td className="px-6 py-4 whitespace-nowrap">
            {rowData.status === 'Con Programación' ? (
              <span className="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-bold bg-blue-100 text-blue-800 border border-blue-300">
                {rowData.diaModelo || 'Sin día modelo'}
              </span>
            ) : (
              <select
                value={rowData.diaModelo || ''}
                onChange={(e) => {
                  e.stopPropagation()
                  const newData = programacionData.map(item => 
                    item.id === rowData.id 
                      ? { ...item, diaModelo: e.target.value }
                      : item
                  )
                  setProgramacionData(newData)
                  setDataVersion(prev => prev + 1)
                }}
                onClick={(e) => e.stopPropagation()}
                className="w-full px-3 py-2 text-xs border border-gray-300 rounded focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
              >
                <option value="">Seleccionar...</option>
                {diasModelo && diasModelo.length > 0 ? (
                  diasModelo.slice(0, 20).map((dia) => (
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
          <td className="px-6 py-4 whitespace-nowrap">
            <div className="flex items-center space-x-2">
              {getStatusIcon(rowData.status)}
              <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border ${
                rowData.status === 'Con Programación' ? 'bg-green-100 text-green-800 border-green-300' :
                rowData.status === 'Sin Configuración' ? 'bg-orange-100 text-orange-800 border-orange-300' :
                rowData.status === 'Pendiente' ? 'bg-yellow-100 text-yellow-800 border-yellow-300' :
                'bg-red-100 text-red-800 border-red-300'
              }`}>
                {rowData.status}
              </span>
            </div>
          </td>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">{rowData.eventos.toLocaleString()}</td>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">{rowData.canciones.toLocaleString()}</td>
          <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">{rowData.asignadas.toLocaleString()}</td>
          <td className="px-6 py-4 whitespace-nowrap">
            <div className="flex items-center space-x-2">
              <div className="w-16 bg-gray-200 rounded-full h-2">
                <div 
                  className={`h-2 rounded-full ${
                    rowData.porcentaje >= 90 ? 'bg-green-500' :
                    rowData.porcentaje >= 70 ? 'bg-yellow-500' :
                    'bg-red-500'
                  }`}
                  style={{ width: `${Math.min(rowData.porcentaje, 100)}%` }}
                ></div>
              </div>
              <span className="text-xs font-medium text-gray-600">{rowData.porcentaje.toFixed(2)}%</span>
            </div>
          </td>
          <td className="px-6 py-4 whitespace-nowrap">
            <span className="inline-flex px-3 py-1.5 text-xs font-bold rounded-full bg-orange-100 text-orange-800 border border-orange-300">
              {rowData.mc}
            </span>
          </td>
        </tr>
      )
    })
  }, [programacionData, currentPage, itemsPerPage, dataVersion, handleRowSelect, diasModelo, getStatusIcon])

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
    <>
      {/* Enhanced Notification Component - Outside main container */}
      {notification && (
        <div className={`fixed top-4 right-4 z-[10000] p-4 rounded-xl shadow-2xl max-w-md transition-all duration-300 border-2 ${
          notification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border-green-300 text-green-800'
            : notification.type === 'info'
            ? 'bg-gradient-to-r from-blue-50 to-cyan-50 border-blue-300 text-blue-800'
            : 'bg-gradient-to-r from-red-50 to-pink-50 border-red-300 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <CheckCircle className="w-5 h-5 mr-2 text-green-600" />
              ) : notification.type === 'info' ? (
                <Info className="w-5 h-5 mr-2 text-blue-600" />
              ) : (
                <AlertCircle className="w-5 h-5 mr-2 text-red-600" />
              )}
              <span className="font-semibold">{notification.message}</span>
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

      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-100/50 overflow-hidden relative">
        {/* Fondo decorativo */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute top-0 left-1/4 w-96 h-96 bg-blue-200/20 rounded-full blur-3xl"></div>
          <div className="absolute bottom-0 right-1/4 w-80 h-80 bg-indigo-200/20 rounded-full blur-3xl"></div>
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-blue-200/10 rounded-full blur-2xl"></div>
        </div>

        <div className="relative z-10 p-6">
          <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden mb-6">
            {/* Enhanced Header */}
            <div className="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
              <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                    <Radio className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h1 className="text-3xl font-bold text-white mb-1">Generar Programación</h1>
                    <p className="text-blue-100 text-sm">Configura y genera la programación musical para tus difusoras</p>
                  </div>
                </div>
                
                {/* Quick Stats */}
                <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
                  <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 px-4 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex flex-col">
                      <span className="text-blue-800 font-bold text-xs">Total Días</span>
                      <span className="bg-blue-600 text-white px-2 py-1 rounded-full text-lg font-bold mt-1 text-center">{stats.total}</span>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 px-4 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex flex-col">
                      <span className="text-indigo-800 font-bold text-xs">Seleccionados</span>
                      <span className="bg-indigo-600 text-white px-2 py-1 rounded-full text-lg font-bold mt-1 text-center">{stats.selected}</span>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-300 px-4 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex flex-col">
                      <span className="text-green-800 font-bold text-xs">Completados</span>
                      <span className="bg-green-600 text-white px-2 py-1 rounded-full text-lg font-bold mt-1 text-center">{stats.completed}</span>
                    </div>
                  </div>
                  <div className="bg-gradient-to-br from-purple-50 to-purple-100 border-2 border-purple-300 px-4 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                    <div className="flex flex-col">
                      <span className="text-purple-800 font-bold text-xs">Promedio</span>
                      <span className="bg-purple-600 text-white px-2 py-1 rounded-full text-lg font-bold mt-1 text-center">{stats.avgPercentage}%</span>
                    </div>
                  </div>
                </div>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
            </div>

            {/* Enhanced Action Buttons */}
            <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
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

            {/* Enhanced Collapsible Filters */}
            {showFilters && (
              <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200 transition-all duration-300">
                <div className="flex items-center space-x-3 mb-4">
                  <Settings className="w-5 h-5 text-blue-600" />
                  <h2 className="text-lg font-bold text-gray-900">Filtros de Programación</h2>
                </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
              <div>
                <label className="block text-sm font-bold text-gray-700 mb-2">Difusora</label>
                <div className="relative">
                  <select 
                    value={difusora} 
                    onChange={(e) => setDifusora(e.target.value)}
                    disabled={loadingDifusoras}
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 appearance-none bg-white disabled:bg-gray-100 disabled:cursor-not-allowed hover:border-gray-400"
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
                <label className="block text-sm font-bold text-gray-700 mb-2">
                  Política
                  {difusora && (
                    <span className="ml-2 text-xs text-gray-500">
                      ({getFilteredPoliticas().length} disponible{getFilteredPoliticas().length !== 1 ? 's' : ''})
                    </span>
                  )}
                </label>
                <div className="relative">
                  <select 
                    value={politica} 
                    onChange={(e) => setPolitica(e.target.value)}
                    disabled={loadingPoliticas}
                    className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 appearance-none bg-white disabled:bg-gray-100 disabled:cursor-not-allowed hover:border-gray-400"
                  >
                    {loadingPoliticas ? (
                      <option value="">Cargando políticas...</option>
                    ) : getFilteredPoliticas().length === 0 ? (
                      <option value="">No hay políticas disponibles para esta difusora</option>
                    ) : (
                      <>
                        <option value="">Seleccionar política...</option>
                        {getFilteredPoliticas().map(p => (
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
              
              
              <div className="col-span-2">
                <label className="block text-sm font-bold mb-2">
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
                      debugLog('Date picker toggled:', !showDatePicker)
                      setShowDatePicker(!showDatePicker)
                    }}
                    disabled={!isDatePickerEnabled}
                    className={`w-full px-4 py-3 pr-10 border-2 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-300 text-left ${
                      !isDatePickerEnabled
                        ? 'border-gray-200 bg-gray-50 text-gray-400 cursor-not-allowed'
                        : 'border-gray-300 bg-white hover:bg-gray-50 text-gray-900 hover:border-gray-400'
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
                            debugLog('Date picker closed')
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
          <div className="px-8 py-4 bg-gradient-to-r from-red-50 via-pink-50 to-red-50 border-b border-red-200">
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
                  }}
                  disabled={loadingDifusoras || loadingPoliticas}
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
        <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
          <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
            <div className="flex items-center justify-between">
              <h3 className="text-xl font-bold text-gray-900">Días de Programación</h3>
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
            <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                  <input 
                    type="checkbox" 
                    className="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
                    checked={programacionData.every(row => row.selected)}
                    onChange={handleSelectAll}
                  />
                </th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Fecha</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Día</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Día Modelo</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Status</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider"># Eventos</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider"># Canciones</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Asignadas</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">%</th>
                <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">MC</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {tableRows}
            </tbody>
          </table>
          
          {/* Paginación - Solo mostrar si hay más de itemsPerPage elementos */}
          {programacionData.length > itemsPerPage && (
            <div className="flex items-center justify-between px-6 py-4 bg-gray-50 border-t border-gray-200">
              <div className="text-sm text-gray-700">
                Mostrando {((currentPage - 1) * itemsPerPage) + 1} a {Math.min(currentPage * itemsPerPage, programacionData.length)} de {programacionData.length} días
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                  disabled={currentPage === 1}
                  className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Anterior
                </button>
                <span className="px-4 py-2 text-sm font-medium text-gray-700">
                  Página {currentPage} de {Math.ceil(programacionData.length / itemsPerPage)}
                </span>
                <button
                  onClick={() => setCurrentPage(prev => Math.min(Math.ceil(programacionData.length / itemsPerPage), prev + 1))}
                  disabled={currentPage >= Math.ceil(programacionData.length / itemsPerPage)}
                  className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Siguiente
                </button>
              </div>
            </div>
          )}
        </div>
        
        {/* Enhanced Empty State - Only show when no data and not loading */}
        {programacionData.length === 0 && !loading && (
          <div className="text-center py-20 px-6">
            <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
              <Radio className="w-12 h-12 text-gray-400" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-3">
              No hay días de programación
            </h3>
            <p className="text-gray-600 mb-8 max-w-md mx-auto text-base">
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
                  className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold hover:shadow-xl transform hover:scale-105 hover:-translate-y-1 flex items-center space-x-2"
                >
                  <Calendar className="w-5 h-5" />
                  <span>Cargar Días del Período</span>
                </button>
              </div>
            )}
          </div>
        )}
      </div>

      {/* Enhanced Selection Counter */}
      <div className="mt-6 bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 p-6">
        <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-3">
                <div className="w-4 h-4 bg-blue-500 rounded-full shadow-md animate-pulse"></div>
                <span className="text-sm font-bold text-gray-700">Días Seleccionados</span>
              </div>
              <div className="text-2xl font-bold text-blue-600">{selectedDays}</div>
              <span className="text-gray-500 font-medium">de</span>
              <div className="text-2xl font-bold text-gray-600">{totalDays}</div>
              <span className="text-gray-500 font-medium">días totales</span>
            </div>
            
            <div className="flex items-center space-x-4 text-sm font-semibold">
              <span className="flex items-center space-x-1 text-green-700">
                <CheckCircle className="w-5 h-5 text-green-600" />
                <span>{stats.completed} Completados</span>
              </span>
              <span className="flex items-center space-x-1 text-yellow-700">
                <Clock className="w-5 h-5 text-yellow-600" />
                <span>{stats.pending} Pendientes</span>
              </span>
              <span className="flex items-center space-x-1 text-red-700">
                <AlertCircle className="w-5 h-5 text-red-600" />
                <span>{stats.errors} Errores</span>
              </span>
            </div>
          </div>
        </div>
      </div>
      </div>

      {/* Modal de Consultar Programación - Lazy loaded */}
      {showConsultarModal && (
        <Suspense fallback={
          <div className="fixed inset-0 bg-black bg-opacity-50 z-[9999] flex items-center justify-center">
            <div className="bg-white rounded-2xl shadow-2xl p-8">
              <div className="flex items-center space-x-4">
                <div className="w-8 h-8 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
                <span className="text-gray-700 font-medium">Cargando editor de programación...</span>
              </div>
            </div>
          </div>
        }>
          <ConsultarProgramacionComponent
            isOpen={showConsultarModal}
            onClose={() => setShowConsultarModal(false)}
            difusora={difusora}
            politica={politica}
            fecha={fechaConsultar}
          />
        </Suspense>
      )}

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
    </>
  )
}
