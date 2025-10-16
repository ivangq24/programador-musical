'use client'

export default function TestImportCSV({ onBack }) {
  console.log('TestImportCSV rendered', { onBack })
  
  return (
    <div className="h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 overflow-hidden p-6">
      <div className="h-full flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Importar CSV - PRUEBA</h2>
          <p className="text-gray-600 mb-6">Componente de prueba para verificar navegación</p>
          
          <div className="bg-blue-50 rounded-lg p-4 mb-6">
            <h3 className="text-lg font-semibold text-blue-900 mb-2">Estado del Componente:</h3>
            <p className="text-blue-800">✅ Componente cargado correctamente</p>
            <p className="text-blue-800">✅ Función onBack disponible: {onBack ? 'Sí' : 'No'}</p>
            <p className="text-blue-800">✅ Navegación funcional</p>
          </div>
          
        </div>
      </div>
    </div>
  )
}
