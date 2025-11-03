--
-- PostgreSQL database dump
--

\restrict 5JjOXtWQddFM8GkSlTEWldda58nmflrdvVsG6UBNw6rdQaS1AE0rkImfzvC8R9w

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: canciones; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.canciones OWNER TO postgres;

--
-- Name: canciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.canciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.canciones_id_seq OWNER TO postgres;

--
-- Name: canciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.canciones_id_seq OWNED BY public.canciones.id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    activa boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    difusora character varying(10),
    clave character varying(50)
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorias_id_seq OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: conjuntos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conjuntos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.conjuntos OWNER TO postgres;

--
-- Name: conjuntos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conjuntos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conjuntos_id_seq OWNER TO postgres;

--
-- Name: conjuntos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conjuntos_id_seq OWNED BY public.conjuntos.id;


--
-- Name: cortes; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.cortes OWNER TO postgres;

--
-- Name: cortes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cortes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cortes_id_seq OWNER TO postgres;

--
-- Name: cortes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cortes_id_seq OWNED BY public.cortes.id;


--
-- Name: dias_modelo; Type: TABLE; Schema: public; Owner: postgres
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
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.dias_modelo OWNER TO postgres;

--
-- Name: dias_modelo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dias_modelo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dias_modelo_id_seq OWNER TO postgres;

--
-- Name: dias_modelo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dias_modelo_id_seq OWNED BY public.dias_modelo.id;


--
-- Name: difusoras; Type: TABLE; Schema: public; Owner: postgres
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
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.difusoras OWNER TO postgres;

--
-- Name: difusoras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.difusoras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.difusoras_id_seq OWNER TO postgres;

--
-- Name: difusoras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.difusoras_id_seq OWNED BY public.difusoras.id;


--
-- Name: eventos_reloj; Type: TABLE; Schema: public; Owner: postgres
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
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.eventos_reloj OWNER TO postgres;

--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eventos_reloj_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eventos_reloj_id_seq OWNER TO postgres;

--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eventos_reloj_id_seq OWNED BY public.eventos_reloj.id;


