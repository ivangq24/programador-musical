--
-- PostgreSQL database dump
--

\restrict IAJ3lYObmIg5zXuXHErCrQbt24LGbcD0DupzoqbgaT5kb1B8CCKW0MsD44mulfL

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: canciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.canciones (
    id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    artista character varying(200),
    album character varying(200),
    duracion integer,
    categoria_id integer,
    conjunto_id integer,
    activa boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


--
-- Name: canciones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.canciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: canciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.canciones_id_seq OWNED BY public.canciones.id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    activa boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: conjuntos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conjuntos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


--
-- Name: conjuntos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conjuntos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conjuntos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conjuntos_id_seq OWNED BY public.conjuntos.id;


--
-- Name: cortes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cortes (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    duracion character varying(8) NOT NULL,
    tipo character varying(20) DEFAULT 'comercial'::character varying NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


--
-- Name: cortes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cortes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cortes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cortes_id_seq OWNED BY public.cortes.id;


--
-- Name: dias_modelo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dias_modelo (
    id integer NOT NULL,
    habilitado boolean DEFAULT true,
    difusora character varying(10) NOT NULL,
    politica_id integer,
    clave character varying(50) NOT NULL,
    nombre character varying(200) NOT NULL,
    descripcion text,
    lunes boolean DEFAULT false,
    martes boolean DEFAULT false,
    miercoles boolean DEFAULT false,
    jueves boolean DEFAULT false,
    viernes boolean DEFAULT false,
    sabado boolean DEFAULT false,
    domingo boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: dias_modelo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dias_modelo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dias_modelo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dias_modelo_id_seq OWNED BY public.dias_modelo.id;


--
-- Name: difusoras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.difusoras (
    id integer NOT NULL,
    siglas character varying(50) NOT NULL,
    nombre character varying(200) NOT NULL,
    slogan character varying(500),
    orden integer DEFAULT 1,
    mascara_medidas character varying(20) DEFAULT 'MM:SS'::character varying,
    descripcion text,
    activa boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: difusoras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.difusoras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: difusoras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.difusoras_id_seq OWNED BY public.difusoras.id;


--
-- Name: eventos_reloj; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventos_reloj (
    id integer NOT NULL,
    reloj_id integer,
    numero character varying(10) NOT NULL,
    offset_value character varying(10) DEFAULT '00:00:00'::character varying,
    desde_etm character varying(10) DEFAULT '00:00:00'::character varying,
    desde_corte character varying(10) DEFAULT '00:00:00'::character varying,
    offset_final character varying(10) DEFAULT '00:00:00'::character varying,
    tipo character varying(20) NOT NULL,
    categoria character varying(50) NOT NULL,
    descripcion character varying(200),
    duracion character varying(10) DEFAULT '00:00:00'::character varying,
    numero_cancion character varying(10) DEFAULT '-'::character varying,
    sin_categorias character varying(10) DEFAULT '-'::character varying,
    id_media character varying(50),
    categoria_media character varying(50),
    tipo_etm character varying(20),
    comando_das character varying(100),
    caracteristica character varying(50),
    twofer_valor character varying(50),
    todas_categorias boolean DEFAULT true,
    categorias_usar text,
    grupos_reglas_ignorar text,
    clasificaciones_evento text,
    caracteristica_especifica character varying(50),
    valor_deseado character varying(50),
    usar_todas_categorias boolean DEFAULT true,
    categorias_usar_especifica text,
    grupos_reglas_ignorar_especifica text,
    clasificaciones_evento_especifica text,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eventos_reloj_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eventos_reloj_id_seq OWNED BY public.eventos_reloj.id;


--
-- Name: orden_asignacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orden_asignacion (
    id integer NOT NULL,
    politica_id integer,
    nombre character varying(200) NOT NULL,
    descripcion text,
    tipo character varying(50) NOT NULL,
    parametros jsonb,
    habilitado boolean DEFAULT true,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: orden_asignacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orden_asignacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orden_asignacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orden_asignacion_id_seq OWNED BY public.orden_asignacion.id;


--
-- Name: politica_categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.politica_categorias (
    id integer NOT NULL,
    politica_id integer,
    categoria_nombre character varying(100) NOT NULL
);


--
-- Name: politica_categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.politica_categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: politica_categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.politica_categorias_id_seq OWNED BY public.politica_categorias.id;


--
-- Name: politicas_programacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.politicas_programacion (
    id integer NOT NULL,
    clave character varying(50) NOT NULL,
    difusora character varying(10) NOT NULL,
    habilitada boolean DEFAULT true,
    guid character varying(50),
    nombre character varying(200) NOT NULL,
    descripcion text,
    alta character varying(100),
    modificacion character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    categorias_seleccionadas text,
    updated_at timestamp with time zone,
    lunes integer,
    martes integer,
    miercoles integer,
    jueves integer,
    viernes integer,
    sabado integer,
    domingo integer
);


--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.politicas_programacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.politicas_programacion_id_seq OWNED BY public.politicas_programacion.id;


--
-- Name: programacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programacion (
    id integer NOT NULL,
    mc boolean DEFAULT false,
    numero_reloj character varying(10) NOT NULL,
    hora_real time without time zone,
    hora_transmision time without time zone,
    duracion_real character varying(10),
    tipo character varying(20) NOT NULL,
    hora_planeada time without time zone,
    duracion_planeada character varying(10),
    categoria character varying(50) NOT NULL,
    id_media character varying(50),
    descripcion character varying(200),
    lenguaje character varying(20),
    interprete character varying(100),
    disco character varying(100),
    sello_discografico character varying(100),
    bpm integer,
    "año" integer,
    difusora character varying(10) NOT NULL,
    politica_id integer,
    fecha date NOT NULL,
    reloj_id integer,
    evento_reloj_id integer,
    dia_modelo_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: programacion_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programacion_id_seq OWNED BY public.programacion.id;


--
-- Name: reglas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reglas (
    id integer NOT NULL,
    set_regla_id integer,
    nombre character varying(200) NOT NULL,
    descripcion text,
    tipo character varying(50) NOT NULL,
    parametros jsonb,
    habilitada boolean DEFAULT true,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: reglas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reglas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reglas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reglas_id_seq OWNED BY public.reglas.id;


--
-- Name: relojes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relojes (
    id integer NOT NULL,
    habilitado boolean DEFAULT true,
    clave character varying(50) NOT NULL,
    grupo character varying(100),
    numero_regla character varying(20),
    nombre character varying(200) NOT NULL,
    numero_eventos integer DEFAULT 0,
    duracion character varying(20) DEFAULT '00:00:00'::character varying,
    con_evento boolean DEFAULT false,
    politica_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: relojes_dia_modelo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relojes_dia_modelo (
    id integer NOT NULL,
    dia_modelo_id integer,
    reloj_id integer,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relojes_dia_modelo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relojes_dia_modelo_id_seq OWNED BY public.relojes_dia_modelo.id;


--
-- Name: relojes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relojes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relojes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relojes_id_seq OWNED BY public.relojes.id;


--
-- Name: sets_reglas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sets_reglas (
    id integer NOT NULL,
    politica_id integer,
    nombre character varying(200) NOT NULL,
    descripcion text,
    habilitado boolean DEFAULT true,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


--
-- Name: sets_reglas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sets_reglas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sets_reglas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sets_reglas_id_seq OWNED BY public.sets_reglas.id;


--
-- Name: canciones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canciones ALTER COLUMN id SET DEFAULT nextval('public.canciones_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: conjuntos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conjuntos ALTER COLUMN id SET DEFAULT nextval('public.conjuntos_id_seq'::regclass);


--
-- Name: cortes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cortes ALTER COLUMN id SET DEFAULT nextval('public.cortes_id_seq'::regclass);


--
-- Name: dias_modelo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dias_modelo ALTER COLUMN id SET DEFAULT nextval('public.dias_modelo_id_seq'::regclass);


--
-- Name: difusoras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.difusoras ALTER COLUMN id SET DEFAULT nextval('public.difusoras_id_seq'::regclass);


--
-- Name: eventos_reloj id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventos_reloj ALTER COLUMN id SET DEFAULT nextval('public.eventos_reloj_id_seq'::regclass);


--
-- Name: orden_asignacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orden_asignacion ALTER COLUMN id SET DEFAULT nextval('public.orden_asignacion_id_seq'::regclass);


--
-- Name: politica_categorias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politica_categorias ALTER COLUMN id SET DEFAULT nextval('public.politica_categorias_id_seq'::regclass);


--
-- Name: politicas_programacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion ALTER COLUMN id SET DEFAULT nextval('public.politicas_programacion_id_seq'::regclass);


--
-- Name: programacion id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion ALTER COLUMN id SET DEFAULT nextval('public.programacion_id_seq'::regclass);


--
-- Name: reglas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reglas ALTER COLUMN id SET DEFAULT nextval('public.reglas_id_seq'::regclass);


--
-- Name: relojes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes ALTER COLUMN id SET DEFAULT nextval('public.relojes_id_seq'::regclass);


--
-- Name: relojes_dia_modelo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes_dia_modelo ALTER COLUMN id SET DEFAULT nextval('public.relojes_dia_modelo_id_seq'::regclass);


--
-- Name: sets_reglas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sets_reglas ALTER COLUMN id SET DEFAULT nextval('public.sets_reglas_id_seq'::regclass);


--
-- Data for Name: canciones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.canciones (id, titulo, artista, album, duracion, categoria_id, conjunto_id, activa, created_at, updated_at) FROM stdin;
1	Canción 1	Artista 1	Album 1	180	1	1	t	2025-10-17 22:27:09.620597+00	\N
2	Canción 2	Artista 2	Album 2	200	2	1	t	2025-10-17 22:27:09.620597+00	\N
3	Canción 3	Artista 3	Album 3	160	1	2	t	2025-10-17 22:27:09.620597+00	\N
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias (id, nombre, descripcion, activa, created_at, updated_at) FROM stdin;
1	Pop	Música pop	t	2025-10-17 22:27:09.619881+00	\N
2	Rock	Música rock	t	2025-10-17 22:27:09.619881+00	\N
3	Clásica	Música clásica	t	2025-10-17 22:27:09.619881+00	\N
\.


--
-- Data for Name: conjuntos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conjuntos (id, nombre, descripcion, activo, created_at, updated_at) FROM stdin;
1	Conjunto 1	Descripción del conjunto 1	t	2025-10-17 22:27:09.620272+00	\N
2	Conjunto 2	Descripción del conjunto 2	t	2025-10-17 22:27:09.620272+00	\N
\.


--
-- Data for Name: cortes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cortes (id, nombre, descripcion, duracion, tipo, activo, observaciones, created_at, updated_at) FROM stdin;
1	Corte 1	Corte comercial 1	00:00:30	comercial	t	\N	2025-10-17 22:27:09.621192+00	\N
2	Corte 2	Corte comercial 2	00:00:15	comercial	t	\N	2025-10-17 22:27:09.621192+00	\N
3	Corte 3	Corte vacío	00:00:10	vacio	t	\N	2025-10-17 22:27:09.621192+00	\N
\.


--
-- Data for Name: dias_modelo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dias_modelo (id, habilitado, difusora, politica_id, clave, nombre, descripcion, lunes, martes, miercoles, jueves, viernes, sabado, domingo, created_at) FROM stdin;
1	t	XRAD	1	DIA_LABORAL	Día Laboral	Día modelo para días laborales	t	t	t	t	t	f	f	2025-10-17 22:27:07.979391+00
2	t	XRAD	1	FIN_SEMANA	Fin de Semana	Día modelo para fines de semana	f	f	f	f	f	t	t	2025-10-17 22:27:07.979391+00
3	t	XHPER	2	DIA_GENERAL	Día General	Día modelo general	t	t	t	t	t	t	t	2025-10-17 22:27:07.979391+00
5	t	XHPER	5	LABORAL	Día Laboral	Día laboral con programación de 6:00 a 18:00	t	t	t	t	t	f	f	2025-10-17 22:41:28.792018+00
6	t	XHPER	5	FIN_SEMANA	Fin de Semana	Fin de semana con programación de 8:00 a 22:00	f	f	f	f	f	t	t	2025-10-17 22:41:28.793338+00
7	t	XHPER	5	ESPECIAL	Día Especial	Día especial con programación de 10:00 a 20:00	t	t	t	t	t	t	t	2025-10-17 22:41:28.794042+00
\.


--
-- Data for Name: difusoras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.difusoras (id, siglas, nombre, slogan, orden, mascara_medidas, descripcion, activa, created_at) FROM stdin;
1	TEST1	Radio Test 1	La mejor música	1	MM:SS	\N	t	2025-10-17 22:27:09.61903+00
2	TEST2	Radio Test 2	Música para todos	2	MM:SS	\N	t	2025-10-17 22:27:09.61903+00
3	adasd	asdasd	asdasd	12	MM:SS	asdasd	t	2025-10-17 22:46:23.497422+00
4	XHPER	Radio XHPER	La radio que te conecta	4	MM:SS	Estación de radio XHPER	t	2025-10-21 01:53:58.150562+00
\.


--
-- Data for Name: eventos_reloj; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.eventos_reloj (id, reloj_id, numero, offset_value, desde_etm, desde_corte, offset_final, tipo, categoria, descripcion, duracion, numero_cancion, sin_categorias, id_media, categoria_media, tipo_etm, comando_das, caracteristica, twofer_valor, todas_categorias, categorias_usar, grupos_reglas_ignorar, clasificaciones_evento, caracteristica_especifica, valor_deseado, usar_todas_categorias, categorias_usar_especifica, grupos_reglas_ignorar_especifica, clasificaciones_evento_especifica, orden, created_at) FROM stdin;
1	1	001	00:00:00	00:00:00	00:00:00	00:00:00	ETM	ETM	Inicio del reloj	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	1	2025-10-17 22:27:07.974686+00
2	1	002	00:00:00	00:00:00	00:00:00	00:00:00	6	ETM	ETM 00	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	2	2025-10-17 22:27:07.974686+00
3	1	003	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	CAFE1	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	3	2025-10-17 22:27:07.974686+00
4	1	004	00:04:00	00:04:00	00:04:00	00:08:00	1	Canciones	GLORIA	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00
5	1	005	00:08:00	00:08:00	00:08:00	00:12:00	1	Canciones	HIMNO	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00
6	1	006	00:12:00	00:12:00	00:12:00	00:16:00	1	Canciones	MUSICA	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	6	2025-10-17 22:27:07.974686+00
7	1	007	00:16:00	00:16:00	00:16:00	00:20:00	1	Canciones	PROMO	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	7	2025-10-17 22:27:07.974686+00
8	1	008	00:20:00	00:20:00	00:20:00	00:24:00	1	Canciones	PROMOSLOS40	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	8	2025-10-17 22:27:07.974686+00
9	2	001	00:00:00	00:00:00	00:00:00	00:00:00	ETM	ETM	Inicio del reloj	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	1	2025-10-17 22:27:07.974686+00
10	2	002	00:00:00	00:00:00	00:00:00	00:00:00	6	ETM	ETM 00	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	2	2025-10-17 22:27:07.974686+00
11	2	003	00:00:00	00:00:00	00:00:00	00:06:00	2	Corte Comercial	CC 3M	00:06:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	3	2025-10-17 22:27:07.974686+00
12	2	004	00:06:00	00:06:00	00:06:00	00:12:00	1	Canciones	MUSICA_MAÑANA	00:06:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00
13	2	005	00:12:00	00:12:00	00:12:00	00:15:00	3	Nota Operador	NOTA_MAÑANA	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00
14	2	006	00:15:00	00:15:00	00:15:00	00:18:00	1	Canciones	DESPERTAR	00:03:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	6	2025-10-17 22:27:07.974686+00
15	3	001	00:00:00	00:00:00	00:00:00	00:00:00	ETM	ETM	Inicio del reloj	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	1	2025-10-17 22:27:07.974686+00
16	3	002	00:00:00	00:00:00	00:00:00	00:05:00	1	Canciones	ALMUERZO	00:05:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	2	2025-10-17 22:27:07.974686+00
17	3	003	00:05:00	00:05:00	00:05:00	00:10:00	2	Corte Comercial	CC 5M	00:05:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	3	2025-10-17 22:27:07.974686+00
18	3	004	00:10:00	00:10:00	00:10:00	00:12:00	4	Cartucho Fijo	HORA_EXACTA	00:02:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00
19	3	005	00:12:00	00:12:00	00:12:00	00:15:00	1	Canciones	MUSICA_TARDE	00:03:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00
40	5	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
41	5	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
42	5	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
43	5	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
44	5	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
45	5	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
46	5	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
47	5	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
48	5	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
49	5	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
50	5	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
51	5	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
52	5	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
53	5	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
54	5	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
55	5	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
56	5	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
57	5	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
58	5	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
59	5	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
60	6	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
61	6	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
62	6	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
63	6	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
64	6	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
65	6	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
66	6	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
67	6	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
68	6	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
69	6	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
70	6	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
71	6	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
72	6	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
73	6	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
74	6	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
75	6	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
76	6	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
77	6	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
78	6	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
79	6	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
80	7	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
81	7	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
82	7	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
83	7	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
84	7	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
85	7	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
86	7	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
87	7	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
88	7	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
89	7	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
90	7	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
91	7	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
92	7	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
93	7	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
94	7	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
95	7	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
96	7	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
97	7	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
98	7	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
99	7	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
100	8	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
101	8	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
102	8	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
103	8	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
104	8	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
105	8	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
106	8	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
107	8	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
108	8	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
109	8	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
110	8	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
111	8	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
112	8	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
113	8	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
114	8	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
115	8	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
116	8	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
117	8	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
118	8	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
119	8	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
120	9	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
121	9	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
122	9	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
123	9	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
124	9	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
125	9	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
126	9	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
127	9	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
128	9	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
129	9	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
130	9	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
131	9	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
132	9	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
133	9	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
134	9	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
135	9	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
136	9	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
137	9	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
138	9	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
139	9	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
140	10	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
141	10	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
142	10	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
143	10	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
144	10	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
145	10	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
146	10	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
147	10	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
148	10	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
149	10	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
150	10	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
151	10	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
152	10	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
153	10	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
154	10	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
155	10	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
156	10	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
157	10	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
158	10	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
159	10	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
160	11	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
161	11	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
162	11	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
163	11	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
164	11	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
165	11	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
166	11	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
167	11	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
168	11	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
169	11	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
170	11	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
171	11	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
172	11	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
173	11	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
174	11	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
175	11	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
176	11	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
177	11	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
178	11	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
179	11	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
180	12	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
181	12	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
182	12	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
183	12	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
184	12	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
185	12	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
186	12	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
187	12	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
188	12	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
189	12	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
190	12	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
191	12	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
192	12	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
193	12	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
194	12	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
195	12	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
196	12	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
197	12	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
198	12	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
199	12	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
200	13	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
201	13	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
202	13	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
203	13	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
204	13	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
205	13	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
206	13	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
207	13	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
208	13	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
209	13	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
210	13	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
211	13	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
212	13	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
213	13	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
214	13	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
215	13	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
216	13	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
217	13	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
218	13	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
219	13	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
220	14	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
221	14	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
222	14	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
223	14	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
224	14	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
225	14	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
226	14	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
227	14	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
228	14	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
229	14	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
230	14	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
231	14	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
232	14	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
233	14	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
234	14	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
235	14	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
236	14	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
237	14	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
238	14	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
239	14	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
240	15	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
241	15	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
242	15	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
243	15	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
244	15	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
245	15	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
246	15	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
247	15	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
248	15	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
249	15	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
250	15	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
251	15	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
252	15	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
253	15	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
254	15	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
255	15	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
256	15	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
257	15	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
258	15	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
259	15	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
260	16	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
261	16	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
262	16	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
263	16	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
264	16	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
265	16	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
266	16	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
267	16	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
268	16	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
269	16	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
270	16	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
271	16	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
272	16	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
273	16	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
274	16	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
275	16	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
276	16	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
277	16	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
278	16	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
279	16	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
280	17	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
281	17	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
282	17	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
283	17	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
284	17	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
285	17	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
286	17	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
287	17	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
288	17	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
289	17	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
290	17	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
291	17	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
292	17	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
293	17	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
294	17	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
295	17	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
296	17	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
297	17	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
298	17	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
299	17	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
300	18	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
301	18	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
302	18	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
303	18	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
304	18	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
305	18	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
306	18	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
307	18	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
308	18	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
309	18	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
310	18	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
311	18	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
312	18	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
313	18	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
314	18	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
315	18	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
316	18	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
317	18	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
318	18	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
319	18	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
320	19	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
321	19	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
322	19	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
323	19	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
324	19	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
325	19	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
326	19	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
327	19	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
328	19	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
329	19	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
330	19	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
331	19	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
332	19	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
333	19	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
334	19	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
335	19	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
336	19	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
337	19	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
338	19	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
339	19	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
340	20	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
341	20	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
342	20	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
513	28	014	00:46:13	00:00:00	00:46:13	00:50:13	1	Canciones	Pop	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.743398+00
343	20	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
344	20	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
345	20	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
346	20	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
347	20	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
348	20	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
349	20	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
350	20	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
351	20	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
352	20	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
353	20	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
354	20	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
355	20	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
356	20	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
357	20	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
358	20	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
359	20	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
360	21	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
361	21	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
362	21	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
363	21	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
364	21	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
365	21	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
366	21	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
367	21	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
368	21	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
369	21	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
370	21	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
371	21	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
372	21	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
373	21	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
374	21	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
375	21	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
376	21	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
377	21	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
378	21	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
379	21	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
380	22	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
381	22	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
382	22	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
383	22	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
384	22	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
385	22	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
386	22	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
387	22	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
388	22	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
389	22	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
390	22	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
391	22	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
392	22	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
393	22	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
394	22	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
395	22	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
396	22	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
397	22	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
398	22	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
514	28	015	00:50:14	00:00:00	00:50:14	00:54:14	1	Canciones	Rock	00:04:00	009	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.746501+00
399	22	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
400	23	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
401	23	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
402	23	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
403	23	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
404	23	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
405	23	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
406	23	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
407	23	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
408	23	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
409	23	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
410	23	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
411	23	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
412	23	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
413	23	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
414	23	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
415	23	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
416	23	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
417	23	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
418	23	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
419	23	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
420	24	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
421	24	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
422	24	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
423	24	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
424	24	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
425	24	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
426	24	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
427	24	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
428	24	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
429	24	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
430	24	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
431	24	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
432	24	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
433	24	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
434	24	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
435	24	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
436	24	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
437	24	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
438	24	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
439	24	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
440	25	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
441	25	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
442	25	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
443	25	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
444	25	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
445	25	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
446	25	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
447	25	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
448	25	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
449	25	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
450	25	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
451	25	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
452	25	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
453	25	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
454	25	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
455	25	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
456	25	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
457	25	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
458	25	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
459	25	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
460	26	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
461	26	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
462	26	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
463	26	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
464	26	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
465	26	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
466	26	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
467	26	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
468	26	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
469	26	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
470	26	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
471	26	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
472	26	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
473	26	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
474	26	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
475	26	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
476	26	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
477	26	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
478	26	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
479	26	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
480	27	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
481	27	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
482	27	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
483	27	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
484	27	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
485	27	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
486	27	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
487	27	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
488	27	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
489	27	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
490	27	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
491	27	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
492	27	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
493	27	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
494	27	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
495	27	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
496	27	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
497	27	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
498	27	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
499	27	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00
500	28	001	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Jazz	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.692715+00
501	28	002	00:04:01	00:00:00	00:04:01	00:08:01	1	Canciones	Pop	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.701609+00
502	28	003	00:08:02	00:00:00	00:08:02	00:12:02	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.705894+00
503	28	004	00:12:03	00:00:00	00:12:03	00:15:03	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.709898+00
504	28	005	00:15:04	00:00:00	00:15:04	00:18:04	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.713518+00
505	28	006	00:18:05	00:00:00	00:18:05	00:21:05	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.717107+00
506	28	007	00:21:06	00:00:00	00:21:06	00:24:06	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.720199+00
507	28	008	00:24:07	00:00:00	00:24:07	00:27:07	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.723625+00
508	28	009	00:27:08	00:00:00	00:27:08	00:30:08	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.726836+00
509	28	010	00:30:09	00:00:00	00:30:09	00:34:09	1	Canciones	Rock	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.729817+00
510	28	011	00:34:10	00:00:00	00:34:10	00:38:10	1	Canciones	Rock	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.733186+00
511	28	012	00:38:11	00:00:00	00:38:11	00:42:11	1	Canciones	Rock	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.736398+00
512	28	013	00:42:12	00:00:00	00:42:12	00:46:12	1	Canciones	Rock	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.740032+00
515	28	016	00:54:15	00:00:00	00:54:15	00:58:15	1	Canciones	Rock	00:04:00	010	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.749411+00
516	28	017	00:58:16	00:00:00	00:58:16	01:02:16	1	Canciones	Rock	00:04:00	011	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.752293+00
517	4	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.010958+00
518	4	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.015381+00
519	4	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.019128+00
520	4	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.022475+00
521	4	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.025819+00
522	4	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.029012+00
523	4	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.032203+00
524	4	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.036899+00
525	4	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.0413+00
526	4	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.045885+00
527	4	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.050291+00
528	4	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.054643+00
529	4	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.058939+00
530	4	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.063447+00
531	4	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.067663+00
532	4	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.072089+00
533	4	017	00:00:01	00:00:00	00:00:01	00:03:01	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.076354+00
534	4	018	00:03:02	00:00:00	00:03:02	00:06:02	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.080648+00
535	4	019	00:06:03	00:00:00	00:06:03	00:09:03	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.084937+00
536	4	020	00:09:04	00:00:00	00:09:04	00:12:04	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.089222+00
537	30	001	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Pop	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.905392+00
538	30	002	00:04:01	00:00:00	00:04:01	00:08:01	1	Canciones	Rock	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.915297+00
539	30	003	00:08:02	00:00:00	00:08:02	00:12:02	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.921539+00
540	30	004	00:12:03	00:00:00	00:12:03	00:16:03	1	Canciones	Rock	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.925784+00
541	30	005	00:16:04	00:00:00	00:16:04	00:19:04	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.929887+00
542	30	006	00:19:05	00:00:00	00:19:05	00:22:05	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.933606+00
543	30	007	00:22:06	00:00:00	00:22:06	00:25:06	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.937373+00
544	30	008	00:25:07	00:00:00	00:25:07	00:28:07	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.941115+00
545	30	009	00:28:08	00:00:00	00:28:08	00:31:08	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.944315+00
546	30	010	00:31:09	00:00:00	00:31:09	00:34:09	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.947898+00
547	30	011	00:34:10	00:00:00	00:34:10	00:38:10	1	Canciones	Pop	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.950889+00
548	30	012	00:38:11	00:00:00	00:38:11	00:42:11	1	Canciones	Pop	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.95411+00
549	30	013	00:42:12	00:00:00	00:42:12	00:45:12	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.957363+00
550	30	014	00:45:13	00:00:00	00:45:13	00:48:13	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.960378+00
551	30	015	00:48:14	00:00:00	00:48:14	00:52:14	1	Canciones	Rock	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.963298+00
552	30	016	00:52:15	00:00:00	00:52:15	00:56:15	1	Canciones	Rock	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.966103+00
553	30	017	00:56:16	00:00:00	00:56:16	00:59:16	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.968864+00
554	30	018	00:59:17	00:00:00	00:59:17	01:02:17	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.971875+00
\.


--
-- Data for Name: orden_asignacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orden_asignacion (id, politica_id, nombre, descripcion, tipo, parametros, habilitado, orden, created_at) FROM stdin;
1	1	Orden por Categoría	Asignar por categoría musical	categoria	{"prioridad": ["pop", "rock", "balada"]}	t	1	2025-10-17 22:27:07.985125+00
2	1	Orden por Duración	Asignar por duración	duracion	{"rango": [180, 240]}	t	2	2025-10-17 22:27:07.985125+00
3	2	Orden General	Orden general de asignación	general	{"criterio": "aleatorio"}	t	1	2025-10-17 22:27:07.985125+00
\.


--
-- Data for Name: politica_categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.politica_categorias (id, politica_id, categoria_nombre) FROM stdin;
1	1	Pop
2	1	Rock
3	1	Jazz
4	5	Pop
5	5	Rock
6	5	Jazz
\.


--
-- Data for Name: politicas_programacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.politicas_programacion (id, clave, difusora, habilitada, guid, nombre, descripcion, alta, modificacion, created_at, categorias_seleccionadas, updated_at, lunes, martes, miercoles, jueves, viernes, sabado, domingo) FROM stdin;
3	GRAL_XHGR	TODAS	t	{C3C4787D-6EF0-4B3D-91E6-ACAE8F229F1C}	GRAL_XHGR	Política específica para XHGR	29/03/2019 04:13:45 p. m. (Administrator)	13/08/2025 04:40:50 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	\N	2025-10-21 01:46:07.765569+00	\N	\N	\N	\N	\N	\N	\N
4	GRAL_XHOZ	TEST2	t	{2FE14516-E959-4D34-A213-46A5152B4784}	AMOR 91.7	Política para AMOR 91.7	01/02/2022 11:05:55 a. m. (Administrator)	13/08/2025 04:46:49 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	\N	2025-10-21 01:46:11.129607+00	\N	\N	\N	\N	\N	\N	\N
1	DIARIO_UPDATED	adasd	t	{F0268715-8A1B-4CCA-9790-913E3810874C}	DIARIO	Política de programación diaria	28/12/2017 12:44:36 p. m. (Administrator)	18/01/2022 02:08:20 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	\N	2025-10-21 01:46:14.91335+00	\N	\N	\N	\N	\N	\N	\N
2	asdasd	XHPER	t	{9D45EB0E-D2AB-4113-AD30-B628B18482CE}	Política General	Política general de programación	28/12/2017 06:16:09 p. m. (Administrator)	13/01/2025 04:20:22 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	\N	2025-10-21 02:40:17.057267+00	3	3	3	3	3	3	3
5	POL_TEST	XHPER	t	\N	Política de Prueba	Política para pruebas de generación	\N	\N	2025-10-17 22:27:11.199335+00	\N	2025-10-21 02:49:51.784975+00	6	7	\N	7	\N	\N	\N
\.


--
-- Data for Name: programacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.programacion (id, mc, numero_reloj, hora_real, hora_transmision, duracion_real, tipo, hora_planeada, duracion_planeada, categoria, id_media, descripcion, lenguaje, interprete, disco, sello_discografico, bpm, "año", difusora, politica_id, fecha, reloj_id, evento_reloj_id, dia_modelo_id, created_at, updated_at) FROM stdin;
1811	t	R02	00:00:00	00:00:00	00:02:40	cancion	00:00:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	60	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1812	t	R02	00:02:40	00:02:40	00:03:20	cancion	00:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	61	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1813	t	R02	00:06:00	00:06:00	00:03:20	cancion	00:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	62	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1814	t	R02	00:09:20	00:09:20	00:03:00	cancion	00:09:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	63	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1815	t	R02	00:12:20	00:12:20	00:03:20	cancion	00:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	64	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1816	t	R02	00:15:40	00:15:40	00:02:40	cancion	00:15:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	65	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1817	t	R02	00:18:20	00:18:20	00:03:00	cancion	00:18:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	66	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1818	t	R02	00:21:20	00:21:20	00:03:20	cancion	00:21:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	67	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1819	t	R02	00:24:40	00:24:40	00:03:00	cancion	00:24:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	68	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1820	t	R02	00:27:40	00:27:40	00:03:20	cancion	00:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	69	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1821	t	R02	00:31:00	00:31:00	00:03:20	cancion	00:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	70	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1822	t	R02	00:34:20	00:34:20	00:02:40	cancion	00:34:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	71	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1823	t	R02	00:37:00	00:37:00	00:03:20	cancion	00:37:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	72	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1824	t	R02	00:40:20	00:40:20	00:02:40	cancion	00:40:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	73	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1825	t	R02	00:43:00	00:43:00	00:03:20	cancion	00:43:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	6	74	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1826	t	R02	00:46:20	00:46:20	00:03:00	cancion	00:46:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	75	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1827	t	R02	00:49:20	00:49:20	00:03:00	cancion	00:49:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	76	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1828	t	R02	00:52:20	00:52:20	00:02:40	cancion	00:52:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	77	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1829	t	R02	00:55:00	00:55:00	00:03:00	cancion	00:55:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	6	78	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1830	t	R02	00:58:00	00:58:00	00:02:40	cancion	00:58:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	6	79	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1831	t	R03	01:00:40	01:00:40	00:03:00	cancion	01:00:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	80	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1832	t	R03	01:03:40	01:03:40	00:02:40	cancion	01:03:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	81	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1833	t	R03	01:06:20	01:06:20	00:02:40	cancion	01:06:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	82	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1834	t	R03	01:09:00	01:09:00	00:03:00	cancion	01:09:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	83	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1835	t	R03	01:12:00	01:12:00	00:03:00	cancion	01:12:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	84	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1836	t	R03	01:15:00	01:15:00	00:02:40	cancion	01:15:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	85	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1837	t	R03	01:17:40	01:17:40	00:03:00	cancion	01:17:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	86	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1838	t	R03	01:20:40	01:20:40	00:03:20	cancion	01:20:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	87	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1839	t	R03	01:24:00	01:24:00	00:02:40	cancion	01:24:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	88	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1840	t	R03	01:26:40	01:26:40	00:03:00	cancion	01:26:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	89	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1841	t	R03	01:29:40	01:29:40	00:02:40	cancion	01:29:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	90	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1842	t	R03	01:32:20	01:32:20	00:03:20	cancion	01:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	91	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1843	t	R03	01:35:40	01:35:40	00:02:40	cancion	01:35:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	7	92	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1844	t	R03	01:38:20	01:38:20	00:03:20	cancion	01:38:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	93	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1845	t	R03	01:41:40	01:41:40	00:03:00	cancion	01:41:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	7	94	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1846	t	R03	01:44:40	01:44:40	00:03:20	cancion	01:44:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	95	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1847	t	R03	01:48:00	01:48:00	00:03:20	cancion	01:48:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	96	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1848	t	R03	01:51:20	01:51:20	00:03:20	cancion	01:51:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	97	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1849	t	R03	01:54:40	01:54:40	00:03:20	cancion	01:54:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	98	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1850	t	R03	01:58:00	01:58:00	00:03:20	cancion	01:58:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	7	99	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1851	t	R04	02:01:20	02:01:20	00:03:20	cancion	02:01:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	100	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1852	t	R04	02:04:40	02:04:40	00:03:00	cancion	02:04:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	8	101	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1853	t	R04	02:07:40	02:07:40	00:03:20	cancion	02:07:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	102	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1854	t	R04	02:11:00	02:11:00	00:02:40	cancion	02:11:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	8	103	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1855	t	R04	02:13:40	02:13:40	00:03:20	cancion	02:13:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	104	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1856	t	R04	02:17:00	02:17:00	00:02:40	cancion	02:17:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	8	105	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1857	t	R04	02:19:40	02:19:40	00:03:00	cancion	02:19:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	8	106	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1858	t	R04	02:22:40	02:22:40	00:03:00	cancion	02:22:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	8	107	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1859	t	R04	02:25:40	02:25:40	00:02:40	cancion	02:25:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	8	108	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1860	t	R04	02:28:20	02:28:20	00:03:20	cancion	02:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	109	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1861	t	R04	02:31:40	02:31:40	00:02:40	cancion	02:31:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	8	110	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1862	t	R04	02:34:20	02:34:20	00:03:00	cancion	02:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	8	111	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1863	t	R04	02:37:20	02:37:20	00:03:20	cancion	02:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	112	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1864	t	R04	02:40:40	02:40:40	00:03:20	cancion	02:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	113	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1865	t	R04	02:44:00	02:44:00	00:03:20	cancion	02:44:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	114	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1866	t	R04	02:47:20	02:47:20	00:02:40	cancion	02:47:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	8	115	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1867	t	R04	02:50:00	02:50:00	00:03:20	cancion	02:50:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	116	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1868	t	R04	02:53:20	02:53:20	00:03:00	cancion	02:53:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	8	117	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1869	t	R04	02:56:20	02:56:20	00:03:20	cancion	02:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	118	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1870	t	R04	02:59:40	02:59:40	00:03:20	cancion	02:59:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	8	119	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1871	t	R05	03:03:00	03:03:00	00:02:40	cancion	03:03:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	9	120	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1872	t	R05	03:05:40	03:05:40	00:03:20	cancion	03:05:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	121	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1873	t	R05	03:09:00	03:09:00	00:03:00	cancion	03:09:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	9	122	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1874	t	R05	03:12:00	03:12:00	00:03:20	cancion	03:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	123	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1875	t	R05	03:15:20	03:15:20	00:03:20	cancion	03:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	124	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1876	t	R05	03:18:40	03:18:40	00:03:20	cancion	03:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	125	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1877	t	R05	03:22:00	03:22:00	00:03:20	cancion	03:22:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	126	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1878	t	R05	03:25:20	03:25:20	00:03:20	cancion	03:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	127	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1879	t	R05	03:28:40	03:28:40	00:03:00	cancion	03:28:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	9	128	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1880	t	R05	03:31:40	03:31:40	00:02:40	cancion	03:31:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	9	129	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1881	t	R05	03:34:20	03:34:20	00:03:00	cancion	03:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	9	130	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1882	t	R05	03:37:20	03:37:20	00:02:40	cancion	03:37:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	9	131	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1883	t	R05	03:40:00	03:40:00	00:03:20	cancion	03:40:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	132	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1884	t	R05	03:43:20	03:43:20	00:03:20	cancion	03:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	133	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1885	t	R05	03:46:40	03:46:40	00:03:20	cancion	03:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	134	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1886	t	R05	03:50:00	03:50:00	00:03:20	cancion	03:50:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	135	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1887	t	R05	03:53:20	03:53:20	00:03:00	cancion	03:53:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	9	136	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1888	t	R05	03:56:20	03:56:20	00:03:20	cancion	03:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	137	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1889	t	R05	03:59:40	03:59:40	00:02:40	cancion	03:59:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	9	138	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1890	t	R05	04:02:20	04:02:20	00:03:20	cancion	04:02:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	9	139	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1891	t	R06	04:05:40	04:05:40	00:03:20	cancion	04:05:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	140	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1892	t	R06	04:09:00	04:09:00	00:03:00	cancion	04:09:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	10	141	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1893	t	R06	04:12:00	04:12:00	00:03:20	cancion	04:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	142	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1894	t	R06	04:15:20	04:15:20	00:03:20	cancion	04:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	143	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1895	t	R06	04:18:40	04:18:40	00:03:20	cancion	04:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	144	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1896	t	R06	04:22:00	04:22:00	00:02:40	cancion	04:22:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	10	145	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1897	t	R06	04:24:40	04:24:40	00:03:00	cancion	04:24:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	10	146	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1898	t	R06	04:27:40	04:27:40	00:03:20	cancion	04:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	147	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1899	t	R06	04:31:00	04:31:00	00:03:20	cancion	04:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	148	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1900	t	R06	04:34:20	04:34:20	00:03:20	cancion	04:34:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	149	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1901	t	R06	04:37:40	04:37:40	00:02:40	cancion	04:37:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	10	150	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1902	t	R06	04:40:20	04:40:20	00:02:40	cancion	04:40:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	10	151	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1903	t	R06	04:43:00	04:43:00	00:03:20	cancion	04:43:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	152	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1904	t	R06	04:46:20	04:46:20	00:03:20	cancion	04:46:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	153	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1905	t	R06	04:49:40	04:49:40	00:03:20	cancion	04:49:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	154	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1906	t	R06	04:53:00	04:53:00	00:03:20	cancion	04:53:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	155	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1907	t	R06	04:56:20	04:56:20	00:03:20	cancion	04:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	156	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1908	t	R06	04:59:40	04:59:40	00:03:20	cancion	04:59:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	10	157	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1909	t	R06	05:03:00	05:03:00	00:03:00	cancion	05:03:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	10	158	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1910	t	R07	05:06:00	05:06:00	00:03:20	cancion	05:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	160	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1911	t	R07	05:09:20	05:09:20	00:03:20	cancion	05:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	161	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1912	t	R07	05:12:40	05:12:40	00:03:20	cancion	05:12:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	162	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1913	t	R07	05:16:00	05:16:00	00:03:00	cancion	05:16:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	11	163	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1914	t	R07	05:19:00	05:19:00	00:02:40	cancion	05:19:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	164	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1915	t	R07	05:21:40	05:21:40	00:03:20	cancion	05:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	165	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1916	t	R07	05:25:00	05:25:00	00:03:00	cancion	05:25:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	11	166	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1917	t	R07	05:28:00	05:28:00	00:02:40	cancion	05:28:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	167	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1918	t	R07	05:30:40	05:30:40	00:03:00	cancion	05:30:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	11	168	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1919	t	R07	05:33:40	05:33:40	00:03:20	cancion	05:33:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	169	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1920	t	R07	05:37:00	05:37:00	00:02:40	cancion	05:37:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	170	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1921	t	R07	05:39:40	05:39:40	00:02:40	cancion	05:39:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	171	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1922	t	R07	05:42:20	05:42:20	00:03:00	cancion	05:42:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	11	172	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1923	t	R07	05:45:20	05:45:20	00:03:20	cancion	05:45:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	173	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1924	t	R07	05:48:40	05:48:40	00:02:40	cancion	05:48:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	174	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1925	t	R07	05:51:20	05:51:20	00:03:00	cancion	05:51:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	11	175	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1926	t	R07	05:54:20	05:54:20	00:03:20	cancion	05:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	176	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1927	t	R07	05:57:40	05:57:40	00:03:20	cancion	05:57:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	177	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1928	t	R07	06:01:00	06:01:00	00:03:20	cancion	06:01:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	11	178	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1929	t	R07	06:04:20	06:04:20	00:02:40	cancion	06:04:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	11	179	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1930	t	R08	06:07:00	06:07:00	00:03:00	cancion	06:07:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	180	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1931	t	R08	06:10:00	06:10:00	00:02:40	cancion	06:10:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	181	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1932	t	R08	06:12:40	06:12:40	00:03:00	cancion	06:12:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	182	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1933	t	R08	06:15:40	06:15:40	00:02:40	cancion	06:15:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	183	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1934	t	R08	06:18:20	06:18:20	00:03:20	cancion	06:18:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	184	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1935	t	R08	06:21:40	06:21:40	00:03:20	cancion	06:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	185	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1936	t	R08	06:25:00	06:25:00	00:03:00	cancion	06:25:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	186	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1937	t	R08	06:28:00	06:28:00	00:02:40	cancion	06:28:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	187	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1938	t	R08	06:30:40	06:30:40	00:03:00	cancion	06:30:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	188	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1939	t	R08	06:33:40	06:33:40	00:03:20	cancion	06:33:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	189	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1940	t	R08	06:37:00	06:37:00	00:03:00	cancion	06:37:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	190	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1941	t	R08	06:40:00	06:40:00	00:02:40	cancion	06:40:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	191	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1942	t	R08	06:42:40	06:42:40	00:03:20	cancion	06:42:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	192	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1943	t	R08	06:46:00	06:46:00	00:03:00	cancion	06:46:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	193	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1944	t	R08	06:49:00	06:49:00	00:02:40	cancion	06:49:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	194	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1945	t	R08	06:51:40	06:51:40	00:03:20	cancion	06:51:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	195	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1946	t	R08	06:55:00	06:55:00	00:02:40	cancion	06:55:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	196	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1947	t	R08	06:57:40	06:57:40	00:03:00	cancion	06:57:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	12	197	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1948	t	R08	07:00:40	07:00:40	00:03:20	cancion	07:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	12	198	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1949	t	R08	07:04:00	07:04:00	00:02:40	cancion	07:04:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	12	199	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1950	t	R09	07:06:40	07:06:40	00:03:00	cancion	07:06:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	200	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1951	t	R09	07:09:40	07:09:40	00:03:20	cancion	07:09:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	201	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1952	t	R09	07:13:00	07:13:00	00:02:40	cancion	07:13:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	202	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1953	t	R09	07:15:40	07:15:40	00:03:00	cancion	07:15:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	203	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1954	t	R09	07:18:40	07:18:40	00:03:20	cancion	07:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	204	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1955	t	R09	07:22:00	07:22:00	00:02:40	cancion	07:22:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	205	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1956	t	R09	07:24:40	07:24:40	00:03:00	cancion	07:24:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	206	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1957	t	R09	07:27:40	07:27:40	00:03:20	cancion	07:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	207	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1958	t	R09	07:31:00	07:31:00	00:03:20	cancion	07:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	208	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1959	t	R09	07:34:20	07:34:20	00:03:00	cancion	07:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	209	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1960	t	R09	07:37:20	07:37:20	00:02:40	cancion	07:37:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	210	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1961	t	R09	07:40:00	07:40:00	00:03:00	cancion	07:40:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	211	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1962	t	R09	07:43:00	07:43:00	00:02:40	cancion	07:43:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	212	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1963	t	R09	07:45:40	07:45:40	00:03:20	cancion	07:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	213	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1964	t	R09	07:49:00	07:49:00	00:02:40	cancion	07:49:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	214	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1965	t	R09	07:51:40	07:51:40	00:03:20	cancion	07:51:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	215	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1966	t	R09	07:55:00	07:55:00	00:03:20	cancion	07:55:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	13	216	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1967	t	R09	07:58:20	07:58:20	00:03:00	cancion	07:58:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	217	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1968	t	R09	08:01:20	08:01:20	00:03:00	cancion	08:01:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	13	218	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1969	t	R09	08:04:20	08:04:20	00:02:40	cancion	08:04:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	13	219	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1970	t	R10	08:07:00	08:07:00	00:03:00	cancion	08:07:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	14	220	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1971	t	R10	08:10:00	08:10:00	00:03:20	cancion	08:10:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	221	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1972	t	R10	08:13:20	08:13:20	00:03:20	cancion	08:13:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	222	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1973	t	R10	08:16:40	08:16:40	00:03:20	cancion	08:16:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	223	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1974	t	R10	08:20:00	08:20:00	00:03:20	cancion	08:20:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	224	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1975	t	R10	08:23:20	08:23:20	00:03:20	cancion	08:23:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	225	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1976	t	R10	08:26:40	08:26:40	00:03:20	cancion	08:26:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	226	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1977	t	R10	08:30:00	08:30:00	00:03:20	cancion	08:30:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	227	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1978	t	R10	08:33:20	08:33:20	00:02:40	cancion	08:33:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	14	228	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1979	t	R10	08:36:00	08:36:00	00:03:20	cancion	08:36:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	229	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1980	t	R10	08:39:20	08:39:20	00:03:00	cancion	08:39:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	14	230	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1981	t	R10	08:42:20	08:42:20	00:03:20	cancion	08:42:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	231	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1982	t	R10	08:45:40	08:45:40	00:03:20	cancion	08:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	232	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1983	t	R10	08:49:00	08:49:00	00:02:40	cancion	08:49:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	14	233	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1984	t	R10	08:51:40	08:51:40	00:03:00	cancion	08:51:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	14	234	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1985	t	R10	08:54:40	08:54:40	00:03:20	cancion	08:54:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	235	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1986	t	R10	08:58:00	08:58:00	00:03:20	cancion	08:58:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	236	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1987	t	R10	09:01:20	09:01:20	00:03:20	cancion	09:01:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	14	237	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1988	t	R10	09:04:40	09:04:40	00:02:40	cancion	09:04:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	14	238	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1989	t	R11	09:07:20	09:07:20	00:03:00	cancion	09:07:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	240	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1990	t	R11	09:10:20	09:10:20	00:03:20	cancion	09:10:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	241	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1991	t	R11	09:13:40	09:13:40	00:03:20	cancion	09:13:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	242	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1992	t	R11	09:17:00	09:17:00	00:02:40	cancion	09:17:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	243	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1993	t	R11	09:19:40	09:19:40	00:03:20	cancion	09:19:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	244	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1994	t	R11	09:23:00	09:23:00	00:03:20	cancion	09:23:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	245	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1995	t	R11	09:26:20	09:26:20	00:02:40	cancion	09:26:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	246	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1996	t	R11	09:29:00	09:29:00	00:03:00	cancion	09:29:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	247	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1997	t	R11	09:32:00	09:32:00	00:03:20	cancion	09:32:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	248	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1998	t	R11	09:35:20	09:35:20	00:03:20	cancion	09:35:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	249	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
1999	t	R11	09:38:40	09:38:40	00:02:40	cancion	09:38:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	250	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2000	t	R11	09:41:20	09:41:20	00:03:00	cancion	09:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	251	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2001	t	R11	09:44:20	09:44:20	00:02:40	cancion	09:44:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	252	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2002	t	R11	09:47:00	09:47:00	00:03:00	cancion	09:47:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	253	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2003	t	R11	09:50:00	09:50:00	00:02:40	cancion	09:50:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	254	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2004	t	R11	09:52:40	09:52:40	00:03:20	cancion	09:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	255	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2005	t	R11	09:56:00	09:56:00	00:03:00	cancion	09:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	256	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2006	t	R11	09:59:00	09:59:00	00:02:40	cancion	09:59:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	15	257	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2007	t	R11	10:01:40	10:01:40	00:03:20	cancion	10:01:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	15	258	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2008	t	R11	10:05:00	10:05:00	00:03:00	cancion	10:05:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	15	259	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2009	t	R12	10:08:00	10:08:00	00:03:20	cancion	10:08:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	260	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2010	t	R12	10:11:20	10:11:20	00:03:20	cancion	10:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	261	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2011	t	R12	10:14:40	10:14:40	00:02:40	cancion	10:14:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	262	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2012	t	R12	10:17:20	10:17:20	00:03:00	cancion	10:17:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	263	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2013	t	R12	10:20:20	10:20:20	00:03:00	cancion	10:20:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	264	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2014	t	R12	10:23:20	10:23:20	00:03:20	cancion	10:23:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	265	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2015	t	R12	10:26:40	10:26:40	00:02:40	cancion	10:26:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	266	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2016	t	R12	10:29:20	10:29:20	00:02:40	cancion	10:29:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	267	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2017	t	R12	10:32:00	10:32:00	00:03:20	cancion	10:32:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	268	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2018	t	R12	10:35:20	10:35:20	00:03:00	cancion	10:35:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	269	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2019	t	R12	10:38:20	10:38:20	00:03:00	cancion	10:38:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	270	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2020	t	R12	10:41:20	10:41:20	00:03:20	cancion	10:41:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	271	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2021	t	R12	10:44:40	10:44:40	00:02:40	cancion	10:44:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	272	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2022	t	R12	10:47:20	10:47:20	00:02:40	cancion	10:47:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	273	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2023	t	R12	10:50:00	10:50:00	00:03:00	cancion	10:50:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	274	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2024	t	R12	10:53:00	10:53:00	00:03:20	cancion	10:53:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	275	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2025	t	R12	10:56:20	10:56:20	00:03:00	cancion	10:56:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	16	276	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2026	t	R12	10:59:20	10:59:20	00:03:20	cancion	10:59:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	277	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2027	t	R12	11:02:40	11:02:40	00:02:40	cancion	11:02:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	16	278	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2028	t	R12	11:05:20	11:05:20	00:03:20	cancion	11:05:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	16	279	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2029	t	R13	11:08:40	11:08:40	00:02:40	cancion	11:08:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	280	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2030	t	R13	11:11:20	11:11:20	00:03:20	cancion	11:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	281	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2031	t	R13	11:14:40	11:14:40	00:03:00	cancion	11:14:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	282	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2032	t	R13	11:17:40	11:17:40	00:03:00	cancion	11:17:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	283	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2033	t	R13	11:20:40	11:20:40	00:02:40	cancion	11:20:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	284	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2034	t	R13	11:23:20	11:23:20	00:03:00	cancion	11:23:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	285	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2035	t	R13	11:26:20	11:26:20	00:02:40	cancion	11:26:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	286	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2036	t	R13	11:29:00	11:29:00	00:02:40	cancion	11:29:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	287	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2037	t	R13	11:31:40	11:31:40	00:03:00	cancion	11:31:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	288	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2038	t	R13	11:34:40	11:34:40	00:03:20	cancion	11:34:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	289	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2039	t	R13	11:38:00	11:38:00	00:02:40	cancion	11:38:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	290	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2040	t	R13	11:40:40	11:40:40	00:03:20	cancion	11:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	291	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2041	t	R13	11:44:00	11:44:00	00:03:20	cancion	11:44:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	292	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2042	t	R13	11:47:20	11:47:20	00:03:00	cancion	11:47:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	293	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2043	t	R13	11:50:20	11:50:20	00:02:40	cancion	11:50:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	294	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2044	t	R13	11:53:00	11:53:00	00:03:00	cancion	11:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	295	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2045	t	R13	11:56:00	11:56:00	00:02:40	cancion	11:56:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	17	296	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2046	t	R13	11:58:40	11:58:40	00:03:20	cancion	11:58:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	297	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2047	t	R13	12:02:00	12:02:00	00:03:20	cancion	12:02:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	17	298	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2048	t	R13	12:05:20	12:05:20	00:03:00	cancion	12:05:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	17	299	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2049	t	R14	12:08:20	12:08:20	00:02:40	cancion	12:08:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	300	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2050	t	R14	12:11:00	12:11:00	00:03:20	cancion	12:11:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	301	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2051	t	R14	12:14:20	12:14:20	00:03:00	cancion	12:14:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	302	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2052	t	R14	12:17:20	12:17:20	00:03:20	cancion	12:17:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	303	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2053	t	R14	12:20:40	12:20:40	00:03:20	cancion	12:20:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	304	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2054	t	R14	12:24:00	12:24:00	00:02:40	cancion	12:24:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	305	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2055	t	R14	12:26:40	12:26:40	00:03:20	cancion	12:26:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	306	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2056	t	R14	12:30:00	12:30:00	00:03:00	cancion	12:30:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	307	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2057	t	R14	12:33:00	12:33:00	00:03:00	cancion	12:33:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	308	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2058	t	R14	12:36:00	12:36:00	00:03:20	cancion	12:36:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	309	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2059	t	R14	12:39:20	12:39:20	00:02:40	cancion	12:39:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	310	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2060	t	R14	12:42:00	12:42:00	00:02:40	cancion	12:42:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	311	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2061	t	R14	12:44:40	12:44:40	00:03:00	cancion	12:44:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	312	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2062	t	R14	12:47:40	12:47:40	00:03:20	cancion	12:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	313	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2063	t	R14	12:51:00	12:51:00	00:02:40	cancion	12:51:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	314	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2064	t	R14	12:53:40	12:53:40	00:03:20	cancion	12:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	315	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2065	t	R14	12:57:00	12:57:00	00:03:20	cancion	12:57:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-20	18	316	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2066	t	R14	13:00:20	13:00:20	00:03:00	cancion	13:00:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	317	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2067	t	R14	13:03:20	13:03:20	00:02:40	cancion	13:03:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-20	18	318	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2068	t	R14	13:06:00	13:06:00	00:03:00	cancion	13:06:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-20	18	319	5	2025-10-20 12:41:03.531784+00	2025-10-20 12:41:03.531784+00
2069	t	R06	00:00:00	00:00:00	00:03:20	cancion	00:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	140	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2070	t	R06	00:03:20	00:03:20	00:03:00	cancion	00:03:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	10	141	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2071	t	R06	00:06:20	00:06:20	00:03:20	cancion	00:06:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	142	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2072	t	R06	00:09:40	00:09:40	00:02:40	cancion	00:09:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	10	143	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2073	t	R06	00:12:20	00:12:20	00:03:20	cancion	00:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	144	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2074	t	R06	00:15:40	00:15:40	00:03:20	cancion	00:15:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	145	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2075	t	R06	00:19:00	00:19:00	00:03:20	cancion	00:19:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	146	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2076	t	R06	00:22:20	00:22:20	00:03:20	cancion	00:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	147	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2077	t	R06	00:25:40	00:25:40	00:02:40	cancion	00:25:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	10	148	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2078	t	R06	00:28:20	00:28:20	00:03:20	cancion	00:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	149	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2079	t	R06	00:31:40	00:31:40	00:03:00	cancion	00:31:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	10	150	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2080	t	R06	00:34:40	00:34:40	00:02:40	cancion	00:34:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	10	151	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2081	t	R06	00:37:20	00:37:20	00:03:20	cancion	00:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	152	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2082	t	R06	00:40:40	00:40:40	00:03:00	cancion	00:40:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	10	153	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2083	t	R06	00:43:40	00:43:40	00:03:20	cancion	00:43:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	154	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2084	t	R06	00:47:00	00:47:00	00:02:40	cancion	00:47:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	10	155	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2085	t	R06	00:49:40	00:49:40	00:03:20	cancion	00:49:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	156	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2086	t	R06	00:53:00	00:53:00	00:03:00	cancion	00:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	10	157	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2087	t	R06	00:56:00	00:56:00	00:03:20	cancion	00:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	10	158	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2088	t	R06	00:59:20	00:59:20	00:02:40	cancion	00:59:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	10	159	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2089	t	R07	01:02:00	01:02:00	00:03:20	cancion	01:02:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	160	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2090	t	R07	01:05:20	01:05:20	00:03:20	cancion	01:05:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	161	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2091	t	R07	01:08:40	01:08:40	00:03:00	cancion	01:08:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	11	162	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2092	t	R07	01:11:40	01:11:40	00:02:40	cancion	01:11:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	11	163	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2093	t	R07	01:14:20	01:14:20	00:03:20	cancion	01:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	164	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2094	t	R07	01:17:40	01:17:40	00:03:20	cancion	01:17:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	165	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2095	t	R07	01:21:00	01:21:00	00:03:00	cancion	01:21:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	11	166	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2096	t	R07	01:24:00	01:24:00	00:03:20	cancion	01:24:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	167	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2097	t	R07	01:27:20	01:27:20	00:03:00	cancion	01:27:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	11	168	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2098	t	R07	01:30:20	01:30:20	00:02:40	cancion	01:30:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	11	169	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2099	t	R07	01:33:00	01:33:00	00:03:20	cancion	01:33:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	170	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2100	t	R07	01:36:20	01:36:20	00:03:20	cancion	01:36:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	171	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2101	t	R07	01:39:40	01:39:40	00:03:20	cancion	01:39:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	172	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2102	t	R07	01:43:00	01:43:00	00:02:40	cancion	01:43:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	11	173	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2103	t	R07	01:45:40	01:45:40	00:03:00	cancion	01:45:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	11	174	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2104	t	R07	01:48:40	01:48:40	00:02:40	cancion	01:48:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	11	175	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2105	t	R07	01:51:20	01:51:20	00:03:20	cancion	01:51:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	176	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2106	t	R07	01:54:40	01:54:40	00:03:20	cancion	01:54:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	177	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2107	t	R07	01:58:00	01:58:00	00:03:00	cancion	01:58:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	11	178	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2108	t	R07	02:01:00	02:01:00	00:03:20	cancion	02:01:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	11	179	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2109	t	R08	02:04:20	02:04:20	00:02:40	cancion	02:04:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	12	180	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2110	t	R08	02:07:00	02:07:00	00:03:20	cancion	02:07:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	181	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2111	t	R08	02:10:20	02:10:20	00:03:00	cancion	02:10:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	12	182	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2112	t	R08	02:13:20	02:13:20	00:03:00	cancion	02:13:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	12	183	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2113	t	R08	02:16:20	02:16:20	00:03:20	cancion	02:16:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	184	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2114	t	R08	02:19:40	02:19:40	00:02:40	cancion	02:19:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	12	185	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2115	t	R08	02:22:20	02:22:20	00:03:20	cancion	02:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	186	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2116	t	R08	02:25:40	02:25:40	00:02:40	cancion	02:25:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	12	187	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2117	t	R08	02:28:20	02:28:20	00:03:20	cancion	02:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	188	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2118	t	R08	02:31:40	02:31:40	00:03:20	cancion	02:31:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	189	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2119	t	R08	02:35:00	02:35:00	00:03:00	cancion	02:35:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	12	190	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2120	t	R08	02:38:00	02:38:00	00:02:40	cancion	02:38:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	12	191	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2121	t	R08	02:40:40	02:40:40	00:03:20	cancion	02:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	192	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2122	t	R08	02:44:00	02:44:00	00:03:20	cancion	02:44:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	193	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2123	t	R08	02:47:20	02:47:20	00:03:00	cancion	02:47:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	12	194	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2124	t	R08	02:50:20	02:50:20	00:03:20	cancion	02:50:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	195	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2125	t	R08	02:53:40	02:53:40	00:03:20	cancion	02:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	196	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2126	t	R08	02:57:00	02:57:00	00:03:00	cancion	02:57:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	12	197	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2127	t	R08	03:00:00	03:00:00	00:02:40	cancion	03:00:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	12	198	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2128	t	R08	03:02:40	03:02:40	00:03:20	cancion	03:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	12	199	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2129	t	R09	03:06:00	03:06:00	00:02:40	cancion	03:06:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	200	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2130	t	R09	03:08:40	03:08:40	00:03:20	cancion	03:08:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	201	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2131	t	R09	03:12:00	03:12:00	00:03:20	cancion	03:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	202	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2132	t	R09	03:15:20	03:15:20	00:03:00	cancion	03:15:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	203	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2133	t	R09	03:18:20	03:18:20	00:03:20	cancion	03:18:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	204	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2134	t	R09	03:21:40	03:21:40	00:03:20	cancion	03:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	205	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2135	t	R09	03:25:00	03:25:00	00:03:00	cancion	03:25:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	206	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2136	t	R09	03:28:00	03:28:00	00:03:20	cancion	03:28:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	207	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2137	t	R09	03:31:20	03:31:20	00:02:40	cancion	03:31:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	208	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2138	t	R09	03:34:00	03:34:00	00:03:00	cancion	03:34:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	209	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2139	t	R09	03:37:00	03:37:00	00:02:40	cancion	03:37:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	210	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2140	t	R09	03:39:40	03:39:40	00:03:20	cancion	03:39:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	211	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2141	t	R09	03:43:00	03:43:00	00:03:00	cancion	03:43:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	212	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2142	t	R09	03:46:00	03:46:00	00:02:40	cancion	03:46:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	213	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2143	t	R09	03:48:40	03:48:40	00:02:40	cancion	03:48:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	214	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2144	t	R09	03:51:20	03:51:20	00:03:00	cancion	03:51:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	215	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2145	t	R09	03:54:20	03:54:20	00:02:40	cancion	03:54:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	13	216	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2146	t	R09	03:57:00	03:57:00	00:03:20	cancion	03:57:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	217	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2147	t	R09	04:00:20	04:00:20	00:03:00	cancion	04:00:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	13	218	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2148	t	R09	04:03:20	04:03:20	00:03:20	cancion	04:03:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	13	219	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2149	t	R10	04:06:40	04:06:40	00:02:40	cancion	04:06:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	14	220	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2150	t	R10	04:09:20	04:09:20	00:03:00	cancion	04:09:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	14	221	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2151	t	R10	04:12:20	04:12:20	00:03:20	cancion	04:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	222	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2152	t	R10	04:15:40	04:15:40	00:03:20	cancion	04:15:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	223	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2153	t	R10	04:19:00	04:19:00	00:02:40	cancion	04:19:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	14	224	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2154	t	R10	04:21:40	04:21:40	00:03:20	cancion	04:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	225	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2155	t	R10	04:25:00	04:25:00	00:03:20	cancion	04:25:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	226	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2156	t	R10	04:28:20	04:28:20	00:03:00	cancion	04:28:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	14	227	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2157	t	R10	04:31:20	04:31:20	00:03:20	cancion	04:31:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	228	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2158	t	R10	04:34:40	04:34:40	00:03:20	cancion	04:34:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	229	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2159	t	R10	04:38:00	04:38:00	00:03:20	cancion	04:38:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	230	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2160	t	R10	04:41:20	04:41:20	00:03:20	cancion	04:41:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	231	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2161	t	R10	04:44:40	04:44:40	00:03:20	cancion	04:44:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	232	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2162	t	R10	04:48:00	04:48:00	00:03:20	cancion	04:48:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	233	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2163	t	R10	04:51:20	04:51:20	00:03:00	cancion	04:51:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	14	234	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2164	t	R10	04:54:20	04:54:20	00:02:40	cancion	04:54:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	14	235	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2165	t	R10	04:57:00	04:57:00	00:03:00	cancion	04:57:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	14	236	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2166	t	R10	05:00:00	05:00:00	00:02:40	cancion	05:00:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	14	237	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2167	t	R10	05:02:40	05:02:40	00:03:20	cancion	05:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	238	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2168	t	R10	05:06:00	05:06:00	00:03:20	cancion	05:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	14	239	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2169	t	R11	05:09:20	05:09:20	00:03:20	cancion	05:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	240	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2170	t	R11	05:12:40	05:12:40	00:02:40	cancion	05:12:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	15	241	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2171	t	R11	05:15:20	05:15:20	00:03:20	cancion	05:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	242	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2172	t	R11	05:18:40	05:18:40	00:03:20	cancion	05:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	243	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2173	t	R11	05:22:00	05:22:00	00:03:00	cancion	05:22:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	15	244	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2174	t	R11	05:25:00	05:25:00	00:03:00	cancion	05:25:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	15	245	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2175	t	R11	05:28:00	05:28:00	00:02:40	cancion	05:28:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	15	246	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2176	t	R11	05:30:40	05:30:40	00:03:20	cancion	05:30:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	247	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2177	t	R11	05:34:00	05:34:00	00:02:40	cancion	05:34:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	15	248	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2178	t	R11	05:36:40	05:36:40	00:03:00	cancion	05:36:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	15	249	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2179	t	R11	05:39:40	05:39:40	00:03:20	cancion	05:39:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	250	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2180	t	R11	05:43:00	05:43:00	00:02:40	cancion	05:43:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	15	251	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2181	t	R11	05:45:40	05:45:40	00:03:20	cancion	05:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	252	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2182	t	R11	05:49:00	05:49:00	00:03:00	cancion	05:49:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	15	253	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2183	t	R11	05:52:00	05:52:00	00:03:20	cancion	05:52:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	254	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2184	t	R11	05:55:20	05:55:20	00:03:20	cancion	05:55:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	255	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2185	t	R11	05:58:40	05:58:40	00:03:00	cancion	05:58:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	15	256	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2186	t	R11	06:01:40	06:01:40	00:03:20	cancion	06:01:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	257	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2187	t	R11	06:05:00	06:05:00	00:03:20	cancion	06:05:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	15	258	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2188	t	R11	06:08:20	06:08:20	00:02:40	cancion	06:08:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	15	259	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2189	t	R12	06:11:00	06:11:00	00:02:40	cancion	06:11:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	16	260	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2190	t	R12	06:13:40	06:13:40	00:03:00	cancion	06:13:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	16	261	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2191	t	R12	06:16:40	06:16:40	00:03:00	cancion	06:16:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	16	262	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2192	t	R12	06:19:40	06:19:40	00:02:40	cancion	06:19:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	16	263	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2193	t	R12	06:22:20	06:22:20	00:03:20	cancion	06:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	264	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2194	t	R12	06:25:40	06:25:40	00:03:20	cancion	06:25:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	265	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2195	t	R12	06:29:00	06:29:00	00:03:20	cancion	06:29:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	266	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2196	t	R12	06:32:20	06:32:20	00:02:40	cancion	06:32:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	16	267	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2197	t	R12	06:35:00	06:35:00	00:03:00	cancion	06:35:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	16	268	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2198	t	R12	06:38:00	06:38:00	00:03:20	cancion	06:38:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	269	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2199	t	R12	06:41:20	06:41:20	00:02:40	cancion	06:41:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	16	270	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2200	t	R12	06:44:00	06:44:00	00:03:00	cancion	06:44:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	16	271	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2201	t	R12	06:47:00	06:47:00	00:03:20	cancion	06:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	272	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2202	t	R12	06:50:20	06:50:20	00:03:20	cancion	06:50:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	273	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2203	t	R12	06:53:40	06:53:40	00:03:20	cancion	06:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	274	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2204	t	R12	06:57:00	06:57:00	00:02:40	cancion	06:57:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	16	275	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2205	t	R12	06:59:40	06:59:40	00:03:00	cancion	06:59:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	16	276	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2206	t	R12	07:02:40	07:02:40	00:03:20	cancion	07:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	277	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2207	t	R12	07:06:00	07:06:00	00:03:20	cancion	07:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	278	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2208	t	R12	07:09:20	07:09:20	00:03:20	cancion	07:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	16	279	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2209	t	R13	07:12:40	07:12:40	00:03:20	cancion	07:12:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	280	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2210	t	R13	07:16:00	07:16:00	00:03:20	cancion	07:16:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	281	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2211	t	R13	07:19:20	07:19:20	00:03:20	cancion	07:19:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	282	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2212	t	R13	07:22:40	07:22:40	00:02:40	cancion	07:22:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	17	283	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2213	t	R13	07:25:20	07:25:20	00:03:20	cancion	07:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	284	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2214	t	R13	07:28:40	07:28:40	00:03:20	cancion	07:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	285	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2215	t	R13	07:32:00	07:32:00	00:03:00	cancion	07:32:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	17	286	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2216	t	R13	07:35:00	07:35:00	00:03:20	cancion	07:35:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	287	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2217	t	R13	07:38:20	07:38:20	00:03:00	cancion	07:38:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	17	288	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2218	t	R13	07:41:20	07:41:20	00:03:20	cancion	07:41:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	289	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2219	t	R13	07:44:40	07:44:40	00:03:20	cancion	07:44:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	290	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2220	t	R13	07:48:00	07:48:00	00:03:20	cancion	07:48:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	291	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2221	t	R13	07:51:20	07:51:20	00:02:40	cancion	07:51:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	17	292	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2222	t	R13	07:54:00	07:54:00	00:03:00	cancion	07:54:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	17	293	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2223	t	R13	07:57:00	07:57:00	00:02:40	cancion	07:57:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	17	294	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2224	t	R13	07:59:40	07:59:40	00:03:20	cancion	07:59:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	295	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2225	t	R13	08:03:00	08:03:00	00:03:20	cancion	08:03:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	296	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2226	t	R13	08:06:20	08:06:20	00:03:20	cancion	08:06:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	297	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2227	t	R13	08:09:40	08:09:40	00:02:40	cancion	08:09:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	17	298	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2228	t	R13	08:12:20	08:12:20	00:03:20	cancion	08:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	17	299	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2229	t	R14	08:15:40	08:15:40	00:03:20	cancion	08:15:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	300	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2230	t	R14	08:19:00	08:19:00	00:03:00	cancion	08:19:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	18	301	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2231	t	R14	08:22:00	08:22:00	00:03:20	cancion	08:22:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	302	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2232	t	R14	08:25:20	08:25:20	00:03:20	cancion	08:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	303	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2233	t	R14	08:28:40	08:28:40	00:02:40	cancion	08:28:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	18	304	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2234	t	R14	08:31:20	08:31:20	00:03:00	cancion	08:31:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	18	305	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2235	t	R14	08:34:20	08:34:20	00:03:20	cancion	08:34:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	306	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2236	t	R14	08:37:40	08:37:40	00:02:40	cancion	08:37:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	18	307	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2237	t	R14	08:40:20	08:40:20	00:03:00	cancion	08:40:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	18	308	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2238	t	R14	08:43:20	08:43:20	00:03:20	cancion	08:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	309	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2239	t	R14	08:46:40	08:46:40	00:03:20	cancion	08:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	310	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2240	t	R14	08:50:00	08:50:00	00:03:20	cancion	08:50:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	311	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2241	t	R14	08:53:20	08:53:20	00:02:40	cancion	08:53:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	18	312	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2242	t	R14	08:56:00	08:56:00	00:03:20	cancion	08:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	313	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2243	t	R14	08:59:20	08:59:20	00:03:20	cancion	08:59:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	314	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2244	t	R14	09:02:40	09:02:40	00:03:00	cancion	09:02:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	18	315	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2245	t	R14	09:05:40	09:05:40	00:03:20	cancion	09:05:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	316	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2246	t	R14	09:09:00	09:09:00	00:03:00	cancion	09:09:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	18	317	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2247	t	R14	09:12:00	09:12:00	00:03:20	cancion	09:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	318	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2248	t	R14	09:15:20	09:15:20	00:03:20	cancion	09:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	18	319	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2249	t	R15	09:18:40	09:18:40	00:02:40	cancion	09:18:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	19	320	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2250	t	R15	09:21:20	09:21:20	00:03:20	cancion	09:21:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	321	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2251	t	R15	09:24:40	09:24:40	00:03:20	cancion	09:24:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	322	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2252	t	R15	09:28:00	09:28:00	00:03:00	cancion	09:28:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	19	323	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2253	t	R15	09:31:00	09:31:00	00:02:40	cancion	09:31:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	19	324	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2254	t	R15	09:33:40	09:33:40	00:03:20	cancion	09:33:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	325	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2255	t	R15	09:37:00	09:37:00	00:03:20	cancion	09:37:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	326	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2256	t	R15	09:40:20	09:40:20	00:03:20	cancion	09:40:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	327	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2257	t	R15	09:43:40	09:43:40	00:03:20	cancion	09:43:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	328	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2258	t	R15	09:47:00	09:47:00	00:03:20	cancion	09:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	329	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2259	t	R15	09:50:20	09:50:20	00:03:00	cancion	09:50:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	19	330	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2260	t	R15	09:53:20	09:53:20	00:03:20	cancion	09:53:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	331	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2261	t	R15	09:56:40	09:56:40	00:02:40	cancion	09:56:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	19	332	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2262	t	R15	09:59:20	09:59:20	00:03:20	cancion	09:59:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	333	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2263	t	R15	10:02:40	10:02:40	00:03:00	cancion	10:02:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	19	334	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2264	t	R15	10:05:40	10:05:40	00:02:40	cancion	10:05:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	19	335	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2265	t	R15	10:08:20	10:08:20	00:03:20	cancion	10:08:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	336	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2266	t	R15	10:11:40	10:11:40	00:03:20	cancion	10:11:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	337	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2267	t	R15	10:15:00	10:15:00	00:03:20	cancion	10:15:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	19	338	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2268	t	R15	10:18:20	10:18:20	00:02:40	cancion	10:18:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	19	339	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2269	t	R16	10:21:00	10:21:00	00:03:20	cancion	10:21:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	340	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2270	t	R16	10:24:20	10:24:20	00:03:20	cancion	10:24:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	341	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2271	t	R16	10:27:40	10:27:40	00:03:20	cancion	10:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	342	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2272	t	R16	10:31:00	10:31:00	00:03:20	cancion	10:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	343	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2273	t	R16	10:34:20	10:34:20	00:03:00	cancion	10:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	20	344	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2274	t	R16	10:37:20	10:37:20	00:03:20	cancion	10:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	345	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2275	t	R16	10:40:40	10:40:40	00:03:20	cancion	10:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	346	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2276	t	R16	10:44:00	10:44:00	00:03:20	cancion	10:44:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	347	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2277	t	R16	10:47:20	10:47:20	00:03:20	cancion	10:47:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	348	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2278	t	R16	10:50:40	10:50:40	00:03:20	cancion	10:50:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	349	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2279	t	R16	10:54:00	10:54:00	00:02:40	cancion	10:54:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	20	350	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2280	t	R16	10:56:40	10:56:40	00:03:20	cancion	10:56:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	351	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2281	t	R16	11:00:00	11:00:00	00:03:20	cancion	11:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	352	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2282	t	R16	11:03:20	11:03:20	00:03:00	cancion	11:03:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	20	353	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2283	t	R16	11:06:20	11:06:20	00:03:00	cancion	11:06:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-21	20	354	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2284	t	R16	11:09:20	11:09:20	00:03:20	cancion	11:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	355	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2285	t	R16	11:12:40	11:12:40	00:02:40	cancion	11:12:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	20	356	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2286	t	R16	11:15:20	11:15:20	00:03:20	cancion	11:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-21	20	357	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2287	t	R16	11:18:40	11:18:40	00:02:40	cancion	11:18:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-21	20	358	7	2025-10-21 02:54:23.250379+00	2025-10-21 02:54:23.250379+00
2288	t	R06	00:00:00	00:00:00	00:03:00	cancion	00:00:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	140	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2289	t	R06	00:03:00	00:03:00	00:03:20	cancion	00:03:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	141	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2290	t	R06	00:06:20	00:06:20	00:03:20	cancion	00:06:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	142	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2291	t	R06	00:09:40	00:09:40	00:02:40	cancion	00:09:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	143	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2292	t	R06	00:12:20	00:12:20	00:03:00	cancion	00:12:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	144	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2293	t	R06	00:15:20	00:15:20	00:03:20	cancion	00:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	145	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2294	t	R06	00:18:40	00:18:40	00:02:40	cancion	00:18:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	146	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2295	t	R06	00:21:20	00:21:20	00:03:00	cancion	00:21:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	147	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2296	t	R06	00:24:20	00:24:20	00:02:40	cancion	00:24:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	148	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2297	t	R06	00:27:00	00:27:00	00:03:20	cancion	00:27:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	149	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2298	t	R06	00:30:20	00:30:20	00:03:00	cancion	00:30:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	150	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2299	t	R06	00:33:20	00:33:20	00:02:40	cancion	00:33:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	151	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2300	t	R06	00:36:00	00:36:00	00:03:20	cancion	00:36:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	152	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2301	t	R06	00:39:20	00:39:20	00:02:40	cancion	00:39:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	153	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2302	t	R06	00:42:00	00:42:00	00:03:20	cancion	00:42:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	154	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2303	t	R06	00:45:20	00:45:20	00:03:00	cancion	00:45:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	155	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2304	t	R06	00:48:20	00:48:20	00:03:20	cancion	00:48:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	10	156	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2305	t	R06	00:51:40	00:51:40	00:02:40	cancion	00:51:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	157	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2306	t	R06	00:54:20	00:54:20	00:03:00	cancion	00:54:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	10	158	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2307	t	R06	00:57:20	00:57:20	00:02:40	cancion	00:57:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	10	159	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2308	t	R07	01:00:00	01:00:00	00:03:20	cancion	01:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	160	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2309	t	R07	01:03:20	01:03:20	00:03:00	cancion	01:03:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	161	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2310	t	R07	01:06:20	01:06:20	00:03:00	cancion	01:06:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	162	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2311	t	R07	01:09:20	01:09:20	00:02:40	cancion	01:09:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	163	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2312	t	R07	01:12:00	01:12:00	00:03:00	cancion	01:12:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	164	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
1513	t	R04	00:00:00	00:00:00	00:02:40	cancion	00:00:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	8	100	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1514	t	R04	00:02:40	00:02:40	00:03:00	cancion	00:02:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	8	101	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1515	t	R04	00:05:40	00:05:40	00:02:40	cancion	00:05:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	8	102	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1516	t	R04	00:08:20	00:08:20	00:03:20	cancion	00:08:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	103	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1517	t	R04	00:11:40	00:11:40	00:03:00	cancion	00:11:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	8	104	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1518	t	R04	00:14:40	00:14:40	00:03:20	cancion	00:14:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	105	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1519	t	R04	00:18:00	00:18:00	00:03:20	cancion	00:18:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	106	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1520	t	R04	00:21:20	00:21:20	00:03:00	cancion	00:21:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	8	107	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1521	t	R04	00:24:20	00:24:20	00:02:40	cancion	00:24:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	8	108	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1522	t	R04	00:27:00	00:27:00	00:03:20	cancion	00:27:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	109	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1523	t	R04	00:30:20	00:30:20	00:03:20	cancion	00:30:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	110	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1524	t	R04	00:33:40	00:33:40	00:03:00	cancion	00:33:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	8	111	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1525	t	R04	00:36:40	00:36:40	00:03:20	cancion	00:36:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	112	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1526	t	R04	00:40:00	00:40:00	00:02:40	cancion	00:40:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	8	113	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1527	t	R04	00:42:40	00:42:40	00:03:20	cancion	00:42:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	114	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1528	t	R04	00:46:00	00:46:00	00:03:20	cancion	00:46:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	115	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1529	t	R04	00:49:20	00:49:20	00:03:20	cancion	00:49:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	116	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1530	t	R04	00:52:40	00:52:40	00:03:00	cancion	00:52:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	8	117	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1531	t	R04	00:55:40	00:55:40	00:02:40	cancion	00:55:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	8	118	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1532	t	R04	00:58:20	00:58:20	00:03:20	cancion	00:58:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	8	119	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1533	t	R05	01:01:40	01:01:40	00:02:40	cancion	01:01:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	9	120	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1534	t	R05	01:04:20	01:04:20	00:03:00	cancion	01:04:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	9	121	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1535	t	R05	01:07:20	01:07:20	00:03:20	cancion	01:07:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	122	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1536	t	R05	01:10:40	01:10:40	00:03:20	cancion	01:10:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	123	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1537	t	R05	01:14:00	01:14:00	00:03:20	cancion	01:14:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	124	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1538	t	R05	01:17:20	01:17:20	00:02:40	cancion	01:17:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	9	125	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1539	t	R05	01:20:00	01:20:00	00:03:20	cancion	01:20:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	126	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1540	t	R05	01:23:20	01:23:20	00:03:00	cancion	01:23:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	9	127	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1541	t	R05	01:26:20	01:26:20	00:02:40	cancion	01:26:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	9	128	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1542	t	R05	01:29:00	01:29:00	00:03:20	cancion	01:29:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	129	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1543	t	R05	01:32:20	01:32:20	00:03:20	cancion	01:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	130	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1544	t	R05	01:35:40	01:35:40	00:03:00	cancion	01:35:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	9	131	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1545	t	R05	01:38:40	01:38:40	00:03:20	cancion	01:38:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	132	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1546	t	R05	01:42:00	01:42:00	00:03:20	cancion	01:42:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	133	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1547	t	R05	01:45:20	01:45:20	00:03:20	cancion	01:45:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	134	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
2313	t	R07	01:15:00	01:15:00	00:02:40	cancion	01:15:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	165	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2314	t	R07	01:17:40	01:17:40	00:02:40	cancion	01:17:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	166	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2315	t	R07	01:20:20	01:20:20	00:03:00	cancion	01:20:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	167	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2316	t	R07	01:23:20	01:23:20	00:03:20	cancion	01:23:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	168	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2317	t	R07	01:26:40	01:26:40	00:03:00	cancion	01:26:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	169	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2318	t	R07	01:29:40	01:29:40	00:03:20	cancion	01:29:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	170	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2319	t	R07	01:33:00	01:33:00	00:02:40	cancion	01:33:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	171	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2320	t	R07	01:35:40	01:35:40	00:02:40	cancion	01:35:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	172	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2321	t	R07	01:38:20	01:38:20	00:03:20	cancion	01:38:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	173	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2322	t	R07	01:41:40	01:41:40	00:03:20	cancion	01:41:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	174	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2323	t	R07	01:45:00	01:45:00	00:03:00	cancion	01:45:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	175	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2324	t	R07	01:48:00	01:48:00	00:03:20	cancion	01:48:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	176	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2325	t	R07	01:51:20	01:51:20	00:03:20	cancion	01:51:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	11	177	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2326	t	R07	01:54:40	01:54:40	00:03:00	cancion	01:54:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	11	178	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2327	t	R07	01:57:40	01:57:40	00:02:40	cancion	01:57:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	11	179	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2328	t	R08	02:00:20	02:00:20	00:03:20	cancion	02:00:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	180	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2329	t	R08	02:03:40	02:03:40	00:03:20	cancion	02:03:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	181	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2330	t	R08	02:07:00	02:07:00	00:02:40	cancion	02:07:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	12	182	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2331	t	R08	02:09:40	02:09:40	00:03:20	cancion	02:09:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	183	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2332	t	R08	02:13:00	02:13:00	00:03:20	cancion	02:13:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	184	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2333	t	R08	02:16:20	02:16:20	00:03:00	cancion	02:16:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	12	185	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2334	t	R08	02:19:20	02:19:20	00:03:00	cancion	02:19:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	12	186	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2335	t	R08	02:22:20	02:22:20	00:03:20	cancion	02:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	187	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2336	t	R08	02:25:40	02:25:40	00:03:20	cancion	02:25:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	188	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2337	t	R08	02:29:00	02:29:00	00:02:40	cancion	02:29:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	12	189	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2338	t	R08	02:31:40	02:31:40	00:03:00	cancion	02:31:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	12	190	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2339	t	R08	02:34:40	02:34:40	00:03:20	cancion	02:34:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	191	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2340	t	R08	02:38:00	02:38:00	00:02:40	cancion	02:38:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	12	192	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2341	t	R08	02:40:40	02:40:40	00:03:20	cancion	02:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	193	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2342	t	R08	02:44:00	02:44:00	00:03:00	cancion	02:44:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	12	194	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2343	t	R08	02:47:00	02:47:00	00:03:20	cancion	02:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	195	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2344	t	R08	02:50:20	02:50:20	00:02:40	cancion	02:50:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	12	196	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2345	t	R08	02:53:00	02:53:00	00:03:00	cancion	02:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	12	197	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2346	t	R08	02:56:00	02:56:00	00:03:20	cancion	02:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	12	198	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2347	t	R08	02:59:20	02:59:20	00:02:40	cancion	02:59:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	12	199	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2348	t	R09	03:02:00	03:02:00	00:03:00	cancion	03:02:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	13	200	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2349	t	R09	03:05:00	03:05:00	00:02:40	cancion	03:05:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	13	201	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2350	t	R09	03:07:40	03:07:40	00:03:20	cancion	03:07:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	202	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2351	t	R09	03:11:00	03:11:00	00:03:20	cancion	03:11:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	203	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2352	t	R09	03:14:20	03:14:20	00:03:20	cancion	03:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	204	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2353	t	R09	03:17:40	03:17:40	00:02:40	cancion	03:17:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	13	205	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2354	t	R09	03:20:20	03:20:20	00:03:00	cancion	03:20:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	13	206	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2355	t	R09	03:23:20	03:23:20	00:03:20	cancion	03:23:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	207	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2356	t	R09	03:26:40	03:26:40	00:03:20	cancion	03:26:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	208	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2357	t	R09	03:30:00	03:30:00	00:03:20	cancion	03:30:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	209	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2358	t	R09	03:33:20	03:33:20	00:03:20	cancion	03:33:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	210	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2359	t	R09	03:36:40	03:36:40	00:03:20	cancion	03:36:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	211	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2360	t	R09	03:40:00	03:40:00	00:03:00	cancion	03:40:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	13	212	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2361	t	R09	03:43:00	03:43:00	00:02:40	cancion	03:43:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	13	213	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2362	t	R09	03:45:40	03:45:40	00:03:00	cancion	03:45:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	13	214	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2363	t	R09	03:48:40	03:48:40	00:02:40	cancion	03:48:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	13	215	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2364	t	R09	03:51:20	03:51:20	00:03:20	cancion	03:51:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	216	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2365	t	R09	03:54:40	03:54:40	00:03:20	cancion	03:54:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	217	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2366	t	R09	03:58:00	03:58:00	00:03:20	cancion	03:58:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	218	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2367	t	R09	04:01:20	04:01:20	00:03:20	cancion	04:01:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	13	219	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2368	t	R10	04:04:40	04:04:40	00:03:00	cancion	04:04:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	14	220	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2369	t	R10	04:07:40	04:07:40	00:03:20	cancion	04:07:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	221	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2370	t	R10	04:11:00	04:11:00	00:03:20	cancion	04:11:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	222	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2371	t	R10	04:14:20	04:14:20	00:03:20	cancion	04:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	223	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2372	t	R10	04:17:40	04:17:40	00:02:40	cancion	04:17:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	14	224	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2373	t	R10	04:20:20	04:20:20	00:03:20	cancion	04:20:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	225	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2374	t	R10	04:23:40	04:23:40	00:03:00	cancion	04:23:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	14	226	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2375	t	R10	04:26:40	04:26:40	00:03:20	cancion	04:26:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	227	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2376	t	R10	04:30:00	04:30:00	00:03:20	cancion	04:30:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	228	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2377	t	R10	04:33:20	04:33:20	00:03:20	cancion	04:33:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	229	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2378	t	R10	04:36:40	04:36:40	00:02:40	cancion	04:36:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	14	230	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2379	t	R10	04:39:20	04:39:20	00:03:00	cancion	04:39:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	14	231	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2380	t	R10	04:42:20	04:42:20	00:02:40	cancion	04:42:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	14	232	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2381	t	R10	04:45:00	04:45:00	00:02:40	cancion	04:45:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	14	233	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2382	t	R10	04:47:40	04:47:40	00:03:20	cancion	04:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	234	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2383	t	R10	04:51:00	04:51:00	00:03:20	cancion	04:51:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	235	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2384	t	R10	04:54:20	04:54:20	00:03:20	cancion	04:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	236	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2385	t	R10	04:57:40	04:57:40	00:03:20	cancion	04:57:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	237	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2386	t	R10	05:01:00	05:01:00	00:03:00	cancion	05:01:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	14	238	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2387	t	R10	05:04:00	05:04:00	00:03:20	cancion	05:04:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	14	239	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2388	t	R11	05:07:20	05:07:20	00:02:40	cancion	05:07:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	240	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2389	t	R11	05:10:00	05:10:00	00:03:20	cancion	05:10:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	241	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2390	t	R11	05:13:20	05:13:20	00:03:00	cancion	05:13:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	242	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2391	t	R11	05:16:20	05:16:20	00:03:00	cancion	05:16:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	243	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2392	t	R11	05:19:20	05:19:20	00:03:20	cancion	05:19:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	244	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2393	t	R11	05:22:40	05:22:40	00:02:40	cancion	05:22:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	245	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2394	t	R11	05:25:20	05:25:20	00:03:20	cancion	05:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	246	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2395	t	R11	05:28:40	05:28:40	00:03:20	cancion	05:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	247	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2396	t	R11	05:32:00	05:32:00	00:03:20	cancion	05:32:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	248	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2397	t	R11	05:35:20	05:35:20	00:03:00	cancion	05:35:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	249	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2398	t	R11	05:38:20	05:38:20	00:02:40	cancion	05:38:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	250	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2399	t	R11	05:41:00	05:41:00	00:02:40	cancion	05:41:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	251	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2400	t	R11	05:43:40	05:43:40	00:03:00	cancion	05:43:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	252	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2401	t	R11	05:46:40	05:46:40	00:03:20	cancion	05:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	253	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2402	t	R11	05:50:00	05:50:00	00:02:40	cancion	05:50:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	254	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2403	t	R11	05:52:40	05:52:40	00:03:00	cancion	05:52:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	255	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2404	t	R11	05:55:40	05:55:40	00:03:00	cancion	05:55:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	256	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2405	t	R11	05:58:40	05:58:40	00:03:20	cancion	05:58:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	15	257	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2406	t	R11	06:02:00	06:02:00	00:02:40	cancion	06:02:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	15	258	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2407	t	R11	06:04:40	06:04:40	00:03:00	cancion	06:04:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	15	259	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2408	t	R12	06:07:40	06:07:40	00:02:40	cancion	06:07:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	260	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2409	t	R12	06:10:20	06:10:20	00:03:20	cancion	06:10:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	261	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2410	t	R12	06:13:40	06:13:40	00:02:40	cancion	06:13:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	262	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2411	t	R12	06:16:20	06:16:20	00:03:20	cancion	06:16:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	263	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2412	t	R12	06:19:40	06:19:40	00:03:20	cancion	06:19:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	264	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2413	t	R12	06:23:00	06:23:00	00:03:00	cancion	06:23:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	265	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2414	t	R12	06:26:00	06:26:00	00:02:40	cancion	06:26:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	266	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2415	t	R12	06:28:40	06:28:40	00:03:20	cancion	06:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	267	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2416	t	R12	06:32:00	06:32:00	00:03:00	cancion	06:32:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	268	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2417	t	R12	06:35:00	06:35:00	00:03:00	cancion	06:35:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	269	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2418	t	R12	06:38:00	06:38:00	00:03:20	cancion	06:38:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	270	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2419	t	R12	06:41:20	06:41:20	00:02:40	cancion	06:41:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	271	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2420	t	R12	06:44:00	06:44:00	00:03:00	cancion	06:44:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	272	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2421	t	R12	06:47:00	06:47:00	00:03:20	cancion	06:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	273	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2422	t	R12	06:50:20	06:50:20	00:02:40	cancion	06:50:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	274	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2423	t	R12	06:53:00	06:53:00	00:03:00	cancion	06:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	275	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2424	t	R12	06:56:00	06:56:00	00:02:40	cancion	06:56:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	16	276	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2425	t	R12	06:58:40	06:58:40	00:03:20	cancion	06:58:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	277	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2426	t	R12	07:02:00	07:02:00	00:03:20	cancion	07:02:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	16	278	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2427	t	R12	07:05:20	07:05:20	00:03:00	cancion	07:05:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	16	279	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2428	t	R13	07:08:20	07:08:20	00:02:40	cancion	07:08:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	280	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2429	t	R13	07:11:00	07:11:00	00:02:40	cancion	07:11:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	281	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2430	t	R13	07:13:40	07:13:40	00:03:20	cancion	07:13:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	282	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2431	t	R13	07:17:00	07:17:00	00:03:00	cancion	07:17:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	17	283	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2432	t	R13	07:20:00	07:20:00	00:02:40	cancion	07:20:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	284	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2433	t	R13	07:22:40	07:22:40	00:03:00	cancion	07:22:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	17	285	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2434	t	R13	07:25:40	07:25:40	00:03:00	cancion	07:25:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	17	286	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2435	t	R13	07:28:40	07:28:40	00:03:20	cancion	07:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	287	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2436	t	R13	07:32:00	07:32:00	00:03:20	cancion	07:32:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	288	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2437	t	R13	07:35:20	07:35:20	00:02:40	cancion	07:35:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	289	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2438	t	R13	07:38:00	07:38:00	00:03:20	cancion	07:38:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	290	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2439	t	R13	07:41:20	07:41:20	00:03:20	cancion	07:41:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	291	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2440	t	R13	07:44:40	07:44:40	00:02:40	cancion	07:44:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	292	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2441	t	R13	07:47:20	07:47:20	00:03:20	cancion	07:47:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	293	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2442	t	R13	07:50:40	07:50:40	00:03:00	cancion	07:50:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	17	294	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2443	t	R13	07:53:40	07:53:40	00:03:20	cancion	07:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	295	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2444	t	R13	07:57:00	07:57:00	00:03:20	cancion	07:57:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	296	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2445	t	R13	08:00:20	08:00:20	00:02:40	cancion	08:00:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	17	297	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2446	t	R13	08:03:00	08:03:00	00:03:20	cancion	08:03:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	17	298	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2447	t	R13	08:06:20	08:06:20	00:03:00	cancion	08:06:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	17	299	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2448	t	R14	08:09:20	08:09:20	00:02:40	cancion	08:09:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	18	300	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2449	t	R14	08:12:00	08:12:00	00:03:00	cancion	08:12:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	301	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2450	t	R14	08:15:00	08:15:00	00:03:00	cancion	08:15:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	302	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2451	t	R14	08:18:00	08:18:00	00:03:20	cancion	08:18:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	303	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2452	t	R14	08:21:20	08:21:20	00:02:40	cancion	08:21:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	18	304	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2453	t	R14	08:24:00	08:24:00	00:02:40	cancion	08:24:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	18	305	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2454	t	R14	08:26:40	08:26:40	00:03:20	cancion	08:26:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	306	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2455	t	R14	08:30:00	08:30:00	00:03:00	cancion	08:30:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	307	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2456	t	R14	08:33:00	08:33:00	00:03:20	cancion	08:33:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	308	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2457	t	R14	08:36:20	08:36:20	00:02:40	cancion	08:36:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	18	309	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2458	t	R14	08:39:00	08:39:00	00:03:20	cancion	08:39:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	310	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2459	t	R14	08:42:20	08:42:20	00:03:20	cancion	08:42:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	311	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2460	t	R14	08:45:40	08:45:40	00:03:20	cancion	08:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	312	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2461	t	R14	08:49:00	08:49:00	00:03:20	cancion	08:49:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	313	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2462	t	R14	08:52:20	08:52:20	00:03:20	cancion	08:52:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	314	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2463	t	R14	08:55:40	08:55:40	00:03:00	cancion	08:55:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	315	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2464	t	R14	08:58:40	08:58:40	00:03:00	cancion	08:58:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	316	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2465	t	R14	09:01:40	09:01:40	00:02:40	cancion	09:01:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	18	317	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2466	t	R14	09:04:20	09:04:20	00:03:20	cancion	09:04:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	18	318	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2467	t	R14	09:07:40	09:07:40	00:03:00	cancion	09:07:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	18	319	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2468	t	R15	09:10:40	09:10:40	00:02:40	cancion	09:10:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	320	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2469	t	R15	09:13:20	09:13:20	00:03:00	cancion	09:13:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	321	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2470	t	R15	09:16:20	09:16:20	00:02:40	cancion	09:16:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	322	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2471	t	R15	09:19:00	09:19:00	00:03:20	cancion	09:19:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	323	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2472	t	R15	09:22:20	09:22:20	00:03:20	cancion	09:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	324	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2473	t	R15	09:25:40	09:25:40	00:02:40	cancion	09:25:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	325	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2474	t	R15	09:28:20	09:28:20	00:03:00	cancion	09:28:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	326	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2475	t	R15	09:31:20	09:31:20	00:02:40	cancion	09:31:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	327	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2476	t	R15	09:34:00	09:34:00	00:03:20	cancion	09:34:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	328	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2477	t	R15	09:37:20	09:37:20	00:03:20	cancion	09:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	329	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2478	t	R15	09:40:40	09:40:40	00:03:00	cancion	09:40:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	330	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2479	t	R15	09:43:40	09:43:40	00:02:40	cancion	09:43:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	331	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2480	t	R15	09:46:20	09:46:20	00:03:00	cancion	09:46:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	332	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2481	t	R15	09:49:20	09:49:20	00:03:20	cancion	09:49:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	333	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2482	t	R15	09:52:40	09:52:40	00:03:20	cancion	09:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	334	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2483	t	R15	09:56:00	09:56:00	00:03:00	cancion	09:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	335	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2484	t	R15	09:59:00	09:59:00	00:02:40	cancion	09:59:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	19	336	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2485	t	R15	10:01:40	10:01:40	00:03:20	cancion	10:01:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	337	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2486	t	R15	10:05:00	10:05:00	00:03:20	cancion	10:05:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	19	338	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2487	t	R15	10:08:20	10:08:20	00:03:00	cancion	10:08:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	19	339	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2488	t	R16	10:11:20	10:11:20	00:03:20	cancion	10:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	340	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2489	t	R16	10:14:40	10:14:40	00:03:20	cancion	10:14:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	341	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2490	t	R16	10:18:00	10:18:00	00:02:40	cancion	10:18:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	342	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2491	t	R16	10:20:40	10:20:40	00:03:20	cancion	10:20:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	343	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2492	t	R16	10:24:00	10:24:00	00:03:00	cancion	10:24:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	20	344	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2493	t	R16	10:27:00	10:27:00	00:03:20	cancion	10:27:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	345	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2494	t	R16	10:30:20	10:30:20	00:02:40	cancion	10:30:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	346	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2495	t	R16	10:33:00	10:33:00	00:02:40	cancion	10:33:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	347	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2496	t	R16	10:35:40	10:35:40	00:03:00	cancion	10:35:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	20	348	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2497	t	R16	10:38:40	10:38:40	00:03:00	cancion	10:38:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	20	349	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2498	t	R16	10:41:40	10:41:40	00:02:40	cancion	10:41:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	350	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2499	t	R16	10:44:20	10:44:20	00:02:40	cancion	10:44:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	351	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2500	t	R16	10:47:00	10:47:00	00:03:20	cancion	10:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	352	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2501	t	R16	10:50:20	10:50:20	00:03:20	cancion	10:50:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	353	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2502	t	R16	10:53:40	10:53:40	00:03:20	cancion	10:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	354	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2503	t	R16	10:57:00	10:57:00	00:03:00	cancion	10:57:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	20	355	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2504	t	R16	11:00:00	11:00:00	00:03:20	cancion	11:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	356	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2505	t	R16	11:03:20	11:03:20	00:03:00	cancion	11:03:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-23	20	357	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2506	t	R16	11:06:20	11:06:20	00:02:40	cancion	11:06:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-23	20	358	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2507	t	R16	11:09:00	11:09:00	00:03:20	cancion	11:09:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-23	20	359	7	2025-10-21 02:55:09.378297+00	2025-10-21 02:55:09.378297+00
2508	t	R06	00:00:00	00:00:00	00:03:20	cancion	00:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	140	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2509	t	R06	00:03:20	00:03:20	00:02:40	cancion	00:03:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	141	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2510	t	R06	00:06:00	00:06:00	00:03:20	cancion	00:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	142	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2511	t	R06	00:09:20	00:09:20	00:03:00	cancion	00:09:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	143	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2512	t	R06	00:12:20	00:12:20	00:03:00	cancion	00:12:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	144	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2513	t	R06	00:15:20	00:15:20	00:03:20	cancion	00:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	145	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2514	t	R06	00:18:40	00:18:40	00:02:40	cancion	00:18:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	146	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2515	t	R06	00:21:20	00:21:20	00:03:20	cancion	00:21:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	147	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2516	t	R06	00:24:40	00:24:40	00:03:00	cancion	00:24:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	148	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2517	t	R06	00:27:40	00:27:40	00:02:40	cancion	00:27:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	149	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2518	t	R06	00:30:20	00:30:20	00:03:20	cancion	00:30:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	150	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2519	t	R06	00:33:40	00:33:40	00:03:00	cancion	00:33:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	151	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2520	t	R06	00:36:40	00:36:40	00:02:40	cancion	00:36:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	152	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2521	t	R06	00:39:20	00:39:20	00:03:20	cancion	00:39:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	153	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2522	t	R06	00:42:40	00:42:40	00:03:00	cancion	00:42:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	154	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2523	t	R06	00:45:40	00:45:40	00:03:20	cancion	00:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	155	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2524	t	R06	00:49:00	00:49:00	00:02:40	cancion	00:49:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	156	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2525	t	R06	00:51:40	00:51:40	00:02:40	cancion	00:51:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	10	157	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2526	t	R06	00:54:20	00:54:20	00:03:20	cancion	00:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	10	158	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2527	t	R06	00:57:40	00:57:40	00:03:00	cancion	00:57:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	10	159	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2528	t	R07	01:00:40	01:00:40	00:03:20	cancion	01:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	160	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2529	t	R07	01:04:00	01:04:00	00:03:20	cancion	01:04:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	161	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2530	t	R07	01:07:20	01:07:20	00:03:00	cancion	01:07:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	11	162	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2531	t	R07	01:10:20	01:10:20	00:03:20	cancion	01:10:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	163	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2532	t	R07	01:13:40	01:13:40	00:02:40	cancion	01:13:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	11	164	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2533	t	R07	01:16:20	01:16:20	00:03:00	cancion	01:16:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	11	165	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2534	t	R07	01:19:20	01:19:20	00:02:40	cancion	01:19:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	11	166	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2535	t	R07	01:22:00	01:22:00	00:03:20	cancion	01:22:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	167	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2536	t	R07	01:25:20	01:25:20	00:03:00	cancion	01:25:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	11	168	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2537	t	R07	01:28:20	01:28:20	00:03:20	cancion	01:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	169	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2538	t	R07	01:31:40	01:31:40	00:03:20	cancion	01:31:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	170	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2539	t	R07	01:35:00	01:35:00	00:03:20	cancion	01:35:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	171	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2540	t	R07	01:38:20	01:38:20	00:02:40	cancion	01:38:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	11	172	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2541	t	R07	01:41:00	01:41:00	00:03:20	cancion	01:41:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	173	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2542	t	R07	01:44:20	01:44:20	00:02:40	cancion	01:44:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	11	174	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2543	t	R07	01:47:00	01:47:00	00:03:00	cancion	01:47:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	11	175	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2544	t	R07	01:50:00	01:50:00	00:03:20	cancion	01:50:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	176	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2545	t	R07	01:53:20	01:53:20	00:03:00	cancion	01:53:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	11	177	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2546	t	R07	01:56:20	01:56:20	00:03:20	cancion	01:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	11	178	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2547	t	R07	01:59:40	01:59:40	00:02:40	cancion	01:59:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	11	179	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2548	t	R08	02:02:20	02:02:20	00:03:20	cancion	02:02:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	12	180	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2549	t	R08	02:05:40	02:05:40	00:03:00	cancion	02:05:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	181	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2550	t	R08	02:08:40	02:08:40	00:02:40	cancion	02:08:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	182	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2551	t	R08	02:11:20	02:11:20	00:03:20	cancion	02:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	12	183	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2552	t	R08	02:14:40	02:14:40	00:03:00	cancion	02:14:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	184	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2553	t	R08	02:17:40	02:17:40	00:02:40	cancion	02:17:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	185	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2554	t	R08	02:20:20	02:20:20	00:02:40	cancion	02:20:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	186	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2555	t	R08	02:23:00	02:23:00	00:03:00	cancion	02:23:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	187	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2556	t	R08	02:26:00	02:26:00	00:03:20	cancion	02:26:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	12	188	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2557	t	R08	02:29:20	02:29:20	00:03:00	cancion	02:29:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	189	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2558	t	R08	02:32:20	02:32:20	00:03:20	cancion	02:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	12	190	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2559	t	R08	02:35:40	02:35:40	00:02:40	cancion	02:35:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	191	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2560	t	R08	02:38:20	02:38:20	00:02:40	cancion	02:38:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	192	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2561	t	R08	02:41:00	02:41:00	00:03:00	cancion	02:41:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	193	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2562	t	R08	02:44:00	02:44:00	00:02:40	cancion	02:44:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	194	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2563	t	R08	02:46:40	02:46:40	00:03:00	cancion	02:46:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	195	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2564	t	R08	02:49:40	02:49:40	00:02:40	cancion	02:49:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	196	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2565	t	R08	02:52:20	02:52:20	00:03:00	cancion	02:52:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	197	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2566	t	R08	02:55:20	02:55:20	00:03:00	cancion	02:55:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	12	198	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2567	t	R08	02:58:20	02:58:20	00:02:40	cancion	02:58:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	12	199	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2568	t	R09	03:01:00	03:01:00	00:02:40	cancion	03:01:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	13	200	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2569	t	R09	03:03:40	03:03:40	00:03:20	cancion	03:03:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	201	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2570	t	R09	03:07:00	03:07:00	00:03:20	cancion	03:07:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	202	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2571	t	R09	03:10:20	03:10:20	00:03:20	cancion	03:10:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	203	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2572	t	R09	03:13:40	03:13:40	00:03:20	cancion	03:13:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	204	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2573	t	R09	03:17:00	03:17:00	00:03:20	cancion	03:17:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	205	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2574	t	R09	03:20:20	03:20:20	00:03:20	cancion	03:20:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	206	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2575	t	R09	03:23:40	03:23:40	00:03:00	cancion	03:23:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	13	207	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2576	t	R09	03:26:40	03:26:40	00:03:00	cancion	03:26:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	13	208	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2577	t	R09	03:29:40	03:29:40	00:02:40	cancion	03:29:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	13	209	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2578	t	R09	03:32:20	03:32:20	00:03:00	cancion	03:32:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	13	210	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2579	t	R09	03:35:20	03:35:20	00:03:20	cancion	03:35:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	211	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2580	t	R09	03:38:40	03:38:40	00:03:20	cancion	03:38:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	212	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2581	t	R09	03:42:00	03:42:00	00:03:20	cancion	03:42:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	213	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2582	t	R09	03:45:20	03:45:20	00:03:20	cancion	03:45:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	214	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2583	t	R09	03:48:40	03:48:40	00:03:20	cancion	03:48:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	215	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2584	t	R09	03:52:00	03:52:00	00:03:20	cancion	03:52:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	216	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2585	t	R09	03:55:20	03:55:20	00:02:40	cancion	03:55:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	13	217	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2586	t	R09	03:58:00	03:58:00	00:03:20	cancion	03:58:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	13	218	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2587	t	R10	04:01:20	04:01:20	00:02:40	cancion	04:01:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	14	220	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2588	t	R10	04:04:00	04:04:00	00:03:00	cancion	04:04:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	14	221	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2589	t	R10	04:07:00	04:07:00	00:02:40	cancion	04:07:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	14	222	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2590	t	R10	04:09:40	04:09:40	00:03:20	cancion	04:09:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	223	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2591	t	R10	04:13:00	04:13:00	00:03:20	cancion	04:13:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	224	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2592	t	R10	04:16:20	04:16:20	00:03:20	cancion	04:16:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	225	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2593	t	R10	04:19:40	04:19:40	00:03:00	cancion	04:19:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	14	226	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2594	t	R10	04:22:40	04:22:40	00:03:20	cancion	04:22:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	227	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2595	t	R10	04:26:00	04:26:00	00:03:20	cancion	04:26:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	228	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2596	t	R10	04:29:20	04:29:20	00:03:20	cancion	04:29:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	229	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2597	t	R10	04:32:40	04:32:40	00:02:40	cancion	04:32:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	14	230	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2598	t	R10	04:35:20	04:35:20	00:03:00	cancion	04:35:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	14	231	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2599	t	R10	04:38:20	04:38:20	00:03:20	cancion	04:38:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	232	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2600	t	R10	04:41:40	04:41:40	00:03:20	cancion	04:41:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	233	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2601	t	R10	04:45:00	04:45:00	00:03:20	cancion	04:45:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	234	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2602	t	R10	04:48:20	04:48:20	00:02:40	cancion	04:48:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	14	235	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2603	t	R10	04:51:00	04:51:00	00:03:20	cancion	04:51:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	236	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2604	t	R10	04:54:20	04:54:20	00:03:20	cancion	04:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	237	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2605	t	R10	04:57:40	04:57:40	00:03:00	cancion	04:57:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	14	238	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2606	t	R10	05:00:40	05:00:40	00:03:20	cancion	05:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	14	239	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2607	t	R11	05:04:00	05:04:00	00:03:20	cancion	05:04:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	240	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2608	t	R11	05:07:20	05:07:20	00:03:20	cancion	05:07:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	241	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2609	t	R11	05:10:40	05:10:40	00:02:40	cancion	05:10:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	15	242	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2610	t	R11	05:13:20	05:13:20	00:03:20	cancion	05:13:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	243	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2611	t	R11	05:16:40	05:16:40	00:03:00	cancion	05:16:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	244	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2612	t	R11	05:19:40	05:19:40	00:03:00	cancion	05:19:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	245	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2613	t	R11	05:22:40	05:22:40	00:03:20	cancion	05:22:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	246	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2614	t	R11	05:26:00	05:26:00	00:02:40	cancion	05:26:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	15	247	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2615	t	R11	05:28:40	05:28:40	00:02:40	cancion	05:28:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	15	248	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2616	t	R11	05:31:20	05:31:20	00:03:00	cancion	05:31:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	249	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2617	t	R11	05:34:20	05:34:20	00:03:00	cancion	05:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	250	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2618	t	R11	05:37:20	05:37:20	00:02:40	cancion	05:37:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	15	251	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2619	t	R11	05:40:00	05:40:00	00:03:00	cancion	05:40:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	252	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2620	t	R11	05:43:00	05:43:00	00:02:40	cancion	05:43:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	15	253	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2621	t	R11	05:45:40	05:45:40	00:03:20	cancion	05:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	254	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2622	t	R11	05:49:00	05:49:00	00:03:20	cancion	05:49:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	255	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2623	t	R11	05:52:20	05:52:20	00:03:20	cancion	05:52:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	256	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2624	t	R11	05:55:40	05:55:40	00:03:00	cancion	05:55:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	15	257	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2625	t	R11	05:58:40	05:58:40	00:03:20	cancion	05:58:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	258	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2626	t	R11	06:02:00	06:02:00	00:03:20	cancion	06:02:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	15	259	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2627	t	R12	06:05:20	06:05:20	00:02:40	cancion	06:05:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	260	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2628	t	R12	06:08:00	06:08:00	00:03:00	cancion	06:08:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	261	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2629	t	R12	06:11:00	06:11:00	00:02:40	cancion	06:11:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	262	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2630	t	R12	06:13:40	06:13:40	00:03:00	cancion	06:13:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	263	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2631	t	R12	06:16:40	06:16:40	00:03:20	cancion	06:16:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	264	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2632	t	R12	06:20:00	06:20:00	00:03:20	cancion	06:20:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	265	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2633	t	R12	06:23:20	06:23:20	00:02:40	cancion	06:23:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	266	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2634	t	R12	06:26:00	06:26:00	00:03:00	cancion	06:26:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	267	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2635	t	R12	06:29:00	06:29:00	00:03:20	cancion	06:29:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	268	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2636	t	R12	06:32:20	06:32:20	00:03:20	cancion	06:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	269	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2637	t	R12	06:35:40	06:35:40	00:02:40	cancion	06:35:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	270	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2638	t	R12	06:38:20	06:38:20	00:02:40	cancion	06:38:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	271	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2639	t	R12	06:41:00	06:41:00	00:03:00	cancion	06:41:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	272	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2640	t	R12	06:44:00	06:44:00	00:03:20	cancion	06:44:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	273	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2641	t	R12	06:47:20	06:47:20	00:03:00	cancion	06:47:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	274	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2642	t	R12	06:50:20	06:50:20	00:02:40	cancion	06:50:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	275	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2643	t	R12	06:53:00	06:53:00	00:03:00	cancion	06:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	16	276	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2644	t	R12	06:56:00	06:56:00	00:03:20	cancion	06:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	277	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2645	t	R12	06:59:20	06:59:20	00:02:40	cancion	06:59:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	16	278	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2646	t	R12	07:02:00	07:02:00	00:03:20	cancion	07:02:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	16	279	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2647	t	R13	07:05:20	07:05:20	00:02:40	cancion	07:05:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	17	280	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2648	t	R13	07:08:00	07:08:00	00:03:00	cancion	07:08:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	17	281	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2649	t	R13	07:11:00	07:11:00	00:03:20	cancion	07:11:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	282	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2650	t	R13	07:14:20	07:14:20	00:03:20	cancion	07:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	283	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2651	t	R13	07:17:40	07:17:40	00:03:00	cancion	07:17:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	17	284	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2652	t	R13	07:20:40	07:20:40	00:02:40	cancion	07:20:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	17	285	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2653	t	R13	07:23:20	07:23:20	00:02:40	cancion	07:23:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	17	286	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2654	t	R13	07:26:00	07:26:00	00:03:20	cancion	07:26:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	287	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2655	t	R13	07:29:20	07:29:20	00:03:20	cancion	07:29:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	288	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2656	t	R13	07:32:40	07:32:40	00:03:20	cancion	07:32:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	289	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2657	t	R13	07:36:00	07:36:00	00:03:20	cancion	07:36:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	290	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2658	t	R13	07:39:20	07:39:20	00:03:20	cancion	07:39:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	291	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2659	t	R13	07:42:40	07:42:40	00:03:20	cancion	07:42:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	292	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2660	t	R13	07:46:00	07:46:00	00:03:20	cancion	07:46:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	293	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2661	t	R13	07:49:20	07:49:20	00:03:20	cancion	07:49:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	294	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2662	t	R13	07:52:40	07:52:40	00:03:20	cancion	07:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	295	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2663	t	R13	07:56:00	07:56:00	00:03:20	cancion	07:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	296	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2664	t	R13	07:59:20	07:59:20	00:03:00	cancion	07:59:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	17	297	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2665	t	R13	08:02:20	08:02:20	00:03:20	cancion	08:02:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	17	298	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2666	t	R14	08:05:40	08:05:40	00:02:40	cancion	08:05:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	300	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2667	t	R14	08:08:20	08:08:20	00:03:00	cancion	08:08:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	18	301	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2668	t	R14	08:11:20	08:11:20	00:03:00	cancion	08:11:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	18	302	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2669	t	R14	08:14:20	08:14:20	00:02:40	cancion	08:14:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	303	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2670	t	R14	08:17:00	08:17:00	00:03:00	cancion	08:17:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	18	304	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2671	t	R14	08:20:00	08:20:00	00:02:40	cancion	08:20:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	305	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2672	t	R14	08:22:40	08:22:40	00:03:20	cancion	08:22:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	306	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2673	t	R14	08:26:00	08:26:00	00:03:20	cancion	08:26:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	307	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2674	t	R14	08:29:20	08:29:20	00:03:00	cancion	08:29:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	18	308	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2675	t	R14	08:32:20	08:32:20	00:03:20	cancion	08:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	309	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2676	t	R14	08:35:40	08:35:40	00:03:20	cancion	08:35:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	310	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2677	t	R14	08:39:00	08:39:00	00:03:20	cancion	08:39:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	311	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2678	t	R14	08:42:20	08:42:20	00:02:40	cancion	08:42:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	312	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2679	t	R14	08:45:00	08:45:00	00:03:20	cancion	08:45:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	313	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2680	t	R14	08:48:20	08:48:20	00:03:20	cancion	08:48:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	314	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2681	t	R14	08:51:40	08:51:40	00:02:40	cancion	08:51:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	315	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2682	t	R14	08:54:20	08:54:20	00:03:20	cancion	08:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	316	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2683	t	R14	08:57:40	08:57:40	00:03:00	cancion	08:57:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	18	317	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2684	t	R14	09:00:40	09:00:40	00:03:20	cancion	09:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	18	318	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2685	t	R14	09:04:00	09:04:00	00:02:40	cancion	09:04:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	18	319	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2686	t	R15	09:06:40	09:06:40	00:03:00	cancion	09:06:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	19	320	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2687	t	R15	09:09:40	09:09:40	00:03:20	cancion	09:09:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	321	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2688	t	R15	09:13:00	09:13:00	00:03:20	cancion	09:13:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	322	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2689	t	R15	09:16:20	09:16:20	00:02:40	cancion	09:16:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	19	323	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2690	t	R15	09:19:00	09:19:00	00:03:20	cancion	09:19:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	324	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2691	t	R15	09:22:20	09:22:20	00:03:20	cancion	09:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	325	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2692	t	R15	09:25:40	09:25:40	00:03:20	cancion	09:25:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	326	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2693	t	R15	09:29:00	09:29:00	00:03:20	cancion	09:29:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	327	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2694	t	R15	09:32:20	09:32:20	00:03:20	cancion	09:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	328	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2695	t	R15	09:35:40	09:35:40	00:03:00	cancion	09:35:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	19	329	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2696	t	R15	09:38:40	09:38:40	00:02:40	cancion	09:38:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	19	330	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2697	t	R15	09:41:20	09:41:20	00:03:00	cancion	09:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	19	331	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2698	t	R15	09:44:20	09:44:20	00:03:00	cancion	09:44:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	19	332	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2699	t	R15	09:47:20	09:47:20	00:03:20	cancion	09:47:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	333	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2700	t	R15	09:50:40	09:50:40	00:03:20	cancion	09:50:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	334	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2701	t	R15	09:54:00	09:54:00	00:03:20	cancion	09:54:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	335	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2702	t	R15	09:57:20	09:57:20	00:02:40	cancion	09:57:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	19	336	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2703	t	R15	10:00:00	10:00:00	00:03:20	cancion	10:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	337	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2704	t	R15	10:03:20	10:03:20	00:02:40	cancion	10:03:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	19	338	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2705	t	R15	10:06:00	10:06:00	00:03:20	cancion	10:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	19	339	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2706	t	R16	10:09:20	10:09:20	00:03:00	cancion	10:09:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	340	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2707	t	R16	10:12:20	10:12:20	00:03:20	cancion	10:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	341	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2708	t	R16	10:15:40	10:15:40	00:03:20	cancion	10:15:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	342	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2709	t	R16	10:19:00	10:19:00	00:03:20	cancion	10:19:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	343	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2710	t	R16	10:22:20	10:22:20	00:02:40	cancion	10:22:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	20	344	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2711	t	R16	10:25:00	10:25:00	00:03:00	cancion	10:25:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	345	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2712	t	R16	10:28:00	10:28:00	00:03:00	cancion	10:28:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	346	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2713	t	R16	10:31:00	10:31:00	00:03:20	cancion	10:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	347	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2714	t	R16	10:34:20	10:34:20	00:02:40	cancion	10:34:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	20	348	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2715	t	R16	10:37:00	10:37:00	00:03:20	cancion	10:37:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	349	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2716	t	R16	10:40:20	10:40:20	00:02:40	cancion	10:40:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	20	350	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2717	t	R16	10:43:00	10:43:00	00:03:20	cancion	10:43:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	351	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2718	t	R16	10:46:20	10:46:20	00:03:20	cancion	10:46:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	352	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2719	t	R16	10:49:40	10:49:40	00:03:20	cancion	10:49:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	353	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2720	t	R16	10:53:00	10:53:00	00:03:00	cancion	10:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	354	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2721	t	R16	10:56:00	10:56:00	00:03:00	cancion	10:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	355	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2722	t	R16	10:59:00	10:59:00	00:03:20	cancion	10:59:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	356	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2723	t	R16	11:02:20	11:02:20	00:02:40	cancion	11:02:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-30	20	357	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2724	t	R16	11:05:00	11:05:00	00:03:00	cancion	11:05:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-30	20	358	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
2725	t	R16	11:08:00	11:08:00	00:03:20	cancion	11:08:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-30	20	359	7	2025-10-21 03:01:23.937336+00	2025-10-21 03:01:23.937336+00
1548	t	R05	01:48:40	01:48:40	00:03:00	cancion	01:48:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	9	135	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1549	t	R05	01:51:40	01:51:40	00:03:20	cancion	01:51:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	136	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1550	t	R05	01:55:00	01:55:00	00:02:40	cancion	01:55:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	9	137	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1551	t	R05	01:57:40	01:57:40	00:03:00	cancion	01:57:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	9	138	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1552	t	R05	02:00:40	02:00:40	00:03:20	cancion	02:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	9	139	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1553	t	R06	02:04:00	02:04:00	00:03:20	cancion	02:04:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	140	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1554	t	R06	02:07:20	02:07:20	00:03:20	cancion	02:07:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	141	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1555	t	R06	02:10:40	02:10:40	00:02:40	cancion	02:10:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	10	142	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1556	t	R06	02:13:20	02:13:20	00:02:40	cancion	02:13:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	10	143	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1557	t	R06	02:16:00	02:16:00	00:03:20	cancion	02:16:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	144	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1558	t	R06	02:19:20	02:19:20	00:03:00	cancion	02:19:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	10	145	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1559	t	R06	02:22:20	02:22:20	00:03:20	cancion	02:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	146	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1560	t	R06	02:25:40	02:25:40	00:03:20	cancion	02:25:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	147	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1561	t	R06	02:29:00	02:29:00	00:02:40	cancion	02:29:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	10	148	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1562	t	R06	02:31:40	02:31:40	00:03:20	cancion	02:31:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	149	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1563	t	R06	02:35:00	02:35:00	00:03:20	cancion	02:35:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	150	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1564	t	R06	02:38:20	02:38:20	00:03:20	cancion	02:38:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	151	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1565	t	R06	02:41:40	02:41:40	00:03:00	cancion	02:41:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	10	152	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1566	t	R06	02:44:40	02:44:40	00:03:20	cancion	02:44:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	153	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1567	t	R06	02:48:00	02:48:00	00:02:40	cancion	02:48:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	10	154	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1568	t	R06	02:50:40	02:50:40	00:03:20	cancion	02:50:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	155	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1569	t	R06	02:54:00	02:54:00	00:03:20	cancion	02:54:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	10	156	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1570	t	R06	02:57:20	02:57:20	00:03:00	cancion	02:57:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	10	157	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1571	t	R06	03:00:20	03:00:20	00:02:40	cancion	03:00:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	10	158	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1572	t	R06	03:03:00	03:03:00	00:03:00	cancion	03:03:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	10	159	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1573	t	R07	03:06:00	03:06:00	00:03:00	cancion	03:06:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	11	160	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1574	t	R07	03:09:00	03:09:00	00:02:40	cancion	03:09:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	11	161	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1575	t	R07	03:11:40	03:11:40	00:02:40	cancion	03:11:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	11	162	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1576	t	R07	03:14:20	03:14:20	00:03:20	cancion	03:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	163	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1577	t	R07	03:17:40	03:17:40	00:03:20	cancion	03:17:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	164	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1578	t	R07	03:21:00	03:21:00	00:03:20	cancion	03:21:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	165	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1579	t	R07	03:24:20	03:24:20	00:03:20	cancion	03:24:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	166	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1580	t	R07	03:27:40	03:27:40	00:03:20	cancion	03:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	167	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1581	t	R07	03:31:00	03:31:00	00:03:00	cancion	03:31:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	11	168	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1582	t	R07	03:34:00	03:34:00	00:03:20	cancion	03:34:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	169	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1583	t	R07	03:37:20	03:37:20	00:03:20	cancion	03:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	170	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1584	t	R07	03:40:40	03:40:40	00:03:20	cancion	03:40:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	171	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1585	t	R07	03:44:00	03:44:00	00:02:40	cancion	03:44:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	11	172	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1586	t	R07	03:46:40	03:46:40	00:03:00	cancion	03:46:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	11	173	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1587	t	R07	03:49:40	03:49:40	00:03:00	cancion	03:49:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	11	174	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1588	t	R07	03:52:40	03:52:40	00:03:20	cancion	03:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	175	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1589	t	R07	03:56:00	03:56:00	00:03:20	cancion	03:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	176	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1590	t	R07	03:59:20	03:59:20	00:03:20	cancion	03:59:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	11	177	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1591	t	R07	04:02:40	04:02:40	00:02:40	cancion	04:02:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	11	178	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1592	t	R07	04:05:20	04:05:20	00:03:00	cancion	04:05:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	11	179	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1593	t	R08	04:08:20	04:08:20	00:02:40	cancion	04:08:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	180	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1594	t	R08	04:11:00	04:11:00	00:02:40	cancion	04:11:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	181	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1595	t	R08	04:13:40	04:13:40	00:03:00	cancion	04:13:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	12	182	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1596	t	R08	04:16:40	04:16:40	00:03:00	cancion	04:16:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	12	183	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1597	t	R08	04:19:40	04:19:40	00:02:40	cancion	04:19:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	184	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1598	t	R08	04:22:20	04:22:20	00:03:20	cancion	04:22:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	185	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1599	t	R08	04:25:40	04:25:40	00:03:00	cancion	04:25:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	12	186	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1600	t	R08	04:28:40	04:28:40	00:03:20	cancion	04:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	187	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1601	t	R08	04:32:00	04:32:00	00:02:40	cancion	04:32:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	188	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1602	t	R08	04:34:40	04:34:40	00:02:40	cancion	04:34:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	189	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1603	t	R08	04:37:20	04:37:20	00:03:20	cancion	04:37:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	190	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1604	t	R08	04:40:40	04:40:40	00:03:00	cancion	04:40:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	12	191	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1605	t	R08	04:43:40	04:43:40	00:03:20	cancion	04:43:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	192	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1606	t	R08	04:47:00	04:47:00	00:03:20	cancion	04:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	193	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1607	t	R08	04:50:20	04:50:20	00:03:00	cancion	04:50:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	12	194	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1608	t	R08	04:53:20	04:53:20	00:03:20	cancion	04:53:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	195	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1609	t	R08	04:56:40	04:56:40	00:03:20	cancion	04:56:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	196	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1610	t	R08	05:00:00	05:00:00	00:03:20	cancion	05:00:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	197	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1611	t	R08	05:03:20	05:03:20	00:03:20	cancion	05:03:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	12	198	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1612	t	R08	05:06:40	05:06:40	00:02:40	cancion	05:06:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	12	199	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1613	t	R09	05:09:20	05:09:20	00:03:20	cancion	05:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	200	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1614	t	R09	05:12:40	05:12:40	00:03:00	cancion	05:12:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	13	201	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1615	t	R09	05:15:40	05:15:40	00:02:40	cancion	05:15:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	13	202	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1616	t	R09	05:18:20	05:18:20	00:03:20	cancion	05:18:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	203	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1617	t	R09	05:21:40	05:21:40	00:02:40	cancion	05:21:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	13	204	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1618	t	R09	05:24:20	05:24:20	00:03:20	cancion	05:24:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	205	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1619	t	R09	05:27:40	05:27:40	00:03:00	cancion	05:27:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	13	206	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1620	t	R09	05:30:40	05:30:40	00:02:40	cancion	05:30:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	13	207	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1621	t	R09	05:33:20	05:33:20	00:03:20	cancion	05:33:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	208	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1622	t	R09	05:36:40	05:36:40	00:03:20	cancion	05:36:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	209	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1623	t	R09	05:40:00	05:40:00	00:03:20	cancion	05:40:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	210	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1624	t	R09	05:43:20	05:43:20	00:03:20	cancion	05:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	211	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1625	t	R09	05:46:40	05:46:40	00:03:20	cancion	05:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	212	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1626	t	R09	05:50:00	05:50:00	00:03:00	cancion	05:50:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	13	213	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1627	t	R09	05:53:00	05:53:00	00:02:40	cancion	05:53:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	13	214	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1628	t	R09	05:55:40	05:55:40	00:03:20	cancion	05:55:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	215	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1629	t	R09	05:59:00	05:59:00	00:03:20	cancion	05:59:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	216	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1630	t	R09	06:02:20	06:02:20	00:03:00	cancion	06:02:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	13	217	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1631	t	R09	06:05:20	06:05:20	00:03:20	cancion	06:05:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	218	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1632	t	R09	06:08:40	06:08:40	00:03:20	cancion	06:08:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	13	219	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1633	t	R10	06:12:00	06:12:00	00:03:20	cancion	06:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	220	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1634	t	R10	06:15:20	06:15:20	00:03:20	cancion	06:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	221	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1635	t	R10	06:18:40	06:18:40	00:03:20	cancion	06:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	222	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1636	t	R10	06:22:00	06:22:00	00:03:00	cancion	06:22:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	223	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1637	t	R10	06:25:00	06:25:00	00:03:20	cancion	06:25:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	224	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1638	t	R10	06:28:20	06:28:20	00:02:40	cancion	06:28:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	225	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1639	t	R10	06:31:00	06:31:00	00:02:40	cancion	06:31:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	226	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1640	t	R10	06:33:40	06:33:40	00:03:00	cancion	06:33:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	227	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1641	t	R10	06:36:40	06:36:40	00:03:00	cancion	06:36:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	228	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1642	t	R10	06:39:40	06:39:40	00:02:40	cancion	06:39:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	229	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1643	t	R10	06:42:20	06:42:20	00:02:40	cancion	06:42:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	230	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1644	t	R10	06:45:00	06:45:00	00:03:00	cancion	06:45:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	231	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1645	t	R10	06:48:00	06:48:00	00:03:20	cancion	06:48:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	232	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1646	t	R10	06:51:20	06:51:20	00:02:40	cancion	06:51:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	233	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1647	t	R10	06:54:00	06:54:00	00:03:20	cancion	06:54:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	14	234	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1648	t	R10	06:57:20	06:57:20	00:03:00	cancion	06:57:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	235	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1649	t	R10	07:00:20	07:00:20	00:02:40	cancion	07:00:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	236	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1650	t	R10	07:03:00	07:03:00	00:03:00	cancion	07:03:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	237	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1651	t	R10	07:06:00	07:06:00	00:03:00	cancion	07:06:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	14	238	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1652	t	R10	07:09:00	07:09:00	00:02:40	cancion	07:09:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	14	239	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1653	t	R11	07:11:40	07:11:40	00:02:40	cancion	07:11:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	15	240	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1654	t	R11	07:14:20	07:14:20	00:03:20	cancion	07:14:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	241	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1655	t	R11	07:17:40	07:17:40	00:03:00	cancion	07:17:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	15	242	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1656	t	R11	07:20:40	07:20:40	00:03:20	cancion	07:20:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	243	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1657	t	R11	07:24:00	07:24:00	00:03:20	cancion	07:24:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	244	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1658	t	R11	07:27:20	07:27:20	00:02:40	cancion	07:27:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	15	245	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1659	t	R11	07:30:00	07:30:00	00:03:20	cancion	07:30:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	246	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1660	t	R11	07:33:20	07:33:20	00:03:20	cancion	07:33:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	247	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1661	t	R11	07:36:40	07:36:40	00:03:20	cancion	07:36:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	248	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1662	t	R11	07:40:00	07:40:00	00:03:20	cancion	07:40:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	249	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1663	t	R11	07:43:20	07:43:20	00:03:20	cancion	07:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	250	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1664	t	R11	07:46:40	07:46:40	00:03:00	cancion	07:46:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	15	251	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1665	t	R11	07:49:40	07:49:40	00:03:20	cancion	07:49:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	252	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1666	t	R11	07:53:00	07:53:00	00:03:20	cancion	07:53:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	253	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1667	t	R11	07:56:20	07:56:20	00:03:20	cancion	07:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	254	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1668	t	R11	07:59:40	07:59:40	00:03:00	cancion	07:59:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	15	255	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1669	t	R11	08:02:40	08:02:40	00:03:20	cancion	08:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	256	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1670	t	R11	08:06:00	08:06:00	00:03:20	cancion	08:06:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	257	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1671	t	R11	08:09:20	08:09:20	00:03:20	cancion	08:09:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	15	258	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1672	t	R12	08:12:40	08:12:40	00:02:40	cancion	08:12:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	16	260	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1673	t	R12	08:15:20	08:15:20	00:03:20	cancion	08:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	261	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1674	t	R12	08:18:40	08:18:40	00:03:20	cancion	08:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	262	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1675	t	R12	08:22:00	08:22:00	00:03:20	cancion	08:22:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	263	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1676	t	R12	08:25:20	08:25:20	00:03:20	cancion	08:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	264	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1677	t	R12	08:28:40	08:28:40	00:03:20	cancion	08:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	265	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1678	t	R12	08:32:00	08:32:00	00:02:40	cancion	08:32:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	16	266	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1679	t	R12	08:34:40	08:34:40	00:03:00	cancion	08:34:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	16	267	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1680	t	R12	08:37:40	08:37:40	00:03:20	cancion	08:37:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	268	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1681	t	R12	08:41:00	08:41:00	00:03:20	cancion	08:41:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	269	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1682	t	R12	08:44:20	08:44:20	00:02:40	cancion	08:44:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	16	270	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1683	t	R12	08:47:00	08:47:00	00:03:20	cancion	08:47:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	271	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1684	t	R12	08:50:20	08:50:20	00:03:00	cancion	08:50:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	16	272	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1685	t	R12	08:53:20	08:53:20	00:03:20	cancion	08:53:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	273	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1686	t	R12	08:56:40	08:56:40	00:03:00	cancion	08:56:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	16	274	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1687	t	R12	08:59:40	08:59:40	00:03:20	cancion	08:59:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	275	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1688	t	R12	09:03:00	09:03:00	00:03:20	cancion	09:03:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	276	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1689	t	R12	09:06:20	09:06:20	00:02:40	cancion	09:06:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	16	277	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1690	t	R12	09:09:00	09:09:00	00:02:40	cancion	09:09:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	16	278	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1691	t	R12	09:11:40	09:11:40	00:03:20	cancion	09:11:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	16	279	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1692	t	R13	09:15:00	09:15:00	00:03:00	cancion	09:15:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	280	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1693	t	R13	09:18:00	09:18:00	00:03:00	cancion	09:18:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	281	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1694	t	R13	09:21:00	09:21:00	00:03:20	cancion	09:21:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	282	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1695	t	R13	09:24:20	09:24:20	00:02:40	cancion	09:24:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	17	283	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1696	t	R13	09:27:00	09:27:00	00:02:40	cancion	09:27:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	17	284	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1697	t	R13	09:29:40	09:29:40	00:03:20	cancion	09:29:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	285	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1698	t	R13	09:33:00	09:33:00	00:03:20	cancion	09:33:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	286	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1699	t	R13	09:36:20	09:36:20	00:03:00	cancion	09:36:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	287	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1700	t	R13	09:39:20	09:39:20	00:03:00	cancion	09:39:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	288	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1701	t	R13	09:42:20	09:42:20	00:02:40	cancion	09:42:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	17	289	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1702	t	R13	09:45:00	09:45:00	00:02:40	cancion	09:45:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	17	290	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1703	t	R13	09:47:40	09:47:40	00:03:00	cancion	09:47:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	291	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1704	t	R13	09:50:40	09:50:40	00:03:20	cancion	09:50:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	292	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1705	t	R13	09:54:00	09:54:00	00:03:20	cancion	09:54:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	293	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1706	t	R13	09:57:20	09:57:20	00:03:20	cancion	09:57:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	294	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1707	t	R13	10:00:40	10:00:40	00:03:00	cancion	10:00:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	295	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1708	t	R13	10:03:40	10:03:40	00:02:40	cancion	10:03:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	17	296	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1709	t	R13	10:06:20	10:06:20	00:03:20	cancion	10:06:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	297	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1710	t	R13	10:09:40	10:09:40	00:03:00	cancion	10:09:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	17	298	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1711	t	R13	10:12:40	10:12:40	00:03:20	cancion	10:12:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	17	299	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1712	t	R14	10:16:00	10:16:00	00:02:40	cancion	10:16:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	300	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1713	t	R14	10:18:40	10:18:40	00:02:40	cancion	10:18:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	301	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1714	t	R14	10:21:20	10:21:20	00:03:20	cancion	10:21:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	302	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1715	t	R14	10:24:40	10:24:40	00:03:20	cancion	10:24:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	303	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1716	t	R14	10:28:00	10:28:00	00:03:00	cancion	10:28:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	18	304	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1717	t	R14	10:31:00	10:31:00	00:03:20	cancion	10:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	305	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1718	t	R14	10:34:20	10:34:20	00:03:20	cancion	10:34:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	306	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1719	t	R14	10:37:40	10:37:40	00:02:40	cancion	10:37:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	307	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1720	t	R14	10:40:20	10:40:20	00:03:00	cancion	10:40:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	18	308	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1721	t	R14	10:43:20	10:43:20	00:03:20	cancion	10:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	309	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1722	t	R14	10:46:40	10:46:40	00:03:20	cancion	10:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	310	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1723	t	R14	10:50:00	10:50:00	00:02:40	cancion	10:50:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	311	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1724	t	R14	10:52:40	10:52:40	00:03:20	cancion	10:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	312	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1725	t	R14	10:56:00	10:56:00	00:03:20	cancion	10:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	313	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1726	t	R14	10:59:20	10:59:20	00:03:00	cancion	10:59:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	18	314	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1727	t	R14	11:02:20	11:02:20	00:03:20	cancion	11:02:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	18	315	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1728	t	R14	11:05:40	11:05:40	00:02:40	cancion	11:05:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	316	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1729	t	R14	11:08:20	11:08:20	00:03:00	cancion	11:08:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	18	317	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1730	t	R14	11:11:20	11:11:20	00:03:00	cancion	11:11:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	18	318	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1731	t	R14	11:14:20	11:14:20	00:02:40	cancion	11:14:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	18	319	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1732	t	R15	11:17:00	11:17:00	00:02:40	cancion	11:17:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	320	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1733	t	R15	11:19:40	11:19:40	00:03:00	cancion	11:19:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	321	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1734	t	R15	11:22:40	11:22:40	00:02:40	cancion	11:22:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	322	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1735	t	R15	11:25:20	11:25:20	00:03:00	cancion	11:25:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	323	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1736	t	R15	11:28:20	11:28:20	00:02:40	cancion	11:28:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	324	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1737	t	R15	11:31:00	11:31:00	00:03:00	cancion	11:31:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	325	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1738	t	R15	11:34:00	11:34:00	00:03:00	cancion	11:34:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	326	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1739	t	R15	11:37:00	11:37:00	00:02:40	cancion	11:37:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	327	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1740	t	R15	11:39:40	11:39:40	00:03:00	cancion	11:39:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	328	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1741	t	R15	11:42:40	11:42:40	00:03:20	cancion	11:42:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	329	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1742	t	R15	11:46:00	11:46:00	00:03:20	cancion	11:46:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	330	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1743	t	R15	11:49:20	11:49:20	00:02:40	cancion	11:49:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	331	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1744	t	R15	11:52:00	11:52:00	00:02:40	cancion	11:52:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	332	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1745	t	R15	11:54:40	11:54:40	00:03:20	cancion	11:54:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	333	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1746	t	R15	11:58:00	11:58:00	00:03:00	cancion	11:58:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	334	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1747	t	R15	12:01:00	12:01:00	00:03:20	cancion	12:01:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	335	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1748	t	R15	12:04:20	12:04:20	00:03:20	cancion	12:04:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	336	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1749	t	R15	12:07:40	12:07:40	00:03:00	cancion	12:07:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	19	337	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1750	t	R15	12:10:40	12:10:40	00:03:20	cancion	12:10:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	19	338	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1751	t	R15	12:14:00	12:14:00	00:02:40	cancion	12:14:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	19	339	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1752	t	R16	12:16:40	12:16:40	00:03:20	cancion	12:16:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	340	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1753	t	R16	12:20:00	12:20:00	00:03:00	cancion	12:20:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	20	341	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1754	t	R16	12:23:00	12:23:00	00:03:20	cancion	12:23:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	342	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1755	t	R16	12:26:20	12:26:20	00:03:20	cancion	12:26:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	343	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1756	t	R16	12:29:40	12:29:40	00:03:20	cancion	12:29:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	344	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1757	t	R16	12:33:00	12:33:00	00:03:20	cancion	12:33:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	345	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1758	t	R16	12:36:20	12:36:20	00:02:40	cancion	12:36:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	20	346	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1759	t	R16	12:39:00	12:39:00	00:03:20	cancion	12:39:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	347	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1760	t	R16	12:42:20	12:42:20	00:03:00	cancion	12:42:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	20	348	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1761	t	R16	12:45:20	12:45:20	00:03:20	cancion	12:45:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	349	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1762	t	R16	12:48:40	12:48:40	00:03:20	cancion	12:48:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	350	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1763	t	R16	12:52:00	12:52:00	00:02:40	cancion	12:52:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	20	351	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1764	t	R16	12:54:40	12:54:40	00:03:00	cancion	12:54:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	20	352	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1765	t	R16	12:57:40	12:57:40	00:03:20	cancion	12:57:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	353	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1766	t	R16	13:01:00	13:01:00	00:02:40	cancion	13:01:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	20	354	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1767	t	R16	13:03:40	13:03:40	00:03:20	cancion	13:03:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	355	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1768	t	R16	13:07:00	13:07:00	00:03:20	cancion	13:07:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	356	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1769	t	R16	13:10:20	13:10:20	00:03:20	cancion	13:10:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	20	357	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1770	t	R16	13:13:40	13:13:40	00:03:00	cancion	13:13:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	20	358	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1771	t	R17	13:16:40	13:16:40	00:02:40	cancion	13:16:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	21	360	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1772	t	R17	13:19:20	13:19:20	00:03:20	cancion	13:19:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	361	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1773	t	R17	13:22:40	13:22:40	00:03:20	cancion	13:22:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	362	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1774	t	R17	13:26:00	13:26:00	00:03:20	cancion	13:26:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	363	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1775	t	R17	13:29:20	13:29:20	00:03:00	cancion	13:29:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	21	364	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1776	t	R17	13:32:20	13:32:20	00:03:20	cancion	13:32:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	365	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1777	t	R17	13:35:40	13:35:40	00:03:20	cancion	13:35:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	366	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1778	t	R17	13:39:00	13:39:00	00:03:20	cancion	13:39:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	367	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1779	t	R17	13:42:20	13:42:20	00:03:20	cancion	13:42:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	368	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1780	t	R17	13:45:40	13:45:40	00:02:40	cancion	13:45:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	21	369	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1781	t	R17	13:48:20	13:48:20	00:03:20	cancion	13:48:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	370	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1782	t	R17	13:51:40	13:51:40	00:03:20	cancion	13:51:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	371	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1783	t	R17	13:55:00	13:55:00	00:03:00	cancion	13:55:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	21	372	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1784	t	R17	13:58:00	13:58:00	00:02:40	cancion	13:58:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	21	373	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1785	t	R17	14:00:40	14:00:40	00:03:00	cancion	14:00:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	21	374	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1786	t	R17	14:03:40	14:03:40	00:03:20	cancion	14:03:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	375	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1787	t	R17	14:07:00	14:07:00	00:02:40	cancion	14:07:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	21	376	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1788	t	R17	14:09:40	14:09:40	00:02:40	cancion	14:09:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	21	377	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1789	t	R17	14:12:20	14:12:20	00:03:00	cancion	14:12:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	21	378	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1790	t	R17	14:15:20	14:15:20	00:03:20	cancion	14:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	21	379	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1791	t	R18	14:18:40	14:18:40	00:03:00	cancion	14:18:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	380	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1792	t	R18	14:21:40	14:21:40	00:03:20	cancion	14:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	381	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1793	t	R18	14:25:00	14:25:00	00:03:20	cancion	14:25:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	382	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1794	t	R18	14:28:20	14:28:20	00:03:20	cancion	14:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	383	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1795	t	R18	14:31:40	14:31:40	00:02:40	cancion	14:31:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	384	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1796	t	R18	14:34:20	14:34:20	00:03:00	cancion	14:34:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	385	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1797	t	R18	14:37:20	14:37:20	00:02:40	cancion	14:37:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	386	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1798	t	R18	14:40:00	14:40:00	00:03:20	cancion	14:40:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	387	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1799	t	R18	14:43:20	14:43:20	00:03:20	cancion	14:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	388	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1800	t	R18	14:46:40	14:46:40	00:03:20	cancion	14:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	389	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1801	t	R18	14:50:00	14:50:00	00:03:00	cancion	14:50:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	390	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1802	t	R18	14:53:00	14:53:00	00:02:40	cancion	14:53:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	391	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1803	t	R18	14:55:40	14:55:40	00:03:00	cancion	14:55:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	392	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1804	t	R18	14:58:40	14:58:40	00:02:40	cancion	14:58:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	393	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1805	t	R18	15:01:20	15:01:20	00:03:20	cancion	15:01:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	394	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1806	t	R18	15:04:40	15:04:40	00:03:00	cancion	15:04:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	395	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1807	t	R18	15:07:40	15:07:40	00:02:40	cancion	15:07:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	396	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1808	t	R18	15:10:20	15:10:20	00:03:00	cancion	15:10:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	TEST1	5	2025-10-17	22	397	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1809	t	R18	15:13:20	15:13:20	00:03:20	cancion	15:13:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	5	2025-10-17	22	398	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
1810	t	R18	15:16:40	15:16:40	00:02:40	cancion	15:16:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	TEST1	5	2025-10-17	22	399	6	2025-10-17 22:44:04.361541+00	2025-10-17 22:44:04.361541+00
\.


--
-- Data for Name: reglas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reglas (id, set_regla_id, nombre, descripcion, tipo, parametros, habilitada, orden, created_at) FROM stdin;
1	1	Regla de Rotación	Regla para rotar canciones	rotacion	{"intervalo": 24, "categorias": ["pop", "rock"]}	t	1	2025-10-17 22:27:07.984043+00
2	1	Regla de Separación	Separar canciones similares	separacion	{"minutos": 30, "categorias": ["pop"]}	t	2	2025-10-17 22:27:07.984043+00
3	2	Regla de Eventos	Regla para eventos especiales	eventos	{"prioridad": "alta", "duracion_max": 300}	t	1	2025-10-17 22:27:07.984043+00
\.


--
-- Data for Name: relojes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.relojes (id, habilitado, clave, grupo, numero_regla, nombre, numero_eventos, duracion, con_evento, politica_id, created_at) FROM stdin;
1	t	DOMINGO_23_52	Grupo A	001	DOMINGO 23.52	8	00:24:00	t	1	2025-10-17 22:27:07.969052+00
2	t	LUNES_06_00	Grupo B	002	LUNES 06.00	6	00:18:00	t	1	2025-10-17 22:27:07.969052+00
3	t	MARTES_12_30	Grupo A	003	MARTES 12.30	5	00:15:00	t	1	2025-10-17 22:27:07.969052+00
5	t	R01	\N	\N	Reloj 01:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
6	t	R02	\N	\N	Reloj 02:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
7	t	R03	\N	\N	Reloj 03:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
8	t	R04	\N	\N	Reloj 04:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
9	t	R05	\N	\N	Reloj 05:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
10	t	R06	\N	\N	Reloj 06:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
11	t	R07	\N	\N	Reloj 07:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
12	t	R08	\N	\N	Reloj 08:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
13	t	R09	\N	\N	Reloj 09:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
14	t	R10	\N	\N	Reloj 10:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
15	t	R11	\N	\N	Reloj 11:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
16	t	R12	\N	\N	Reloj 12:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
17	t	R13	\N	\N	Reloj 13:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
18	t	R14	\N	\N	Reloj 14:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
19	t	R15	\N	\N	Reloj 15:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
20	t	R16	\N	\N	Reloj 16:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
21	t	R17	\N	\N	Reloj 17:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
22	t	R18	\N	\N	Reloj 18:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
23	t	R19	\N	\N	Reloj 19:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
24	t	R20	\N	\N	Reloj 20:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
25	t	R21	\N	\N	Reloj 21:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
26	t	R22	\N	\N	Reloj 22:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
27	t	R23	\N	\N	Reloj 23:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00
28	t	General	\N	\N	Política General	17	01:01:01	f	3	2025-10-21 01:27:20.636447+00
4	t	R00	\N	\N	Reloj 00:00	20	01:00:00	f	5	2025-10-17 22:27:11.200568+00
29	t	TEST_RELOJ_1	\N	\N	Reloj de Prueba	0	01:00:00	f	2	2025-10-21 02:10:25.386909+00
30	t	asdasd	\N	\N	asdasd	18	01:00:00	f	2	2025-10-21 02:11:05.888231+00
\.


--
-- Data for Name: relojes_dia_modelo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.relojes_dia_modelo (id, dia_modelo_id, reloj_id, orden, created_at) FROM stdin;
1	1	2	1	2025-10-17 22:27:07.980834+00
2	1	3	2	2025-10-17 22:27:07.980834+00
3	2	1	1	2025-10-17 22:27:07.980834+00
4	3	1	1	2025-10-17 22:27:07.980834+00
5	3	2	2	2025-10-17 22:27:07.980834+00
6	3	3	3	2025-10-17 22:27:07.980834+00
109	5	6	1	2025-10-17 22:42:24.506751+00
110	5	7	2	2025-10-17 22:42:24.506751+00
111	5	8	3	2025-10-17 22:42:24.506751+00
112	5	9	4	2025-10-17 22:42:24.506751+00
113	5	10	5	2025-10-17 22:42:24.506751+00
114	5	11	6	2025-10-17 22:42:24.506751+00
115	5	12	7	2025-10-17 22:42:24.506751+00
116	5	13	8	2025-10-17 22:42:24.506751+00
117	5	14	9	2025-10-17 22:42:24.506751+00
118	5	15	10	2025-10-17 22:42:24.506751+00
119	5	16	11	2025-10-17 22:42:24.506751+00
120	5	17	12	2025-10-17 22:42:24.506751+00
121	5	18	13	2025-10-17 22:42:24.506751+00
122	6	8	1	2025-10-17 22:42:24.512787+00
123	6	9	2	2025-10-17 22:42:24.512787+00
124	6	10	3	2025-10-17 22:42:24.512787+00
125	6	11	4	2025-10-17 22:42:24.512787+00
126	6	12	5	2025-10-17 22:42:24.512787+00
127	6	13	6	2025-10-17 22:42:24.512787+00
128	6	14	7	2025-10-17 22:42:24.512787+00
129	6	15	8	2025-10-17 22:42:24.512787+00
130	6	16	9	2025-10-17 22:42:24.512787+00
131	6	17	10	2025-10-17 22:42:24.512787+00
132	6	18	11	2025-10-17 22:42:24.512787+00
133	6	19	12	2025-10-17 22:42:24.512787+00
134	6	20	13	2025-10-17 22:42:24.512787+00
135	6	21	14	2025-10-17 22:42:24.512787+00
136	6	22	15	2025-10-17 22:42:24.512787+00
137	7	10	1	2025-10-17 22:42:24.51349+00
138	7	11	2	2025-10-17 22:42:24.51349+00
139	7	12	3	2025-10-17 22:42:24.51349+00
140	7	13	4	2025-10-17 22:42:24.51349+00
141	7	14	5	2025-10-17 22:42:24.51349+00
142	7	15	6	2025-10-17 22:42:24.51349+00
143	7	16	7	2025-10-17 22:42:24.51349+00
144	7	17	8	2025-10-17 22:42:24.51349+00
145	7	18	9	2025-10-17 22:42:24.51349+00
146	7	19	10	2025-10-17 22:42:24.51349+00
147	7	20	11	2025-10-17 22:42:24.51349+00
\.


--
-- Data for Name: sets_reglas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sets_reglas (id, politica_id, nombre, descripcion, habilitado, orden, created_at, updated_at) FROM stdin;
1	1	Set Reglas Diarias	Conjunto de reglas para programación diaria	t	1	2025-10-17 22:27:07.982854+00	\N
2	1	Set Reglas Especiales	Reglas especiales para eventos	t	2	2025-10-17 22:27:07.982854+00	\N
3	2	Set Reglas Generales	Reglas generales de programación	t	1	2025-10-17 22:27:07.982854+00	\N
\.


--
-- Name: canciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.canciones_id_seq', 3, true);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorias_id_seq', 3, true);


--
-- Name: conjuntos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.conjuntos_id_seq', 2, true);


--
-- Name: cortes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cortes_id_seq', 3, true);


--
-- Name: dias_modelo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dias_modelo_id_seq', 7, true);


--
-- Name: difusoras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.difusoras_id_seq', 4, true);


--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eventos_reloj_id_seq', 554, true);


--
-- Name: orden_asignacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orden_asignacion_id_seq', 3, true);


--
-- Name: politica_categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.politica_categorias_id_seq', 6, true);


--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.politicas_programacion_id_seq', 5, true);


--
-- Name: programacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.programacion_id_seq', 2725, true);


--
-- Name: reglas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reglas_id_seq', 3, true);


--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.relojes_dia_modelo_id_seq', 147, true);


--
-- Name: relojes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.relojes_id_seq', 30, true);


--
-- Name: sets_reglas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sets_reglas_id_seq', 3, true);


--
-- Name: canciones canciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: conjuntos conjuntos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conjuntos
    ADD CONSTRAINT conjuntos_pkey PRIMARY KEY (id);


--
-- Name: cortes cortes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cortes
    ADD CONSTRAINT cortes_pkey PRIMARY KEY (id);


--
-- Name: dias_modelo dias_modelo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dias_modelo
    ADD CONSTRAINT dias_modelo_pkey PRIMARY KEY (id);


--
-- Name: difusoras difusoras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.difusoras
    ADD CONSTRAINT difusoras_pkey PRIMARY KEY (id);


--
-- Name: difusoras difusoras_siglas_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.difusoras
    ADD CONSTRAINT difusoras_siglas_key UNIQUE (siglas);


--
-- Name: eventos_reloj eventos_reloj_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventos_reloj
    ADD CONSTRAINT eventos_reloj_pkey PRIMARY KEY (id);


--
-- Name: orden_asignacion orden_asignacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orden_asignacion
    ADD CONSTRAINT orden_asignacion_pkey PRIMARY KEY (id);


--
-- Name: politica_categorias politica_categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politica_categorias
    ADD CONSTRAINT politica_categorias_pkey PRIMARY KEY (id);


--
-- Name: politicas_programacion politicas_programacion_clave_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_clave_key UNIQUE (clave);


--
-- Name: politicas_programacion politicas_programacion_guid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_guid_key UNIQUE (guid);


--
-- Name: politicas_programacion politicas_programacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_pkey PRIMARY KEY (id);


--
-- Name: programacion programacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_pkey PRIMARY KEY (id);


--
-- Name: reglas reglas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reglas
    ADD CONSTRAINT reglas_pkey PRIMARY KEY (id);


--
-- Name: relojes relojes_clave_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_clave_key UNIQUE (clave);


--
-- Name: relojes_dia_modelo relojes_dia_modelo_dia_modelo_id_reloj_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_dia_modelo_id_reloj_id_key UNIQUE (dia_modelo_id, reloj_id);


--
-- Name: relojes_dia_modelo relojes_dia_modelo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_pkey PRIMARY KEY (id);


--
-- Name: relojes relojes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_pkey PRIMARY KEY (id);


--
-- Name: sets_reglas sets_reglas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sets_reglas
    ADD CONSTRAINT sets_reglas_pkey PRIMARY KEY (id);


--
-- Name: idx_politicas_domingo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_domingo ON public.politicas_programacion USING btree (domingo);


--
-- Name: idx_politicas_jueves; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_jueves ON public.politicas_programacion USING btree (jueves);


--
-- Name: idx_politicas_lunes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_lunes ON public.politicas_programacion USING btree (lunes);


--
-- Name: idx_politicas_martes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_martes ON public.politicas_programacion USING btree (martes);


--
-- Name: idx_politicas_miercoles; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_miercoles ON public.politicas_programacion USING btree (miercoles);


--
-- Name: idx_politicas_sabado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_sabado ON public.politicas_programacion USING btree (sabado);


--
-- Name: idx_politicas_viernes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_politicas_viernes ON public.politicas_programacion USING btree (viernes);


--
-- Name: ix_programacion_fecha_difusora; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_programacion_fecha_difusora ON public.programacion USING btree (fecha, difusora);


--
-- Name: ix_programacion_politica; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_programacion_politica ON public.programacion USING btree (politica_id);


--
-- Name: ix_programacion_reloj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_programacion_reloj ON public.programacion USING btree (reloj_id);


--
-- Name: canciones canciones_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorias(id);


--
-- Name: canciones canciones_conjunto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_conjunto_id_fkey FOREIGN KEY (conjunto_id) REFERENCES public.conjuntos(id);


--
-- Name: dias_modelo dias_modelo_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dias_modelo
    ADD CONSTRAINT dias_modelo_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: eventos_reloj eventos_reloj_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventos_reloj
    ADD CONSTRAINT eventos_reloj_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: orden_asignacion orden_asignacion_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orden_asignacion
    ADD CONSTRAINT orden_asignacion_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: politica_categorias politica_categorias_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politica_categorias
    ADD CONSTRAINT politica_categorias_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id);


--
-- Name: politicas_programacion politicas_programacion_domingo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_domingo_fkey FOREIGN KEY (domingo) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_jueves_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_jueves_fkey FOREIGN KEY (jueves) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_lunes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_lunes_fkey FOREIGN KEY (lunes) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_martes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_martes_fkey FOREIGN KEY (martes) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_miercoles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_miercoles_fkey FOREIGN KEY (miercoles) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_sabado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_sabado_fkey FOREIGN KEY (sabado) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_viernes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_viernes_fkey FOREIGN KEY (viernes) REFERENCES public.dias_modelo(id);


--
-- Name: programacion programacion_dia_modelo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_dia_modelo_id_fkey FOREIGN KEY (dia_modelo_id) REFERENCES public.dias_modelo(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_evento_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_evento_reloj_id_fkey FOREIGN KEY (evento_reloj_id) REFERENCES public.eventos_reloj(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: reglas reglas_set_regla_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reglas
    ADD CONSTRAINT reglas_set_regla_id_fkey FOREIGN KEY (set_regla_id) REFERENCES public.sets_reglas(id) ON DELETE CASCADE;


--
-- Name: relojes_dia_modelo relojes_dia_modelo_dia_modelo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_dia_modelo_id_fkey FOREIGN KEY (dia_modelo_id) REFERENCES public.dias_modelo(id) ON DELETE CASCADE;


--
-- Name: relojes_dia_modelo relojes_dia_modelo_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: relojes relojes_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: sets_reglas sets_reglas_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sets_reglas
    ADD CONSTRAINT sets_reglas_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict IAJ3lYObmIg5zXuXHErCrQbt24LGbcD0DupzoqbgaT5kb1B8CCKW0MsD44mulfL

