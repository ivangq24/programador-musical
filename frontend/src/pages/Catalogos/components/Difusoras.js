import React, { useState, useEffect } from 'react';
import { getDifusoras, createDifusora, updateDifusora, deleteDifusora, getDifusorasStats, exportDifusorasToCSV } from '../../../api/catalogos/generales/difusorasApi';

export default function Difusoras({ onDifusoraSelect }) {
  // Estado para difusoras desde la API
  const [difusoras, setDifusoras] = useState([]);
  
  const [filteredDifusoras, setFilteredDifusoras] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [formMode, setFormMode] = useState('new'); // 'new', 'edit', 'view'
  const [selectedDifusora, setSelectedDifusora] = useState(null);
  const [showOnlyActive, setShowOnlyActive] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [notification, setNotification] = useState(null);
  const [stats, setStats] = useState({ total: 0, activas: 0, inactivas: 0 });

  // Load difusoras from API
  const loadDifusoras = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Build query parameters
      const params = {};
      if (showOnlyActive) params.activa = true;
      if (searchTerm) params.search = searchTerm;
      
      const data = await getDifusoras(params);
      setDifusoras(data);
      setFilteredDifusoras(data);
    } catch (err) {
      console.error('Error loading difusoras:', err);
      setError(err.message);
      setDifusoras([]);
      setFilteredDifusoras([]);
    } finally {
      setLoading(false);
    }
  };

  // Load stats from API
  const loadStats = async () => {
    try {
      const statsData = await getDifusorasStats();
      setStats(statsData);
    } catch (err) {
      console.error('Error loading stats:', err);
      // Fallback to calculated stats from current data
      setStats({
        total: difusoras.length,
        activas: difusoras.filter(d => d.activa).length,
        inactivas: difusoras.filter(d => !d.activa).length
      });
    }
  };

  // Load difusoras on component mount and when filters change
  useEffect(() => {
    loadDifusoras();
    loadStats();
  }, [showOnlyActive, searchTerm]);

  // Show notification
  const showNotification = (message, type = 'error') => {
    setNotification({ message, type });
  };

  // Auto-hide notification
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null);
      }, 5000);
      return () => clearTimeout(timer);
    }
  }, [notification]);

  const handleNew = () => {
    setSelectedDifusora(null);
    setFormMode('new');
    setShowForm(true);
  };

  const handleEdit = (difusora) => {
    setSelectedDifusora(difusora);
    setFormMode('edit');
    setShowForm(true);
  };

  const handleView = (difusora) => {
    setSelectedDifusora(difusora);
    setFormMode('view');
    setShowForm(true);
  };

  const handleDelete = async (id) => {
    const difusora = difusoras.find(d => d.id === id);
    if (window.confirm(`¿Está seguro de eliminar la difusora "${difusora?.nombre}"?`)) {
      try {
        await deleteDifusora(id);
        showNotification('Difusora eliminada correctamente', 'success');
        await loadDifusoras();
        await loadStats();
      } catch (err) {
        console.error('Error deleting difusora:', err);
        showNotification(`Error al eliminar la difusora: ${err.message}`, 'error');
      }
    }
  };

  const handleSelect = (difusora) => {
    if (onDifusoraSelect) {
      onDifusoraSelect(difusora);
    }
  };

  const handleToggleActive = () => {
    setShowOnlyActive(!showOnlyActive);
  };

  const handleExport = async () => {
    try {
      const params = {};
      if (showOnlyActive) params.activa = true;
      if (searchTerm) params.search = searchTerm;
      
      await exportDifusorasToCSV(params);
      showNotification('Exportación CSV completada', 'success');
    } catch (err) {
      console.error('Error exporting CSV:', err);
      showNotification(`Error al exportar CSV: ${err.message}`, 'error');
    }
  };

  const handleSave = async (difusoraData) => {
    try {
      if (formMode === 'edit') {
        await updateDifusora(selectedDifusora.id, difusoraData);
        showNotification('Difusora actualizada correctamente', 'success');
      } else {
        await createDifusora(difusoraData);
        showNotification('Difusora creada correctamente', 'success');
      }
      
      await loadDifusoras();
      await loadStats();
      setShowForm(false);
      setSelectedDifusora(null);
      setFormMode('new');
    } catch (err) {
      console.error('Error saving difusora:', err);
      showNotification(`Error al guardar la difusora: ${err.message}`, 'error');
    }
  };

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
        {/* Enhanced Header */}
        <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-indigo-50">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Gestión de Difusoras</h1>
              <p className="text-sm text-gray-600 mt-1">Administra y organiza la información de tus difusoras</p>
            </div>
            
            {/* Action Buttons */}
            <div className="flex flex-wrap gap-3">
              <button
                onClick={handleNew}
                className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition-all duration-200 flex items-center space-x-2 shadow-sm font-medium hover:shadow-md transform hover:-translate-y-0.5"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <span>Nueva Difusora</span>
              </button>
              
              <button
                onClick={handleToggleActive}
                className={`px-4 py-3 rounded-lg transition-all duration-200 flex items-center space-x-2 shadow-sm font-medium hover:shadow-md transform hover:-translate-y-0.5 ${
                  showOnlyActive 
                    ? 'bg-blue-600 hover:bg-blue-700 text-white' 
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
                <span>{showOnlyActive ? 'Ver Todas' : 'Solo Activas'}</span>
              </button>
              
              <button
                onClick={handleExport}
                className="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-3 rounded-lg transition-all duration-200 flex items-center space-x-2 shadow-sm font-medium hover:shadow-md transform hover:-translate-y-0.5"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <span>Exportar CSV</span>
              </button>
            </div>
          </div>
        </div>

        {/* Enhanced Search and Stats */}
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
                placeholder="Buscar por nombre, siglas, slogan o descripción..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg leading-5 bg-white text-black placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm transition-all duration-200"
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
            
            {/* Enhanced Stats Cards */}
            <div className="flex items-center space-x-4">
              <div className="bg-white border border-blue-200 px-4 py-3 rounded-lg shadow-sm">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-blue-500 rounded-full animate-pulse"></div>
                  <span className="text-blue-800 font-semibold text-sm">Activas</span>
                  <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full text-xs font-bold">{stats.activas}</span>
                </div>
              </div>
              <div className="bg-white border border-red-200 px-4 py-3 rounded-lg shadow-sm">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  <span className="text-red-800 font-semibold text-sm">Inactivas</span>
                  <span className="bg-red-100 text-red-800 px-2 py-1 rounded-full text-xs font-bold">{stats.inactivas}</span>
                </div>
              </div>
              <div className="bg-white border border-indigo-200 px-4 py-3 rounded-lg shadow-sm">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-indigo-500 rounded-full"></div>
                  <span className="text-indigo-800 font-semibold text-sm">Total</span>
                  <span className="bg-indigo-100 text-indigo-800 px-2 py-1 rounded-full text-xs font-bold">{stats.total}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Enhanced Filter Status */}
        {(showOnlyActive || searchTerm || error) && (
          <div className="px-6 py-4 bg-blue-50 border-b border-blue-200">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.207A1 1 0 013 6.5V4z" />
                </svg>
                <p className="text-blue-800 text-sm font-medium">
                  {error ? 
                    `Error: ${error}` :
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
                className="text-blue-600 hover:text-blue-800 text-sm font-medium hover:underline transition-colors"
              >
                Limpiar filtros
              </button>
            </div>
          </div>
        )}

        {/* Enhanced Table */}
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Estado
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  ID
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Siglas
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Nombre
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Slogan
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Orden
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Máscara Medidas
                </th>
                <th className="px-3 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Descripción
                </th>
                <th className="px-3 py-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider w-40 sticky right-0 bg-gray-50 border-l border-gray-200 shadow-lg">
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredDifusoras.map((difusora, index) => (
                <tr key={difusora.id} className={`hover:bg-blue-50 transition-all duration-200 cursor-pointer ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}`}>
                  <td className="px-3 py-4 whitespace-nowrap">
                    <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full border ${
                      difusora.activa 
                        ? 'bg-blue-100 text-blue-800 border-blue-200' 
                        : 'bg-red-100 text-red-800 border-red-200'
                    }`}>
                      {difusora.activa ? 'Activa' : 'Inactiva'}
                    </span>
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    #{difusora.id}
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                    {difusora.siglas}
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    <div className="max-w-40 truncate" title={difusora.nombre}>
                      {difusora.nombre}
                    </div>
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    <div className="max-w-48 truncate" title={difusora.slogan}>
                      {difusora.slogan}
                    </div>
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    {difusora.orden}
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    {difusora.mascaraMedidas}
                  </td>
                  <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    <div className="max-w-48 truncate" title={difusora.descripcion}>
                      {difusora.descripcion}
                    </div>
                  </td>
                  <td className={`px-3 py-4 whitespace-nowrap text-sm font-medium sticky right-0 border-l border-gray-200 shadow-lg ${index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}`}>
                    <div className="flex justify-center space-x-1">
                      {onDifusoraSelect && (
                        <button
                          onClick={() => handleSelect(difusora)}
                          className="p-2 text-green-600 hover:text-green-900 bg-green-50 hover:bg-green-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-sm"
                          title="Seleccionar difusora"
                        >
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                          </svg>
                        </button>
                      )}
                      <button
                        onClick={() => handleView(difusora)}
                        className="p-2 text-blue-600 hover:text-blue-900 bg-blue-50 hover:bg-blue-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-sm"
                        title="Ver detalles de la difusora"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                      </button>
                      <button
                        onClick={() => handleEdit(difusora)}
                        className="p-2 text-yellow-600 hover:text-yellow-900 bg-yellow-50 hover:bg-yellow-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-sm"
                        title="Editar difusora"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                      </button>
                      <button
                        onClick={() => handleDelete(difusora.id)}
                        className="p-2 text-red-600 hover:text-red-900 bg-red-50 hover:bg-red-100 rounded-lg transition-all duration-200 hover:scale-110 shadow-sm"
                        title="Eliminar difusora"
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
        
        {/* Enhanced Empty State */}
        {filteredDifusoras.length === 0 && !loading && (
          <div className="text-center py-16 px-6">
            <div className="mx-auto h-20 w-20 text-gray-400 mb-6">
              <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" className="w-full h-full">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 19V6a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              {error ? 'Error al cargar difusoras' :
               searchTerm ? 'No se encontraron difusoras' : 
               showOnlyActive ? 'No hay difusoras activas' : 
               'No hay difusoras registradas'}
            </h3>
            <p className="text-gray-500 mb-6 max-w-md mx-auto">
              {error ? 
                `Error: ${error}. Intenta recargar la página.` :
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
                className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition-all duration-200 font-medium hover:shadow-md transform hover:-translate-y-0.5"
              >
                Crear primera difusora
              </button>
            )}
          </div>
        )}
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
  );
}

