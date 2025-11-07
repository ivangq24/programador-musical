'use client'

import React from 'react'

export default function SimplePage({ title, color = 'blue' }) {
  return (
    <div className={`min-h-screen bg-${color}-500 flex items-center justify-center`}>
      <div className="text-white text-center">
        <h1 className="text-8xl font-bold mb-8">{title}</h1>
        <p className="text-3xl mb-8">Página funcionando correctamente</p>
        <div className="bg-white bg-opacity-20 rounded-lg p-6">
          <p className="text-xl">Esta es una página completa como Difusoras.js</p>
        </div>
      </div>
    </div>
  )
}
