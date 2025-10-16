import React, { useState, useEffect } from 'react';
import { 
  politicasApi, 
  diasModeloApi, 
  relojesApi, 
  eventosRelojApi 
} from '../../../../api/programacion/politicasApi';
import OrdenAsignacion from './OrdenAsignacion'
import EventosReloj from './EventosReloj';

export default function PoliticasProgramacion() {
  // Estado para políticas de programación
  const [politicas, setPoliticas] = useState([]);
  
  const [filteredPoliticas, setFilteredPoliticas] = useState([]);
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
    comandoDAS: '',
    caracteristica: '',
    twoferValor: '',
    todasCategorias: true,
    categoriasUsar: '',
    gruposReglasIgnorar: '',
    clasificacionesEvento: '',
    caracteristicaEspecifica: '',
    valorDeseado: '',
    usarTodasCategorias: true,
    categoriasUsarEspecifica: '',
    gruposReglasIgnorarEspecifica: '',
    clasificacionesEventoEspecifica: ''
  });
  
  // Estado para manejar los eventos del reloj actualmente en edición
  const [relojEvents, setRelojEvents] = useState([]);
  
  const [showOnlyActive, setShowOnlyActive] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [notification, setNotification] = useState(null);
  const [viewMode, setViewMode] = useState('tarjetas'); // 'tarjetas' or 'grid'
  const [expandedCategories, setExpandedCategories] = useState(new Set());
  const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
  const [selectedRelojInTable, setSelectedRelojInTable] = useState(null);
  const [categoriasSeleccionadas, setCategoriasSeleccionadas] = useState([]);
  const [politicaFormActiveTab, setPoliticaFormActiveTab] = useState(0); // Mostrar primera pestaña por defecto

  // Cargar categorías seleccionadas al inicializar el componente
  useEffect(() => {
    const loadCategoriasSeleccionadas = async () => {
      try {
        const response = await fetch('http://localhost:8000/api/v1/categorias/canciones/politica/1/categorias');
        const data = await response.json();
        if (data.categorias && data.categorias.length > 0) {
          setCategoriasSeleccionadas(data.categorias);
          console.log('🔍 Categorías cargadas desde la DB:', data.categorias);
        }
      } catch (error) {
        console.error('Error cargando categorías seleccionadas:', error);
      }
    };
    
    loadCategoriasSeleccionadas();
  }, []);

  // ===== FUNCIONES AUXILIARES =====
  
  // Función para manejar el guardado de categorías desde OrdenAsignacion
  const handleCategoriasSaved = (configuracion) => {
    console.log('Configuración de orden de asignación:', configuracion);
    // Actualizar las categorías seleccionadas
    if (configuracion.categorias) {
      const nuevasCategorias = configuracion.categorias.map(c => c.nombre);
      console.log('Categorías actualizadas:', nuevasCategorias);
      // Actualizar el estado de categorías seleccionadas
      setCategoriasSeleccionadas(nuevasCategorias);
    }
  };
  
  // Función para convertir errores de API a cadenas legibles
  const formatErrorMessage = (error, defaultMessage = 'Error desconocido') => {
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
  };

  // Load políticas
  const loadPoliticas = async () => {
    try {
      setLoading(true);
      setError(null);
      
      console.log('🔍 Cargando políticas desde API...');
      const data = await politicasApi.getAll();
      console.log('✅ Políticas cargadas desde API:', data);
      
      // Mapear datos de la API al formato esperado por el componente
      const politicasMapeadas = data.map(politica => ({
        id: politica.id,
        nombre: politica.clave,
        descripcion: `Política para ${politica.difusora}`,
        habilitada: politica.habilitada,
        tipo: 'General',
        prioridad: 'Media',
        fechaCreacion: politica.created_at ? new Date(politica.created_at).toLocaleDateString() : 'N/A',
        ultimaModificacion: politica.updated_at ? new Date(politica.updated_at).toLocaleDateString() : 'N/A',
        difusora: politica.difusora,
        guid: politica.guid
      }));
      
      setPoliticas(politicasMapeadas);
      setFilteredPoliticas(politicasMapeadas);
    } catch (err) {
      console.error('❌ Error loading políticas:', err);
      setError(err.message || 'Error al cargar las políticas');
      setPoliticas([]);
      setFilteredPoliticas([]);
    } finally {
      setLoading(false);
    }
  };

  // Cargar días modelo por política
  const loadDiasModelo = async (politicaId) => {
    try {
      console.log('🔄 Cargando días modelo para política ID:', politicaId);
      const diasModeloData = await diasModeloApi.getByPolitica(politicaId);
      console.log('✅ Días modelo cargados desde API:', diasModeloData);
      setDiasModelo(diasModeloData);
    } catch (err) {
      console.error('❌ Error loading días modelo:', err);
      setDiasModelo([]);
    }
  };

  // Cargar relojes por política
  const loadRelojes = async (politicaId) => {
    try {
      console.log('🔄 Cargando relojes para política ID:', politicaId);
      const relojesData = await relojesApi.getByPolitica(politicaId);
      console.log('✅ Relojes cargados:', relojesData);
      setRelojes(relojesData);
    } catch (err) {
      console.error('❌ Error loading relojes:', err);
      setRelojes([]);
    }
  };

  // Manejar nuevo día modelo
  const handleNewDiaModelo = () => {
    setShowDiaModeloForm(true);
  };

  // Manejar editar día modelo
  const handleEditDiaModelo = (diaModelo) => {
    setShowDiaModeloForm(true);
  };

  // Manejar ver día modelo
  const handleViewDiaModelo = (diaModelo) => {
    setShowDiaModeloForm(true);
  };

  useEffect(() => {
    loadPoliticas();
  }, []);

  // Cargar días modelo cuando se selecciona una política
  useEffect(() => {
    if (selectedPolitica && selectedPolitica.id) {
      loadDiasModelo(selectedPolitica.id);
    } else {
      setDiasModelo([]);
    }
  }, [selectedPolitica]);

  // Cargar relojes cuando se selecciona una política
  useEffect(() => {
    if (selectedPolitica && selectedPolitica.id) {
      loadRelojes(selectedPolitica.id);
    } else {
      setRelojes([]);
    }
  }, [selectedPolitica]);

  // Seleccionar el primer reloj por defecto - DESHABILITADO para evitar reaperturas automáticas
  // useEffect(() => {
  //   // Solo seleccionar automáticamente si no estamos en modo de creación/edición
  //   if (relojes.length > 0 && !selectedRelojInTable && !showRelojForm) {
  //     setSelectedRelojInTable(relojes[0]);
  //   }
  // }, [relojes, selectedRelojInTable, showRelojForm]);

  // Función para obtener el color de cada categoría de evento
  const getEventColor = (categoria) => {
    const colorMap = {
      'Canciones': '#3b82f6', // blue-500
      'Nota Operador': '#eab308', // yellow-500
      'Cartucho Fijo': '#8b5cf6', // purple-500
      'Canción Manual': '#f97316', // orange-500
      'Twofer': '#ec4899', // pink-500
      'Corte Comercial': '#ef4444', // red-500
      'ETM': '#22c55e', // green-500
      'Exact Time Marker': '#06b6d4', // cyan-500
      'Comando': '#6366f1', // indigo-500
      'Característica Específica': '#84cc16' // lime-500
    };
    
    return colorMap[categoria] || '#6b7280'; // gray-500 como fallback
  };

  // Función para obtener los eventos del reloj seleccionado en la tabla
  const getSelectedRelojEvents = () => {
    // Si estamos en el formulario de reloj (creando o editando), usar relojEvents
    if (showRelojForm && relojEvents.length > 0) {
      console.log('🔄 getSelectedRelojEvents - Usando relojEvents del formulario:', relojEvents);
      return relojEvents;
    }

    // Si hay un reloj seleccionado en la tabla, buscar sus eventos
    if (selectedRelojInTable) {
      const relojSeleccionado = relojes.find(reloj => reloj.id === selectedRelojInTable.id);
      const eventos = relojSeleccionado ? relojSeleccionado.eventos || [] : [];
      console.log('🔄 getSelectedRelojEvents - Usando eventos del reloj seleccionado:', eventos);
      return eventos;
    }

    // Si no hay nada seleccionado, devolver array vacío
    console.log('🔄 getSelectedRelojEvents - No hay eventos disponibles');
    return [];
  };

  // Función para calcular la duración total del reloj seleccionado
  const getSelectedRelojDuration = () => {
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
  };





  // Filter políticas
  useEffect(() => {
    let filtered = politicas;
    
    if (showOnlyActive) {
      filtered = filtered.filter(p => p.habilitada === true);
    }
    
    if (searchTerm) {
      filtered = filtered.filter(p => 
        p.nombre?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.clave?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.difusora?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.descripcion?.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }
    
    setFilteredPoliticas(filtered);
  }, [politicas, showOnlyActive, searchTerm]);

  // Show notification
  const showNotification = (message, type = 'error') => {
    setNotification({ message, type });
  };

  // Función para obtener estadísticas por categoría
  const getCategoryStats = () => {
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
  };

  // Función para formatear duración
  const formatDuration = (minutes) => {
    const mins = Math.floor(minutes);
    const secs = Math.round((minutes - mins) * 60);
    return `${mins}' ${secs.toString().padStart(2, '0')}"`;
  };

  // Función para manejar expansión de categorías
  const toggleCategoryExpansion = (category) => {
    const newExpanded = new Set(expandedCategories);
    if (newExpanded.has(category)) {
      newExpanded.delete(category);
    } else {
      newExpanded.add(category);
    }
    setExpandedCategories(newExpanded);
  };

  // Función para ordenar estadísticas
  const sortStats = (key) => {
    let direction = 'asc';
    if (sortConfig.key === key && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    setSortConfig({ key, direction });
  };

  // Función para obtener estadísticas ordenadas
  const getSortedCategoryStats = () => {
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
  };

  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [notification]);

  const handleNew = () => {
    setSelectedPolitica(null);
    setFormMode('new');
    setShowForm(true);
  };

  const loadRelojesForPolitica = async (politicaId) => {
    try {
      console.log('🔄 Cargando relojes para política ID:', politicaId);
      const relojesData = await relojesApi.getByPolitica(politicaId);
      console.log('✅ Relojes cargados:', relojesData);
      setRelojes(relojesData);
    } catch (err) {
      console.error('❌ Error loading relojes:', err);
      setRelojes([]);
    }
  };

  const handleEdit = async (politica) => {
    setSelectedPolitica(politica);
    setFormMode('edit');
    setShowForm(true);
    // Cargar relojes de la política
    await loadRelojesForPolitica(politica.id);
  };

  const handleView = async (politica) => {
    setSelectedPolitica(politica);
    setFormMode('view');
    setShowForm(true);
    // Cargar relojes de la política
    await loadRelojesForPolitica(politica.id);
  };

  const handleDelete = async (id) => {
    const politica = politicas.find(p => p.id === id);
    if (window.confirm(`¿Está seguro de eliminar la política "${politica?.nombre}"?`)) {
      try {
        setLoading(true);
        await deletePolitica(id);
        showNotification('Política eliminada correctamente', 'success');
        await loadPoliticas();
      } catch (err) {
        console.error('Error deleting política:', err);
        showNotification(`Error al eliminar la política: ${err.message}`, 'error');
      } finally {
        setLoading(false);
      }
    }
  };

  const handleToggleActive = () => {
    setShowOnlyActive(!showOnlyActive);
  };

  const handleSave = async (politicaData) => {
    try {
      setLoading(true);
      if (formMode === 'edit') {
        await updatePolitica(selectedPolitica.id, politicaData);
        showNotification('Política actualizada correctamente', 'success');
      } else {
        await createPolitica(politicaData);
        showNotification('Política creada correctamente', 'success');
      }
      
      await loadPoliticas();
      setShowForm(false);
      setSelectedPolitica(null);
      setFormMode('new');
    } catch (err) {
      console.error('Error saving política:', err);
      showNotification(`Error al guardar la política: ${err.message}`, 'error');
    } finally {
      setLoading(false);
    }
  };

  // ===== FUNCIONES DE GESTIÓN DE RELOJES =====
  
  const handleNewReloj = async () => {
    console.log('🔵 handleNewReloj - INICIO');
    if (!selectedPolitica) {
      setNotification({
        type: 'error',
        message: 'Debe seleccionar una política primero para crear un reloj'
      });
      return;
    }
    
    setSelectedReloj(null);
    setRelojFormMode('new');
    
    // Iniciar con reloj vacío - sin eventos automáticos
    setRelojEvents([]);
    console.log('🔍 Nuevo reloj iniciado vacío - sin eventos automáticos');
    
    setShowRelojForm(true); // Mostrar el RelojForm modal
    console.log('🔵 handleNewReloj - FIN - Modal abierto');
  };

  const handleEditReloj = (reloj) => {
    console.log('🟡 handleEditReloj - INICIO - Reloj recibido:', reloj);
    console.log('🟡 handleEditReloj - Eventos del reloj:', reloj.eventos);
    setSelectedReloj(reloj);
    setRelojFormMode('edit');
    
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
      comandoDAS: evento.comando_das,
      caracteristica: evento.caracteristica,
      twoferValor: evento.twofer_valor,
      todasCategorias: evento.todas_categorias,
      categoriasUsar: evento.categorias_usar,
      gruposReglasIgnorar: evento.grupos_reglas_ignorar,
      clasificacionesEvento: evento.clasificaciones_evento,
      caracteristicaEspecifica: evento.caracteristica_especifica,
      valorDeseado: evento.valor_deseado,
      usarTodasCategorias: evento.usar_todas_categorias,
      categoriasUsarEspecifica: evento.categorias_usar_especifica,
      gruposReglasIgnorarEspecifica: evento.grupos_reglas_ignorar_especifica,
      clasificacionesEventoEspecifica: evento.clasificaciones_evento_especifica,
      orden: evento.orden
    })) : [];
    
    setRelojEvents(eventosMapeados);
    console.log('🟡 handleEditReloj - Eventos mapeados al estado:', eventosMapeados);
    setShowRelojForm(true);
    console.log('🟡 handleEditReloj - FIN - Modal abierto para edición');
  };

  const handleViewReloj = (reloj) => {
    console.log('🔄 handleViewReloj - Reloj recibido:', reloj);
    console.log('🔄 handleViewReloj - Eventos del reloj:', reloj.eventos);
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
      comandoDAS: evento.comando_das,
      caracteristica: evento.caracteristica,
      twoferValor: evento.twofer_valor,
      todasCategorias: evento.todas_categorias,
      categoriasUsar: evento.categorias_usar,
      gruposReglasIgnorar: evento.grupos_reglas_ignorar,
      clasificacionesEvento: evento.clasificaciones_evento,
      caracteristicaEspecifica: evento.caracteristica_especifica,
      valorDeseado: evento.valor_deseado,
      usarTodasCategorias: evento.usar_todas_categorias,
      categoriasUsarEspecifica: evento.categorias_usar_especifica,
      gruposReglasIgnorarEspecifica: evento.grupos_reglas_ignorar_especifica,
      clasificacionesEventoEspecifica: evento.clasificaciones_evento_especifica,
      orden: evento.orden
    })) : [];
    
    setRelojEvents(eventosMapeados);
    console.log('🔄 handleViewReloj - Eventos mapeados al estado:', eventosMapeados);
    setShowRelojForm(true);
  };

  const handleDeleteReloj = async (id) => {
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
        // Recargar relojes de la política actual
        if (selectedPolitica) {
          const relojesData = await relojesApi.getByPolitica(selectedPolitica.id);
          console.log('🔄 Relojes recargados después de eliminar:', relojesData);
          setRelojes(relojesData);
        }
      } catch (err) {
        console.error('Error deleting reloj:', err);
        setNotification({ type: 'error', message: 'Error al eliminar el reloj' });
      } finally {
        setLoading(false);
      }
    }
  };

  const handleSaveReloj = async (relojData) => {
    try {
      setLoading(true);
      
      let relojId;
      
      if (relojFormMode === 'new') {
        // Crear nuevo reloj
        if (!selectedPolitica || !selectedPolitica.id) {
          throw new Error('No se ha seleccionado una política válida');
        }
        
        const newReloj = await relojesApi.create(selectedPolitica.id, relojData);
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
            console.error('Error al eliminar evento existente:', deleteError);
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
              tipo_etm: evento.tipoETM || evento.tipo_etm,
              comando_das: evento.comandoDAS || evento.comando_das,
              caracteristica: evento.caracteristica,
              twofer_valor: evento.twoferValor || evento.twofer_valor,
              todas_categorias: evento.todasCategorias !== undefined ? evento.todasCategorias : true,
              categorias_usar: evento.categoriasUsar || evento.categorias_usar,
              grupos_reglas_ignorar: evento.gruposReglasIgnorar || evento.grupos_reglas_ignorar,
              clasificaciones_evento: evento.clasificacionesEvento || evento.clasificaciones_evento,
              caracteristica_especifica: evento.caracteristicaEspecifica || evento.caracteristica_especifica,
              valor_deseado: evento.valorDeseado || evento.valor_deseado,
              usar_todas_categorias: evento.usarTodasCategorias !== undefined ? evento.usarTodasCategorias : true,
              categorias_usar_especifica: evento.categoriasUsarEspecifica || evento.categorias_usar_especifica,
              grupos_reglas_ignorar_especifica: evento.gruposReglasIgnorarEspecifica || evento.grupos_reglas_ignorar_especifica,
              clasificaciones_evento_especifica: evento.clasificacionesEventoEspecifica || evento.clasificaciones_evento_especifica,
              orden: evento.orden || 0
            };
            
            await eventosRelojApi.create(relojId, eventoData);
          } catch (eventoError) {
            console.error('❌ Error al guardar evento:', eventoError);
            console.error('❌ Detalles del error:', eventoError.response?.data);
            
            const errorMessage = formatErrorMessage(eventoError, 'Error al guardar evento');
            setNotification({ type: 'error', message: `Error al guardar evento: ${errorMessage}` });
          }
        }
        setNotification({ type: 'success', message: `${relojEvents.length} eventos guardados exitosamente` });
      }
      
      // Recargar relojes de la política actual primero
      console.log('🔄 Recargando lista de relojes...');
      if (selectedPolitica) {
        const relojesData = await relojesApi.getByPolitica(selectedPolitica.id);
        setRelojes(relojesData);
        console.log('✅ Lista de relojes recargada');
      }
      
      // Limpiar estados después de recargar
      console.log('🔄 Limpiando estados y cerrando formulario...');
      setShowRelojForm(false);
      setSelectedReloj(null);
      setRelojFormMode('new');
      setRelojEvents([]);
      setSelectedRelojInTable(null); // Limpiar selección de tabla
      console.log('✅ Formulario cerrado, estados limpiados');
    } catch (err) {
      console.error('❌ Error saving reloj:', err);
      console.error('❌ Error details:', err.response?.data);
      
      const errorMessage = formatErrorMessage(err, 'Error al guardar el reloj');
      setNotification({ type: 'error', message: errorMessage });
    } finally {
      setLoading(false);
    }
  };


  const handleDeleteDiaModelo = async (diaModelo) => {
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
        console.error('Error deleting día modelo:', err);
        const errorMessage = err.response?.data?.detail || err.message || 'Error al eliminar el día modelo';
        setNotification({
          type: 'error',
          message: errorMessage
        });
      } finally {
        setLoading(false);
      }
    }
  };

  const handleSaveDiaModelo = async (diaModeloData, diaModeloId = null) => {
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
      console.error('Error saving dia modelo:', err);
      
      const errorMessage = formatErrorMessage(err, 'Error al guardar el día modelo');
      setNotification({ type: 'error', message: errorMessage });
    } finally {
      setLoading(false);
    }
  };

  const handleEventClick = (eventType, eventName) => {
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
  };

  const handleCategoryClick = (eventType, categoryName) => {
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
  };

  const handlePredefinedEventClick = (eventType, eventName) => {
    // Configuración específica para eventos de cartucho fijo
    let categoria = getEventCategory(eventType);
    let idMedia = '';
    let categoriaEspecifica = '';
    
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
    
    // Configuración específica para eventos de Comando Automatización
    let comandoDAS = '';
    if (eventType === 'comando-automatizacion') {
      // Mapear nombres de eventos a comandos DAS específicos
      const comandoMapping = {
        'AUTO_CMD_1': 'DAS_CMD_1',
        'AUTO_CMD_2': 'DAS_CMD_2',
        'AUTO_CMD_3': 'DAS_CMD_3',
        'AUTO_CMD_4': 'DAS_CMD_4'
      };
      
      comandoDAS = comandoMapping[eventName] || eventName;
    }
    
    // Configuración específica para eventos de Twofer
    let caracteristica = '';
    let twoferValor = '';
    let todasCategorias = true;
    let categoriasUsar = '';
    let gruposReglasIgnorar = '';
    let clasificacionesEvento = '';
    
    if (eventType === 'twofer') {
      // Mapear nombres de eventos a configuraciones específicas
      const twoferMapping = {
        'TWOFER_1': { 
          caracteristica: 'CARACT_1', 
          twoferValor: 'TWOFER_1',
          todasCategorias: true,
          categoriasUsar: '',
          gruposReglasIgnorar: 'GRUPO_1',
          clasificacionesEvento: 'CLASIF_1'
        },
        'TWOFER_2': { 
          caracteristica: 'CARACT_2', 
          twoferValor: 'TWOFER_2',
          todasCategorias: false,
          categoriasUsar: 'CAT_1',
          gruposReglasIgnorar: 'GRUPO_2',
          clasificacionesEvento: 'CLASIF_2'
        },
        'TWOFER_3': { 
          caracteristica: 'CARACT_3', 
          twoferValor: 'TWOFER_3',
          todasCategorias: true,
          categoriasUsar: '',
          gruposReglasIgnorar: 'GRUPO_3',
          clasificacionesEvento: 'CLASIF_3'
        },
        'TWOFER_4': { 
          caracteristica: 'CARACT_4', 
          twoferValor: 'TWOFER_4',
          todasCategorias: false,
          categoriasUsar: 'CAT_2',
          gruposReglasIgnorar: 'GRUPO_4',
          clasificacionesEvento: 'CLASIF_4'
        }
      };
      
      const mapping = twoferMapping[eventName];
      if (mapping) {
        caracteristica = mapping.caracteristica;
        twoferValor = mapping.twoferValor;
        todasCategorias = mapping.todasCategorias;
        categoriasUsar = mapping.categoriasUsar;
        gruposReglasIgnorar = mapping.gruposReglasIgnorar;
        clasificacionesEvento = mapping.clasificacionesEvento;
      }
    }
    
    // Configuración específica para eventos de Característica Específica
    let caracteristicaEspecifica = '';
    let valorDeseado = '';
    let usarTodasCategorias = true;
    let categoriasUsarEspecifica = '';
    let gruposReglasIgnorarEspecifica = '';
    let clasificacionesEventoEspecifica = '';
    
    if (eventType === 'caracteristica-especifica') {
      // Mapear nombres de eventos a configuraciones específicas
      const caracteristicaMapping = {
        'CARACT_ESP_1': { 
          caracteristicaEspecifica: 'CARACT_ESP_1', 
          valorDeseado: 'Valor 1',
          usarTodasCategorias: true,
          categoriasUsarEspecifica: '',
          gruposReglasIgnorarEspecifica: 'GRUPO_ESP_1',
          clasificacionesEventoEspecifica: 'CLASIF_ESP_1'
        },
        'CARACT_ESP_2': { 
          caracteristicaEspecifica: 'CARACT_ESP_2', 
          valorDeseado: 'Valor 2',
          usarTodasCategorias: false,
          categoriasUsarEspecifica: 'CAT_ESP_1',
          gruposReglasIgnorarEspecifica: 'GRUPO_ESP_2',
          clasificacionesEventoEspecifica: 'CLASIF_ESP_2'
        },
        'CARACT_ESP_3': { 
          caracteristicaEspecifica: 'CARACT_ESP_3', 
          valorDeseado: 'Valor 3',
          usarTodasCategorias: true,
          categoriasUsarEspecifica: '',
          gruposReglasIgnorarEspecifica: 'GRUPO_ESP_3',
          clasificacionesEventoEspecifica: 'CLASIF_ESP_3'
        },
        'CARACT_ESP_4': { 
          caracteristicaEspecifica: 'CARACT_ESP_4', 
          valorDeseado: 'Valor 4',
          usarTodasCategorias: false,
          categoriasUsarEspecifica: 'CAT_ESP_2',
          gruposReglasIgnorarEspecifica: 'GRUPO_ESP_4',
          clasificacionesEventoEspecifica: 'CLASIF_ESP_4'
        }
      };
      
      const mapping = caracteristicaMapping[eventName];
      if (mapping) {
        caracteristicaEspecifica = mapping.caracteristicaEspecifica;
        valorDeseado = mapping.valorDeseado;
        usarTodasCategorias = mapping.usarTodasCategorias;
        categoriasUsarEspecifica = mapping.categoriasUsarEspecifica;
        gruposReglasIgnorarEspecifica = mapping.gruposReglasIgnorarEspecifica;
        clasificacionesEventoEspecifica = mapping.clasificacionesEventoEspecifica;
      }
    }
    
    // Añadir directamente al reloj
    const newEvent = {
      id: relojEvents.length + 1,
      numero: generateConsecutivo(),
      offset: calculateLastEventOffset(),
      desdeETM: calculateLastEventOffset(),
      desdeCorte: calculateLastEventOffset(),
      offsetFinal: calculateLastEventOffset(), // Se calculará después
      tipo: getEventTypeNumber(eventType),
      categoria: categoria,
      descripcion: eventName,
      duracion: getDefaultDuration(eventType),
      numeroCancion: getNumeroCancion(eventType),
      sinCategorias: '-',
      // Campos adicionales para Cartucho Fijo
      ...(eventType === 'cartucho-fijo' && {
        idMedia: idMedia,
        categoriaEspecifica: categoriaEspecifica
      }),
      // Campo adicional para Exact Time Marker
      ...(eventType === 'exact-time-marker' && {
        tipoETM: tipoETM
      }),
      // Campo adicional para Comando Automatización
      ...(eventType === 'comando-automatizacion' && {
        comandoDAS: comandoDAS
      }),
      // Campos adicionales para Twofer
      ...(eventType === 'twofer' && {
        caracteristica: caracteristica,
        twoferValor: twoferValor,
        todasCategorias: todasCategorias,
        categoriasUsar: categoriasUsar,
        gruposReglasIgnorar: gruposReglasIgnorar,
        clasificacionesEvento: clasificacionesEvento
      }),
      // Campos adicionales para Característica Específica
      ...(eventType === 'caracteristica-especifica' && {
        caracteristicaEspecifica: caracteristicaEspecifica,
        valorDeseado: valorDeseado,
        usarTodasCategorias: usarTodasCategorias,
        categoriasUsarEspecifica: categoriasUsarEspecifica,
        gruposReglasIgnorarEspecifica: gruposReglasIgnorarEspecifica,
        clasificacionesEventoEspecifica: clasificacionesEventoEspecifica
      })
    };
    
    // Calcular el offset final basado en la duración
    let durationSeconds = 0;
    if (typeof newEvent.duracion === 'number') {
      durationSeconds = newEvent.duracion;
    } else if (typeof newEvent.duracion === 'string' && newEvent.duracion.includes(':')) {
      const [hours, minutes, seconds] = newEvent.duracion.split(':').map(Number);
      durationSeconds = hours * 3600 + minutes * 60 + seconds;
    } else {
      durationSeconds = parseInt(newEvent.duracion) || 0;
    }
    const [offsetHours, offsetMinutes, offsetSeconds] = newEvent.offset.split(':').map(Number);
    const offsetTotalSeconds = offsetHours * 3600 + offsetMinutes * 60 + offsetSeconds;
    const finalTotalSeconds = offsetTotalSeconds + durationSeconds;
    
    const finalHours = Math.floor(finalTotalSeconds / 3600);
    const finalMinutes = Math.floor((finalTotalSeconds % 3600) / 60);
    const finalSeconds = finalTotalSeconds % 60;
    
    newEvent.offsetFinal = `${finalHours.toString().padStart(2, '0')}:${finalMinutes.toString().padStart(2, '0')}:${finalSeconds.toString().padStart(2, '0')}`;
    
    // Añadir el evento a la tabla
    setRelojEvents(prev => [...prev, newEvent]);
    
    console.log('Evento añadido al reloj:', newEvent);
    
    // Mostrar notificación de éxito
    setNotification({
      type: 'success',
      message: `Evento "${eventName}" añadido al reloj`
    });
  };

  // ===== FUNCIONES DE GESTIÓN DE EVENTOS =====
  
  // Función helper para parsear tiempo de forma segura
  const parseTimeSafely = (timeString) => {
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
      console.error('Error al parsear tiempo:', error);
      return [0, 0, 0];
    }
  };
  
  const addEventToReloj = (newEvent) => {
    console.log('🔄 addEventToReloj - Evento recibido:', newEvent);
    console.log('🔄 addEventToReloj - Estado actual de relojEvents:', relojEvents);
    setRelojEvents(prev => {
      const newState = [...prev, newEvent];
      console.log('🔄 addEventToReloj - Nuevo estado de relojEvents:', newState);
      return newState;
    });
    console.log('✅ Evento añadido al reloj:', newEvent);
  };

  const deleteEventFromReloj = async (eventId) => {
    if (window.confirm('¿Está seguro de eliminar este evento?')) {
      try {
        // Si el evento tiene un ID válido (no es temporal), eliminarlo de la BD
        if (eventId && typeof eventId === 'number') {
          console.log('🔄 Eliminando evento de la base de datos:', eventId);
          await eventosRelojApi.delete(eventId);
          console.log('✅ Evento eliminado de la base de datos');
          
          // Recargar relojes para actualizar la vista de lista
          if (selectedPolitica) {
            const relojesData = await relojesApi.getByPolitica(selectedPolitica.id);
            setRelojes(relojesData);
            console.log('🔄 Relojes recargados después de eliminar evento');
          }
        }
        
        // Eliminar del estado local
        setRelojEvents(prev => prev.filter(event => event.id !== eventId));
        
        setNotification({
          type: 'success',
          message: 'Evento eliminado correctamente'
        });
      } catch (error) {
        console.error('❌ Error al eliminar evento:', error);
        setNotification({
          type: 'error',
          message: 'Error al eliminar el evento'
        });
      }
    }
  };

  // Función para verificar si hay cambios sin guardar en el reloj en edición
  const hasUnsavedChanges = () => {
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
  };



  const calculateLastEventOffset = () => {
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
      console.error('Error al calcular offset:', error);
      return '00:00:00';
    }
  };

  const generateConsecutivo = () => {
    // Generar el siguiente número consecutivo basado en los eventos actuales
    const lastEventNumber = relojEvents.length;
    return (lastEventNumber + 1).toString().padStart(3, '0');
  };

  const getDefaultDuration = (eventType) => {
    const defaultDurations = {
      'corte-comercial': '00:03:00', // 3 minutos por defecto
      'canciones': '00:04:00',       // 4 minutos por defecto
      'nota-operador': '00:00:30',   // 30 segundos por defecto
      'vacío': '00:00:00',           // 0 segundos
      'cartucho-fijo': '00:01:00',   // 1 minuto por defecto
      'exact-time-marker': '00:00:00', // 0 segundos
      'cancion-manual': '00:04:00',  // 4 minutos por defecto
      'comando-automatizacion': '00:00:10', // 10 segundos por defecto
      'twofer': '00:00:20',          // 20 segundos por defecto
      'caracteristica-especifica': '00:02:00' // 2 minutos por defecto
    };
    return defaultDurations[eventType] || '00:01:00';
  };

  const getEventTypeNumber = (eventType) => {
    const typeNumbers = {
      'corte-comercial': '2',
      'canciones': '1',
      'nota-operador': '3',
      'vacío': '4',
      'cartucho-fijo': '5',
      'exact-time-marker': '6',
      'cancion-manual': '7',
      'comando-automatizacion': '8',
      'twofer': '9',
      'caracteristica-especifica': '10'
    };
    return typeNumbers[eventType] || '1';
  };

  const getEventCategory = (eventType) => {
    const categories = {
      'corte-comercial': 'Corte Comercial',
      'canciones': 'Canciones',
      'nota-operador': 'Nota Operador',
      'vacío': 'Vacío',
      'cartucho-fijo': 'Cartucho Fijo',
      'exact-time-marker': 'ETM',
      'cancion-manual': 'Canción Manual',
      'comando-automatizacion': 'Comando',
      'twofer': 'Twofer',
      'caracteristica-especifica': 'Característica'
    };
    return categories[eventType] || 'Otros';
  };

  const getNumeroCancion = (eventType) => {
    if (eventType === 'canciones') {
      return (relojEvents.filter(e => e.categoria === 'Canciones').length + 1).toString().padStart(3, '0');
    }
    return '-';
  };

  const calculateTotalDuration = () => {
    let totalSeconds = 0;
    
    relojEvents.forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    
    return `${hours}' ${minutes.toString().padStart(2, '0')}" ${seconds.toString().padStart(2, '0')}"`;
  };

  const calculateCategoryDuration = (category) => {
    let totalSeconds = 0;
    
    relojEvents.filter(event => event.categoria === category).forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    return `${minutes}' ${seconds.toString().padStart(2, '0')}"`;
  };

  const calculateOtherDuration = () => {
    let totalSeconds = 0;
    
    relojEvents.filter(event => !['Corte Comercial', 'Canciones', 'Nota Operador'].includes(event.categoria)).forEach(event => {
      const [hours, minutes, seconds] = parseTimeSafely(event.duracion);
      totalSeconds += hours * 3600 + minutes * 60 + seconds;
    });
    
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    return `${minutes}' ${seconds.toString().padStart(2, '0')}"`;
  };

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
    <div className="p-6 bg-gray-50 min-h-screen">
      {/* Notification Component */}
      {notification && (
        <div className={`fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-md transition-all duration-300 ${
          notification.type === 'success'
            ? 'bg-green-100 border border-green-400 text-green-800'
            : 'bg-red-100 border border-red-400 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              ) : (
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              )}
              <span className="font-medium">{notification.message}</span>
            </div>
            <button
              onClick={() => setNotification(null)}
              className="ml-4 text-gray-500 hover:text-gray-700"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-sm border border-gray-200">
        {/* Header */}
        <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-purple-50 to-indigo-50">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Políticas de Programación</h1>
              <p className="text-sm text-gray-600 mt-1">Administra las políticas de programación musical</p>
            </div>
            
            {/* Action Buttons */}
            <div className="flex flex-wrap gap-3">
              <button
                onClick={handleNew}
                className="bg-purple-600 hover:bg-purple-700 text-white px-6 py-3 rounded-lg transition-all duration-200 flex items-center space-x-2 shadow-sm font-medium hover:shadow-md transform hover:-translate-y-0.5"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nueva Política</span>
              </button>
              

              
              <button
                onClick={handleToggleActive}
                className={`px-4 py-3 rounded-lg transition-all duration-200 flex items-center space-x-2 shadow-sm font-medium hover:shadow-md transform hover:-translate-y-0.5 ${
                  showOnlyActive 
                    ? 'bg-purple-600 hover:bg-purple-700 text-white' 
                    : 'bg-gray-200 hover:bg-gray-300 text-gray-700 border border-gray-300'
                }`}
              >
                {showOnlyActive ? (
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                ) : (
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                )}
                <span>{showOnlyActive ? 'Ver Todas' : 'Solo Habilitadas'}</span>
              </button>
            </div>
          </div>
        </div>

        {/* Search and View Toggle */}
        <div className="px-6 py-5 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="relative max-w-md flex-1">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
              <input
                type="text"
                placeholder="Buscar políticas..."
                value={searchTerm || ''}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg leading-5 bg-white text-black placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-purple-500 focus:border-purple-500 shadow-sm transition-all duration-200"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="absolute inset-y-0 right-0 pr-3 flex items-center hover:bg-gray-100 rounded-r-lg transition-colors"
                >
                  <svg className="h-5 w-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              )}
            </div>
            
            {/* View Mode Toggle */}
            <div className="flex items-center space-x-2 bg-white border border-gray-300 rounded-lg p-1">
              <button
                onClick={() => setViewMode('tarjetas')}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-all duration-200 ${
                  viewMode === 'tarjetas'
                    ? 'bg-purple-600 text-white shadow-sm'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
              >
                Tarjetas
              </button>
              <button
                onClick={() => setViewMode('grid')}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-all duration-200 ${
                  viewMode === 'grid'
                    ? 'bg-purple-600 text-white shadow-sm'
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
          <div className="p-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {filteredPoliticas.map((politica) => (
                <div key={politica.id} className="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition-all duration-200">
                  <div className="p-6">
                    <div className="flex items-start justify-between mb-4">
                      <div className="flex items-center space-x-3">
                        <div className={`w-3 h-3 rounded-full ${politica.habilitada ? 'bg-green-500' : 'bg-red-500'}`}></div>
                        <h3 className="text-lg font-semibold text-gray-900">{politica.nombre}</h3>
                      </div>
                      <div className="flex space-x-1">
                        <button
                          onClick={() => handleView(politica)}
                          className="p-2 text-blue-600 hover:text-blue-900 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200"
                          title="Ver detalles"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleEdit(politica)}
                          className="p-2 text-yellow-600 hover:text-yellow-900 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200"
                          title="Editar"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(politica.id)}
                          className="p-2 text-red-600 hover:text-red-900 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200"
                          title="Eliminar"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </div>
                    
                    <div className="space-y-3">
                      <div className="grid grid-cols-2 gap-4 text-sm">
                        <div>
                          <span className="font-medium text-gray-600">Clave:</span>
                          <p className="text-gray-900">{politica.clave}</p>
                        </div>
                        <div>
                          <span className="font-medium text-gray-600">Difusora:</span>
                          <p className="text-gray-900">{politica.difusora}</p>
                        </div>
                      </div>
                      
                      <div>
                        <span className="font-medium text-gray-600">Habilitada:</span>
                        <div className="flex items-center mt-1">
                          <input
                            type="checkbox"
                            checked={politica.habilitada}
                            readOnly
                            className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
                          />
                          <span className="ml-2 text-sm text-gray-900">
                            {politica.habilitada ? 'Sí' : 'No'}
                          </span>
                        </div>
                      </div>
                      
                      <div>
                        <span className="font-medium text-gray-600">GUID:</span>
                        <p className="text-gray-900 text-xs font-mono">{politica.guid}</p>
                      </div>
                      
                      <div>
                        <span className="font-medium text-gray-600">Descripción:</span>
                        <p className="text-gray-900">{politica.descripcion || 'Sin descripción'}</p>
                      </div>
                      
                      <div className="pt-3 border-t border-gray-200">
                        <div className="grid grid-cols-1 gap-2 text-xs text-gray-500">
                          <div>
                            <span className="font-medium">Alta:</span> {politica.alta}
                          </div>
                          <div>
                            <span className="font-medium">Modificación:</span> {politica.modificacion}
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
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                    Estado
                  </th>
                  <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                    Clave
                  </th>
                  <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                    Difusora
                  </th>
                  <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                    Nombre
                  </th>
                  <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                    Descripción
                  </th>
                  <th className="px-3 py-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-40">
                    Acciones
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredPoliticas.map((politica, index) => (
                  <tr key={politica.id} className={`hover:bg-purple-50 transition-all duration-200 ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}`}>
                    <td className="px-3 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full border ${
                        politica.habilitada 
                          ? 'bg-green-100 text-green-800 border-green-200' 
                          : 'bg-red-100 text-red-800 border-red-200'
                      }`}>
                        {politica.habilitada ? 'Habilitada' : 'Deshabilitada'}
                      </span>
                    </td>
                    <td className="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {politica.clave}
                    </td>
                    <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-900">
                      {politica.difusora}
                    </td>
                    <td className="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {politica.nombre}
                    </td>
                    <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                      <div className="max-w-48 truncate" title={politica.descripcion}>
                        {politica.descripcion || 'Sin descripción'}
                      </div>
                    </td>
                    <td className="px-3 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex justify-center space-x-1">
                        <button
                          onClick={() => handleView(politica)}
                          className="p-2 text-blue-600 hover:text-blue-900 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200"
                          title="Ver detalles"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleEdit(politica)}
                          className="p-2 text-yellow-600 hover:text-yellow-900 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200"
                          title="Editar"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(politica.id)}
                          className="p-2 text-red-600 hover:text-red-900 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200"
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
          <div className="text-center py-16 px-6">
            <div className="mx-auto h-20 w-20 text-gray-400 mb-6">
              <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" className="w-full h-full">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              {error ? 'Error al cargar políticas' :
               searchTerm ? 'No se encontraron políticas' : 
               showOnlyActive ? 'No hay políticas habilitadas' : 
               'No hay políticas registradas'}
            </h3>
            <p className="text-gray-500 mb-6 max-w-md mx-auto">
              {error ? 
                `Error: ${error}. Intenta recargar la página.` :
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
                className="bg-purple-600 hover:bg-purple-700 text-white px-6 py-3 rounded-lg transition-all duration-200 font-medium hover:shadow-md transform hover:-translate-y-0.5"
              >
                Crear primera política
              </button>
            )}
          </div>
        )}
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
                onCategoriasSaved={handleCategoriasSaved}
                categoriasSeleccionadas={categoriasSeleccionadas}
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
                handleViewReloj={handleViewReloj}
                handleDeleteReloj={handleDeleteReloj}
                getEventColor={getEventColor}
                relojEvents={relojEvents}
                calculateTotalDuration={calculateTotalDuration}
                getSelectedRelojEvents={getSelectedRelojEvents}
                getSelectedRelojDuration={getSelectedRelojDuration}
              />
            )}

                        {/* Reloj Form Modal */}
            {showRelojForm && (
              <RelojForm
                reloj={selectedReloj}
                mode={relojFormMode}
                relojEvents={relojEvents}
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
                  console.log('Guardando evento:', eventData);
                  setShowEventForm(false);
                  setSelectedEventType(null);
                  setEventFormData({
                    consecutivo: '',
                    offset: '',
                    duracion: '',
                    descripcion: '',
                    idMedia: '',
                    categoria: '',
                    tipoETM: '',
                    comandoDAS: '',
                    caracteristica: '',
                    twoferValor: '',
                    todasCategorias: true,
                    categoriasUsar: '',
                    gruposReglasIgnorar: '',
                    clasificacionesEvento: '',
                    caracteristicaEspecifica: '',
                    valorDeseado: '',
                    usarTodasCategorias: true,
                    categoriasUsarEspecifica: '',
                    gruposReglasIgnorarEspecifica: '',
                    clasificacionesEventoEspecifica: ''
                  });
                }}
                onCancel={() => {
                  setShowEventForm(false);
                  setSelectedEventType(null);
                  setEventFormData({
                    consecutivo: '',
                    offset: '',
                    duracion: '',
                    descripcion: '',
                    idMedia: '',
                    categoria: '',
                    tipoETM: '',
                    comandoDAS: '',
                    caracteristica: '',
                    twoferValor: '',
                    todasCategorias: true,
                    categoriasUsar: '',
                    gruposReglasIgnorar: '',
                    clasificacionesEvento: '',
                    caracteristicaEspecifica: '',
                    valorDeseado: '',
                    usarTodasCategorias: true,
                    categoriasUsarEspecifica: '',
                    gruposReglasIgnorarEspecifica: '',
                    clasificacionesEventoEspecifica: ''
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
          </div>
        );
      }

      // Reloj Form Component
      function RelojForm({ reloj, mode, relojEvents, categoriasSeleccionadas = [], parseTimeSafely, getEventTypeNumber, getEventCategory, getNumeroCancion, calculateTotalDuration, calculateCategoryDuration, calculateOtherDuration, addEventToReloj, deleteEventFromReloj, hasUnsavedChanges, getSelectedRelojEvents, getSelectedRelojDuration, getCategoryStats, formatDuration, expandedCategories, toggleCategoryExpansion, sortConfig, sortStats, getSortedCategoryStats, onSave, onCancel, onEventClick, onCategoryClick, onPredefinedEventClick }) {
        const [isLoading, setIsLoading] = useState(false);
        const [errors, setErrors] = useState({});
        const [activeTab, setActiveTab] = useState(0);
        const [cortes, setCortes] = useState([]);
        const [loadingCortes, setLoadingCortes] = useState(false);

        // Cargar cortes desde la base de datos
        useEffect(() => {
          const loadCortes = async () => {
            setLoadingCortes(true);
            try {
              const response = await fetch('http://localhost:8000/api/v1/catalogos/cortes/?activo=true');
              const data = await response.json();
              setCortes(data.cortes || []);
              console.log('🔍 RelojForm - Cortes cargados:', data.cortes);
            } catch (error) {
              console.error('Error al cargar cortes en RelojForm:', error);
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
            console.error('Error al parsear tiempo:', error);
            return [0, 0, 0];
          }
        };

        const [formData, setFormData] = useState({
          habilitado: reloj?.habilitado ?? true,
          perteneceGrupo: reloj?.pertenece_grupo ?? false,
          grupo: reloj?.grupo || '',
          clave: reloj?.clave || '',
          numeroRegla: reloj?.numero_regla || '',
          duracionReferencia: reloj?.duracion || '00:00:00',
          nombre: reloj?.nombre || '',
          descripcion: reloj?.descripcion || ''
        });

        const isReadOnly = mode === 'view';
        const title = mode === 'new' ? 'Nuevo Reloj' : 
                     mode === 'edit' ? 'Editar Reloj' : 
                     'Consultar Reloj';
        


        // Mock data
        const grupos = [
          { value: 'GRUPO_A', label: 'Grupo A' },
          { value: 'GRUPO_B', label: 'Grupo B' },
          { value: 'GRUPO_C', label: 'Grupo C' }
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
            name: 'Eventos del reloj', 
            icon: (
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )
          }
        ];

        const inputClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;
        const selectClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;

        const validateForm = () => {
          const newErrors = {};
          if (!formData.clave) newErrors.clave = 'La clave es requerida';
          if (!formData.nombre) newErrors.nombre = 'El nombre es requerido';
          if (formData.perteneceGrupo && !formData.grupo) newErrors.grupo = 'El grupo es requerido cuando pertenece a un grupo';
          setErrors(newErrors);
          return Object.keys(newErrors).length === 0;
        };

        const handleSubmit = async () => {
          if (!validateForm()) return;
          
          setIsLoading(true);
          try {
            // Mapear los campos del frontend a los campos que espera el backend
            const relojDataForBackend = {
              habilitado: formData.habilitado ?? true,
              clave: formData.clave || '',
              nombre: formData.nombre || '',
              numero_eventos: relojEvents.length || 0,
              duracion: formData.duracionReferencia || '00:00:00'
            };
            
            console.log('📦 DATOS A ENVIAR AL BACKEND:', JSON.stringify(relojDataForBackend, null, 2));
            
            // Llamar a la función onSave del componente padre
            await onSave(relojDataForBackend);
          } catch (error) {
            console.error('Error en RelojForm handleSubmit:', error);
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
                <div className="space-y-6">
                  <div className="flex items-center space-x-3">
                    <input 
                      type="checkbox" 
                      name="habilitado" 
                      checked={formData.habilitado} 
                      onChange={handleChange} 
                      disabled={isReadOnly} 
                      className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded" 
                    />
                    <label className="text-sm font-medium text-gray-700">Reloj habilitado</label>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Clave *</label>
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
                      {errors.clave && <p className="mt-1 text-sm text-red-600">{errors.clave}</p>}
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Nombre *</label>
                      <input 
                        type="text" 
                        name="nombre" 
                        value={formData.nombre || ''} 
                        onChange={handleChange} 
                        disabled={isReadOnly} 
                        className={inputClass} 
                        placeholder="Nombre del reloj"
                        required={!isReadOnly}
                      />
                      {errors.nombre && <p className="mt-1 text-sm text-red-600">{errors.nombre}</p>}
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Número de Regla</label>
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
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Duración de Referencia</label>
                      <input 
                        type="text" 
                        name="duracionReferencia" 
                        value={formData.duracionReferencia || ''} 
                        onChange={handleChange} 
                        disabled={isReadOnly} 
                        className={inputClass} 
                        placeholder="00:00:00"
                      />
                    </div>
                    
                    <div className="md:col-span-2">
                      <div className="flex items-center space-x-3 mb-2">
                        <input 
                          type="checkbox" 
                          name="perteneceGrupo" 
                          checked={formData.perteneceGrupo} 
                          onChange={handleChange} 
                          disabled={isReadOnly} 
                          className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded" 
                        />
                        <label className="text-sm font-medium text-gray-700">Pertenece al grupo de relojes</label>
                      </div>
                      
                      {formData.perteneceGrupo && (
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">Grupo</label>
                          <select 
                            name="grupo" 
                            value={formData.grupo || ''} 
                            onChange={handleChange} 
                            disabled={isReadOnly} 
                            className={selectClass}
                          >
                            <option value="">Seleccionar grupo</option>
                            {grupos.map((grupo) => (
                              <option key={grupo.value} value={grupo.value}>
                                {grupo.label}
                              </option>
                            ))}
                          </select>
                          {errors.grupo && <p className="mt-1 text-sm text-red-600">{errors.grupo}</p>}
                        </div>
                      )}
                    </div>
                    
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Duración de referencia</label>
                      <div className="flex flex-col space-y-2">
                        <div className="flex space-x-2 items-center">
                          <div className="flex flex-col items-center">
                            <input 
                              type="number" 
                              name="duracionReferenciaHoras" 
                              value={formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[0]) || 0 : 0} 
                              onChange={(e) => {
                                const horas = e.target.value;
                                const minutos = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[1]) || 0 : 0;
                                const segundos = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[2]) || 0 : 0;
                                const newValue = `${horas.padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                                handleChange({ target: { name: 'duracionReferencia', value: newValue } });
                              }}
                              onKeyDown={(e) => {
                                if (e.key === 'Enter' || e.target.value.length === 2) {
                                  e.target.nextElementSibling?.nextElementSibling?.focus();
                                }
                              }}
                              readOnly={isReadOnly} 
                              className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
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
                              name="duracionReferenciaMinutos" 
                              value={formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[1]) || 0 : 0} 
                              onChange={(e) => {
                                const horas = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[0]) || 0 : 0;
                                const minutos = e.target.value;
                                const segundos = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[2]) || 0 : 0;
                                const newValue = `${horas.toString().padStart(2, '0')}:${minutos.padStart(2, '0')}:${segundos.toString().padStart(2, '0')}`;
                                handleChange({ target: { name: 'duracionReferencia', value: newValue } });
                              }}
                              onKeyDown={(e) => {
                                if (e.key === 'Enter' || e.target.value.length === 2) {
                                  e.target.nextElementSibling?.nextElementSibling?.focus();
                                }
                              }}
                              readOnly={isReadOnly} 
                              className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
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
                              name="duracionReferenciaSegundos" 
                              value={formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[2]) || 0 : 0} 
                              onChange={(e) => {
                                const horas = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[0]) || 0 : 0;
                                const minutos = formData.duracionReferencia ? parseInt(formData.duracionReferencia.split(':')[1]) || 0 : 0;
                                const segundos = e.target.value;
                                const newValue = `${horas.toString().padStart(2, '0')}:${minutos.toString().padStart(2, '0')}:${segundos.padStart(2, '0')}`;
                                handleChange({ target: { name: 'duracionReferencia', value: newValue } });
                              }}
                              onKeyDown={(e) => {
                                if (e.key === 'Enter') {
                                  e.target.closest('form')?.querySelector('button[type="submit"]')?.focus();
                                }
                              }}
                              readOnly={isReadOnly} 
                              className="w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 text-center" 
                              min="0"
                              max="59"
                              placeholder="00"
                              title="Segundos (0-59)"
                            />
                            <span className="text-xs text-gray-500 mt-1">S</span>
                          </div>
                        </div>
                      </div>
                      <p className="mt-1 text-xs text-gray-500">Formato: HH:MM:SS</p>
                    </div>
                    
                    <div className="md:col-span-2">
                      <label className="block text-sm font-medium text-gray-700 mb-1">Nombre *</label>
                      <input 
                        type="text" 
                        name="nombre" 
                        value={formData.nombre || ''} 
                        onChange={handleChange} 
                        readOnly={isReadOnly} 
                        className={inputClass} 
                        required={!isReadOnly} 
                        placeholder="Ej: Reloj Matutino" 
                      />
                      {errors.nombre && <p className="mt-1 text-sm text-red-600">{errors.nombre}</p>}
                    </div>
                    
                    <div className="md:col-span-2">
                      <label className="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
                      <textarea 
                        name="descripcion" 
                        value={formData.descripcion || ''} 
                        onChange={handleChange} 
                        readOnly={isReadOnly} 
                        rows="3" 
                        className={inputClass} 
                        placeholder="Descripción del reloj..." 
                      />
                    </div>
                  </div>
                </div>
              );
              
            case 1: // Reglas
              return (
                <div className="space-y-4">
                  <div className="text-center py-8">
                    <div className="w-16 h-16 mx-auto mb-4 bg-purple-100 rounded-full flex items-center justify-center">
                      <svg className="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                    </div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Reglas del Reloj</h3>
                    <p className="text-gray-600">Configuración de reglas específicas para este reloj</p>
                    <p className="text-sm text-gray-500 mt-2">Funcionalidad en desarrollo</p>
                  </div>
                </div>
              );
              
            case 2: // Eventos del reloj
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
                            {categoriasSeleccionadas.map((cancion, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('canciones', cancion)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                                </svg>
                                <span>{cancion}</span>
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
                                  onClick={() => onPredefinedEventClick('corte-comercial', corte.nombre)}
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
                            onClick={() => onCategoryClick('nota-operador', 'Nota para el Operador')}
                          >
                            <svg className="w-4 h-4 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Nota para el Operador</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['NOTA_OP_1', 'NOTA_OP_2', 'NOTA_OP_3', 'NOTA_OP_4'].map((nota, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('nota-operador', nota)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                </svg>
                                <span>{nota}</span>
                              </div>
                            ))}
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
                                  onClick={() => onPredefinedEventClick('vacío', corte.nombre)}
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
                            {['ETM_00', 'ETM_15', 'ETM_30', 'ETM_45'].map((etm, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('exact-time-marker', etm)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span>{etm}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Canción Manual */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('cancion-manual', 'Canción Manual')}
                          >
                            <svg className="w-4 h-4 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Canción Manual</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['MANUAL_1', 'MANUAL_2', 'MANUAL_3', 'MANUAL_4'].map((manual, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('cancion-manual', manual)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
                                </svg>
                                <span>{manual}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Comando Automatización */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('comando-automatizacion', 'Comando Automatización')}
                          >
                            <svg className="w-4 h-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Comando Automatización</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['AUTO_CMD_1', 'AUTO_CMD_2', 'AUTO_CMD_3', 'AUTO_CMD_4'].map((cmd, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('comando-automatizacion', cmd)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                                <span>{cmd}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Twofer */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('twofer', 'Twofer')}
                          >
                            <svg className="w-4 h-4 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Twofer</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['TWOFER_1', 'TWOFER_2', 'TWOFER_3', 'TWOFER_4'].map((twofer, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('twofer', twofer)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-pink-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                                </svg>
                                <span>{twofer}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Característica Específica */}
                        <div>
                          <div 
                            className="flex items-center space-x-2 mb-2 cursor-pointer hover:bg-gray-50 p-1 rounded"
                            onClick={() => onCategoryClick('caracteristica-especifica', 'Característica Específica')}
                          >
                            <svg className="w-4 h-4 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                            </svg>
                            <span className="text-sm font-medium text-gray-700">Característica Específica</span>
                          </div>
                          <div className="space-y-1 ml-6">
                            {['CARAC_ESP_1', 'CARAC_ESP_2', 'CARAC_ESP_3', 'CARAC_ESP_4'].map((carac, index) => (
                              <div 
                                key={index} 
                                onClick={() => onPredefinedEventClick('caracteristica-especifica', carac)}
                                className="flex items-center space-x-2 text-sm text-gray-600 hover:bg-gray-50 p-1 rounded cursor-pointer"
                              >
                                <svg className="w-3 h-3 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                                </svg>
                                <span>{carac}</span>
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* Eventos Modelo */}
                        <div className="pt-3 border-t border-gray-200">
                          <label className="block text-sm font-medium text-gray-700 mb-2">Eventos Modelo</label>
                          <select className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500">
                            <option value="">Seleccionar evento modelo</option>
                            <option value="modelo1">Modelo 1 - Hora Completa</option>
                            <option value="modelo2">Modelo 2 - Media Hora</option>
                            <option value="modelo3">Modelo 3 - Personalizado</option>
                          </select>
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
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Desde ETM</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Desde corte</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Offset final</th>
                              <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipo</th>
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
                              console.log('🔄 Eventos en tabla:', events);
                              return events.map((event, index) => (
                              <tr key={event.id} className={`hover:bg-gray-50 ${index === getSelectedRelojEvents().length - 1 ? 'bg-blue-50 border-l-4 border-blue-500' : ''}`}>
                                <td className="px-3 py-2 text-sm font-medium text-gray-900">{event.numero}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.offset}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.desdeETM}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.desdeCorte}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.offsetFinal}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.tipo}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.categoria}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.descripcion}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.duracion}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.numeroCancion}</td>
                                <td className="px-3 py-2 text-sm text-gray-600">{event.sinCategorias}</td>
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
                                  console.error('Error al parsear tiempo:', error);
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
                                    'Exact Time Marker': '#06b6d4', // Cyan
                                    'Canción Manual': '#f97316', // Naranja
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
                              fill="#ffffff"
                              stroke="#e5e7eb"
                              strokeWidth="1"
                            />
                          </svg>
                        </div>
                        
                        {/* Leyenda de colores */}
                        <div className="mt-4">
                          <h4 className="text-sm font-medium text-gray-700 mb-2">Leyenda de colores:</h4>
                          <div className="grid grid-cols-2 gap-2 text-xs">
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-blue-500"></div>
                              <span className="text-gray-600">Canciones</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-red-500"></div>
                              <span className="text-gray-600">Corte Comercial</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
                              <span className="text-gray-600">Nota Operador</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-green-500"></div>
                              <span className="text-gray-600">ETM</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-purple-500"></div>
                              <span className="text-gray-600">Cartucho Fijo</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-cyan-500"></div>
                              <span className="text-gray-600">Exact Time Marker</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-orange-500"></div>
                              <span className="text-gray-600">Canción Manual</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-indigo-500"></div>
                              <span className="text-gray-600">Comando</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-pink-500"></div>
                              <span className="text-gray-600">Twofer</span>
                            </div>
                            <div className="flex items-center space-x-2">
                              <div className="w-3 h-3 rounded-full bg-lime-500"></div>
                              <span className="text-gray-600">Característica Específica</span>
                            </div>
                          </div>
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
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-2" onClick={(e) => e.target === e.currentTarget && onCancel()}>
            <div className="bg-white border border-gray-300 shadow-lg w-[95vw] max-w-[1400px] h-[95vh] overflow-hidden flex flex-col" onClick={(e) => e.stopPropagation()}>
              {/* Window Header */}
              <div className="bg-gray-100 border-b border-gray-300 px-4 py-2 flex justify-between items-center">
                <div className="flex items-center space-x-2">
                  <div className="w-4 h-4 bg-red-500 rounded-full"></div>
                  <div className="w-4 h-4 bg-yellow-500 rounded-full"></div>
                  <div className="w-4 h-4 bg-green-500 rounded-full"></div>
                </div>
                <div className="flex items-center space-x-4">
                  <h1 className="text-lg font-semibold text-gray-800">{title}</h1>
                  <div className="flex items-center space-x-2 text-sm text-gray-500">
                    <span>Políticas</span>
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                    </svg>
                    <span>Relojes</span>
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                    </svg>
                    <span className="text-purple-600 font-medium">{title}</span>
                  </div>
                  {!isReadOnly && (
                    <div className="flex items-center space-x-2 text-xs">
                      <div className={`px-2 py-1 rounded-full ${
                        mode === 'new' ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800'
                      }`}>
                        {mode === 'new' ? 'Nuevo' : 'Edición'}
                      </div>
                    </div>
                  )}
                </div>
                <button onClick={onCancel} className="text-gray-600 hover:text-gray-800 transition-colors">
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              {/* Tabs Navigation */}
              <div className="bg-white border-b border-gray-200">
                <div className="flex space-x-1 overflow-x-auto">
                  {tabs.map((tab) => (
                    <button 
                      key={tab.id} 
                      onClick={() => setActiveTab(tab.id)} 
                      className={`group flex items-center space-x-2 px-4 py-3 text-sm font-medium whitespace-nowrap transition-all duration-200 relative ${
                        activeTab === tab.id 
                          ? "text-purple-700 bg-purple-50 border-b-2 border-purple-600" 
                          : "text-gray-600 hover:text-purple-600 hover:bg-purple-50/50"
                      }`}
                    >
                      {tab.icon}
                      <span className="font-semibold">{tab.name}</span>
                    </button>
                  ))}
                </div>
              </div>
              
              {/* Form Content */}
              <div className="flex-1 overflow-y-auto p-4 bg-white">
                {renderTabContent()}
              </div>
              
              {/* Footer with Action Buttons */}
              <div className="bg-gray-50 border-t border-gray-300 px-6 py-4 flex justify-between items-center">
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
                <div className="flex space-x-3">
                  <button 
                    type="button" 
                    onClick={onCancel} 
                    disabled={isLoading} 
                    className="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                    <span>Cerrar</span>
                  </button>
                  {!isReadOnly && (
                    <button 
                      type="button" 
                      onClick={handleSubmit} 
                      disabled={isLoading} 
                      className="px-6 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
                    >
                      {isLoading ? (
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                      ) : (
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
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
            console.error('Error al parsear tiempo:', error);
            return [0, 0, 0];
          }
        };
        const [localFormData, setLocalFormData] = useState(formData);

        const title = `Agregar ${eventType?.name || 'Evento'}`;

        const inputClass = "w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500";

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
          
          // Validación adicional para Exact Time Marker
          if (eventType?.type === 'exact-time-marker') {
            if (!localFormData.tipoETM) newErrors.tipoETM = 'El Tipo ETM es requerido';
          }
          
          // Validación adicional para Comando Automatización
          if (eventType?.type === 'comando-automatizacion') {
            if (!localFormData.comandoDAS) newErrors.comandoDAS = 'El Comando DAS es requerido';
          }
          
          // Validación adicional para Twofer
          if (eventType?.type === 'twofer') {
            if (!localFormData.caracteristica) newErrors.caracteristica = 'La Característica es requerida';
            if (!localFormData.twoferValor) newErrors.twoferValor = 'El Twofer el valor es requerido';
            if (!localFormData.todasCategorias && !localFormData.categoriasUsar) {
              newErrors.categoriasUsar = 'Debe seleccionar categorías a usar si no usa todas las categorías';
            }
          }
          
          // Validación adicional para Característica Específica
          if (eventType?.type === 'caracteristica-especifica') {
            if (!localFormData.caracteristicaEspecifica) newErrors.caracteristicaEspecifica = 'La Característica es requerida';
            if (!localFormData.valorDeseado) newErrors.valorDeseado = 'El Valor deseado es requerido';
            if (!localFormData.usarTodasCategorias && !localFormData.categoriasUsarEspecifica) {
              newErrors.categoriasUsarEspecifica = 'Debe seleccionar categorías a usar si no usa todas las categorías';
            }
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
              // Campo adicional para Exact Time Marker
              ...(eventType?.type === 'exact-time-marker' && {
                tipoETM: localFormData.tipoETM
              }),
              // Campo adicional para Comando Automatización
              ...(eventType?.type === 'comando-automatizacion' && {
                comandoDAS: localFormData.comandoDAS
              }),
              // Campos adicionales para Twofer
              ...(eventType?.type === 'twofer' && {
                caracteristica: localFormData.caracteristica,
                twoferValor: localFormData.twoferValor,
                todasCategorias: localFormData.todasCategorias,
                categoriasUsar: localFormData.categoriasUsar,
                gruposReglasIgnorar: localFormData.gruposReglasIgnorar,
                clasificacionesEvento: localFormData.clasificacionesEvento
              }),
              // Campos adicionales para Característica Específica
              ...(eventType?.type === 'caracteristica-especifica' && {
                caracteristicaEspecifica: localFormData.caracteristicaEspecifica,
                valorDeseado: localFormData.valorDeseado,
                usarTodasCategorias: localFormData.usarTodasCategorias,
                categoriasUsarEspecifica: localFormData.categoriasUsarEspecifica,
                gruposReglasIgnorarEspecifica: localFormData.gruposReglasIgnorarEspecifica,
                clasificacionesEventoEspecifica: localFormData.clasificacionesEventoEspecifica
              })
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
            
            newEvent.offsetFinal = `${finalHours.toString().padStart(2, '0')}:${finalMinutes.toString().padStart(2, '0')}:${finalSeconds.toString().padStart(2, '0')}`;
            
            // Añadir el evento a la tabla
            addEventToReloj(newEvent);
            
            console.log('Evento añadido desde formulario:', newEvent);
            onSave(newEvent);
          } catch (error) {
            console.error('Error al guardar:', error);
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
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onClick={(e) => e.target === e.currentTarget && onCancel()}>
            <div className="bg-white border border-gray-300 shadow-lg w-[500px] max-h-[90vh] overflow-hidden flex flex-col" onClick={(e) => e.stopPropagation()}>
              {/* Window Header */}
              <div className="bg-gray-100 border-b border-gray-300 px-4 py-2 flex justify-between items-center">
                <div className="flex items-center space-x-2">
                  <div className="w-4 h-4 bg-red-500 rounded-full"></div>
                  <div className="w-4 h-4 bg-yellow-500 rounded-full"></div>
                  <div className="w-4 h-4 bg-green-500 rounded-full"></div>
                </div>
                <h1 className="text-lg font-semibold text-gray-800">{title}</h1>
                <button onClick={onCancel} className="text-gray-600 hover:text-gray-800 transition-colors">
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              {/* Form Content */}
              <div className="flex-1 overflow-y-auto p-6 bg-white">
                <div className="space-y-4">
                  {/* Consecutivo */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Consecutivo *</label>
                    <input 
                      type="text" 
                      name="consecutivo" 
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
                    <label className="block text-sm font-medium text-gray-700 mb-1">Offset *</label>
                    <div className="flex flex-col space-y-2">
                      <div className="flex space-x-2 items-center">
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
                            name="offsetHoras" 
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
                            name="offsetMinutos" 
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
                            name="offsetSegundos" 
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
                    <label className="block text-sm font-medium text-gray-700 mb-1">Duración *</label>
                    <div className="flex flex-col space-y-2">
                      <div className="flex space-x-2 items-center">
                        <div className="flex flex-col items-center">
                          <input 
                            type="number" 
                            name="duracionHoras" 
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
                            name="duracionMinutos" 
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
                            name="duracionSegundos" 
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
                    <label className="block text-sm font-medium text-gray-700 mb-1">Descripción *</label>
                    <textarea 
                      name="descripcion" 
                      value={localFormData.descripcion || ''} 
                      onChange={handleChange} 
                      rows="3" 
                      className={inputClass} 
                      required 
                      placeholder="Descripción del evento..." 
                    />
                    {errors.descripcion && <p className="mt-1 text-sm text-red-600">{errors.descripcion}</p>}
                  </div>

                  {/* Campos adicionales para Cartucho Fijo */}
                  {eventType?.type === 'cartucho-fijo' && (
                    <>
                      {/* ID Media */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">ID Media *</label>
                        <input 
                          type="text" 
                          name="idMedia" 
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
                        <label className="block text-sm font-medium text-gray-700 mb-1">Categoría *</label>
                        <select 
                          name="categoria" 
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

                  {/* Campo adicional para Exact Time Marker */}
                  {eventType?.type === 'exact-time-marker' && (
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Tipo ETM *</label>
                      <select 
                        name="tipoETM" 
                        value={localFormData.tipoETM || ''} 
                        onChange={handleChange} 
                        className={inputClass} 
                        required
                      >
                        <option value="">Seleccionar tipo ETM</option>
                        <option value="ETM_00">ETM 00</option>
                        <option value="ETM_15">ETM 15</option>
                        <option value="ETM_30">ETM 30</option>
                        <option value="ETM_45">ETM 45</option>
                      </select>
                      {errors.tipoETM && <p className="mt-1 text-sm text-red-600">{errors.tipoETM}</p>}
                    </div>
                  )}

                  {/* Campo adicional para Comando Automatización */}
                  {eventType?.type === 'comando-automatizacion' && (
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Comando DAS *</label>
                      <select 
                        name="comandoDAS" 
                        value={localFormData.comandoDAS || ''} 
                        onChange={handleChange} 
                        className={inputClass} 
                        required
                      >
                        <option value="">Seleccionar comando DAS</option>
                        <option value="DAS_CMD_1">DAS Comando 1</option>
                        <option value="DAS_CMD_2">DAS Comando 2</option>
                        <option value="DAS_CMD_3">DAS Comando 3</option>
                        <option value="DAS_CMD_4">DAS Comando 4</option>
                        <option value="DAS_CMD_5">DAS Comando 5</option>
                        <option value="DAS_CMD_6">DAS Comando 6</option>
                      </select>
                      {errors.comandoDAS && <p className="mt-1 text-sm text-red-600">{errors.comandoDAS}</p>}
                    </div>
                  )}

                  {/* Campos adicionales para Twofer */}
                  {eventType?.type === 'twofer' && (
                    <>
                      {/* Característica */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Característica *</label>
                        <select 
                          name="caracteristica" 
                          value={localFormData.caracteristica || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required
                        >
                          <option value="">Seleccionar característica</option>
                          <option value="CARACT_1">Característica 1</option>
                          <option value="CARACT_2">Característica 2</option>
                          <option value="CARACT_3">Característica 3</option>
                          <option value="CARACT_4">Característica 4</option>
                        </select>
                        {errors.caracteristica && <p className="mt-1 text-sm text-red-600">{errors.caracteristica}</p>}
                      </div>

                      {/* Twofer el valor */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Twofer el valor *</label>
                        <select 
                          name="twoferValor" 
                          value={localFormData.twoferValor || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required
                        >
                          <option value="">Seleccionar valor</option>
                          <option value="TWOFER_1">Twofer 1</option>
                          <option value="TWOFER_2">Twofer 2</option>
                          <option value="TWOFER_3">Twofer 3</option>
                          <option value="TWOFER_4">Twofer 4</option>
                        </select>
                        {errors.twoferValor && <p className="mt-1 text-sm text-red-600">{errors.twoferValor}</p>}
                      </div>

                      {/* Todas las categorías */}
                      <div>
                        <label className="flex items-center space-x-2">
                          <input 
                            type="checkbox" 
                            name="todasCategorias" 
                            checked={localFormData.todasCategorias || true} 
                            onChange={(e) => handleChange({ target: { name: 'todasCategorias', value: e.target.checked } })} 
                            className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                          />
                          <span className="text-sm font-medium text-gray-700">Todas las categorías</span>
                        </label>
                      </div>

                      {/* Categorías a usar */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Categorías a usar</label>
                        <select 
                          name="categoriasUsar" 
                          value={localFormData.categoriasUsar || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          disabled={localFormData.todasCategorias}
                        >
                          <option value="">Seleccionar categorías</option>
                          <option value="CAT_1">Categoría 1</option>
                          <option value="CAT_2">Categoría 2</option>
                          <option value="CAT_3">Categoría 3</option>
                          <option value="CAT_4">Categoría 4</option>
                        </select>
                        {errors.categoriasUsar && <p className="mt-1 text-sm text-red-600">{errors.categoriasUsar}</p>}
                      </div>

                      {/* Grupos reglas a ignorar */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Grupos reglas a ignorar</label>
                        <select 
                          name="gruposReglasIgnorar" 
                          value={localFormData.gruposReglasIgnorar || ''} 
                          onChange={handleChange} 
                          className={inputClass}
                        >
                          <option value="">Seleccionar grupos</option>
                          <option value="GRUPO_1">Grupo 1</option>
                          <option value="GRUPO_2">Grupo 2</option>
                          <option value="GRUPO_3">Grupo 3</option>
                          <option value="GRUPO_4">Grupo 4</option>
                        </select>
                        {errors.gruposReglasIgnorar && <p className="mt-1 text-sm text-red-600">{errors.gruposReglasIgnorar}</p>}
                      </div>

                      {/* Clasificaciones del evento */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Clasificaciones del evento</label>
                        <select 
                          name="clasificacionesEvento" 
                          value={localFormData.clasificacionesEvento || ''} 
                          onChange={handleChange} 
                          className={inputClass}
                        >
                          <option value="">Seleccionar clasificación</option>
                          <option value="CLASIF_1">Clasificación 1</option>
                          <option value="CLASIF_2">Clasificación 2</option>
                          <option value="CLASIF_3">Clasificación 3</option>
                          <option value="CLASIF_4">Clasificación 4</option>
                        </select>
                        {errors.clasificacionesEvento && <p className="mt-1 text-sm text-red-600">{errors.clasificacionesEvento}</p>}
                      </div>
                    </>
                  )}

                  {/* Campos adicionales para Característica Específica */}
                  {eventType?.type === 'caracteristica-especifica' && (
                    <>
                      {/* Característica */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Característica *</label>
                        <select 
                          name="caracteristicaEspecifica" 
                          value={localFormData.caracteristicaEspecifica || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required
                        >
                          <option value="">Seleccionar característica</option>
                          <option value="CARACT_ESP_1">Característica Específica 1</option>
                          <option value="CARACT_ESP_2">Característica Específica 2</option>
                          <option value="CARACT_ESP_3">Característica Específica 3</option>
                          <option value="CARACT_ESP_4">Característica Específica 4</option>
                        </select>
                        {errors.caracteristicaEspecifica && <p className="mt-1 text-sm text-red-600">{errors.caracteristicaEspecifica}</p>}
                      </div>

                      {/* Valor deseado */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Valor deseado *</label>
                        <input 
                          type="text" 
                          name="valorDeseado" 
                          value={localFormData.valorDeseado || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          required 
                          placeholder="Ingrese el valor deseado" 
                        />
                        {errors.valorDeseado && <p className="mt-1 text-sm text-red-600">{errors.valorDeseado}</p>}
                      </div>

                      {/* Usar todas las categorías */}
                      <div>
                        <label className="flex items-center space-x-2">
                          <input 
                            type="checkbox" 
                            name="usarTodasCategorias" 
                            checked={localFormData.usarTodasCategorias || true} 
                            onChange={(e) => handleChange({ target: { name: 'usarTodasCategorias', value: e.target.checked } })} 
                            className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                          />
                          <span className="text-sm font-medium text-gray-700">Usar todas las categorías</span>
                        </label>
                      </div>

                      {/* Categorías a usar */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Categorías a usar</label>
                        <select 
                          name="categoriasUsarEspecifica" 
                          value={localFormData.categoriasUsarEspecifica || ''} 
                          onChange={handleChange} 
                          className={inputClass} 
                          disabled={localFormData.usarTodasCategorias}
                        >
                          <option value="">Seleccionar categorías</option>
                          <option value="CAT_ESP_1">Categoría Específica 1</option>
                          <option value="CAT_ESP_2">Categoría Específica 2</option>
                          <option value="CAT_ESP_3">Categoría Específica 3</option>
                          <option value="CAT_ESP_4">Categoría Específica 4</option>
                        </select>
                        {errors.categoriasUsarEspecifica && <p className="mt-1 text-sm text-red-600">{errors.categoriasUsarEspecifica}</p>}
                      </div>

                      {/* Grupos reglas a ignorar */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Grupos reglas a ignorar</label>
                        <select 
                          name="gruposReglasIgnorarEspecifica" 
                          value={localFormData.gruposReglasIgnorarEspecifica || ''} 
                          onChange={handleChange} 
                          className={inputClass}
                        >
                          <option value="">Seleccionar grupos</option>
                          <option value="GRUPO_ESP_1">Grupo Específico 1</option>
                          <option value="GRUPO_ESP_2">Grupo Específico 2</option>
                          <option value="GRUPO_ESP_3">Grupo Específico 3</option>
                          <option value="GRUPO_ESP_4">Grupo Específico 4</option>
                        </select>
                        {errors.gruposReglasIgnorarEspecifica && <p className="mt-1 text-sm text-red-600">{errors.gruposReglasIgnorarEspecifica}</p>}
                      </div>

                      {/* Clasificaciones del evento */}
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Clasificaciones del evento</label>
                        <select 
                          name="clasificacionesEventoEspecifica" 
                          value={localFormData.clasificacionesEventoEspecifica || ''} 
                          onChange={handleChange} 
                          className={inputClass}
                        >
                          <option value="">Seleccionar clasificación</option>
                          <option value="CLASIF_ESP_1">Clasificación Específica 1</option>
                          <option value="CLASIF_ESP_2">Clasificación Específica 2</option>
                          <option value="CLASIF_ESP_3">Clasificación Específica 3</option>
                          <option value="CLASIF_ESP_4">Clasificación Específica 4</option>
                        </select>
                        {errors.clasificacionesEventoEspecifica && <p className="mt-1 text-sm text-red-600">{errors.clasificacionesEventoEspecifica}</p>}
                      </div>
                    </>
                  )}
                </div>
              </div>
              
              {/* Footer with Action Buttons */}
              <div className="bg-gray-50 border-t border-gray-300 px-6 py-4 flex justify-end space-x-3">
                <button 
                  type="button" 
                  onClick={onCancel} 
                  disabled={isLoading} 
                  className="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                  <span>Cancelar</span>
                </button>
                <button 
                  type="button" 
                  onClick={handleSubmit} 
                  disabled={isLoading} 
                  className="px-6 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
                >
                  {isLoading ? (
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  ) : (
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
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
  onCategoriasSaved,
  categoriasSeleccionadas,
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
  handleNewDiaModelo,
  handleEditDiaModelo,
  handleViewDiaModelo,
  handleDeleteDiaModelo,
  handleSaveDiaModelo,
  getEventColor,
  relojEvents,
  calculateTotalDuration,
  getSelectedRelojEvents,
  getSelectedRelojDuration
}) {
  
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const [activeTab, setActiveTab] = useState(propActiveTab !== undefined ? propActiveTab : 0);
  const [editingDiaModeloIndex, setEditingDiaModeloIndex] = useState(null);
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

  // Funciones locales para manejar días modelo
  const handleNewDiaModeloLocal = () => {
    setEditingDiaModeloIndex(null);
    setShowDiaModeloForm(true);
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
    diasModelo: politica?.diasModelo || []
  });

  const isReadOnly = mode === 'view';
  const title = mode === 'new' ? 'Nueva Política' : 
               mode === 'edit' ? 'Editar Política' : 
               'Consultar Política';

  // Mock data para difusoras
  const difusoras = [
    { value: 'XRAD', label: 'XRAD' },
    { value: 'XHPER', label: 'XHPER' },
    { value: 'XHGR', label: 'XHGR' },
    { value: 'XHOZ', label: 'XHOZ' }
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
      name: 'Sets de reglas', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
        </svg>
      )
    },
    { 
      id: 2, 
      name: 'Reglas', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      )
    },
    { 
      id: 3, 
      name: 'Orden de asignación', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
      )
    },
    { 
      id: 4, 
      name: 'Relojes', 
      icon: (
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      )
    },
    { 
      id: 5, 
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
      await onSave(formData);
    } catch (err) {
      console.error('Error in form submission:', err);
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

  const inputClass = `w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 ${
    isReadOnly ? 'bg-gray-50 text-gray-600' : 'bg-white text-gray-900'
  }`;

  const selectClass = `w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-purple-500 ${
    isReadOnly ? 'bg-gray-50 text-gray-600' : 'bg-white text-gray-900'
  }`;

  const renderTabContent = () => {
    switch (activeTab) {
      case 0: // Datos generales
        return (
          <div className="space-y-6">
            {/* Habilitada checkbox */}
            <div className="flex items-center space-x-3">
              <input
                type="checkbox"
                name="habilitada"
                checked={formData.habilitada}
                onChange={handleChange}
                disabled={isReadOnly}
                className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
              />
              <label className="text-sm font-medium text-gray-700">Política habilitada</label>
            </div>

            {/* Form fields */}
            <div className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Clave *
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
                    <p className="mt-1 text-sm text-red-600">{errors.clave}</p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Difusora *
                  </label>
                  <input
                    type="text"
                    name="difusora"
                    value={formData.difusora || ''}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    placeholder="Ej: RADIO_1"
                  />
                  {errors.difusora && (
                    <p className="mt-1 text-sm text-red-600">{errors.difusora}</p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Nombre *
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
                    <p className="mt-1 text-sm text-red-600">{errors.nombre}</p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Descripción
                  </label>
                  <textarea
                    name="descripcion"
                    value={formData.descripcion || ''}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    rows="3"
                    className={inputClass}
                    placeholder="Descripción de la política..."
                  />
                </div>
              </div>
            </div>
          </div>
        );

      case 1: // Sets de reglas
        return (
          <div className="space-y-4">
            <div className="text-center py-8">
              <div className="w-16 h-16 mx-auto mb-4 bg-purple-100 rounded-full flex items-center justify-center">
                <svg className="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
              </div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Sets de Reglas</h3>
              <p className="text-gray-600">Configuración de sets de reglas para esta política</p>
              <p className="text-sm text-gray-500 mt-2">Funcionalidad en desarrollo</p>
            </div>
          </div>
        );

      case 2: // Reglas
        return (
          <div className="space-y-4">
            <div className="text-center py-8">
              <div className="w-16 h-16 mx-auto mb-4 bg-purple-100 rounded-full flex items-center justify-center">
                <svg className="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Reglas</h3>
              <p className="text-gray-600">Configuración de reglas específicas</p>
              <p className="text-sm text-gray-500 mt-2">Funcionalidad en desarrollo</p>
            </div>
          </div>
        );

      case 3: // Orden de asignación
        return (
          <OrdenAsignacion 
            politicaId={1} // ID fijo por ahora, en una implementación real vendría del estado
            onSave={onCategoriasSaved}
            onCancel={() => {
              // Cerrar el modal o volver a la vista anterior
            }}
          />
        );

      case 4: // Relojes
        return (
          <div className="space-y-6">
            {/* Header */}
            <div className="flex justify-between items-center">
              <div>
                <h3 className="text-lg font-semibold text-gray-900">Gestión de Relojes</h3>
                <p className="text-sm text-gray-600">Administra los relojes de programación</p>
              </div>
              <button
                onClick={() => {
                  console.log('🔵 Botón Nuevo Reloj clickeado');
                  console.log('🔵 onNewReloj disponible:', typeof onNewReloj);
                  if (onNewReloj) {
                    onNewReloj();
                  } else {
                    console.error('❌ onNewReloj no está definido');
                  }
                }}
                className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors flex items-center space-x-2"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nuevo Reloj</span>
              </button>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Left Panel - Data Grid */}
              <div className="lg:col-span-2 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div className="p-4 border-b border-gray-200">
                  <h4 className="font-medium text-gray-900">Lista de Relojes</h4>
                                        <p className="text-xs text-gray-500 mt-1">Arrastre una columna aquí para agrupar • Doble click para editar</p>
                </div>
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          <input type="checkbox" className="rounded border-gray-300 text-purple-600 focus:ring-purple-500" />
                        </th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Habilitado</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Clave</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Grupo</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"># Regla</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"># Eventos</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duración</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">¡Con Evento</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {relojes.map((reloj, index) => (
                        <tr 
                          key={reloj.id} 
                          className={`${selectedRelojInTable?.id === reloj.id ? 'bg-blue-50 border-l-4 border-blue-500' : ''} hover:bg-gray-50 cursor-pointer`}
                                                          onClick={() => {
                                  console.log('🔄 Reloj seleccionado en tabla:', reloj);
                                  setSelectedRelojInTable(reloj);
                                }}
                          onDoubleClick={() => handleEditReloj(reloj)}
                        >
                          <td className="px-3 py-2">
                            <div className="flex items-center">
                              <div className="w-2 h-2 bg-black transform rotate-45"></div>
                            </div>
                          </td>
                          <td className="px-3 py-2">
                            <input 
                              type="checkbox" 
                              checked={reloj.habilitado || false} 
                              onChange={(e) => {
                                setRelojes(prev => prev.map(r => 
                                  r.id === reloj.id ? { ...r, habilitado: e.target.checked } : r
                                ));
                              }}
                              className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                              onClick={(e) => e.stopPropagation()}
                            />
                          </td>
                          <td className="px-3 py-2 text-sm font-medium text-gray-900">{reloj.clave}</td>
                          <td className="px-3 py-2 text-sm text-gray-500">{reloj.grupo}</td>
                          <td className="px-3 py-2 text-sm text-gray-500">{reloj.numeroRegla}</td>
                          <td className="px-3 py-2 text-sm text-gray-900">{reloj.nombre}</td>
                          <td className="px-3 py-2 text-sm text-gray-500">{reloj.eventos ? reloj.eventos.length : 0} eventos</td>
                          <td className="px-3 py-2 text-sm text-gray-500">{reloj.duracion}</td>
                          <td className="px-3 py-2">
                            <input 
                              type="checkbox" 
                              checked={reloj.conEvento || false} 
                              onChange={(e) => {
                                setRelojes(prev => prev.map(r => 
                                  r.id === reloj.id ? { ...r, conEvento: e.target.checked } : r
                                ));
                              }}
                              className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                              onClick={(e) => e.stopPropagation()}
                            />
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
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
                            console.error('Error al parsear tiempo:', error);
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
                              'Exact Time Marker': '#06b6d4', // Cyan
                              'Canción Manual': '#f97316', // Naranja
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
                  
                  {/* Leyenda de colores */}
                  <div className="mt-4">
                    <h5 className="text-sm font-medium text-gray-700 mb-3">Leyenda de colores:</h5>
                    <div className="grid grid-cols-2 gap-2 text-xs">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-blue-500"></div>
                        <span>Canciones</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-red-500"></div>
                        <span>Corte Comercial</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
                        <span>Nota Operador</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-green-500"></div>
                        <span>ETM</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-purple-500"></div>
                        <span>Cartucho Fijo</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-cyan-500"></div>
                        <span>Exact Time Marker</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-orange-500"></div>
                        <span>Canción Manual</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-indigo-500"></div>
                        <span>Comando</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-pink-500"></div>
                        <span>Twofer</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 rounded-full bg-lime-500"></div>
                        <span>Característica Específica</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* Estadísticas */}
                  <div className="mt-4 p-3 bg-gray-50 rounded-lg">
                    <div className="text-sm text-gray-700">
                      <div className="flex justify-between items-center mb-2">
                        <span className="font-medium">Total:</span>
                        <span className="font-bold text-purple-600">{getSelectedRelojEvents().length} eventos</span>
                      </div>
                      <div className="flex justify-between items-center">
                        <span className="font-medium">Duración:</span>
                        <span className="text-gray-600">{getSelectedRelojDuration()}</span>
                      </div>
                      <div className="mt-2 p-2 bg-yellow-100 rounded text-xs">
                        <strong>Debug:</strong> Reloj seleccionado: {selectedRelojInTable?.nombre || 'Ninguno'} | 
                        Eventos: {getSelectedRelojEvents().length} | 
                        Estado relojes: {relojes.length}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex space-x-3">
              <button 
                onClick={handleNewReloj}
                className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition-colors flex items-center space-x-2"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Añadir</span>
              </button>
              <button 
                onClick={() => selectedRelojInTable && handleEditReloj(selectedRelojInTable)}
                disabled={!selectedRelojInTable}
                className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
                <span>Editar</span>
              </button>

              <button 
                onClick={() => selectedRelojInTable && handleDeleteReloj(selectedRelojInTable.id)}
                disabled={!selectedRelojInTable}
                className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
                <span>Eliminar</span>
              </button>
            </div>
          </div>
        );

      case 5: // Días modelo
        return (
          <div className="flex flex-col h-full space-y-4">
            {/* Header */}
            <div className="flex justify-between items-center mb-4">
              <div>
                <h3 className="text-lg font-semibold text-gray-900">Días Modelo</h3>
                <p className="text-sm text-gray-600">Configuración de días modelo para la programación</p>
                <p className="text-xs text-gray-400">Total: {diasModelo?.length || 0} días modelo</p>
              </div>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 xl:grid-cols-3 gap-4 flex-1">
              {/* Left/Center Panel - Días Modelo Table */}
              <div className="xl:col-span-2 bg-white rounded-lg border border-gray-200 shadow-sm">
                <div className="p-4 border-b border-gray-200">
                  <h4 className="font-medium text-gray-900">Lista de Días Modelo</h4>
                  <p className="text-xs text-gray-500 mt-1">Arrastre una columna aquí para agrupar • Doble click para editar</p>
                </div>
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Habilitado</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Clave</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Días</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Descripción</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {diasModelo.length === 0 ? (
                        <tr>
                          <td colSpan="6" className="px-6 py-12 text-center">
                            <div className="flex flex-col items-center space-y-2">
                              <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                              </svg>
                              <p className="text-gray-500 font-medium">No hay días modelo configurados</p>
                              <p className="text-sm text-gray-400">Agrega días modelo para comenzar</p>
                            </div>
                          </td>
                        </tr>
                      ) : (
                        diasModelo.map((diaModelo, index) => (
                          <tr key={diaModelo.id || index} className="hover:bg-gray-50">
                            <td className="px-3 py-2">
                              <input
                                type="checkbox"
                                checked={diaModelo.habilitado || false}
                                onChange={(e) => {
                                  const updatedDiasModelo = [...diasModelo];
                                  updatedDiasModelo[index] = { ...diaModelo, habilitado: e.target.checked };
                                  setDiasModelo(updatedDiasModelo);
                                }}
                                disabled={isReadOnly}
                                className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                              />
                            </td>
                            <td className="px-3 py-2 text-sm text-gray-900">{diaModelo.clave}</td>
                            <td className="px-3 py-2 text-sm text-gray-900">{diaModelo.nombre}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">
                              {[
                                diaModelo.lunes && 'L',
                                diaModelo.martes && 'M',
                                diaModelo.miercoles && 'X',
                                diaModelo.jueves && 'J',
                                diaModelo.viernes && 'V',
                                diaModelo.sabado && 'S',
                                diaModelo.domingo && 'D'
                              ].filter(Boolean).join(', ')}
                            </td>
                            <td className="px-3 py-2 text-sm text-gray-500 truncate max-w-xs" title={diaModelo.descripcion}>
                              {diaModelo.descripcion || '-'}
                            </td>
                            <td className="px-3 py-2">
                              <div className="flex space-x-2">
                                <button
                                  onClick={() => handleViewDiaModeloLocal(diaModelo)}
                                  className="text-blue-500 hover:text-blue-700 transition-colors"
                                  title="Consultar día modelo"
                                >
                                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                  </svg>
                                </button>
                                {!isReadOnly && (
                                  <>
                                    <button
                                      onClick={() => handleEditDiaModeloLocal(diaModelo)}
                                      className="text-green-500 hover:text-green-700 transition-colors"
                                      title="Editar día modelo"
                                    >
                                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                      </svg>
                                    </button>
                                    <button
                                      onClick={() => {
                                        if (window.confirm(`¿Está seguro de eliminar el día modelo "${diaModelo.nombre || diaModelo.clave}"?`)) {
                                          handleDeleteDiaModelo(diaModelo);
                                        }
                                      }}
                                      className="text-red-500 hover:text-red-700 transition-colors"
                                      title="Eliminar día modelo"
                                    >
                                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                      </svg>
                                    </button>
                                  </>
                                )}
                              </div>
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
                
                {/* Action Buttons */}
                <div className="p-4 border-t border-gray-200 bg-gray-50">
                  <div className="flex space-x-2">
                    <button
                      onClick={() => handleNewDiaModeloLocal()}
                      className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors flex items-center space-x-2"
                      disabled={isReadOnly}
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                      </svg>
                      <span>Añadir</span>
                    </button>
                    <button
                      onClick={() => {
                        if (diasModelo.length > 0) {
                          handleViewDiaModeloLocal(diasModelo[0]); // Consultar el primer día modelo
                        }
                      }}
                      className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors flex items-center space-x-2"
                      disabled={diasModelo.length === 0}
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                      </svg>
                      <span>Consultar</span>
                    </button>
                    <button
                      onClick={() => {
                        if (diasModelo.length > 0) {
                          handleEditDiaModeloLocal(diasModelo[0]); // Editar el primer día modelo
                        }
                      }}
                      className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors flex items-center space-x-2"
                      disabled={isReadOnly || diasModelo.length === 0}
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                      <span>Editar</span>
                    </button>

                    <button
                      onClick={() => {
                        if (diasModelo.length > 0 && window.confirm('¿Está seguro de eliminar este día modelo?')) {
                          handleDeleteDiaModelo(diasModelo[0]); // Eliminar el primer día modelo
                        }
                      }}
                      className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors flex items-center space-x-2"
                      disabled={isReadOnly || diasModelo.length === 0}
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                      <span>Eliminar</span>
                    </button>
                  </div>
                </div>
              </div>

              {/* Right Panel - Día Modelo Configuration */}
              <div className="bg-white rounded-lg border border-gray-200 shadow-sm">
                <div className="p-4 border-b border-gray-200">
                  <h4 className="font-medium text-gray-900">Día Modelo default por día</h4>
                </div>
                <div className="p-4 space-y-4">
                  {[
                    { key: 'lunes', label: 'Lunes' },
                    { key: 'martes', label: 'Martes' },
                    { key: 'miercoles', label: 'Miércoles' },
                    { key: 'jueves', label: 'Jueves' },
                    { key: 'viernes', label: 'Viernes' },
                    { key: 'sabado', label: 'Sábado' },
                    { key: 'domingo', label: 'Domingo' }
                  ].map((dia) => (
                    <div key={dia.key} className="flex items-center space-x-3">
                      <label className="text-sm font-medium text-gray-700 min-w-[80px]">
                        {dia.label}
                      </label>
                      <div className="flex-1 relative">
                        <select
                          value={formData[dia.key] || ''}
                          onChange={(e) => {
                            setFormData(prev => ({
                              ...prev,
                              [dia.key]: e.target.value
                            }));
                          }}
                          className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 pr-8 appearance-none bg-white"
                          disabled={isReadOnly}
                        >
                          <option value="">Seleccionar día modelo</option>
                          {diasModelo.map((diaModelo) => (
                            <option key={diaModelo.id} value={diaModelo.id}>
                              {diaModelo.nombre || diaModelo.clave}
                            </option>
                          ))}
                        </select>
                        <div className="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
                          <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                          </svg>
                        </div>
                      </div>
                    </div>
                  ))}
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
      className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
      onClick={(e) => e.target === e.currentTarget && onCancel()}
    >
      <div 
        className="bg-white border border-gray-300 shadow-lg w-[800px] max-h-[90vh] overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Window Header */}
        <div className="bg-gray-100 border-b border-gray-300 px-4 py-2 flex justify-between items-center">
          <div className="flex items-center space-x-2">
            <div className="w-4 h-4 bg-red-500 rounded-full"></div>
            <div className="w-4 h-4 bg-yellow-500 rounded-full"></div>
            <div className="w-4 h-4 bg-green-500 rounded-full"></div>
          </div>
          <h1 className="text-lg font-semibold text-gray-800">{title}</h1>
          <button
            onClick={onCancel}
            className="text-gray-600 hover:text-gray-800 transition-colors"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Tabs Navigation */}
        <div className="bg-white border-b border-gray-200">
          <div className="flex space-x-1 overflow-x-auto">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`group flex items-center space-x-2 px-4 py-3 text-sm font-medium whitespace-nowrap transition-all duration-200 relative ${
                  activeTab === tab.id
                    ? "text-purple-700 bg-purple-50 border-b-2 border-purple-600"
                    : "text-gray-600 hover:text-purple-600 hover:bg-purple-50/50"
                }`}
              >
                {tab.icon}
                <span className="font-semibold">{tab.name}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Form Content */}
        <div className="flex-1 overflow-y-auto p-6 bg-white">
          {renderTabContent()}
        </div>
        
        {/* Footer with Action Buttons */}
        <div className="bg-gray-50 border-t border-gray-300 px-6 py-4 flex justify-end space-x-3">
          <button
            type="button"
            onClick={onCancel}
            disabled={isLoading}
            className="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
          >
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
            <span>Cerrar</span>
          </button>
          
          {!isReadOnly && (
            <button
              type="button"
              onClick={handleSubmit}
              disabled={isLoading}
              className="px-6 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
            >
              {isLoading ? (
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              ) : (
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
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
              console.error('Error al guardar día modelo:', error);
            }
          }}
          onCancel={() => {
            setShowDiaModeloForm(false);
            setEditingDiaModeloIndex(null);
          }}
        />
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
    difusora: diaModelo?.difusora || 'RADIO_1', // Valor por defecto
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
      setRelojesDiaModelo(diaModelo.relojes);
    } else {
      setRelojesDiaModelo([]);
    }
  }, [diaModelo, mode]);

  // Estado para la búsqueda de relojes
  const [relojSearchTerm, setRelojSearchTerm] = useState('');

  // Filtrar relojes basado en el término de búsqueda
  const filteredRelojes = relojes.filter(reloj => {
    const searchTerm = relojSearchTerm.toLowerCase();
    return (
      reloj.nombre?.toLowerCase().includes(searchTerm) ||
      reloj.clave?.toLowerCase().includes(searchTerm) ||
      reloj.grupo?.toLowerCase().includes(searchTerm) ||
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

  const inputClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;
  const selectClass = `w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500 ${isReadOnly ? 'bg-gray-100' : 'bg-white'}`;

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
      
      console.log('📦 Datos a guardar día modelo:', dataToSave);
      await onSave(dataToSave);
      console.log('✅ Día modelo guardado exitosamente');
    } catch (error) {
      console.error('❌ Error al guardar día modelo:', error);
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

  const renderTabContent = () => {
    switch (activeTab) {
      case 0: // Datos generales
        return (
          <div className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Checkbox: Día modelo habilitado */}
              <div className="md:col-span-2">
                <div className="flex items-center space-x-3">
                  <input
                    type="checkbox"
                    id="habilitado"
                    name="habilitado"
                    checked={formData.habilitado}
                    onChange={handleChange}
                    disabled={isReadOnly}
                    className="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
                  />
                  <label htmlFor="habilitado" className="text-sm font-medium text-gray-700">
                    Día modelo habilitado
                  </label>
                </div>
              </div>


              {/* Input: Clave */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Clave *</label>
                <input
                  type="text"
                  name="clave"
                  value={formData.clave || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  className={inputClass}
                  placeholder="Clave del día modelo"
                  required={!isReadOnly}
                />
                {errors.clave && <p className="text-red-500 text-xs mt-1">{errors.clave}</p>}
              </div>

              {/* Input: Nombre */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Nombre *</label>
                <input
                  type="text"
                  name="nombre"
                  value={formData.nombre || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  className={inputClass}
                  placeholder="Nombre del día modelo"
                  required={!isReadOnly}
                />
                {errors.nombre && <p className="text-red-500 text-xs mt-1">{errors.nombre}</p>}
              </div>

              {/* Textarea: Descripción */}
              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
                <textarea
                  name="descripcion"
                  value={formData.descripcion || ''}
                  onChange={handleChange}
                  readOnly={isReadOnly}
                  rows={3}
                  className={inputClass}
                  placeholder="Descripción del día modelo"
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
                            <td className="px-3 py-2 text-sm text-gray-500">{reloj.duracion || '0\' 0"'}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{reloj.eventos?.length || 0}</td>
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
                                className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
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
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cortes</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Otros</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">¡Sin</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {relojesDiaModelo.length === 0 ? (
                        <tr>
                          <td colSpan="10" className="px-6 py-12 text-center">
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
                            <td className="px-3 py-2 text-sm text-gray-500">{reloj.duracion || '0\' 0"'}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">{reloj.eventos?.length || 0}</td>
                            <td className="px-3 py-2 text-sm text-gray-500">0:00:00</td>
                            <td className="px-3 py-2 text-sm text-gray-500">0:00:00</td>
                            <td className="px-3 py-2 text-sm text-gray-500">0:00:00</td>
                            <td className="px-3 py-2">
                              <input
                                type="checkbox"
                                checked={true}
                                disabled
                                className="rounded border-gray-300 text-purple-600 focus:ring-purple-500"
                              />
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
                  <span className="font-medium">{relojesDiaModelo.length} relojes, {relojesDiaModelo.reduce((acc, r) => acc + (r.eventos?.length || 0), 0)} eventos, 0 ms</span>
                </div>
                <div className="flex space-x-4">
                  <span>Música: 0 - 0 ms</span>
                  <span>Cortes Comerciales: 0 - 0 ms</span>
                  <span>Otros: 0 - 0 ms</span>
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
      className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[60] p-4"
      onClick={(e) => e.target === e.currentTarget && onCancel()}
    >
      <div 
        className="bg-white border border-gray-300 shadow-lg w-[95vw] max-w-[1200px] h-[95vh] overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Window Header */}
        <div className="bg-gray-100 border-b border-gray-300 px-4 py-2 flex justify-between items-center">
          <div className="flex items-center space-x-2">
            <div className="w-4 h-4 bg-red-500 rounded-full"></div>
            <div className="w-4 h-4 bg-yellow-500 rounded-full"></div>
            <div className="w-4 h-4 bg-green-500 rounded-full"></div>
          </div>
          <h1 className="text-lg font-semibold text-gray-800">{title}</h1>
          <button
            onClick={onCancel}
            className="text-gray-600 hover:text-gray-800 transition-colors"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Tabs Navigation */}
        <div className="bg-white border-b border-gray-200">
          <div className="flex space-x-1 overflow-x-auto">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`group flex items-center space-x-2 px-4 py-3 text-sm font-medium whitespace-nowrap transition-all duration-200 relative ${
                  activeTab === tab.id
                    ? "text-purple-700 bg-purple-50 border-b-2 border-purple-600"
                    : "text-gray-600 hover:text-purple-600 hover:bg-purple-50/50"
                }`}
              >
                {tab.icon}
                <span className="font-semibold">{tab.name}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Form Content */}
        <div className="flex-1 overflow-y-auto p-6 bg-white">
          {renderTabContent()}
        </div>
        
        {/* Footer with Action Buttons */}
        <div className="bg-gray-50 border-t border-gray-300 px-6 py-4 flex justify-end space-x-3">
          <button
            type="button"
            onClick={onCancel}
            disabled={isLoading}
            className="px-6 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
          >
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
            <span>Cerrar</span>
          </button>
          
          {!isReadOnly && (
            <button
              type="button"
              onClick={handleSubmit}
              disabled={isLoading}
              className="px-6 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors disabled:opacity-50 flex items-center space-x-2"
            >
              {isLoading ? (
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              ) : (
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
              )}
              <span>{isLoading ? 'Guardando...' : mode === 'new' ? 'Crear' : 'Guardar'}</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
