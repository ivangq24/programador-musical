-- Script para actualizar la tabla difusoras en la base de datos programador-musical
-- Ejecutar este script en PostgreSQL para agregar los nuevos campos

-- Conectar a la base de datos programador-musical
\c programador-musical;

-- Verificar si la tabla difusoras existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'difusoras') THEN
        -- Crear la tabla si no existe
        CREATE TABLE difusoras (
            id SERIAL PRIMARY KEY,
            siglas VARCHAR(50) NOT NULL UNIQUE,
            nombre VARCHAR(200) NOT NULL,
            slogan VARCHAR(500),
            orden INTEGER DEFAULT 1,
            mascara_medidas VARCHAR(20) DEFAULT 'MM:SS',
            descripcion TEXT,
            activa BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE
        );
        
        -- Crear índices
        CREATE INDEX idx_difusoras_siglas ON difusoras(siglas);
        CREATE INDEX idx_difusoras_activa ON difusoras(activa);
        CREATE INDEX idx_difusoras_orden ON difusoras(orden);
        
        RAISE NOTICE 'Tabla difusoras creada exitosamente';
    ELSE
        -- La tabla existe, agregar los campos faltantes
        BEGIN
            -- Agregar campo siglas si no existe
            IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'difusoras' AND column_name = 'siglas') THEN
                ALTER TABLE difusoras ADD COLUMN siglas VARCHAR(50);
                ALTER TABLE difusoras ADD CONSTRAINT difusoras_siglas_unique UNIQUE (siglas);
                RAISE NOTICE 'Campo siglas agregado';
            END IF;
            
            -- Agregar campo slogan si no existe
            IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'difusoras' AND column_name = 'slogan') THEN
                ALTER TABLE difusoras ADD COLUMN slogan VARCHAR(500);
                RAISE NOTICE 'Campo slogan agregado';
            END IF;
            
            -- Agregar campo orden si no existe
            IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'difusoras' AND column_name = 'orden') THEN
                ALTER TABLE difusoras ADD COLUMN orden INTEGER DEFAULT 1;
                RAISE NOTICE 'Campo orden agregado';
            END IF;
            
            -- Agregar campo mascara_medidas si no existe
            IF NOT EXISTS (SELECT FROM information_schema.columns WHERE table_name = 'difusoras' AND column_name = 'mascara_medidas') THEN
                ALTER TABLE difusoras ADD COLUMN mascara_medidas VARCHAR(20) DEFAULT 'MM:SS';
                RAISE NOTICE 'Campo mascara_medidas agregado';
            END IF;
            
            -- Actualizar el campo nombre si es necesario (aumentar longitud)
            ALTER TABLE difusoras ALTER COLUMN nombre TYPE VARCHAR(200);
            
            -- Crear índices si no existen
            IF NOT EXISTS (SELECT FROM pg_indexes WHERE tablename = 'difusoras' AND indexname = 'idx_difusoras_siglas') THEN
                CREATE INDEX idx_difusoras_siglas ON difusoras(siglas);
            END IF;
            
            IF NOT EXISTS (SELECT FROM pg_indexes WHERE tablename = 'difusoras' AND indexname = 'idx_difusoras_activa') THEN
                CREATE INDEX idx_difusoras_activa ON difusoras(activa);
            END IF;
            
            IF NOT EXISTS (SELECT FROM pg_indexes WHERE tablename = 'difusoras' AND indexname = 'idx_difusoras_orden') THEN
                CREATE INDEX idx_difusoras_orden ON difusoras(orden);
            END IF;
            
            RAISE NOTICE 'Tabla difusoras actualizada exitosamente';
        END;
    END IF;
END $$;

-- Insertar datos de ejemplo si la tabla está vacía
INSERT INTO difusoras (siglas, nombre, slogan, orden, mascara_medidas, descripcion, activa)
SELECT 'RADIO1', 'Radio Primera', 'La mejor música del momento', 1, 'MM:SS', 'Estación de radio principal', true
WHERE NOT EXISTS (SELECT 1 FROM difusoras WHERE siglas = 'RADIO1');

INSERT INTO difusoras (siglas, nombre, slogan, orden, mascara_medidas, descripcion, activa)
SELECT 'RADIO2', 'Radio Segunda', 'Música para todos', 2, 'HH:MM:SS', 'Estación de radio secundaria', true
WHERE NOT EXISTS (SELECT 1 FROM difusoras WHERE siglas = 'RADIO2');

INSERT INTO difusoras (siglas, nombre, slogan, orden, mascara_medidas, descripcion, activa)
SELECT 'RADIO3', 'Radio Tercera', 'Tu música favorita', 3, 'MM:SS', 'Estación de radio terciaria', false
WHERE NOT EXISTS (SELECT 1 FROM difusoras WHERE siglas = 'RADIO3');

-- Mostrar la estructura final de la tabla
\d difusoras;

-- Mostrar los datos insertados
SELECT id, siglas, nombre, slogan, orden, mascara_medidas, activa, created_at 
FROM difusoras 
ORDER BY orden;

