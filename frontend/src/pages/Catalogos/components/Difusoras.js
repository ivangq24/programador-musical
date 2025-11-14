import React, { useState, useEffect, useMemo, useCallback } from 'react';
import { 
  Plus, 
  Eye, 
  EyeOff, 
  Download, 
  Search, 
  X, 
  Building2, 
  CheckCircle, 
  Edit, 
  Trash2,
  Filter,
  AlertCircle
} from 'lucide-react';
import { getDifusoras, createDifusora, updateDifusora, deleteDifusora, getDifusorasStats, exportDifusorasToCSV } from '../../../api/catalogos/generales/difusorasApi';

export default function Difusoras({ onDifusoraSelect }) {
  // Estado para difusoras desde la API - cargar todas una vez, filtrar del lado del cliente
  const [difusoras, setDifusoras] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [formMode, setFormMode] = useState('new'); // 'new', 'edit', 'view'
  const [selectedDifusora, setSelectedDifusora] = useState(null);
  const [showOnlyActive, setShowOnlyActive] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [notification, setNotification] = useState(null);
  const [stats, setStats] = useState({ total: 0, activas: 0, inactivas: 0 });

  // Load all difusoras from API - solo una vez al montar
  const loadDifusoras = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Cargar todas las difusoras sin filtros - filtrar del lado del cliente
      const data = await getDifusoras({});
      setDifusoras(data);
    } catch (err) {

      setError(err.message);
      setDifusoras([]);
    } finally {
      setLoading(false);
    }
  }, []);

  // Load stats from API - solo cuando cambia la cantidad de difusoras
  const loadStats = useCallback(async () => {
    try {
      const statsData = await getDifusorasStats();
      setStats(statsData);
    } catch (err) {

      // Fallback: usar calculatedStats que ya está memoizado
      // No necesitamos actualizar stats aquí, calculatedStats se actualiza automáticamente
    }
  }, []);

  // Calcular stats memoizados desde difusoras
  const calculatedStats = useMemo(() => {
    const activas = difusoras.filter(d => d.activa).length;
    const inactivas = difusoras.filter(d => !d.activa).length;
    return {
      total: difusoras.length,
      activas,
      inactivas
    };
  }, [difusoras]);

  // Filtrar difusoras del lado del cliente - memoizado para evitar recálculos
  const filteredDifusoras = useMemo(() => {
    let result = difusoras;

    // Filtrar por activas
    if (showOnlyActive) {
      result = result.filter(d => d.activa);
    }

    // Filtrar por búsqueda
    if (searchTerm.trim()) {
      const searchLower = searchTerm.toLowerCase().trim();
      result = result.filter(d => 
        d.nombre?.toLowerCase().includes(searchLower) ||
        d.siglas?.toLowerCase().includes(searchLower) ||
        d.slogan?.toLowerCase().includes(searchLower) ||
        d.descripcion?.toLowerCase().includes(searchLower)
      );
    }

    return result;
  }, [difusoras, showOnlyActive, searchTerm]);

  // Load difusoras on component mount only
  useEffect(() => {
    loadDifusoras();
  }, [loadDifusoras]);

  // Load stats solo una vez después de cargar las difusoras iniciales
  useEffect(() => {
    if (difusoras.length > 0 && stats.total === 0) {
      loadStats();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [difusoras.length]); // Solo cuando se cargan las difusoras iniciales

  // Show notification - memoizado
  const showNotification = useCallback((message, type = 'error') => {
    setNotification({ message, type });
  }, []);

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [notification]);

  // Handlers memoizados para evitar recreaciones
  const handleNew = useCallback(() => {
    setSelectedDifusora(null);
    setFormMode('new');
    setShowForm(true);
  }, []);

  const handleEdit = useCallback((difusora) => {
    setSelectedDifusora(difusora);
    setFormMode('edit');
    setShowForm(true);
  }, []);

  const handleView = useCallback((difusora) => {
    setSelectedDifusora(difusora);
    setFormMode('view');
    setShowForm(true);
  }, []);

  const handleDelete = useCallback(async (id) => {
    const difusora = difusoras.find(d => d.id === id);
    if (!difusora) return;
    
    if (window.confirm(`¿Está seguro de eliminar la difusora "${difusora.nombre}"?`)) {
      try {
        await deleteDifusora(id);
        showNotification('Difusora eliminada correctamente', 'success');
        // Actualizar estado local en lugar de recargar todo
        setDifusoras(prev => prev.filter(d => d.id !== id));
      } catch (err) {

        showNotification(`Error al eliminar la difusora: ${err.message}`, 'error');
      }
    }
  }, [difusoras, showNotification]);

  const handleSelect = useCallback((difusora) => {
    if (onDifusoraSelect) {
      onDifusoraSelect(difusora);
    }
  }, [onDifusoraSelect]);

  const handleToggleActive = useCallback(() => {
    setShowOnlyActive(prev => !prev);
  }, []);

  const handleExport = useCallback(async () => {
    try {
      // Exportar las difusoras filtradas actuales
      const params = {};
      if (showOnlyActive) params.activa = true;
      if (searchTerm) params.search = searchTerm;
      
      await exportDifusorasToCSV(params);
      showNotification('Exportación CSV completada', 'success');
    } catch (err) {

      showNotification(`Error al exportar CSV: ${err.message}`, 'error');
    }
  }, [showOnlyActive, searchTerm, showNotification]);

  const handleSave = useCallback(async (difusoraData) => {
    try {
      // Convertir mascaraMedidas (camelCase) a mascara_medidas (snake_case) para el backend
      const dataToSend = {
        ...difusoraData,
        mascara_medidas: difusoraData.mascaraMedidas || difusoraData.mascara_medidas || ''
      };
      // Eliminar mascaraMedidas si existe para evitar duplicados
      delete dataToSend.mascaraMedidas;
      
      if (formMode === 'edit' && selectedDifusora) {
        await updateDifusora(selectedDifusora.id, dataToSend);
        showNotification('Difusora actualizada correctamente', 'success');
        // Actualizar estado local en lugar de recargar todo
        setDifusoras(prev => prev.map(d => 
          d.id === selectedDifusora.id ? { ...d, ...dataToSend } : d
        ));
      } else {
        const newDifusora = await createDifusora(dataToSend);
        showNotification('Difusora creada correctamente', 'success');
        // Agregar al estado local en lugar de recargar todo
        setDifusoras(prev => [...prev, newDifusora]);
      }
      
      setShowForm(false);
      setSelectedDifusora(null);
      setFormMode('new');
    } catch (err) {

      showNotification(`Error al guardar la difusora: ${err.message}`, 'error');
    }
  }, [formMode, selectedDifusora, showNotification]);

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center h-64 space-y-4">
        <div className="relative">
          <div className="w-12 h-12 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
        <div className="text-gray-600 font-medium">Cargando difusoras...</div>
        <div className="text-sm text-gray-500">Esto puede tomar unos segundos</div>
      </div>
    );
  }

  return (
    <>
      {/* Notification Component - Outside main container to ensure it's always on top */}
      {notification && (
        <div className={`fixed top-4 right-4 z-[10000] p-4 rounded-xl shadow-2xl max-w-md transition-all duration-300 ${
          notification.type === 'success'
            ? 'bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-300 text-green-800'
            : 'bg-gradient-to-r from-red-50 to-pink-50 border-2 border-red-300 text-red-800'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              {notification.type === 'success' ? (
                <CheckCircle className="w-5 h-5 mr-2 text-green-600" />
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
          <div className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 overflow-hidden">
          {/* Enhanced Header */}
          <div className="px-8 py-6 border-b border-gray-200 bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
            <div className="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
              <div className="flex items-center space-x-4">
                <div className="w-14 h-14 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                  <Building2 className="w-7 h-7 text-white" />
                </div>
                <div>
                  <h1 className="text-3xl font-bold text-white mb-1">Gestión de Difusoras</h1>
                  <p className="text-blue-100 text-sm">Administra y organiza la información de tus difusoras</p>
                </div>
              </div>
              
              {/* Action Buttons */}
              <div className="flex flex-wrap gap-3">
                <button
                  onClick={handleNew}
                  className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-6 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                >
                  <Plus className="w-5 h-5" />
                  <span>Nueva Difusora</span>
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
                    <EyeOff className="w-5 h-5" />
                  ) : (
                    <Eye className="w-5 h-5" />
                  )}
                  <span>{showOnlyActive ? 'Ver Todas' : 'Solo Activas'}</span>
                </button>
                
                <button
                  onClick={handleExport}
                  className="bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white px-5 py-3 rounded-xl transition-all duration-300 flex items-center space-x-2 shadow-lg font-semibold hover:shadow-xl transform hover:scale-[1.02] hover:-translate-y-0.5 border border-white/30"
                >
                  <Download className="w-5 h-5" />
                  <span>Exportar CSV</span>
                </button>
              </div>
            </div>
            {/* Efecto de partículas decorativas */}
            <div className="absolute top-0 right-0 w-40 h-40 bg-white/10 rounded-full -translate-y-20 translate-x-20"></div>
            <div className="absolute bottom-0 left-0 w-32 h-32 bg-white/5 rounded-full translate-y-16 -translate-x-16"></div>
          </div>

          {/* Enhanced Search and Stats */}
          <div className="px-8 py-6 bg-gradient-to-r from-gray-50 to-blue-50/30 border-b border-gray-200">
            <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
              <div className="relative max-w-lg flex-1">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Search className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  type="text"
                  placeholder="Buscar por nombre, siglas, slogan o descripción..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="block w-full pl-12 pr-12 py-3.5 border-2 border-gray-300 rounded-xl leading-5 bg-white text-gray-900 placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-md transition-all duration-200 hover:border-gray-400"
                />
                {searchTerm && (
                  <button
                    onClick={() => setSearchTerm('')}
                    className="absolute inset-y-0 right-0 pr-4 flex items-center hover:bg-gray-100 rounded-r-xl transition-colors"
                  >
                    <X className="h-5 w-5 text-gray-400 hover:text-gray-600" />
                  </button>
                )}
              </div>
              
              {/* Enhanced Stats Cards - usar calculatedStats para mejor performance */}
              <div className="flex items-center gap-3">
                <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-blue-500 rounded-full animate-pulse shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-blue-800 font-bold text-sm">Activas</span>
                      <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.activas}</span>
                    </div>
                  </div>
                </div>
                <div className="bg-gradient-to-br from-red-50 to-red-100 border-2 border-red-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-red-500 rounded-full shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-red-800 font-bold text-sm">Inactivas</span>
                      <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.inactivas}</span>
                    </div>
                  </div>
                </div>
                <div className="bg-gradient-to-br from-indigo-50 to-indigo-100 border-2 border-indigo-300 px-5 py-4 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="flex items-center space-x-3">
                    <div className="w-4 h-4 bg-indigo-500 rounded-full shadow-md"></div>
                    <div className="flex flex-col">
                      <span className="text-indigo-800 font-bold text-sm">Total</span>
                      <span className="bg-indigo-600 text-white px-3 py-1 rounded-full text-sm font-bold mt-1">{calculatedStats.total}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Enhanced Filter Status */}
          {(showOnlyActive || searchTerm || error) && (
            <div className="px-8 py-4 bg-gradient-to-r from-blue-50 via-indigo-50 to-blue-50 border-b border-blue-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <Filter className="w-5 h-5 text-blue-600" />
                  <p className="text-blue-800 text-sm font-semibold">
                    {error ? 
                      `Error: ${error.message || error}` :
                      showOnlyActive && searchTerm ? 
                      `Mostrando difusoras activas que coinciden con "${searchTerm}" (${filteredDifusoras.length} de ${difusoras.length})` :
                      showOnlyActive ? 
                      `Mostrando solo difusoras activas (${filteredDifusoras.length} de ${difusoras.length})` :
                      `Mostrando difusoras que coinciden con "${searchTerm}" (${filteredDifusoras.length} de ${difusoras.length})`
                    }
                  </p>
                </div>
                <button
                  onClick={() => {
                    setShowOnlyActive(false);
                    setSearchTerm('');
                    setError(null);
                  }}
                  className="text-blue-600 hover:text-blue-800 text-sm font-semibold hover:underline transition-colors flex items-center space-x-1 px-3 py-1.5 rounded-lg hover:bg-blue-100"
                >
                  <X className="w-4 h-4" />
                  <span>Limpiar filtros</span>
                </button>
              </div>
            </div>
          )}

          {/* Enhanced Table */}
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gradient-to-r from-gray-100 to-gray-50 sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Estado
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    ID
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Siglas
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Nombre
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Slogan
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Orden
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Máscara Medidas
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                    Descripción
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-bold text-gray-700 uppercase tracking-wider w-48 sticky right-0 bg-gradient-to-r from-gray-100 to-gray-50 border-l-2 border-gray-300 shadow-lg">
                    Acciones
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredDifusoras.map((difusora, index) => (
                  <tr key={difusora.id} className={`hover:bg-blue-50/50 transition-all duration-200 cursor-pointer group ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-3 py-1.5 text-xs font-bold rounded-full border-2 shadow-sm ${
                        difusora.activa 
                          ? 'bg-gradient-to-r from-blue-100 to-blue-50 text-blue-800 border-blue-300' 
                          : 'bg-gradient-to-r from-red-100 to-red-50 text-red-800 border-red-300'
                      }`}>
                        {difusora.activa ? 'Activa' : 'Inactiva'}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                      #{difusora.id}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                      {difusora.siglas}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                      <div className="max-w-48 truncate group-hover:text-blue-700 transition-colors" title={difusora.nombre}>
                        {difusora.nombre}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                      <div className="max-w-56 truncate" title={difusora.slogan}>
                        {difusora.slogan}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-700">
                      {difusora.orden}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                      {difusora.mascara_medidas || difusora.mascaraMedidas || '-'}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                      <div className="max-w-56 truncate" title={difusora.descripcion}>
                        {difusora.descripcion || '-'}
                      </div>
                    </td>
                    <td className={`px-6 py-4 whitespace-nowrap text-sm font-medium sticky right-0 border-l-2 border-gray-300 shadow-lg ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}`}>
                      <div className="flex justify-center space-x-2">
                        {onDifusoraSelect && (
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleSelect(difusora);
                            }}
                            className="p-2.5 text-green-600 hover:text-green-800 bg-green-50 hover:bg-green-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-green-200"
                            title="Seleccionar difusora"
                          >
                            <CheckCircle className="w-5 h-5" />
                          </button>
                        )}
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleView(difusora);
                          }}
                          className="p-2.5 text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-blue-200"
                          title="Ver detalles de la difusora"
                        >
                          <Eye className="w-5 h-5" />
                        </button>
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleEdit(difusora);
                          }}
                          className="p-2.5 text-yellow-600 hover:text-yellow-800 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-yellow-200"
                          title="Editar difusora"
                        >
                          <Edit className="w-5 h-5" />
                        </button>
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleDelete(difusora.id);
                          }}
                          className="p-2.5 text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-md hover:shadow-lg border border-red-200"
                          title="Eliminar difusora"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          
          {/* Enhanced Empty State */}
          {filteredDifusoras.length === 0 && !loading && (
            <div className="text-center py-20 px-6">
              <div className="mx-auto w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-full flex items-center justify-center mb-6 shadow-lg">
                <Building2 className="w-12 h-12 text-gray-400" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">
                {error ? 'Error al cargar difusoras' :
                 searchTerm ? 'No se encontraron difusoras' : 
                 showOnlyActive ? 'No hay difusoras activas' : 
                 'No hay difusoras registradas'}
              </h3>
              <p className="text-gray-600 mb-8 max-w-md mx-auto text-base">
                {error ? 
                  `Error: ${error.message || error}. Intenta recargar la página.` :
                  searchTerm ? 
                  `No se encontraron difusoras que coincidan con "${searchTerm}". Intenta con otros términos de búsqueda.` : 
                  showOnlyActive ? 
                  'No hay difusoras activas en el sistema. Puedes ver todas las difusoras o crear una nueva.' : 
                  'Comienza agregando tu primera difusora al sistema para gestionar tus estaciones de radio.'
                }
              </p>
              {!searchTerm && !showOnlyActive && !error && (
                <button
                  onClick={handleNew}
                  className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-8 py-4 rounded-xl transition-all duration-300 font-semibold hover:shadow-xl transform hover:scale-105 hover:-translate-y-1 flex items-center space-x-2 mx-auto"
                >
                  <Plus className="w-5 h-5" />
                  <span>Crear primera difusora</span>
                </button>
              )}
            </div>
          )}
        </div>
      </div>

        {/* Form Modal */}
        {showForm && (
          <DifusoraForm
            difusora={selectedDifusora}
            mode={formMode}
            onSave={handleSave}
            onCancel={() => {
              setShowForm(false);
              setSelectedDifusora(null);
              setFormMode('new');
            }}
          />
        )}
      </div>
    </>
  );
}

// Enhanced Difusora Form Component - memoizado para evitar re-renders innecesarios
const DifusoraForm = React.memo(function DifusoraForm({ difusora, mode, onSave, onCancel }) {
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});

  const [formData, setFormData] = useState({
    siglas: difusora?.siglas || '',
    nombre: difusora?.nombre || '',
    slogan: difusora?.slogan || '',
    orden: difusora?.orden?.toString() || '',
    mascaraMedidas: difusora?.mascara_medidas || difusora?.mascaraMedidas || '',
    descripcion: difusora?.descripcion || '',
    activa: difusora?.activa ?? true,
  });

  const isReadOnly = mode === 'view';
  const title = mode === 'new' ? 'Nueva Difusora' : 
               mode === 'edit' ? 'Editar Difusora' : 
               'Consultar Difusora';

  // Validate form
  const validateForm = () => {
    const newErrors = {};
    
    if (!formData.siglas || formData.siglas.trim() === '') {
      newErrors.siglas = 'Las siglas son obligatorias';
    }
    
    if (!formData.nombre || formData.nombre.trim() === '') {
      newErrors.nombre = 'El nombre es obligatorio';
    }
    
    if (!formData.orden || formData.orden.trim() === '') {
      newErrors.orden = 'El orden es obligatorio';
    } else if (isNaN(parseInt(formData.orden))) {
      newErrors.orden = 'El orden debe ser un número';
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
      const dataToSave = {
        ...formData,
        orden: parseInt(formData.orden)
      };

      await onSave(dataToSave);
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
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const inputClass = `w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 ${
    isReadOnly ? 'bg-gray-50 text-gray-600 cursor-not-allowed' : 'bg-white text-gray-900 hover:border-gray-400'
  }`;

  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) {
      onCancel();
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 transition-opacity duration-200"
      onClick={handleBackdropClick}
    >
      <div 
        className="bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl border border-white/20 w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col transform transition-all duration-300 scale-100"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Enhanced Window Header */}
        <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 px-6 py-4 relative overflow-hidden border-b border-blue-800/20">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/90 to-indigo-600/90"></div>
          <div className="relative z-10 flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm shadow-lg">
                <Building2 className="w-6 h-6 text-white" />
              </div>
              <h1 className="text-2xl font-bold text-white">{title}</h1>
            </div>
            <button
              onClick={onCancel}
              className="text-white/90 hover:text-white hover:bg-white/20 rounded-lg p-2 transition-all duration-200 hover:scale-110"
              title="Cerrar"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
          {/* Efecto de partículas decorativas */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
          <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/5 rounded-full translate-y-12 -translate-x-12"></div>
        </div>

        {/* Enhanced Form Content */}
        <div className="flex-1 overflow-y-auto p-8 bg-gradient-to-br from-gray-50 via-white to-blue-50/20">
          <div className="space-y-6">
            {/* Activo checkbox */}
            <div className="flex items-center space-x-3 p-4 bg-white rounded-xl border-2 border-gray-200 hover:border-blue-300 transition-colors shadow-sm">
              <input
                type="checkbox"
                name="activa"
                checked={formData.activa}
                onChange={handleChange}
                disabled={isReadOnly}
                className="h-5 w-5 text-blue-600 focus:ring-2 focus:ring-blue-500 border-gray-300 rounded transition-all cursor-pointer disabled:cursor-not-allowed"
              />
              <label className="text-base font-semibold text-gray-700 cursor-pointer">Activa</label>
            </div>

            {/* Form fields */}
            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Siglas <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="siglas"
                    value={formData.siglas}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    placeholder="Ej: RADIO1"
                  />
                  {errors.siglas && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <AlertCircle className="w-4 h-4" />
                      <span>{errors.siglas}</span>
                    </p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Nombre <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    name="nombre"
                    value={formData.nombre}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    placeholder="Ej: Radio Primera"
                  />
                  {errors.nombre && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <AlertCircle className="w-4 h-4" />
                      <span>{errors.nombre}</span>
                    </p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Slogan
                  </label>
                  <input
                    type="text"
                    name="slogan"
                    value={formData.slogan}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    placeholder="Ej: La mejor música del momento"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Orden <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="orden"
                    value={formData.orden}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    required={!isReadOnly}
                    min="1"
                    placeholder="1"
                  />
                  {errors.orden && (
                    <p className="mt-2 text-sm text-red-600 font-medium flex items-center space-x-1">
                      <AlertCircle className="w-4 h-4" />
                      <span>{errors.orden}</span>
                    </p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Máscara para Medidas
                  </label>
                  <input
                    type="text"
                    name="mascaraMedidas"
                    value={formData.mascaraMedidas}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    className={inputClass}
                    placeholder="Ej: MM:SS"
                  />
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Descripción
                  </label>
                  <textarea
                    name="descripcion"
                    value={formData.descripcion}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    rows="4"
                    className={inputClass}
                    placeholder="Descripción de la difusora..."
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        
        {/* Enhanced Footer with Action Buttons */}
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 border-t-2 border-gray-300 px-8 py-5 flex justify-end space-x-3 shadow-inner">
          <button
            type="button"
            onClick={onCancel}
            disabled={isLoading}
            className="px-8 py-3 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-xl transition-all duration-300 disabled:opacity-50 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
          >
            <X className="w-5 h-5" />
            <span>Cerrar</span>
          </button>
          
          {!isReadOnly && (
            <button
              type="button"
              onClick={handleSubmit}
              disabled={isLoading}
              className="px-8 py-3 bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white rounded-xl transition-all duration-300 disabled:opacity-50 flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-[1.02] font-semibold min-w-[140px] justify-center"
            >
              {isLoading ? (
                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              ) : (
                <CheckCircle className="w-5 h-5" />
              )}
              <span>{isLoading ? 'Guardando...' : 'Aceptar'}</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
});
