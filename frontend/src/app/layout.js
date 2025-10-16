import './globals.css'

export const metadata = {
  title: 'Programador Musical',
  description: 'Sistema de programación musical',
}

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <body>
        {children}
      </body>
    </html>
  )
}
