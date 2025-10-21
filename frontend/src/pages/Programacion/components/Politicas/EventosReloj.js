'use client'

import { useState, useEffect } from 'react'
import {
  Music,
  Clock,
  Plus,
  Trash2,
  Save,
  X,
  AlertTriangle,
  Eye,
  Edit,
  Play,
  Pause,
  RotateCcw,
  Scissors
} from 'lucide-react'
import { getCortes } from '../../../../api/catalogos/cortes/index'

export default function EventosReloj({ onSave, onCancel, categoriasPolitica = [] }) {
  const [eventosReloj, setEventosReloj] = useState([])
  const [selectedCategoria, setSelectedCategoria] = useState(null)
  const [duracionTotal, setDuracionTotal] = useState(0)
  const [totalEventos, setTotalEventos] = useState(0)
  const [cortes, setCortes] = useState([])
  const [loadingCortes, setLoadingCortes] = useState(false)

  // Debug: Verificar las categorías recibidas
  console.log('🔍 EventosReloj - categoriasPolitica recibidas:', categoriasPolitica)

  // Cargar cortes desde la base de datos
  useEffect(() => {
    const loadCortes = async () => {
      setLoadingCortes(true)
      try {
        const response = await getCortes({ activo: true })
        setCortes(response.cortes || [])
        console.log('🔍 EventosReloj - Cortes cargados:', response.cortes)
      } catch (error) {
        console.error('Error al cargar cortes:', error)
        setCortes([])
      } finally {
        setLoadingCortes(false)
      }
    }

    loadCortes()
  }, [])

  // Usar las categorías de la política en lugar de cargar todas
  const categorias = categoriasPolitica.map((categoria, index) => ({
    id: index + 1,
    nombre: categoria,
    activa: true,
    tipo: 'cancion'
  }))

  console.log('🔍 EventosReloj - categorias mapeadas:', categorias)
  console.log('🔍 EventosReloj - cortes cargados:', cortes)
  console.log('🔍 EventosReloj - loadingCortes:', loadingCortes)

  const agregarEvento = (categoria) => {
    const nuevoEvento = {
      id: Date.now(),
      offset: calcularOffset(),
      desdeEtm: false,
      desdeCorte: false,
      offsetFinal: 0,
      tipo: 'cancion',
      categoria: categoria.nombre,
      descripcion: `Canción de ${categoria.nombre}`,
      duracion: 180 // 3 minutos por defecto
    }
    
    setEventosReloj([...eventosReloj, nuevoEvento])
    setSelectedCategoria(null)
  }

  const agregarCorte = (corte) => {
    // Convertir duración de HH:MM:SS a segundos
    const duracionEnSegundos = convertirDuracionASegundos(corte.duracion)
    
    const nuevoEvento = {
      id: Date.now(),
      offset: calcularOffset(),
      desdeEtm: false,
      desdeCorte: false,
      offsetFinal: 0,
      tipo: corte.tipo === 'comercial' ? 'comercial' : 'vacio',
      categoria: corte.tipo === 'comercial' ? 'Corte Comercial' : 'Corte Vacío',
      descripcion: corte.nombre,
      duracion: duracionEnSegundos
    }
    
    setEventosReloj([...eventosReloj, nuevoEvento])
  }

  const convertirDuracionASegundos = (duracion) => {
    const [horas, minutos, segundos] = duracion.split(':').map(Number)
    return horas * 3600 + minutos * 60 + segundos
  }

  const calcularOffset = () => {
    if (eventosReloj.length === 0) return 0
    return eventosReloj.reduce((total, evento) => total + evento.duracion, 0)
  }

  const eliminarEvento = (id) => {
    setEventosReloj(eventosReloj.filter(evento => evento.id !== id))
  }

  const actualizarEvento = (id, campo, valor) => {
    setEventosReloj(eventosReloj.map(evento => 
      evento.id === id ? { ...evento, [campo]: valor } : evento
    ))
  }

  // Calcular duración total y total de eventos
  useEffect(() => {
    const duracion = eventosReloj.reduce((total, evento) => total + evento.duracion, 0)
    setDuracionTotal(duracion)
    setTotalEventos(eventosReloj.length)
  }, [eventosReloj])

  const formatDuracion = (segundos) => {
    const minutos = Math.floor(segundos / 60)
    const segs = segundos % 60
    return `${minutos}' ${segs.toString().padStart(2, '0')}" 00"`
  }

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200">
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-200">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-xl font-semibold text-gray-900">Eventos del Reloj</h2>
            <p className="text-sm text-gray-600">Configuración de eventos para 60 minutos</p>
          </div>
          <div className="flex items-center space-x-3">
            <button
              onClick={onCancel}
              className="flex items-center space-x-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <X className="w-4 h-4" />
              <span>Cerrar</span>
            </button>
            <button
              onClick={() => onSave(eventosReloj)}
              className="flex items-center space-x-2 px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 transition-colors"
            >
              <Save className="w-4 h-4" />
              <span>Guardar Reloj</span>
            </button>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        <div className="grid grid-cols-3 gap-6 h-[600px]">
          {/* Panel Izquierdo: Eventos Disponibles */}
          <div className="bg-gray-50 rounded-lg border border-gray-200">
            <div className="p-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">Eventos Disponibles</h3>
            </div>
            <div className="p-4">
              {/* Categorías de Canciones */}
              <div className="mb-6">
                <div className="flex items-center space-x-2 mb-3">
                  <Music className="w-5 h-5 text-blue-600" />
                  <h4 className="font-medium text-gray-900">Canciones</h4>
                </div>
                <div className="space-y-2 max-h-80 overflow-y-auto">
                  {categorias.length === 0 ? (
                    <div className="flex items-center justify-center p-4 text-gray-500">
                      <span className="text-sm">No hay categorías seleccionadas para esta política</span>
                    </div>
                  ) : (
                    categorias.map((categoria) => {
                      console.log('🔍 EventosReloj - Renderizando categoría:', categoria);
                      return (
                        <button
                          key={categoria.id}
                          onClick={() => agregarEvento(categoria)}
                          className="w-full flex items-center space-x-3 p-3 text-left bg-white border border-gray-200 rounded-lg hover:border-blue-300 hover:bg-blue-50 transition-all duration-200 group"
                        >
                          <Music className="w-4 h-4 text-blue-600 group-hover:text-blue-700" />
                          <span className="font-medium text-gray-900 group-hover:text-blue-900">
                            {categoria.nombre}
                          </span>
                          <Plus className="w-4 h-4 text-gray-400 group-hover:text-blue-600 ml-auto" />
                        </button>
                      );
                    })
                  )}
                </div>
              </div>

              {/* Cortes Comerciales y Vacíos */}
              <div className="mb-6">
                <div className="flex items-center space-x-2 mb-3">
                  <Scissors className="w-5 h-5 text-red-600" />
                  <h4 className="font-medium text-gray-900">Cortes</h4>
                </div>
                <div className="space-y-2 max-h-80 overflow-y-auto">
                  {loadingCortes ? (
                    <div className="flex items-center justify-center p-4 text-gray-500">
                      <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-red-600"></div>
                      <span className="ml-2 text-sm">Cargando cortes...</span>
                    </div>
                  ) : cortes.length === 0 ? (
                    <div className="flex items-center justify-center p-4 text-gray-500">
                      <span className="text-sm">No hay cortes disponibles</span>
                    </div>
                  ) : (
                    cortes.map((corte) => (
                      <button
                        key={corte.id}
                        onClick={() => agregarCorte(corte)}
                        className="w-full flex items-center space-x-3 p-3 text-left bg-white border border-gray-200 rounded-lg hover:border-red-300 hover:bg-red-50 transition-all duration-200 group"
                      >
                        <Scissors className={`w-4 h-4 ${corte.tipo === 'comercial' ? 'text-red-600' : 'text-gray-600'} group-hover:text-red-700`} />
                        <div className="flex-1">
                          <span className="font-medium text-gray-900 group-hover:text-red-900 block">
                            {corte.nombre}
                          </span>
                          <span className="text-xs text-gray-500">
                            {corte.tipo === 'comercial' ? 'Comercial' : 'Vacío'} • {corte.duracion}
                          </span>
                        </div>
                        <Plus className="w-4 h-4 text-gray-400 group-hover:text-red-600" />
                      </button>
                    ))
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Panel Central: Estructura del Reloj */}
          <div className="bg-white rounded-lg border border-gray-200">
            <div className="p-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">Estructura del Reloj</h3>
            </div>
            <div className="p-4">
              <div className="mb-4">
                <div className="text-sm text-gray-600 mb-2">OFFSET</div>
                <div className="text-lg font-semibold text-gray-900">AVG=91.95</div>
              </div>
              
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-gray-200">
                      <th className="text-left py-2 px-2 font-medium text-gray-700">#</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">OFFSET</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">DESDE ETM</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">DESDE CORTE</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">OFFSET FINAL</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">TIPO</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">CATEGORIA</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">DESCRIPCION</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">DURACION</th>
                      <th className="text-left py-2 px-2 font-medium text-gray-700">ACCIONES</th>
                    </tr>
                  </thead>
                  <tbody>
                    {eventosReloj.length === 0 ? (
                      <tr>
                        <td colSpan="10" className="text-center py-8 text-gray-500">
                          No hay eventos configurados
                        </td>
                      </tr>
                    ) : (
                      eventosReloj.map((evento, index) => (
                        <tr key={evento.id} className="border-b border-gray-100 hover:bg-gray-50">
                          <td className="py-2 px-2 text-gray-600">{index + 1}</td>
                          <td className="py-2 px-2">
                            <input
                              type="number"
                              value={evento.offset}
                              onChange={(e) => actualizarEvento(evento.id, 'offset', parseInt(e.target.value) || 0)}
                              className="w-16 px-2 py-1 text-xs border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <input
                              type="checkbox"
                              checked={evento.desdeEtm}
                              onChange={(e) => actualizarEvento(evento.id, 'desdeEtm', e.target.checked)}
                              className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <input
                              type="checkbox"
                              checked={evento.desdeCorte}
                              onChange={(e) => actualizarEvento(evento.id, 'desdeCorte', e.target.checked)}
                              className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <input
                              type="number"
                              value={evento.offsetFinal}
                              onChange={(e) => actualizarEvento(evento.id, 'offsetFinal', parseInt(e.target.value) || 0)}
                              className="w-16 px-2 py-1 text-xs border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <select
                              value={evento.tipo}
                              onChange={(e) => actualizarEvento(evento.id, 'tipo', e.target.value)}
                              className="text-xs border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            >
                              <option value="cancion">Canción</option>
                              <option value="comercial">Comercial</option>
                              <option value="etm">ETM</option>
                              <option value="nota">Nota</option>
                            </select>
                          </td>
                          <td className="py-2 px-2 text-gray-900 font-medium">{evento.categoria}</td>
                          <td className="py-2 px-2">
                            <input
                              type="text"
                              value={evento.descripcion}
                              onChange={(e) => actualizarEvento(evento.id, 'descripcion', e.target.value)}
                              className="w-32 px-2 py-1 text-xs border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <input
                              type="number"
                              value={evento.duracion}
                              onChange={(e) => actualizarEvento(evento.id, 'duracion', parseInt(e.target.value) || 0)}
                              className="w-16 px-2 py-1 text-xs border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            />
                          </td>
                          <td className="py-2 px-2">
                            <button
                              onClick={() => eliminarEvento(evento.id)}
                              className="text-red-600 hover:text-red-800 transition-colors"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          {/* Panel Derecho: Visualización del Reloj */}
          <div className="bg-gray-50 rounded-lg border border-gray-200">
            <div className="p-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">Visualización del Reloj</h3>
            </div>
            <div className="p-4">
              {/* Reloj Circular */}
              <div className="flex justify-center mb-6">
                <div className="relative w-48 h-48">
                  <div className="absolute inset-0 rounded-full border-4 border-gray-300 bg-white">
                    {/* Marcas del reloj */}
                    {Array.from({ length: 12 }, (_, i) => (
                      <div
                        key={i}
                        className="absolute w-1 h-4 bg-gray-400"
                        style={{
                          top: '10px',
                          left: '50%',
                          transformOrigin: '50% 114px',
                          transform: `rotate(${i * 30}deg) translateX(-50%)`
                        }}
                      />
                    ))}
                    {/* Centro del reloj */}
                    <div className="absolute top-1/2 left-1/2 w-3 h-3 bg-gray-600 rounded-full transform -translate-x-1/2 -translate-y-1/2" />
                  </div>
                </div>
              </div>

              {/* Leyenda de colores */}
              <div className="mb-4">
                <h4 className="text-sm font-medium text-gray-900 mb-2">Leyenda de colores</h4>
                <div className="space-y-1 text-xs">
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                    <span className="text-gray-700">Canciones</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                    <span className="text-gray-700">Nota Operador</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-purple-500 rounded-full"></div>
                    <span className="text-gray-700">Cartucho Fijo</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-pink-500 rounded-full"></div>
                    <span className="text-gray-700">Canción Manual</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-orange-500 rounded-full"></div>
                    <span className="text-gray-700">Twofer</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                    <span className="text-gray-700">Corte Comercial</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-gray-500 rounded-full"></div>
                    <span className="text-gray-700">Corte Vacío</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span className="text-gray-700">ETM</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-cyan-500 rounded-full"></div>
                    <span className="text-gray-700">Exact Time Marker</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-emerald-500 rounded-full"></div>
                    <span className="text-gray-700">Comando</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-3 h-3 bg-lime-500 rounded-full"></div>
                    <span className="text-gray-700">Característica Específica</span>
                  </div>
                </div>
              </div>

              {/* Estadísticas */}
              <div className="bg-white rounded-lg border border-gray-200 p-3">
                <div className="text-sm text-gray-600 mb-1">Total: {totalEventos} eventos</div>
                <div className="text-sm text-gray-600">Duración: {formatDuracion(duracionTotal)}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="px-6 py-4 border-t border-gray-200 bg-gray-50">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-2 text-amber-600">
            <AlertTriangle className="w-4 h-4" />
            <span className="text-sm font-medium">Cambios sin guardar</span>
          </div>
          <div className="flex items-center space-x-3">
            <button
              onClick={onCancel}
              className="flex items-center space-x-2 px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700 transition-colors"
            >
              <X className="w-4 h-4" />
              <span>Cerrar</span>
            </button>
            <button
              onClick={() => onSave(eventosReloj)}
              className="flex items-center space-x-2 px-4 py-2 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 transition-colors"
            >
              <Save className="w-4 h-4" />
              <span>Crear</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
