'use client'

import React from 'react'

export default function TestComponent({ onBack, title, color = 'blue' }) {
  console.log('=== TEST COMPONENT RENDERED ===')
  console.log('Title:', title)
  console.log('Color:', color)
  console.log('onBack:', onBack)
  console.log('================================')
  
  return (
    <div className={`h-screen w-full bg-${color}-500 flex items-center justify-center`}>
      <div className="text-white text-center">
        <h1 className="text-6xl font-bold mb-8">{title}</h1>
        <p className="text-2xl mb-8">Componente funcionando correctamente</p>
      </div>
    </div>
  )
}
