# Frontend - Programador Musical

Aplicación web desarrollada con Next.js 14 para el sistema de programación musical.

## 🚀 Tecnologías

- **Next.js 14** - Framework de React con App Router
- **React 18** - Biblioteca de UI
- **Tailwind CSS** - Framework de CSS utilitario
- **Lucide React** - Iconos
- **ESLint** - Linter de código

## 🛠️ Desarrollo Local

```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Construir para producción
npm run build

# Ejecutar linter
npm run lint
```

## 📁 Módulos Principales

- **Catálogos**: Gestión de entidades del sistema
- **Categorías**: Categorías y canciones
- **Programación**: Políticas y programación musical
- **Reportes**: Reportes del sistema
- **Varios**: Configuraciones adicionales

## 🔧 Configuración de APIs

Las APIs están organizadas por módulo en `src/api/`. Cada módulo tiene su propia carpeta con archivos específicos para cada entidad.

### Ejemplo de uso:

```javascript
import { clientesApi } from '@/api/catalogos/generales/clientesApi'

// Obtener todos los clientes
const clientes = await clientesApi.getClientes()
```