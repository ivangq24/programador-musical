-- Script para crear datos de prueba para generación de programación
-- Política de venta, días modelo, relojes y eventos

-- 1. Crear política de prueba si no existe
INSERT INTO politicas_programacion (clave, difusora, habilitada, nombre, descripcion, created_at)
VALUES ('POL_TEST', 'test2', true, 'Política de Prueba', 'Política para pruebas de generación', NOW())
ON CONFLICT (clave) DO NOTHING;

-- Obtener el ID de la política (asumiendo que es la más reciente)
DO $$
DECLARE
    politica_id_var INTEGER;
    dia_modelo_id_var INTEGER;
    reloj_id_var INTEGER;
    hora_actual INTEGER;
    categoria_id_var INTEGER;
    categoria_nombre VARCHAR(50);
BEGIN
    -- Obtener ID de la política
    SELECT id INTO politica_id_var FROM politicas_programacion 
    WHERE clave = 'POL_TEST' AND difusora = 'test2' LIMIT 1;
    
    RAISE NOTICE 'Política ID: %', politica_id_var;
    
    -- 2. Crear día modelo (Lunes a Viernes)
    INSERT INTO dias_modelo (habilitado, difusora, politica_id, clave, nombre, descripcion, 
                            lunes, martes, miercoles, jueves, viernes, sabado, domingo, created_at)
    VALUES (true, 'test2', politica_id_var, 'DIA_LABORAL', 'Día Laboral', 'Programación de lunes a viernes',
            true, true, true, true, true, false, false, NOW())
    ON CONFLICT DO NOTHING;
    
    SELECT id INTO dia_modelo_id_var FROM dias_modelo 
    WHERE clave = 'DIA_LABORAL' AND difusora = 'test2' AND politica_id = politica_id_var LIMIT 1;
    
    RAISE NOTICE 'Día Modelo ID: %', dia_modelo_id_var;
    
    -- 3. Crear 24 relojes (uno por cada hora del día)
    FOR hora_actual IN 0..23 LOOP
        -- Crear reloj
        INSERT INTO relojes (clave, nombre, duracion, numero_eventos, habilitado, politica_id, created_at)
        VALUES (
            'R' || LPAD(hora_actual::TEXT, 2, '0'),
            'Reloj ' || LPAD(hora_actual::TEXT, 2, '0') || ':00',
            '01:00:00',
            0,
            true,
            politica_id_var,
            NOW()
        )
        ON CONFLICT (clave) DO UPDATE SET politica_id = politica_id_var
        RETURNING id INTO reloj_id_var;
        
        -- Si no se insertó, obtener el ID existente
        IF reloj_id_var IS NULL THEN
            SELECT id INTO reloj_id_var FROM relojes 
            WHERE clave = 'R' || LPAD(hora_actual::TEXT, 2, '0') LIMIT 1;
        END IF;
        
        -- Asociar reloj con día modelo
        INSERT INTO relojes_dia_modelo (dia_modelo_id, reloj_id, orden, created_at)
        VALUES (dia_modelo_id_var, reloj_id_var, hora_actual + 1, NOW())
        ON CONFLICT DO NOTHING;
        
        -- Crear eventos para este reloj (20 eventos, mezclando canciones de diferentes categorías)
        FOR i IN 1..20 LOOP
            -- Alternar entre Pop, Rock y Jazz
            IF i % 3 = 0 THEN
                categoria_nombre := 'Pop';
            ELSIF i % 3 = 1 THEN
                categoria_nombre := 'Rock';
            ELSE
                categoria_nombre := 'Jazz';
            END IF;
            
            INSERT INTO eventos_reloj (
                reloj_id, numero, tipo, categoria, descripcion, duracion,
                offset_value, desde_etm, desde_corte, offset_final,
                numero_cancion, sin_categorias
            )
            VALUES (
                reloj_id_var,
                'E' || LPAD(i::TEXT, 2, '0'),
                'cancion',
                categoria_nombre,
                'Evento ' || i || ' - ' || categoria_nombre,
                '00:03:00',
                '00:00:00',
                '00:00:00',
                '00:00:00',
                '00:00:00',
                '-',
                '-'
            )
            ON CONFLICT DO NOTHING;
        END LOOP;
        
        RAISE NOTICE 'Reloj % creado con ID: %', hora_actual, reloj_id_var;
        
    END LOOP;
    
    RAISE NOTICE 'Datos de prueba creados exitosamente para la política %', politica_id_var;
END $$;
