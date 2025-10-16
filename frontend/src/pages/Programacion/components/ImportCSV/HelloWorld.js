'use client'

import React from 'react'

export default function HelloWorld({ onBack }) {
  console.log('=== HELLO WORLD COMPONENT ===')
  console.log('HelloWorld component rendered')
  console.log('onBack function:', onBack)
  console.log('============================')
  
  return (
    <div className="h-screen w-full bg-green-500 flex items-center justify-center">
      <div className="text-white text-center">
        <h1 className="text-6xl font-bold mb-8">HELLO WORLD!</h1>
        <p className="text-2xl mb-8">Componente Import CSV funcionando</p>
      </div>
    </div>
  )
}