// Enhanced Difusora Form Component
function DifusoraForm({ difusora, mode, onSave, onCancel }) {
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});

  const [formData, setFormData] = useState({
    siglas: difusora?.siglas || '',
    nombre: difusora?.nombre || '',
    slogan: difusora?.slogan || '',
    orden: difusora?.orden?.toString() || '',
    mascaraMedidas: difusora?.mascaraMedidas || '',
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
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const inputClass = `w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
    isReadOnly ? 'bg-gray-50 text-gray-600' : 'bg-white text-gray-900'
  }`;

  const handleBackdropClick = (e) => {
    if (e.target === e.currentTarget) {
      onCancel();
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
      onClick={handleBackdropClick}
    >
      <div 
        className="bg-white border border-gray-300 shadow-lg w-[600px] max-h-[80vh] overflow-hidden flex flex-col"
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

        {/* Form Content */}
        <div className="flex-1 overflow-y-auto p-6 bg-white">
          <div className="space-y-6">
            {/* Activo checkbox */}
            <div className="flex items-center space-x-3">
              <input
                type="checkbox"
                name="activa"
                checked={formData.activa}
                onChange={handleChange}
                disabled={isReadOnly}
                className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
              />
              <label className="text-sm font-medium text-gray-700">Activa</label>
            </div>

            {/* Form fields */}
            <div className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Siglas *
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
                    <p className="mt-1 text-sm text-red-600">{errors.siglas}</p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Nombre *
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
                    <p className="mt-1 text-sm text-red-600">{errors.nombre}</p>
                  )}
                </div>
                
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
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
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Orden *
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
                    <p className="mt-1 text-sm text-red-600">{errors.orden}</p>
                  )}
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
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
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Descripción
                  </label>
                  <textarea
                    name="descripcion"
                    value={formData.descripcion}
                    onChange={handleChange}
                    readOnly={isReadOnly}
                    rows="3"
                    className={inputClass}
                    placeholder="Descripción de la difusora..."
                  />
                </div>
              </div>
            </div>
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
    </div>
  );
}
