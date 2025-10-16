-- 1) TABLAS
-- 1. Políticas de Programación
CREATE TABLE IF NOT EXISTS politicas_programacion (
    id SERIAL PRIMARY KEY,
    clave VARCHAR(50) NOT NULL UNIQUE,
    difusora VARCHAR(10) NOT NULL,
    habilitada BOOLEAN DEFAULT TRUE,
    guid VARCHAR(50) UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    alta VARCHAR(100),
    modificacion VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Relojes
CREATE TABLE IF NOT EXISTS relojes (
    id SERIAL PRIMARY KEY,
    habilitado BOOLEAN DEFAULT TRUE,
    clave VARCHAR(50) NOT NULL UNIQUE,
    grupo VARCHAR(100),
    numero_regla VARCHAR(20),
    nombre VARCHAR(200) NOT NULL,
    numero_eventos INTEGER DEFAULT 0,
    duracion VARCHAR(20) DEFAULT '00:00:00',
    con_evento BOOLEAN DEFAULT FALSE,
    politica_id INTEGER REFERENCES politicas_programacion(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Eventos de Reloj
CREATE TABLE IF NOT EXISTS eventos_reloj (
    id SERIAL PRIMARY KEY,
    reloj_id INTEGER REFERENCES relojes(id) ON DELETE CASCADE,
    numero VARCHAR(10) NOT NULL,
    offset_value VARCHAR(10) DEFAULT '00:00:00',
    desde_etm VARCHAR(10) DEFAULT '00:00:00',
    desde_corte VARCHAR(10) DEFAULT '00:00:00',
    offset_final VARCHAR(10) DEFAULT '00:00:00',
    tipo VARCHAR(20) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    duracion VARCHAR(10) DEFAULT '00:00:00',
    numero_cancion VARCHAR(10) DEFAULT '-',
    sin_categorias VARCHAR(10) DEFAULT '-',
    -- Campos específicos
    id_media VARCHAR(50),
    categoria_media VARCHAR(50),
    tipo_etm VARCHAR(20),
    comando_das VARCHAR(100),
    caracteristica VARCHAR(50),
    twofer_valor VARCHAR(50),
    todas_categorias BOOLEAN DEFAULT TRUE,
    categorias_usar TEXT,
    grupos_reglas_ignorar TEXT,
    clasificaciones_evento TEXT,
    caracteristica_especifica VARCHAR(50),
    valor_deseado VARCHAR(50),
    usar_todas_categorias BOOLEAN DEFAULT TRUE,
    categorias_usar_especifica TEXT,
    grupos_reglas_ignorar_especifica TEXT,
    clasificaciones_evento_especifica TEXT,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Días Modelo
CREATE TABLE IF NOT EXISTS dias_modelo (
    id SERIAL PRIMARY KEY,
    habilitado BOOLEAN DEFAULT TRUE,
    difusora VARCHAR(10) NOT NULL,
    politica_id INTEGER REFERENCES politicas_programacion(id) ON DELETE CASCADE,
    clave VARCHAR(50) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    lunes BOOLEAN DEFAULT FALSE,
    martes BOOLEAN DEFAULT FALSE,
    miercoles BOOLEAN DEFAULT FALSE,
    jueves BOOLEAN DEFAULT FALSE,
    viernes BOOLEAN DEFAULT FALSE,
    sabado BOOLEAN DEFAULT FALSE,
    domingo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Relación Relojes-Días Modelo
CREATE TABLE IF NOT EXISTS relojes_dia_modelo (
    id SERIAL PRIMARY KEY,
    dia_modelo_id INTEGER REFERENCES dias_modelo(id) ON DELETE CASCADE,
    reloj_id INTEGER REFERENCES relojes(id) ON DELETE CASCADE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(dia_modelo_id, reloj_id)
);

-- 6. Sets de Reglas
CREATE TABLE IF NOT EXISTS sets_reglas (
    id SERIAL PRIMARY KEY,
    politica_id INTEGER REFERENCES politicas_programacion(id) ON DELETE CASCADE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    habilitado BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Reglas
CREATE TABLE IF NOT EXISTS reglas (
    id SERIAL PRIMARY KEY,
    set_regla_id INTEGER REFERENCES sets_reglas(id) ON DELETE CASCADE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    parametros JSONB,
    habilitada BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Orden de Asignación
CREATE TABLE IF NOT EXISTS orden_asignacion (
    id SERIAL PRIMARY KEY,
    politica_id INTEGER REFERENCES politicas_programacion(id) ON DELETE CASCADE,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    parametros JSONB,
    habilitado BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2) INSERTS
-- Políticas
INSERT INTO politicas_programacion (clave, difusora, habilitada, guid, nombre, descripcion, alta, modificacion) VALUES
('DIARIO', 'XRAD', TRUE, '{F0268715-8A1B-4CCA-9790-913E3810874C}', 'DIARIO', 'Política de programación diaria', '28/12/2017 12:44:36 p. m. (Administrator)', '18/01/2022 02:08:20 p. m. (Administrator)'),
('General', 'XHPER', TRUE, '{9D45EB0E-D2AB-4113-AD30-B628B18482CE}', 'Política General', 'Política general de programación', '28/12/2017 06:16:09 p. m. (Administrator)', '13/01/2025 04:20:22 p. m. (Administrator)'),
('GRAL_XHGR', 'XHGR', TRUE, '{C3C4787D-6EF0-4B3D-91E6-ACAE8F229F1C}', 'GRAL_XHGR', 'Política específica para XHGR', '29/03/2019 04:13:45 p. m. (Administrator)', '13/08/2025 04:40:50 p. m. (Administrator)'),
('GRAL_XHOZ', 'XHOZ', TRUE, '{2FE14516-E959-4D34-A213-46A5152B4784}', 'AMOR 91.7', 'Política para AMOR 91.7', '01/02/2022 11:05:55 a. m. (Administrator)', '13/08/2025 04:46:49 p. m. (Administrator)')
ON CONFLICT (clave) DO NOTHING;

-- Relojes (usan politica_id por subconsulta)
INSERT INTO relojes (habilitado, clave, grupo, numero_regla, nombre, numero_eventos, duracion, con_evento, politica_id)
VALUES
(TRUE, 'DOMINGO_23_52', 'Grupo A', '001', 'DOMINGO 23.52', 8, '00:24:00', TRUE, (SELECT id FROM politicas_programacion WHERE clave='DIARIO')),
(TRUE, 'LUNES_06_00',    'Grupo B', '002', 'LUNES 06.00',    6, '00:18:00', TRUE, (SELECT id FROM politicas_programacion WHERE clave='DIARIO')),
(TRUE, 'MARTES_12_30',  'Grupo A', '003', 'MARTES 12.30',   5, '00:15:00', TRUE, (SELECT id FROM politicas_programacion WHERE clave='DIARIO'))
ON CONFLICT (clave) DO NOTHING;

-- Eventos de reloj (corrigiendo 'offset' -> 'offset_value' y referenciando por clave)
INSERT INTO eventos_reloj
(reloj_id, numero, offset_value, desde_etm, desde_corte, offset_final, tipo, categoria, descripcion, duracion, numero_cancion, sin_categorias, orden)
VALUES
-- DOMINGO_23_52
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'001','00:00:00','00:00:00','00:00:00','00:00:00','ETM','ETM','Inicio del reloj','00:00:00','-','-',1),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'002','00:00:00','00:00:00','00:00:00','00:00:00','6','ETM','ETM 00','00:00:00','-','-',2),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'003','00:00:00','00:00:00','00:00:00','00:04:00','1','Canciones','CAFE1','00:04:00','001','-',3),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'004','00:04:00','00:04:00','00:04:00','00:08:00','1','Canciones','GLORIA','00:04:00','002','-',4),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'005','00:08:00','00:08:00','00:08:00','00:12:00','1','Canciones','HIMNO','00:04:00','003','-',5),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'006','00:12:00','00:12:00','00:12:00','00:16:00','1','Canciones','MUSICA','00:04:00','004','-',6),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'007','00:16:00','00:16:00','00:16:00','00:20:00','1','Canciones','PROMO','00:04:00','005','-',7),
((SELECT id FROM relojes WHERE clave='DOMINGO_23_52'),'008','00:20:00','00:20:00','00:20:00','00:24:00','1','Canciones','PROMOSLOS40','00:04:00','006','-',8),

