import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { 
  politicasApi, 
  diasModeloApi, 
  relojesApi, 
  eventosRelojApi 
} from '../../../../api/programacion/politicasApi';
import { buildApiUrl } from '../../../../utils/apiConfig';
import {
  getReglasByPolitica,
  createRegla,
  updateRegla,
  deleteRegla
} from '../../../../api/reglas';
import { guardarCategoriasPolitica, obtenerCategoriasPolitica } from '../../../../api/canciones';
import OrdenAsignacion from './OrdenAsignacion'
import EventosReloj from './EventosReloj';

export default function PoliticasProgramacion() {
  // Estado para políticas de programación - cargar todas una vez, filtrar del lado del cliente
  const [politicas, setPoliticas] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [formMode, setFormMode] = useState('new');
  const [selectedPolitica, setSelectedPolitica] = useState(null);
  
  // Estados para el modal de relojes
  const [showRelojForm, setShowRelojForm] = useState(false);
  const [selectedReloj, setSelectedReloj] = useState(null);
  const [relojFormMode, setRelojFormMode] = useState('new');
  
  // Estado para el formulario de días modelo
  const [showDiaModeloForm, setShowDiaModeloForm] = useState(false);
  const [diaModeloFormMode, setDiaModeloFormMode] = useState('new');
  const [selectedDiaModelo, setSelectedDiaModelo] = useState(null);
  
  // Estado para la lista de relojes
  const [relojes, setRelojes] = useState([]);
  
  // Estado para la lista de días modelo
  const [diasModelo, setDiasModelo] = useState([]);
  
  // Estados para el modal de eventos
  const [showEventForm, setShowEventForm] = useState(false);
  const [selectedEventType, setSelectedEventType] = useState(null);
  const [eventFormData, setEventFormData] = useState({
    consecutivo: '',
    offset: '',
    duracion: '',
    descripcion: '',
    idMedia: '',
    categoria: '',
    tipoETM: '',
  });
  
  // Estado para manejar los eventos del reloj actualmente en edición
  const [relojEvents, setRelojEvents] = useState([]);
  
  const [showOnlyActive, setShowOnlyActive] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [notification, setNotification] = useState(null);
  const [viewMode, setViewMode] = useState('tarjetas'); // 'tarjetas' or 'grid'
  const [expandedCategories, setExpandedCategories] = useState(new Set());
  // Nota: la acción ETM se maneja localmente dentro de RelojForm
  const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
  const [selectedRelojInTable, setSelectedRelojInTable] = useState(null);
  const [categoriasSeleccionadas, setCategoriasSeleccionadas] = useState([]);
  const [politicaFormActiveTab, setPoliticaFormActiveTab] = useState(0); // Mostrar primera pestaña por defecto
  
  // Estados para el modal de reglas
  const [showReglaForm, setShowReglaForm] = useState(false);
  const [reglaFormData, setReglaFormData] = useState({
    posicion: 0,
    tipoRegla: 'Separación Mínima',
    caracteristica: 'Inquebrantable',
    caracteristica2: '',
    setReglas: false,
    reglaHabilitada: true,
    caracteristicaDetalle: '',
    horario: false,
    horaInicial: '',
    horaFinal: '',
    tipoSeparacion: 'Tiempo - Segundos',
    soloVerificarDia: false,
    descripcion: '',
    separaciones: []
  });
  
  // Estado para las reglas de la política actual
  const [reglasPolitica, setReglasPolitica] = useState([]);
  const [loadingReglas, setLoadingReglas] = useState(false);

  // Cargar reglas por política - Memoizada (debe definirse antes de handleReglaSave)
  const loadReglasPolitica = useCallback(async (politicaId) => {
    try {
      setLoadingReglas(true);

      const reglasData = await getReglasByPolitica(politicaId);

      setReglasPolitica(reglasData);
    } catch (error) {

    } finally {
      setLoadingReglas(false);
    }
  }, []);

  // Cargar categorías seleccionadas al inicializar el componente - Optimizado
  useEffect(() => {
    // No cargar categorías automáticamente - se cargarán cuando se edite una política específica

    setCategoriasSeleccionadas([]);
  }, []);

  // Controlar el scroll del body cuando cualquier modal esté abierto
  useEffect(() => {
    if (showForm || showRelojForm || showReglaForm) {
      // Bloquear el scroll del body
      document.body.style.overflow = 'hidden';
    } else {
      // Restaurar el scroll del body
      document.body.style.overflow = 'unset';
    }

    // Cleanup: restaurar el scroll cuando el componente se desmonte
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [showForm, showRelojForm, showReglaForm]);

  // Debug: monitorear cambios en showReglaForm
  useEffect(() => {

  }, [showReglaForm]);

  // ===== FUNCIONES AUXILIARES =====
  
  // Función para cargar categorías de una política - Memoizada
  const loadCategoriasPolitica = useCallback(async (politicaId) => {
    if (!politicaId) {

      setCategoriasSeleccionadas([]);
      return;
    }
    
    try {

      const categoriasData = await obtenerCategoriasPolitica(politicaId);

      
      if (categoriasData?.categorias && Array.isArray(categoriasData.categorias)) {
        // Si las categorías son strings, usarlas directamente; si son objetos, extraer el nombre
        const categoriasNombres = categoriasData.categorias.map(c => 
          typeof c === 'string' ? c : c.nombre || c
        );
        setCategoriasSeleccionadas(categoriasNombres);

      } else {

        setCategoriasSeleccionadas([]);
      }
    } catch (error) {

      setCategoriasSeleccionadas([]);
    }
  }, []);

  // Función para manejar el guardado de categorías desde OrdenAsignacion - Memoizada
  const handleCategoriasSaved = useCallback((configuracion) => {

    // Actualizar las categorías seleccionadas
    if (configuracion.categorias) {
      const nuevasCategorias = configuracion.categorias.map(c => c.nombre);

      // Actualizar el estado de categorías seleccionadas
      setCategoriasSeleccionadas(nuevasCategorias);
    }
  }, []);
  
  // Función para convertir errores de API a cadenas legibles - Memoizada
  const formatErrorMessage = useCallback((error, defaultMessage = 'Error desconocido') => {
    if (error.response?.data?.detail) {
      if (typeof error.response.data.detail === 'string') {
        return error.response.data.detail;
      } else if (Array.isArray(error.response.data.detail)) {
        return error.response.data.detail.map(e => e.msg || e.message || String(e)).join(', ');
      } else {
        return JSON.stringify(error.response.data.detail);
      }
    } else if (error.message) {
      return error.message;
    }
    return defaultMessage;
  }, []);

  // Load políticas - Memoizada
  const loadPoliticas = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      
      const data = await politicasApi.getAll();
      
      if (!data || !Array.isArray(data)) {
        setPoliticas([]);
        return;
      }
      
      // Mapear datos de la API al formato esperado por el componente
      const politicasMapeadas = data.map(politica => ({
        id: politica.id,
        clave: politica.clave,
        nombre: politica.nombre,
        descripcion: politica.descripcion || `Política para ${politica.difusora}`,
        habilitada: politica.habilitada,
        tipo: 'General',
        prioridad: 'Media',
        fechaCreacion: politica.created_at ? new Date(politica.created_at).toLocaleDateString('es-ES') : 'N/A',
        ultimaModificacion: politica.updated_at ? new Date(politica.updated_at).toLocaleDateString('es-ES') : 'N/A',
        alta: politica.created_at ? new Date(politica.created_at).toLocaleDateString('es-ES') : 'N/A',
        modificacion: politica.updated_at ? new Date(politica.updated_at).toLocaleDateString('es-ES') : 'N/A',
        difusora: politica.difusora,
        guid: politica.guid
      }));
      
      setPoliticas(politicasMapeadas);
    } catch (err) {
      const errorMessage = err.response?.data?.detail || err.message || 'Error al cargar las políticas';
      setError(errorMessage);
      setPoliticas([]);
    } finally {
      setLoading(false);
    }
  }, []);

  // Cargar días modelo por política - Memoizada
  const loadDiasModelo = useCallback(async (politicaId) => {
    try {

      const diasModeloData = await diasModeloApi.getByPolitica(politicaId);



      setDiasModelo(diasModeloData);
    } catch (err) {

      setDiasModelo([]);
    }
  }, []);

  // Cargar relojes por política - Memoizada
  const loadRelojes = useCallback(async (politicaId) => {
    try {

      const relojesData = await relojesApi.getByPolitica(politicaId);

      setRelojes(relojesData);
    } catch (err) {

      setRelojes([]);
    }
  }, []);

  // Manejar nuevo día modelo - Memoizada
  const handleNewDiaModelo = useCallback(() => {
    setShowDiaModeloForm(true);
  }, []);

  // Funciones para el formulario de reglas - Memoizadas
  const handleNewRegla = useCallback(() => {


    setReglaFormData({
      tipoRegla: '',
      reglaHabilitada: true,
      caracteristicaDetalle: 'ID de Canción',
      horario: false,
      horaInicial: '',
      horaFinal: '',
      tipoSeparacion: '',
      soloVerificarDia: false,
      separaciones: []
    });

    setShowReglaForm(true);

  }, []);

  const handleReglaFormChange = useCallback((field, value) => {
    setReglaFormData(prev => ({
      ...prev,
      [field]: value
    }));
  }, []);

  const handleSeparacionChange = useCallback((index, field, value) => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: prev.separaciones.map((sep, i) => 
        i === index ? { ...sep, [field]: value } : sep
      )
    }));
  }, []);

  const addSeparacion = useCallback(() => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: [...prev.separaciones, { valor: '', separacion: 0 }]
    }));
  }, []);

  const removeSeparacion = useCallback((index) => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: prev.separaciones.filter((_, i) => i !== index)
    }));
  }, []);

  const handleReglaSave = useCallback(async () => {
    try {

      
      // Preparar datos para enviar a la API
      const reglaData = {
        politica_id: politica?.id || 1, // Usar la política actual o un ID por defecto
        tipo_regla: reglaFormData.tipoRegla,
        caracteristica: reglaFormData.caracteristicaDetalle,
        tipo_separacion: reglaFormData.tipoSeparacion,
        descripcion: reglaFormData.descripcion,
        horario: reglaFormData.horario,
        solo_verificar_dia: reglaFormData.soloVerificarDia,
        habilitada: reglaFormData.reglaHabilitada,
        separaciones: reglaFormData.separaciones.map(sep => ({
          valor: sep.valor,
          separacion: parseInt(sep.separacion) || 0
        }))
      };
      
      // Crear la regla
      const nuevaRegla = await createRegla(reglaData);

      
      // Cerrar el modal y limpiar el formulario
      setShowReglaForm(false);
      setReglaFormData({
        tipoRegla: 'Separación Mínima',
        caracteristica: '',
        tipoSeparacion: 'Tiempo - Segundos',
        horario: false,
        soloVerificarDia: false,
        habilitada: true,
        separaciones: []
      });
      
      // Mostrar notificación de éxito

      
      // Recargar las reglas de la política
      await loadReglasPolitica(selectedPolitica?.id || 1);
      
    } catch (error) {


    }
  }, [reglaFormData, selectedPolitica, loadReglasPolitica]);

  const handleReglaCancel = useCallback(() => {
    setShowReglaForm(false);
  }, []);

  // Manejar editar día modelo - Memoizada
  const handleEditDiaModelo = useCallback((diaModelo) => {
    setShowDiaModeloForm(true);
  }, []);

  // Manejar ver día modelo - Memoizada
  const handleViewDiaModelo = useCallback((diaModelo) => {
    setShowDiaModeloForm(true);
  }, []);

  useEffect(() => {
    loadPoliticas();
  }, [loadPoliticas]);

  // Cargar días modelo cuando se selecciona una política - Optimizado
  useEffect(() => {
    if (selectedPolitica?.id) {
      loadDiasModelo(selectedPolitica.id);
    } else {
      setDiasModelo([]);
    }
  }, [selectedPolitica, loadDiasModelo]);

  // Cargar relojes cuando se selecciona una política - Optimizado
  useEffect(() => {
    if (selectedPolitica?.id) {
      loadRelojes(selectedPolitica.id);
    } else {
      setRelojes([]);
    }
  }, [selectedPolitica, loadRelojes]);

  // Seleccionar el primer reloj por defecto - DESHABILITADO para evitar reaperturas automáticas
  // useEffect(() => {
  //   // Solo seleccionar automáticamente si no estamos en modo de creación/edición
  //   if (relojes.length > 0 && !selectedRelojInTable && !showRelojForm) {
  //     setSelectedRelojInTable(relojes[0]);
  //   }
  // }, [relojes, selectedRelojInTable, showRelojForm]);

  // Función para obtener el color de cada categoría de evento - Memoizada
  const getEventColor = useCallback((categoria) => {
    const colorMap = {
      'Canciones': '#3b82f6', // blue-500
      'Nota Operador': '#eab308', // yellow-500
      'Cartucho Fijo': '#8b5cf6', // purple-500
      'Corte Comercial': '#ef4444', // red-500
      'ETM': '#22c55e', // green-500
    };
    
    return colorMap[categoria] || '#6b7280'; // gray-500 como fallback
  }, []);

  // Función para obtener los eventos del reloj seleccionado en la tabla - Memoizada
  const getSelectedRelojEvents = useCallback(() => {
    // Si estamos en el formulario de reloj (creando o editando), usar relojEvents
    if (showRelojForm) {
      return relojEvents || [];
    }

    // Si hay un reloj seleccionado en la tabla, buscar sus eventos
    if (selectedRelojInTable) {
      const relojSeleccionado = relojes.find(reloj => reloj.id === selectedRelojInTable.id);
      return relojSeleccionado ? relojSeleccionado.eventos || [] : [];
    }

    // Si no hay nada seleccionado, devolver array vacío
    return [];
  }, [showRelojForm, relojEvents, selectedRelojInTable, relojes]);

  // Función para calcular la duración total del reloj seleccionado - Memoizada
  const getSelectedRelojDuration = useCallback(() => {
    const events = getSelectedRelojEvents();
    if (events.length === 0) return "0' 00\" 00\"";
    
    let totalSeconds = 0;
    events.forEach(event => {
      // Manejar tanto duración en segundos (number) como en formato HH:MM:SS (string)
      if (typeof event.duracion === 'number') {
        totalSeconds += event.duracion;
      } else if (typeof event.duracion === 'string' && event.duracion.includes(':')) {
        const [hours, minutes, seconds] = event.duracion.split(':').map(Number);
        totalSeconds += hours * 3600 + minutes * 60 + seconds;
      } else {
        // Fallback: tratar como segundos
        totalSeconds += parseInt(event.duracion) || 0;
      }
    });
    
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;
    
    return `${hours}' ${minutes.toString().padStart(2, '0')}\" ${secs.toString().padStart(2, '0')}\"`;
  }, [getSelectedRelojEvents]);

  // Filter políticas - Optimizado con useMemo
  const filteredPoliticas = useMemo(() => {
    let filtered = politicas;
    
    if (showOnlyActive) {
      filtered = filtered.filter(p => p.habilitada === true);
    }
    
    if (searchTerm.trim()) {
      const searchLower = searchTerm.toLowerCase().trim();
      filtered = filtered.filter(p => 
        p.nombre?.toLowerCase().includes(searchLower) ||
        p.clave?.toLowerCase().includes(searchLower) ||
        p.difusora?.toLowerCase().includes(searchLower) ||
        p.descripcion?.toLowerCase().includes(searchLower)
      );
    }
    
    return filtered;
  }, [politicas, showOnlyActive, searchTerm]);

  // Show notification - Memoizada
  const showNotification = useCallback((message, type = 'error') => {
    setNotification({ message, type });
  }, []);

  // Función para obtener estadísticas por categoría - Memoizada
  const getCategoryStats = useCallback(() => {
    const stats = {};
    
    relojEvents.forEach(event => {
      const category = event.categoria;
      if (!stats[category]) {
        stats[category] = {
          count: 0,
          duration: 0,
          events: []
        };
      }
      stats[category].count++;
      stats[category].events.push(event);
      
      // Convertir duración a minutos
      let durationInMinutes = 0;
      if (typeof event.duracion === 'number') {
        // Si ya está en segundos, convertir a minutos
        durationInMinutes = event.duracion / 60;
      } else if (typeof event.duracion === 'string' && event.duracion.includes(':')) {
        const durationParts = event.duracion.split(':');
        const minutes = parseInt(durationParts[0]) || 0;
        const seconds = parseInt(durationParts[1]) || 0;
        durationInMinutes = minutes + (seconds / 60);
      } else {
        // Fallback: tratar como segundos
        durationInMinutes = (parseInt(event.duracion) || 0) / 60;
      }
      stats[category].duration += durationInMinutes;
    });
    
    return stats;
  }, [relojEvents]);

  // Función para formatear duración - Memoizada
  const formatDuration = useCallback((minutes) => {
    const mins = Math.floor(minutes);
    const secs = Math.round((minutes - mins) * 60);
    return `${mins}' ${secs.toString().padStart(2, '0')}"`;
  }, []);

  // Función para manejar expansión de categorías - Memoizada
  const toggleCategoryExpansion = useCallback((category) => {
    setExpandedCategories(prev => {
      const newExpanded = new Set(prev);
      if (newExpanded.has(category)) {
        newExpanded.delete(category);
      } else {
        newExpanded.add(category);
      }
      return newExpanded;
    });
  }, []);

  // Función para ordenar estadísticas - Memoizada
  const sortStats = useCallback((key) => {
    setSortConfig(prev => {
      let direction = 'asc';
      if (prev.key === key && prev.direction === 'asc') {
        direction = 'desc';
      }
      return { key, direction };
    });
  }, []);

  // Función para obtener estadísticas ordenadas - Memoizada
  const getSortedCategoryStats = useCallback(() => {
    const stats = getCategoryStats();
    const entries = Object.entries(stats);
    
    if (!sortConfig.key) return entries;
    
    return entries.sort((a, b) => {
      const [categoryA, statsA] = a;
      const [categoryB, statsB] = b;
      
      let comparison = 0;
      if (sortConfig.key === 'categoria') {
        comparison = categoryA.localeCompare(categoryB);
      } else if (sortConfig.key === 'eventos') {
        comparison = statsA.count - statsB.count;
      } else if (sortConfig.key === 'duracion') {
        comparison = statsA.duration - statsB.duration;
      }
      
      return sortConfig.direction === 'asc' ? comparison : -comparison;
    });
  }, [getCategoryStats, sortConfig]);

  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [notification]);

  const handleNew = useCallback(() => {
    setSelectedPolitica(null);
    setFormMode('new');
    setShowForm(true);
  }, []);

  const loadRelojesForPolitica = useCallback(async (politicaId) => {
    try {

      const relojesData = await relojesApi.getByPolitica(politicaId);

      setRelojes(relojesData);
    } catch (err) {

      setRelojes([]);
    }
  }, []);


  // Actualizar estado habilitado de un reloj - Memoizada
  const handleToggleRelojHabilitado = useCallback(async (relojId, nuevoEstado) => {
    // Guardar el estado anterior para poder revertir en caso de error
    const relojAnterior = relojes.find(r => r.id === relojId);
    const estadoAnterior = relojAnterior?.habilitado || false;
    
    try {
      // Actualizar estado local primero para feedback inmediato
      setRelojes(prev => prev.map(r => 
        r.id === relojId ? { ...r, habilitado: nuevoEstado } : r
      ));

      // Actualizar en la base de datos
      await relojesApi.update(relojId, { habilitado: nuevoEstado });

    } catch (error) {

      
      // Revertir cambio local en caso de error
      setRelojes(prev => prev.map(r => 
        r.id === relojId ? { ...r, habilitado: estadoAnterior } : r
      ));
      
      setNotification({ 
        type: 'error', 
        message: 'Error al actualizar el estado del reloj. Por favor, intenta de nuevo.' 
      });
    }
  }, [relojes, showNotification]);

  // Actualizar estado habilitada de una regla - Memoizada
  const handleToggleReglaHabilitada = useCallback(async (reglaId, nuevoEstado) => {
    // Guardar el estado anterior para poder revertir en caso de error
    const reglaAnterior = reglasPolitica.find(r => r.id === reglaId);
    const estadoAnterior = reglaAnterior?.habilitada ?? true;
    
    try {
      // Actualizar estado local primero para feedback inmediato
      setReglasPolitica(prev => prev.map(r => 
        r.id === reglaId ? { ...r, habilitada: nuevoEstado } : r
      ));

      // Actualizar en la base de datos
      await updateRegla(reglaId, { habilitada: nuevoEstado });

    } catch (error) {

      
      // Revertir cambio local en caso de error
      setReglasPolitica(prev => prev.map(r => 
        r.id === reglaId ? { ...r, habilitada: estadoAnterior } : r
      ));
      
      setNotification({ 
        type: 'error', 
        message: 'Error al actualizar el estado de la regla. Por favor, intenta de nuevo.' 
      });
    }
  }, [reglasPolitica, showNotification]);

  // Actualizar estado habilitado de un día modelo - Memoizada
  const handleToggleDiaModeloHabilitado = useCallback(async (diaModeloId, nuevoEstado) => {
    // Guardar el estado anterior para poder revertir en caso de error
    const diaModeloAnterior = diasModelo.find(dm => dm.id === diaModeloId);
    const estadoAnterior = diaModeloAnterior?.habilitado ?? true;
    
    try {
      // Actualizar estado local primero para feedback inmediato
      setDiasModelo(prev => prev.map(dm => 
        dm.id === diaModeloId ? { ...dm, habilitado: nuevoEstado } : dm
      ));

      // Actualizar en la base de datos
      await diasModeloApi.update(diaModeloId, { habilitado: nuevoEstado });

    } catch (error) {

      
      // Revertir cambio local en caso de error
      setDiasModelo(prev => prev.map(dm => 
        dm.id === diaModeloId ? { ...dm, habilitado: estadoAnterior } : dm
      ));
      
      setNotification({ 
        type: 'error', 
        message: 'Error al actualizar el estado del día modelo. Por favor, intenta de nuevo.' 
      });
    }
  }, [diasModelo, showNotification]);

  const handleEdit = useCallback(async (politica) => {



    
    // Resetear categorías seleccionadas para no arrastrar selección entre políticas
    setCategoriasSeleccionadas([]);
    
    try {
      // Obtener los datos completos de la política
      const politicaCompleta = await politicasApi.getById(politica.id);

      setSelectedPolitica(politicaCompleta);
    } catch (error) {

      setSelectedPolitica(politica);
    }
    
    setFormMode('edit');
    setShowForm(true);
    // Cargar relojes de la política
    await loadRelojesForPolitica(politica.id);
    // Cargar reglas de la política
    await loadReglasPolitica(politica.id);
  }, [loadRelojesForPolitica, loadReglasPolitica]);

  const handleView = useCallback(async (politica) => {
    setSelectedPolitica(politica);
    setFormMode('view');
    setShowForm(true);
    // Cargar relojes de la política
    await loadRelojesForPolitica(politica.id);
  }, [loadRelojesForPolitica]);

  const handleDelete = useCallback(async (id) => {
    const politica = politicas.find(p => p.id === id);
    if (window.confirm(`¿Está seguro de eliminar la política "${politica?.nombre}"?`)) {
      try {
        setLoading(true);
        await politicasApi.delete(id);
        showNotification('Política eliminada correctamente', 'success');
        // Actualizar estado local en lugar de recargar todo
        setPoliticas(prev => prev.filter(p => p.id !== id));
      } catch (err) {

        showNotification(`Error al eliminar la política: ${err.message}`, 'error');
      } finally {
        setLoading(false);
      }
    }
  }, [politicas, showNotification]);

  const handleToggleActive = useCallback(() => {
    setShowOnlyActive(prev => !prev);
  }, []);

  const handleSave = useCallback(async (politicaData) => {
    try {
      setLoading(true);



      
      if (formMode === 'edit') {

        await politicasApi.update(selectedPolitica.id, politicaData);
        showNotification('Política actualizada correctamente', 'success');
      } else {

        await politicasApi.create(politicaData);
        showNotification('Política creada correctamente', 'success');
      }
      
      // Actualizar estado local en lugar de recargar todo
      if (formMode === 'edit' && selectedPolitica) {
        setPoliticas(prev => prev.map(p => 
          p.id === selectedPolitica.id ? { ...p, ...politicaData } : p
        ))
      } else {
        // Para nuevas políticas, recargar ya que necesitamos el ID
        await loadPoliticas();
      }
      setShowForm(false);
      setSelectedPolitica(null);
      setFormMode('new');
    } catch (err) {

      showNotification(`Error al guardar la política: ${err.message}`, 'error');
    } finally {
      setLoading(false);
    }
  }, [formMode, selectedPolitica, showNotification, loadPoliticas]);

  // ===== FUNCIONES DE GESTIÓN DE RELOJES =====
  
  const handleNewReloj = useCallback(async () => {




    
    // Permitir crear reloj si:
    // 1. Hay una política seleccionada, O
    // 2. El formulario de política está abierto (modo new o edit)
    if (!selectedPolitica && !showForm) {
      setNotification({
        type: 'error',
        message: 'Debe seleccionar una política primero o abrir el formulario de política para crear un reloj'
      });
      return;
    }
    
    // Determinar qué política usar
    const politicaToUse = selectedPolitica;
    const politicaId = politicaToUse?.id;
    
    // Cargar categorías de la política
    if (politicaId) {
      await loadCategoriasPolitica(politicaId);
    } else {
      setCategoriasSeleccionadas([]);
    }
    
    setSelectedReloj(null);
    setRelojFormMode('new');
    
    // Iniciar con reloj vacío - sin eventos automáticos
    setRelojEvents([]);

    
    setShowRelojForm(true); // Mostrar el RelojForm modal

  }, [selectedPolitica, showForm, formMode, loadCategoriasPolitica]);

  const handleEditReloj = useCallback(async (reloj) => {


    setSelectedReloj(reloj);
    setRelojFormMode('edit');
    
    // Cargar categorías de la política asociada al reloj
    const politicaId = reloj.politica_id || reloj.politica?.id;
    if (politicaId) {
      await loadCategoriasPolitica(politicaId);
    } else {
      // Si no hay política en el reloj, usar la política seleccionada
      const politicaIdFromSelected = selectedPolitica?.id;
      if (politicaIdFromSelected) {
        await loadCategoriasPolitica(politicaIdFromSelected);
      } else {
        setCategoriasSeleccionadas([]);
      }
    }
    
    // Mapear eventos del backend al formato del frontend
    const eventosMapeados = reloj.eventos ? reloj.eventos.map(evento => ({
      id: evento.id,
      consecutivo: evento.numero,
      offset: evento.offset_value,
      desdeEtm: evento.desde_etm,
      desdeCorte: evento.desde_corte,
      offsetFinal: evento.offset_final,
      tipo: evento.tipo,
      categoria: evento.categoria,
      descripcion: evento.descripcion,
      duracion: evento.duracion,
      numeroCancion: evento.numero_cancion,
      sinCategorias: evento.sin_categorias,
      idMedia: evento.id_media,
      categoriaMedia: evento.categoria_media,
      tipoETM: evento.tipo_etm,
      accionETM: evento.tipo_etm,  // La acción ETM se guarda en tipo_etm
      orden: evento.orden
    })) : [];
    
    setRelojEvents(eventosMapeados);

    setShowRelojForm(true);

  }, [selectedPolitica, loadCategoriasPolitica]);

  const handleViewReloj = useCallback((reloj) => {


    setSelectedReloj(reloj);
    setRelojFormMode('view');
    
    // Mapear eventos del backend al formato del frontend
    const eventosMapeados = reloj.eventos ? reloj.eventos.map(evento => ({
      id: evento.id,
      consecutivo: evento.numero,
      offset: evento.offset_value,
      desdeEtm: evento.desde_etm,
      desdeCorte: evento.desde_corte,
      offsetFinal: evento.offset_final,
      tipo: evento.tipo,
      categoria: evento.categoria,
      descripcion: evento.descripcion,
      duracion: evento.duracion,
      numeroCancion: evento.numero_cancion,
      sinCategorias: evento.sin_categorias,
      idMedia: evento.id_media,
      categoriaMedia: evento.categoria_media,
      tipoETM: evento.tipo_etm,
      accionETM: evento.tipo_etm,  // La acción ETM se guarda en tipo_etm
      orden: evento.orden
    })) : [];
    
    setRelojEvents(eventosMapeados);

    setShowRelojForm(true);
  }, []);

  const handleDeleteReloj = useCallback(async (id) => {
    const reloj = relojes.find(r => r.id === id);
    if (window.confirm(`¿Está seguro de eliminar el reloj "${reloj?.nombre}"?`)) {
      try {
        setLoading(true);
        await relojesApi.delete(id);
        // Si se eliminó el reloj seleccionado, limpiar la selección
        if (selectedRelojInTable?.id === id) {
          setSelectedRelojInTable(null);
        }
        setNotification({ type: 'success', message: 'Reloj eliminado exitosamente' });
        // Actualizar estado local en lugar de recargar todo
        if (selectedPolitica) {
          setRelojes(prev => prev.filter(r => r.id !== id));
          if (selectedRelojInTable?.id === id) {
            setSelectedRelojInTable(null);
          }
        }
      } catch (err) {

        setNotification({ type: 'error', message: 'Error al eliminar el reloj' });
      } finally {
        setLoading(false);
      }
    }
  }, [relojes, selectedPolitica, selectedRelojInTable, showNotification]);

  const handleSaveReloj = useCallback(async (relojData, politicaFromForm = null) => {





    
    try {
      setLoading(true);
      
      // Usar la política del formulario si está disponible, sino usar selectedPolitica
      const politicaToUse = politicaFromForm || selectedPolitica;

      
      let relojId;
      
      if (relojFormMode === 'new') {

        // Crear nuevo reloj
        if (!politicaToUse || !politicaToUse.id) {
          const errorMsg = 'No se ha seleccionado una política válida. Por favor, guarde la política primero antes de crear el reloj.';

          setNotification({ type: 'error', message: errorMsg });
          return;
        }
        



        
        const newReloj = await relojesApi.create(politicaToUse.id, relojData);

        relojId = newReloj.id;
        setNotification({ type: 'success', message: 'Reloj creado exitosamente' });
      } else {
        // Actualizar reloj existente
        await relojesApi.update(selectedReloj.id, relojData);
        relojId = selectedReloj.id;
        
        // Eliminar eventos existentes del reloj
        const eventosExistentes = await eventosRelojApi.getByReloj(relojId);
        for (const evento of eventosExistentes) {
          try {
            await eventosRelojApi.delete(evento.id);
          } catch (deleteError) {

          }
        }
        
        setNotification({ type: 'success', message: 'Reloj actualizado exitosamente' });
      }
      
      // Guardar eventos en la base de datos
      if (relojEvents.length > 0) {
        for (const evento of relojEvents) {
          try {
            // Mapear campos del frontend al backend
            const eventoData = {
              numero: evento.numero || evento.consecutivo,
              offset_value: evento.offset || evento.offset_value || '00:00:00',
              desde_etm: evento.desdeEtm || evento.desde_etm || '00:00:00',
              desde_corte: evento.desdeCorte || evento.desde_corte || '00:00:00',
              offset_final: evento.offsetFinal || evento.offset_final || '00:00:00',
              tipo: evento.tipo || '1',
              categoria: evento.categoria,
              descripcion: evento.descripcion,
              duracion: evento.duracion,
numero_cancion: evento.numeroCancion || evento.numero_cancion || '-',
              sin_categorias: evento.sinCategorias || evento.sin_categorias || '-',
              id_media: evento.idMedia || evento.id_media,
              categoria_media: evento.categoriaMedia || evento.categoria_media,
              tipo_etm: evento.accionETM || evento.tipoETM || evento.tipo_etm,  // Guardar accionETM en tipo_etm
              orden: evento.orden || 0
            };
            
            await eventosRelojApi.create(relojId, eventoData);
          } catch (eventoError) {


            
            const errorMessage = formatErrorMessage(eventoError, 'Error al guardar evento');
            setNotification({ type: 'error', message: `Error al guardar evento: ${errorMessage}` });
          }
        }
        setNotification({ type: 'success', message: `${relojEvents.length} eventos guardados exitosamente` });
      }
      
      // Recargar relojes de la política actual primero

      if (selectedPolitica) {
        const relojesData = await relojesApi.getByPolitica(selectedPolitica.id);
        setRelojes(relojesData);

      }
      
      // Limpiar estados después de recargar

      setShowRelojForm(false);
      setSelectedReloj(null);
      setRelojFormMode('new');
      setRelojEvents([]);
      setSelectedRelojInTable(null); // Limpiar selección de tabla

    } catch (err) {


      
      const errorMessage = formatErrorMessage(err, 'Error al guardar el reloj');
      setNotification({ type: 'error', message: errorMessage });
    } finally {
      setLoading(false);
    }
  }, [relojFormMode, selectedPolitica, selectedReloj, relojEvents, formatErrorMessage, showNotification]);

  const handleDeleteDiaModelo = useCallback(async (diaModelo) => {
    if (window.confirm('¿Está seguro de eliminar este día modelo?')) {
      try {
        setLoading(true);
        await diasModeloApi.delete(diaModelo.id);
        
        // Actualizar la lista local
        setDiasModelo(prev => prev.filter(d => d.id !== diaModelo.id));
        
        setNotification({
          type: 'success',
          message: 'Día modelo eliminado correctamente'
        });
      } catch (err) {

        const errorMessage = err.response?.data?.detail || err.message || 'Error al eliminar el día modelo';
        setNotification({
          type: 'error',
          message: errorMessage
        });
      } finally {
        setLoading(false);
      }
    }
  }, [showNotification]);

  const handleSaveDiaModelo = useCallback(async (diaModeloData, diaModeloId = null) => {
    try {
      setLoading(true);
      
      if (diaModeloId === null) {
        // Crear nuevo día modelo
        if (!selectedPolitica || !selectedPolitica.id) {
          throw new Error('No se ha seleccionado una política válida');
        }
        
        const newDiaModelo = await diasModeloApi.create(selectedPolitica.id, diaModeloData);
        
        // Actualizar la lista de días modelo en el estado local
        setDiasModelo(prev => [...prev, newDiaModelo]);
        setNotification({ type: 'success', message: 'Día modelo creado exitosamente' });
      } else {
        // Actualizar día modelo existente
        const updatedDiaModelo = await diasModeloApi.update(diaModeloId, diaModeloData);
        
        // Actualizar la lista de días modelo en el estado local
        setDiasModelo(prev => prev.map(d => 
          d.id === diaModeloId ? updatedDiaModelo : d
        ));
        setNotification({ type: 'success', message: 'Día modelo actualizado exitosamente' });
      }
      
      // Limpiar estados
      setShowDiaModeloForm(false);
      setSelectedDiaModelo(null);
      setDiaModeloFormMode('new');
    } catch (err) {

      
      const errorMessage = formatErrorMessage(err, 'Error al guardar el día modelo');
      setNotification({ type: 'error', message: errorMessage });
    } finally {
      setLoading(false);
    }
  }, [selectedPolitica, formatErrorMessage, showNotification]);

  // Funciones helper deben definirse antes de los handlers que las usan
  // parseTimeSafely debe definirse primero porque otras funciones lo usan
  const parseTimeSafely = useCallback((timeString) => {
    if (!timeString || typeof timeString !== 'string') {
      return [0, 0, 0];
    }
    
    // Verificar que tenga el formato correcto (HH:MM:SS)
    if (!/^\d{1,2}:\d{1,2}:\d{1,2}$/.test(timeString)) {
      return [0, 0, 0];
    }
    
    try {
      const parts = timeString.split(':');
      const hours = parseInt(parts[0], 10) || 0;
      const minutes = parseInt(parts[1], 10) || 0;
      const seconds = parseInt(parts[2], 10) || 0;
      
      return [hours, minutes, seconds];
    } catch (error) {

      return [0, 0, 0];
    }
  }, []);

  const getDefaultDuration = useCallback((eventType) => {
    const defaultDurations = {
      'corte-comercial': '00:03:00', // 3 minutos por defecto
      'canciones': '00:04:00',       // 4 minutos por defecto
      'nota-operador': '00:00:30',   // 30 segundos por defecto
      'vacío': '00:00:00',           // 0 segundos
      'cartucho-fijo': '00:01:00',   // 1 minuto por defecto
      'exact-time-marker': '00:00:00', // 0 segundos
      'comando-automatizacion': '00:00:10', // 10 segundos por defecto
      'twofer': '00:00:20',          // 20 segundos por defecto
      'caracteristica-especifica': '00:02:00' // 2 minutos por defecto
    };
    return defaultDurations[eventType] || '00:01:00';
  }, []);

  const generateConsecutivo = useCallback(() => {
    // Generar el siguiente número consecutivo basado en los eventos actuales
    const lastEventNumber = relojEvents.length;
    return (lastEventNumber + 1).toString().padStart(3, '0');
  }, [relojEvents]);

  const calculateLastEventOffset = useCallback(() => {
    // Calcular el offset del último evento basado en los eventos actuales
    if (relojEvents.length === 0) {
      return '00:00:00';
    }
    
    const lastEvent = relojEvents[relojEvents.length - 1];
    const lastOffset = lastEvent.offsetFinal || lastEvent.offset || '00:00:00';
    
    // Verificar que lastOffset sea una cadena válida
    if (!lastOffset || typeof lastOffset !== 'string') {
      return '00:00:00';
    }
    
    // Verificar que tenga el formato correcto (HH:MM:SS)
    if (!/^\d{2}:\d{2}:\d{2}$/.test(lastOffset)) {
      return '00:00:00';
    }
    
    try {
      // Convertir el offset a segundos, sumar 1 segundo y volver a formato
      const [hours, minutes, seconds] = parseTimeSafely(lastOffset);
      const totalSeconds = hours * 3600 + minutes * 60 + seconds + 1;
      
      const newHours = Math.floor(totalSeconds / 3600);
      const newMinutes = Math.floor((totalSeconds % 3600) / 60);
      const newSeconds = totalSeconds % 60;
      
      return `${newHours.toString().padStart(2, '0')}:${newMinutes.toString().padStart(2, '0')}:${newSeconds.toString().padStart(2, '0')}`;
    } catch (error) {

      return '00:00:00';
    }
  }, [relojEvents, parseTimeSafely]);

  // Funciones helper adicionales deben definirse antes de los handlers que las usan
  const getEventTypeNumber = useCallback((eventType) => {
    const typeNumbers = {
      'corte-comercial': '2',
      'canciones': '1',
      'nota-operador': '3',
      'vacío': '4',
      'cartucho-fijo': '5',
      'exact-time-marker': '6',
      'comando-automatizacion': '8',
      'twofer': '9',
      'caracteristica-especifica': '10'
    };
    return typeNumbers[eventType] || '1';
  }, []);

  const getEventCategory = useCallback((eventType) => {
    const categories = {
      'corte-comercial': 'Corte Comercial',
      'canciones': 'Canciones',
      'nota-operador': 'Nota Operador',
      'vacío': 'Vacío',
      'cartucho-fijo': 'Cartucho Fijo',
      'exact-time-marker': 'ETM',
    };
    return categories[eventType] || 'Otros';
  }, []);

  const getNumeroCancion = useCallback((eventType) => {
    if (eventType === 'canciones') {
      return (relojEvents.filter(e => e.categoria === 'Canciones').length + 1).toString().padStart(3, '0');
    }
    return '-';
  }, [relojEvents]);

  // addEventToReloj debe definirse antes de handlePredefinedEventClick porque lo usa
  const addEventToReloj = useCallback((newEvent) => {


    
    setRelojEvents(prev => {
      // Calcular el offset correcto para el nuevo evento
      let offsetInicial = '00:00:00';
      if (prev.length > 0) {
        const lastEvent = prev[prev.length - 1];
        offsetInicial = lastEvent.offsetFinal || lastEvent.offset || '00:00:00';
      }
      
      // Calcular la duración en segundos
      let durationSeconds = 0;
      if (typeof newEvent.duracion === 'number') {
        durationSeconds = newEvent.duracion;
      } else if (typeof newEvent.duracion === 'string' && newEvent.duracion.includes(':')) {
        const [hours, minutes, seconds] = newEvent.duracion.split(':').map(Number);
        durationSeconds = hours * 3600 + minutes * 60 + seconds;
      } else {
        durationSeconds = parseInt(newEvent.duracion) || 0;
      }
      
      // Calcular el offset final
      const [offsetHours, offsetMinutes, offsetSeconds] = offsetInicial.split(':').map(Number);
      const offsetTotalSeconds = offsetHours * 3600 + offsetMinutes * 60 + offsetSeconds;
      const finalTotalSeconds = offsetTotalSeconds + durationSeconds;
      
      const finalHours = Math.floor(finalTotalSeconds / 3600);
      const finalMinutes = Math.floor((finalTotalSeconds % 3600) / 60);
      const finalSeconds = finalTotalSeconds % 60;
      
      const offsetFinal = `${finalHours.toString().padStart(2, '0')}:${finalMinutes.toString().padStart(2, '0')}:${finalSeconds.toString().padStart(2, '0')}`;
      
      // Crear el evento con los offsets correctos
      const eventWithCorrectOffsets = {
        ...newEvent,
        offset: offsetInicial,
        desdeETM: offsetInicial,
        desdeCorte: offsetInicial,
        offsetFinal: offsetFinal
      };
      
      const newState = [...prev, eventWithCorrectOffsets];

      return newState;
    });

  }, []); // No necesita relojEvents en dependencias porque usa la forma funcional de setState

  const handleEventClick = useCallback((eventType, eventName) => {
    setSelectedEventType({ type: eventType, name: eventName });
    
    // Calcular el offset basado en el último evento
    const lastEventOffset = calculateLastEventOffset();
    
    setEventFormData({
      consecutivo: generateConsecutivo(), // El siguiente número consecutivo de la tabla
      offset: lastEventOffset,
      duracion: getDefaultDuration(eventType),
      descripcion: eventName
    });
    
    setShowEventForm(true);
  }, [calculateLastEventOffset, generateConsecutivo, getDefaultDuration]);

  const handleCategoryClick = useCallback((eventType, categoryName) => {
    setSelectedEventType({ type: eventType, name: categoryName });
    
    // Calcular el offset basado en el último evento
    const lastEventOffset = calculateLastEventOffset();
    
    setEventFormData({
      consecutivo: generateConsecutivo(), // El siguiente número consecutivo de la tabla
      offset: lastEventOffset,
      duracion: getDefaultDuration(eventType),
      descripcion: categoryName
    });
    
    setShowEventForm(true);
  }, [calculateLastEventOffset, generateConsecutivo, getDefaultDuration]);

  const handlePredefinedEventClick = useCallback((eventType, eventName, param3 = []) => {
    // Configuración específica para eventos de cartucho fijo
    let categoria = getEventCategory(eventType);
    let idMedia = '';
    let categoriaEspecifica = '';
    let duracion = getDefaultDuration(eventType);
    // Si es ETM, param3 puede ser la acción; si es corte/vacío, param3 es la lista de cortes
    const etmActionParam = eventType === 'exact-time-marker' ? (param3 || 'espera') : undefined;
    const cortes = eventType === 'corte-comercial' || eventType === 'vacío' ? (param3 || []) : [];
    
    // Configuración específica para cortes comerciales y vacíos
    if (eventType === 'corte-comercial' || eventType === 'vacío') {
      // Buscar el corte en la lista de cortes cargados
      const corteEncontrado = cortes.find(corte => corte.nombre === eventName);
      if (corteEncontrado) {
        duracion = corteEncontrado.duracion; // Usar la duración real del corte


      } else {

      }
    }
    
    if (eventType === 'cartucho-fijo') {
      // Mapear nombres de eventos a categorías específicas
      const cartuchoMapping = {
        'HIMNO NACIONAL': { categoria: 'HIMNO', idMedia: 'HIMNO001' },
        'HORA EXACTA': { categoria: 'HORA_EXACTA', idMedia: 'HORA001' },
        'IDENTIFICACION': { categoria: 'IDENTIFICACION', idMedia: 'ID001' },
        'LINEA INOLVIDABLE': { categoria: 'LINEA_INOLVIDABLE', idMedia: 'LINEA001' },
        'CARTUCHO_1': { categoria: 'CARTUCHO_1', idMedia: 'CART1' },
        'CARTUCHO_2': { categoria: 'CARTUCHO_2', idMedia: 'CART2' }
      };
      
      const mapping = cartuchoMapping[eventName];
      if (mapping) {
        categoria = mapping.categoria;
        idMedia = mapping.idMedia;
        categoriaEspecifica = mapping.categoria;
      }
    }
    
    // Configuración específica para eventos de Exact Time Marker
    let tipoETM = '';
    if (eventType === 'exact-time-marker') {
      // Mapear nombres de eventos a tipos ETM específicos
      const etmMapping = {
        'ETM_00': 'ETM_00',
        'ETM_15': 'ETM_15',
        'ETM_30': 'ETM_30',
        'ETM_45': 'ETM_45'
      };
      
      tipoETM = etmMapping[eventName] || eventName;
    }
    
    
    
    
    
    // Añadir directamente al reloj
    const newEvent = {
      id: Date.now(), // Usar timestamp para evitar conflictos de ID
      numero: generateConsecutivo(),
      tipo: getEventTypeNumber(eventType),
      categoria: categoria,
      descripcion: eventName,
      duracion: duracion, // Usar la duración calculada
      numeroCancion: getNumeroCancion(eventType),
      sinCategorias: '-',
      // Campos adicionales para Cartucho Fijo
      ...(eventType === 'cartucho-fijo' && {
        idMedia: idMedia,
        categoriaEspecifica: categoriaEspecifica
      }),
      // Campo adicional para Exact Time Marker
      ...(eventType === 'exact-time-marker' && {
        tipoETM: tipoETM,
        accionETM: etmActionParam || 'espera'
      }),
    };
    
    // Añadir el evento a la tabla (addEventToReloj calculará los offsets automáticamente)
    addEventToReloj(newEvent);
    

    
    // Mostrar notificación de éxito
    setNotification({
      type: 'success',
      message: `Evento "${eventName}" añadido al reloj`
    });
  }, [relojEvents, getEventCategory, getDefaultDuration, getEventTypeNumber, getNumeroCancion, addEventToReloj, generateConsecutivo]);

  // ===== FUNCIONES DE GESTIÓN DE EVENTOS =====

  const deleteEventFromReloj = useCallback(async (eventId) => {
    if (window.confirm('¿Está seguro de eliminar este evento?')) {
      try {
        // Si el evento tiene un ID válido (no es temporal), eliminarlo de la BD
        if (eventId && typeof eventId === 'number') {

          await eventosRelojApi.delete(eventId);

          
          // Recargar relojes para actualizar la vista de lista
          if (selectedPolitica) {
            const relojesData = await relojesApi.getByPolitica(selectedPolitica.id);
            setRelojes(relojesData);

          }
        }
        
        // Eliminar del estado local
        setRelojEvents(prev => prev.filter(event => event.id !== eventId));
        
        setNotification({
          type: 'success',
          message: 'Evento eliminado correctamente'
        });
      } catch (error) {

        setNotification({
          type: 'error',
          message: 'Error al eliminar el evento'
        });
      }
    }
  }, [selectedPolitica, showNotification]);

  // Función para verificar si hay cambios sin guardar en el reloj en edición - Memoizada
  const hasUnsavedChanges = useCallback(() => {
    if (!selectedReloj) return false;
    
    // Si es un reloj nuevo, cualquier evento es un cambio
    if (relojFormMode === 'new') {
      return relojEvents.length > 0;
    }
    
    // Para relojes existentes, comparar con los eventos originales
    const originalEvents = selectedReloj.eventos || [];
    
    if (originalEvents.length !== relojEvents.length) return true;
    
    return originalEvents.some((event, index) => {
      const currentEvent = relojEvents[index];
      return !currentEvent || JSON.stringify(event) !== JSON.stringify(currentEvent);
    });
  }, [selectedReloj, relojFormMode, relojEvents]);

  const calculateTotalDuration = useCallback(() => {
    let totalSeconds = 0;
    
    relojEvents.forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    
    return `${hours}' ${minutes.toString().padStart(2, '0')}" ${seconds.toString().padStart(2, '0')}"`;
  }, [relojEvents, parseTimeSafely]);

  const calculateCategoryDuration = useCallback((category) => {
    let totalSeconds = 0;
    
    relojEvents.filter(event => event.categoria === category).forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    return `${minutes}' ${seconds.toString().padStart(2, '0')}"`;
  }, [relojEvents, parseTimeSafely]);

  const calculateOtherDuration = useCallback(() => {
    let totalSeconds = 0;
    
    relojEvents.filter(event => !['Corte Comercial', 'Canciones', 'Nota Operador'].includes(event.categoria)).forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    return `${minutes}' ${seconds.toString().padStart(2, '0')}"`;
  }, [relojEvents, parseTimeSafely]);

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center h-64 space-y-4">
        <div className="relative">
          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
        <div className="text-gray-600 font-medium">Cargando políticas...</div>
        <div className="text-sm text-gray-500">Esto puede tomar unos segundos</div>
      </div>
    );
  }

  return (
    <>
      {/* Notification Component */}
      {notification && (
        <div className={`fixed top-4 right-4 z-[10000] p-4 rounded-xl shadow-2xl max-w-md transition-all duration-300 border-2 ${
          notification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border-green-300 text-green-800'
            : 'bg-gradient-to-r from-red-50 to-pink-50 border-red-300 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              {notification.type === 'success' ? (
                <div className="p-2 bg-gradient-to-br from-green-100 to-green-200 rounded-lg shadow-md">
                  <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              ) : (
                <div className="p-2 bg-gradient-to-br from-red-100 to-red-200 rounded-lg shadow-md">
                  <svg className="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              )}
              <span className="font-bold">{notification.message}</span>
            </div>
            <button
              onClick={() => setNotification(null)}
              className="ml-4 text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-lg p-1 transition-all duration-200"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
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

      <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 mb-6 sticky top-0 z-10 overflow-hidden">
        {/* Header Moderno */}
        <div className="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
          <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="flex items-center space-x-4">
              <div className="w-14 h-14 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                <svg className="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                </svg>
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white mb-1">Políticas de Programación</h1>
                <p className="text-blue-100 text-sm">Administra las políticas de programación musical</p>
              </div>
            </div>
            
            {/* Action Buttons */}
            <div className="flex flex-wrap gap-3">
              <button
                onClick={handleNew}
                className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nueva Política</span>
              </button>
              

              
              <button
                onClick={handleToggleActive}
                className={`px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 ${
                  showOnlyActive 
                    ? 'bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white border border-white/30' 
                    : 'bg-white/10 hover:bg-white/20 backdrop-blur-sm text-white border border-white/20'
                }`}
              >
                {showOnlyActive ? (
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                ) : (
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                )}
                <span>{showOnlyActive ? 'Ver Todas' : 'Solo Habilitadas'}</span>
              </button>
            </div>
          </div>
          {/* Efecto de partículas decorativas */}
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
          <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
        </div>

            {/* Search and View Toggle */}
            <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
              <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div className="relative max-w-md flex-1">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                  </div>
                  <input
                    type="text"
                    placeholder="Buscar políticas..."
                    value={searchTerm || ''}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="block w-full pl-12 pr-12 py-3.5 border-2 border-gray-300 rounded-xl leading-5 bg-white text-black placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-md hover:border-gray-400 transition-all duration-200"
                  />
                  {searchTerm && (
                    <button
                      onClick={() => setSearchTerm('')}
                      className="absolute inset-y-0 right-0 pr-4 flex items-center hover:bg-gray-100 rounded-r-xl transition-colors"
                    >
                      <svg className="h-5 w-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  )}
                </div>
                
                {/* View Mode Toggle */}
                <div className="flex items-center space-x-2 bg-white border-2 border-gray-300 rounded-xl p-1 shadow-md">
                  <button
                    onClick={() => setViewMode('tarjetas')}
                    className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all duration-200 ${
                      viewMode === 'tarjetas'
                        ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    Tarjetas
                  </button>
                  <button
                    onClick={() => setViewMode('grid')}
                    className={`px-4 py-2 rounded-lg text-sm font-semibold transition-all duration-200 ${
                      viewMode === 'grid'
                        ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    Grid
                  </button>
                </div>
              </div>
            </div>

        {/* Content */}
        {viewMode === 'tarjetas' ? (
          <div className="p-6 max-h-[calc(100vh-300px)] overflow-y-auto allow-scroll">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {filteredPoliticas.map((politica) => (
                <div key={politica.id} className="group bg-white border border-gray-200/50 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 hover:scale-105">
                  <div className="p-8">
                    {/* Header con gradiente */}
                    <div className="flex items-start justify-between mb-6">
                      <div className="flex items-center space-x-4">
                        <div className={`w-4 h-4 rounded-full shadow-lg ${politica.habilitada ? 'bg-gradient-to-r from-green-400 to-green-600' : 'bg-gradient-to-r from-red-400 to-red-600'}`}></div>
                        <div>
                          <h3 className="text-xl font-bold text-gray-900 group-hover:text-purple-700 transition-colors">{politica.nombre}</h3>
                          <p className="text-sm text-gray-500 mt-1">Política de Programación</p>
                        </div>
                      </div>
                      <div className="flex space-x-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <button
                          onClick={() => handleView(politica)}
                          className="p-3 text-blue-600 hover:text-white bg-blue-50 hover:bg-gradient-to-r hover:from-blue-500 hover:to-blue-600 rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:scale-110"
                          title="Ver detalles"
                        >
                          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleEdit(politica)}
                          className="p-3 text-green-600 hover:text-white bg-green-50 hover:bg-gradient-to-r hover:from-green-500 hover:to-green-600 rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:scale-110"
                          title="Editar"
                        >
                          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(politica.id)}
                          className="p-3 text-red-600 hover:text-white bg-red-50 hover:bg-gradient-to-r hover:from-red-500 hover:to-red-600 rounded-xl transition-all duration-300 shadow-md hover:shadow-lg transform hover:scale-110"
                          title="Eliminar"
                        >
                          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </div>
                    
                    {/* Contenido principal con diseño moderno */}
                    <div className="space-y-6">
                      {/* Información principal */}
                      <div className="bg-gradient-to-r from-gray-50 to-blue-50 rounded-xl p-4 border border-gray-100">
                        <div className="grid grid-cols-1 gap-4">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-3">
                              <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                              <span className="text-sm font-medium text-gray-600">Clave</span>
                            </div>
                            <span className="font-bold text-gray-900 bg-white px-3 py-1 rounded-lg shadow-sm">{politica.clave}</span>
                          </div>
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-3">
                              <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                              <span className="text-sm font-medium text-gray-600">Difusora</span>
                            </div>
                            <span className="font-semibold text-purple-700 bg-purple-50 px-3 py-1 rounded-lg">{politica.difusora}</span>
                          </div>
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-3">
                              <div className={`w-2 h-2 rounded-full ${politica.habilitada ? 'bg-green-500' : 'bg-red-500'}`}></div>
                              <span className="text-sm font-medium text-gray-600">Estado</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className={`w-3 h-3 rounded-full ${politica.habilitada ? 'bg-green-500' : 'bg-red-500'}`}></div>
                              <span className={`font-semibold ${politica.habilitada ? 'text-green-700' : 'text-red-700'}`}>
                                {politica.habilitada ? 'Activa' : 'Inactiva'}
                              </span>
                            </div>
                          </div>
                        </div>
                      </div>
                      
                      {/* Descripción */}
                      {politica.descripcion && (
                        <div className="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-xl p-4 border border-yellow-100">
                          <div className="flex items-start space-x-3">
                            <div className="w-2 h-2 bg-yellow-500 rounded-full mt-2"></div>
                            <div>
                              <span className="text-sm font-medium text-gray-600 block">Descripción</span>
                              <p className="mt-1 text-sm text-gray-700 leading-relaxed">{politica.descripcion}</p>
                            </div>
                          </div>
                        </div>
                      )}
                      
                      {/* Fechas */}
                      <div className="bg-gradient-to-r from-gray-50 to-slate-50 rounded-xl p-4 border border-gray-100">
                        <div className="grid grid-cols-2 gap-4 text-xs">
                          <div className="flex items-center space-x-2">
                            <div className="w-2 h-2 bg-gray-400 rounded-full"></div>
                            <span className="text-gray-500">Alta:</span>
                            <span className="font-medium text-gray-700">
                              {politica.alta || 'N/A'}
                            </span>
                          </div>
                          <div className="flex items-center space-x-2">
                            <div className="w-2 h-2 bg-gray-400 rounded-full"></div>
                            <span className="text-gray-500">Modificación:</span>
                            <span className="font-medium text-gray-700">
                              {politica.modificacion || 'N/A'}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div className="overflow-x-auto bg-white rounded-xl shadow-lg border border-gray-200">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Estado
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Clave
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Difusora
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Nombre
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Descripción
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-bold text-gray-700 uppercase tracking-wider w-40 border-l-2 border-gray-300 shadow-lg sticky right-0 bg-gradient-to-r from-gray-100 to-gray-50">
                    Acciones
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredPoliticas.map((politica, index) => (
                  <tr key={politica.id} className={`hover:bg-blue-50/50 transition-all duration-200 group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm ${
                        politica.habilitada 
                          ? 'bg-gradient-to-r from-green-100 to-green-50 text-green-800 border-green-300' 
                          : 'bg-gradient-to-r from-red-100 to-red-50 text-red-800 border-red-300'
                      }`}>
                        {politica.habilitada ? 'Habilitada' : 'Deshabilitada'}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                      {politica.clave}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                      {politica.difusora}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                      {politica.nombre}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                      <div className="max-w-48 truncate" title={politica.descripcion}>
                        {politica.descripcion || 'Sin descripción'}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium border-l-2 border-gray-300 shadow-lg sticky right-0 bg-white group-hover:bg-blue-50/50">
                      <div className="flex justify-center space-x-2">
                        <button
                          onClick={() => handleView(politica)}
                          className="p-2.5 text-blue-600 hover:text-white bg-blue-50 hover:bg-gradient-to-r hover:from-blue-500 hover:to-blue-600 rounded-lg transition-all duration-200 shadow-md hover:shadow-lg transform hover:scale-110 border border-blue-200"
                          title="Ver detalles"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleEdit(politica)}
                          className="p-2.5 text-yellow-600 hover:text-white bg-yellow-50 hover:bg-gradient-to-r hover:from-yellow-500 hover:to-yellow-600 rounded-lg transition-all duration-200 shadow-md hover:shadow-lg transform hover:scale-110 border border-yellow-200"
                          title="Editar"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(politica.id)}
                          className="p-2.5 text-red-600 hover:text-white bg-red-50 hover:bg-gradient-to-r hover:from-red-500 hover:to-red-600 rounded-lg transition-all duration-200 shadow-md hover:shadow-lg transform hover:scale-110 border border-red-200"
                          title="Eliminar"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
        
            {/* Empty State */}
            {filteredPoliticas.length === 0 && !loading && (
              <div className="text-center py-20 px-6 bg-white rounded-xl shadow-lg border border-gray-200">
                <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
                  <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" className="w-12 h-12 text-gray-400">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                  </svg>
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">
                  {error ? 'Error al cargar políticas' :
                   searchTerm ? 'No se encontraron políticas' : 
                   showOnlyActive ? 'No hay políticas habilitadas' : 
                   'No hay políticas registradas'}
                </h3>
                <p className="text-gray-600 mb-8 max-w-md mx-auto text-base">
                  {error ? 
                    `Error: ${error.message || error}. Intenta recargar la página.` :
                    searchTerm ? 
                    `No se encontraron políticas que coincidan con "${searchTerm}". Intenta con otros términos de búsqueda.` : 
                    showOnlyActive ? 
                    'No hay políticas habilitadas en el sistema. Puedes ver todas las políticas o crear una nueva.' : 
                    'Comienza agregando tu primera política de programación al sistema.'
                  }
                </p>
                {!searchTerm && !showOnlyActive && !error && (
                  <button
                    onClick={handleNew}
                    className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold shadow-lg hover:shadow-xl transform hover:scale-105"
                  >
                    Crear primera política
                  </button>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Form Modal */}
      {showForm && (
              <PoliticaForm
                politica={selectedPolitica}
                mode={formMode}
                onSave={handleSave}
                onNewReloj={handleNewReloj}
                onCancel={() => {
                  setShowForm(false);
                  setSelectedPolitica(null);
                  setFormMode('new');
                }}
                relojes={relojes}
                categoriasSeleccionadas={categoriasSeleccionadas}
                setCategoriasSeleccionadas={setCategoriasSeleccionadas}
                onCategoriasSaved={handleCategoriasSaved}
                activeTab={politicaFormActiveTab}
                setActiveTab={setPoliticaFormActiveTab}
                diasModelo={diasModelo}
                setDiasModelo={setDiasModelo}
                setRelojes={setRelojes}
                selectedRelojInTable={selectedRelojInTable}
                setSelectedRelojInTable={setSelectedRelojInTable}
                handleNewReloj={handleNewReloj}
                handleEditReloj={handleEditReloj}
                handleNewDiaModelo={handleNewDiaModelo}
                handleEditDiaModelo={handleEditDiaModelo}
                handleViewDiaModelo={handleViewDiaModelo}
                handleDeleteDiaModelo={handleDeleteDiaModelo}
                handleSaveDiaModelo={handleSaveDiaModelo}
                handleToggleDiaModeloHabilitado={handleToggleDiaModeloHabilitado}
                handleViewReloj={handleViewReloj}
                handleDeleteReloj={handleDeleteReloj}
                handleToggleRelojHabilitado={handleToggleRelojHabilitado}
                getEventColor={getEventColor}
                relojEvents={relojEvents}
                calculateTotalDuration={calculateTotalDuration}
                getSelectedRelojEvents={getSelectedRelojEvents}
                getSelectedRelojDuration={getSelectedRelojDuration}
                politicas={politicas}
                handleNewRegla={handleNewRegla}
                reglasPolitica={reglasPolitica}
                loadingReglas={loadingReglas}
                loadReglasPolitica={loadReglasPolitica}
                handleToggleReglaHabilitada={handleToggleReglaHabilitada}
              />
      )}

      {/* Reloj Form Modal */}
      {showRelojForm && (
              <RelojForm
                reloj={selectedReloj}
                mode={relojFormMode}
                relojEvents={relojEvents}
                politica={selectedPolitica}
                categoriasSeleccionadas={categoriasSeleccionadas}
                parseTimeSafely={parseTimeSafely}
                getEventTypeNumber={getEventTypeNumber}
                getEventCategory={getEventCategory}
                getNumeroCancion={getNumeroCancion}
                calculateTotalDuration={calculateTotalDuration}
                calculateCategoryDuration={calculateCategoryDuration}
                calculateOtherDuration={calculateOtherDuration}
                addEventToReloj={addEventToReloj}
                deleteEventFromReloj={deleteEventFromReloj}
                hasUnsavedChanges={hasUnsavedChanges}
                getSelectedRelojEvents={getSelectedRelojEvents}
                getSelectedRelojDuration={getSelectedRelojDuration}
                getCategoryStats={getCategoryStats}
                formatDuration={formatDuration}
                expandedCategories={expandedCategories}
                toggleCategoryExpansion={toggleCategoryExpansion}
                sortConfig={sortConfig}
                sortStats={sortStats}
                getSortedCategoryStats={getSortedCategoryStats}
                onEventClick={handleEventClick}
                onCategoryClick={handleCategoryClick}
                onPredefinedEventClick={handlePredefinedEventClick}
                onSave={handleSaveReloj}
                onCancel={() => {
                  setShowRelojForm(false);
                  setSelectedReloj(null);
                  setRelojFormMode('new');
                  setRelojEvents([]); // Limpiar eventos al cancelar
                }}
              />
      )}

      {/* Event Form Modal */}
      {showEventForm && (
              <EventForm
                eventType={selectedEventType}
                formData={eventFormData}
                relojEvents={relojEvents}
                parseTimeSafely={parseTimeSafely}
                addEventToReloj={addEventToReloj}
                getEventTypeNumber={getEventTypeNumber}
                getEventCategory={getEventCategory}
                getNumeroCancion={getNumeroCancion}
                onSave={(eventData) => {

                  setShowEventForm(false);
                  setSelectedEventType(null);
                  setEventFormData({
                    consecutivo: '',
                    offset: '',
                    duracion: '',
                    idMedia: '',
                    categoria: '',
                    tipoETM: '',
                  });
                }}
                onCancel={() => {
                  setShowEventForm(false);
                  setSelectedEventType(null);
                  setEventFormData({
                    consecutivo: '',
                    offset: '',
                    duracion: '',
                    idMedia: '',
                    categoria: '',
                    tipoETM: '',
                  });
                }}
              />
      )}

      {/* DiaModelo Form Modal */}
      {showDiaModeloForm && (
              <DiaModeloForm
                diaModelo={selectedDiaModelo}
                mode={diaModeloFormMode}
                relojes={relojes}
                diasModeloExistentes={diasModelo}
                onSave={handleSaveDiaModelo}
                onCancel={() => {
                  setShowDiaModeloForm(false);
                  setSelectedDiaModelo(null);
                  setDiaModeloFormMode('new');
                }}
              />
      )}
    </>
  );
}

      // Reloj Form Component
      function RelojForm({ reloj, mode, relojEvents, politica, categoriasSeleccionadas = [], parseTimeSafely, getEventTypeNumber, getEventCategory, getNumeroCancion, calculateTotalDuration, calculateCategoryDuration, calculateOtherDuration, addEventToReloj, deleteEventFromReloj, hasUnsavedChanges, getSelectedRelojEvents, getSelectedRelojDuration, getCategoryStats, formatDuration, expandedCategories, toggleCategoryExpansion, sortConfig, sortStats, getSortedCategoryStats, onSave, onCancel, onEventClick, onCategoryClick, onPredefinedEventClick }) {
        const [isLoading, setIsLoading] = useState(false);
        const [errors, setErrors] = useState({});
        const [activeTab, setActiveTab] = useState(0);
        const [cortes, setCortes] = useState([]);
        const [loadingCortes, setLoadingCortes] = useState(false);
        // Acción local para ETM
        const [etmAction, setEtmAction] = useState('espera');
        // Color helper local para filas
        const colorForCategory = (categoria) => {
          const map = {
            'Canciones': '#3b82f6',
            'Corte Comercial': '#ef4444',
            'Nota Operador': '#f59e0b',
            'ETM': '#10b981',
            'Cartucho Fijo': '#8b5cf6',
          };
          return map[categoria] || '#6b7280';
        };

        // Cargar cortes desde la base de datos
        useEffect(() => {
          const loadCortes = async () => {
            setLoadingCortes(true);
            try {
              // Obtener token de autenticación
              const accessToken = typeof window !== 'undefined' ? localStorage.getItem('accessToken') : null;
              const headers = {
                'Content-Type': 'application/json',
              };
              if (accessToken) {
                headers['Authorization'] = `Bearer ${accessToken}`;
              }
              
              const response = await fetch(buildApiUrl('/catalogos/general/cortes/?activo=true'), {
                headers: headers
              });
              
              if (!response.ok) {
                if (response.status === 403) {
                  throw new Error('No tienes permisos para acceder a los cortes. Por favor, inicia sesión.');
                }
                if (response.status === 401) {
                  if (typeof window !== 'undefined') {
                    localStorage.removeItem('accessToken');
                    localStorage.removeItem('idToken');
                    localStorage.removeItem('refreshToken');
                    window.location.href = '/auth/login';
                  }
                  throw new Error('Sesión expirada. Por favor, inicia sesión nuevamente.');
                }
                throw new Error(`Error al cargar cortes: ${response.status}`);
              }
              
              const data = await response.json();
              setCortes(data || []);

            } catch (error) {
              console.error('Error al cargar cortes:', error);
              setCortes([]);
            } finally {
              setLoadingCortes(false);
            }
          };

          loadCortes();
        }, []);

        // Función helper para parsear tiempo de forma segura dentro del componente
        const parseTimeSafelyLocal = (timeString) => {
          if (!timeString || typeof timeString !== 'string') {
            return [0, 0, 0];
          }
          
          // Verificar que tenga el formato correcto (HH:MM:SS)
          if (!/^\d{1,2}:\d{1,2}:\d{1,2}$/.test(timeString)) {
            return [0, 0, 0];
          }
          
          try {
            return timeString.split(':').map(Number);
          } catch (error) {

            return [0, 0, 0];
          }
        };

        const [formData, setFormData] = useState({
          habilitado: reloj?.habilitado ?? true,
          clave: reloj?.clave || '',
          numeroRegla: reloj?.numero_regla || '',
          nombre: reloj?.nombre || '',
          descripcion: reloj?.descripcion || ''
        });

        const isReadOnly = mode === 'view';
        const title = mode === 'new' ? 'Nuevo Reloj' : 
                     mode === 'edit' ? 'Editar Reloj' : 
                     'Consultar Reloj';
        



        const tabs = [
          { 
            id: 0, 
            name: 'Datos generales', 
            icon: (
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            )
          },
          { 
            id: 1, 
            name: 'Eventos del reloj', 
            icon: (
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )
          }
        ];

        const inputClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
          isReadOnly ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
        }`;
        const selectClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
          isReadOnly ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
        }`;

        const validateForm = () => {
          const newErrors = {};
          if (!formData.clave) newErrors.clave = 'La clave es requerida';
          if (!formData.nombre) newErrors.nombre = 'El nombre es requerido';
          setErrors(newErrors);
          return Object.keys(newErrors).length === 0;
        };

        const handleSubmit = async () => {



          
          if (!validateForm()) {

            return;
          }
          
          setIsLoading(true);
          try {
            // Mapear los campos del frontend a los campos que espera el backend
            const relojDataForBackend = {
              habilitado: formData.habilitado ?? true,
              clave: formData.clave || '',
                  nombre: formData.nombre || '',
              numero_eventos: relojEvents.length || 0,
              duracion: '00:00:00'
            };
            



            
            // Llamar a la función onSave del componente padre, pasando también la política
            await onSave(relojDataForBackend, politica);

          } catch (error) {

          } finally {
            setIsLoading(false);
          }
        };

        // Atajos de teclado
        useEffect(() => {
          const handleKeyDown = (e) => {
            if (e.ctrlKey || e.metaKey) {
              if (e.key === 's') {
                e.preventDefault();
                handleSubmit();
              }
            }
            if (e.key === 'Escape') {
              onCancel();
            }
          };

          document.addEventListener('keydown', handleKeyDown);
          return () => document.removeEventListener('keydown', handleKeyDown);
        }, [formData]);

        const handleChange = (e) => {
          const { name, value, type, checked } = e.target;
          setFormData(prev => ({
            ...prev,
            [name]: type === 'checkbox' ? checked : value
          }));
        };

        const renderTabContent = () => {
          switch (activeTab) {
            case 0: // Datos generales
              return (
                <div className="space-y-4">
                  <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm">
                    <input 
                      type="checkbox" 
ame="habilitado" 
                      checked={formData.habilitado} 
                      onChange={handleChange} 
                      disabled={isReadOnly} 
                      className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer disabled:cursor-not-allowed" 
                    />
                    <label className="text-base font-semibold text-gray-700 cursor-pointer">Reloj habilitado</label>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">
                        Clave <span className="text-red-500">*</span>
                      </label>
                      <input 
                        type="text" 
                        name="clave" 
                        value={formData.clave || ''} 
                        onChange={handleChange} 
                        disabled={isReadOnly} 
                        className={inputClass} 
                        placeholder="Clave del reloj"
                        required={!isReadOnly}
                      />
                      {errors.clave && (
                        <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <span>{errors.clave}</span>
                        </p>
                      )}
                    </div>
                    
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">Número de Regla</label>
                      <input 
                        type="text" 
                        name="numeroRegla" 
                        value={formData.numeroRegla || ''} 
                        onChange={handleChange} 
                        disabled={isReadOnly} 
                        className={inputClass} 
                        placeholder="Número de regla"
                      />
                    </div>
                    
                    <div className="md:col-span-2">
                      <label className="block text-sm font-bold text-gray-700 mb-2">Descripción</label>
                      <textarea 
                        name="descripcion" 
                        value={formData.descripcion || ''} 
                        onChange={handleChange} 
                        readOnly={isReadOnly} 
                        rows="4" 
                        className={inputClass} 
                        placeholder="Descripción del reloj..." 
                      />
                    </div>
                  </div>
                </div>
              );
              
            case 1: // Eventos del reloj
              return (
                <div className="flex flex-col h-full space-y-4">
                  {/* Header */}
                  <div className="flex justify-between items-center mb-4">
                    <div>
                      <h3 className="text-lg font-semibold text-gray-900">Eventos del Reloj</h3>
                      <p className="text-sm text-gray-600">Configuración de eventos para 60 minutos</p>
                    </div>
                  </div>

                  {/* Content Grid */}
                  <div className="grid grid-cols-1 xl:grid-cols-4 gap-4 mb-4">
                    {/* Left Panel - Available Events */}
                    <div className="bg-white rounded-lg border border-gray-200 shadow-sm">
                      <div className="p-3 border-b border-gray-200">
                        <h4 className="font-medium text-gray-900 text-sm">Eventos Disponibles</h4>
                      </div>
                      <div className="p-3 space-y-2 max-h-96 overflow-y-auto">
                        {/* Canciones */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('canciones', 'Canciones')}
                          >
                            <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Canciones</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {categoriasSeleccionadas.map((categoria, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('canciones', typeof categoria === 'string' ? categoria : categoria.nombre)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                                </svg>
                                <span>{typeof categoria === 'string' ? categoria : categoria.nombre}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Corte Comercial */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('corte-comercial', 'Corte Comercial')}
                          >
                            <svg className="w-4 h-4 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Corte Comercial</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {loadingCortes ? (
                              <div className="flex items-center justify-center p-2 text-gray-500">
                                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-red-600"></div>
                                <span className="ml-2 text-xs">Cargando cortes...</span>
                              </div>
                            ) : cortes.filter(corte => corte.tipo === 'comercial').length === 0 ? (
                              <div className="text-xs text-gray-500 p-2">No hay cortes comerciales disponibles</div>
                            ) : (
                              cortes.filter(corte => corte.tipo === 'comercial').map((corte, index) => (
                                <div 
                                  key={corte.id} 
                                  onClick={() => onPredefinedEventClick('corte-comercial', corte.nombre, cortes)}
                                  className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                                >
                                  <svg className="w-3 h-3 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1" />
                                  </svg>
                                  <span>{corte.nombre}</span>
                                </div>
                              ))
                            )}
                          </div>
                        </div>

                        {/* Nota para el Operador */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onPredefinedEventClick('nota-operador', 'Nota para el Operador')}
                          >
                            <svg className="w-4 h-4 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Nota para el Operador</span>
                          </div>
                        </div>

                        {/* Vacío */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('vacío', 'Vacío')}
                          >
                            <svg className="w-4 h-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Vacío</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {loadingCortes ? (
                              <div className="flex items-center justify-center p-2 text-gray-500">
                                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-gray-600"></div>
                                <span className="ml-2 text-xs">Cargando cortes...</span>
                              </div>
                            ) : cortes.filter(corte => corte.tipo === 'vacio').length === 0 ? (
                              <div className="text-xs text-gray-500 p-2">No hay cortes vacíos disponibles</div>
                            ) : (
                              cortes.filter(corte => corte.tipo === 'vacio').map((corte, index) => (
                                <div 
                                  key={corte.id} 
                                  onClick={() => onPredefinedEventClick('vacío', corte.nombre, cortes)}
                                  className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                                >
                                  <svg className="w-3 h-3 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                                  </svg>
                                  <span>{corte.nombre}</span>
                                </div>
                              ))
                            )}
                          </div>
                        </div>

                        {/* Cartucho Fijo */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('cartucho-fijo', 'Cartucho Fijo')}
                          >
                            <svg className="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Cartucho Fijo</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['HIMNO NACIONAL', 'HORA EXACTA', 'IDENTIFICACION', 'LINEA INOLVIDABLE', 'CARTUCHO_1', 'CARTUCHO_2'].map((cartucho, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('cartucho-fijo', cartucho)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                                </svg>
                                <span>{cartucho}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Exact Time Marker */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('exact-time-marker', 'Exact Time Marker')}
                          >
                            <svg className="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Exact Time Marker</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {[
                              { label: 'Cortar canción', value: 'cortar' },
                              { label: 'Fade out', value: 'fadeout' },
                              { label: 'Esperar a terminar', value: 'espera' }
                            ].map(({label, value}) => (
                              <div
                                key={value}
                                onClick={() => onPredefinedEventClick('exact-time-marker', label, value)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span>{label}</span>
                              </div>
                            ))}
                          </div>
                        </div>






                      </div>
                    </div>

                    {/* Middle Panel - Clock Structure */}
                    <div className="xl:col-span-2 bg-white rounded-lg border border-gray-200 shadow-sm">
                      <div className="p-3 border-b border-gray-200">
                        <h4 className="font-medium text-gray-900 text-sm">Estructura del Reloj</h4>
                      </div>
                      <div className="overflow-x-auto max-h-96">
                        <table className="w-full">
                          <thead className="bg-gray-50">
                            <tr>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Offset</th>
                              
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Offset final</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoria</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Descripcion</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duracion</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"># de cancion</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sin categorias</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                            </tr>
                          </thead>
                          <tbody className="bg-white divide-y divide-gray-200">
                            {(() => {
                              const events = getSelectedRelojEvents();
                              if (!events || events.length === 0) {
                                return (
                                  <tr>
                                    <td colSpan="9" className="px-3 py-8 text-center text-gray-500">
                                      <div className="flex flex-col items-center justify-center space-y-2">
                                        <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                                        </svg>
                                        <p className="text-sm font-medium">No hay eventos en el reloj</p>
                                        <p className="text-xs text-gray-400">Agrega eventos desde el panel izquierdo</p>
                                      </div>
                                    </td>
                                  </tr>
                                );
                              }
                              return events.map((event, index) => (
                              <tr
                                key={event.id || index}
                                className={`hover:bg-gray-50`}
                                style={{ borderLeft: `4px solid ${colorForCategory(event.categoria)}` }}
                              >
                                <td className="px-3 py-2 text-sm font-medium text-gray-900">{event.numero}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.offset || '00:00:00'}</td>
                                
                                <td className="px-3 py-2 text-sm text-gray-600">{event.offsetFinal || '00:00:00'}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">
                                  <span className="inline-flex items-center gap-2">
                                    <span className="inline-block w-2.5 h-2.5 rounded-full" style={{ backgroundColor: colorForCategory(event.categoria) }}></span>
                                    {event.categoria}
                                  </span>
                                </td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.descripcion}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{typeof event.duracion === 'string' ? event.duracion : (typeof event.duracion === 'number' ? `${Math.floor(event.duracion / 60)}:${String(event.duracion % 60).padStart(2, '0')}` : event.duracion)}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.numeroCancion || '-'}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.sinCategorias || '-'}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">
                                  <button
                                    onClick={() => deleteEventFromReloj(event.id)}
                                    className="text-red-600 hover:text-red-800 transition-colors"
                                    title="Eliminar evento"
                                  >
                                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                    </svg>
                                  </button>
                                </td>
                              </tr>
                            ));
                            })()}
                          </tbody>
                        </table>
                      </div>
                      <div className="p-3 border-t border-gray-200 bg-gray-50">
                        <div className="text-xs text-gray-600">AVG=91.95</div>
                      </div>
                    </div>

                    {/* Right Panel - Clock Visualization */}
                    <div className="bg-white rounded-lg border border-gray-200 shadow-sm">
                      <div className="p-3 border-b border-gray-200">
                        <h4 className="font-medium text-gray-900 text-sm">Visualización del Reloj</h4>
                      </div>
                      <div className="p-4">
                        <div className="relative w-48 h-48 mx-auto">
                          {/* Pie Chart */}
                          <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                            {/* Círculo base de 60 minutos */}
                            <circle
                              cx="50"
                              cy="50"
                              r="45"
                              fill="none"
                              stroke="#e5e7eb"
                              strokeWidth="2"
                            />
                            
                            {/* Segmentos que van llenando los 60 minutos */}
                            {(() => {
                              const totalSeconds = 3600; // 60 minutos en segundos
                              let currentAngle = 0;
                              
                              // Función helper para parsear tiempo de forma segura
                              const parseTimeSafelyHelper = (timeString) => {
                                if (!timeString || typeof timeString !== 'string') {
                                  return [0, 0, 0];
                                }
                                
                                // Verificar que tenga el formato correcto (HH:MM:SS)
                                if (!/^\d{1,2}:\d{1,2}:\d{1,2}$/.test(timeString)) {
                                  return [0, 0, 0];
                                }
                                
                                try {
                                  return timeString.split(':').map(Number);
                                } catch (error) {

                                  return [0, 0, 0];
                                }
                              };
                              
                                                              return relojEvents.map((event, index) => {
                                  const [hours, minutes, seconds] = parseTimeSafelyHelper(event.duracion);
                                const eventDuration = hours * 3600 + minutes * 60 + seconds;
                                const angle = (eventDuration / totalSeconds) * 360;
                                
                                // Color por categoría
                                const getCategoryColor = (categoria) => {
                                  const colors = {
                                    'Canciones': '#3b82f6', // Azul
                                    'Corte Comercial': '#ef4444', // Rojo
                                    'Nota Operador': '#f59e0b', // Amarillo
                                    'ETM': '#10b981', // Verde
                                    'Cartucho Fijo': '#8b5cf6', // Púrpura
                                  };
                                  return colors[categoria] || '#6b7280'; // Gris por defecto
                                };
                                
                                const color = getCategoryColor(event.categoria);
                                
                                // Calcular coordenadas del segmento
                                const startAngle = currentAngle;
                                const endAngle = currentAngle + angle;
                                const x1 = 50 + 45 * Math.cos(startAngle * Math.PI / 180);
                                const y1 = 50 + 45 * Math.sin(startAngle * Math.PI / 180);
                                const x2 = 50 + 45 * Math.cos(endAngle * Math.PI / 180);
                                const y2 = 50 + 45 * Math.sin(endAngle * Math.PI / 180);
                                
                                // Determinar si el arco es grande
                                const largeArcFlag = angle > 180 ? 1 : 0;
                                
                                // Crear el path del segmento que llena esa porción de los 60 minutos
                                const pathData = `M 50 50 L ${x1} ${y1} A 45 45 0 ${largeArcFlag} 1 ${x2} ${y2} Z`;
                                
                                currentAngle += angle;
                                
                                return (
                                  <g key={index}>
                                    <path
                                      d={pathData}
                                      fill={color}
                                      stroke="#ffffff"
                                      strokeWidth="1"
                                      opacity="0.8"
                                      className="cursor-pointer hover:opacity-100 transition-opacity duration-200"
                                      onMouseEnter={(e) => {
                                        const tooltip = document.createElement('div');
                                        tooltip.className = 'absolute bg-black text-white text-xs px-2 py-1 rounded pointer-events-none z-50';
                                        tooltip.textContent = `${event.descripcion} (${event.duracion})`;
                                        tooltip.style.left = e.pageX + 10 + 'px';
                                        tooltip.style.top = e.pageY - 10 + 'px';
                                        document.body.appendChild(tooltip);
                                        e.target._tooltip = tooltip;
                                      }}
                                      onMouseLeave={(e) => {
                                        if (e.target._tooltip) {
                                          document.body.removeChild(e.target._tooltip);
                                          e.target._tooltip = null;
                                        }
                                      }}
                                    />
                                  </g>
                                );
                              });
                            })()}
                            
                            {/* Marcadores cada 5 minutos */}
                            {Array.from({length: 12}, (_, i) => i * 5).map((minute, index) => {
                              const angle = (minute / 60) * 360;
                              const isMainMark = minute % 15 === 0; // Marcas principales cada 15 minutos
                              
                              return (
                                <g key={index}>
                                  <line
                                    x1={50 + 45 * Math.cos(angle * Math.PI / 180)}
                                    y1={50 + 45 * Math.sin(angle * Math.PI / 180)}
                                    x2={50 + (isMainMark ? 50 : 47) * Math.cos(angle * Math.PI / 180)}
                                    y2={50 + (isMainMark ? 50 : 47) * Math.sin(angle * Math.PI / 180)}
                                    stroke="#374151"
                                    strokeWidth={isMainMark ? "2" : "1"}
                                  />
                                  {isMainMark && (
                                    <text
                                      x={50 + 55 * Math.cos(angle * Math.PI / 180)}
                                      y={50 + 55 * Math.sin(angle * Math.PI / 180)}
                                      textAnchor="middle"
                                      dominantBaseline="middle"
                                      className="text-base font-bold fill-gray-900"
                                      transform={`rotate(${angle + 90}, ${50 + 55 * Math.cos(angle * Math.PI / 180)}, ${50 + 55 * Math.sin(angle * Math.PI / 180)})`}
                                    >
                                      {minute}
                                    </text>
                                  )}
                                </g>
                              );
                            })}
                            
                            {/* Círculo central */}
                            <circle
                              cx="50"
                              cy="50"
                              r="15"
                              fill="#ffffff"
                              stroke="#e5e7eb"
                              strokeWidth="1"
                            />
                          </svg>
                        </div>
                        
                        {/* Leyenda de colores */}
                        <div className="mt-4">
                          <h4 className="text-sm font-medium text-gray-700 mb-2">Leyenda de colores:</h4>
                          {(() => {
                            // Obtener categorías únicas presentes en los eventos del reloj
                            const categoriasPresentes = [...new Set(relojEvents.map(e => e.categoria))];
                            
                            // Mapa de colores para cada categoría
                            const colorMap = {
                              'Canciones': { color: 'bg-blue-500',     nombre: 'Canciones' },
                              'Corte Comercial': { color: 'bg-red-500',     nombre: 'Corte Comercial' },
                              'Nota Operador': { color: 'bg-yellow-500',     nombre: 'Nota Operador' },
                              'ETM': { color: 'bg-green-500',     nombre: 'ETM' },
                              'Cartucho Fijo': { color: 'bg-purple-500',     nombre: 'Cartucho Fijo' },
                              'Comando': { color: 'bg-indigo-500',     nombre: 'Comando' },
                              'Twofer': { color: 'bg-pink-500',     nombre: 'Twofer' },
                              'Característica Específica': { color: 'bg-lime-500',     nombre: 'Característica Específica' }
                            };
                            
                            // Filtrar solo las categorías presentes
                            const categoriasDisponibles = categoriasPresentes
                              .filter(cat => colorMap[cat])
                              .map(cat => colorMap[cat]);
                            
                            if (categoriasDisponibles.length === 0) {
                              return <p className="text-xs text-gray-500">No hay eventos para mostrar</p>;
                            }
                            
                            return (
                              <div className="grid grid-cols-2 gap-2 text-xs">
                                {categoriasDisponibles.map((item, index) => (
                                  <div key={index} className="flex items-center space-x-2">
                                    <div className={`w-3 h-3 rounded-full ${item.color}`}></div>
                                    <span className="text-gray-600">{item.nombre}</span>
                                  </div>
                                ))}
                              </div>
                            );
                          })()}
                        </div>
                        
                        <div className="mt-4 space-y-2">
                          <div className="text-xs text-gray-600">Total: <span className="font-medium">{relojEvents.length} eventos</span></div>
                          <div className="text-xs text-gray-600">Duración: <span className="font-medium">{calculateTotalDuration()}</span></div>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Statistics Panel */}
                  <div className="bg-white rounded-lg border border-gray-200 shadow-sm flex-1">
                    <div className="p-3 border-b border-gray-200">
                      <h4 className="font-medium text-gray-900 text-sm">Estadísticas por Categoría</h4>
                    </div>
                    <div className="p-3">
                      <div className="overflow-x-auto">
                        <table className="w-full text-sm">
                          <thead>
                            <tr className="border-b border-gray-200">
                              <th className="text-left py-2 px-2 font-medium text-gray-700">Categoría</th>
                              <th className="text-center py-2 px-2 font-medium text-gray-700">
                                <svg className="w-4 h-4 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
                                </svg>
                              </th>
                              <th 
                                className="text-center py-2 px-2 font-medium text-gray-700 cursor-pointer hover:bg-gray-50 transition-colors"
                                onClick={() => sortStats('eventos')}
                              >
                                <div className="flex items-center justify-center space-x-1">
                                  <span># Eventos</span>
                                  {sortConfig.key === 'eventos' && (
                                    <svg className={`w-4 h-4 transition-transform ${sortConfig.direction === 'desc' ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
                                    </svg>
                                  )}
                                </div>
                              </th>
                              <th 
                                className="text-center py-2 px-2 font-medium text-gray-700 cursor-pointer hover:bg-gray-50 transition-colors"
                                onClick={() => sortStats('duracion')}
                              >
                                <div className="flex items-center justify-center space-x-1">
                                  <span>Duración</span>
                                  {sortConfig.key === 'duracion' && (
                                    <svg className={`w-4 h-4 transition-transform ${sortConfig.direction === 'desc' ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
                                    </svg>
                                  )}
                                </div>
                              </th>
                            </tr>
                          </thead>
                          <tbody>
                            {getSortedCategoryStats().map(([category, stats]) => (
                              <React.Fragment key={category}>
                                <tr 
                                  className={`border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-all duration-200 ${
                                    expandedCategories.has(category) ? 'bg-orange-50' : ''
                                  }`}
                                  onClick={() => toggleCategoryExpansion(category)}
                                >
                                  <td className="py-2 px-2">
                                    <div className="flex items-center space-x-2">
                                      <svg 
                                        className={`w-4 h-4 transition-transform ${
                                          expandedCategories.has(category) ? 'rotate-90' : ''
                                        }`} 
                                        fill="none" 
                                        stroke="currentColor" 
                                        viewBox="0 0 24 24"
                                      >
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                                      </svg>
                                      <span className="font-medium">{category}</span>
                                    </div>
                                  </td>
                                  <td className="text-center py-2 px-2">
                                    {/* Icono de ordenamiento */}
                                  </td>
                                  <td className="text-center py-2 px-2 font-medium">{stats.count}</td>
                                  <td className="text-center py-2 px-2 font-medium">{formatDuration(stats.duration)}</td>
                                </tr>
                                {expandedCategories.has(category) && (
                                  <tr className="bg-gray-50 transition-all duration-300 ease-in-out">
                                    <td colSpan="4" className="py-2 px-2">
                                      <div className="space-y-2">
                                        <div className="text-xs font-medium text-gray-600 mb-2">Detalles de eventos:</div>
                                        <div className="grid grid-cols-1 gap-1">
                                          {stats.events.map((event, index) => (
                                            <div key={index} className="flex justify-between items-center text-xs bg-white p-2 rounded border">
                                              <div className="flex items-center space-x-2">
                                                <span className="font-medium">#{event.numero}</span>
                                                <span className="text-gray-600">{event.descripcion}</span>
                                              </div>
                                              <div className="flex items-center space-x-4 text-gray-500">
                                                <span>Offset: {event.offset}</span>
                                                <span>Duración: {event.duracion}</span>
                                                {event.numeroCancion !== '-' && (
                                                  <span>Canción: {event.numeroCancion}</span>
                                                )}
                                              </div>
                                            </div>
                                          ))}
                                        </div>
                                      </div>
                                    </td>
                                  </tr>
                                )}
                              </React.Fragment>
                            ))}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>

                </div>
              );
              
              
            default:
              return null;
          }
        };

        return (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-in fade-in duration-200" onClick={(e) => e.target === e.currentTarget && onCancel()}>
            <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-[95vw] max-w-[1400px] h-[92vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100" onClick={(e) => e.stopPropagation()}>
              {/* Window Header */}
              <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 flex justify-between items-center relative overflow-hidden border-b border-blue-800/20">
                {/* Elementos decorativos */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
                <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full translate-y-12 -translate-x-12"></div>
                
                <div className="flex items-center space-x-4 relative z-10">
                  <div className="p-2 bg-white/20 rounded-lg">
                    <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                  <div>
                    <h1 className="text-2xl font-bold text-white">{title}</h1>
                    <p className="text-blue-100 text-xs">Configuración del reloj</p>
                  </div>
                  {!isReadOnly && (
                    <div className="flex items-center space-x-2 ml-4">
                      <div className={`px-3 py-1 rounded-full text-xs font-semibold ${
                        mode === 'new' ? 'bg-blue-400/30 text-white border border-white/30' : 'bg-green-400/30 text-white border border-white/30'
                      }`}>
                        {mode === 'new' ? 'Nuevo' : 'Edición'}
                      </div>
                    </div>
                  )}
                </div>
                <button onClick={onCancel} className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110 relative z-10">
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              {/* Tabs Navigation */}
              <div className="bg-white border-b border-gray-200">
                <div className="flex space-x-0 overflow-x-auto">
                  {tabs.map((tab) => (
                    <button 
                      key={tab.id} 
                      onClick={() => setActiveTab(tab.id)} 
                      className={`group flex items-center space-x-2 px-4 py-3 text-sm font-semibold whitespace-nowrap transition-all duration-200 relative ${
                        activeTab === tab.id 
                          ? "text-blue-700 bg-blue-50 border-b-2 border-blue-600" 
                          : "text-gray-600 hover:text-blue-600 hover:bg-blue-50/50"
                      }`}
                    >
                      {tab.icon}
                      <span>{tab.name}</span>
                    </button>
                  ))}
                </div>
              </div>
              
              {/* Form Content */}
              <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
                {renderTabContent()}
              </div>
              
              {/* Footer with Action Buttons */}
              <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-between items-center shadow-inner">
                <div className="flex items-center space-x-2">
                  {!isReadOnly && hasUnsavedChanges && (
                    <div className="flex items-center space-x-2 text-orange-600 text-sm">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
                      </svg>
                      <span>Cambios sin guardar</span>
                    </div>
                  )}
                </div>
                <div className="flex gap-4">
                  <button 
                    type="button" 
                    onClick={onCancel} 
                    disabled={isLoading} 
                    className="min-w-[140px] px-8 py-4 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300"
                    aria-label="Cerrar formulario"
                  >
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                    <span>Cerrar</span>
                  </button>
                  {!isReadOnly && (
                    <button 
                      type="button" 
                      onClick={handleSubmit} 
                      disabled={isLoading} 
                      className="min-w-[140px] px-8 py-4 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300"
                      aria-label={isLoading ? 'Guardando cambios' : mode === 'new' ? 'Crear nuevo reloj' : 'Guardar cambios del reloj'}
                    >
                      {isLoading ? (
                        <div className="w-5 h-5 border-[3px] border-white border-t-transparent rounded-full animate-spin"></div>
                      ) : (
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                      <span>{isLoading ? 'Guardando...' : mode === 'new' ? 'Crear' : 'Guardar'}</span>
                    </button>
                  )}
                </div>
              </div>
            </div>
          </div>
                );
      }

      // Event Form Component
      function EventForm({ eventType, formData, relojEvents, parseTimeSafely, addEventToReloj, getEventTypeNumber, getEventCategory, getNumeroCancion, onSave, onCancel }) {
        const [isLoading, setIsLoading] = useState(false);
        const [errors, setErrors] = useState({});

        // Función helper para parsear tiempo de forma segura dentro del componente
        const parseTimeSafelyLocal = (timeString) => {
          if (!timeString || typeof timeString !== 'string') {
            return [0, 0, 0];
          }
          
          // Verificar que tenga el formato correcto (HH:MM:SS)
          if (!/^\d{1,2}:\d{1,2}:\d{1,2}$/.test(timeString)) {
            return [0, 0, 0];
          }
          
          try {
            return timeString.split(':').map(Number);
          } catch (error) {

            return [0, 0, 0];
          }
        };
        const [localFormData, setLocalFormData] = useState(formData);

        const title = `Agregar ${eventType?.name || 'Evento'}`;

        const inputClass = "w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400";

        const validateForm = () => {
          const newErrors = {};
          if (!localFormData.consecutivo) newErrors.consecutivo = 'El consecutivo es requerido';
          if (!localFormData.offset) newErrors.offset = 'El offset es requerido';
          if (!localFormData.duracion) newErrors.duracion = 'La duración es requerida';
          if (!localFormData.descripcion) newErrors.descripcion = 'La descripción es requerida';
          
          // Validación adicional para Cartucho Fijo
          if (eventType?.type === 'cartucho-fijo') {
            if (!localFormData.idMedia) newErrors.idMedia = 'El ID Media es requerido';
            if (!localFormData.categoria) newErrors.categoria = 'La categoría es requerida';
          }
          
          
          
          setErrors(newErrors);
          return Object.keys(newErrors).length === 0;
        };

        const handleSubmit = async () => {
          if (!validateForm()) return;
          
          setIsLoading(true);
          try {
            // Crear el nuevo evento
            const newEvent = {
              id: relojEvents.length + 1,
numero: localFormData.consecutivo,
              offset: localFormData.offset,
              desdeETM: localFormData.offset,
              desdeCorte: localFormData.offset,
              offsetFinal: localFormData.offset, // Se calculará después
              tipo: getEventTypeNumber(eventType?.type || 'otros'),
              categoria: eventType?.type === 'cartucho-fijo' ? localFormData.categoria : getEventCategory(eventType?.type || 'otros'),
              descripcion: localFormData.descripcion,
              duracion: localFormData.duracion,
numeroCancion: getNumeroCancion(eventType?.type || 'otros'),
              sinCategorias: '-',
              // Campos adicionales para Cartucho Fijo
              ...(eventType?.type === 'cartucho-fijo' && {
                idMedia: localFormData.idMedia,
                categoriaEspecifica: localFormData.categoria
              }),
            };
            
            // Calcular el offset final basado en la duración
            const [hours, minutes, seconds] = parseTimeSafelyLocal(newEvent.duracion);
            const durationSeconds = hours * 3600 + minutes * 60 + seconds;
            const [offsetHours, offsetMinutes, offsetSeconds] = parseTimeSafelyLocal(newEvent.offset);
            const offsetTotalSeconds = offsetHours * 3600 + offsetMinutes * 60 + offsetSeconds;
            const finalTotalSeconds = offsetTotalSeconds + durationSeconds;
            
            const finalHours = Math.floor(finalTotalSeconds / 3600);
            const finalMinutes = Math.floor((finalTotalSeconds % 3600) / 60);
            const finalSeconds = finalTotalSeconds % 60;
            
ewEvent.offsetFinal = `${finalHours.toString().padStart(2, '0')}:${finalMinutes.toString().padStart(2, '0')}:${finalSeconds.toString().padStart(2, '0')}`;
            
            // Añadir el evento a la tabla
            addEventToReloj(newEvent);
            

            onSave(newEvent);
          } catch (error) {

          } finally {
            setIsLoading(false);
          }
        };

        const handleChange = (e) => {
          const { name, value } = e.target;
          setLocalFormData(prev => ({
            ...prev,
            [name]: value
          }));
        };

        return (
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200" onClick={(e) => e.target === e.currentTarget && onCancel()}>
            <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100" onClick={(e) => e.stopPropagation()}>
              {/* Enhanced Window Header */}
              <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 relative overflow-hidden border-b border-blue-800/20">
                <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
                <div className="relative z-10 flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                      <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                      </svg>
                    </div>
                    <h1 className="text-2xl font-bold text-white">{title}</h1>
                  </div>
                  <button
                    onClick={onCancel}
                    className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110"
                    title="Cerrar"
                  >
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
                {/* Efecto de partículas decorativas */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
                <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
              </div>
              
              {/* Enhanced Form Content */}
              <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
                <div className="space-y-6">
                  {/* Consecutivo */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">
                      Consecutivo <span className="text-red-500">*</span>
                    </label>
                    <input 
                      type="text" 
ame="consecutivo" 
                      value={localFormData.consecutivo || ''} 
                      onChange={handleChange} 
                      className={inputClass} 
                      required 
                      placeholder="Ej: 001" 
                    />
                    {errors.consecutivo && <p className="mt-1 text-sm text-red-600">{errors.consecutivo}</p>}
                  </div>
                  
                  {/* Offset */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">
                      Offset <span className="text-red-500">*</span>
                    </label>
                    <div className="flex flex-col space-y-2">
                      <div className="flex space-x-2 items-center">
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="offsetHoras" 
                            value={localFormData.offset ? parseInt(localFormData.offset.split(':')[0]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = e.target.value;
                              const minutos = localFormData.offset ? parseInt(localFormData.offset.split(':')[1]) || 0 : 0;
                              const segundos = localFormData.offset ? parseInt(localFormData.offset.split(':')[2]) || 0 : 0;
                              const newValue = `${horas.padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                              handleChange({ target: { name: 'offset', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter' || e.target.value.length === 2) {
                                e.target.nextElementSibling?.nextElementSibling?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="23"
                            placeholder="00"
                            title="Horas (0-23)"
                          />
                          <span className="text-xs text-gray-500 mt-1">H</span>
                        </div>
                        <span className="flex items-center text-gray-500 text-lg font-bold">:</span>
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="offsetMinutos" 
                            value={localFormData.offset ? parseInt(localFormData.offset.split(':')[1]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = localFormData.offset ? parseInt(localFormData.offset.split(':')[0]) || 0 : 0;
                              const minutos = e.target.value;
                              const segundos = localFormData.offset ? parseInt(localFormData.offset.split(':')[2]) || 0 : 0;
                              const newValue = `${horas.toString().padStart(2, '0')}:${minutos.padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                              handleChange({ target: { name: 'offset', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter' || e.target.value.length === 2) {
                                e.target.nextElementSibling?.nextElementSibling?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="59"
                            placeholder="00"
                            title="Minutos (0-59)"
                          />
                          <span className="text-xs text-gray-500 mt-1">M</span>
                        </div>
                        <span className="flex items-center text-gray-500 text-lg font-bold">:</span>
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="offsetSegundos" 
                            value={localFormData.offset ? parseInt(localFormData.offset.split(':')[2]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = localFormData.offset ? parseInt(localFormData.offset.split(':')[0]) || 0 : 0;
                              const minutos = localFormData.offset ? parseInt(localFormData.offset.split(':')[1]) || 0 : 0;
                              const segundos = e.target.value;
                              const newValue = `${horas.toString().padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.padStart(2, '0')}`;
                              handleChange({ target: { name: 'offset', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter') {
                                e.target.closest('form')?.querySelector('button[type="submit"]')?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="59"
                            placeholder="00"
                            title="Segundos (0-59)"
                          />
                          <span className="text-xs text-gray-500 mt-1">S</span>
                        </div>
                      </div>
                    </div>
                    <p className="mt-1 text-xs text-gray-500">Se calcula automáticamente basado en el último evento</p>
                    {errors.offset && <p className="mt-1 text-sm text-red-600">{errors.offset}</p>}
                  </div>
                  
                  {/* Duración */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">
                      Duración <span className="text-red-500">*</span>
                    </label>
                    <div className="flex flex-col space-y-2">
                      <div className="flex space-x-2 items-center">
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="duracionHoras" 
                            value={localFormData.duracion ? parseInt(localFormData.duracion.split(':')[0]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = e.target.value;
                              const minutos = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[1]) || 0 : 0;
                              const segundos = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[2]) || 0 : 0;
                              const newValue = `${horas.padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                              handleChange({ target: { name: 'duracion', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter' || e.target.value.length === 2) {
                                e.target.nextElementSibling?.nextElementSibling?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="23"
                            placeholder="00"
                            title="Horas (0-23)"
                          />
                          <span className="text-xs text-gray-500 mt-1">H</span>
                        </div>
                        <span className="flex items-center text-gray-500 text-lg font-bold">:</span>
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="duracionMinutos" 
                            value={localFormData.duracion ? parseInt(localFormData.duracion.split(':')[1]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[0]) || 0 : 0;
                              const minutos = e.target.value;
                              const segundos = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[2]) || 0 : 0;
                              const newValue = `${horas.toString().padStart(2, '0')}:${minutos.padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                              handleChange({ target: { name: 'duracion', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter' || e.target.value.length === 2) {
                                e.target.nextElementSibling?.nextElementSibling?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="59"
                            placeholder="00"
                            title="Minutos (0-59)"
                          />
                          <span className="text-xs text-gray-500 mt-1">M</span>
                        </div>
                        <span className="flex items-center text-gray-500 text-lg font-bold">:</span>
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
ame="duracionSegundos" 
                            value={localFormData.duracion ? parseInt(localFormData.duracion.split(':')[2]) || 0 : 0} 
                            onChange={(e) => {
                              const horas = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[0]) || 0 : 0;
                              const minutos = localFormData.duracion ? parseInt(localFormData.duracion.split(':')[1]) || 0 : 0;
                              const segundos = e.target.value;
                              const newValue = `${horas.toString().padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.padStart(2, '0')}`;
                              handleChange({ target: { name: 'duracion', value: newValue } });
                            }}
                            onKeyDown={(e) => {
                              if (e.key === 'Enter') {
                                e.target.closest('form')?.querySelector('button[type="submit"]')?.focus();
                              }
                            }}
                            className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                            required 
                            min="0"
                            max="59"
                            placeholder="00"
                            title="Segundos (0-59)"
                          />
                          <span className="text-xs text-gray-500 mt-1">S</span>
                        </div>
                      </div>
                    </div>
                    {errors.duracion && <p className="mt-1 text-sm text-red-600">{errors.duracion}</p>}
                  </div>
                  
                  {/* Descripción */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">
                      Descripción <span className="text-red-500">*</span>
                    </label>
                    <textarea 
ame="descripcion" 
                      value={localFormData.descripcion || ''} 
                      onChange={handleChange} 
                      rows="4" 
                      className={inputClass} 
                      required 
                      placeholder="Descripción del evento..." 
                    />
                    {errors.descripcion && (
                      <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <span>{errors.descripcion}</span>
                      </p>
                    )}
                  </div>

                  {/* Campos adicionales para Cartucho Fijo */}
                  {eventType?.type === 'cartucho-fijo' && (
                    <>
                      {/* ID Media */}
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          ID Media <span className="text-red-500">*</span>
                        </label>
                        <input 
                          type="text" 
ame="idMedia" 
                          value={localFormData.idMedia || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required 
                          placeholder="Ej: MEDIA001" 
                        />
                        {errors.idMedia && <p className="mt-1 text-sm text-red-600">{errors.idMedia}</p>}
                      </div>

                      {/* Categoría */}
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">
                          Categoría <span className="text-red-500">*</span>
                        </label>
                        <select 
ame="categoria" 
                          value={localFormData.categoria || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required
                        >
                          <option value="">Seleccionar categoría</option>
                          <option value="HIMNO">HIMNO</option>
                          <option value="IDENTIFICACION">IDENTIFICACION</option>
                          <option value="HORA_EXACTA">HORA EXACTA</option>
                          <option value="LINEA_INOLVIDABLE">LINEA INOLVIDABLE</option>
                          <option value="CARTUCHO_1">CARTUCHO 1</option>
                          <option value="CARTUCHO_2">CARTUCHO 2</option>
                        </select>
                        {errors.categoria && <p className="mt-1 text-sm text-red-600">{errors.categoria}</p>}
                      </div>
                    </>
                  )}




                </div>
              </div>
              
              {/* Footer with Action Buttons - Mejorado */}
              <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end gap-4 shadow-inner">
                <button 
                  type="button" 
                  onClick={onCancel} 
                  disabled={isLoading} 
                  className="min-w-[140px] px-8 py-4 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300"
                  aria-label="Cancelar y cerrar formulario"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                  <span>Cancelar</span>
                </button>
                <button 
                  type="button" 
                  onClick={handleSubmit} 
                  disabled={isLoading} 
                  className="min-w-[140px] px-8 py-4 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300"
                  aria-label={isLoading ? 'Guardando evento' : 'Agregar evento al reloj'}
                >
                  {isLoading ? (
                    <div className="w-5 h-5 border-[3px] border-white border-t-transparent rounded-full animate-spin"></div>
                  ) : (
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                    </svg>
                  )}
                  <span>{isLoading ? 'Guardando...' : 'Agregar Evento'}</span>
                </button>
              </div>
            </div>
          </div>
        );
      }

      // Politica Form Component
      function PoliticaForm({ 
  politica, 
  mode, 
  onSave, 
  onCancel, 
  onNewReloj,
  categoriasSeleccionadas,
  setCategoriasSeleccionadas,
  onCategoriasSaved,
  activeTab: propActiveTab,
  setActiveTab: propSetActiveTab,
  relojes,
  setRelojes,
  diasModelo,
  setDiasModelo,
  selectedRelojInTable,
  setSelectedRelojInTable,
  handleNewReloj,
  handleEditReloj,
  handleViewReloj,
  handleDeleteReloj,
  handleToggleRelojHabilitado,
  handleNewDiaModelo,
  handleEditDiaModelo,
  handleViewDiaModelo,
  handleDeleteDiaModelo,
  handleSaveDiaModelo,
  handleToggleDiaModeloHabilitado,
  getEventColor,
  relojEvents,
  calculateTotalDuration,
  getSelectedRelojEvents,
  getSelectedRelojDuration,
  politicas,
  handleNewRegla,
  reglasPolitica,
  loadingReglas,
  loadReglasPolitica,
  handleToggleReglaHabilitada
}) {
  
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const [activeTab, setActiveTab] = useState(propActiveTab !== undefined ? propActiveTab : 0);
  const [editingDiaModeloIndex, setEditingDiaModeloIndex] = useState(null);
  const [selectedDiaModeloInTable, setSelectedDiaModeloInTable] = useState(null);

  // Helper para calcular duración total en segundos desde formato HH:MM:SS
  const parseDurationToSecondsLocal = (durationStr) => {
    if (!durationStr) return 0;
    
    // Si es un número, ya está en segundos
    if (typeof durationStr === 'number') {
      return durationStr;
    }
    
    // Si es string con formato HH:MM:SS
    if (typeof durationStr === 'string' && durationStr.includes(':')) {
      const parts = durationStr.split(':');
      if (parts.length === 3) {
        const hours = parseInt(parts[0], 10) || 0;
        const minutes = parseInt(parts[1], 10) || 0;
        const seconds = parseInt(parts[2], 10) || 0;
        return hours * 3600 + minutes * 60 + seconds;
      }
    }
    
    // Si es string numérico, tratar como segundos
    if (typeof durationStr === 'string') {
      return parseInt(durationStr, 10) || 0;
    }
    
    return 0;
  };

  // Helper para formatear segundos a HH:MM:SS
  const formatSecondsToTimeLocal = (totalSeconds) => {
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  };

  // Función para calcular la duración total de un reloj basándose en sus eventos
  const calculateRelojDurationLocal = (reloj) => {
    if (!reloj || !reloj.eventos || reloj.eventos.length === 0) {
      return '00:00:00';
    }
    
    let totalSeconds = 0;
    reloj.eventos.forEach(evento => {
      totalSeconds += parseDurationToSecondsLocal(evento.duracion);
    });
    
    return formatSecondsToTimeLocal(totalSeconds);
  };
  
  // Estados para el modal de reglas
  const [showReglaForm, setShowReglaForm] = useState(false);
  const [selectedRegla, setSelectedRegla] = useState(null);
  const [reglaFormMode, setReglaFormMode] = useState('new'); // 'new', 'edit', 'view'
  const [reglaFormData, setReglaFormData] = useState({
    posicion: 0,
    tipoRegla: 'Separación Mínima',
    caracteristica: 'Inquebrantable',
    caracteristica2: '',
    setReglas: false,
    reglaHabilitada: true,
    caracteristicaDetalle: '',
    horario: false,
    horaInicial: '',
    horaFinal: '',
    tipoSeparacion: 'Tiempo - Segundos',
    soloVerificarDia: false,
    descripcion: '',
    separaciones: []
  });
  const [showDiaModeloForm, setShowDiaModeloForm] = useState(false);

  // Sincronizar el estado local con las props cuando cambien
  useEffect(() => {
    if (propActiveTab !== undefined && propActiveTab !== activeTab) {
      setActiveTab(propActiveTab);
    }
  }, [propActiveTab]);

  // Notificar al componente padre cuando cambie la tab
  useEffect(() => {
    if (propSetActiveTab) {
      propSetActiveTab(activeTab);
    }
  }, [activeTab, propSetActiveTab]);

  // Debug: monitorear cambios en showReglaForm
  useEffect(() => {

  }, [showReglaForm]);

  // Funciones locales para manejar días modelo
  const handleNewDiaModeloLocal = () => {
    setEditingDiaModeloIndex(null);
    setShowDiaModeloForm(true);
  };

  // Funciones para el formulario de reglas
  const handleNewReglaLocal = () => {

    setSelectedRegla(null);
    setReglaFormMode('new');
    setReglaFormData({
      tipoRegla: 'Separación Mínima',
      reglaHabilitada: true,
      caracteristicaDetalle: 'ID de Canción',
      horario: false,
      horaInicial: '',
      horaFinal: '',
      tipoSeparacion: 'Tiempo - Segundos',
      soloVerificarDia: false,
      descripcion: '',
      separaciones: []
    });
    setShowReglaForm(true);
  };

  const handleEditReglaLocal = () => {
    if (!selectedRegla) {
      alert('Por favor, selecciona una regla para editar');
      return;
    }

    setReglaFormMode('edit');
    setReglaFormData({
      tipoRegla: selectedRegla.tipo_regla || 'Separación Mínima',
      reglaHabilitada: selectedRegla.habilitada ?? true,
      caracteristicaDetalle: selectedRegla.caracteristica || 'ID de Canción',
      horario: selectedRegla.horario || false,
      horaInicial: '',
      horaFinal: '',
      tipoSeparacion: selectedRegla.tipo_separacion || 'Tiempo - Segundos',
      soloVerificarDia: selectedRegla.solo_verificar_dia || false,
      descripcion: selectedRegla.descripcion || '',
      separaciones: selectedRegla.separaciones?.map(sep => ({
        valor: sep.valor || '',
        separacion: sep.separacion || 0
      })) || []
    });
    setShowReglaForm(true);
  };

  const handleConsultarRegla = () => {
    if (!selectedRegla) {
      alert('Por favor, selecciona una regla para consultar');
      return;
    }

    setReglaFormMode('view');
    setReglaFormData({
      tipoRegla: selectedRegla.tipo_regla || 'Separación Mínima',
      reglaHabilitada: selectedRegla.habilitada ?? true,
      caracteristicaDetalle: selectedRegla.caracteristica || 'ID de Canción',
      horario: selectedRegla.horario || false,
      horaInicial: '',
      horaFinal: '',
      tipoSeparacion: selectedRegla.tipo_separacion || 'Tiempo - Segundos',
      soloVerificarDia: selectedRegla.solo_verificar_dia || false,
      descripcion: selectedRegla.descripcion || '',
      separaciones: selectedRegla.separaciones?.map(sep => ({
        valor: sep.valor || '',
        separacion: sep.separacion || 0
      })) || []
    });
    setShowReglaForm(true);
  };

  const handleDeleteReglaLocal = async () => {
    if (!selectedRegla) {
      alert('Por favor, selecciona una regla para eliminar');
      return;
    }
    
    if (!confirm(`¿Estás seguro de que deseas eliminar la regla "${selectedRegla.tipo_regla}"?`)) {
      return;
    }
    
    try {
      await deleteRegla(selectedRegla.id);

      
      // Recargar las reglas de la política
      await loadReglasPolitica(politica?.id || 1);
      
      // Limpiar selección
      setSelectedRegla(null);
      
    } catch (error) {

      alert('Error al eliminar la regla. Por favor, inténtalo de nuevo.');
    }
  };

  const handleReglaFormChange = (field, value) => {
    setReglaFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handleSeparacionChange = (index, field, value) => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: prev.separaciones.map((sep, i) => 
        i === index ? { ...sep, [field]: value } : sep
      )
    }));
  };

  const addSeparacion = () => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: [...prev.separaciones, { valor: '', separacion: 0 }]
    }));
  };

  const removeSeparacion = (index) => {
    setReglaFormData(prev => ({
      ...prev,
      separaciones: prev.separaciones.filter((_, i) => i !== index)
    }));
  };

  const handleReglaSave = async () => {
    try {

      
      // Preparar datos para enviar a la API
      const reglaData = {
        politica_id: politica?.id || 1, // Usar la política actual o un ID por defecto
        tipo_regla: reglaFormData.tipoRegla,
        caracteristica: reglaFormData.caracteristicaDetalle,
        tipo_separacion: reglaFormData.tipoSeparacion,
        descripcion: reglaFormData.descripcion,
        horario: reglaFormData.horario,
        solo_verificar_dia: reglaFormData.soloVerificarDia,
        habilitada: reglaFormData.reglaHabilitada,
        separaciones: reglaFormData.separaciones.map(sep => ({
          valor: sep.valor,
          separacion: parseInt(sep.separacion) || 0
        }))
      };
      
      // Crear la regla
      const nuevaRegla = await createRegla(reglaData);

      
      // Cerrar el modal y limpiar el formulario
      setShowReglaForm(false);
      setReglaFormData({
        tipoRegla: 'Separación Mínima',
        caracteristica: '',
        tipoSeparacion: 'Tiempo - Segundos',
        horario: false,
        soloVerificarDia: false,
        habilitada: true,
        separaciones: []
      });
      
      // Mostrar notificación de éxito

      
      // Recargar las reglas de la política
      await loadReglasPolitica(politica?.id || 1);
      
    } catch (error) {


    }
  };

  const handleReglaCancel = () => {
    setShowReglaForm(false);
  };

  const handleEditDiaModeloLocal = (diaModelo) => {
    setEditingDiaModeloIndex(diaModelo.id);
    setShowDiaModeloForm(true);
  };

  const handleViewDiaModeloLocal = (diaModelo) => {
    setEditingDiaModeloIndex(diaModelo.id);
    setShowDiaModeloForm(true);
  };

  const [formData, setFormData] = useState({
    clave: politica?.clave || '',
    difusora: politica?.difusora || '',
    nombre: politica?.nombre || '',
    descripcion: politica?.descripcion || '',
    habilitada: politica?.habilitada ?? true,
    // Datos adicionales para los otros tabs
    setsReglas: politica?.setsReglas || [],
    reglas: politica?.reglas || [],
    ordenAsignacion: politica?.ordenAsignacion || [],
    relojes: politica?.relojes || [],
    diasModelo: politica?.diasModelo || [],
    // Días modelo por defecto para cada día de la semana
    lunes: politica?.lunes ? String(politica.lunes) : '',
    martes: politica?.martes ? String(politica.martes) : '',
    miercoles: politica?.miercoles ? String(politica.miercoles) : '',
    jueves: politica?.jueves ? String(politica.jueves) : '',
    viernes: politica?.viernes ? String(politica.viernes) : '',
    sabado: politica?.sabado ? String(politica.sabado) : '',
    domingo: politica?.domingo ? String(politica.domingo) : ''
  });

  // Estado para difusoras
  const [difusoras, setDifusoras] = useState([]);

  // Cargar difusoras al inicializar el componente
  useEffect(() => {
    loadDifusoras();
  }, []);

  // Actualizar formData cuando cambie la política
  useEffect(() => {
    if (politica) {




      
      setFormData({
        clave: politica.clave || '',
        difusora: politica.difusora || '',
            nombre: politica.nombre || '',
        descripcion: politica.descripcion || '',
        habilitada: politica.habilitada ?? true,
        setsReglas: politica.setsReglas || [],
        reglas: politica.reglas || [],
        ordenAsignacion: politica.ordenAsignacion || [],
        relojes: politica.relojes || [],
        diasModelo: politica.diasModelo || [],
        // Días modelo por defecto para cada día de la semana
        lunes: politica.lunes ? String(politica.lunes) : '',
        martes: politica.martes ? String(politica.martes) : '',
        miercoles: politica.miercoles ? String(politica.miercoles) : '',
        jueves: politica.jueves ? String(politica.jueves) : '',
        viernes: politica.viernes ? String(politica.viernes) : '',
        sabado: politica.sabado ? String(politica.sabado) : '',
        domingo: politica.domingo ? String(politica.domingo) : ''
      });



    }
  }, [politica, difusoras]);

  const isReadOnly = mode === 'view';
  const title = mode === 'new' ? 'Nueva Política' : 
               mode === 'edit' ? 'Editar Política' : 
               'Consultar Política';

  // Cargar difusoras desde la API
  const loadDifusoras = async () => {
    try {
      // Usar la misma API que la página de gestión de difusoras
      const { getDifusoras } = await import('../../../../api/catalogos/generales/difusorasApi');
      
      // Cargar todas las difusoras activas
      const data = await getDifusoras({ activa: true });
      
      if (!data || !Array.isArray(data)) {
        console.warn('No se recibieron difusoras o el formato es incorrecto:', data);
        setDifusoras([]);
        return;
      }

      // Mapear datos de la API al formato esperado por el select
      const difusorasMapeadas = data.map(difusora => ({
        value: difusora.siglas,
        label: `${difusora.siglas} - ${difusora.nombre}`
      }));
      
      // Agregar opción especial para "Todas las difusoras" solo si hay difusoras
      const difusorasConTodas = difusorasMapeadas.length > 0 ? [
        { value: 'TODAS', label: 'Todas las difusoras' },
        ...difusorasMapeadas
      ] : [];
      
      setDifusoras(difusorasConTodas);
      
      // Log para debugging
      if (difusorasConTodas.length === 0) {
        console.warn('No se encontraron difusoras para el usuario actual');
      }
    } catch (err) {
      console.error('Error al cargar difusoras:', err);
      setDifusoras([]);
    }
  };

  const tabs = [
    { 
      id: 0, 
      name: 'Datos generales', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      )
    },
    { 
      id: 1, 
      name: 'Reglas', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      )
    },
    { 
      id: 2, 
      name: 'Orden de asignación', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
      )
    },
    { 
      id: 3, 
      name: 'Relojes', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      )
    },
    { 
      id: 4, 
      name: 'Días modelo', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      )
    }
  ];

  const validateForm = () => {
    const newErrors = {};
    
    if (!formData.clave || formData.clave.trim() === '') {
      newErrors.clave = 'La clave es obligatoria';
    } else {
      // Verificar si la clave ya existe en otra política
      const claveExistente = politicas.find(p => 
        p.clave === formData.clave.trim() && 
        p.id !== politica?.id
      );
      if (claveExistente) {
        newErrors.clave = `La clave "${formData.clave.trim()}" ya existe en la política "${claveExistente.nombre || claveExistente.difusora}"`;
      }
    }
    
    if (!formData.difusora || formData.difusora.trim() === '') {
      newErrors.difusora = 'La difusora es obligatoria';
    }
    
    if (!formData.nombre || formData.nombre.trim() === '') {
      newErrors.nombre = 'El nombre es obligatorio';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    if (isReadOnly) return;
    
    const isValid = validateForm();
    if (!isValid) return;
    
    setIsLoading(true);
    
    try {
      // Si estamos en la pestaña de Orden de asignación (2), persistir categorías antes
      if (activeTab === 2 && politica?.id) {
        try {
          const categoriasNombres = categoriasSeleccionadas.map(c => typeof c === 'string' ? c : c.nombre)
          await guardarCategoriasPolitica(politica.id, categoriasNombres)

        } catch (err) {

        }
      }

      
      // Convertir cadenas vacías a null para los días modelo
      const formDataToSend = {
        ...formData,
        lunes: formData.lunes === '' ? null : formData.lunes,
        martes: formData.martes === '' ? null : formData.martes,
        miercoles: formData.miercoles === '' ? null : formData.miercoles,
        jueves: formData.jueves === '' ? null : formData.jueves,
        viernes: formData.viernes === '' ? null : formData.viernes,
        sabado: formData.sabado === '' ? null : formData.sabado,
        domingo: formData.domingo === '' ? null : formData.domingo
      };
      
      await onSave(formDataToSend);
    } catch (err) {

    } finally {
      setIsLoading(false);
    }
  };

  const handleChange = (e) => {
    if (isReadOnly) return;
    
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : value;
    
    setFormData(prev => ({
      ...prev,
      [name]: newValue
    }));
    
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const inputClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
    isReadOnly ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
  }`;

  const selectClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
    isReadOnly ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
  }`;

  const renderTabContent = () => {
    switch (activeTab) {
      case 0: // Datos generales
        return (
          <div className="space-y-6">
            {/* Habilitada checkbox */}
            <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm">
              <input
                type="checkbox"
                name="habilitada"
                checked={formData.habilitada}
                onChange={handleChange}
                disabled={isReadOnly}
                className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer disabled:cursor-not-allowed"
              />
              <label className="text-base font-semibold text-gray-700 cursor-pointer">Política habilitada</label>
            </div>

            {/* Form fields */}
            <div className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Clave <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="clave"
                    value={formData.clave || ''}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    placeholder="Ej: DIARIO"
                  />
                  {errors.clave && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <span>{errors.clave}</span>
                    </p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Difusora <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="difusora"
                    value={formData.difusora || ''}
                    onChange={handleChange}
                    disabled={isReadOnly}
                    className={selectClass}
                    required={!isReadOnly}
                  >
                    <option value="">
                      {difusoras.length === 0 
                        ? 'No hay difusoras disponibles. Contacta al administrador para que te asigne difusoras.' 
                        : 'Seleccionar difusora'}
                    </option>
                    {difusoras.map((difusora) => (
                      <option key={difusora.value} value={difusora.value}>
                        {difusora.label}
                      </option>
                    ))}
                  </select>
                  {errors.difusora && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <span>{errors.difusora}</span>
                    </p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Nombre <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="nombre"
                    value={formData.nombre || ''}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    placeholder="Ej: Política Diaria"
                  />
                  {errors.nombre && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <span>{errors.nombre}</span>
                    </p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-bold text-gray-700 mb-2">Descripción</label>
                  <textarea
                    name="descripcion"
                    value={formData.descripcion || ''}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    rows="4"
                    className={inputClass}
                    placeholder="Descripción de la política..."
                  />
                </div>
              </div>
            </div>
          </div>
        );


      case 1: // Reglas
        return (
          <div className="space-y-4">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Reglas</h3>
              <div className="flex space-x-2">
                <button 
                  onClick={() => {

                    handleNewReglaLocal();
                  }}
                  className="flex items-center space-x-2 px-3 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                  <span>Añadir</span>
                </button>
                <button 
                  onClick={handleEditReglaLocal}
                  className="flex items-center space-x-2 px-3 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                  <span>Editar</span>
                </button>
                <button 
                  onClick={handleConsultarRegla}
                  className="flex items-center space-x-2 px-3 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors border-2 border-green-500"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                  <span>Consultar</span>
                </button>
                <button 
                  onClick={handleDeleteReglaLocal}
                  className="flex items-center space-x-2 px-3 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                  <span>Eliminar</span>
                </button>
              </div>
            </div>
            
            <div className="bg-white border border-gray-200 rounded-lg overflow-hidden">
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Habilitada
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Tipo de Regla
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Descripción
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Característica
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Tipo Separación
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Valor
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Separación
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {loadingReglas ? (
                      <tr>
                        <td colSpan="7" className="px-4 py-8 text-center">
                          <div className="flex justify-center items-center">
                            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                            <span className="ml-2 text-gray-500">Cargando reglas...</span>
              </div>
                        </td>
                      </tr>
                    ) : reglasPolitica.length === 0 ? (
                      <tr>
                        <td colSpan="7" className="px-4 py-8 text-center text-gray-500">
                          No hay reglas configuradas para esta política
                        </td>
                      </tr>
                    ) : (
                      reglasPolitica.map((regla, index) => (
                        <tr 
                          key={regla.id} 
                          className={`hover:bg-gray-50 cursor-pointer ${selectedRegla?.id === regla.id ? 'bg-blue-50 border-l-4 border-blue-500' : ''}`}
                          onClick={() => setSelectedRegla(regla)}
                        >
                          <td className="px-4 py-4 whitespace-nowrap" onClick={(e) => e.stopPropagation()}>
                            <div className="flex items-center">
                              <input 
                                type="checkbox" 
                                className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded" 
                                checked={regla.habilitada ?? true}
                                onChange={(e) => {
                                  if (handleToggleReglaHabilitada) {
                                    handleToggleReglaHabilitada(regla.id, e.target.checked);
                                  }
                                }}
                                onClick={(e) => e.stopPropagation()}
                              />
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <div className="text-sm text-gray-900">{regla.tipo_regla}</div>
                          </td>
                          <td className="px-4 py-4">
                            <div className="text-sm text-gray-900 max-w-xs truncate" title={regla.descripcion || 'Sin descripción'}>
                              {regla.descripcion || 'Sin descripción'}
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <div className="text-sm text-gray-900">{regla.caracteristica}</div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <div className="text-sm text-gray-900">{regla.tipo_separacion}</div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <div className="text-sm text-gray-900">
                              {regla.separaciones && regla.separaciones.length > 0 
                                ? regla.separaciones.map(sep => sep.valor).join(', ')
                                : 'Sin separaciones'
                              }
                            </div>
                          </td>
                          <td className="px-4 py-4 whitespace-nowrap">
                            <div className="text-sm text-gray-900">
                              {regla.separaciones && regla.separaciones.length > 0 
                                ? regla.separaciones.map(sep => `${sep.separacion} seg`).join(', ')
                                : '0 seg'
                              }
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
        );

      case 2: // Orden de asignación
        return (
          <OrdenAsignacion 
            politicaId={politica?.id || 1} // Usar el ID de la política actual
            categoriasSeleccionadas={categoriasSeleccionadas}
            setCategoriasSeleccionadas={setCategoriasSeleccionadas}
            onSave={onCategoriasSaved}
            onCancel={() => {
              // Cerrar el modal o volver a la vista anterior
            }}
          />
        );

      case 3: // Relojes
        return (
          <div className="space-y-6">
            {/* Header Mejorado */}
            <div className="bg-gradient-to-br from-purple-50 via-indigo-50 to-blue-50 rounded-2xl p-6 border border-purple-200 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="p-3 bg-purple-600 rounded-xl shadow-md">
                    <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                  <div>
                    <h3 className="text-2xl font-bold text-gray-900">Gestión de Relojes</h3>
                    <p className="text-sm text-gray-600 mt-1">Administra los relojes de programación</p>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="bg-white rounded-xl px-4 py-3 shadow-sm border border-gray-200 text-center">
                    <div className="text-2xl font-bold text-purple-600">{relojes.length}</div>
                    <div className="text-xs text-gray-600 uppercase tracking-wide">Relojes</div>
                  </div>
                </div>
              </div>
            </div>

            {/* Action Buttons - Movidos arriba para mejor accesibilidad */}
            <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-2 border-gray-300 rounded-xl px-8 py-5 flex justify-center gap-6 shadow-md">
              <button 
                onClick={handleNewReloj}
                className="min-w-[180px] px-8 py-5 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300"
                aria-label="Añadir nuevo reloj"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nuevo Reloj</span>
              </button>
              <button 
                onClick={() => selectedRelojInTable && handleEditReloj(selectedRelojInTable)}
                disabled={!selectedRelojInTable}
                className="min-w-[160px] px-8 py-5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 active:bg-blue-800 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-blue-300 disabled:transform-none"
                aria-label={selectedRelojInTable ? 'Editar reloj seleccionado' : 'Selecciona un reloj para editar'}
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
                <span>Editar</span>
              </button>
              <button 
                onClick={() => selectedRelojInTable && handleDeleteReloj(selectedRelojInTable.id)}
                disabled={!selectedRelojInTable}
                className="min-w-[160px] px-8 py-5 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300 disabled:transform-none"
                aria-label={selectedRelojInTable ? 'Eliminar reloj seleccionado' : 'Selecciona un reloj para eliminar'}
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
                <span>Eliminar</span>
              </button>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Left Panel - Data Grid */}
              <div className="lg:col-span-2 bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="bg-gradient-to-r from-gray-50 to-gray-100 px-6 py-4 border-b border-gray-200">
                  <div className="flex items-center justify-between">
                    <div>
                      <h4 className="font-bold text-gray-900 text-lg flex items-center gap-2">
                        <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        Lista de Relojes
                      </h4>
                      <p className="text-xs text-gray-500 mt-1 flex items-center gap-1">
                        <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Haz doble click en una fila para editar • Click simple para visualizar
                      </p>
                    </div>
                  </div>
                </div>
                <div className="overflow-x-auto">
                  {relojes.length === 0 ? (
                    <div className="text-center py-16">
                      <svg className="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <p className="text-gray-600 font-medium text-lg mb-2">No hay relojes configurados</p>
                      <p className="text-gray-500 text-sm mb-4">Crea tu primer reloj para comenzar</p>
                      <button
                        onClick={() => onNewReloj && onNewReloj()}
                        className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors inline-flex items-center gap-2"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        Crear Reloj
                      </button>
                    </div>
                  ) : (
                    <table className="w-full">
                      <thead className="bg-gray-50 border-b-2 border-gray-200">
                        <tr>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Habilitado</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Clave</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Nombre</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider"># Eventos</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Duración</th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-100">
                        {relojes.map((reloj, index) => (
                          <tr 
                            key={reloj.id} 
                            className={`${selectedRelojInTable?.id === reloj.id ? 'bg-gradient-to-r from-blue-50 to-indigo-50 border-l-4 border-blue-500 shadow-sm' : ''} hover:bg-gray-50 cursor-pointer transition-all duration-150`}
                            onClick={() => {

                              setSelectedRelojInTable(reloj);
                            }}
                            onDoubleClick={() => handleEditReloj(reloj)}
                          >
                            <td className="px-4 py-4" onClick={(e) => e.stopPropagation()}>
                              <input 
                                type="checkbox" 
                                checked={reloj.habilitado || false} 
                                onChange={(e) => {
                                  handleToggleRelojHabilitado(reloj.id, e.target.checked);
                                }}
                                className="w-5 h-5 rounded border-gray-300 text-purple-600 focus:ring-purple-500 cursor-pointer"
                              />
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <div className="w-2 h-2 rounded-full bg-purple-500"></div>
                                <span className="text-sm font-semibold text-gray-900">{reloj.clave}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <span className="text-sm font-medium text-gray-900">{reloj.nombre}</span>
                            </td>
                            <td className="px-4 py-4">
                              <div className="inline-flex items-center px-2.5 py-1 rounded-full bg-blue-100 text-blue-800 text-xs font-semibold">
                                {reloj.eventos ? reloj.eventos.length : 0} eventos
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <div className="inline-flex items-center px-2.5 py-1 rounded-full bg-green-100 text-green-800 text-xs font-semibold">
                                <svg className="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                {calculateRelojDurationLocal(reloj)}
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  )}
                </div>
              </div>

              {/* Right Panel - Clock Visualization */}
              <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="bg-gradient-to-r from-purple-50 to-indigo-50 px-5 py-4 border-b border-gray-200">
                  <h4 className="font-bold text-gray-900 text-base flex items-center gap-2">
                    <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                    Visualización del Reloj
                  </h4>
                </div>
                <div className="p-6">
                  {!selectedRelojInTable ? (
                    <div className="text-center py-12">
                      <div className="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
                        <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                      </div>
                      <p className="text-gray-600 font-medium mb-1">Selecciona un reloj</p>
                      <p className="text-gray-500 text-sm">Haz click en un reloj de la lista para ver su visualización</p>
                    </div>
                  ) : (
                    <>
                      <div className="relative w-72 h-72 mx-auto mb-6">
                        {/* Pie Chart */}
                        <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                      {/* Círculo base de 60 minutos */}
                      <circle
                        cx="50"
                        cy="50"
                        r="45"
                        fill="none"
                        stroke="#e5e7eb"
                        strokeWidth="2"
                      />
                      
                      {/* Segmentos que van llenando los 60 minutos */}
                      {(() => {
                        const totalSeconds = 3600; // 60 minutos en segundos
                        let currentAngle = 0;
                        
                        // Función helper para parsear tiempo de forma segura
                        const parseTimeSafelyHelper = (timeString) => {
                          if (!timeString || typeof timeString !== 'string') {
                            return [0, 0, 0];
                          }
                          
                          // Verificar que tenga el formato correcto (HH:MM:SS)
                          if (!/^\d{1,2}:\d{1,2}:\d{1,2}$/.test(timeString)) {
                            return [0, 0, 0];
                          }
                          
                          try {
                            return timeString.split(':').map(Number);
                          } catch (error) {

                            return [0, 0, 0];
                          }
                        };
                        
                                                  return getSelectedRelojEvents().map((event, index) => {
                            const [hours, minutes, seconds] = parseTimeSafelyHelper(event.duracion);
                          const eventDuration = hours * 3600 + minutes * 60 + seconds;
                          const angle = (eventDuration / totalSeconds) * 360;
                          
                          // Color por categoría
                          const getCategoryColor = (categoria) => {
                            const colors = {
                              'Canciones': '#3b82f6', // Azul
                              'Corte Comercial': '#ef4444', // Rojo
                              'Nota Operador': '#f59e0b', // Amarillo
                              'ETM': '#10b981', // Verde
                              'Cartucho Fijo': '#8b5cf6', // Púrpura
                              'Comando': '#6366f1', // Índigo
                              'Twofer': '#ec4899', // Rosa
                              'Característica Específica': '#84cc16' // Verde lima
                            };
                            return colors[categoria] || '#6b7280'; // Gris por defecto
                          };
                          
                          const color = getCategoryColor(event.categoria);
                          
                          // Calcular coordenadas del segmento
                          const startAngle = currentAngle;
                          const endAngle = currentAngle + angle;
                          const x1 = 50 + 45 * Math.cos(startAngle * Math.PI / 180);
                          const y1 = 50 + 45 * Math.sin(startAngle * Math.PI / 180);
                          const x2 = 50 + 45 * Math.cos(endAngle * Math.PI / 180);
                          const y2 = 50 + 45 * Math.sin(endAngle * Math.PI / 180);
                          
                          // Determinar si el arco es grande
                          const largeArcFlag = angle > 180 ? 1 : 0;
                          
                          // Crear el path del segmento que llena esa porción de los 60 minutos
                          const pathData = `M 50 50 L ${x1} ${y1} A 45 45 0 ${largeArcFlag} 1 ${x2} ${y2} Z`;
                          
                          currentAngle += angle;
                          
                          return (
                            <g key={index}>
                              <path
                                d={pathData}
                                fill={color}
                                stroke="#ffffff"
                                strokeWidth="1"
                                opacity="0.8"
                                className="cursor-pointer hover:opacity-100 transition-opacity duration-200"
                                onMouseEnter={(e) => {
                                  const tooltip = document.createElement('div');
                                  tooltip.className = 'absolute bg-black text-white text-xs px-2 py-1 rounded pointer-events-none z-50';
                                  tooltip.textContent = `${event.descripcion} (${event.duracion})`;
                                  tooltip.style.left = e.pageX + 10 + 'px';
                                  tooltip.style.top = e.pageY - 10 + 'px';
                                  document.body.appendChild(tooltip);
                                  e.target._tooltip = tooltip;
                                }}
                                onMouseLeave={(e) => {
                                  if (e.target._tooltip) {
                                    document.body.removeChild(e.target._tooltip);
                                    e.target._tooltip = null;
                                  }
                                }}
                              />
                            </g>
                          );
                        });
                      })()}
                      
                      {/* Marcadores cada 5 minutos */}
                      {Array.from({length: 12}, (_, i) => i * 5).map((minute, index) => {
                        const angle = (minute / 60) * 360;
                        const isMainMark = minute % 15 === 0; // Marcas principales cada 15 minutos
                        
                        return (
                          <g key={index}>
                            <line
                              x1={50 + 45 * Math.cos(angle * Math.PI / 180)}
                              y1={50 + 45 * Math.sin(angle * Math.PI / 180)}
                              x2={50 + (isMainMark ? 50 : 47) * Math.cos(angle * Math.PI / 180)}
                              y2={50 + (isMainMark ? 50 : 47) * Math.sin(angle * Math.PI / 180)}
                              stroke="#374151"
                              strokeWidth={isMainMark ? "2" : "1"}
                            />
                            {isMainMark && (
                              <text
                                x={50 + 55 * Math.cos(angle * Math.PI / 180)}
                                y={50 + 55 * Math.sin(angle * Math.PI / 180)}
                                textAnchor="middle"
                                dominantBaseline="middle"
                                className="text-base font-bold fill-gray-900"
                                transform={`rotate(${angle + 90}, ${50 + 55 * Math.cos(angle * Math.PI / 180)}, ${50 + 55 * Math.sin(angle * Math.PI / 180)})`}
                              >
                                {minute}
                              </text>
                            )}
                          </g>
                        );
                      })}
                      
                      {/* Círculo central */}
                      <circle
                        cx="50"
                        cy="50"
                        r="15"
                        fill="white"
                        stroke="#e5e7eb"
                        strokeWidth="1"
                      />
                    </svg>
                  </div>
                  
                      {/* Leyenda de colores mejorada */}
                      <div className="mb-6">
                        <h5 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
                          <svg className="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01" />
                          </svg>
                          Leyenda de colores
                        </h5>
                        {(() => {
                          // Obtener eventos del reloj seleccionado
                          const events = getSelectedRelojEvents();
                          
                          // Obtener categorías únicas presentes en los eventos
                          const categoriasPresentes = [...new Set(events.map(e => e.categoria))];
                          
                          // Mapa de colores para cada categoría
                          const colorMap = {
                            'Canciones': { color: 'bg-blue-500', border: 'border-blue-500',     nombre: 'Canciones' },
                            'Corte Comercial': { color: 'bg-red-500', border: 'border-red-500',     nombre: 'Corte Comercial' },
                            'Nota Operador': { color: 'bg-yellow-500', border: 'border-yellow-500',     nombre: 'Nota Operador' },
                            'ETM': { color: 'bg-green-500', border: 'border-green-500',     nombre: 'ETM' },
                            'Cartucho Fijo': { color: 'bg-purple-500', border: 'border-purple-500',     nombre: 'Cartucho Fijo' },
                            'Comando': { color: 'bg-indigo-500', border: 'border-indigo-500',     nombre: 'Comando' },
                            'Twofer': { color: 'bg-pink-500', border: 'border-pink-500',     nombre: 'Twofer' },
                            'Característica Específica': { color: 'bg-lime-500', border: 'border-lime-500',     nombre: 'Característica Específica' }
                          };
                          
                          // Filtrar solo las categorías presentes
                          const categoriasDisponibles = categoriasPresentes
                            .filter(cat => colorMap[cat])
                            .map(cat => colorMap[cat]);
                          
                          if (categoriasDisponibles.length === 0) {
                            return (
                              <div className="text-center py-4">
                                <p className="text-xs text-gray-500">No hay eventos para mostrar</p>
                              </div>
                            );
                          }
                          
                          return (
                            <div className="space-y-2">
                              {categoriasDisponibles.map((item, index) => (
                                <div key={index} className="flex items-center p-2 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors">
                                  <div className="flex items-center gap-2">
                                    <div className={`w-4 h-4 rounded-full ${item.color} border-2 ${item.border}`}></div>
                                    <span className="text-xs font-medium text-gray-700">{item.nombre}</span>
                                  </div>
                                </div>
                              ))}
                            </div>
                          );
                        })()}
                      </div>
                      
                      {/* Estadísticas mejoradas */}
                      <div className="bg-gradient-to-br from-purple-50 to-indigo-50 rounded-xl p-4 border border-purple-200">
                        <div className="space-y-3">
                          <div className="flex items-center justify-between p-2 bg-white rounded-lg shadow-sm">
                            <div className="flex items-center gap-2">
                              <svg className="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                              </svg>
                              <span className="text-sm font-medium text-gray-700">Total:</span>
                            </div>
                            <span className="text-lg font-bold text-purple-600">{getSelectedRelojEvents().length} eventos</span>
                          </div>
                          <div className="flex items-center justify-between p-2 bg-white rounded-lg shadow-sm">
                            <div className="flex items-center gap-2">
                              <svg className="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                              </svg>
                              <span className="text-sm font-medium text-gray-700">Duración:</span>
                            </div>
                            <span className="text-lg font-bold text-green-600">{getSelectedRelojDuration()}</span>
                          </div>
                          <div className="mt-3 pt-3 border-t border-purple-200">
                            <div className="text-xs text-gray-600 text-center">
                              <span className="font-semibold">{selectedRelojInTable?.nombre || 'Sin nombre'}</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </>
                  )}
                </div>
              </div>
            </div>
          </div>
        );

      case 4: // Días modelo
        return (
          <div className="space-y-6">
            {/* Header Mejorado */}
            <div className="bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-50 rounded-2xl p-6 border border-indigo-200 shadow-sm">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-3 bg-indigo-600 rounded-xl shadow-md">
                    <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div>
                    <h3 className="text-2xl font-bold text-gray-900">Días Modelo</h3>
                    <p className="text-sm text-gray-600 mt-1">Configuración de días modelo para la programación</p>
                  </div>
                </div>
                <div className="bg-white rounded-xl px-4 py-3 shadow-sm border border-gray-200 text-center">
                  <div className="text-2xl font-bold text-indigo-600">{diasModelo?.length || 0}</div>
                  <div className="text-xs text-gray-600 uppercase tracking-wide">Días modelo</div>
                </div>
              </div>
            </div>

            {/* Action Buttons - Mejorados */}
            <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-2 border-gray-300 rounded-xl px-8 py-5 flex justify-center gap-6 shadow-md">
              <button
                onClick={() => handleNewDiaModeloLocal()}
                className="min-w-[160px] px-8 py-5 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
                disabled={isReadOnly}
                aria-label="Añadir nuevo día modelo"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nuevo Día Modelo</span>
              </button>
              <button
                onClick={() => selectedDiaModeloInTable && handleViewDiaModeloLocal(selectedDiaModeloInTable)}
                disabled={!selectedDiaModeloInTable}
                className="min-w-[160px] px-8 py-5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 active:bg-blue-800 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-blue-300 disabled:transform-none"
                aria-label={selectedDiaModeloInTable ? 'Consultar día modelo seleccionado' : 'Selecciona un día modelo para consultar'}
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
                <span>Consultar</span>
              </button>
              <button
                onClick={() => selectedDiaModeloInTable && handleEditDiaModeloLocal(selectedDiaModeloInTable)}
                disabled={!selectedDiaModeloInTable || isReadOnly}
                className="min-w-[160px] px-8 py-5 bg-purple-600 text-white rounded-xl hover:bg-purple-700 active:bg-purple-800 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-purple-300 disabled:transform-none"
                aria-label={selectedDiaModeloInTable ? 'Editar día modelo seleccionado' : 'Selecciona un día modelo para editar'}
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
                <span>Editar</span>
              </button>
              <button
                onClick={() => {
                  if (selectedDiaModeloInTable && window.confirm(`¿Está seguro de eliminar el día modelo "${selectedDiaModeloInTable.nombre || selectedDiaModeloInTable.clave}"?`)) {
                    handleDeleteDiaModelo(selectedDiaModeloInTable);
                  }
                }}
                disabled={!selectedDiaModeloInTable || isReadOnly}
                className="min-w-[160px] px-8 py-5 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300 disabled:transform-none"
                aria-label={selectedDiaModeloInTable ? 'Eliminar día modelo seleccionado' : 'Selecciona un día modelo para eliminar'}
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
                <span>Eliminar</span>
              </button>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
              {/* Left/Center Panel - Días Modelo Table */}
              <div className="xl:col-span-2 bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="bg-gradient-to-r from-gray-50 to-gray-100 px-6 py-4 border-b border-gray-200">
                  <div className="flex items-center justify-between">
                    <div>
                      <h4 className="font-bold text-gray-900 text-lg flex items-center gap-2">
                        <svg className="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        Lista de Días Modelo
                      </h4>
                      <p className="text-xs text-gray-500 mt-1 flex items-center gap-1">
                        <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Haz doble click en una fila para editar • Click simple para seleccionar
                      </p>
                    </div>
                  </div>
                </div>
                <div className="overflow-x-auto">
                  {diasModelo.length === 0 ? (
                    <div className="text-center py-16">
                      <svg className="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      <p className="text-gray-600 font-medium text-lg mb-2">No hay días modelo configurados</p>
                      <p className="text-gray-500 text-sm mb-4">Crea tu primer día modelo para comenzar</p>
                      <button
                        onClick={() => handleNewDiaModeloLocal()}
                        disabled={isReadOnly}
                        className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors inline-flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        Crear Día Modelo
                      </button>
                    </div>
                  ) : (
                    <table className="w-full">
                      <thead className="bg-gray-50 border-b-2 border-gray-200">
                        <tr>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Habilitado</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Clave</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Nombre</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Días</th>
                          <th className="px-4 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Descripción</th>
                        </tr>
                      </thead>
                      <tbody className="bg-white divide-y divide-gray-100">
                        {diasModelo.map((diaModelo, index) => (
                          <tr 
                            key={diaModelo.id || index} 
                            className={`${selectedDiaModeloInTable?.id === diaModelo.id ? 'bg-gradient-to-r from-indigo-50 to-purple-50 border-l-4 border-indigo-500 shadow-sm' : ''} hover:bg-gray-50 cursor-pointer transition-all duration-150`}
                            onClick={() => {
                              setSelectedDiaModeloInTable(diaModelo);
                            }}
                            onDoubleClick={() => handleEditDiaModeloLocal(diaModelo)}
                          >
                            <td className="px-4 py-4" onClick={(e) => e.stopPropagation()}>
                              <input
                                type="checkbox"
                                checked={diaModelo.habilitado || false}
                                onChange={(e) => {
                                  if (handleToggleDiaModeloHabilitado && diaModelo.id) {
                                    handleToggleDiaModeloHabilitado(diaModelo.id, e.target.checked);
                                  }
                                }}
                                disabled={isReadOnly}
                                className="w-5 h-5 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 cursor-pointer"
                              />
                            </td>
                            <td className="px-4 py-4">
                              <div className="flex items-center gap-2">
                                <div className="w-2 h-2 rounded-full bg-indigo-500"></div>
                                <span className="text-sm font-semibold text-gray-900">{diaModelo.clave}</span>
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <span className="text-sm font-medium text-gray-900">{diaModelo.nombre}</span>
                            </td>
                            <td className="px-4 py-4">
                              <div className="inline-flex items-center gap-1">
                                {[
                                  diaModelo.lunes && { label: 'L', color: 'bg-blue-100 text-blue-800' },
                                  diaModelo.martes && { label: 'M', color: 'bg-blue-100 text-blue-800' },
                                  diaModelo.miercoles && { label: 'X', color: 'bg-blue-100 text-blue-800' },
                                  diaModelo.jueves && { label: 'J', color: 'bg-blue-100 text-blue-800' },
                                  diaModelo.viernes && { label: 'V', color: 'bg-blue-100 text-blue-800' },
                                  diaModelo.sabado && { label: 'S', color: 'bg-purple-100 text-purple-800' },
                                  diaModelo.domingo && { label: 'D', color: 'bg-purple-100 text-purple-800' }
                                ].filter(Boolean).map((dia, idx) => (
                                  <span key={idx} className={`px-2 py-1 rounded-full text-xs font-semibold ${dia.color}`}>
                                    {dia.label}
                                  </span>
                                ))}
                              </div>
                            </td>
                            <td className="px-4 py-4">
                              <span className="text-sm text-gray-600 line-clamp-2" title={diaModelo.descripcion}>
                                {diaModelo.descripcion || <span className="text-gray-400 italic">Sin descripción</span>}
                              </span>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  )}
                </div>
              </div>

              {/* Right Panel - Día Modelo Configuration Mejorado */}
              <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
                <div className="bg-gradient-to-r from-indigo-50 to-purple-50 px-6 py-4 border-b border-gray-200">
                  <h4 className="font-bold text-gray-900 text-base flex items-center gap-2">
                    <svg className="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    Día Modelo por Defecto
                  </h4>
                  <p className="text-xs text-gray-600 mt-1">Configura el día modelo predeterminado para cada día de la semana</p>
                </div>
                <div className="p-6 space-y-4">
                  {[
                    { key: 'lunes', label: 'Lunes' },
                    { key: 'martes', label: 'Martes' },
                    { key: 'miercoles', label: 'Miércoles' },
                    { key: 'jueves', label: 'Jueves' },
                    { key: 'viernes', label: 'Viernes' },
                    { key: 'sabado', label: 'Sábado' },
                    { key: 'domingo', label: 'Domingo' }
                  ].map((dia) => {
                    const selectedDiaModelo = diasModelo.find(dm => String(dm.id) === String(formData[dia.key]));
                    return (
                      <div key={dia.key} className="group">
                        <label className="block text-sm font-semibold text-gray-700 mb-2">
                          {dia.label}
                        </label>
                        <div className="relative">
                          <select
                            value={formData[dia.key] || ''}
                            onChange={(e) => {
                              setFormData(prev => ({
                                ...prev,
                                [dia.key]: e.target.value
                              }));
                            }}
                            className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 pr-10 appearance-none bg-white hover:border-gray-400 transition-colors text-sm font-medium"
                            disabled={isReadOnly}
                          >
                            <option value="">Seleccionar día modelo</option>
                            {diasModelo.map((diaModelo) => (
                              <option key={diaModelo.id} value={diaModelo.id}>
                                {diaModelo.nombre || diaModelo.clave}
                              </option>
                            ))}
                          </select>
                          <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                            <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                            </svg>
                          </div>
                        </div>
                        {selectedDiaModelo && (
                          <div className="mt-2 px-3 py-2 bg-indigo-50 rounded-lg border border-indigo-200">
                            <div className="flex items-center gap-2">
                              <div className="w-2 h-2 rounded-full bg-indigo-500"></div>
                              <span className="text-xs text-indigo-700 font-medium">{selectedDiaModelo.clave}</span>
                              {selectedDiaModelo.descripcion && (
                                <span className="text-xs text-indigo-600 truncate">• {selectedDiaModelo.descripcion}</span>
                              )}
                            </div>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200"
      onClick={(e) => e.target === e.currentTarget && onCancel()}
    >
      <div 
        className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-[95vw] max-w-[1400px] h-[92vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Enhanced Header */}
        <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 relative overflow-hidden border-b border-blue-800/20">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
          <div className="relative z-10 flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                </svg>
              </div>
              <h1 className="text-2xl font-bold text-white">{title}</h1>
            </div>
            <button
              onClick={onCancel}
              className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110"
              title="Cerrar"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          {/* Efecto de partículas decorativas */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
          <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
        </div>

        {/* Enhanced Tabs Navigation */}
        <div className="bg-white border-b border-gray-200">
          <div className="flex space-x-1 overflow-x-auto px-4">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`group flex items-center space-x-2 px-4 py-3 text-sm font-semibold whitespace-nowrap transition-all duration-200 relative ${
                  activeTab === tab.id
                    ? "text-blue-700 bg-blue-50 border-b-2 border-blue-600"
                    : "text-gray-600 hover:text-blue-600 hover:bg-blue-50/50"
                }`}
              >
                {tab.icon}
                <span>{tab.name}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Enhanced Form Content */}
        <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
          {renderTabContent()}
        </div>
        
        {/* Footer with Action Buttons - Mejorado para Accesibilidad */}
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end gap-4 shadow-inner">
          <button
            type="button"
            onClick={onCancel}
            disabled={isLoading}
            className="min-w-[140px] px-8 py-4 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300"
            aria-label="Cerrar formulario"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
            </svg>
            <span>Cerrar</span>
          </button>
          
          {!isReadOnly && (
            <button
              type="button"
              onClick={handleSubmit}
              disabled={isLoading}
              className="min-w-[140px] px-8 py-4 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300"
              aria-label={isLoading ? 'Guardando cambios' : 'Guardar y aceptar cambios'}
            >
              {isLoading ? (
                <div className="w-5 h-5 border-[3px] border-white border-t-transparent rounded-full animate-spin"></div>
              ) : (
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                </svg>
              )}
              <span>{isLoading ? 'Guardando...' : 'Aceptar'}</span>
            </button>
          )}
        </div>
      </div>

      {/* Modal para Día Modelo */}
      {showDiaModeloForm && (
        <DiaModeloForm
          diaModelo={editingDiaModeloIndex !== null ? diasModelo.find(dm => dm.id === editingDiaModeloIndex) : null}
          mode={editingDiaModeloIndex !== null ? 'edit' : 'new'}
          relojes={relojes}
          diasModeloExistentes={diasModelo}
          onSave={async (diaModeloData) => {
            try {
              if (editingDiaModeloIndex !== null) {
                // Editar día modelo existente - usar el ID del día modelo
                const diaModeloToEdit = diasModelo.find(dm => dm.id === editingDiaModeloIndex);
                if (diaModeloToEdit) {
                  await handleSaveDiaModelo(diaModeloData, diaModeloToEdit.id);
                } else {
                  throw new Error('No se encontró el día modelo a editar');
                }
              } else {
                // Agregar nuevo día modelo
                await handleSaveDiaModelo(diaModeloData);
              }
              setShowDiaModeloForm(false);
              setEditingDiaModeloIndex(null);
            } catch (error) {

            }
          }}
          onCancel={() => {
            setShowDiaModeloForm(false);
            setEditingDiaModeloIndex(null);
          }}
        />
      )}

      {/* Modal Independiente de Nueva Regla */}

      {showReglaForm && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200">

          <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-[95vw] max-w-[1400px] h-[92vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100">
            {/* Enhanced Header */}
            <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 relative overflow-hidden border-b border-blue-800/20">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
              <div className="relative z-10 flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                    <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                    </svg>
                  </div>
                  <h2 className="text-2xl font-bold text-white">
                    {reglaFormMode === 'new' ? 'Nueva Regla de Programación' : 
                     reglaFormMode === 'edit' ? 'Editar Regla de Programación' : 
                     'Consultar Regla de Programación'}
                  </h2>
                </div>
                <button
                  onClick={handleReglaCancel}
                  className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110"
                  title="Cerrar"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              {/* Efecto de partículas decorativas */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
              <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
            </div>

            {/* Enhanced Form Content */}
            <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
                <div className="space-y-6">

                  {/* Parámetros */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">Parámetros</label>
                    <div className="space-y-2">
                      <select 
                        value={reglaFormData.tipoRegla}
                        onChange={(e) => handleReglaFormChange('tipoRegla', e.target.value)}
                        className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                      >
                        <option value="">Seleccione el tipo de regla</option>
                        <option value="Separación Mínima">Separación Mínima</option>
                        <option value="DayPart">DayPart</option>
                        <option value="Protección de Días Anteriores">Protección de Días Anteriores</option>
                        <option value="Máxima Diferencia Permitida">Máxima Diferencia Permitida</option>
                        <option value="Mínima Diferencia Permitida">Mínima Diferencia Permitida</option>
                        <option value="Canciones máximas en un periodo">Canciones máximas en un periodo</option>
                        <option value="Máximo de Canciones en Hilera">Máximo de Canciones en Hilera</option>
                        <option value="Protección de Secuencias">Protección de Secuencias</option>
                      </select>
                    </div>
                    
                  </div>


                  {/* Regla Habilitada */}
                  <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm">
                    <input 
                      type="checkbox" 
                      checked={reglaFormData.reglaHabilitada}
                      onChange={(e) => handleReglaFormChange('reglaHabilitada', e.target.checked)}
                      className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer" 
                    />
                    <label className="text-base font-semibold text-gray-700 cursor-pointer">Regla Habilitada</label>
                  </div>


                  {/* Característica Detalle */}
                  <div>
                    <label className="block text-sm font-bold text-gray-700 mb-2">Característica</label>
                    <select 
                      value={reglaFormData.caracteristicaDetalle}
                      onChange={(e) => handleReglaFormChange('caracteristicaDetalle', e.target.value)}
                      className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                    >
                      <option value="">Seleccionar característica...</option>
                      <option value="id_cancion">ID de Canción</option>
                      <option value="artista">Artista/Intérprete</option>
                      <option value="titulo">Título de la Canción</option>
                      <option value="album">Álbum</option>
                      <option value="genero">Género</option>
                      <option value="año">Año</option>
                      <option value="duracion">Duración</option>
                      <option value="bpm">BPM</option>
                      <option value="sello_discografico">Sello Discográfico</option>
                      <option value="categoria">Categoría</option>
                      <option value="subcategoria">Subcategoría</option>
                      <option value="idioma">Idioma</option>
                      <option value="pais">País</option>
                      <option value="formato">Formato</option>
                      <option value="calidad">Calidad</option>
                    </select>
                  </div>

                  {/* Horario */}
                  <div className="space-y-3">
                    <div className="flex items-center space-x-3">
                      <input 
                        type="checkbox" 
                        checked={reglaFormData.horario}
                        onChange={(e) => handleReglaFormChange('horario', e.target.checked)}
                        className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded" 
                      />
                      <label className="text-sm font-medium text-gray-700">Horario</label>
                    </div>
                    
                    {reglaFormData.horario && (
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-bold text-gray-700 mb-2">Hora Inicial</label>
                          <input 
                            type="time" 
                            value={reglaFormData.horaInicial}
                            onChange={(e) => handleReglaFormChange('horaInicial', e.target.value)}
                            className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                          />
                        </div>
                        <div>
                          <label className="block text-sm font-bold text-gray-700 mb-2">Hora Final</label>
                          <input 
                            type="time" 
                            value={reglaFormData.horaFinal}
                            onChange={(e) => handleReglaFormChange('horaFinal', e.target.value)}
                            className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                          />
                        </div>
                      </div>
                    )}
                  </div>

                  {/* Parámetros Generales */}
                  <div className="space-y-3">
                    <h4 className="text-sm font-medium text-gray-700">Parámetros Generales</h4>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Tipo Separación</label>
                        <select 
                          value={reglaFormData.tipoSeparacion}
                          onChange={(e) => handleReglaFormChange('tipoSeparacion', e.target.value)}
                          className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 bg-white text-gray-900 hover:border-gray-400"
                        >
                          <option value="">Seleccionar tipo...</option>
                          <option value="numero_eventos">Número de Eventos</option>
                          <option value="numero_canciones">Número de Canciones</option>
                          <option value="tiempo_segundos">Tiempo - Segundos</option>
                          <option value="tiempo_dd_hh_mm">Tiempo - DD:HH:MM</option>
                        </select>
                      </div>
                      <div className="flex items-center space-x-3">
                        <input 
                          type="checkbox" 
                          checked={reglaFormData.soloVerificarDia}
                          onChange={(e) => handleReglaFormChange('soloVerificarDia', e.target.checked)}
                          className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded" 
                        />
                        <label className="text-sm font-medium text-gray-700">Sólo verificar el día que se esté programando</label>
                      </div>
                    </div>
                  </div>

                  {/* Descripción */}
                  <div className="space-y-3">
                    <h4 className="text-sm font-medium text-gray-700">Descripción</h4>
                    <div>
                      <textarea
                        value={reglaFormData.descripcion}
                        onChange={(e) => handleReglaFormChange('descripcion', e.target.value)}
                        placeholder="Ingrese una descripción para la regla..."
                        className="w-full px-3 py-2 border border-gray-300 rounded-md resize-none"
                        rows={3}
                      />
                    </div>
                  </div>

                  {/* Tabla de Separaciones */}
                  <div>
                    <h4 className="text-sm font-medium text-gray-700 mb-3">Separaciones</h4>
                    <div className="border border-gray-200 rounded-lg overflow-hidden">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-50">
                          <tr>
                            <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Valor</th>
                            <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Separación</th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {reglaFormData.separaciones.map((sep, index) => (
                            <tr key={index}>
                              <td className="px-4 py-2">
                                <select 
                                  value={sep.valor}
                                  onChange={(e) => handleSeparacionChange(index, 'valor', e.target.value)}
                                  className="w-full px-3 py-1 border border-gray-300 rounded-md text-sm"
                                >
                                  <option value="">Seleccionar valor...</option>
                                  <option value="todos">Todos los valores</option>
                                  <option value="artista_1">Artista 1</option>
                                  <option value="artista_2">Artista 2</option>
                                  <option value="artista_3">Artista 3</option>
                                  <option value="artista_4">Artista 4</option>
                                  <option value="artista_5">Artista 5</option>
                                  <option value="artista_6">Artista 6</option>
                                  <option value="artista_7">Artista 7</option>
                                  <option value="artista_8">Artista 8</option>
                                  <option value="artista_9">Artista 9</option>
                                  <option value="artista_10">Artista 10</option>
                                </select>
                              </td>
                              <td className="px-4 py-2">
                                <input 
                                  type="text" 
                                  value={sep.separacion && sep.separacion !== 0 ? `${sep.separacion} seg` : ''}
                                  onChange={(e) => {
                                    const value = e.target.value.replace(' seg', '');
                                    handleSeparacionChange(index, 'separacion', parseInt(value) || 0);
                                  }}
                                  className="w-full px-3 py-1 border border-gray-300 rounded-md text-sm"
                                  placeholder="0 seg"
                                />
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                      <div className="px-4 py-2 bg-gray-50 border-t border-gray-200">
                        <button 
                          onClick={addSeparacion}
                          className="text-blue-600 hover:text-blue-800 text-sm"
                        >
                          Click here to add a new row
                        </button>
                      </div>
                      
                    </div>
                  </div>
                </div>
            </div>

            {/* Footer - Mejorado para Accesibilidad */}
            <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end gap-4 shadow-inner">
              <button
                onClick={handleReglaCancel}
                className="min-w-[140px] px-8 py-4 bg-red-600 text-white rounded-xl hover:bg-red-700 active:bg-red-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-red-300"
                aria-label="Cerrar formulario de regla"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
                </svg>
                <span>Cerrar</span>
              </button>
              {reglaFormMode !== 'view' && (
                <button
                  onClick={handleReglaSave}
                  className="min-w-[140px] px-8 py-4 bg-green-600 text-white rounded-xl hover:bg-green-700 active:bg-green-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3 font-semibold text-base shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-green-300"
                  aria-label={reglaFormMode === 'new' ? 'Crear nueva regla' : 'Guardar cambios de la regla'}
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                  </svg>
                  <span>Aceptar</span>
                </button>
              )}
            </div>
          </div>
        </div>
      )}

    </div>
  );
}

// DiaModeloForm Component
function DiaModeloForm({ diaModelo, mode, relojes, onSave, onCancel, diasModeloExistentes = [] }) {
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const [activeTab, setActiveTab] = useState(0);

  const [formData, setFormData] = useState({
    habilitado: diaModelo?.habilitado ?? true,
    difusora: diaModelo?.difusora || '', // Sin valor por defecto
    clave: diaModelo?.clave || '',
    nombre: diaModelo?.nombre || '',
    descripcion: diaModelo?.descripcion || '',
    lunes: diaModelo?.lunes ?? false,
    martes: diaModelo?.martes ?? false,
    miercoles: diaModelo?.miercoles ?? false,
    jueves: diaModelo?.jueves ?? false,
    viernes: diaModelo?.viernes ?? false,
    sabado: diaModelo?.sabado ?? false,
    domingo: diaModelo?.domingo ?? false
  });

  // Estado para los relojes del día modelo
  const [relojesDiaModelo, setRelojesDiaModelo] = useState([]);

  // Cargar relojes existentes cuando se edita un día modelo
  useEffect(() => {
    if (diaModelo && diaModelo.relojes && Array.isArray(diaModelo.relojes)) {
      // En edición, completar datos del backend con los relojes completos recibidos en props
      const merged = diaModelo.relojes.map((r) => {
        const full = relojes.find(x => (x.id && r.id && x.id === r.id) || (x.clave && r.clave && x.clave === r.clave))
        return full ? { ...r, ...full } : r
      })
      setRelojesDiaModelo(merged);
    } else {
      setRelojesDiaModelo([]);
    }
  }, [diaModelo, mode, relojes]);

  // Estado para la búsqueda de relojes
  const [relojSearchTerm, setRelojSearchTerm] = useState('');

  // Filtrar relojes basado en el término de búsqueda
  const filteredRelojes = relojes.filter(reloj => {
    const searchTerm = relojSearchTerm.toLowerCase();
    return (
      reloj.nombre?.toLowerCase().includes(searchTerm) ||
      reloj.clave?.toLowerCase().includes(searchTerm) ||
      reloj.numeroRegla?.toLowerCase().includes(searchTerm)
    );
  });


  const isReadOnly = mode === 'view';
  const title = mode === 'new' ? 'Nuevo Día Modelo' : 
               mode === 'edit' ? 'Editar Día Modelo' : 
               'Consultar Día Modelo';

  // Mock data
  const difusoras = [
    { value: 'XRAD', label: 'XRAD' },
    { value: 'XHPER', label: 'XHPER' },
    { value: 'XHGR', label: 'XHGR' },
    { value: 'XHOZ', label: 'XHOZ' }
  ];

  const politicas = [
    { value: 'DIARIO', label: 'Política Diaria' },
    { value: 'SEMANAL', label: 'Política Semanal' },
    { value: 'ESPECIAL', label: 'Política Especial' }
  ];

  const tabs = [
    { 
      id: 0, 
      name: 'Datos generales', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      )
    },
    { 
      id: 1, 
      name: 'Relojes que forman el día modelo', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      )
    }
  ];

  const inputClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;
  const selectClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;

  const validateForm = () => {
    const newErrors = {};
    if (!formData.difusora) newErrors.difusora = 'La difusora es requerida';
    if (!formData.clave) newErrors.clave = 'La clave es requerida';
    if (!formData.nombre) newErrors.nombre = 'El nombre es requerido';
    
    // Verificar que al menos un reloj esté seleccionado
    if (relojesDiaModelo.length === 0) {
      newErrors.relojes = 'Debe seleccionar al menos un reloj para el día modelo';
    }
    
    // Verificar nombres duplicados dentro de la misma política
    if (formData.nombre && formData.nombre.trim()) {
      const nombreExistente = diasModeloExistentes.find(dm => 
        dm.nombre.toLowerCase() === formData.nombre.toLowerCase() && 
        dm.id !== diaModelo?.id // Excluir el día modelo actual si estamos editando
      );
      
      if (nombreExistente) {
        newErrors.nombre = 'Ya existe un día modelo con este nombre en la política';
      }
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async () => {
    if (!validateForm()) return;
    
    setIsLoading(true);
    try {
      // Incluir los relojes seleccionados en los datos
      const dataToSave = {
        ...formData,
        relojes: relojesDiaModelo.map(reloj => reloj.id)
      };
      

      await onSave(dataToSave);

    } catch (error) {

    } finally {
      setIsLoading(false);
    }
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
    
    // Validación en tiempo real para nombres duplicados
    if (name === 'nombre' && value && value.trim()) {
      const nombreExistente = diasModeloExistentes.find(dm => 
        dm.nombre.toLowerCase() === value.toLowerCase() && 
        dm.id !== diaModelo?.id
      );
      
      if (nombreExistente) {
        setErrors(prev => ({
          ...prev,
          nombre: 'Ya existe un día modelo con este nombre en la política'
        }));
      } else {
        setErrors(prev => {
          const newErrors = { ...prev };
          delete newErrors.nombre;
          return newErrors;
        });
      }
    }
  };

  // Helper para obtener eventos completos de un reloj
  const getRelojEventos = (reloj) => {
    const fullReloj = relojes.find(x => 
      (x.id && reloj.id && x.id === reloj.id) || 
      (x.clave && reloj.clave && x.clave === reloj.clave)
    );
    return fullReloj?.eventos || reloj.eventos || [];
  };

  // Helper para contar canciones (música)
  const countCanciones = (reloj) => {
    const eventos = getRelojEventos(reloj);
    return eventos.filter(e => e.categoria === 'Canciones').length;
  };

  // Helper para contar eventos que NO son música
  const countEventosNoMusica = (reloj) => {
    const eventos = getRelojEventos(reloj);
    return eventos.filter(e => e.categoria !== 'Canciones').length;
  };

  // Helper para calcular duración total en segundos desde formato HH:MM:SS
  const parseDurationToSeconds = (durationStr) => {
    if (!durationStr) return 0;
    
    // Si es un número, ya está en segundos
    if (typeof durationStr === 'number') {
      return durationStr;
    }
    
    // Si es string con formato HH:MM:SS
    if (typeof durationStr === 'string' && durationStr.includes(':')) {
      const parts = durationStr.split(':');
      if (parts.length === 3) {
        const hours = parseInt(parts[0], 10) || 0;
        const minutes = parseInt(parts[1], 10) || 0;
        const seconds = parseInt(parts[2], 10) || 0;
        return hours * 3600 + minutes * 60 + seconds;
      }
    }
    
    // Si es string numérico, tratar como segundos
    if (typeof durationStr === 'string') {
      return parseInt(durationStr, 10) || 0;
    }
    
    return 0;
  };

  // Helper para formatear segundos a HH:MM:SS
  const formatSecondsToTime = (totalSeconds) => {
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  };

  // Función para calcular la duración total de un reloj basándose en sus eventos
  const calculateRelojDuration = (reloj) => {
    if (!reloj || !reloj.eventos || reloj.eventos.length === 0) {
      return '00:00:00';
    }
    
    let totalSeconds = 0;
    reloj.eventos.forEach(evento => {
      totalSeconds += parseDurationToSeconds(evento.duracion);
    });
    
    return formatSecondsToTime(totalSeconds);
  };

  // Helper para calcular duración total de eventos por categoría
  const calculateDuracionByCategoria = (reloj, categoria) => {
    const eventos = getRelojEventos(reloj);
    const eventosFiltrados = eventos.filter(e => e.categoria === categoria);
    const totalSeconds = eventosFiltrados.reduce((acc, e) => {
      return acc + parseDurationToSeconds(e.duracion);
    }, 0);
    return formatSecondsToTime(totalSeconds);
  };

  // Helper para calcular duración total de eventos que NO son música
  const calculateDuracionNoMusica = (reloj) => {
    const eventos = getRelojEventos(reloj);
    const eventosNoMusica = eventos.filter(e => e.categoria !== 'Canciones');
    const totalSeconds = eventosNoMusica.reduce((acc, e) => {
      return acc + parseDurationToSeconds(e.duracion);
    }, 0);
    return formatSecondsToTime(totalSeconds);
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 0: // Datos generales
        return (
          <div className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Checkbox: Día modelo habilitado - Mejorado */}
              <div className="md:col-span-2">
                <div className="flex items-center space-x-4 p-5 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-all duration-200 shadow-sm hover:shadow-md">
                  <div className="relative">
                    <input
                      type="checkbox"
                      id="habilitado"
ame="habilitado"
                      checked={formData.habilitado}
                      onChange={handleChange}
                      disabled={isReadOnly}
                      className="h-6 w-6 text-blue-600 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 border-gray-300 rounded-md transition-all cursor-pointer disabled:cursor-not-allowed"
                    />
                  </div>
                  <label htmlFor="habilitado" className="flex items-center space-x-2 text-base font-semibold text-gray-700 cursor-pointer">
                    <svg className="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span>Día modelo habilitado</span>
                  </label>
                </div>
              </div>


              {/* Input: Clave - Mejorado */}
              <div className="space-y-2">
                <label className="flex items-center space-x-2 text-sm font-semibold text-gray-700">
                  <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                  </svg>
                  <span>Clave</span>
                  <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
ame="clave"
                  value={formData.clave || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  className={`${inputClass} transition-all duration-200 ${errors.clave ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'hover:border-blue-300'}`}
                  placeholder="Ej: DM_LUNES"
                  required={!isReadOnly}
                />
                {errors.clave && (
                  <p className="flex items-center space-x-1 text-red-500 text-xs mt-1">
                    <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                    </svg>
                    <span>{errors.clave}</span>
                  </p>
                )}
              </div>

              {/* Input: Nombre - Mejorado */}
              <div className="space-y-2">
                <label className="flex items-center space-x-2 text-sm font-semibold text-gray-700">
                  <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 8h10M7 12h10m-7 4h7" />
                  </svg>
                  <span>Nombre</span>
                  <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
ame="nombre"
                  value={formData.nombre || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  className={`${inputClass} transition-all duration-200 ${errors.nombre ? 'border-red-400 focus:border-red-500 focus:ring-red-500' : 'hover:border-blue-300'}`}
                  placeholder="Ej: Lunes"
                  required={!isReadOnly}
                />
                {errors.nombre && (
                  <p className="flex items-center space-x-1 text-red-500 text-xs mt-1">
                    <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                    </svg>
                    <span>{errors.nombre}</span>
                  </p>
                )}
              </div>

              {/* Textarea: Descripción - Mejorado */}
              <div className="md:col-span-2 space-y-2">
                <label className="flex items-center space-x-2 text-sm font-semibold text-gray-700">
                  <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h7" />
                  </svg>
                  <span>Descripción</span>
                </label>
                <textarea
ame="descripcion"
                  value={formData.descripcion || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  rows={4}
                  className={`${inputClass} transition-all duration-200 resize-none hover:border-blue-300`}
                  placeholder="Describe el propósito y características de este día modelo..."
                />
              </div>

            </div>
          </div>
        );

      case 1: // Relojes que forman el día modelo
        return (
          <div className="h-full flex flex-col space-y-4">
            {/* Header */}
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-semibold text-gray-900">Relojes que forman el día modelo</h3>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 xl:grid-cols-3 gap-4 flex-1">
              {/* Left Panel - Relojes disponibles */}
              <div className="xl:col-span-1 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div className="p-4 border-b border-gray-200">
                  <h4 className="font-medium text-gray-900">Relojes</h4>
                </div>
                <div className="overflow-x-auto max-h-96">
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Clave</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duración</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"># Eventos</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">¡Sin</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {relojes.length === 0 ? (
                        <tr>
                          <td colSpan="4" className="px-6 py-12 text-center">
                            <div className="flex flex-col items-center space-y-2">
                              <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                              </svg>
                              <p className="text-gray-500 font-medium">No hay relojes disponibles</p>
                            </div>
                          </td>
                        </tr>
                      ) : (
                        relojes.map((reloj, index) => (
                          <tr key={reloj.id || index} className="hover:bg-gray-50">
                            <td className="px-3 py-2 text-sm text-gray-900">{reloj.clave}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{calculateRelojDuration(reloj)}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{(reloj.eventos?.length) ?? (relojes.find(x=>x.id===reloj.id)?.eventos?.length) ?? 0}</td>
                            <td className="px-3 py-2">
                              <input
                                type="checkbox"
                                checked={relojesDiaModelo.some(r => r.id === reloj.id)}
                                onChange={(e) => {
                                  if (e.target.checked) {
                                    setRelojesDiaModelo(prev => [...prev, reloj]);
                                  } else {
                                    setRelojesDiaModelo(prev => prev.filter(r => r.id !== reloj.id));
                                  }
                                }}
                                disabled={isReadOnly}
                                className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                              />
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Right Panel - Estructura del día modelo */}
              <div className="xl:col-span-2 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div className="p-4 border-b border-gray-200 flex justify-between items-center">
                  <h4 className="font-medium text-gray-900">Estructura del Día Modelo</h4>
                  <button
                    className="px-3 py-1 bg-gray-100 text-gray-700 rounded hover:bg-gray-200 transition-colors text-sm"
                    disabled={isReadOnly}
                  >
                    Acciones
                  </button>
                </div>
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Offset</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Clave</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Descripción</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duración</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Eventos</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Música</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Otros</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {relojesDiaModelo.length === 0 ? (
                        <tr>
                          <td colSpan="8" className="px-6 py-12 text-center">
                            <div className="flex flex-col items-center space-y-2">
                              <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                              </svg>
                              <p className="text-gray-500 font-medium">No hay información para mostrar</p>
                            </div>
                          </td>
                        </tr>
                      ) : (
                        relojesDiaModelo.map((reloj, index) => (
                          <tr key={reloj.id || index} className="hover:bg-gray-50">
                            <td className="px-3 py-2 text-sm text-gray-900">{index + 1}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">0:00:00</td>
                            <td className="px-3 py-2 text-sm text-gray-900">{reloj.clave}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{reloj.nombre || reloj.descripcion || '-'}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{calculateRelojDuration(reloj)}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{(reloj.eventos?.length) ?? (relojes.find(x=>x.id===reloj.id)?.eventos?.length) ?? 0}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">
                              {countCanciones(reloj)} ({calculateDuracionByCategoria(reloj, 'Canciones')})
                            </td>
                            <td className="px-3 py-2 text-sm text-gray-500">
                              {countEventosNoMusica(reloj)} ({calculateDuracionNoMusica(reloj)})
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            {/* Footer Summary */}
            <div className="bg-gray-50 border-t border-gray-200 px-4 py-3">
              <div className="flex justify-between items-center text-sm text-gray-600">
                <div>
                  <span className="font-medium">
                    {relojesDiaModelo.length} relojes, {relojesDiaModelo.reduce((acc, r) => acc + getRelojEventos(r).length, 0)} eventos
                  </span>
                </div>
                <div className="flex space-x-4">
                  <span>
                    Música: {relojesDiaModelo.reduce((acc, r) => acc + countCanciones(r), 0)} - {
                      formatSecondsToTime(
                        relojesDiaModelo.reduce((acc, r) => {
                          const eventos = getRelojEventos(r);
                          const eventosMusica = eventos.filter(e => e.categoria === 'Canciones');
                          const totalSeconds = eventosMusica.reduce((sum, e) => sum + parseDurationToSeconds(e.duracion), 0);
                          return acc + totalSeconds;
                        }, 0)
                      )
                    }
                  </span>
                  <span>
                    Otros: {relojesDiaModelo.reduce((acc, r) => acc + countEventosNoMusica(r), 0)} - {
                      formatSecondsToTime(
                        relojesDiaModelo.reduce((acc, r) => {
                          const eventos = getRelojEventos(r);
                          const eventosNoMusica = eventos.filter(e => e.categoria !== 'Canciones');
                          const totalSeconds = eventosNoMusica.reduce((sum, e) => sum + parseDurationToSeconds(e.duracion), 0);
                          return acc + totalSeconds;
                        }, 0)
                      )
                    }
                  </span>
                </div>
              </div>
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-[60] p-4 transition-opacity duration-200"
      onClick={(e) => e.target === e.currentTarget && onCancel()}
    >
      <div 
        className="bg-white shadow-2xl w-[95vw] max-w-[1400px] h-[92vh] overflow-hidden flex flex-col rounded-2xl border border-gray-200"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Window Header - Mejorado */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4 flex justify-between items-center shadow-lg">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <h1 className="text-xl font-bold text-white">{title}</h1>
          </div>
          <button
            onClick={onCancel}
            className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200"
            aria-label="Cerrar"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Tabs Navigation - Mejorado */}
        <div className="bg-gray-50/50 border-b border-gray-200">
          <div className="flex space-x-2 overflow-x-auto px-4">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`group flex items-center space-x-2 px-6 py-4 text-sm font-semibold whitespace-nowrap transition-all duration-200 relative ${
                  activeTab === tab.id
                    ? "text-blue-700 bg-white shadow-sm"
                    : "text-gray-600 hover:text-blue-600 hover:bg-white/70"
                }`}
              >
                <span className={`transition-colors ${activeTab === tab.id ? 'text-blue-600' : 'text-gray-500 group-hover:text-blue-500'}`}>
                  {tab.icon}
                </span>
                <span>{tab.name}</span>
                {activeTab === tab.id && (
                  <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-blue-600"></div>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Form Content - Mejorado */}
        <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 to-white">
          <div className="max-w-7xl mx-auto">
            {renderTabContent()}
          </div>
        </div>
        
        {/* Footer with Action Buttons - Mejorado */}
        <div className="bg-white border-t border-gray-200 px-8 py-6 flex justify-between items-center shadow-lg">
          <div className="text-sm text-gray-500">
            {mode === 'new' ? 'Completa los campos requeridos para crear el día modelo' : mode === 'edit' ? 'Modifica los campos necesarios y guarda los cambios' : 'Vista de solo lectura'}
          </div>
          <div className="flex gap-3">
            <button
              type="button"
              onClick={onCancel}
              disabled={isLoading}
              className="min-w-[140px] px-6 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 active:bg-gray-300 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 font-semibold text-sm shadow-sm hover:shadow-md transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-gray-400"
              aria-label="Cerrar formulario de día modelo"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
              <span>Cerrar</span>
            </button>
            
            {!isReadOnly && (
              <button
                type="button"
                onClick={handleSubmit}
                disabled={isLoading}
                className="min-w-[160px] px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl hover:from-blue-700 hover:to-blue-800 active:from-blue-800 active:to-blue-900 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 font-semibold text-sm shadow-lg hover:shadow-xl transform hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-4 focus:ring-blue-300"
                aria-label={isLoading ? 'Guardando día modelo' : mode === 'new' ? 'Crear nuevo día modelo' : 'Guardar cambios del día modelo'}
              >
                {isLoading ? (
                  <>
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    <span>Guardando...</span>
                  </>
                ) : (
                  <>
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                    </svg>
                    <span>{mode === 'new' ? 'Crear Día Modelo' : 'Guardar Cambios'}</span>
                  </>
                )}
              </button>
            )}
          </div>
        </div>
      </div>


    </div>
  );
}
