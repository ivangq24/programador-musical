'use client'

import { useState, useEffect } from 'react'
import { 
  X, 
  Save, 
  Music, 
  Tag, 
  Layers, 
  Settings,
  Calendar,
  Clock,
  User,
  FileAudio,
  CheckCircle
} from 'lucide-react'

export default function FormularioCancion({ isOpen, onClose, onSave, cancionEditando, modoConsulta = false, difusoras = [] }) {
  const [activeTab, setActiveTab] = useState('datos-generales')
  const [formData, setFormData] = useState({
    // Datos Generales
    habilitada: true,
    difusora: '',
    cancionId: '',
    idmedia: '',
    titulo: '',
    interpretes: '',
    categoria: '',
    posicionStack: '',
    posicionVisual: '',
    targetPlays: '',
    numPlays: '',
    version: '',
    lenguaje: '',
    año: '',
    album: '',
    entrada: '',
    entradaSegundos: '',
    salida: '',
    salidaSegundos: '',
    bpm: '',
    lanzamiento: '',
    topCharts: '',
    
    // Clasificaciones
    clasificaciones: [],
    
    // Otros Datos
    daypart: '',
    idusuario1: '',
    idusuario2: '',
    idusuario3: '',
    idusuario4: '',
    idusuario5: '',
    sello: '',
    otrasPersonas: '',
    archivoAudio: '',
    formato: '',
    bitrate: '',
    frecuencia: '',
    canales: '',
    sampling: ''
  })

  const categorias = ['Pop', 'Rock', 'Balada', 'Jazz', 'Salsa', 'Reggaeton']
  const lenguajes = ['Español', 'Inglés', 'Francés', 'Portugués', 'Italiano']
  const entradas = ['Fade', 'Cut', 'Aplausos', 'Otros']
  const salidas = ['Fade', 'Cut', 'Aplausos', 'Otros']
  const sellos = ['Sony Music', 'Universal Music', 'Warner Music', 'EMI', 'Independiente']

  // Cargar datos de la canción cuando se está editando
  useEffect(() => {
    if (cancionEditando) {
      setFormData({
        habilitada: cancionEditando.activa || true,
        difusora: cancionEditando.difusora_id ? difusoras.find(d => d.id === cancionEditando.difusora_id)?.siglas || '' : '', // Use real difusora
        cancionId: cancionEditando.id?.toString() || '',
        idmedia: cancionEditando.id?.toString() || '',
        titulo: cancionEditando.titulo || '',
        interpretes: cancionEditando.artista || '',
        categoria: '',
        posicionStack: '',
        posicionVisual: '',
        targetPlays: '',
        numPlays: '',
        version: '',
        lenguaje: '',
        año: '',
        album: cancionEditando.album || '',
        entrada: '',
        entradaSegundos: '',
        salida: '',
        salidaSegundos: '',
        bpm: '',
        lanzamiento: '',
        topCharts: '',
        clasificaciones: [],
        daypart: '',
        idusuario1: '',
        idusuario2: '',
        idusuario3: '',
        idusuario4: '',
        idusuario5: '',
        sello: '',
        otrasPersonas: '',
        archivoAudio: '',
        formato: '',
        bitrate: '',
        frecuencia: '',
        canales: '',
        sampling: ''
      })
    } else {
      // Resetear formulario para nueva canción
      setFormData({
        habilitada: true,
        difusora: '',
        cancionId: '',
        idmedia: '',
        titulo: '',
        interpretes: '',
        categoria: '',
        posicionStack: '',
        posicionVisual: '',
        targetPlays: '',
        numPlays: '',
        version: '',
        lenguaje: '',
        año: '',
        album: '',
        entrada: '',
        entradaSegundos: '',
        salida: '',
        salidaSegundos: '',
        bpm: '',
        lanzamiento: '',
        topCharts: '',
        clasificaciones: [],
        daypart: '',
        idusuario1: '',
        idusuario2: '',
        idusuario3: '',
        idusuario4: '',
        idusuario5: '',
        sello: '',
        otrasPersonas: '',
        archivoAudio: '',
        formato: '',
        bitrate: '',
        frecuencia: '',
        canales: '',
        sampling: ''
      })
    }
  }, [cancionEditando])

  const handleInputChange = (field, value) => {
    if (modoConsulta) return // No permitir cambios en modo consulta
    setFormData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  // Helper para obtener clases de campos según el modo
  const getFieldClasses = (baseClasses = '') => {
    return `${baseClasses} ${modoConsulta ? 'opacity-50 cursor-not-allowed' : ''}`
  }

  // Helper para obtener clases de labels según el modo
  const getLabelClasses = (baseClasses = 'text-sm font-medium text-gray-700') => {
    return `${baseClasses} ${modoConsulta ? 'text-gray-500' : ''}`
  }

  const handleSubmit = (e) => {
    e.preventDefault()

    onSave(formData)
    onClose()
  }

  const tabs = [
    { id: 'datos-generales', label: 'Datos Generales', icon: Music },
    { id: 'clasificaciones', label: 'Clasificaciones', icon: Tag },
    { id: 'otros-datos', label: 'Otros Datos', icon: Settings }
  ]

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-6xl max-h-[90vh] overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 text-white p-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="p-2 bg-white/20 rounded-lg">
                <Music className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-2xl font-bold">
                  {modoConsulta ? 'Consultar Canción' : cancionEditando ? 'Editar Canción' : 'Datos de la Canción'}
                </h2>
                <p className="text-blue-100">
                  {modoConsulta ? 'Consulta la información de la canción' : cancionEditando ? 'Modifica la información de la canción' : 'Complete la información de la nueva canción'}
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-white/20 rounded-lg transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
        </div>

        {/* Tabs */}
        <div className="bg-gray-50 border-b border-gray-200">
          <div className="flex">
            {tabs.map((tab) => {
              const Icon = tab.icon
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center space-x-2 px-6 py-4 text-sm font-medium transition-colors ${
                    activeTab === tab.id
                      ? 'bg-white text-blue-600 border-b-2 border-blue-600'
                      : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                  <span>{tab.label}</span>
                </button>
              )
            })}
          </div>
        </div>

        {/* Form Content */}
        <div className="p-6 overflow-y-auto max-h-[60vh]">
          <form onSubmit={handleSubmit}>
            {/* Tab 1: Datos Generales */}
            {activeTab === 'datos-generales' && (
              <div className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {/* Checkbox Habilitada */}
                  <div className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      id="habilitada"
                      checked={formData.habilitada}
                      onChange={(e) => handleInputChange('habilitada', e.target.checked)}
                      disabled={modoConsulta}
                      className={`w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 ${modoConsulta ? 'opacity-50 cursor-not-allowed' : ''}`}
                    />
                    <label htmlFor="habilitada" className={`text-sm font-medium ${modoConsulta ? 'text-gray-500' : 'text-gray-700'}`}>
                      Canción habilitada
                    </label>
                  </div>

                  {/* Difusora */}
                  <div>
                    <label className={getLabelClasses('block mb-2')}>Difusora</label>
                    <select
                      value={formData.difusora}
                      onChange={(e) => handleInputChange('difusora', e.target.value)}
                      disabled={modoConsulta}
                      className={getFieldClasses('w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500')}
                    >
                      <option value="">Seleccionar difusora</option>
                      {difusoras.map(difusora => (
                        <option key={difusora.id} value={difusora.siglas}>{difusora.siglas} - {difusora.nombre}</option>
                      ))}
                    </select>
                  </div>

                  {/* Canción ID */}
                  <div>
                    <label className={getLabelClasses('block mb-2')}>Canción ID</label>
                    <input
                      type="text"
                      value={formData.cancionId}
                      onChange={(e) => handleInputChange('cancionId', e.target.value)}
                      disabled={modoConsulta}
                      className={getFieldClasses('w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500')}
                      placeholder="ID de la canción"
                    />
                  </div>

                  {/* ID Media */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Media</label>
                    <input
                      type="text"
                      value={formData.idmedia}
                      onChange={(e) => handleInputChange('idmedia', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del media"
                    />
                  </div>

                  {/* Título */}
                  <div>
                    <label className={getLabelClasses('block mb-2')}>Título</label>
                    <input
                      type="text"
                      value={formData.titulo}
                      onChange={(e) => handleInputChange('titulo', e.target.value)}
                      disabled={modoConsulta}
                      className={getFieldClasses('w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500')}
                      placeholder="Título de la canción"
                    />
                  </div>

                  {/* Intérpretes */}
                  <div>
                    <label className={getLabelClasses('block mb-2')}>Intérpretes</label>
                    <input
                      type="text"
                      value={formData.interpretes}
                      onChange={(e) => handleInputChange('interpretes', e.target.value)}
                      disabled={modoConsulta}
                      className={getFieldClasses('w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500')}
                      placeholder="Intérpretes de la canción"
                    />
                  </div>

                  {/* Categoría */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Categoría</label>
                    <select
                      value={formData.categoria}
                      onChange={(e) => handleInputChange('categoria', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Seleccionar categoría</option>
                      {categorias.map(categoria => (
                        <option key={categoria} value={categoria}>{categoria}</option>
                      ))}
                    </select>
                  </div>

                  {/* Posición Stack */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Posición Stack</label>
                    <input
                      type="number"
                      value={formData.posicionStack}
                      onChange={(e) => handleInputChange('posicionStack', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Posición en stack"
                    />
                  </div>

                  {/* Posición Visual */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Posición Visual</label>
                    <input
                      type="number"
                      value={formData.posicionVisual}
                      onChange={(e) => handleInputChange('posicionVisual', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Posición visual"
                    />
                  </div>

                  {/* Target Plays */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Target Plays</label>
                    <input
                      type="number"
                      value={formData.targetPlays}
                      onChange={(e) => handleInputChange('targetPlays', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Reproducciones objetivo"
                    />
                  </div>

                  {/* Num Plays */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Num Plays</label>
                    <input
                      type="number"
                      value={formData.numPlays}
                      onChange={(e) => handleInputChange('numPlays', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Número de reproducciones"
                    />
                  </div>

                  {/* Versión */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Versión</label>
                    <input
                      type="text"
                      value={formData.version}
                      onChange={(e) => handleInputChange('version', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Versión de la canción"
                    />
                  </div>

                  {/* Lenguaje */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Lenguaje</label>
                    <select
                      value={formData.lenguaje}
                      onChange={(e) => handleInputChange('lenguaje', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Seleccionar lenguaje</option>
                      {lenguajes.map(lenguaje => (
                        <option key={lenguaje} value={lenguaje}>{lenguaje}</option>
                      ))}
                    </select>
                  </div>

                  {/* Año */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Año</label>
                    <input
                      type="number"
                      value={formData.año}
                      onChange={(e) => handleInputChange('año', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Año de lanzamiento"
                    />
                  </div>

                  {/* Álbum */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Álbum</label>
                    <input
                      type="text"
                      value={formData.album}
                      onChange={(e) => handleInputChange('album', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Nombre del álbum"
                    />
                  </div>

                  {/* Entrada */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Entrada</label>
                    <div className="flex space-x-2">
                      <select
                        value={formData.entrada}
                        onChange={(e) => handleInputChange('entrada', e.target.value)}
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      >
                        <option value="">Tipo</option>
                        {entradas.map(entrada => (
                          <option key={entrada} value={entrada}>{entrada}</option>
                        ))}
                      </select>
                      <input
                        type="number"
                        value={formData.entradaSegundos}
                        onChange={(e) => handleInputChange('entradaSegundos', e.target.value)}
                        className="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        placeholder="Seg"
                      />
                    </div>
                  </div>

                  {/* Salida */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Salida</label>
                    <div className="flex space-x-2">
                      <select
                        value={formData.salida}
                        onChange={(e) => handleInputChange('salida', e.target.value)}
                        className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      >
                        <option value="">Tipo</option>
                        {salidas.map(salida => (
                          <option key={salida} value={salida}>{salida}</option>
                        ))}
                      </select>
                      <input
                        type="number"
                        value={formData.salidaSegundos}
                        onChange={(e) => handleInputChange('salidaSegundos', e.target.value)}
                        className="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        placeholder="Seg"
                      />
                    </div>
                  </div>

                  {/* BPM */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">BPM</label>
                    <input
                      type="number"
                      value={formData.bpm}
                      onChange={(e) => handleInputChange('bpm', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Beats por minuto"
                    />
                  </div>

                  {/* Lanzamiento */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Lanzamiento</label>
                    <input
                      type="date"
                      value={formData.lanzamiento}
                      onChange={(e) => handleInputChange('lanzamiento', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>

                  {/* Top Charts */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Top Charts</label>
                    <input
                      type="date"
                      value={formData.topCharts}
                      onChange={(e) => handleInputChange('topCharts', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>
                </div>
              </div>
            )}

            {/* Tab 2: Clasificaciones */}
            {activeTab === 'clasificaciones' && (
              <div className="space-y-6">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <h3 className="text-lg font-semibold text-gray-900 mb-4">Clasificaciones relacionadas a la canción</h3>
                  <div className="flex items-center space-x-4">
                    <div className="flex-1">
                      <select className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <option value="">Seleccionar clasificación</option>
                        <option value="genero">Género Musical</option>
                        <option value="energia">Energía</option>
                        <option value="humor">Humor</option>
                        <option value="tempo">Tempo</option>
                      </select>
                    </div>
                    <button
                      type="button"
                      className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    >
                      Añadir
                    </button>
                    <button
                      type="button"
                      className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
                    >
                      Mantenimiento
                    </button>
                  </div>
                </div>

                {/* Tabla de Clasificaciones */}
                <div className="border border-gray-200 rounded-lg overflow-hidden">
                  <table className="min-w-full">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Tipo Clasificación</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Clasificación</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Grupo</th>
                        <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Valor Numérico</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white">
                      <tr>
                        <td colSpan="4" className="px-4 py-8 text-center text-gray-500">
                          No hay información para mostrar
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* Se eliminó la pestaña Conjuntos */}

            {/* Tab 4: Otros Datos */}
            {activeTab === 'otros-datos' && (
              <div className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {/* Daypart */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Daypart</label>
                    <input
                      type="text"
                      value={formData.daypart}
                      onChange={(e) => handleInputChange('daypart', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Parte del día"
                    />
                  </div>

                  {/* ID Usuario 1 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Usuario 1</label>
                    <input
                      type="text"
                      value={formData.idusuario1}
                      onChange={(e) => handleInputChange('idusuario1', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del usuario 1"
                    />
                  </div>

                  {/* ID Usuario 2 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Usuario 2</label>
                    <input
                      type="text"
                      value={formData.idusuario2}
                      onChange={(e) => handleInputChange('idusuario2', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del usuario 2"
                    />
                  </div>

                  {/* ID Usuario 3 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Usuario 3</label>
                    <input
                      type="text"
                      value={formData.idusuario3}
                      onChange={(e) => handleInputChange('idusuario3', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del usuario 3"
                    />
                  </div>

                  {/* ID Usuario 4 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Usuario 4</label>
                    <input
                      type="text"
                      value={formData.idusuario4}
                      onChange={(e) => handleInputChange('idusuario4', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del usuario 4"
                    />
                  </div>

                  {/* ID Usuario 5 */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">ID Usuario 5</label>
                    <input
                      type="text"
                      value={formData.idusuario5}
                      onChange={(e) => handleInputChange('idusuario5', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="ID del usuario 5"
                    />
                  </div>

                  {/* Sello */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Sello</label>
                    <select
                      value={formData.sello}
                      onChange={(e) => handleInputChange('sello', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Seleccionar sello</option>
                      {sellos.map(sello => (
                        <option key={sello} value={sello}>{sello}</option>
                      ))}
                    </select>
                  </div>

                  {/* Otras Personas */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Otras Personas</label>
                    <input
                      type="text"
                      value={formData.otrasPersonas}
                      onChange={(e) => handleInputChange('otrasPersonas', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Otras personas involucradas"
                    />
                  </div>

                  {/* Archivo Audio */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Archivo Audio</label>
                    <input
                      type="file"
                      accept="audio/*"
                      onChange={(e) => handleInputChange('archivoAudio', e.target.files[0])}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>

                  {/* Formato */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Formato</label>
                    <select
                      value={formData.formato}
                      onChange={(e) => handleInputChange('formato', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Seleccionar formato</option>
                      <option value="mp3">MP3</option>
                      <option value="wav">WAV</option>
                      <option value="flac">FLAC</option>
                      <option value="aac">AAC</option>
                    </select>
                  </div>

                  {/* Bitrate */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Bitrate</label>
                    <input
                      type="number"
                      value={formData.bitrate}
                      onChange={(e) => handleInputChange('bitrate', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Bitrate en kbps"
                    />
                  </div>

                  {/* Frecuencia */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Frecuencia</label>
                    <input
                      type="number"
                      value={formData.frecuencia}
                      onChange={(e) => handleInputChange('frecuencia', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Frecuencia en Hz"
                    />
                  </div>

                  {/* Canales */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Canales</label>
                    <select
                      value={formData.canales}
                      onChange={(e) => handleInputChange('canales', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="">Seleccionar canales</option>
                      <option value="mono">Mono (1 canal)</option>
                      <option value="stereo">Estéreo (2 canales)</option>
                      <option value="surround">Surround (5.1)</option>
                    </select>
                  </div>

                  {/* Sampling */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Sampling</label>
                    <input
                      type="number"
                      value={formData.sampling}
                      onChange={(e) => handleInputChange('sampling', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Tasa de muestreo"
                    />
                  </div>
                </div>
              </div>
            )}
          </form>
        </div>

        {/* Footer */}
        <div className="bg-gray-50 border-t border-gray-200 px-6 py-4">
          <div className="flex items-center justify-between">
            {!modoConsulta && (
              <div className="flex items-center space-x-2">
                <input
                  type="checkbox"
                  id="addMore"
                  className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500"
                />
                <label htmlFor="addMore" className="text-sm text-gray-700">
                  Añadir más canciones
                </label>
              </div>
            )}
            <div className="flex items-center space-x-3">
              {modoConsulta ? (
                <button
                  type="button"
                  onClick={onClose}
                  className="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors flex items-center space-x-2"
                >
                  <X className="w-4 h-4" />
                  <span>Cerrar</span>
                </button>
              ) : (
                <>
                  <button
                    type="button"
                    onClick={onClose}
                    className="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 transition-colors"
                  >
                    Cancelar
                  </button>
                  <button
                    type="submit"
                    onClick={handleSubmit}
                    className="flex items-center space-x-2 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    <CheckCircle className="w-4 h-4" />
                    <span>Guardar</span>
                  </button>
                </>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