-- LUNES_06_00
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'001','00:00:00','00:00:00','00:00:00','00:00:00','ETM','ETM','Inicio del reloj','00:00:00','-','-',1),
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'002','00:00:00','00:00:00','00:00:00','00:00:00','6','ETM','ETM 00','00:00:00','-','-',2),
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'003','00:00:00','00:00:00','00:00:00','00:06:00','2','Corte Comercial','CC 3M','00:06:00','-','-',3),
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'004','00:06:00','00:06:00','00:06:00','00:12:00','1','Canciones','MUSICA_MAÑANA','00:06:00','001','-',4),
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'005','00:12:00','00:12:00','00:12:00','00:15:00','3','Nota Operador','NOTA_MAÑANA','00:03:00','-','-',5),
((SELECT id FROM relojes WHERE clave='LUNES_06_00'),'006','00:15:00','00:15:00','00:15:00','00:18:00','1','Canciones','DESPERTAR','00:03:00','002','-',6),

-- MARTES_12_30
((SELECT id FROM relojes WHERE clave='MARTES_12_30'),'001','00:00:00','00:00:00','00:00:00','00:00:00','ETM','ETM','Inicio del reloj','00:00:00','-','-',1),
((SELECT id FROM relojes WHERE clave='MARTES_12_30'),'002','00:00:00','00:00:00','00:00:00','00:05:00','1','Canciones','ALMUERZO','00:05:00','001','-',2),
((SELECT id FROM relojes WHERE clave='MARTES_12_30'),'003','00:05:00','00:05:00','00:05:00','00:10:00','2','Corte Comercial','CC 5M','00:05:00','-','-',3),
((SELECT id FROM relojes WHERE clave='MARTES_12_30'),'004','00:10:00','00:10:00','00:10:00','00:12:00','4','Cartucho Fijo','HORA_EXACTA','00:02:00','-','-',4),
((SELECT id FROM relojes WHERE clave='MARTES_12_30'),'005','00:12:00','00:12:00','00:12:00','00:15:00','1','Canciones','MUSICA_TARDE','00:03:00','002','-',5);