--
-- Name: politica_categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.politica_categorias (
    id integer NOT NULL,
    politica_id integer,
    categoria_nombre character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.politica_categorias OWNER TO postgres;

--
-- Name: politica_categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.politica_categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.politica_categorias_id_seq OWNER TO postgres;

--
-- Name: politica_categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.politica_categorias_id_seq OWNED BY public.politica_categorias.id;


--
-- Name: politicas_programacion; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.politicas_programacion OWNER TO postgres;

--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.politicas_programacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.politicas_programacion_id_seq OWNER TO postgres;

--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.politicas_programacion_id_seq OWNED BY public.politicas_programacion.id;


--
-- Name: programacion; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.programacion OWNER TO postgres;

--
-- Name: programacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.programacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.programacion_id_seq OWNER TO postgres;

--
-- Name: programacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.programacion_id_seq OWNED BY public.programacion.id;


--
-- Name: reglas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reglas (
    id integer NOT NULL,
    politica_id integer NOT NULL,
    tipo_regla character varying(100) NOT NULL,
    caracteristica character varying(100) NOT NULL,
    tipo_separacion character varying(50) NOT NULL,
    horario boolean,
    solo_verificar_dia boolean,
    habilitada boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    descripcion text
);


ALTER TABLE public.reglas OWNER TO postgres;

--
-- Name: reglas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reglas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reglas_id_seq OWNER TO postgres;

--
-- Name: reglas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reglas_id_seq OWNED BY public.reglas.id;


--
-- Name: relojes; Type: TABLE; Schema: public; Owner: postgres
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
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.relojes OWNER TO postgres;

--
-- Name: relojes_dia_modelo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relojes_dia_modelo (
    id integer NOT NULL,
    dia_modelo_id integer,
    reloj_id integer,
    orden integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.relojes_dia_modelo OWNER TO postgres;

--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relojes_dia_modelo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relojes_dia_modelo_id_seq OWNER TO postgres;

--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relojes_dia_modelo_id_seq OWNED BY public.relojes_dia_modelo.id;


--
-- Name: relojes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relojes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relojes_id_seq OWNER TO postgres;

--
-- Name: relojes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relojes_id_seq OWNED BY public.relojes.id;


--
-- Name: separaciones_regla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.separaciones_regla (
    id integer NOT NULL,
    regla_id integer NOT NULL,
    valor character varying(200) NOT NULL,
    separacion integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.separaciones_regla OWNER TO postgres;

--
-- Name: separaciones_regla_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.separaciones_regla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.separaciones_regla_id_seq OWNER TO postgres;

--
-- Name: separaciones_regla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.separaciones_regla_id_seq OWNED BY public.separaciones_regla.id;


--
-- Name: canciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canciones ALTER COLUMN id SET DEFAULT nextval('public.canciones_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: conjuntos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conjuntos ALTER COLUMN id SET DEFAULT nextval('public.conjuntos_id_seq'::regclass);


--
-- Name: cortes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cortes ALTER COLUMN id SET DEFAULT nextval('public.cortes_id_seq'::regclass);


--
-- Name: dias_modelo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dias_modelo ALTER COLUMN id SET DEFAULT nextval('public.dias_modelo_id_seq'::regclass);


--
-- Name: difusoras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.difusoras ALTER COLUMN id SET DEFAULT nextval('public.difusoras_id_seq'::regclass);


--
-- Name: eventos_reloj id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_reloj ALTER COLUMN id SET DEFAULT nextval('public.eventos_reloj_id_seq'::regclass);


--
-- Name: politica_categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politica_categorias ALTER COLUMN id SET DEFAULT nextval('public.politica_categorias_id_seq'::regclass);


--
-- Name: politicas_programacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion ALTER COLUMN id SET DEFAULT nextval('public.politicas_programacion_id_seq'::regclass);


--
-- Name: programacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion ALTER COLUMN id SET DEFAULT nextval('public.programacion_id_seq'::regclass);


--
-- Name: reglas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglas ALTER COLUMN id SET DEFAULT nextval('public.reglas_id_seq'::regclass);


--
-- Name: relojes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes ALTER COLUMN id SET DEFAULT nextval('public.relojes_id_seq'::regclass);


--
-- Name: relojes_dia_modelo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes_dia_modelo ALTER COLUMN id SET DEFAULT nextval('public.relojes_dia_modelo_id_seq'::regclass);


--
-- Name: separaciones_regla id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.separaciones_regla ALTER COLUMN id SET DEFAULT nextval('public.separaciones_regla_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: canciones canciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: conjuntos conjuntos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conjuntos
    ADD CONSTRAINT conjuntos_pkey PRIMARY KEY (id);


--
-- Name: cortes cortes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cortes
    ADD CONSTRAINT cortes_pkey PRIMARY KEY (id);


--
-- Name: dias_modelo dias_modelo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dias_modelo
    ADD CONSTRAINT dias_modelo_pkey PRIMARY KEY (id);


--
-- Name: difusoras difusoras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.difusoras
    ADD CONSTRAINT difusoras_pkey PRIMARY KEY (id);


--
-- Name: difusoras difusoras_siglas_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.difusoras
    ADD CONSTRAINT difusoras_siglas_key UNIQUE (siglas);


--
-- Name: eventos_reloj eventos_reloj_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_reloj
    ADD CONSTRAINT eventos_reloj_pkey PRIMARY KEY (id);


--
-- Name: politica_categorias politica_categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politica_categorias
    ADD CONSTRAINT politica_categorias_pkey PRIMARY KEY (id);


--
-- Name: politicas_programacion politicas_programacion_clave_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_clave_key UNIQUE (clave);


--
-- Name: politicas_programacion politicas_programacion_guid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_guid_key UNIQUE (guid);


--
-- Name: politicas_programacion politicas_programacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_pkey PRIMARY KEY (id);


--
-- Name: programacion programacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_pkey PRIMARY KEY (id);


--
-- Name: reglas reglas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglas
    ADD CONSTRAINT reglas_pkey PRIMARY KEY (id);


--
-- Name: relojes relojes_clave_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_clave_key UNIQUE (clave);


--
-- Name: relojes_dia_modelo relojes_dia_modelo_dia_modelo_id_reloj_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_dia_modelo_id_reloj_id_key UNIQUE (dia_modelo_id, reloj_id);


--
-- Name: relojes_dia_modelo relojes_dia_modelo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_pkey PRIMARY KEY (id);


--
-- Name: relojes relojes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_pkey PRIMARY KEY (id);


--
-- Name: separaciones_regla separaciones_regla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.separaciones_regla
    ADD CONSTRAINT separaciones_regla_pkey PRIMARY KEY (id);


--
-- Name: idx_politicas_domingo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_domingo ON public.politicas_programacion USING btree (domingo);


--
-- Name: idx_politicas_jueves; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_jueves ON public.politicas_programacion USING btree (jueves);


--
-- Name: idx_politicas_lunes; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_lunes ON public.politicas_programacion USING btree (lunes);


--
-- Name: idx_politicas_martes; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_martes ON public.politicas_programacion USING btree (martes);


--
-- Name: idx_politicas_miercoles; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_miercoles ON public.politicas_programacion USING btree (miercoles);


--
-- Name: idx_politicas_sabado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_sabado ON public.politicas_programacion USING btree (sabado);


--
-- Name: idx_politicas_viernes; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_politicas_viernes ON public.politicas_programacion USING btree (viernes);


--
-- Name: ix_programacion_fecha_difusora; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_programacion_fecha_difusora ON public.programacion USING btree (fecha, difusora);


--
-- Name: ix_programacion_politica; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_programacion_politica ON public.programacion USING btree (politica_id);


--
-- Name: ix_programacion_reloj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_programacion_reloj ON public.programacion USING btree (reloj_id);


--
-- Name: ix_reglas_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_reglas_id ON public.reglas USING btree (id);


--
-- Name: ix_separaciones_regla_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_separaciones_regla_id ON public.separaciones_regla USING btree (id);


--
-- Name: canciones canciones_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorias(id);


--
-- Name: canciones canciones_conjunto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canciones
    ADD CONSTRAINT canciones_conjunto_id_fkey FOREIGN KEY (conjunto_id) REFERENCES public.conjuntos(id);


--
-- Name: dias_modelo dias_modelo_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dias_modelo
    ADD CONSTRAINT dias_modelo_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: eventos_reloj eventos_reloj_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos_reloj
    ADD CONSTRAINT eventos_reloj_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: politica_categorias politica_categorias_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politica_categorias
    ADD CONSTRAINT politica_categorias_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id);


--
-- Name: politicas_programacion politicas_programacion_domingo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_domingo_fkey FOREIGN KEY (domingo) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_jueves_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_jueves_fkey FOREIGN KEY (jueves) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_lunes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_lunes_fkey FOREIGN KEY (lunes) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_martes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_martes_fkey FOREIGN KEY (martes) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_miercoles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_miercoles_fkey FOREIGN KEY (miercoles) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_sabado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_sabado_fkey FOREIGN KEY (sabado) REFERENCES public.dias_modelo(id);


--
-- Name: politicas_programacion politicas_programacion_viernes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.politicas_programacion
    ADD CONSTRAINT politicas_programacion_viernes_fkey FOREIGN KEY (viernes) REFERENCES public.dias_modelo(id);


--
-- Name: programacion programacion_dia_modelo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_dia_modelo_id_fkey FOREIGN KEY (dia_modelo_id) REFERENCES public.dias_modelo(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_evento_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_evento_reloj_id_fkey FOREIGN KEY (evento_reloj_id) REFERENCES public.eventos_reloj(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: programacion programacion_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programacion
    ADD CONSTRAINT programacion_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: reglas reglas_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reglas
    ADD CONSTRAINT reglas_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: relojes_dia_modelo relojes_dia_modelo_dia_modelo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_dia_modelo_id_fkey FOREIGN KEY (dia_modelo_id) REFERENCES public.dias_modelo(id) ON DELETE CASCADE;


--
-- Name: relojes_dia_modelo relojes_dia_modelo_reloj_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes_dia_modelo
    ADD CONSTRAINT relojes_dia_modelo_reloj_id_fkey FOREIGN KEY (reloj_id) REFERENCES public.relojes(id) ON DELETE CASCADE;


--
-- Name: relojes relojes_politica_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_politica_id_fkey FOREIGN KEY (politica_id) REFERENCES public.politicas_programacion(id) ON DELETE CASCADE;


--
-- Name: separaciones_regla separaciones_regla_regla_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.separaciones_regla
    ADD CONSTRAINT separaciones_regla_regla_id_fkey FOREIGN KEY (regla_id) REFERENCES public.reglas(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 5JjOXtWQddFM8GkSlTEWldda58nmflrdvVsG6UBNw6rdQaS1AE0rkImfzvC8R9w

