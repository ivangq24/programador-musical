'use client'

export default function SimpleTest({ onBack }) {
  return (
    <div className="h-screen bg-red-100 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-red-800 mb-4">SIMPLE TEST</h1>
        <p className="text-red-600 mb-4">Si ves esto, el componente funciona</p>
      </div>
    </div>
  )
}