-- Días modelo (usan politica_id por subconsulta)
INSERT INTO dias_modelo
(habilitado, difusora, politica_id, clave, nombre, descripcion, lunes, martes, miercoles, jueves, viernes, sabado, domingo)
VALUES
(TRUE, 'XRAD',  (SELECT id FROM politicas_programacion WHERE clave='DIARIO'), 'DIA_LABORAL', 'Día Laboral', 'Día modelo para días laborales', TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE),
(TRUE, 'XRAD',  (SELECT id FROM politicas_programacion WHERE clave='DIARIO'), 'FIN_SEMANA', 'Fin de Semana', 'Día modelo para fines de semana', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE),
(TRUE, 'XHPER', (SELECT id FROM politicas_programacion WHERE clave='General'), 'DIA_GENERAL', 'Día General', 'Día modelo general', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE);

-- Relación relojes-días modelo (subconsultas por clave)
INSERT INTO relojes_dia_modelo (dia_modelo_id, reloj_id, orden) VALUES
((SELECT id FROM dias_modelo WHERE clave='DIA_LABORAL'), (SELECT id FROM relojes WHERE clave='LUNES_06_00'), 1),
((SELECT id FROM dias_modelo WHERE clave='DIA_LABORAL'), (SELECT id FROM relojes WHERE clave='MARTES_12_30'), 2),
((SELECT id FROM dias_modelo WHERE clave='FIN_SEMANA'), (SELECT id FROM relojes WHERE clave='DOMINGO_23_52'), 1),
((SELECT id FROM dias_modelo WHERE clave='DIA_GENERAL'), (SELECT id FROM relojes WHERE clave='DOMINGO_23_52'), 1),
((SELECT id FROM dias_modelo WHERE clave='DIA_GENERAL'), (SELECT id FROM relojes WHERE clave='LUNES_06_00'), 2),
((SELECT id FROM dias_modelo WHERE clave='DIA_GENERAL'), (SELECT id FROM relojes WHERE clave='MARTES_12_30'), 3)
ON CONFLICT (dia_modelo_id, reloj_id) DO NOTHING;

-- Sets de reglas (usan politica_id por subconsulta)
INSERT INTO sets_reglas (politica_id, nombre, descripcion, habilitado, orden) VALUES
((SELECT id FROM politicas_programacion WHERE clave='DIARIO'),  'Set Reglas Diarias',   'Conjunto de reglas para programación diaria', TRUE, 1),
((SELECT id FROM politicas_programacion WHERE clave='DIARIO'),  'Set Reglas Especiales','Reglas especiales para eventos',               TRUE, 2),
((SELECT id FROM politicas_programacion WHERE clave='General'), 'Set Reglas Generales', 'Reglas generales de programación',             TRUE, 1);

-- Reglas (buscan el set por nombre)
INSERT INTO reglas (set_regla_id, nombre, descripcion, tipo, parametros, habilitada, orden) VALUES
((SELECT id FROM sets_reglas WHERE nombre='Set Reglas Diarias'),   'Regla de Rotación',   'Regla para rotar canciones',          'rotacion',  '{"intervalo": 24, "categorias": ["pop", "rock"]}', TRUE, 1),
((SELECT id FROM sets_reglas WHERE nombre='Set Reglas Diarias'),   'Regla de Separación', 'Separar canciones similares',          'separacion','{"minutos": 30, "categorias": ["pop"]}',        TRUE, 2),
((SELECT id FROM sets_reglas WHERE nombre='Set Reglas Especiales'),'Regla de Eventos',    'Regla para eventos especiales',        'eventos',   '{"prioridad": "alta", "duracion_max": 300}',       TRUE, 1);

-- Orden de asignación (usan politica_id por subconsulta)
INSERT INTO orden_asignacion (politica_id, nombre, descripcion, tipo, parametros, habilitado, orden) VALUES
((SELECT id FROM politicas_programacion WHERE clave='DIARIO'),  'Orden por Categoría', 'Asignar por categoría musical', 'categoria', '{"prioridad": ["pop", "rock", "balada"]}', TRUE, 1),
((SELECT id FROM politicas_programacion WHERE clave='DIARIO'),  'Orden por Duración', 'Asignar por duración',          'duracion',  '{"rango": [180, 240]}',                   TRUE, 2),
((SELECT id FROM politicas_programacion WHERE clave='General'), 'Orden General',      'Orden general de asignación',  'general',   '{"criterio": "aleatorio"}',                 TRUE, 1);
