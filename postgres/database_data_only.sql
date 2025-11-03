--
-- PostgreSQL database dump
--

\restrict ebvk9jcfAD4igjentuttIwrLYxOAVOBe0WSnsVKpVoJoWfUj6jugYdDIIB2eeWt

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

--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
9caddcadd001
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nombre, descripcion, activa, created_at, updated_at, difusora, clave) FROM stdin;
1	Pop	Música pop	t	2025-10-17 22:27:09.619881+00	\N	\N	\N
2	Rock	Música rock	t	2025-10-17 22:27:09.619881+00	\N	\N	\N
3	Clásica	Música clásica	t	2025-10-17 22:27:09.619881+00	\N	\N	\N
4	Jazz	Música jazz	t	2025-10-30 05:12:36.889082+00	\N	TEST1	JAZZ
5	Electrónica	Música electrónica	t	2025-10-30 05:12:36.889082+00	\N	TEST1	EDM
6	Baladas	Baladas románticas	t	2025-10-30 05:12:36.889082+00	\N	TEST1	BAL
7	Reggaeton	Reggaeton y urbanos	t	2025-10-30 05:14:31.781989+00	\N	TEST1	REGGAE
8	Indie	Indie / Alternativo	t	2025-10-30 05:14:31.781989+00	\N	TEST1	IND
9	Instrumental	Instrumentales y cinemáticas	t	2025-10-30 05:14:31.781989+00	\N	TEST1	INST
10	dscsdfsdfsdf		t	2025-11-03 16:22:57.909029+00	\N	TEST2	sdfsdfsdf
\.


--
-- Data for Name: conjuntos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conjuntos (id, nombre, descripcion, activo, created_at, updated_at) FROM stdin;
1	Conjunto 1	Descripción del conjunto 1	t	2025-10-17 22:27:09.620272+00	\N
2	Conjunto 2	Descripción del conjunto 2	t	2025-10-17 22:27:09.620272+00	\N
\.


--
-- Data for Name: canciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.canciones (id, titulo, artista, album, duracion, categoria_id, conjunto_id, activa, created_at, updated_at) FROM stdin;
1	Canción 1	Artista 1	Album 1	180	2	1	t	2025-10-17 22:27:09.620597+00	2025-10-30 04:57:21.469093+00
2	Canción 2	Artista 2	Album 2	200	1	1	t	2025-10-17 22:27:09.620597+00	2025-10-30 04:57:48.201878+00
3	Canción 3	Artista 3	Album 3	160	2	2	t	2025-10-17 22:27:09.620597+00	2025-10-30 05:09:53.119062+00
4	Pop Hit 1	Artista Pop 2	Álbum Pop 2	151	1	\N	t	2025-10-30 05:13:08.267095+00	\N
5	Pop Hit 2	Artista Pop 3	Álbum Pop 3	152	1	\N	t	2025-10-30 05:13:08.267095+00	\N
6	Pop Hit 3	Artista Pop 4	Álbum Pop 4	153	1	\N	t	2025-10-30 05:13:08.267095+00	\N
7	Pop Hit 4	Artista Pop 5	Álbum Pop 5	154	1	\N	t	2025-10-30 05:13:08.267095+00	\N
8	Pop Hit 5	Artista Pop 6	Álbum Pop 1	155	1	\N	t	2025-10-30 05:13:08.267095+00	\N
9	Pop Hit 6	Artista Pop 7	Álbum Pop 2	156	1	\N	t	2025-10-30 05:13:08.267095+00	\N
10	Pop Hit 7	Artista Pop 1	Álbum Pop 3	157	1	\N	t	2025-10-30 05:13:08.267095+00	\N
11	Pop Hit 8	Artista Pop 2	Álbum Pop 4	158	1	\N	t	2025-10-30 05:13:08.267095+00	\N
12	Pop Hit 9	Artista Pop 3	Álbum Pop 5	159	1	\N	t	2025-10-30 05:13:08.267095+00	\N
13	Pop Hit 10	Artista Pop 4	Álbum Pop 1	160	1	\N	t	2025-10-30 05:13:08.267095+00	\N
14	Rock Track 1	Banda Rock 2	Álbum Rock 2	181	2	\N	t	2025-10-30 05:13:08.267095+00	\N
15	Rock Track 2	Banda Rock 3	Álbum Rock 3	182	2	\N	t	2025-10-30 05:13:08.267095+00	\N
16	Rock Track 3	Banda Rock 4	Álbum Rock 4	183	2	\N	t	2025-10-30 05:13:08.267095+00	\N
17	Rock Track 4	Banda Rock 5	Álbum Rock 1	184	2	\N	t	2025-10-30 05:13:08.267095+00	\N
18	Rock Track 5	Banda Rock 6	Álbum Rock 2	185	2	\N	t	2025-10-30 05:13:08.267095+00	\N
19	Rock Track 6	Banda Rock 1	Álbum Rock 3	186	2	\N	t	2025-10-30 05:13:08.267095+00	\N
20	Rock Track 7	Banda Rock 2	Álbum Rock 4	187	2	\N	t	2025-10-30 05:13:08.267095+00	\N
21	Rock Track 8	Banda Rock 3	Álbum Rock 1	188	2	\N	t	2025-10-30 05:13:08.267095+00	\N
22	Rock Track 9	Banda Rock 4	Álbum Rock 2	189	2	\N	t	2025-10-30 05:13:08.267095+00	\N
23	Rock Track 10	Banda Rock 5	Álbum Rock 3	190	2	\N	t	2025-10-30 05:13:08.267095+00	\N
24	Clásica 1	Compositor 2	Obra 2	241	3	\N	t	2025-10-30 05:13:08.267095+00	\N
25	Clásica 2	Compositor 3	Obra 3	242	3	\N	t	2025-10-30 05:13:08.267095+00	\N
26	Clásica 3	Compositor 4	Obra 4	243	3	\N	t	2025-10-30 05:13:08.267095+00	\N
27	Clásica 4	Compositor 5	Obra 5	244	3	\N	t	2025-10-30 05:13:08.267095+00	\N
28	Clásica 5	Compositor 6	Obra 6	245	3	\N	t	2025-10-30 05:13:08.267095+00	\N
29	Clásica 6	Compositor 7	Obra 7	246	3	\N	t	2025-10-30 05:13:08.267095+00	\N
30	Clásica 7	Compositor 8	Obra 8	247	3	\N	t	2025-10-30 05:13:08.267095+00	\N
31	Clásica 8	Compositor 1	Obra 9	248	3	\N	t	2025-10-30 05:13:08.267095+00	\N
32	Clásica 9	Compositor 2	Obra 10	249	3	\N	t	2025-10-30 05:13:08.267095+00	\N
33	Clásica 10	Compositor 3	Obra 1	250	3	\N	t	2025-10-30 05:13:08.267095+00	\N
34	Jazz Standard 1	Quartet 2	Live Set 2	181	4	\N	t	2025-10-30 05:13:08.267095+00	\N
35	Jazz Standard 2	Quartet 3	Live Set 3	182	4	\N	t	2025-10-30 05:13:08.267095+00	\N
36	Jazz Standard 3	Quartet 4	Live Set 1	183	4	\N	t	2025-10-30 05:13:08.267095+00	\N
37	Jazz Standard 4	Quartet 5	Live Set 2	184	4	\N	t	2025-10-30 05:13:08.267095+00	\N
38	Jazz Standard 5	Quartet 6	Live Set 3	185	4	\N	t	2025-10-30 05:13:08.267095+00	\N
39	Jazz Standard 6	Quartet 7	Live Set 1	186	4	\N	t	2025-10-30 05:13:08.267095+00	\N
40	Jazz Standard 7	Quartet 8	Live Set 2	187	4	\N	t	2025-10-30 05:13:08.267095+00	\N
41	Jazz Standard 8	Quartet 9	Live Set 3	188	4	\N	t	2025-10-30 05:13:08.267095+00	\N
42	Jazz Standard 9	Quartet 1	Live Set 1	189	4	\N	t	2025-10-30 05:13:08.267095+00	\N
43	Jazz Standard 10	Quartet 2	Live Set 2	190	4	\N	t	2025-10-30 05:13:08.267095+00	\N
44	Jazz Standard 11	Quartet 3	Live Set 3	191	4	\N	t	2025-10-30 05:13:08.267095+00	\N
45	Jazz Standard 12	Quartet 4	Live Set 1	192	4	\N	t	2025-10-30 05:13:08.267095+00	\N
46	Jazz Standard 13	Quartet 5	Live Set 2	193	4	\N	t	2025-10-30 05:13:08.267095+00	\N
47	Jazz Standard 14	Quartet 6	Live Set 3	194	4	\N	t	2025-10-30 05:13:08.267095+00	\N
48	Jazz Standard 15	Quartet 7	Live Set 1	195	4	\N	t	2025-10-30 05:13:08.267095+00	\N
49	Jazz Standard 16	Quartet 8	Live Set 2	196	4	\N	t	2025-10-30 05:13:08.267095+00	\N
50	Jazz Standard 17	Quartet 9	Live Set 3	197	4	\N	t	2025-10-30 05:13:08.267095+00	\N
51	Jazz Standard 18	Quartet 1	Live Set 1	198	4	\N	t	2025-10-30 05:13:08.267095+00	\N
52	Jazz Standard 19	Quartet 2	Live Set 2	199	4	\N	t	2025-10-30 05:13:08.267095+00	\N
53	Jazz Standard 20	Quartet 3	Live Set 3	200	4	\N	t	2025-10-30 05:13:08.267095+00	\N
54	EDM Track 1	DJ 2	Festival 2	211	5	\N	t	2025-10-30 05:13:08.267095+00	\N
55	EDM Track 2	DJ 3	Festival 3	212	5	\N	t	2025-10-30 05:13:08.267095+00	\N
56	EDM Track 3	DJ 4	Festival 4	213	5	\N	t	2025-10-30 05:13:08.267095+00	\N
57	EDM Track 4	DJ 5	Festival 5	214	5	\N	t	2025-10-30 05:13:08.267095+00	\N
58	EDM Track 5	DJ 6	Festival 1	215	5	\N	t	2025-10-30 05:13:08.267095+00	\N
59	EDM Track 6	DJ 7	Festival 2	216	5	\N	t	2025-10-30 05:13:08.267095+00	\N
60	EDM Track 7	DJ 8	Festival 3	217	5	\N	t	2025-10-30 05:13:08.267095+00	\N
61	EDM Track 8	DJ 9	Festival 4	218	5	\N	t	2025-10-30 05:13:08.267095+00	\N
62	EDM Track 9	DJ 10	Festival 5	219	5	\N	t	2025-10-30 05:13:08.267095+00	\N
63	EDM Track 10	DJ 11	Festival 1	220	5	\N	t	2025-10-30 05:13:08.267095+00	\N
64	EDM Track 11	DJ 12	Festival 2	221	5	\N	t	2025-10-30 05:13:08.267095+00	\N
65	EDM Track 12	DJ 13	Festival 3	222	5	\N	t	2025-10-30 05:13:08.267095+00	\N
66	EDM Track 13	DJ 14	Festival 4	223	5	\N	t	2025-10-30 05:13:08.267095+00	\N
67	EDM Track 14	DJ 15	Festival 5	224	5	\N	t	2025-10-30 05:13:08.267095+00	\N
68	EDM Track 15	DJ 1	Festival 1	225	5	\N	t	2025-10-30 05:13:08.267095+00	\N
69	EDM Track 16	DJ 2	Festival 2	226	5	\N	t	2025-10-30 05:13:08.267095+00	\N
70	EDM Track 17	DJ 3	Festival 3	227	5	\N	t	2025-10-30 05:13:08.267095+00	\N
71	EDM Track 18	DJ 4	Festival 4	228	5	\N	t	2025-10-30 05:13:08.267095+00	\N
72	EDM Track 19	DJ 5	Festival 5	229	5	\N	t	2025-10-30 05:13:08.267095+00	\N
73	EDM Track 20	DJ 6	Festival 1	230	5	\N	t	2025-10-30 05:13:08.267095+00	\N
74	Balada 1	Cantante 2	Colección 2	201	6	\N	t	2025-10-30 05:13:08.267095+00	\N
75	Balada 2	Cantante 3	Colección 3	202	6	\N	t	2025-10-30 05:13:08.267095+00	\N
76	Balada 3	Cantante 4	Colección 4	203	6	\N	t	2025-10-30 05:13:08.267095+00	\N
77	Balada 4	Cantante 5	Colección 5	204	6	\N	t	2025-10-30 05:13:08.267095+00	\N
78	Balada 5	Cantante 6	Colección 6	205	6	\N	t	2025-10-30 05:13:08.267095+00	\N
79	Balada 6	Cantante 7	Colección 1	206	6	\N	t	2025-10-30 05:13:08.267095+00	\N
80	Balada 7	Cantante 8	Colección 2	207	6	\N	t	2025-10-30 05:13:08.267095+00	\N
81	Balada 8	Cantante 9	Colección 3	208	6	\N	t	2025-10-30 05:13:08.267095+00	\N
82	Balada 9	Cantante 10	Colección 4	209	6	\N	t	2025-10-30 05:13:08.267095+00	\N
83	Balada 10	Cantante 11	Colección 5	210	6	\N	t	2025-10-30 05:13:08.267095+00	\N
84	Balada 11	Cantante 12	Colección 6	211	6	\N	t	2025-10-30 05:13:08.267095+00	\N
85	Balada 12	Cantante 1	Colección 1	212	6	\N	t	2025-10-30 05:13:08.267095+00	\N
86	Balada 13	Cantante 2	Colección 2	213	6	\N	t	2025-10-30 05:13:08.267095+00	\N
87	Balada 14	Cantante 3	Colección 3	214	6	\N	t	2025-10-30 05:13:08.267095+00	\N
88	Balada 15	Cantante 4	Colección 4	215	6	\N	t	2025-10-30 05:13:08.267095+00	\N
89	Balada 16	Cantante 5	Colección 5	216	6	\N	t	2025-10-30 05:13:08.267095+00	\N
90	Balada 17	Cantante 6	Colección 6	217	6	\N	t	2025-10-30 05:13:08.267095+00	\N
91	Balada 18	Cantante 7	Colección 1	218	6	\N	t	2025-10-30 05:13:08.267095+00	\N
92	Balada 19	Cantante 8	Colección 2	219	6	\N	t	2025-10-30 05:13:08.267095+00	\N
93	Balada 20	Cantante 9	Colección 3	220	6	\N	t	2025-10-30 05:13:08.267095+00	\N
94	Pop Extra 1	Artista Pop X2	Álbum Pop X2	161	1	\N	t	2025-10-30 05:15:27.290654+00	\N
95	Pop Extra 2	Artista Pop X3	Álbum Pop X3	162	1	\N	t	2025-10-30 05:15:27.290654+00	\N
96	Pop Extra 3	Artista Pop X4	Álbum Pop X4	163	1	\N	t	2025-10-30 05:15:27.290654+00	\N
97	Pop Extra 4	Artista Pop X5	Álbum Pop X5	164	1	\N	t	2025-10-30 05:15:27.290654+00	\N
98	Pop Extra 5	Artista Pop X6	Álbum Pop X6	165	1	\N	t	2025-10-30 05:15:27.290654+00	\N
99	Pop Extra 6	Artista Pop X7	Álbum Pop X7	166	1	\N	t	2025-10-30 05:15:27.290654+00	\N
100	Pop Extra 7	Artista Pop X8	Álbum Pop X8	167	1	\N	t	2025-10-30 05:15:27.290654+00	\N
101	Pop Extra 8	Artista Pop X9	Álbum Pop X9	168	1	\N	t	2025-10-30 05:15:27.290654+00	\N
102	Pop Extra 9	Artista Pop X10	Álbum Pop X10	169	1	\N	t	2025-10-30 05:15:27.290654+00	\N
103	Pop Extra 10	Artista Pop X11	Álbum Pop X1	170	1	\N	t	2025-10-30 05:15:27.290654+00	\N
104	Pop Extra 11	Artista Pop X12	Álbum Pop X2	171	1	\N	t	2025-10-30 05:15:27.290654+00	\N
105	Pop Extra 12	Artista Pop X13	Álbum Pop X3	172	1	\N	t	2025-10-30 05:15:27.290654+00	\N
106	Pop Extra 13	Artista Pop X14	Álbum Pop X4	173	1	\N	t	2025-10-30 05:15:27.290654+00	\N
107	Pop Extra 14	Artista Pop X15	Álbum Pop X5	174	1	\N	t	2025-10-30 05:15:27.290654+00	\N
108	Pop Extra 15	Artista Pop X16	Álbum Pop X6	175	1	\N	t	2025-10-30 05:15:27.290654+00	\N
109	Pop Extra 16	Artista Pop X17	Álbum Pop X7	176	1	\N	t	2025-10-30 05:15:27.290654+00	\N
110	Pop Extra 17	Artista Pop X18	Álbum Pop X8	177	1	\N	t	2025-10-30 05:15:27.290654+00	\N
111	Pop Extra 18	Artista Pop X19	Álbum Pop X9	178	1	\N	t	2025-10-30 05:15:27.290654+00	\N
112	Pop Extra 19	Artista Pop X20	Álbum Pop X10	179	1	\N	t	2025-10-30 05:15:27.290654+00	\N
113	Pop Extra 20	Artista Pop X1	Álbum Pop X1	180	1	\N	t	2025-10-30 05:15:27.290654+00	\N
114	Pop Extra 21	Artista Pop X2	Álbum Pop X2	181	1	\N	t	2025-10-30 05:15:27.290654+00	\N
115	Pop Extra 22	Artista Pop X3	Álbum Pop X3	182	1	\N	t	2025-10-30 05:15:27.290654+00	\N
116	Pop Extra 23	Artista Pop X4	Álbum Pop X4	183	1	\N	t	2025-10-30 05:15:27.290654+00	\N
117	Pop Extra 24	Artista Pop X5	Álbum Pop X5	184	1	\N	t	2025-10-30 05:15:27.290654+00	\N
118	Pop Extra 25	Artista Pop X6	Álbum Pop X6	185	1	\N	t	2025-10-30 05:15:27.290654+00	\N
119	Pop Extra 26	Artista Pop X7	Álbum Pop X7	186	1	\N	t	2025-10-30 05:15:27.290654+00	\N
120	Pop Extra 27	Artista Pop X8	Álbum Pop X8	187	1	\N	t	2025-10-30 05:15:27.290654+00	\N
121	Pop Extra 28	Artista Pop X9	Álbum Pop X9	188	1	\N	t	2025-10-30 05:15:27.290654+00	\N
122	Pop Extra 29	Artista Pop X10	Álbum Pop X10	189	1	\N	t	2025-10-30 05:15:27.290654+00	\N
123	Pop Extra 30	Artista Pop X11	Álbum Pop X1	190	1	\N	t	2025-10-30 05:15:27.290654+00	\N
124	Pop Extra 31	Artista Pop X12	Álbum Pop X2	191	1	\N	t	2025-10-30 05:15:27.290654+00	\N
125	Pop Extra 32	Artista Pop X13	Álbum Pop X3	192	1	\N	t	2025-10-30 05:15:27.290654+00	\N
126	Pop Extra 33	Artista Pop X14	Álbum Pop X4	193	1	\N	t	2025-10-30 05:15:27.290654+00	\N
127	Pop Extra 34	Artista Pop X15	Álbum Pop X5	194	1	\N	t	2025-10-30 05:15:27.290654+00	\N
128	Pop Extra 35	Artista Pop X16	Álbum Pop X6	195	1	\N	t	2025-10-30 05:15:27.290654+00	\N
129	Pop Extra 36	Artista Pop X17	Álbum Pop X7	196	1	\N	t	2025-10-30 05:15:27.290654+00	\N
130	Pop Extra 37	Artista Pop X18	Álbum Pop X8	197	1	\N	t	2025-10-30 05:15:27.290654+00	\N
131	Pop Extra 38	Artista Pop X19	Álbum Pop X9	198	1	\N	t	2025-10-30 05:15:27.290654+00	\N
132	Pop Extra 39	Artista Pop X20	Álbum Pop X10	199	1	\N	t	2025-10-30 05:15:27.290654+00	\N
133	Pop Extra 40	Artista Pop X1	Álbum Pop X1	200	1	\N	t	2025-10-30 05:15:27.290654+00	\N
134	Pop Extra 41	Artista Pop X2	Álbum Pop X2	201	1	\N	t	2025-10-30 05:15:27.290654+00	\N
135	Pop Extra 42	Artista Pop X3	Álbum Pop X3	202	1	\N	t	2025-10-30 05:15:27.290654+00	\N
136	Pop Extra 43	Artista Pop X4	Álbum Pop X4	203	1	\N	t	2025-10-30 05:15:27.290654+00	\N
137	Pop Extra 44	Artista Pop X5	Álbum Pop X5	204	1	\N	t	2025-10-30 05:15:27.290654+00	\N
138	Pop Extra 45	Artista Pop X6	Álbum Pop X6	205	1	\N	t	2025-10-30 05:15:27.290654+00	\N
139	Pop Extra 46	Artista Pop X7	Álbum Pop X7	206	1	\N	t	2025-10-30 05:15:27.290654+00	\N
140	Pop Extra 47	Artista Pop X8	Álbum Pop X8	207	1	\N	t	2025-10-30 05:15:27.290654+00	\N
141	Pop Extra 48	Artista Pop X9	Álbum Pop X9	208	1	\N	t	2025-10-30 05:15:27.290654+00	\N
142	Pop Extra 49	Artista Pop X10	Álbum Pop X10	209	1	\N	t	2025-10-30 05:15:27.290654+00	\N
143	Pop Extra 50	Artista Pop X11	Álbum Pop X1	210	1	\N	t	2025-10-30 05:15:27.290654+00	\N
144	Rock Extra 1	Banda Rock X2	Álbum Rock X2	171	2	\N	t	2025-10-30 05:15:27.290654+00	\N
145	Rock Extra 2	Banda Rock X3	Álbum Rock X3	172	2	\N	t	2025-10-30 05:15:27.290654+00	\N
146	Rock Extra 3	Banda Rock X4	Álbum Rock X4	173	2	\N	t	2025-10-30 05:15:27.290654+00	\N
147	Rock Extra 4	Banda Rock X5	Álbum Rock X5	174	2	\N	t	2025-10-30 05:15:27.290654+00	\N
148	Rock Extra 5	Banda Rock X6	Álbum Rock X6	175	2	\N	t	2025-10-30 05:15:27.290654+00	\N
149	Rock Extra 6	Banda Rock X7	Álbum Rock X7	176	2	\N	t	2025-10-30 05:15:27.290654+00	\N
150	Rock Extra 7	Banda Rock X8	Álbum Rock X8	177	2	\N	t	2025-10-30 05:15:27.290654+00	\N
151	Rock Extra 8	Banda Rock X9	Álbum Rock X9	178	2	\N	t	2025-10-30 05:15:27.290654+00	\N
152	Rock Extra 9	Banda Rock X10	Álbum Rock X10	179	2	\N	t	2025-10-30 05:15:27.290654+00	\N
153	Rock Extra 10	Banda Rock X11	Álbum Rock X1	180	2	\N	t	2025-10-30 05:15:27.290654+00	\N
154	Rock Extra 11	Banda Rock X12	Álbum Rock X2	181	2	\N	t	2025-10-30 05:15:27.290654+00	\N
155	Rock Extra 12	Banda Rock X13	Álbum Rock X3	182	2	\N	t	2025-10-30 05:15:27.290654+00	\N
156	Rock Extra 13	Banda Rock X14	Álbum Rock X4	183	2	\N	t	2025-10-30 05:15:27.290654+00	\N
157	Rock Extra 14	Banda Rock X15	Álbum Rock X5	184	2	\N	t	2025-10-30 05:15:27.290654+00	\N
158	Rock Extra 15	Banda Rock X16	Álbum Rock X6	185	2	\N	t	2025-10-30 05:15:27.290654+00	\N
159	Rock Extra 16	Banda Rock X17	Álbum Rock X7	186	2	\N	t	2025-10-30 05:15:27.290654+00	\N
160	Rock Extra 17	Banda Rock X18	Álbum Rock X8	187	2	\N	t	2025-10-30 05:15:27.290654+00	\N
161	Rock Extra 18	Banda Rock X19	Álbum Rock X9	188	2	\N	t	2025-10-30 05:15:27.290654+00	\N
162	Rock Extra 19	Banda Rock X20	Álbum Rock X10	189	2	\N	t	2025-10-30 05:15:27.290654+00	\N
163	Rock Extra 20	Banda Rock X1	Álbum Rock X1	190	2	\N	t	2025-10-30 05:15:27.290654+00	\N
164	Rock Extra 21	Banda Rock X2	Álbum Rock X2	191	2	\N	t	2025-10-30 05:15:27.290654+00	\N
165	Rock Extra 22	Banda Rock X3	Álbum Rock X3	192	2	\N	t	2025-10-30 05:15:27.290654+00	\N
166	Rock Extra 23	Banda Rock X4	Álbum Rock X4	193	2	\N	t	2025-10-30 05:15:27.290654+00	\N
167	Rock Extra 24	Banda Rock X5	Álbum Rock X5	194	2	\N	t	2025-10-30 05:15:27.290654+00	\N
168	Rock Extra 25	Banda Rock X6	Álbum Rock X6	195	2	\N	t	2025-10-30 05:15:27.290654+00	\N
169	Rock Extra 26	Banda Rock X7	Álbum Rock X7	196	2	\N	t	2025-10-30 05:15:27.290654+00	\N
170	Rock Extra 27	Banda Rock X8	Álbum Rock X8	197	2	\N	t	2025-10-30 05:15:27.290654+00	\N
171	Rock Extra 28	Banda Rock X9	Álbum Rock X9	198	2	\N	t	2025-10-30 05:15:27.290654+00	\N
172	Rock Extra 29	Banda Rock X10	Álbum Rock X10	199	2	\N	t	2025-10-30 05:15:27.290654+00	\N
173	Rock Extra 30	Banda Rock X11	Álbum Rock X1	200	2	\N	t	2025-10-30 05:15:27.290654+00	\N
174	Rock Extra 31	Banda Rock X12	Álbum Rock X2	201	2	\N	t	2025-10-30 05:15:27.290654+00	\N
175	Rock Extra 32	Banda Rock X13	Álbum Rock X3	202	2	\N	t	2025-10-30 05:15:27.290654+00	\N
176	Rock Extra 33	Banda Rock X14	Álbum Rock X4	203	2	\N	t	2025-10-30 05:15:27.290654+00	\N
177	Rock Extra 34	Banda Rock X15	Álbum Rock X5	204	2	\N	t	2025-10-30 05:15:27.290654+00	\N
178	Rock Extra 35	Banda Rock X16	Álbum Rock X6	205	2	\N	t	2025-10-30 05:15:27.290654+00	\N
179	Rock Extra 36	Banda Rock X17	Álbum Rock X7	206	2	\N	t	2025-10-30 05:15:27.290654+00	\N
180	Rock Extra 37	Banda Rock X18	Álbum Rock X8	207	2	\N	t	2025-10-30 05:15:27.290654+00	\N
181	Rock Extra 38	Banda Rock X19	Álbum Rock X9	208	2	\N	t	2025-10-30 05:15:27.290654+00	\N
182	Rock Extra 39	Banda Rock X20	Álbum Rock X10	209	2	\N	t	2025-10-30 05:15:27.290654+00	\N
183	Rock Extra 40	Banda Rock X1	Álbum Rock X1	210	2	\N	t	2025-10-30 05:15:27.290654+00	\N
184	Rock Extra 41	Banda Rock X2	Álbum Rock X2	211	2	\N	t	2025-10-30 05:15:27.290654+00	\N
185	Rock Extra 42	Banda Rock X3	Álbum Rock X3	212	2	\N	t	2025-10-30 05:15:27.290654+00	\N
186	Rock Extra 43	Banda Rock X4	Álbum Rock X4	213	2	\N	t	2025-10-30 05:15:27.290654+00	\N
187	Rock Extra 44	Banda Rock X5	Álbum Rock X5	214	2	\N	t	2025-10-30 05:15:27.290654+00	\N
188	Rock Extra 45	Banda Rock X6	Álbum Rock X6	215	2	\N	t	2025-10-30 05:15:27.290654+00	\N
189	Rock Extra 46	Banda Rock X7	Álbum Rock X7	216	2	\N	t	2025-10-30 05:15:27.290654+00	\N
190	Rock Extra 47	Banda Rock X8	Álbum Rock X8	217	2	\N	t	2025-10-30 05:15:27.290654+00	\N
191	Rock Extra 48	Banda Rock X9	Álbum Rock X9	218	2	\N	t	2025-10-30 05:15:27.290654+00	\N
192	Rock Extra 49	Banda Rock X10	Álbum Rock X10	219	2	\N	t	2025-10-30 05:15:27.290654+00	\N
193	Rock Extra 50	Banda Rock X11	Álbum Rock X1	220	2	\N	t	2025-10-30 05:15:27.290654+00	\N
194	Clásica Extra 1	Compositor X2	Obra X2	241	3	\N	t	2025-10-30 05:15:27.290654+00	\N
195	Clásica Extra 2	Compositor X3	Obra X3	242	3	\N	t	2025-10-30 05:15:27.290654+00	\N
196	Clásica Extra 3	Compositor X4	Obra X4	243	3	\N	t	2025-10-30 05:15:27.290654+00	\N
197	Clásica Extra 4	Compositor X5	Obra X5	244	3	\N	t	2025-10-30 05:15:27.290654+00	\N
198	Clásica Extra 5	Compositor X6	Obra X6	245	3	\N	t	2025-10-30 05:15:27.290654+00	\N
199	Clásica Extra 6	Compositor X7	Obra X7	246	3	\N	t	2025-10-30 05:15:27.290654+00	\N
200	Clásica Extra 7	Compositor X8	Obra X8	247	3	\N	t	2025-10-30 05:15:27.290654+00	\N
201	Clásica Extra 8	Compositor X9	Obra X9	248	3	\N	t	2025-10-30 05:15:27.290654+00	\N
202	Clásica Extra 9	Compositor X10	Obra X10	249	3	\N	t	2025-10-30 05:15:27.290654+00	\N
203	Clásica Extra 10	Compositor X11	Obra X11	250	3	\N	t	2025-10-30 05:15:27.290654+00	\N
204	Clásica Extra 11	Compositor X12	Obra X12	251	3	\N	t	2025-10-30 05:15:27.290654+00	\N
205	Clásica Extra 12	Compositor X13	Obra X13	252	3	\N	t	2025-10-30 05:15:27.290654+00	\N
206	Clásica Extra 13	Compositor X14	Obra X14	253	3	\N	t	2025-10-30 05:15:27.290654+00	\N
207	Clásica Extra 14	Compositor X15	Obra X15	254	3	\N	t	2025-10-30 05:15:27.290654+00	\N
208	Clásica Extra 15	Compositor X16	Obra X1	255	3	\N	t	2025-10-30 05:15:27.290654+00	\N
209	Clásica Extra 16	Compositor X17	Obra X2	256	3	\N	t	2025-10-30 05:15:27.290654+00	\N
210	Clásica Extra 17	Compositor X18	Obra X3	257	3	\N	t	2025-10-30 05:15:27.290654+00	\N
211	Clásica Extra 18	Compositor X19	Obra X4	258	3	\N	t	2025-10-30 05:15:27.290654+00	\N
212	Clásica Extra 19	Compositor X20	Obra X5	259	3	\N	t	2025-10-30 05:15:27.290654+00	\N
213	Clásica Extra 20	Compositor X21	Obra X6	260	3	\N	t	2025-10-30 05:15:27.290654+00	\N
214	Clásica Extra 21	Compositor X22	Obra X7	261	3	\N	t	2025-10-30 05:15:27.290654+00	\N
215	Clásica Extra 22	Compositor X23	Obra X8	262	3	\N	t	2025-10-30 05:15:27.290654+00	\N
216	Clásica Extra 23	Compositor X24	Obra X9	263	3	\N	t	2025-10-30 05:15:27.290654+00	\N
217	Clásica Extra 24	Compositor X25	Obra X10	264	3	\N	t	2025-10-30 05:15:27.290654+00	\N
218	Clásica Extra 25	Compositor X1	Obra X11	265	3	\N	t	2025-10-30 05:15:27.290654+00	\N
219	Clásica Extra 26	Compositor X2	Obra X12	266	3	\N	t	2025-10-30 05:15:27.290654+00	\N
220	Clásica Extra 27	Compositor X3	Obra X13	267	3	\N	t	2025-10-30 05:15:27.290654+00	\N
221	Clásica Extra 28	Compositor X4	Obra X14	268	3	\N	t	2025-10-30 05:15:27.290654+00	\N
222	Clásica Extra 29	Compositor X5	Obra X15	269	3	\N	t	2025-10-30 05:15:27.290654+00	\N
223	Clásica Extra 30	Compositor X6	Obra X1	270	3	\N	t	2025-10-30 05:15:27.290654+00	\N
224	Clásica Extra 31	Compositor X7	Obra X2	271	3	\N	t	2025-10-30 05:15:27.290654+00	\N
225	Clásica Extra 32	Compositor X8	Obra X3	272	3	\N	t	2025-10-30 05:15:27.290654+00	\N
226	Clásica Extra 33	Compositor X9	Obra X4	273	3	\N	t	2025-10-30 05:15:27.290654+00	\N
227	Clásica Extra 34	Compositor X10	Obra X5	274	3	\N	t	2025-10-30 05:15:27.290654+00	\N
228	Clásica Extra 35	Compositor X11	Obra X6	275	3	\N	t	2025-10-30 05:15:27.290654+00	\N
229	Clásica Extra 36	Compositor X12	Obra X7	276	3	\N	t	2025-10-30 05:15:27.290654+00	\N
230	Clásica Extra 37	Compositor X13	Obra X8	277	3	\N	t	2025-10-30 05:15:27.290654+00	\N
231	Clásica Extra 38	Compositor X14	Obra X9	278	3	\N	t	2025-10-30 05:15:27.290654+00	\N
232	Clásica Extra 39	Compositor X15	Obra X10	279	3	\N	t	2025-10-30 05:15:27.290654+00	\N
233	Clásica Extra 40	Compositor X16	Obra X11	280	3	\N	t	2025-10-30 05:15:27.290654+00	\N
234	Clásica Extra 41	Compositor X17	Obra X12	281	3	\N	t	2025-10-30 05:15:27.290654+00	\N
235	Clásica Extra 42	Compositor X18	Obra X13	282	3	\N	t	2025-10-30 05:15:27.290654+00	\N
236	Clásica Extra 43	Compositor X19	Obra X14	283	3	\N	t	2025-10-30 05:15:27.290654+00	\N
237	Clásica Extra 44	Compositor X20	Obra X15	284	3	\N	t	2025-10-30 05:15:27.290654+00	\N
238	Clásica Extra 45	Compositor X21	Obra X1	285	3	\N	t	2025-10-30 05:15:27.290654+00	\N
239	Clásica Extra 46	Compositor X22	Obra X2	286	3	\N	t	2025-10-30 05:15:27.290654+00	\N
240	Clásica Extra 47	Compositor X23	Obra X3	287	3	\N	t	2025-10-30 05:15:27.290654+00	\N
241	Clásica Extra 48	Compositor X24	Obra X4	288	3	\N	t	2025-10-30 05:15:27.290654+00	\N
242	Clásica Extra 49	Compositor X25	Obra X5	289	3	\N	t	2025-10-30 05:15:27.290654+00	\N
243	Clásica Extra 50	Compositor X1	Obra X6	290	3	\N	t	2025-10-30 05:15:27.290654+00	\N
244	Jazz Extra 1	Quartet X2	Live X2	181	4	\N	t	2025-10-30 05:15:27.290654+00	\N
245	Jazz Extra 2	Quartet X3	Live X3	182	4	\N	t	2025-10-30 05:15:27.290654+00	\N
246	Jazz Extra 3	Quartet X4	Live X4	183	4	\N	t	2025-10-30 05:15:27.290654+00	\N
247	Jazz Extra 4	Quartet X5	Live X5	184	4	\N	t	2025-10-30 05:15:27.290654+00	\N
248	Jazz Extra 5	Quartet X6	Live X6	185	4	\N	t	2025-10-30 05:15:27.290654+00	\N
249	Jazz Extra 6	Quartet X7	Live X7	186	4	\N	t	2025-10-30 05:15:27.290654+00	\N
250	Jazz Extra 7	Quartet X8	Live X8	187	4	\N	t	2025-10-30 05:15:27.290654+00	\N
251	Jazz Extra 8	Quartet X9	Live X1	188	4	\N	t	2025-10-30 05:15:27.290654+00	\N
252	Jazz Extra 9	Quartet X10	Live X2	189	4	\N	t	2025-10-30 05:15:27.290654+00	\N
253	Jazz Extra 10	Quartet X11	Live X3	190	4	\N	t	2025-10-30 05:15:27.290654+00	\N
254	Jazz Extra 11	Quartet X12	Live X4	191	4	\N	t	2025-10-30 05:15:27.290654+00	\N
255	Jazz Extra 12	Quartet X13	Live X5	192	4	\N	t	2025-10-30 05:15:27.290654+00	\N
256	Jazz Extra 13	Quartet X14	Live X6	193	4	\N	t	2025-10-30 05:15:27.290654+00	\N
257	Jazz Extra 14	Quartet X15	Live X7	194	4	\N	t	2025-10-30 05:15:27.290654+00	\N
258	Jazz Extra 15	Quartet X16	Live X8	195	4	\N	t	2025-10-30 05:15:27.290654+00	\N
259	Jazz Extra 16	Quartet X17	Live X1	196	4	\N	t	2025-10-30 05:15:27.290654+00	\N
260	Jazz Extra 17	Quartet X18	Live X2	197	4	\N	t	2025-10-30 05:15:27.290654+00	\N
261	Jazz Extra 18	Quartet X19	Live X3	198	4	\N	t	2025-10-30 05:15:27.290654+00	\N
262	Jazz Extra 19	Quartet X20	Live X4	199	4	\N	t	2025-10-30 05:15:27.290654+00	\N
263	Jazz Extra 20	Quartet X21	Live X5	200	4	\N	t	2025-10-30 05:15:27.290654+00	\N
264	Jazz Extra 21	Quartet X22	Live X6	201	4	\N	t	2025-10-30 05:15:27.290654+00	\N
265	Jazz Extra 22	Quartet X23	Live X7	202	4	\N	t	2025-10-30 05:15:27.290654+00	\N
266	Jazz Extra 23	Quartet X24	Live X8	203	4	\N	t	2025-10-30 05:15:27.290654+00	\N
267	Jazz Extra 24	Quartet X25	Live X1	204	4	\N	t	2025-10-30 05:15:27.290654+00	\N
268	Jazz Extra 25	Quartet X1	Live X2	205	4	\N	t	2025-10-30 05:15:27.290654+00	\N
269	Jazz Extra 26	Quartet X2	Live X3	206	4	\N	t	2025-10-30 05:15:27.290654+00	\N
270	Jazz Extra 27	Quartet X3	Live X4	207	4	\N	t	2025-10-30 05:15:27.290654+00	\N
271	Jazz Extra 28	Quartet X4	Live X5	208	4	\N	t	2025-10-30 05:15:27.290654+00	\N
272	Jazz Extra 29	Quartet X5	Live X6	209	4	\N	t	2025-10-30 05:15:27.290654+00	\N
273	Jazz Extra 30	Quartet X6	Live X7	210	4	\N	t	2025-10-30 05:15:27.290654+00	\N
274	Jazz Extra 31	Quartet X7	Live X8	211	4	\N	t	2025-10-30 05:15:27.290654+00	\N
275	Jazz Extra 32	Quartet X8	Live X1	212	4	\N	t	2025-10-30 05:15:27.290654+00	\N
276	Jazz Extra 33	Quartet X9	Live X2	213	4	\N	t	2025-10-30 05:15:27.290654+00	\N
277	Jazz Extra 34	Quartet X10	Live X3	214	4	\N	t	2025-10-30 05:15:27.290654+00	\N
278	Jazz Extra 35	Quartet X11	Live X4	215	4	\N	t	2025-10-30 05:15:27.290654+00	\N
279	Jazz Extra 36	Quartet X12	Live X5	216	4	\N	t	2025-10-30 05:15:27.290654+00	\N
280	Jazz Extra 37	Quartet X13	Live X6	217	4	\N	t	2025-10-30 05:15:27.290654+00	\N
281	Jazz Extra 38	Quartet X14	Live X7	218	4	\N	t	2025-10-30 05:15:27.290654+00	\N
282	Jazz Extra 39	Quartet X15	Live X8	219	4	\N	t	2025-10-30 05:15:27.290654+00	\N
283	Jazz Extra 40	Quartet X16	Live X1	220	4	\N	t	2025-10-30 05:15:27.290654+00	\N
284	Jazz Extra 41	Quartet X17	Live X2	221	4	\N	t	2025-10-30 05:15:27.290654+00	\N
285	Jazz Extra 42	Quartet X18	Live X3	222	4	\N	t	2025-10-30 05:15:27.290654+00	\N
286	Jazz Extra 43	Quartet X19	Live X4	223	4	\N	t	2025-10-30 05:15:27.290654+00	\N
287	Jazz Extra 44	Quartet X20	Live X5	224	4	\N	t	2025-10-30 05:15:27.290654+00	\N
288	Jazz Extra 45	Quartet X21	Live X6	225	4	\N	t	2025-10-30 05:15:27.290654+00	\N
289	Jazz Extra 46	Quartet X22	Live X7	226	4	\N	t	2025-10-30 05:15:27.290654+00	\N
290	Jazz Extra 47	Quartet X23	Live X8	227	4	\N	t	2025-10-30 05:15:27.290654+00	\N
291	Jazz Extra 48	Quartet X24	Live X1	228	4	\N	t	2025-10-30 05:15:27.290654+00	\N
292	Jazz Extra 49	Quartet X25	Live X2	229	4	\N	t	2025-10-30 05:15:27.290654+00	\N
293	Jazz Extra 50	Quartet X1	Live X3	230	4	\N	t	2025-10-30 05:15:27.290654+00	\N
294	EDM Extra 1	DJ X2	Festival X2	201	5	\N	t	2025-10-30 05:15:27.290654+00	\N
295	EDM Extra 2	DJ X3	Festival X3	202	5	\N	t	2025-10-30 05:15:27.290654+00	\N
296	EDM Extra 3	DJ X4	Festival X4	203	5	\N	t	2025-10-30 05:15:27.290654+00	\N
297	EDM Extra 4	DJ X5	Festival X5	204	5	\N	t	2025-10-30 05:15:27.290654+00	\N
298	EDM Extra 5	DJ X6	Festival X6	205	5	\N	t	2025-10-30 05:15:27.290654+00	\N
299	EDM Extra 6	DJ X7	Festival X7	206	5	\N	t	2025-10-30 05:15:27.290654+00	\N
300	EDM Extra 7	DJ X8	Festival X8	207	5	\N	t	2025-10-30 05:15:27.290654+00	\N
301	EDM Extra 8	DJ X9	Festival X9	208	5	\N	t	2025-10-30 05:15:27.290654+00	\N
302	EDM Extra 9	DJ X10	Festival X10	209	5	\N	t	2025-10-30 05:15:27.290654+00	\N
303	EDM Extra 10	DJ X11	Festival X11	210	5	\N	t	2025-10-30 05:15:27.290654+00	\N
304	EDM Extra 11	DJ X12	Festival X12	211	5	\N	t	2025-10-30 05:15:27.290654+00	\N
305	EDM Extra 12	DJ X13	Festival X1	212	5	\N	t	2025-10-30 05:15:27.290654+00	\N
306	EDM Extra 13	DJ X14	Festival X2	213	5	\N	t	2025-10-30 05:15:27.290654+00	\N
307	EDM Extra 14	DJ X15	Festival X3	214	5	\N	t	2025-10-30 05:15:27.290654+00	\N
308	EDM Extra 15	DJ X16	Festival X4	215	5	\N	t	2025-10-30 05:15:27.290654+00	\N
309	EDM Extra 16	DJ X17	Festival X5	216	5	\N	t	2025-10-30 05:15:27.290654+00	\N
310	EDM Extra 17	DJ X18	Festival X6	217	5	\N	t	2025-10-30 05:15:27.290654+00	\N
311	EDM Extra 18	DJ X19	Festival X7	218	5	\N	t	2025-10-30 05:15:27.290654+00	\N
312	EDM Extra 19	DJ X20	Festival X8	219	5	\N	t	2025-10-30 05:15:27.290654+00	\N
313	EDM Extra 20	DJ X21	Festival X9	220	5	\N	t	2025-10-30 05:15:27.290654+00	\N
314	EDM Extra 21	DJ X22	Festival X10	221	5	\N	t	2025-10-30 05:15:27.290654+00	\N
315	EDM Extra 22	DJ X23	Festival X11	222	5	\N	t	2025-10-30 05:15:27.290654+00	\N
316	EDM Extra 23	DJ X24	Festival X12	223	5	\N	t	2025-10-30 05:15:27.290654+00	\N
317	EDM Extra 24	DJ X25	Festival X1	224	5	\N	t	2025-10-30 05:15:27.290654+00	\N
318	EDM Extra 25	DJ X26	Festival X2	225	5	\N	t	2025-10-30 05:15:27.290654+00	\N
319	EDM Extra 26	DJ X27	Festival X3	226	5	\N	t	2025-10-30 05:15:27.290654+00	\N
320	EDM Extra 27	DJ X28	Festival X4	227	5	\N	t	2025-10-30 05:15:27.290654+00	\N
321	EDM Extra 28	DJ X29	Festival X5	228	5	\N	t	2025-10-30 05:15:27.290654+00	\N
322	EDM Extra 29	DJ X30	Festival X6	229	5	\N	t	2025-10-30 05:15:27.290654+00	\N
323	EDM Extra 30	DJ X1	Festival X7	230	5	\N	t	2025-10-30 05:15:27.290654+00	\N
324	EDM Extra 31	DJ X2	Festival X8	231	5	\N	t	2025-10-30 05:15:27.290654+00	\N
325	EDM Extra 32	DJ X3	Festival X9	232	5	\N	t	2025-10-30 05:15:27.290654+00	\N
326	EDM Extra 33	DJ X4	Festival X10	233	5	\N	t	2025-10-30 05:15:27.290654+00	\N
327	EDM Extra 34	DJ X5	Festival X11	234	5	\N	t	2025-10-30 05:15:27.290654+00	\N
328	EDM Extra 35	DJ X6	Festival X12	235	5	\N	t	2025-10-30 05:15:27.290654+00	\N
329	EDM Extra 36	DJ X7	Festival X1	236	5	\N	t	2025-10-30 05:15:27.290654+00	\N
330	EDM Extra 37	DJ X8	Festival X2	237	5	\N	t	2025-10-30 05:15:27.290654+00	\N
331	EDM Extra 38	DJ X9	Festival X3	238	5	\N	t	2025-10-30 05:15:27.290654+00	\N
332	EDM Extra 39	DJ X10	Festival X4	239	5	\N	t	2025-10-30 05:15:27.290654+00	\N
333	EDM Extra 40	DJ X11	Festival X5	240	5	\N	t	2025-10-30 05:15:27.290654+00	\N
334	EDM Extra 41	DJ X12	Festival X6	241	5	\N	t	2025-10-30 05:15:27.290654+00	\N
335	EDM Extra 42	DJ X13	Festival X7	242	5	\N	t	2025-10-30 05:15:27.290654+00	\N
336	EDM Extra 43	DJ X14	Festival X8	243	5	\N	t	2025-10-30 05:15:27.290654+00	\N
337	EDM Extra 44	DJ X15	Festival X9	244	5	\N	t	2025-10-30 05:15:27.290654+00	\N
338	EDM Extra 45	DJ X16	Festival X10	245	5	\N	t	2025-10-30 05:15:27.290654+00	\N
339	EDM Extra 46	DJ X17	Festival X11	246	5	\N	t	2025-10-30 05:15:27.290654+00	\N
340	EDM Extra 47	DJ X18	Festival X12	247	5	\N	t	2025-10-30 05:15:27.290654+00	\N
341	EDM Extra 48	DJ X19	Festival X1	248	5	\N	t	2025-10-30 05:15:27.290654+00	\N
342	EDM Extra 49	DJ X20	Festival X2	249	5	\N	t	2025-10-30 05:15:27.290654+00	\N
343	EDM Extra 50	DJ X21	Festival X3	250	5	\N	t	2025-10-30 05:15:27.290654+00	\N
344	Balada Extra 1	Cantante X2	Colección X2	191	6	\N	t	2025-10-30 05:15:27.290654+00	\N
345	Balada Extra 2	Cantante X3	Colección X3	192	6	\N	t	2025-10-30 05:15:27.290654+00	\N
346	Balada Extra 3	Cantante X4	Colección X4	193	6	\N	t	2025-10-30 05:15:27.290654+00	\N
347	Balada Extra 4	Cantante X5	Colección X5	194	6	\N	t	2025-10-30 05:15:27.290654+00	\N
348	Balada Extra 5	Cantante X6	Colección X6	195	6	\N	t	2025-10-30 05:15:27.290654+00	\N
349	Balada Extra 6	Cantante X7	Colección X7	196	6	\N	t	2025-10-30 05:15:27.290654+00	\N
350	Balada Extra 7	Cantante X8	Colección X8	197	6	\N	t	2025-10-30 05:15:27.290654+00	\N
351	Balada Extra 8	Cantante X9	Colección X9	198	6	\N	t	2025-10-30 05:15:27.290654+00	\N
352	Balada Extra 9	Cantante X10	Colección X10	199	6	\N	t	2025-10-30 05:15:27.290654+00	\N
353	Balada Extra 10	Cantante X11	Colección X1	200	6	\N	t	2025-10-30 05:15:27.290654+00	\N
354	Balada Extra 11	Cantante X12	Colección X2	201	6	\N	t	2025-10-30 05:15:27.290654+00	\N
355	Balada Extra 12	Cantante X13	Colección X3	202	6	\N	t	2025-10-30 05:15:27.290654+00	\N
356	Balada Extra 13	Cantante X14	Colección X4	203	6	\N	t	2025-10-30 05:15:27.290654+00	\N
357	Balada Extra 14	Cantante X15	Colección X5	204	6	\N	t	2025-10-30 05:15:27.290654+00	\N
358	Balada Extra 15	Cantante X16	Colección X6	205	6	\N	t	2025-10-30 05:15:27.290654+00	\N
359	Balada Extra 16	Cantante X17	Colección X7	206	6	\N	t	2025-10-30 05:15:27.290654+00	\N
360	Balada Extra 17	Cantante X18	Colección X8	207	6	\N	t	2025-10-30 05:15:27.290654+00	\N
361	Balada Extra 18	Cantante X19	Colección X9	208	6	\N	t	2025-10-30 05:15:27.290654+00	\N
362	Balada Extra 19	Cantante X20	Colección X10	209	6	\N	t	2025-10-30 05:15:27.290654+00	\N
363	Balada Extra 20	Cantante X21	Colección X1	210	6	\N	t	2025-10-30 05:15:27.290654+00	\N
364	Balada Extra 21	Cantante X22	Colección X2	211	6	\N	t	2025-10-30 05:15:27.290654+00	\N
365	Balada Extra 22	Cantante X23	Colección X3	212	6	\N	t	2025-10-30 05:15:27.290654+00	\N
366	Balada Extra 23	Cantante X24	Colección X4	213	6	\N	t	2025-10-30 05:15:27.290654+00	\N
367	Balada Extra 24	Cantante X25	Colección X5	214	6	\N	t	2025-10-30 05:15:27.290654+00	\N
368	Balada Extra 25	Cantante X26	Colección X6	215	6	\N	t	2025-10-30 05:15:27.290654+00	\N
369	Balada Extra 26	Cantante X27	Colección X7	216	6	\N	t	2025-10-30 05:15:27.290654+00	\N
370	Balada Extra 27	Cantante X28	Colección X8	217	6	\N	t	2025-10-30 05:15:27.290654+00	\N
371	Balada Extra 28	Cantante X29	Colección X9	218	6	\N	t	2025-10-30 05:15:27.290654+00	\N
372	Balada Extra 29	Cantante X30	Colección X10	219	6	\N	t	2025-10-30 05:15:27.290654+00	\N
373	Balada Extra 30	Cantante X1	Colección X1	220	6	\N	t	2025-10-30 05:15:27.290654+00	\N
374	Balada Extra 31	Cantante X2	Colección X2	221	6	\N	t	2025-10-30 05:15:27.290654+00	\N
375	Balada Extra 32	Cantante X3	Colección X3	222	6	\N	t	2025-10-30 05:15:27.290654+00	\N
376	Balada Extra 33	Cantante X4	Colección X4	223	6	\N	t	2025-10-30 05:15:27.290654+00	\N
377	Balada Extra 34	Cantante X5	Colección X5	224	6	\N	t	2025-10-30 05:15:27.290654+00	\N
378	Balada Extra 35	Cantante X6	Colección X6	225	6	\N	t	2025-10-30 05:15:27.290654+00	\N
379	Balada Extra 36	Cantante X7	Colección X7	226	6	\N	t	2025-10-30 05:15:27.290654+00	\N
380	Balada Extra 37	Cantante X8	Colección X8	227	6	\N	t	2025-10-30 05:15:27.290654+00	\N
381	Balada Extra 38	Cantante X9	Colección X9	228	6	\N	t	2025-10-30 05:15:27.290654+00	\N
382	Balada Extra 39	Cantante X10	Colección X10	229	6	\N	t	2025-10-30 05:15:27.290654+00	\N
383	Balada Extra 40	Cantante X11	Colección X1	230	6	\N	t	2025-10-30 05:15:27.290654+00	\N
384	Balada Extra 41	Cantante X12	Colección X2	231	6	\N	t	2025-10-30 05:15:27.290654+00	\N
385	Balada Extra 42	Cantante X13	Colección X3	232	6	\N	t	2025-10-30 05:15:27.290654+00	\N
386	Balada Extra 43	Cantante X14	Colección X4	233	6	\N	t	2025-10-30 05:15:27.290654+00	\N
387	Balada Extra 44	Cantante X15	Colección X5	234	6	\N	t	2025-10-30 05:15:27.290654+00	\N
388	Balada Extra 45	Cantante X16	Colección X6	235	6	\N	t	2025-10-30 05:15:27.290654+00	\N
389	Balada Extra 46	Cantante X17	Colección X7	236	6	\N	t	2025-10-30 05:15:27.290654+00	\N
390	Balada Extra 47	Cantante X18	Colección X8	237	6	\N	t	2025-10-30 05:15:27.290654+00	\N
391	Balada Extra 48	Cantante X19	Colección X9	238	6	\N	t	2025-10-30 05:15:27.290654+00	\N
392	Balada Extra 49	Cantante X20	Colección X10	239	6	\N	t	2025-10-30 05:15:27.290654+00	\N
393	Balada Extra 50	Cantante X21	Colección X1	240	6	\N	t	2025-10-30 05:15:27.290654+00	\N
394	Reggaeton 1	Urbano 2	Mixtape 2	151	7	\N	t	2025-10-30 05:15:27.290654+00	\N
395	Reggaeton 2	Urbano 3	Mixtape 3	152	7	\N	t	2025-10-30 05:15:27.290654+00	\N
396	Reggaeton 3	Urbano 4	Mixtape 4	153	7	\N	t	2025-10-30 05:15:27.290654+00	\N
397	Reggaeton 4	Urbano 5	Mixtape 5	154	7	\N	t	2025-10-30 05:15:27.290654+00	\N
398	Reggaeton 5	Urbano 6	Mixtape 6	155	7	\N	t	2025-10-30 05:15:27.290654+00	\N
399	Reggaeton 6	Urbano 7	Mixtape 7	156	7	\N	t	2025-10-30 05:15:27.290654+00	\N
400	Reggaeton 7	Urbano 8	Mixtape 8	157	7	\N	t	2025-10-30 05:15:27.290654+00	\N
401	Reggaeton 8	Urbano 9	Mixtape 9	158	7	\N	t	2025-10-30 05:15:27.290654+00	\N
402	Reggaeton 9	Urbano 10	Mixtape 10	159	7	\N	t	2025-10-30 05:15:27.290654+00	\N
403	Reggaeton 10	Urbano 11	Mixtape 11	160	7	\N	t	2025-10-30 05:15:27.290654+00	\N
404	Reggaeton 11	Urbano 12	Mixtape 12	161	7	\N	t	2025-10-30 05:15:27.290654+00	\N
405	Reggaeton 12	Urbano 13	Mixtape 1	162	7	\N	t	2025-10-30 05:15:27.290654+00	\N
406	Reggaeton 13	Urbano 14	Mixtape 2	163	7	\N	t	2025-10-30 05:15:27.290654+00	\N
407	Reggaeton 14	Urbano 15	Mixtape 3	164	7	\N	t	2025-10-30 05:15:27.290654+00	\N
408	Reggaeton 15	Urbano 16	Mixtape 4	165	7	\N	t	2025-10-30 05:15:27.290654+00	\N
409	Reggaeton 16	Urbano 17	Mixtape 5	166	7	\N	t	2025-10-30 05:15:27.290654+00	\N
410	Reggaeton 17	Urbano 18	Mixtape 6	167	7	\N	t	2025-10-30 05:15:27.290654+00	\N
411	Reggaeton 18	Urbano 19	Mixtape 7	168	7	\N	t	2025-10-30 05:15:27.290654+00	\N
412	Reggaeton 19	Urbano 20	Mixtape 8	169	7	\N	t	2025-10-30 05:15:27.290654+00	\N
413	Reggaeton 20	Urbano 21	Mixtape 9	170	7	\N	t	2025-10-30 05:15:27.290654+00	\N
414	Reggaeton 21	Urbano 22	Mixtape 10	171	7	\N	t	2025-10-30 05:15:27.290654+00	\N
415	Reggaeton 22	Urbano 23	Mixtape 11	172	7	\N	t	2025-10-30 05:15:27.290654+00	\N
416	Reggaeton 23	Urbano 24	Mixtape 12	173	7	\N	t	2025-10-30 05:15:27.290654+00	\N
417	Reggaeton 24	Urbano 25	Mixtape 1	174	7	\N	t	2025-10-30 05:15:27.290654+00	\N
418	Reggaeton 25	Urbano 26	Mixtape 2	175	7	\N	t	2025-10-30 05:15:27.290654+00	\N
419	Reggaeton 26	Urbano 27	Mixtape 3	176	7	\N	t	2025-10-30 05:15:27.290654+00	\N
420	Reggaeton 27	Urbano 28	Mixtape 4	177	7	\N	t	2025-10-30 05:15:27.290654+00	\N
421	Reggaeton 28	Urbano 29	Mixtape 5	178	7	\N	t	2025-10-30 05:15:27.290654+00	\N
422	Reggaeton 29	Urbano 30	Mixtape 6	179	7	\N	t	2025-10-30 05:15:27.290654+00	\N
423	Reggaeton 30	Urbano 31	Mixtape 7	180	7	\N	t	2025-10-30 05:15:27.290654+00	\N
424	Reggaeton 31	Urbano 32	Mixtape 8	181	7	\N	t	2025-10-30 05:15:27.290654+00	\N
425	Reggaeton 32	Urbano 33	Mixtape 9	182	7	\N	t	2025-10-30 05:15:27.290654+00	\N
426	Reggaeton 33	Urbano 34	Mixtape 10	183	7	\N	t	2025-10-30 05:15:27.290654+00	\N
427	Reggaeton 34	Urbano 35	Mixtape 11	184	7	\N	t	2025-10-30 05:15:27.290654+00	\N
428	Reggaeton 35	Urbano 36	Mixtape 12	185	7	\N	t	2025-10-30 05:15:27.290654+00	\N
429	Reggaeton 36	Urbano 37	Mixtape 1	186	7	\N	t	2025-10-30 05:15:27.290654+00	\N
430	Reggaeton 37	Urbano 38	Mixtape 2	187	7	\N	t	2025-10-30 05:15:27.290654+00	\N
431	Reggaeton 38	Urbano 39	Mixtape 3	188	7	\N	t	2025-10-30 05:15:27.290654+00	\N
432	Reggaeton 39	Urbano 40	Mixtape 4	189	7	\N	t	2025-10-30 05:15:27.290654+00	\N
433	Reggaeton 40	Urbano 1	Mixtape 5	190	7	\N	t	2025-10-30 05:15:27.290654+00	\N
434	Reggaeton 41	Urbano 2	Mixtape 6	191	7	\N	t	2025-10-30 05:15:27.290654+00	\N
435	Reggaeton 42	Urbano 3	Mixtape 7	192	7	\N	t	2025-10-30 05:15:27.290654+00	\N
436	Reggaeton 43	Urbano 4	Mixtape 8	193	7	\N	t	2025-10-30 05:15:27.290654+00	\N
437	Reggaeton 44	Urbano 5	Mixtape 9	194	7	\N	t	2025-10-30 05:15:27.290654+00	\N
438	Reggaeton 45	Urbano 6	Mixtape 10	195	7	\N	t	2025-10-30 05:15:27.290654+00	\N
439	Reggaeton 46	Urbano 7	Mixtape 11	196	7	\N	t	2025-10-30 05:15:27.290654+00	\N
440	Reggaeton 47	Urbano 8	Mixtape 12	197	7	\N	t	2025-10-30 05:15:27.290654+00	\N
441	Reggaeton 48	Urbano 9	Mixtape 1	198	7	\N	t	2025-10-30 05:15:27.290654+00	\N
442	Reggaeton 49	Urbano 10	Mixtape 2	199	7	\N	t	2025-10-30 05:15:27.290654+00	\N
443	Reggaeton 50	Urbano 11	Mixtape 3	200	7	\N	t	2025-10-30 05:15:27.290654+00	\N
444	Reggaeton 51	Urbano 12	Mixtape 4	201	7	\N	t	2025-10-30 05:15:27.290654+00	\N
445	Reggaeton 52	Urbano 13	Mixtape 5	202	7	\N	t	2025-10-30 05:15:27.290654+00	\N
446	Reggaeton 53	Urbano 14	Mixtape 6	203	7	\N	t	2025-10-30 05:15:27.290654+00	\N
447	Reggaeton 54	Urbano 15	Mixtape 7	204	7	\N	t	2025-10-30 05:15:27.290654+00	\N
448	Reggaeton 55	Urbano 16	Mixtape 8	205	7	\N	t	2025-10-30 05:15:27.290654+00	\N
449	Reggaeton 56	Urbano 17	Mixtape 9	206	7	\N	t	2025-10-30 05:15:27.290654+00	\N
450	Reggaeton 57	Urbano 18	Mixtape 10	207	7	\N	t	2025-10-30 05:15:27.290654+00	\N
451	Reggaeton 58	Urbano 19	Mixtape 11	208	7	\N	t	2025-10-30 05:15:27.290654+00	\N
452	Reggaeton 59	Urbano 20	Mixtape 12	209	7	\N	t	2025-10-30 05:15:27.290654+00	\N
453	Reggaeton 60	Urbano 21	Mixtape 1	210	7	\N	t	2025-10-30 05:15:27.290654+00	\N
454	Reggaeton 61	Urbano 22	Mixtape 2	211	7	\N	t	2025-10-30 05:15:27.290654+00	\N
455	Reggaeton 62	Urbano 23	Mixtape 3	212	7	\N	t	2025-10-30 05:15:27.290654+00	\N
456	Reggaeton 63	Urbano 24	Mixtape 4	213	7	\N	t	2025-10-30 05:15:27.290654+00	\N
457	Reggaeton 64	Urbano 25	Mixtape 5	214	7	\N	t	2025-10-30 05:15:27.290654+00	\N
458	Reggaeton 65	Urbano 26	Mixtape 6	215	7	\N	t	2025-10-30 05:15:27.290654+00	\N
459	Reggaeton 66	Urbano 27	Mixtape 7	216	7	\N	t	2025-10-30 05:15:27.290654+00	\N
460	Reggaeton 67	Urbano 28	Mixtape 8	217	7	\N	t	2025-10-30 05:15:27.290654+00	\N
461	Reggaeton 68	Urbano 29	Mixtape 9	218	7	\N	t	2025-10-30 05:15:27.290654+00	\N
462	Reggaeton 69	Urbano 30	Mixtape 10	219	7	\N	t	2025-10-30 05:15:27.290654+00	\N
463	Reggaeton 70	Urbano 31	Mixtape 11	220	7	\N	t	2025-10-30 05:15:27.290654+00	\N
464	Reggaeton 71	Urbano 32	Mixtape 12	221	7	\N	t	2025-10-30 05:15:27.290654+00	\N
465	Reggaeton 72	Urbano 33	Mixtape 1	222	7	\N	t	2025-10-30 05:15:27.290654+00	\N
466	Reggaeton 73	Urbano 34	Mixtape 2	223	7	\N	t	2025-10-30 05:15:27.290654+00	\N
467	Reggaeton 74	Urbano 35	Mixtape 3	224	7	\N	t	2025-10-30 05:15:27.290654+00	\N
468	Reggaeton 75	Urbano 36	Mixtape 4	225	7	\N	t	2025-10-30 05:15:27.290654+00	\N
469	Reggaeton 76	Urbano 37	Mixtape 5	226	7	\N	t	2025-10-30 05:15:27.290654+00	\N
470	Reggaeton 77	Urbano 38	Mixtape 6	227	7	\N	t	2025-10-30 05:15:27.290654+00	\N
471	Reggaeton 78	Urbano 39	Mixtape 7	228	7	\N	t	2025-10-30 05:15:27.290654+00	\N
472	Reggaeton 79	Urbano 40	Mixtape 8	229	7	\N	t	2025-10-30 05:15:27.290654+00	\N
473	Reggaeton 80	Urbano 1	Mixtape 9	230	7	\N	t	2025-10-30 05:15:27.290654+00	\N
474	Indie 1	Banda Indie 2	Demo 2	151	8	\N	t	2025-10-30 05:15:27.290654+00	\N
475	Indie 2	Banda Indie 3	Demo 3	152	8	\N	t	2025-10-30 05:15:27.290654+00	\N
476	Indie 3	Banda Indie 4	Demo 4	153	8	\N	t	2025-10-30 05:15:27.290654+00	\N
477	Indie 4	Banda Indie 5	Demo 5	154	8	\N	t	2025-10-30 05:15:27.290654+00	\N
478	Indie 5	Banda Indie 6	Demo 6	155	8	\N	t	2025-10-30 05:15:27.290654+00	\N
479	Indie 6	Banda Indie 7	Demo 7	156	8	\N	t	2025-10-30 05:15:27.290654+00	\N
480	Indie 7	Banda Indie 8	Demo 8	157	8	\N	t	2025-10-30 05:15:27.290654+00	\N
481	Indie 8	Banda Indie 9	Demo 9	158	8	\N	t	2025-10-30 05:15:27.290654+00	\N
482	Indie 9	Banda Indie 10	Demo 10	159	8	\N	t	2025-10-30 05:15:27.290654+00	\N
483	Indie 10	Banda Indie 11	Demo 1	160	8	\N	t	2025-10-30 05:15:27.290654+00	\N
484	Indie 11	Banda Indie 12	Demo 2	161	8	\N	t	2025-10-30 05:15:27.290654+00	\N
485	Indie 12	Banda Indie 13	Demo 3	162	8	\N	t	2025-10-30 05:15:27.290654+00	\N
486	Indie 13	Banda Indie 14	Demo 4	163	8	\N	t	2025-10-30 05:15:27.290654+00	\N
487	Indie 14	Banda Indie 15	Demo 5	164	8	\N	t	2025-10-30 05:15:27.290654+00	\N
488	Indie 15	Banda Indie 16	Demo 6	165	8	\N	t	2025-10-30 05:15:27.290654+00	\N
489	Indie 16	Banda Indie 17	Demo 7	166	8	\N	t	2025-10-30 05:15:27.290654+00	\N
490	Indie 17	Banda Indie 18	Demo 8	167	8	\N	t	2025-10-30 05:15:27.290654+00	\N
491	Indie 18	Banda Indie 19	Demo 9	168	8	\N	t	2025-10-30 05:15:27.290654+00	\N
492	Indie 19	Banda Indie 20	Demo 10	169	8	\N	t	2025-10-30 05:15:27.290654+00	\N
493	Indie 20	Banda Indie 21	Demo 1	170	8	\N	t	2025-10-30 05:15:27.290654+00	\N
494	Indie 21	Banda Indie 22	Demo 2	171	8	\N	t	2025-10-30 05:15:27.290654+00	\N
495	Indie 22	Banda Indie 23	Demo 3	172	8	\N	t	2025-10-30 05:15:27.290654+00	\N
496	Indie 23	Banda Indie 24	Demo 4	173	8	\N	t	2025-10-30 05:15:27.290654+00	\N
497	Indie 24	Banda Indie 25	Demo 5	174	8	\N	t	2025-10-30 05:15:27.290654+00	\N
498	Indie 25	Banda Indie 26	Demo 6	175	8	\N	t	2025-10-30 05:15:27.290654+00	\N
499	Indie 26	Banda Indie 27	Demo 7	176	8	\N	t	2025-10-30 05:15:27.290654+00	\N
500	Indie 27	Banda Indie 28	Demo 8	177	8	\N	t	2025-10-30 05:15:27.290654+00	\N
501	Indie 28	Banda Indie 29	Demo 9	178	8	\N	t	2025-10-30 05:15:27.290654+00	\N
502	Indie 29	Banda Indie 30	Demo 10	179	8	\N	t	2025-10-30 05:15:27.290654+00	\N
503	Indie 30	Banda Indie 31	Demo 1	180	8	\N	t	2025-10-30 05:15:27.290654+00	\N
504	Indie 31	Banda Indie 32	Demo 2	181	8	\N	t	2025-10-30 05:15:27.290654+00	\N
505	Indie 32	Banda Indie 33	Demo 3	182	8	\N	t	2025-10-30 05:15:27.290654+00	\N
506	Indie 33	Banda Indie 34	Demo 4	183	8	\N	t	2025-10-30 05:15:27.290654+00	\N
507	Indie 34	Banda Indie 35	Demo 5	184	8	\N	t	2025-10-30 05:15:27.290654+00	\N
508	Indie 35	Banda Indie 1	Demo 6	185	8	\N	t	2025-10-30 05:15:27.290654+00	\N
509	Indie 36	Banda Indie 2	Demo 7	186	8	\N	t	2025-10-30 05:15:27.290654+00	\N
510	Indie 37	Banda Indie 3	Demo 8	187	8	\N	t	2025-10-30 05:15:27.290654+00	\N
511	Indie 38	Banda Indie 4	Demo 9	188	8	\N	t	2025-10-30 05:15:27.290654+00	\N
512	Indie 39	Banda Indie 5	Demo 10	189	8	\N	t	2025-10-30 05:15:27.290654+00	\N
513	Indie 40	Banda Indie 6	Demo 1	190	8	\N	t	2025-10-30 05:15:27.290654+00	\N
514	Indie 41	Banda Indie 7	Demo 2	191	8	\N	t	2025-10-30 05:15:27.290654+00	\N
515	Indie 42	Banda Indie 8	Demo 3	192	8	\N	t	2025-10-30 05:15:27.290654+00	\N
516	Indie 43	Banda Indie 9	Demo 4	193	8	\N	t	2025-10-30 05:15:27.290654+00	\N
517	Indie 44	Banda Indie 10	Demo 5	194	8	\N	t	2025-10-30 05:15:27.290654+00	\N
518	Indie 45	Banda Indie 11	Demo 6	195	8	\N	t	2025-10-30 05:15:27.290654+00	\N
519	Indie 46	Banda Indie 12	Demo 7	196	8	\N	t	2025-10-30 05:15:27.290654+00	\N
520	Indie 47	Banda Indie 13	Demo 8	197	8	\N	t	2025-10-30 05:15:27.290654+00	\N
521	Indie 48	Banda Indie 14	Demo 9	198	8	\N	t	2025-10-30 05:15:27.290654+00	\N
522	Indie 49	Banda Indie 15	Demo 10	199	8	\N	t	2025-10-30 05:15:27.290654+00	\N
523	Indie 50	Banda Indie 16	Demo 1	200	8	\N	t	2025-10-30 05:15:27.290654+00	\N
524	Indie 51	Banda Indie 17	Demo 2	201	8	\N	t	2025-10-30 05:15:27.290654+00	\N
525	Indie 52	Banda Indie 18	Demo 3	202	8	\N	t	2025-10-30 05:15:27.290654+00	\N
526	Indie 53	Banda Indie 19	Demo 4	203	8	\N	t	2025-10-30 05:15:27.290654+00	\N
527	Indie 54	Banda Indie 20	Demo 5	204	8	\N	t	2025-10-30 05:15:27.290654+00	\N
528	Indie 55	Banda Indie 21	Demo 6	205	8	\N	t	2025-10-30 05:15:27.290654+00	\N
529	Indie 56	Banda Indie 22	Demo 7	206	8	\N	t	2025-10-30 05:15:27.290654+00	\N
530	Indie 57	Banda Indie 23	Demo 8	207	8	\N	t	2025-10-30 05:15:27.290654+00	\N
531	Indie 58	Banda Indie 24	Demo 9	208	8	\N	t	2025-10-30 05:15:27.290654+00	\N
532	Indie 59	Banda Indie 25	Demo 10	209	8	\N	t	2025-10-30 05:15:27.290654+00	\N
533	Indie 60	Banda Indie 26	Demo 1	210	8	\N	t	2025-10-30 05:15:27.290654+00	\N
534	Indie 61	Banda Indie 27	Demo 2	211	8	\N	t	2025-10-30 05:15:27.290654+00	\N
535	Indie 62	Banda Indie 28	Demo 3	212	8	\N	t	2025-10-30 05:15:27.290654+00	\N
536	Indie 63	Banda Indie 29	Demo 4	213	8	\N	t	2025-10-30 05:15:27.290654+00	\N
537	Indie 64	Banda Indie 30	Demo 5	214	8	\N	t	2025-10-30 05:15:27.290654+00	\N
538	Indie 65	Banda Indie 31	Demo 6	215	8	\N	t	2025-10-30 05:15:27.290654+00	\N
539	Indie 66	Banda Indie 32	Demo 7	216	8	\N	t	2025-10-30 05:15:27.290654+00	\N
540	Indie 67	Banda Indie 33	Demo 8	217	8	\N	t	2025-10-30 05:15:27.290654+00	\N
541	Indie 68	Banda Indie 34	Demo 9	218	8	\N	t	2025-10-30 05:15:27.290654+00	\N
542	Indie 69	Banda Indie 35	Demo 10	219	8	\N	t	2025-10-30 05:15:27.290654+00	\N
543	Indie 70	Banda Indie 1	Demo 1	220	8	\N	t	2025-10-30 05:15:27.290654+00	\N
544	Indie 71	Banda Indie 2	Demo 2	221	8	\N	t	2025-10-30 05:15:27.290654+00	\N
545	Indie 72	Banda Indie 3	Demo 3	222	8	\N	t	2025-10-30 05:15:27.290654+00	\N
546	Indie 73	Banda Indie 4	Demo 4	223	8	\N	t	2025-10-30 05:15:27.290654+00	\N
547	Indie 74	Banda Indie 5	Demo 5	224	8	\N	t	2025-10-30 05:15:27.290654+00	\N
548	Indie 75	Banda Indie 6	Demo 6	225	8	\N	t	2025-10-30 05:15:27.290654+00	\N
549	Indie 76	Banda Indie 7	Demo 7	226	8	\N	t	2025-10-30 05:15:27.290654+00	\N
550	Indie 77	Banda Indie 8	Demo 8	227	8	\N	t	2025-10-30 05:15:27.290654+00	\N
551	Indie 78	Banda Indie 9	Demo 9	228	8	\N	t	2025-10-30 05:15:27.290654+00	\N
552	Indie 79	Banda Indie 10	Demo 10	229	8	\N	t	2025-10-30 05:15:27.290654+00	\N
553	Indie 80	Banda Indie 11	Demo 1	230	8	\N	t	2025-10-30 05:15:27.290654+00	\N
554	Instrumental 1	Orquesta 2	Score 2	121	9	\N	t	2025-10-30 05:15:27.290654+00	\N
555	Instrumental 2	Orquesta 3	Score 3	122	9	\N	t	2025-10-30 05:15:27.290654+00	\N
556	Instrumental 3	Orquesta 4	Score 4	123	9	\N	t	2025-10-30 05:15:27.290654+00	\N
557	Instrumental 4	Orquesta 5	Score 5	124	9	\N	t	2025-10-30 05:15:27.290654+00	\N
558	Instrumental 5	Orquesta 6	Score 6	125	9	\N	t	2025-10-30 05:15:27.290654+00	\N
559	Instrumental 6	Orquesta 7	Score 7	126	9	\N	t	2025-10-30 05:15:27.290654+00	\N
560	Instrumental 7	Orquesta 8	Score 8	127	9	\N	t	2025-10-30 05:15:27.290654+00	\N
561	Instrumental 8	Orquesta 9	Score 9	128	9	\N	t	2025-10-30 05:15:27.290654+00	\N
562	Instrumental 9	Orquesta 10	Score 10	129	9	\N	t	2025-10-30 05:15:27.290654+00	\N
563	Instrumental 10	Orquesta 11	Score 11	130	9	\N	t	2025-10-30 05:15:27.290654+00	\N
564	Instrumental 11	Orquesta 12	Score 12	131	9	\N	t	2025-10-30 05:15:27.290654+00	\N
565	Instrumental 12	Orquesta 13	Score 13	132	9	\N	t	2025-10-30 05:15:27.290654+00	\N
566	Instrumental 13	Orquesta 14	Score 14	133	9	\N	t	2025-10-30 05:15:27.290654+00	\N
567	Instrumental 14	Orquesta 15	Score 15	134	9	\N	t	2025-10-30 05:15:27.290654+00	\N
568	Instrumental 15	Orquesta 16	Score 1	135	9	\N	t	2025-10-30 05:15:27.290654+00	\N
569	Instrumental 16	Orquesta 17	Score 2	136	9	\N	t	2025-10-30 05:15:27.290654+00	\N
570	Instrumental 17	Orquesta 18	Score 3	137	9	\N	t	2025-10-30 05:15:27.290654+00	\N
571	Instrumental 18	Orquesta 19	Score 4	138	9	\N	t	2025-10-30 05:15:27.290654+00	\N
572	Instrumental 19	Orquesta 20	Score 5	139	9	\N	t	2025-10-30 05:15:27.290654+00	\N
573	Instrumental 20	Orquesta 21	Score 6	140	9	\N	t	2025-10-30 05:15:27.290654+00	\N
574	Instrumental 21	Orquesta 22	Score 7	141	9	\N	t	2025-10-30 05:15:27.290654+00	\N
575	Instrumental 22	Orquesta 23	Score 8	142	9	\N	t	2025-10-30 05:15:27.290654+00	\N
576	Instrumental 23	Orquesta 24	Score 9	143	9	\N	t	2025-10-30 05:15:27.290654+00	\N
577	Instrumental 24	Orquesta 25	Score 10	144	9	\N	t	2025-10-30 05:15:27.290654+00	\N
578	Instrumental 25	Orquesta 26	Score 11	145	9	\N	t	2025-10-30 05:15:27.290654+00	\N
579	Instrumental 26	Orquesta 27	Score 12	146	9	\N	t	2025-10-30 05:15:27.290654+00	\N
580	Instrumental 27	Orquesta 28	Score 13	147	9	\N	t	2025-10-30 05:15:27.290654+00	\N
581	Instrumental 28	Orquesta 29	Score 14	148	9	\N	t	2025-10-30 05:15:27.290654+00	\N
582	Instrumental 29	Orquesta 30	Score 15	149	9	\N	t	2025-10-30 05:15:27.290654+00	\N
583	Instrumental 30	Orquesta 31	Score 1	150	9	\N	t	2025-10-30 05:15:27.290654+00	\N
584	Instrumental 31	Orquesta 32	Score 2	151	9	\N	t	2025-10-30 05:15:27.290654+00	\N
585	Instrumental 32	Orquesta 33	Score 3	152	9	\N	t	2025-10-30 05:15:27.290654+00	\N
586	Instrumental 33	Orquesta 34	Score 4	153	9	\N	t	2025-10-30 05:15:27.290654+00	\N
587	Instrumental 34	Orquesta 35	Score 5	154	9	\N	t	2025-10-30 05:15:27.290654+00	\N
588	Instrumental 35	Orquesta 36	Score 6	155	9	\N	t	2025-10-30 05:15:27.290654+00	\N
589	Instrumental 36	Orquesta 37	Score 7	156	9	\N	t	2025-10-30 05:15:27.290654+00	\N
590	Instrumental 37	Orquesta 38	Score 8	157	9	\N	t	2025-10-30 05:15:27.290654+00	\N
591	Instrumental 38	Orquesta 39	Score 9	158	9	\N	t	2025-10-30 05:15:27.290654+00	\N
592	Instrumental 39	Orquesta 40	Score 10	159	9	\N	t	2025-10-30 05:15:27.290654+00	\N
593	Instrumental 40	Orquesta 1	Score 11	160	9	\N	t	2025-10-30 05:15:27.290654+00	\N
594	Instrumental 41	Orquesta 2	Score 12	161	9	\N	t	2025-10-30 05:15:27.290654+00	\N
595	Instrumental 42	Orquesta 3	Score 13	162	9	\N	t	2025-10-30 05:15:27.290654+00	\N
596	Instrumental 43	Orquesta 4	Score 14	163	9	\N	t	2025-10-30 05:15:27.290654+00	\N
597	Instrumental 44	Orquesta 5	Score 15	164	9	\N	t	2025-10-30 05:15:27.290654+00	\N
598	Instrumental 45	Orquesta 6	Score 1	165	9	\N	t	2025-10-30 05:15:27.290654+00	\N
599	Instrumental 46	Orquesta 7	Score 2	166	9	\N	t	2025-10-30 05:15:27.290654+00	\N
600	Instrumental 47	Orquesta 8	Score 3	167	9	\N	t	2025-10-30 05:15:27.290654+00	\N
601	Instrumental 48	Orquesta 9	Score 4	168	9	\N	t	2025-10-30 05:15:27.290654+00	\N
602	Instrumental 49	Orquesta 10	Score 5	169	9	\N	t	2025-10-30 05:15:27.290654+00	\N
603	Instrumental 50	Orquesta 11	Score 6	170	9	\N	t	2025-10-30 05:15:27.290654+00	\N
604	Instrumental 51	Orquesta 12	Score 7	171	9	\N	t	2025-10-30 05:15:27.290654+00	\N
605	Instrumental 52	Orquesta 13	Score 8	172	9	\N	t	2025-10-30 05:15:27.290654+00	\N
606	Instrumental 53	Orquesta 14	Score 9	173	9	\N	t	2025-10-30 05:15:27.290654+00	\N
607	Instrumental 54	Orquesta 15	Score 10	174	9	\N	t	2025-10-30 05:15:27.290654+00	\N
608	Instrumental 55	Orquesta 16	Score 11	175	9	\N	t	2025-10-30 05:15:27.290654+00	\N
609	Instrumental 56	Orquesta 17	Score 12	176	9	\N	t	2025-10-30 05:15:27.290654+00	\N
610	Instrumental 57	Orquesta 18	Score 13	177	9	\N	t	2025-10-30 05:15:27.290654+00	\N
611	Instrumental 58	Orquesta 19	Score 14	178	9	\N	t	2025-10-30 05:15:27.290654+00	\N
612	Instrumental 59	Orquesta 20	Score 15	179	9	\N	t	2025-10-30 05:15:27.290654+00	\N
613	Instrumental 60	Orquesta 21	Score 1	180	9	\N	t	2025-10-30 05:15:27.290654+00	\N
614	Instrumental 61	Orquesta 22	Score 2	181	9	\N	t	2025-10-30 05:15:27.290654+00	\N
615	Instrumental 62	Orquesta 23	Score 3	182	9	\N	t	2025-10-30 05:15:27.290654+00	\N
616	Instrumental 63	Orquesta 24	Score 4	183	9	\N	t	2025-10-30 05:15:27.290654+00	\N
617	Instrumental 64	Orquesta 25	Score 5	184	9	\N	t	2025-10-30 05:15:27.290654+00	\N
618	Instrumental 65	Orquesta 26	Score 6	185	9	\N	t	2025-10-30 05:15:27.290654+00	\N
619	Instrumental 66	Orquesta 27	Score 7	186	9	\N	t	2025-10-30 05:15:27.290654+00	\N
620	Instrumental 67	Orquesta 28	Score 8	187	9	\N	t	2025-10-30 05:15:27.290654+00	\N
621	Instrumental 68	Orquesta 29	Score 9	188	9	\N	t	2025-10-30 05:15:27.290654+00	\N
622	Instrumental 69	Orquesta 30	Score 10	189	9	\N	t	2025-10-30 05:15:27.290654+00	\N
623	Instrumental 70	Orquesta 31	Score 11	190	9	\N	t	2025-10-30 05:15:27.290654+00	\N
624	Instrumental 71	Orquesta 32	Score 12	191	9	\N	t	2025-10-30 05:15:27.290654+00	\N
625	Instrumental 72	Orquesta 33	Score 13	192	9	\N	t	2025-10-30 05:15:27.290654+00	\N
626	Instrumental 73	Orquesta 34	Score 14	193	9	\N	t	2025-10-30 05:15:27.290654+00	\N
627	Instrumental 74	Orquesta 35	Score 15	194	9	\N	t	2025-10-30 05:15:27.290654+00	\N
628	Instrumental 75	Orquesta 36	Score 1	195	9	\N	t	2025-10-30 05:15:27.290654+00	\N
629	Instrumental 76	Orquesta 37	Score 2	196	9	\N	t	2025-10-30 05:15:27.290654+00	\N
630	Instrumental 77	Orquesta 38	Score 3	197	9	\N	t	2025-10-30 05:15:27.290654+00	\N
631	Instrumental 78	Orquesta 39	Score 4	198	9	\N	t	2025-10-30 05:15:27.290654+00	\N
632	Instrumental 79	Orquesta 40	Score 5	199	9	\N	t	2025-10-30 05:15:27.290654+00	\N
633	Instrumental 80	Orquesta 1	Score 6	200	9	\N	t	2025-10-30 05:15:27.290654+00	\N
\.


--
-- Data for Name: cortes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cortes (id, nombre, descripcion, duracion, tipo, activo, observaciones, created_at, updated_at) FROM stdin;
1	Corte 1	Corte comercial 1	00:00:30	comercial	t	\N	2025-10-17 22:27:09.621192+00	\N
2	Corte 2	Corte comercial 2	00:00:15	comercial	t	\N	2025-10-17 22:27:09.621192+00	\N
4	Corte de Prueba DB	Prueba directa en DB	00:00:30	comercial	t	Prueba directa	2025-10-29 20:55:14.794999+00	\N
5	Corte de Prueba API	Corte de prueba desde API	00:00:45	comercial	t	Prueba desde API	2025-10-29 20:57:26.014573+00	\N
6	GRAL_XHGR	asdads	00:03:00	comercial	t	asdasdas	2025-10-29 20:58:05.359127+00	\N
3	Corte 3	Corte vacío actualizado	00:10:00	vacio	t	Actualizado desde API	2025-10-17 22:27:09.621192+00	2025-10-29 21:11:48.278523+00
7	Política General	sdsdf	00:02:00	comercial	t		2025-11-03 16:16:19.709178+00	\N
\.


--
-- Data for Name: politicas_programacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.politicas_programacion (id, clave, difusora, habilitada, guid, nombre, descripcion, alta, modificacion, created_at, categorias_seleccionadas, updated_at, lunes, martes, miercoles, jueves, viernes, sabado, domingo) FROM stdin;
2	asdasd	XHPER	t	{9D45EB0E-D2AB-4113-AD30-B628B18482CE}	Política General	Política general de programación	28/12/2017 06:16:09 p. m. (Administrator)	13/01/2025 04:20:22 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	Pop,Clásica,Instrumental,Reggaeton	2025-10-30 20:33:35.836551+00	3	3	3	3	3	3	3
3	GRAL_XHGR	TODAS	t	{C3C4787D-6EF0-4B3D-91E6-ACAE8F229F1C}	GRAL_XHGR	Política específica para XHGR	29/03/2019 04:13:45 p. m. (Administrator)	13/08/2025 04:40:50 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	Pop,Rock,Jazz,Electrónica	2025-10-30 21:13:11.604329+00	9	10	9	10	11	10	9
4	GRAL_XHOZ	TEST2	t	{2FE14516-E959-4D34-A213-46A5152B4784}	AMOR 91.7	Política para AMOR 91.7	01/02/2022 11:05:55 a. m. (Administrator)	13/08/2025 04:46:49 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	Rock	2025-10-30 20:30:23.805387+00	\N	\N	\N	\N	\N	\N	\N
5	POL_TEST	XHPER	t	\N	Política de Prueba	Política para pruebas de generación	\N	\N	2025-10-17 22:27:11.199335+00	Pop,Rock,Jazz,Electrónica,Clásica,Baladas	2025-10-30 20:31:16.428855+00	6	7	\N	7	\N	\N	\N
1	DIARIO_UPDATED	adasd	t	{F0268715-8A1B-4CCA-9790-913E3810874C}	DIARIO	Política de programación diaria	28/12/2017 12:44:36 p. m. (Administrator)	18/01/2022 02:08:20 p. m. (Administrator)	2025-10-17 22:27:07.964661+00	Pop,Electrónica,Instrumental	2025-10-30 20:33:30.418407+00	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: dias_modelo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dias_modelo (id, habilitado, difusora, politica_id, clave, nombre, descripcion, lunes, martes, miercoles, jueves, viernes, sabado, domingo, created_at, updated_at) FROM stdin;
1	t	XRAD	1	DIA_LABORAL	Día Laboral	Día modelo para días laborales	t	t	t	t	t	f	f	2025-10-17 22:27:07.979391+00	\N
2	t	XRAD	1	FIN_SEMANA	Fin de Semana	Día modelo para fines de semana	f	f	f	f	f	t	t	2025-10-17 22:27:07.979391+00	\N
3	t	XHPER	2	DIA_GENERAL	Día General	Día modelo general	t	t	t	t	t	t	t	2025-10-17 22:27:07.979391+00	\N
5	t	XHPER	5	LABORAL	Día Laboral	Día laboral con programación de 6:00 a 18:00	t	t	t	t	t	f	f	2025-10-17 22:41:28.792018+00	\N
6	t	XHPER	5	FIN_SEMANA	Fin de Semana	Fin de semana con programación de 8:00 a 22:00	f	f	f	f	f	t	t	2025-10-17 22:41:28.793338+00	\N
7	t	XHPER	5	ESPECIAL	Día Especial	Día especial con programación de 10:00 a 20:00	t	t	t	t	t	t	t	2025-10-17 22:41:28.794042+00	\N
9	f	TEST1	3	DIA_LABORAL	Día Laboral	Día modelo para días laborales (lunes a viernes)	t	t	t	t	t	f	f	2025-10-29 22:45:15.853165+00	\N
11	t	TEST1	3	DIA_GENERAL	Día General	Día modelo general para cualquier día	t	t	t	t	t	t	t	2025-10-29 22:45:15.853165+00	\N
10	t	TEST1	3	FIN_SEMANA	Fin de Semana	Día modelo para fines de semana (sábado y domingo)	f	f	f	f	f	t	t	2025-10-29 22:45:15.853165+00	\N
\.


--
-- Data for Name: difusoras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.difusoras (id, siglas, nombre, slogan, orden, mascara_medidas, descripcion, activa, created_at, updated_at) FROM stdin;
1	TEST1	Radio Test 1	La mejor música	1	MM:SS	\N	t	2025-10-17 22:27:09.61903+00	\N
2	TEST2	Radio Test 2	Música para todos	2	MM:SS	\N	t	2025-10-17 22:27:09.61903+00	\N
3	adasd	asdasd	asdasd	12	MM:SS	asdasd	t	2025-10-17 22:46:23.497422+00	\N
4	XHPER	Radio XHPER	La radio que te conecta	4	MM:SS	Estación de radio XHPER	t	2025-10-21 01:53:58.150562+00	\N
5	fake	fake	fake	2			t	2025-11-03 16:07:18.930883+00	\N
\.


--
-- Data for Name: relojes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relojes (id, habilitado, clave, grupo, numero_regla, nombre, numero_eventos, duracion, con_evento, politica_id, created_at, updated_at) FROM stdin;
1	t	DOMINGO_23_52	Grupo A	001	DOMINGO 23.52	8	00:24:00	t	1	2025-10-17 22:27:07.969052+00	\N
2	t	LUNES_06_00	Grupo B	002	LUNES 06.00	6	00:18:00	t	1	2025-10-17 22:27:07.969052+00	\N
3	t	MARTES_12_30	Grupo A	003	MARTES 12.30	5	00:15:00	t	1	2025-10-17 22:27:07.969052+00	\N
5	t	R01	\N	\N	Reloj 01:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
6	t	R02	\N	\N	Reloj 02:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
7	t	R03	\N	\N	Reloj 03:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
8	t	R04	\N	\N	Reloj 04:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
9	t	R05	\N	\N	Reloj 05:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
10	t	R06	\N	\N	Reloj 06:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
11	t	R07	\N	\N	Reloj 07:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
12	t	R08	\N	\N	Reloj 08:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
13	t	R09	\N	\N	Reloj 09:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
14	t	R10	\N	\N	Reloj 10:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
15	t	R11	\N	\N	Reloj 11:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
16	t	R12	\N	\N	Reloj 12:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
17	t	R13	\N	\N	Reloj 13:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
18	t	R14	\N	\N	Reloj 14:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
19	t	R15	\N	\N	Reloj 15:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
20	t	R16	\N	\N	Reloj 16:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
21	t	R17	\N	\N	Reloj 17:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
22	t	R18	\N	\N	Reloj 18:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
23	t	R19	\N	\N	Reloj 19:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
24	t	R20	\N	\N	Reloj 20:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
25	t	R21	\N	\N	Reloj 21:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
26	t	R22	\N	\N	Reloj 22:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
27	t	R23	\N	\N	Reloj 23:00	0	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
28	t	General	\N	\N	Política General	17	01:01:01	f	3	2025-10-21 01:27:20.636447+00	\N
4	t	R00	\N	\N	Reloj 00:00	20	01:00:00	f	5	2025-10-17 22:27:11.200568+00	\N
29	t	TEST_RELOJ_1	\N	\N	Reloj de Prueba	0	01:00:00	f	2	2025-10-21 02:10:25.386909+00	\N
30	t	asdasd	\N	\N	asdasd	18	01:00:00	f	2	2025-10-21 02:11:05.888231+00	\N
31	t	sdfsd	\N	\N	sdf	23	00:00:00	f	2	2025-10-30 21:07:16.219877+00	\N
32	t	etm	\N	\N	etm	19	01:00:00	f	3	2025-10-30 21:21:33.139386+00	\N
33	t	test	\N	\N	test	16	00:00:00	f	3	2025-10-31 03:48:15.70848+00	\N
\.


--
-- Data for Name: eventos_reloj; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventos_reloj (id, reloj_id, numero, offset_value, desde_etm, desde_corte, offset_final, tipo, categoria, descripcion, duracion, numero_cancion, sin_categorias, id_media, categoria_media, tipo_etm, comando_das, caracteristica, twofer_valor, todas_categorias, categorias_usar, grupos_reglas_ignorar, clasificaciones_evento, caracteristica_especifica, valor_deseado, usar_todas_categorias, categorias_usar_especifica, grupos_reglas_ignorar_especifica, clasificaciones_evento_especifica, orden, created_at, updated_at) FROM stdin;
4	1	004	00:04:00	00:04:00	00:04:00	00:08:00	1	Canciones	GLORIA	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00	\N
5	1	005	00:08:00	00:08:00	00:08:00	00:12:00	1	Canciones	HIMNO	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00	\N
6	1	006	00:12:00	00:12:00	00:12:00	00:16:00	1	Canciones	MUSICA	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	6	2025-10-17 22:27:07.974686+00	\N
7	1	007	00:16:00	00:16:00	00:16:00	00:20:00	1	Canciones	PROMO	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	7	2025-10-17 22:27:07.974686+00	\N
8	1	008	00:20:00	00:20:00	00:20:00	00:24:00	1	Canciones	PROMOSLOS40	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	8	2025-10-17 22:27:07.974686+00	\N
9	2	001	00:00:00	00:00:00	00:00:00	00:00:00	ETM	ETM	Inicio del reloj	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	1	2025-10-17 22:27:07.974686+00	\N
10	2	002	00:00:00	00:00:00	00:00:00	00:00:00	6	ETM	ETM 00	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	2	2025-10-17 22:27:07.974686+00	\N
11	2	003	00:00:00	00:00:00	00:00:00	00:06:00	2	Corte Comercial	CC 3M	00:06:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	3	2025-10-17 22:27:07.974686+00	\N
12	2	004	00:06:00	00:06:00	00:06:00	00:12:00	1	Canciones	MUSICA_MAÑANA	00:06:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00	\N
13	2	005	00:12:00	00:12:00	00:12:00	00:15:00	3	Nota Operador	NOTA_MAÑANA	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00	\N
14	2	006	00:15:00	00:15:00	00:15:00	00:18:00	1	Canciones	DESPERTAR	00:03:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	6	2025-10-17 22:27:07.974686+00	\N
15	3	001	00:00:00	00:00:00	00:00:00	00:00:00	ETM	ETM	Inicio del reloj	00:00:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	1	2025-10-17 22:27:07.974686+00	\N
16	3	002	00:00:00	00:00:00	00:00:00	00:05:00	1	Canciones	ALMUERZO	00:05:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	2	2025-10-17 22:27:07.974686+00	\N
17	3	003	00:05:00	00:05:00	00:05:00	00:10:00	2	Corte Comercial	CC 5M	00:05:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	3	2025-10-17 22:27:07.974686+00	\N
18	3	004	00:10:00	00:10:00	00:10:00	00:12:00	4	Cartucho Fijo	HORA_EXACTA	00:02:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	4	2025-10-17 22:27:07.974686+00	\N
19	3	005	00:12:00	00:12:00	00:12:00	00:15:00	1	Canciones	MUSICA_TARDE	00:03:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	5	2025-10-17 22:27:07.974686+00	\N
40	5	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
41	5	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
42	5	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
43	5	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
44	5	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
45	5	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
46	5	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
47	5	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
48	5	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
49	5	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
50	5	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
51	5	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
52	5	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
53	5	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
54	5	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
55	5	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
56	5	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
57	5	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
58	5	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
59	5	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
60	6	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
61	6	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
62	6	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
63	6	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
64	6	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
65	6	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
66	6	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
67	6	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
68	6	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
69	6	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
70	6	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
71	6	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
72	6	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
73	6	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
74	6	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
75	6	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
76	6	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
77	6	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
78	6	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
79	6	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
80	7	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
81	7	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
82	7	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
83	7	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
84	7	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
85	7	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
86	7	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
87	7	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
88	7	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
89	7	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
90	7	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
91	7	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
92	7	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
93	7	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
94	7	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
95	7	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
96	7	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
97	7	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
98	7	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
99	7	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
100	8	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
101	8	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
102	8	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
103	8	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
104	8	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
105	8	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
106	8	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
107	8	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
108	8	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
109	8	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
110	8	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
111	8	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
112	8	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
113	8	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
114	8	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
115	8	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
116	8	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
117	8	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
118	8	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
119	8	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
120	9	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
121	9	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
122	9	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
123	9	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
124	9	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
125	9	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
126	9	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
127	9	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
128	9	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
129	9	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
130	9	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
131	9	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
132	9	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
133	9	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
134	9	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
135	9	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
136	9	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
137	9	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
138	9	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
139	9	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
140	10	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
141	10	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
142	10	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
143	10	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
144	10	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
145	10	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
146	10	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
147	10	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
148	10	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
149	10	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
150	10	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
151	10	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
152	10	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
153	10	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
154	10	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
155	10	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
156	10	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
157	10	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
158	10	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
159	10	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
160	11	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
161	11	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
162	11	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
163	11	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
164	11	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
165	11	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
166	11	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
167	11	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
168	11	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
169	11	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
170	11	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
171	11	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
172	11	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
173	11	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
174	11	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
175	11	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
176	11	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
177	11	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
178	11	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
179	11	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
180	12	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
181	12	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
182	12	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
183	12	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
184	12	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
185	12	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
186	12	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
187	12	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
188	12	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
189	12	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
190	12	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
191	12	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
192	12	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
193	12	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
194	12	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
195	12	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
196	12	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
197	12	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
198	12	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
199	12	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
200	13	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
201	13	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
202	13	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
203	13	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
204	13	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
205	13	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
206	13	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
207	13	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
208	13	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
209	13	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
210	13	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
211	13	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
212	13	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
213	13	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
214	13	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
215	13	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
216	13	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
217	13	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
218	13	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
219	13	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
220	14	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
221	14	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
222	14	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
223	14	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
224	14	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
225	14	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
226	14	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
227	14	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
228	14	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
229	14	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
230	14	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
231	14	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
232	14	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
233	14	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
234	14	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
235	14	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
236	14	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
237	14	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
238	14	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
239	14	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
240	15	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
241	15	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
242	15	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
243	15	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
244	15	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
245	15	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
246	15	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
247	15	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
248	15	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
249	15	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
250	15	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
251	15	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
252	15	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
253	15	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
254	15	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
255	15	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
256	15	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
257	15	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
258	15	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
259	15	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
260	16	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
261	16	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
262	16	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
263	16	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
264	16	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
265	16	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
266	16	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
267	16	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
268	16	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
269	16	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
270	16	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
271	16	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
272	16	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
273	16	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
274	16	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
275	16	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
276	16	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
277	16	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
278	16	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
279	16	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
280	17	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
281	17	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
282	17	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
283	17	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
284	17	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
285	17	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
286	17	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
287	17	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
288	17	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
289	17	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
290	17	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
291	17	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
292	17	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
293	17	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
294	17	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
295	17	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
296	17	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
297	17	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
298	17	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
299	17	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
300	18	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
301	18	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
302	18	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
303	18	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
304	18	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
305	18	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
306	18	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
307	18	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
308	18	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
309	18	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
310	18	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
311	18	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
312	18	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
313	18	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
314	18	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
315	18	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
316	18	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
317	18	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
318	18	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
319	18	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
320	19	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
321	19	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
322	19	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
323	19	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
324	19	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
325	19	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
326	19	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
327	19	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
328	19	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
329	19	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
330	19	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
331	19	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
332	19	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
333	19	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
334	19	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
335	19	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
336	19	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
337	19	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
338	19	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
339	19	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
340	20	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
341	20	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
342	20	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
513	28	014	00:46:13	00:00:00	00:46:13	00:50:13	1	Canciones	Pop	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.743398+00	\N
343	20	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
344	20	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
345	20	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
346	20	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
347	20	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
348	20	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
349	20	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
350	20	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
351	20	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
352	20	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
353	20	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
354	20	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
355	20	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
356	20	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
357	20	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
358	20	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
359	20	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
360	21	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
361	21	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
362	21	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
363	21	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
364	21	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
365	21	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
366	21	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
367	21	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
368	21	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
369	21	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
370	21	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
371	21	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
372	21	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
373	21	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
374	21	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
375	21	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
376	21	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
377	21	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
378	21	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
379	21	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
380	22	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
381	22	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
382	22	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
383	22	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
384	22	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
385	22	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
386	22	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
387	22	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
388	22	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
389	22	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
390	22	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
391	22	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
392	22	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
393	22	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
394	22	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
395	22	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
396	22	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
397	22	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
398	22	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
514	28	015	00:50:14	00:00:00	00:50:14	00:54:14	1	Canciones	Rock	00:04:00	009	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.746501+00	\N
399	22	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
400	23	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
401	23	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
402	23	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
403	23	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
404	23	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
405	23	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
406	23	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
407	23	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
408	23	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
409	23	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
410	23	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
411	23	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
412	23	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
413	23	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
414	23	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
415	23	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
416	23	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
417	23	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
418	23	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
419	23	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
420	24	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
421	24	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
422	24	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
423	24	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
424	24	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
425	24	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
426	24	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
427	24	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
428	24	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
429	24	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
430	24	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
431	24	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
432	24	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
433	24	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
434	24	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
435	24	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
436	24	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
437	24	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
438	24	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
439	24	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
440	25	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
441	25	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
442	25	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
443	25	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
444	25	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
445	25	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
446	25	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
447	25	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
448	25	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
449	25	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
450	25	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
451	25	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
452	25	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
453	25	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
454	25	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
455	25	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
456	25	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
457	25	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
458	25	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
459	25	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
460	26	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
461	26	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
462	26	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
463	26	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
464	26	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
465	26	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
466	26	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
467	26	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
468	26	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
469	26	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
470	26	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
471	26	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
472	26	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
473	26	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
474	26	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
475	26	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
476	26	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
477	26	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
478	26	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
479	26	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
480	27	E01	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 1 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
481	27	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
482	27	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
483	27	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
484	27	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
485	27	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
486	27	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
487	27	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
488	27	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
489	27	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
490	27	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
491	27	E12	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 12 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
492	27	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
493	27	E14	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 14 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
494	27	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
495	27	E16	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 16 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
496	27	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
497	27	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
498	27	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
499	27	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-17 22:27:11.200568+00	\N
500	28	001	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Jazz	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.692715+00	\N
501	28	002	00:04:01	00:00:00	00:04:01	00:08:01	1	Canciones	Pop	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.701609+00	\N
502	28	003	00:08:02	00:00:00	00:08:02	00:12:02	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.705894+00	\N
503	28	004	00:12:03	00:00:00	00:12:03	00:15:03	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.709898+00	\N
504	28	005	00:15:04	00:00:00	00:15:04	00:18:04	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.713518+00	\N
505	28	006	00:18:05	00:00:00	00:18:05	00:21:05	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.717107+00	\N
506	28	007	00:21:06	00:00:00	00:21:06	00:24:06	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.720199+00	\N
507	28	008	00:24:07	00:00:00	00:24:07	00:27:07	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.723625+00	\N
508	28	009	00:27:08	00:00:00	00:27:08	00:30:08	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.726836+00	\N
509	28	010	00:30:09	00:00:00	00:30:09	00:34:09	1	Canciones	Rock	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.729817+00	\N
510	28	011	00:34:10	00:00:00	00:34:10	00:38:10	1	Canciones	Rock	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.733186+00	\N
511	28	012	00:38:11	00:00:00	00:38:11	00:42:11	1	Canciones	Rock	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.736398+00	\N
512	28	013	00:42:12	00:00:00	00:42:12	00:46:12	1	Canciones	Rock	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.740032+00	\N
515	28	016	00:54:15	00:00:00	00:54:15	00:58:15	1	Canciones	Rock	00:04:00	010	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.749411+00	\N
516	28	017	00:58:16	00:00:00	00:58:16	01:02:16	1	Canciones	Rock	00:04:00	011	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:27:20.752293+00	\N
517	4	E02	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 2 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.010958+00	\N
518	4	E03	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 3 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.015381+00	\N
519	4	E04	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 4 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.019128+00	\N
520	4	E05	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 5 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.022475+00	\N
521	4	E06	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 6 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.025819+00	\N
522	4	E07	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 7 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.029012+00	\N
523	4	E08	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 8 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.032203+00	\N
524	4	E09	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 9 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.036899+00	\N
525	4	E10	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 10 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.0413+00	\N
526	4	E11	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 11 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.045885+00	\N
527	4	E13	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 13 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.050291+00	\N
528	4	E15	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 15 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.054643+00	\N
529	4	E17	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 17 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.058939+00	\N
530	4	E18	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Pop	Evento 18 - Pop	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.063447+00	\N
531	4	E19	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Rock	Evento 19 - Rock	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.067663+00	\N
532	4	E20	00:00:00	00:00:00	00:00:00	00:00:00	cancion	Jazz	Evento 20 - Jazz	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.072089+00	\N
533	4	017	00:00:01	00:00:00	00:00:01	00:03:01	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.076354+00	\N
534	4	018	00:03:02	00:00:00	00:03:02	00:06:02	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.080648+00	\N
535	4	019	00:06:03	00:00:00	00:06:03	00:09:03	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.084937+00	\N
536	4	020	00:09:04	00:00:00	00:09:04	00:12:04	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 01:28:25.089222+00	\N
537	30	001	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Pop	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.905392+00	\N
538	30	002	00:04:01	00:00:00	00:04:01	00:08:01	1	Canciones	Rock	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.915297+00	\N
539	30	003	00:08:02	00:00:00	00:08:02	00:12:02	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.921539+00	\N
540	30	004	00:12:03	00:00:00	00:12:03	00:16:03	1	Canciones	Rock	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.925784+00	\N
541	30	005	00:16:04	00:00:00	00:16:04	00:19:04	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.929887+00	\N
542	30	006	00:19:05	00:00:00	00:19:05	00:22:05	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.933606+00	\N
543	30	007	00:22:06	00:00:00	00:22:06	00:25:06	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.937373+00	\N
544	30	008	00:25:07	00:00:00	00:25:07	00:28:07	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.941115+00	\N
545	30	009	00:28:08	00:00:00	00:28:08	00:31:08	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.944315+00	\N
546	30	010	00:31:09	00:00:00	00:31:09	00:34:09	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.947898+00	\N
547	30	011	00:34:10	00:00:00	00:34:10	00:38:10	1	Canciones	Pop	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.950889+00	\N
548	30	012	00:38:11	00:00:00	00:38:11	00:42:11	1	Canciones	Pop	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.95411+00	\N
549	30	013	00:42:12	00:00:00	00:42:12	00:45:12	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.957363+00	\N
550	30	014	00:45:13	00:00:00	00:45:13	00:48:13	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.960378+00	\N
551	30	015	00:48:14	00:00:00	00:48:14	00:52:14	1	Canciones	Rock	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.963298+00	\N
552	30	016	00:52:15	00:00:00	00:52:15	00:56:15	1	Canciones	Rock	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.966103+00	\N
553	30	017	00:56:16	00:00:00	00:56:16	00:59:16	2	Corte Comercial	Corte 2	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.968864+00	\N
554	30	018	00:59:17	00:00:00	00:59:17	01:02:17	2	Corte Comercial	Corte 1	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-21 02:11:05.971875+00	\N
555	31	001	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Clásica	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.257096+00	\N
556	31	002	00:04:00	00:00:00	00:04:00	00:04:30	2	Corte Comercial	Corte 1	00:00:30	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.280417+00	\N
557	31	003	00:04:30	00:00:00	00:04:30	00:05:15	2	Corte Comercial	Corte de Prueba API	00:00:45	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.287197+00	\N
558	31	004	00:05:15	00:00:00	00:05:15	00:08:15	2	Corte Comercial	GRAL_XHGR	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.293236+00	\N
559	31	005	00:08:15	00:00:00	00:08:15	00:18:15	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.299453+00	\N
560	31	006	00:18:15	00:00:00	00:18:15	00:19:15	5	LINEA_INOLVIDABLE	LINEA INOLVIDABLE	00:01:00	-	-	LINEA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.303774+00	\N
561	31	007	00:19:15	00:00:00	00:19:15	00:20:15	5	HORA_EXACTA	HORA EXACTA	00:01:00	-	-	HORA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.30794+00	\N
562	31	008	00:20:15	00:00:00	00:20:15	00:30:15	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.312869+00	\N
563	31	009	00:30:15	00:00:00	00:30:15	00:31:15	5	LINEA_INOLVIDABLE	LINEA INOLVIDABLE	00:01:00	-	-	LINEA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.316881+00	\N
564	31	010	00:31:15	00:00:00	00:31:15	00:32:15	5	HORA_EXACTA	HORA EXACTA	00:01:00	-	-	HORA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.32064+00	\N
565	31	011	00:32:15	00:00:00	00:32:15	00:33:15	5	HIMNO	HIMNO NACIONAL	00:01:00	-	-	HIMNO001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.324012+00	\N
566	31	012	00:33:15	00:00:00	00:33:15	00:36:15	2	Corte Comercial	GRAL_XHGR	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.328084+00	\N
567	31	013	00:36:15	00:00:00	00:36:15	00:37:15	5	IDENTIFICACION	IDENTIFICACION	00:01:00	-	-	ID001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.331158+00	\N
568	31	014	00:37:15	00:00:00	00:37:15	00:37:15	6	ETM	Cortar canción	00:00:00	-	-	\N	\N	Cortar canción	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.334908+00	\N
569	31	015	00:37:15	00:00:00	00:37:15	00:37:15	6	ETM	Cortar canción	00:00:00	-	-	\N	\N	Cortar canción	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.339781+00	\N
570	31	016	00:37:15	00:00:00	00:37:15	00:41:15	1	Canciones	Clásica	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.343426+00	\N
571	31	017	00:41:15	00:00:00	00:41:15	00:45:15	1	Canciones	Instrumental	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.346917+00	\N
572	31	018	00:45:15	00:00:00	00:45:15	00:49:15	1	Canciones	Reggaeton	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.350623+00	\N
577	31	023	00:58:15	00:00:00	00:58:15	01:01:15	2	Corte Comercial	GRAL_XHGR	00:03:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.368197+00	\N
573	31	019	00:49:15	00:00:00	00:49:15	00:53:15	1	Canciones	Instrumental	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.355412+00	\N
574	31	020	00:53:15	00:00:00	00:53:15	00:57:15	1	Canciones	Clásica	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.358621+00	\N
575	31	021	00:57:15	00:00:00	00:57:15	00:57:30	2	Corte Comercial	Corte 2	00:00:15	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.361927+00	\N
576	31	022	00:57:30	00:00:00	00:57:30	00:58:15	2	Corte Comercial	Corte de Prueba API	00:00:45	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:07:16.365008+00	\N
578	32	001	00:00:00	00:00:00	00:00:00	00:00:00	6	ETM	Cortar canción	00:00:00	-	-	\N	\N	Cortar canción	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.304864+00	\N
579	32	002	00:00:00	00:00:00	00:00:00	00:04:00	1	Canciones	Pop	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.315945+00	\N
580	32	003	00:04:00	00:00:00	00:04:00	00:08:00	1	Canciones	Jazz	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.322312+00	\N
581	32	004	00:08:00	00:00:00	00:08:00	00:12:00	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.327493+00	\N
582	32	005	00:12:00	00:00:00	00:12:00	00:16:00	1	Canciones	Jazz	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.332399+00	\N
583	32	006	00:16:00	00:00:00	00:16:00	00:16:30	2	Corte Comercial	Corte 1	00:00:30	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.338741+00	\N
584	32	007	00:16:30	00:00:00	00:16:30	00:16:45	2	Corte Comercial	Corte 2	00:00:15	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.343257+00	\N
585	32	008	00:16:45	00:00:00	00:16:45	00:26:45	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.348384+00	\N
586	32	009	00:26:45	00:00:00	00:26:45	00:27:45	5	HORA_EXACTA	HORA EXACTA	00:01:00	-	-	HORA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.35267+00	\N
587	32	010	00:27:45	00:00:00	00:27:45	00:28:45	5	IDENTIFICACION	IDENTIFICACION	00:01:00	-	-	ID001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.35747+00	\N
588	32	011	00:28:45	00:00:00	00:28:45	00:29:45	5	LINEA_INOLVIDABLE	LINEA INOLVIDABLE	00:01:00	-	-	LINEA001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.36175+00	\N
589	32	012	00:29:45	00:00:00	00:29:45	00:33:45	1	Canciones	Rock	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.366189+00	\N
590	32	013	00:33:45	00:00:00	00:33:45	00:37:45	1	Canciones	Jazz	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.37009+00	\N
591	32	014	00:37:45	00:00:00	00:37:45	00:41:45	1	Canciones	Rock	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.374339+00	\N
592	32	015	00:41:45	00:00:00	00:41:45	00:42:15	2	Corte Comercial	Corte de Prueba DB	00:00:30	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.378478+00	\N
593	32	016	00:42:15	00:00:00	00:42:15	00:42:45	2	Corte Comercial	Corte de Prueba DB	00:00:30	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.385798+00	\N
594	32	017	00:42:45	00:00:00	00:42:45	00:52:45	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.390089+00	\N
595	32	018	00:52:45	00:00:00	00:52:45	00:56:45	1	Canciones	Jazz	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.394137+00	\N
596	32	019	00:56:45	00:00:00	00:56:45	01:00:45	1	Canciones	Jazz	00:04:00	009	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-30 21:21:33.39864+00	\N
629	33	001	00:00:00	00:00:00	00:00:00	00:00:00	6	ETM	Esperar a terminar	00:00:00	-	-	\N	\N	espera	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.292752+00	\N
630	33	002	00:00:00	00:00:00	00:00:00	00:01:00	5	HIMNO	HIMNO NACIONAL	00:01:00	-	-	HIMNO001	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.300378+00	\N
631	33	003	00:01:00	00:00:00	00:01:00	00:11:00	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.305578+00	\N
632	33	004	00:11:00	00:00:00	00:11:00	00:21:00	4	Vacío	Corte 3	00:10:00	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.310321+00	\N
633	33	005	00:21:00	00:00:00	00:21:00	00:21:30	2	Corte Comercial	Corte 1	00:00:30	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.315063+00	\N
634	33	006	00:21:30	00:00:00	00:21:30	00:21:45	2	Corte Comercial	Corte 2	00:00:15	-	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.319796+00	\N
635	33	007	00:21:45	00:00:00	00:21:45	00:25:45	1	Canciones	Jazz	00:04:00	001	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.32429+00	\N
636	33	008	00:25:45	00:00:00	00:25:45	00:29:45	1	Canciones	Electrónica	00:04:00	002	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.328942+00	\N
637	33	009	00:29:45	00:00:00	00:29:45	00:33:45	1	Canciones	Rock	00:04:00	003	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.334208+00	\N
638	33	010	00:33:45	00:00:00	00:33:45	00:37:45	1	Canciones	Pop	00:04:00	004	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.339321+00	\N
639	33	011	00:37:45	00:00:00	00:37:45	00:41:45	1	Canciones	Rock	00:04:00	005	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.34477+00	\N
640	33	012	00:41:45	00:00:00	00:41:45	00:45:45	1	Canciones	Jazz	00:04:00	006	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.34928+00	\N
641	33	013	00:45:45	00:00:00	00:45:45	00:49:45	1	Canciones	Pop	00:04:00	007	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.354429+00	\N
642	33	014	00:49:45	00:00:00	00:49:45	00:53:45	1	Canciones	Pop	00:04:00	008	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.359696+00	\N
643	33	015	00:53:45	00:00:00	00:53:45	00:57:45	1	Canciones	Pop	00:04:00	009	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.365119+00	\N
644	33	016	00:57:45	00:00:00	00:57:45	01:01:45	1	Canciones	Pop	00:04:00	010	-	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	t	\N	\N	\N	0	2025-10-31 18:17:04.369942+00	\N
\.


--
-- Data for Name: politica_categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.politica_categorias (id, politica_id, categoria_nombre, created_at, updated_at) FROM stdin;
1	1	Pop	2025-11-03 21:30:06.351496+00	\N
2	1	Rock	2025-11-03 21:30:06.351496+00	\N
3	1	Jazz	2025-11-03 21:30:06.351496+00	\N
4	5	Pop	2025-11-03 21:30:06.351496+00	\N
5	5	Rock	2025-11-03 21:30:06.351496+00	\N
6	5	Jazz	2025-11-03 21:30:06.351496+00	\N
\.


--
-- Data for Name: programacion; Type: TABLE DATA; Schema: public; Owner: postgres
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
2823	t	R06	04:57:20	04:57:20	00:03:20	cancion	04:57:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	157	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2824	t	R06	05:00:40	05:00:40	00:03:20	cancion	05:00:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	158	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2825	t	R06	05:04:00	05:04:00	00:02:40	cancion	05:04:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	10	159	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2826	t	R07	05:06:40	05:06:40	00:03:20	cancion	05:06:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	160	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2827	t	R07	05:10:00	05:10:00	00:03:20	cancion	05:10:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	161	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2828	t	R07	05:13:20	05:13:20	00:03:20	cancion	05:13:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	162	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2829	t	R07	05:16:40	05:16:40	00:03:00	cancion	05:16:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	11	163	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2830	t	R07	05:19:40	05:19:40	00:02:40	cancion	05:19:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	11	164	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2831	t	R07	05:22:20	05:22:20	00:03:00	cancion	05:22:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	11	165	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2832	t	R07	05:25:20	05:25:20	00:03:20	cancion	05:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	166	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2833	t	R07	05:28:40	05:28:40	00:02:40	cancion	05:28:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	11	167	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2834	t	R07	05:31:20	05:31:20	00:03:00	cancion	05:31:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	11	168	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2835	t	R07	05:34:20	05:34:20	00:02:40	cancion	05:34:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	11	169	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2836	t	R07	05:37:00	05:37:00	00:03:20	cancion	05:37:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	170	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2837	t	R07	05:40:20	05:40:20	00:03:00	cancion	05:40:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	11	171	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2838	t	R07	05:43:20	05:43:20	00:03:20	cancion	05:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	172	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2839	t	R07	05:46:40	05:46:40	00:02:40	cancion	05:46:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	11	173	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2840	t	R07	05:49:20	05:49:20	00:03:20	cancion	05:49:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	174	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2841	t	R07	05:52:40	05:52:40	00:03:20	cancion	05:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	175	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2842	t	R07	05:56:00	05:56:00	00:03:00	cancion	05:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	11	176	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2843	t	R07	05:59:00	05:59:00	00:03:20	cancion	05:59:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	177	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2844	t	R07	06:02:20	06:02:20	00:03:20	cancion	06:02:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	178	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
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
2845	t	R07	06:05:40	06:05:40	00:03:20	cancion	06:05:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	11	179	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2846	t	R08	06:09:00	06:09:00	00:03:20	cancion	06:09:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	180	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2847	t	R08	06:12:20	06:12:20	00:02:40	cancion	06:12:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	12	181	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2848	t	R08	06:15:00	06:15:00	00:03:20	cancion	06:15:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	182	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2849	t	R08	06:18:20	06:18:20	00:03:20	cancion	06:18:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	183	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
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
2850	t	R08	06:21:40	06:21:40	00:03:20	cancion	06:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	184	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2851	t	R08	06:25:00	06:25:00	00:03:20	cancion	06:25:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	185	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2852	t	R08	06:28:20	06:28:20	00:03:20	cancion	06:28:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	186	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2853	t	R08	06:31:40	06:31:40	00:03:20	cancion	06:31:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	187	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2854	t	R08	06:35:00	06:35:00	00:03:20	cancion	06:35:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	188	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2855	t	R08	06:38:20	06:38:20	00:03:00	cancion	06:38:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	12	189	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2856	t	R08	06:41:20	06:41:20	00:03:00	cancion	06:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	12	190	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2857	t	R08	06:44:20	06:44:20	00:03:20	cancion	06:44:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	191	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2858	t	R08	06:47:40	06:47:40	00:02:40	cancion	06:47:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	12	192	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2859	t	R08	06:50:20	06:50:20	00:03:20	cancion	06:50:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	193	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2860	t	R08	06:53:40	06:53:40	00:02:40	cancion	06:53:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	12	194	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2861	t	R08	06:56:20	06:56:20	00:03:20	cancion	06:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	195	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2862	t	R08	06:59:40	06:59:40	00:03:00	cancion	06:59:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	12	196	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2863	t	R08	07:02:40	07:02:40	00:03:20	cancion	07:02:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	12	197	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2864	t	R08	07:06:00	07:06:00	00:02:40	cancion	07:06:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	12	198	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2865	t	R08	07:08:40	07:08:40	00:03:00	cancion	07:08:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	12	199	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2866	t	R09	07:11:40	07:11:40	00:03:20	cancion	07:11:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	200	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2867	t	R09	07:15:00	07:15:00	00:02:40	cancion	07:15:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	13	201	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2868	t	R09	07:17:40	07:17:40	00:03:20	cancion	07:17:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	202	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2869	t	R09	07:21:00	07:21:00	00:03:20	cancion	07:21:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	203	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2870	t	R09	07:24:20	07:24:20	00:03:20	cancion	07:24:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	204	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2871	t	R09	07:27:40	07:27:40	00:03:20	cancion	07:27:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	205	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2726	t	R02	00:00:00	00:00:00	00:02:40	cancion	00:00:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	6	60	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2727	t	R02	00:02:40	00:02:40	00:03:00	cancion	00:02:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	6	61	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2728	t	R02	00:05:40	00:05:40	00:03:20	cancion	00:05:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	62	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2729	t	R02	00:09:00	00:09:00	00:03:00	cancion	00:09:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	6	63	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2730	t	R02	00:12:00	00:12:00	00:03:20	cancion	00:12:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	64	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2731	t	R02	00:15:20	00:15:20	00:03:20	cancion	00:15:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	65	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2732	t	R02	00:18:40	00:18:40	00:03:20	cancion	00:18:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	66	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2733	t	R02	00:22:00	00:22:00	00:02:40	cancion	00:22:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	6	67	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2734	t	R02	00:24:40	00:24:40	00:03:20	cancion	00:24:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	68	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2735	t	R02	00:28:00	00:28:00	00:02:40	cancion	00:28:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	6	69	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2736	t	R02	00:30:40	00:30:40	00:03:20	cancion	00:30:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	70	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2737	t	R02	00:34:00	00:34:00	00:03:20	cancion	00:34:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	71	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2738	t	R02	00:37:20	00:37:20	00:03:00	cancion	00:37:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	6	72	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2739	t	R02	00:40:20	00:40:20	00:02:40	cancion	00:40:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	6	73	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2740	t	R02	00:43:00	00:43:00	00:03:20	cancion	00:43:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	74	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2741	t	R02	00:46:20	00:46:20	00:03:00	cancion	00:46:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	6	75	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2742	t	R02	00:49:20	00:49:20	00:03:20	cancion	00:49:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	76	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2743	t	R02	00:52:40	00:52:40	00:03:20	cancion	00:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	77	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2744	t	R02	00:56:00	00:56:00	00:03:20	cancion	00:56:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	6	78	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2745	t	R02	00:59:20	00:59:20	00:03:00	cancion	00:59:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	6	79	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2746	t	R03	01:02:20	01:02:20	00:02:40	cancion	01:02:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	80	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2747	t	R03	01:05:00	01:05:00	00:03:20	cancion	01:05:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	81	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2748	t	R03	01:08:20	01:08:20	00:03:20	cancion	01:08:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	82	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2749	t	R03	01:11:40	01:11:40	00:03:20	cancion	01:11:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	83	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2750	t	R03	01:15:00	01:15:00	00:03:20	cancion	01:15:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	84	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2751	t	R03	01:18:20	01:18:20	00:03:00	cancion	01:18:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	85	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2752	t	R03	01:21:20	01:21:20	00:02:40	cancion	01:21:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	86	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2753	t	R03	01:24:00	01:24:00	00:03:20	cancion	01:24:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	87	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2754	t	R03	01:27:20	01:27:20	00:02:40	cancion	01:27:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	88	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2755	t	R03	01:30:00	01:30:00	00:03:00	cancion	01:30:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	89	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2756	t	R03	01:33:00	01:33:00	00:03:00	cancion	01:33:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	90	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2757	t	R03	01:36:00	01:36:00	00:02:40	cancion	01:36:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	91	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2758	t	R03	01:38:40	01:38:40	00:02:40	cancion	01:38:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	92	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2759	t	R03	01:41:20	01:41:20	00:03:00	cancion	01:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	93	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2760	t	R03	01:44:20	01:44:20	00:03:20	cancion	01:44:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	94	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2761	t	R03	01:47:40	01:47:40	00:03:20	cancion	01:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	7	95	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2762	t	R03	01:51:00	01:51:00	00:02:40	cancion	01:51:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	96	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2763	t	R03	01:53:40	01:53:40	00:03:00	cancion	01:53:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	97	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2764	t	R03	01:56:40	01:56:40	00:02:40	cancion	01:56:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	7	98	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2765	t	R03	01:59:20	01:59:20	00:03:00	cancion	01:59:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	7	99	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2766	t	R04	02:02:20	02:02:20	00:02:40	cancion	02:02:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	8	100	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2767	t	R04	02:05:00	02:05:00	00:03:00	cancion	02:05:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	8	101	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2768	t	R04	02:08:00	02:08:00	00:03:20	cancion	02:08:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	102	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2769	t	R04	02:11:20	02:11:20	00:03:20	cancion	02:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	103	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2770	t	R04	02:14:40	02:14:40	00:03:20	cancion	02:14:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	104	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2771	t	R04	02:18:00	02:18:00	00:03:20	cancion	02:18:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	105	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2772	t	R04	02:21:20	02:21:20	00:02:40	cancion	02:21:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	8	106	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2773	t	R04	02:24:00	02:24:00	00:03:20	cancion	02:24:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	107	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2774	t	R04	02:27:20	02:27:20	00:03:20	cancion	02:27:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	108	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2775	t	R04	02:30:40	02:30:40	00:03:20	cancion	02:30:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	109	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2776	t	R04	02:34:00	02:34:00	00:03:00	cancion	02:34:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	8	110	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2777	t	R04	02:37:00	02:37:00	00:03:00	cancion	02:37:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	8	111	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2778	t	R04	02:40:00	02:40:00	00:03:20	cancion	02:40:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	112	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2779	t	R04	02:43:20	02:43:20	00:03:20	cancion	02:43:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	113	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2780	t	R04	02:46:40	02:46:40	00:03:20	cancion	02:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	8	114	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2781	t	R04	02:50:00	02:50:00	00:02:40	cancion	02:50:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	8	115	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2782	t	R04	02:52:40	02:52:40	00:03:00	cancion	02:52:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	8	116	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2783	t	R04	02:55:40	02:55:40	00:02:40	cancion	02:55:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	8	117	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2784	t	R04	02:58:20	02:58:20	00:03:00	cancion	02:58:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	8	118	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2785	t	R04	03:01:20	03:01:20	00:02:40	cancion	03:01:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	8	119	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2786	t	R05	03:04:00	03:04:00	00:02:40	cancion	03:04:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	120	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2787	t	R05	03:06:40	03:06:40	00:03:00	cancion	03:06:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	9	121	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2788	t	R05	03:09:40	03:09:40	00:02:40	cancion	03:09:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	122	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2789	t	R05	03:12:20	03:12:20	00:03:20	cancion	03:12:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	123	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2790	t	R05	03:15:40	03:15:40	00:03:20	cancion	03:15:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	124	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2791	t	R05	03:19:00	03:19:00	00:03:00	cancion	03:19:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	9	125	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2792	t	R05	03:22:00	03:22:00	00:03:20	cancion	03:22:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	126	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2793	t	R05	03:25:20	03:25:20	00:03:20	cancion	03:25:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	127	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2794	t	R05	03:28:40	03:28:40	00:03:20	cancion	03:28:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	128	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2795	t	R05	03:32:00	03:32:00	00:03:20	cancion	03:32:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	129	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2796	t	R05	03:35:20	03:35:20	00:03:00	cancion	03:35:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	9	130	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2797	t	R05	03:38:20	03:38:20	00:02:40	cancion	03:38:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	131	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2798	t	R05	03:41:00	03:41:00	00:02:40	cancion	03:41:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	132	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2799	t	R05	03:43:40	03:43:40	00:03:00	cancion	03:43:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	9	133	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2800	t	R05	03:46:40	03:46:40	00:03:20	cancion	03:46:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	134	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2801	t	R05	03:50:00	03:50:00	00:02:40	cancion	03:50:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	135	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2802	t	R05	03:52:40	03:52:40	00:03:20	cancion	03:52:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	136	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2803	t	R05	03:56:00	03:56:00	00:03:00	cancion	03:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	9	137	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2804	t	R05	03:59:00	03:59:00	00:02:40	cancion	03:59:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	9	138	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2805	t	R05	04:01:40	04:01:40	00:03:20	cancion	04:01:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	9	139	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
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
2806	t	R06	04:05:00	04:05:00	00:03:00	cancion	04:05:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	10	140	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2807	t	R06	04:08:00	04:08:00	00:03:20	cancion	04:08:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	141	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2808	t	R06	04:11:20	04:11:20	00:03:20	cancion	04:11:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	142	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2809	t	R06	04:14:40	04:14:40	00:03:00	cancion	04:14:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	10	143	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2810	t	R06	04:17:40	04:17:40	00:03:20	cancion	04:17:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	144	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2811	t	R06	04:21:00	04:21:00	00:03:20	cancion	04:21:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	145	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2812	t	R06	04:24:20	04:24:20	00:02:40	cancion	04:24:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	10	146	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2813	t	R06	04:27:00	04:27:00	00:02:40	cancion	04:27:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	10	147	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2814	t	R06	04:29:40	04:29:40	00:03:20	cancion	04:29:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	148	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2815	t	R06	04:33:00	04:33:00	00:03:00	cancion	04:33:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	10	149	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2816	t	R06	04:36:00	04:36:00	00:03:20	cancion	04:36:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	150	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2817	t	R06	04:39:20	04:39:20	00:03:00	cancion	04:39:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	10	151	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2818	t	R06	04:42:20	04:42:20	00:03:20	cancion	04:42:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	152	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2819	t	R06	04:45:40	04:45:40	00:02:40	cancion	04:45:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	10	153	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2820	t	R06	04:48:20	04:48:20	00:03:00	cancion	04:48:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	10	154	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2821	t	R06	04:51:20	04:51:20	00:02:40	cancion	04:51:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	10	155	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2822	t	R06	04:54:00	04:54:00	00:03:20	cancion	04:54:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	10	156	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2872	t	R09	07:31:00	07:31:00	00:03:20	cancion	07:31:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	206	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2873	t	R09	07:34:20	07:34:20	00:03:20	cancion	07:34:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	207	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2874	t	R09	07:37:40	07:37:40	00:03:20	cancion	07:37:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	208	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2875	t	R09	07:41:00	07:41:00	00:03:20	cancion	07:41:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	209	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2876	t	R09	07:44:20	07:44:20	00:03:00	cancion	07:44:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	13	210	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2877	t	R09	07:47:20	07:47:20	00:02:40	cancion	07:47:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	13	211	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2878	t	R09	07:50:00	07:50:00	00:03:00	cancion	07:50:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	13	212	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2879	t	R09	07:53:00	07:53:00	00:03:20	cancion	07:53:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	213	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2880	t	R09	07:56:20	07:56:20	00:03:20	cancion	07:56:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	214	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2881	t	R09	07:59:40	07:59:40	00:03:20	cancion	07:59:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	13	215	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2882	t	R09	08:03:00	08:03:00	00:02:40	cancion	08:03:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	13	216	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2883	t	R09	08:05:40	08:05:40	00:03:00	cancion	08:05:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	13	217	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2884	t	R09	08:08:40	08:08:40	00:03:00	cancion	08:08:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	13	218	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2885	t	R10	08:11:40	08:11:40	00:02:40	cancion	08:11:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	220	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2886	t	R10	08:14:20	08:14:20	00:02:40	cancion	08:14:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	221	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2887	t	R10	08:17:00	08:17:00	00:03:00	cancion	08:17:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	14	222	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2888	t	R10	08:20:00	08:20:00	00:02:40	cancion	08:20:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	223	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2889	t	R10	08:22:40	08:22:40	00:03:20	cancion	08:22:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	224	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2890	t	R10	08:26:00	08:26:00	00:03:00	cancion	08:26:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	14	225	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2891	t	R10	08:29:00	08:29:00	00:03:20	cancion	08:29:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	226	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2892	t	R10	08:32:20	08:32:20	00:02:40	cancion	08:32:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	227	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2893	t	R10	08:35:00	08:35:00	00:03:00	cancion	08:35:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	14	228	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2894	t	R10	08:38:00	08:38:00	00:03:00	cancion	08:38:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	14	229	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2895	t	R10	08:41:00	08:41:00	00:03:20	cancion	08:41:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	230	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2896	t	R10	08:44:20	08:44:20	00:03:20	cancion	08:44:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	231	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2897	t	R10	08:47:40	08:47:40	00:03:20	cancion	08:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	232	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2898	t	R10	08:51:00	08:51:00	00:03:20	cancion	08:51:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	233	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2899	t	R10	08:54:20	08:54:20	00:03:20	cancion	08:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	234	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2900	t	R10	08:57:40	08:57:40	00:02:40	cancion	08:57:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	235	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2901	t	R10	09:00:20	09:00:20	00:03:20	cancion	09:00:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	236	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2902	t	R10	09:03:40	09:03:40	00:02:40	cancion	09:03:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	14	237	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2903	t	R10	09:06:20	09:06:20	00:03:20	cancion	09:06:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	14	238	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2904	t	R10	09:09:40	09:09:40	00:03:00	cancion	09:09:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	14	239	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2905	t	R11	09:12:40	09:12:40	00:03:20	cancion	09:12:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	240	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2906	t	R11	09:16:00	09:16:00	00:02:40	cancion	09:16:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	241	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2907	t	R11	09:18:40	09:18:40	00:03:00	cancion	09:18:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	242	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2908	t	R11	09:21:40	09:21:40	00:03:00	cancion	09:21:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	243	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2909	t	R11	09:24:40	09:24:40	00:02:40	cancion	09:24:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	244	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2910	t	R11	09:27:20	09:27:20	00:03:20	cancion	09:27:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	245	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2911	t	R11	09:30:40	09:30:40	00:03:20	cancion	09:30:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	246	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2912	t	R11	09:34:00	09:34:00	00:02:40	cancion	09:34:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	247	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2913	t	R11	09:36:40	09:36:40	00:03:00	cancion	09:36:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	248	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2914	t	R11	09:39:40	09:39:40	00:02:40	cancion	09:39:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	249	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2915	t	R11	09:42:20	09:42:20	00:03:20	cancion	09:42:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	250	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2916	t	R11	09:45:40	09:45:40	00:03:20	cancion	09:45:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	251	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2917	t	R11	09:49:00	09:49:00	00:03:20	cancion	09:49:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	252	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2918	t	R11	09:52:20	09:52:20	00:03:00	cancion	09:52:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	253	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2919	t	R11	09:55:20	09:55:20	00:03:20	cancion	09:55:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	254	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2920	t	R11	09:58:40	09:58:40	00:03:00	cancion	09:58:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	255	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2921	t	R11	10:01:40	10:01:40	00:03:20	cancion	10:01:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	15	256	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2922	t	R11	10:05:00	10:05:00	00:02:40	cancion	10:05:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	257	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2923	t	R11	10:07:40	10:07:40	00:02:40	cancion	10:07:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	15	258	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2924	t	R11	10:10:20	10:10:20	00:03:00	cancion	10:10:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	15	259	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2925	t	R12	10:13:20	10:13:20	00:03:20	cancion	10:13:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	260	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2926	t	R12	10:16:40	10:16:40	00:03:20	cancion	10:16:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	261	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2927	t	R12	10:20:00	10:20:00	00:03:00	cancion	10:20:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	16	262	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2928	t	R12	10:23:00	10:23:00	00:02:40	cancion	10:23:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	263	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2929	t	R12	10:25:40	10:25:40	00:03:20	cancion	10:25:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	264	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2930	t	R12	10:29:00	10:29:00	00:02:40	cancion	10:29:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	265	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2931	t	R12	10:31:40	10:31:40	00:03:20	cancion	10:31:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	266	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2932	t	R12	10:35:00	10:35:00	00:03:20	cancion	10:35:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	267	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2933	t	R12	10:38:20	10:38:20	00:03:00	cancion	10:38:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	16	268	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2934	t	R12	10:41:20	10:41:20	00:03:00	cancion	10:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	16	269	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2935	t	R12	10:44:20	10:44:20	00:03:20	cancion	10:44:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	270	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2936	t	R12	10:47:40	10:47:40	00:03:20	cancion	10:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	271	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2937	t	R12	10:51:00	10:51:00	00:02:40	cancion	10:51:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	272	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2938	t	R12	10:53:40	10:53:40	00:03:20	cancion	10:53:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	273	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2939	t	R12	10:57:00	10:57:00	00:02:40	cancion	10:57:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	274	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2940	t	R12	10:59:40	10:59:40	00:03:00	cancion	10:59:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	16	275	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2941	t	R12	11:02:40	11:02:40	00:02:40	cancion	11:02:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	276	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2942	t	R12	11:05:20	11:05:20	00:03:00	cancion	11:05:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	16	277	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2943	t	R12	11:08:20	11:08:20	00:02:40	cancion	11:08:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	16	278	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2944	t	R12	11:11:00	11:11:00	00:03:20	cancion	11:11:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	16	279	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2945	t	R13	11:14:20	11:14:20	00:03:00	cancion	11:14:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	280	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2946	t	R13	11:17:20	11:17:20	00:02:40	cancion	11:17:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	17	281	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2947	t	R13	11:20:00	11:20:00	00:03:20	cancion	11:20:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	282	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2948	t	R13	11:23:20	11:23:20	00:03:20	cancion	11:23:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	283	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2949	t	R13	11:26:40	11:26:40	00:03:00	cancion	11:26:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	284	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2950	t	R13	11:29:40	11:29:40	00:03:20	cancion	11:29:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	285	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2951	t	R13	11:33:00	11:33:00	00:03:00	cancion	11:33:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	286	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2952	t	R13	11:36:00	11:36:00	00:02:40	cancion	11:36:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	17	287	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2953	t	R13	11:38:40	11:38:40	00:02:40	cancion	11:38:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	17	288	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2954	t	R13	11:41:20	11:41:20	00:03:00	cancion	11:41:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	289	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2955	t	R13	11:44:20	11:44:20	00:03:20	cancion	11:44:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	290	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2956	t	R13	11:47:40	11:47:40	00:03:20	cancion	11:47:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	291	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2957	t	R13	11:51:00	11:51:00	00:03:20	cancion	11:51:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	292	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2958	t	R13	11:54:20	11:54:20	00:03:20	cancion	11:54:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	293	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2959	t	R13	11:57:40	11:57:40	00:03:20	cancion	11:57:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	294	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2960	t	R13	12:01:00	12:01:00	00:03:20	cancion	12:01:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	17	295	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2961	t	R13	12:04:20	12:04:20	00:03:00	cancion	12:04:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	296	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2962	t	R13	12:07:20	12:07:20	00:02:40	cancion	12:07:20	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	17	297	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2963	t	R13	12:10:00	12:10:00	00:02:40	cancion	12:10:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	17	298	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2964	t	R13	12:12:40	12:12:40	00:03:00	cancion	12:12:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	17	299	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2965	t	R14	12:15:40	12:15:40	00:02:40	cancion	12:15:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	18	300	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2966	t	R14	12:18:20	12:18:20	00:03:20	cancion	12:18:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	301	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2967	t	R14	12:21:40	12:21:40	00:03:20	cancion	12:21:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	302	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2968	t	R14	12:25:00	12:25:00	00:03:20	cancion	12:25:00	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	303	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2969	t	R14	12:28:20	12:28:20	00:03:00	cancion	12:28:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	304	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2970	t	R14	12:31:20	12:31:20	00:03:20	cancion	12:31:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	305	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2971	t	R14	12:34:40	12:34:40	00:02:40	cancion	12:34:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	18	306	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2972	t	R14	12:37:20	12:37:20	00:03:00	cancion	12:37:20	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	307	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2973	t	R14	12:40:20	12:40:20	00:03:20	cancion	12:40:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	308	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2974	t	R14	12:43:40	12:43:40	00:02:40	cancion	12:43:40	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	18	309	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2975	t	R14	12:46:20	12:46:20	00:03:20	cancion	12:46:20	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	310	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2976	t	R14	12:49:40	12:49:40	00:03:20	cancion	12:49:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	311	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2977	t	R14	12:53:00	12:53:00	00:03:00	cancion	12:53:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	312	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2978	t	R14	12:56:00	12:56:00	00:03:00	cancion	12:56:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	313	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2979	t	R14	12:59:00	12:59:00	00:02:40	cancion	12:59:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	18	314	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2980	t	R14	13:01:40	13:01:40	00:03:00	cancion	13:01:40	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	315	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2981	t	R14	13:04:40	13:04:40	00:03:20	cancion	13:04:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	316	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2982	t	R14	13:08:00	13:08:00	00:02:40	cancion	13:08:00	00:02:40	Pop	3	Canción 3	Español	Artista 3	Album 3		0	0	XHPER	5	2025-10-29	18	317	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2983	t	R14	13:10:40	13:10:40	00:03:20	cancion	13:10:40	00:03:20	Rock	2	Canción 2	Español	Artista 2	Album 2		0	0	XHPER	5	2025-10-29	18	318	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
2984	t	R14	13:14:00	13:14:00	00:03:00	cancion	13:14:00	00:03:00	Pop	1	Canción 1	Español	Artista 1	Album 1		0	0	XHPER	5	2025-10-29	18	319	5	2025-10-29 23:48:02.985806+00	2025-10-29 23:48:02.985806+00
3108	t	General	00:00:00	00:00:00	00:03:12	1	00:00:00	00:03:12	Jazz	45	Jazz Standard 12	Español	Quartet 4	Live Set 1		0	0	TEST2	3	2025-10-30	28	500	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3109	t	General	00:04:01	00:04:01	00:02:37	1	00:04:01	00:02:37	Pop	10	Pop Hit 7	Español	Artista Pop 1	Álbum Pop 3		0	0	TEST2	3	2025-10-30	28	501	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3110	t	General	00:08:02	00:08:02	00:02:51	1	00:08:02	00:02:51	Rock	144	Rock Extra 1	Español	Banda Rock X2	Álbum Rock X2		0	0	TEST2	3	2025-10-30	28	502	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3111	f	General	00:12:03	00:12:03	00:03:00	2	00:12:03	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	28	503	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3112	f	General	00:15:04	00:15:04	00:03:00	2	00:15:04	00:03:00	Corte Comercial	\N	Corte 1					0	0	TEST2	3	2025-10-30	28	504	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3113	f	General	00:18:05	00:18:05	00:03:00	2	00:18:05	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	28	505	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3114	f	General	00:21:06	00:21:06	00:03:00	2	00:21:06	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	28	506	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3115	f	General	00:24:07	00:24:07	00:03:00	2	00:24:07	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	28	507	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3116	f	General	00:27:08	00:27:08	00:03:00	2	00:27:08	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	28	508	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3117	t	General	00:30:09	00:30:09	00:03:39	1	00:30:09	00:03:39	Rock	192	Rock Extra 49	Español	Banda Rock X10	Álbum Rock X10		0	0	TEST2	3	2025-10-30	28	509	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3118	t	General	00:34:10	00:34:10	00:03:06	1	00:34:10	00:03:06	Rock	19	Rock Track 6	Español	Banda Rock 1	Álbum Rock 3		0	0	TEST2	3	2025-10-30	28	510	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3119	t	General	00:38:11	00:38:11	00:03:26	1	00:38:11	00:03:26	Rock	179	Rock Extra 36	Español	Banda Rock X17	Álbum Rock X7		0	0	TEST2	3	2025-10-30	28	511	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3120	t	General	00:42:12	00:42:12	00:03:11	1	00:42:12	00:03:11	Rock	164	Rock Extra 21	Español	Banda Rock X2	Álbum Rock X2		0	0	TEST2	3	2025-10-30	28	512	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3121	t	General	00:46:13	00:46:13	00:02:36	1	00:46:13	00:02:36	Pop	9	Pop Hit 6	Español	Artista Pop 7	Álbum Pop 2		0	0	TEST2	3	2025-10-30	28	513	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3122	t	General	00:50:14	00:50:14	00:03:07	1	00:50:14	00:03:07	Rock	20	Rock Track 7	Español	Banda Rock 2	Álbum Rock 4		0	0	TEST2	3	2025-10-30	28	514	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3123	t	General	00:54:15	00:54:15	00:03:30	1	00:54:15	00:03:30	Rock	183	Rock Extra 40	Español	Banda Rock X1	Álbum Rock X1		0	0	TEST2	3	2025-10-30	28	515	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3124	t	General	00:58:16	00:58:16	00:03:08	1	00:58:16	00:03:08	Rock	21	Rock Track 8	Español	Banda Rock 3	Álbum Rock 1		0	0	TEST2	3	2025-10-30	28	516	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3002	t	General	00:00:00	00:00:00	00:03:08	1	00:00:00	00:03:08	Jazz	251	Jazz Extra 8	Español	Quartet X9	Live X1		0	0	TEST1	3	2025-10-30	28	500	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3003	t	General	00:03:08	00:03:08	00:02:46	1	00:03:08	00:02:46	Pop	99	Pop Extra 6	Español	Artista Pop X7	Álbum Pop X7		0	0	TEST1	3	2025-10-30	28	501	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3004	t	General	00:05:54	00:05:54	00:03:34	1	00:05:54	00:03:34	Rock	187	Rock Extra 44	Español	Banda Rock X5	Álbum Rock X5		0	0	TEST1	3	2025-10-30	28	502	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3005	f	General	00:09:28	00:09:28	00:03:00	2	00:09:28	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-30	28	503	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3006	f	General	00:12:28	00:12:28	00:03:00	2	00:12:28	00:03:00	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-10-30	28	504	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3007	f	General	00:15:28	00:15:28	00:03:00	2	00:15:28	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-30	28	505	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3008	f	General	00:18:28	00:18:28	00:03:00	2	00:18:28	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-30	28	506	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3009	f	General	00:21:28	00:21:28	00:03:00	2	00:21:28	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-30	28	507	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3010	f	General	00:24:28	00:24:28	00:03:00	2	00:24:28	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-30	28	508	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3011	t	General	00:27:28	00:27:28	00:03:29	1	00:27:28	00:03:29	Rock	182	Rock Extra 39	Español	Banda Rock X20	Álbum Rock X10		0	0	TEST1	3	2025-10-30	28	509	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3012	t	General	00:30:57	00:30:57	00:03:19	1	00:30:57	00:03:19	Rock	172	Rock Extra 29	Español	Banda Rock X10	Álbum Rock X10		0	0	TEST1	3	2025-10-30	28	510	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3013	t	General	00:34:16	00:34:16	00:03:11	1	00:34:16	00:03:11	Rock	164	Rock Extra 21	Español	Banda Rock X2	Álbum Rock X2		0	0	TEST1	3	2025-10-30	28	511	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3014	t	General	00:37:27	00:37:27	00:02:53	1	00:37:27	00:02:53	Rock	146	Rock Extra 3	Español	Banda Rock X4	Álbum Rock X4		0	0	TEST1	3	2025-10-30	28	512	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3015	t	General	00:40:20	00:40:20	00:02:43	1	00:40:20	00:02:43	Pop	96	Pop Extra 3	Español	Artista Pop X4	Álbum Pop X4		0	0	TEST1	3	2025-10-30	28	513	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3016	t	General	00:43:03	00:43:03	00:03:27	1	00:43:03	00:03:27	Rock	180	Rock Extra 37	Español	Banda Rock X18	Álbum Rock X8		0	0	TEST1	3	2025-10-30	28	514	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3017	t	General	00:46:30	00:46:30	00:03:06	1	00:46:30	00:03:06	Rock	159	Rock Extra 16	Español	Banda Rock X17	Álbum Rock X7		0	0	TEST1	3	2025-10-30	28	515	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3018	t	General	00:49:36	00:49:36	00:03:09	1	00:49:36	00:03:09	Rock	162	Rock Extra 19	Español	Banda Rock X20	Álbum Rock X10		0	0	TEST1	3	2025-10-30	28	516	11	2025-10-30 21:43:20.107203+00	2025-10-30 21:43:20.107203+00
3125	t	etm	01:01:24	01:01:24	00:00:00	6	01:01:24	00:00:00	Rock	21	Rock Track 8	Español	Banda Rock 3	Álbum Rock 1		0	0	TEST2	3	2025-10-30	32	578	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3126	t	etm	01:01:24	01:01:24	00:02:57	1	01:01:24	00:02:57	Pop	110	Pop Extra 17	Español	Artista Pop X18	Álbum Pop X8		0	0	TEST2	3	2025-10-30	32	579	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3127	t	etm	01:05:24	01:05:24	00:03:30	1	01:05:24	00:03:30	Jazz	273	Jazz Extra 30	Español	Quartet X6	Live X7		0	0	TEST2	3	2025-10-30	32	580	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3128	t	etm	01:09:24	01:09:24	00:03:40	1	01:09:24	00:03:40	Rock	193	Rock Extra 50	Español	Banda Rock X11	Álbum Rock X1		0	0	TEST2	3	2025-10-30	32	581	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3129	t	etm	01:13:24	01:13:24	00:03:01	1	01:13:24	00:03:01	Jazz	34	Jazz Standard 1	Español	Quartet 2	Live Set 2		0	0	TEST2	3	2025-10-30	32	582	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3130	f	etm	01:17:24	01:17:24	00:00:30	2	01:17:24	00:00:30	Corte Comercial	\N	Corte 1					0	0	TEST2	3	2025-10-30	32	583	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3131	f	etm	01:17:54	01:17:54	00:00:15	2	01:17:54	00:00:15	Corte Comercial	\N	Corte 2					0	0	TEST2	3	2025-10-30	32	584	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3132	f	etm	01:18:09	01:18:09	00:10:00	4	01:18:09	00:10:00	Vacío	\N	Corte 3					0	0	TEST2	3	2025-10-30	32	585	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3133	f	etm	01:28:09	01:28:09	00:01:00	5	01:28:09	00:01:00	HORA_EXACTA	HORA001	HORA EXACTA					0	0	TEST2	3	2025-10-30	32	586	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3134	f	etm	01:29:09	01:29:09	00:01:00	5	01:29:09	00:01:00	IDENTIFICACION	ID001	IDENTIFICACION					0	0	TEST2	3	2025-10-30	32	587	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3135	f	etm	01:30:09	01:30:09	00:01:00	5	01:30:09	00:01:00	LINEA_INOLVIDABLE	LINEA001	LINEA INOLVIDABLE					0	0	TEST2	3	2025-10-30	32	588	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3136	t	etm	01:31:09	01:31:09	00:03:01	1	01:31:09	00:03:01	Rock	14	Rock Track 1	Español	Banda Rock 2	Álbum Rock 2		0	0	TEST2	3	2025-10-30	32	589	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3137	t	etm	01:35:09	01:35:09	00:03:08	1	01:35:09	00:03:08	Jazz	251	Jazz Extra 8	Español	Quartet X9	Live X1		0	0	TEST2	3	2025-10-30	32	590	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3138	t	etm	01:39:09	01:39:09	00:03:10	1	01:39:09	00:03:10	Rock	163	Rock Extra 20	Español	Banda Rock X1	Álbum Rock X1		0	0	TEST2	3	2025-10-30	32	591	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3139	f	etm	01:43:09	01:43:09	00:00:30	2	01:43:09	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST2	3	2025-10-30	32	592	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3140	f	etm	01:43:39	01:43:39	00:00:30	2	01:43:39	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST2	3	2025-10-30	32	593	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3141	f	etm	01:44:09	01:44:09	00:10:00	4	01:44:09	00:10:00	Vacío	\N	Corte 3					0	0	TEST2	3	2025-10-30	32	594	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3142	t	etm	01:54:09	01:54:09	00:03:49	1	01:54:09	00:03:49	Jazz	292	Jazz Extra 49	Español	Quartet X25	Live X2		0	0	TEST2	3	2025-10-30	32	595	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3143	t	etm	01:58:09	01:58:09	00:03:26	1	01:58:09	00:03:26	Jazz	269	Jazz Extra 26	Español	Quartet X2	Live X3		0	0	TEST2	3	2025-10-30	32	596	10	2025-10-31 02:24:06.358302+00	2025-10-31 02:24:06.358302+00
3913	t	General	00:54:15	00:54:15	00:03:06	1	00:54:15	00:03:06	Rock	19	Rock Track 6	Español	Banda Rock 1	Álbum Rock 3		0	0	TEST1	3	2025-10-31	28	515	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3914	t	General	00:58:16	00:58:16	00:01:44	1	00:58:16	00:01:44	Rock	171	Rock Extra 28	Español	Banda Rock X9	Álbum Rock X9		0	0	TEST1	3	2025-10-31	28	516	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3915	f	etm	01:00:00	01:00:00	00:00:00	6	01:00:00	00:00:00	ETM	\N	Guillotina					0	0	TEST1	3	2025-10-31	32	578	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3916	t	etm	01:00:00	01:00:00	00:03:24	1	01:00:00	00:03:24	Pop	137	Pop Extra 44	Español	Artista Pop X5	Álbum Pop X5		0	0	TEST1	3	2025-10-31	32	579	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3917	t	etm	01:04:00	01:04:00	00:03:31	1	01:04:00	00:03:31	Jazz	274	Jazz Extra 31	Español	Quartet X7	Live X8		0	0	TEST1	3	2025-10-31	32	580	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3918	t	etm	01:08:00	01:08:00	00:03:32	1	01:08:00	00:03:32	Rock	185	Rock Extra 42	Español	Banda Rock X3	Álbum Rock X3		0	0	TEST1	3	2025-10-31	32	581	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3919	t	etm	01:12:00	01:12:00	00:03:36	1	01:12:00	00:03:36	Jazz	279	Jazz Extra 36	Español	Quartet X12	Live X5		0	0	TEST1	3	2025-10-31	32	582	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3920	f	etm	01:16:00	01:16:00	00:00:30	2	01:16:00	00:00:30	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-10-31	32	583	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3921	f	etm	01:16:30	01:16:30	00:00:15	2	01:16:30	00:00:15	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	32	584	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3922	f	etm	01:16:45	01:16:45	00:10:00	4	01:16:45	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-10-31	32	585	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3923	f	etm	01:26:45	01:26:45	00:01:00	5	01:26:45	00:01:00	HORA_EXACTA	HORA001	HORA EXACTA					0	0	TEST1	3	2025-10-31	32	586	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3924	f	etm	01:27:45	01:27:45	00:01:00	5	01:27:45	00:01:00	IDENTIFICACION	ID001	IDENTIFICACION					0	0	TEST1	3	2025-10-31	32	587	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3925	f	etm	01:28:45	01:28:45	00:01:00	5	01:28:45	00:01:00	LINEA_INOLVIDABLE	LINEA001	LINEA INOLVIDABLE					0	0	TEST1	3	2025-10-31	32	588	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3926	t	etm	01:29:45	01:29:45	00:03:38	1	01:29:45	00:03:38	Rock	191	Rock Extra 48	Español	Banda Rock X9	Álbum Rock X9		0	0	TEST1	3	2025-10-31	32	589	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3927	t	etm	01:33:45	01:33:45	00:03:14	1	01:33:45	00:03:14	Jazz	47	Jazz Standard 14	Español	Quartet 6	Live Set 3		0	0	TEST1	3	2025-10-31	32	590	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3928	t	etm	01:37:45	01:37:45	00:03:31	1	01:37:45	00:03:31	Rock	184	Rock Extra 41	Español	Banda Rock X2	Álbum Rock X2		0	0	TEST1	3	2025-10-31	32	591	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3929	f	etm	01:41:45	01:41:45	00:00:30	2	01:41:45	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST1	3	2025-10-31	32	592	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3930	f	etm	01:42:15	01:42:15	00:00:30	2	01:42:15	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST1	3	2025-10-31	32	593	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3931	f	etm	01:42:45	01:42:45	00:10:00	4	01:42:45	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-10-31	32	594	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3932	t	etm	01:52:45	01:52:45	00:03:02	1	01:52:45	00:03:02	Jazz	35	Jazz Standard 2	Español	Quartet 3	Live Set 3		0	0	TEST1	3	2025-10-31	32	595	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3933	t	etm	01:56:45	01:56:45	00:03:16	1	01:56:45	00:03:16	Jazz	49	Jazz Standard 16	Español	Quartet 8	Live Set 2		0	0	TEST1	3	2025-10-31	32	596	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3934	f	test	02:00:01	02:00:01	00:00:00	6	02:00:01	00:00:00	ETM	\N	Esperar a terminar					0	0	TEST1	3	2025-10-31	33	629	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3935	f	test	02:00:01	02:00:01	00:01:00	5	02:00:01	00:01:00	HIMNO	HIMNO001	HIMNO NACIONAL					0	0	TEST1	3	2025-10-31	33	630	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3936	f	test	02:01:01	02:01:01	00:10:00	4	02:01:01	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-10-31	33	631	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3937	f	test	02:11:01	02:11:01	00:10:00	4	02:11:01	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-10-31	33	632	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3938	f	test	02:21:01	02:21:01	00:00:30	2	02:21:01	00:00:30	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-10-31	33	633	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3939	f	test	02:21:31	02:21:31	00:00:15	2	02:21:31	00:00:15	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	33	634	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3940	t	test	02:21:46	02:21:46	00:03:03	1	02:21:46	00:03:03	Jazz	36	Jazz Standard 3	Español	Quartet 4	Live Set 1		0	0	TEST1	3	2025-10-31	33	635	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3941	t	test	02:25:46	02:25:46	00:03:48	1	02:25:46	00:03:48	Electrónica	321	EDM Extra 28	Español	DJ X29	Festival X5		0	0	TEST1	3	2025-10-31	33	636	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3942	t	test	02:29:46	02:29:46	00:02:55	1	02:29:46	00:02:55	Rock	148	Rock Extra 5	Español	Banda Rock X6	Álbum Rock X6		0	0	TEST1	3	2025-10-31	33	637	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3943	t	test	02:33:46	02:33:46	00:02:53	1	02:33:46	00:02:53	Pop	106	Pop Extra 13	Español	Artista Pop X14	Álbum Pop X4		0	0	TEST1	3	2025-10-31	33	638	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3944	t	test	02:37:46	02:37:46	00:03:04	1	02:37:46	00:03:04	Rock	157	Rock Extra 14	Español	Banda Rock X15	Álbum Rock X5		0	0	TEST1	3	2025-10-31	33	639	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3945	t	test	02:41:46	02:41:46	00:03:18	1	02:41:46	00:03:18	Jazz	51	Jazz Standard 18	Español	Quartet 1	Live Set 1		0	0	TEST1	3	2025-10-31	33	640	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3946	t	test	02:45:46	02:45:46	00:03:06	1	02:45:46	00:03:06	Pop	119	Pop Extra 26	Español	Artista Pop X7	Álbum Pop X7		0	0	TEST1	3	2025-10-31	33	641	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3947	t	test	02:49:46	02:49:46	00:02:50	1	02:49:46	00:02:50	Pop	103	Pop Extra 10	Español	Artista Pop X11	Álbum Pop X1		0	0	TEST1	3	2025-10-31	33	642	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3948	t	test	02:53:46	02:53:46	00:03:27	1	02:53:46	00:03:27	Pop	140	Pop Extra 47	Español	Artista Pop X8	Álbum Pop X8		0	0	TEST1	3	2025-10-31	33	643	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3949	t	test	02:57:46	02:57:46	00:03:17	1	02:57:46	00:03:17	Pop	130	Pop Extra 37	Español	Artista Pop X18	Álbum Pop X8		0	0	TEST1	3	2025-10-31	33	644	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3950	t	General	00:00:00	00:00:00	00:03:43	1	00:00:00	00:03:43	Jazz	286	Jazz Extra 43	Español	Quartet X19	Live X4		0	0	TEST1	3	2025-11-03	28	500	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3951	t	General	00:04:01	00:04:01	00:02:46	1	00:04:01	00:02:46	Pop	99	Pop Extra 6	Español	Artista Pop X7	Álbum Pop X7		0	0	TEST1	3	2025-11-03	28	501	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3952	t	General	00:08:02	00:08:02	00:03:25	1	00:08:02	00:03:25	Rock	178	Rock Extra 35	Español	Banda Rock X16	Álbum Rock X6		0	0	TEST1	3	2025-11-03	28	502	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3953	f	General	00:12:03	00:12:03	00:03:00	2	00:12:03	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	28	503	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3954	f	General	00:15:04	00:15:04	00:03:00	2	00:15:04	00:03:00	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-11-03	28	504	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3955	f	General	00:18:05	00:18:05	00:03:00	2	00:18:05	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	28	505	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3956	f	General	00:21:06	00:21:06	00:03:00	2	00:21:06	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	28	506	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3957	f	General	00:24:07	00:24:07	00:03:00	2	00:24:07	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	28	507	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3958	f	General	00:27:08	00:27:08	00:03:00	2	00:27:08	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	28	508	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3959	t	General	00:30:09	00:30:09	00:03:04	1	00:30:09	00:03:04	Rock	17	Rock Track 4	Español	Banda Rock 5	Álbum Rock 1		0	0	TEST1	3	2025-11-03	28	509	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3960	t	General	00:34:10	00:34:10	00:02:51	1	00:34:10	00:02:51	Rock	144	Rock Extra 1	Español	Banda Rock X2	Álbum Rock X2		0	0	TEST1	3	2025-11-03	28	510	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3961	t	General	00:38:11	00:38:11	00:03:39	1	00:38:11	00:03:39	Rock	192	Rock Extra 49	Español	Banda Rock X10	Álbum Rock X10		0	0	TEST1	3	2025-11-03	28	511	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3962	t	General	00:42:12	00:42:12	00:03:21	1	00:42:12	00:03:21	Rock	174	Rock Extra 31	Español	Banda Rock X12	Álbum Rock X2		0	0	TEST1	3	2025-11-03	28	512	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3963	t	General	00:46:13	00:46:13	00:03:01	1	00:46:13	00:03:01	Pop	114	Pop Extra 21	Español	Artista Pop X2	Álbum Pop X2		0	0	TEST1	3	2025-11-03	28	513	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3964	t	General	00:50:14	00:50:14	00:03:33	1	00:50:14	00:03:33	Rock	186	Rock Extra 43	Español	Banda Rock X4	Álbum Rock X4		0	0	TEST1	3	2025-11-03	28	514	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3965	t	General	00:54:15	00:54:15	00:03:29	1	00:54:15	00:03:29	Rock	182	Rock Extra 39	Español	Banda Rock X20	Álbum Rock X10		0	0	TEST1	3	2025-11-03	28	515	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3966	t	General	00:58:16	00:58:16	00:01:44	1	00:58:16	00:01:44	Rock	187	Rock Extra 44	Español	Banda Rock X5	Álbum Rock X5		0	0	TEST1	3	2025-11-03	28	516	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3967	f	etm	01:00:00	01:00:00	00:00:00	6	01:00:00	00:00:00	ETM	\N	Guillotina					0	0	TEST1	3	2025-11-03	32	578	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3968	t	etm	01:00:00	01:00:00	00:02:55	1	01:00:00	00:02:55	Pop	108	Pop Extra 15	Español	Artista Pop X16	Álbum Pop X6		0	0	TEST1	3	2025-11-03	32	579	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3969	t	etm	01:04:00	01:04:00	00:03:04	1	01:04:00	00:03:04	Jazz	247	Jazz Extra 4	Español	Quartet X5	Live X5		0	0	TEST1	3	2025-11-03	32	580	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3970	t	etm	01:08:00	01:08:00	00:03:28	1	01:08:00	00:03:28	Rock	181	Rock Extra 38	Español	Banda Rock X19	Álbum Rock X9		0	0	TEST1	3	2025-11-03	32	581	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3971	t	etm	01:12:00	01:12:00	00:03:02	1	01:12:00	00:03:02	Jazz	35	Jazz Standard 2	Español	Quartet 3	Live Set 3		0	0	TEST1	3	2025-11-03	32	582	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3972	f	etm	01:16:00	01:16:00	00:00:30	2	01:16:00	00:00:30	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-11-03	32	583	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3973	f	etm	01:16:30	01:16:30	00:00:15	2	01:16:30	00:00:15	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	32	584	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3974	f	etm	01:16:45	01:16:45	00:10:00	4	01:16:45	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-11-03	32	585	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3975	f	etm	01:26:45	01:26:45	00:01:00	5	01:26:45	00:01:00	HORA_EXACTA	HORA001	HORA EXACTA					0	0	TEST1	3	2025-11-03	32	586	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3976	f	etm	01:27:45	01:27:45	00:01:00	5	01:27:45	00:01:00	IDENTIFICACION	ID001	IDENTIFICACION					0	0	TEST1	3	2025-11-03	32	587	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3977	f	etm	01:28:45	01:28:45	00:01:00	5	01:28:45	00:01:00	LINEA_INOLVIDABLE	LINEA001	LINEA INOLVIDABLE					0	0	TEST1	3	2025-11-03	32	588	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3978	t	etm	01:29:45	01:29:45	00:03:01	1	01:29:45	00:03:01	Rock	14	Rock Track 1	Español	Banda Rock 2	Álbum Rock 2		0	0	TEST1	3	2025-11-03	32	589	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3979	t	etm	01:33:45	01:33:45	00:03:14	1	01:33:45	00:03:14	Jazz	257	Jazz Extra 14	Español	Quartet X15	Live X7		0	0	TEST1	3	2025-11-03	32	590	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3980	t	etm	01:37:45	01:37:45	00:03:05	1	01:37:45	00:03:05	Rock	18	Rock Track 5	Español	Banda Rock 6	Álbum Rock 2		0	0	TEST1	3	2025-11-03	32	591	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3981	f	etm	01:41:45	01:41:45	00:00:30	2	01:41:45	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST1	3	2025-11-03	32	592	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3982	f	etm	01:42:15	01:42:15	00:00:30	2	01:42:15	00:00:30	Corte Comercial	\N	Corte de Prueba DB					0	0	TEST1	3	2025-11-03	32	593	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3983	f	etm	01:42:45	01:42:45	00:10:00	4	01:42:45	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-11-03	32	594	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3984	t	etm	01:52:45	01:52:45	00:03:29	1	01:52:45	00:03:29	Jazz	272	Jazz Extra 29	Español	Quartet X5	Live X6		0	0	TEST1	3	2025-11-03	32	595	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3985	t	etm	01:56:45	01:56:45	00:03:37	1	01:56:45	00:03:37	Jazz	280	Jazz Extra 37	Español	Quartet X13	Live X6		0	0	TEST1	3	2025-11-03	32	596	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3986	f	test	02:00:22	02:00:22	00:00:00	6	02:00:22	00:00:00	ETM	\N	Esperar a terminar					0	0	TEST1	3	2025-11-03	33	629	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3987	f	test	02:00:22	02:00:22	00:01:00	5	02:00:22	00:01:00	HIMNO	HIMNO001	HIMNO NACIONAL					0	0	TEST1	3	2025-11-03	33	630	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3988	f	test	02:01:22	02:01:22	00:10:00	4	02:01:22	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-11-03	33	631	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3989	f	test	02:11:22	02:11:22	00:10:00	4	02:11:22	00:10:00	Vacío	\N	Corte 3					0	0	TEST1	3	2025-11-03	33	632	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3990	f	test	02:21:22	02:21:22	00:00:30	2	02:21:22	00:00:30	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-11-03	33	633	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3991	f	test	02:21:52	02:21:52	00:00:15	2	02:21:52	00:00:15	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-11-03	33	634	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3992	t	test	02:22:07	02:22:07	00:03:40	1	02:22:07	00:03:40	Jazz	283	Jazz Extra 40	Español	Quartet X16	Live X1		0	0	TEST1	3	2025-11-03	33	635	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3993	t	test	02:26:07	02:26:07	00:03:50	1	02:26:07	00:03:50	Electrónica	323	EDM Extra 30	Español	DJ X1	Festival X7		0	0	TEST1	3	2025-11-03	33	636	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3994	t	test	02:30:07	02:30:07	00:03:04	1	02:30:07	00:03:04	Rock	157	Rock Extra 14	Español	Banda Rock X15	Álbum Rock X5		0	0	TEST1	3	2025-11-03	33	637	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3995	t	test	02:34:07	02:34:07	00:03:10	1	02:34:07	00:03:10	Pop	123	Pop Extra 30	Español	Artista Pop X11	Álbum Pop X1		0	0	TEST1	3	2025-11-03	33	638	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3996	t	test	02:38:07	02:38:07	00:02:55	1	02:38:07	00:02:55	Rock	148	Rock Extra 5	Español	Banda Rock X6	Álbum Rock X6		0	0	TEST1	3	2025-11-03	33	639	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3997	t	test	02:42:07	02:42:07	00:03:08	1	02:42:07	00:03:08	Jazz	41	Jazz Standard 8	Español	Quartet 9	Live Set 3		0	0	TEST1	3	2025-11-03	33	640	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3998	t	test	02:46:07	02:46:07	00:02:54	1	02:46:07	00:02:54	Pop	107	Pop Extra 14	Español	Artista Pop X15	Álbum Pop X5		0	0	TEST1	3	2025-11-03	33	641	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3999	t	test	02:50:07	02:50:07	00:03:29	1	02:50:07	00:03:29	Pop	142	Pop Extra 49	Español	Artista Pop X10	Álbum Pop X10		0	0	TEST1	3	2025-11-03	33	642	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
4000	t	test	02:54:07	02:54:07	00:03:13	1	02:54:07	00:03:13	Pop	126	Pop Extra 33	Español	Artista Pop X14	Álbum Pop X4		0	0	TEST1	3	2025-11-03	33	643	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
4001	t	test	02:58:07	02:58:07	00:03:04	1	02:58:07	00:03:04	Pop	117	Pop Extra 24	Español	Artista Pop X5	Álbum Pop X5		0	0	TEST1	3	2025-11-03	33	644	11	2025-11-03 17:47:29.695182+00	2025-11-03 17:47:29.695182+00
3899	t	General	00:04:01	00:04:01	00:03:30	1	00:04:01	00:03:30	Pop	143	Pop Extra 50	Español	Artista Pop X11	Álbum Pop X1		0	0	TEST1	3	2025-10-31	28	501	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3900	t	General	00:08:02	00:08:02	00:03:07	1	00:08:02	00:03:07	Rock	160	Rock Extra 17	Español	Banda Rock X18	Álbum Rock X8		0	0	TEST1	3	2025-10-31	28	502	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3901	f	General	00:12:03	00:12:03	00:03:00	2	00:12:03	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	28	503	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3902	f	General	00:15:04	00:15:04	00:03:00	2	00:15:04	00:03:00	Corte Comercial	\N	Corte 1					0	0	TEST1	3	2025-10-31	28	504	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3903	f	General	00:18:05	00:18:05	00:03:00	2	00:18:05	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	28	505	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3904	f	General	00:21:06	00:21:06	00:03:00	2	00:21:06	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	28	506	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3905	f	General	00:24:07	00:24:07	00:03:00	2	00:24:07	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	28	507	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3906	f	General	00:27:08	00:27:08	00:03:00	2	00:27:08	00:03:00	Corte Comercial	\N	Corte 2					0	0	TEST1	3	2025-10-31	28	508	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3907	t	General	00:30:09	00:30:09	00:02:52	1	00:30:09	00:02:52	Rock	145	Rock Extra 2	Español	Banda Rock X3	Álbum Rock X3		0	0	TEST1	3	2025-10-31	28	509	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3908	t	General	00:34:10	00:34:10	00:03:10	1	00:34:10	00:03:10	Rock	23	Rock Track 10	Español	Banda Rock 5	Álbum Rock 3		0	0	TEST1	3	2025-10-31	28	510	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3909	t	General	00:38:11	00:38:11	00:03:12	1	00:38:11	00:03:12	Rock	165	Rock Extra 22	Español	Banda Rock X3	Álbum Rock X3		0	0	TEST1	3	2025-10-31	28	511	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3910	t	General	00:42:12	00:42:12	00:02:56	1	00:42:12	00:02:56	Rock	149	Rock Extra 6	Español	Banda Rock X7	Álbum Rock X7		0	0	TEST1	3	2025-10-31	28	512	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3911	t	General	00:46:13	00:46:13	00:02:55	1	00:46:13	00:02:55	Pop	108	Pop Extra 15	Español	Artista Pop X16	Álbum Pop X6		0	0	TEST1	3	2025-10-31	28	513	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3912	t	General	00:50:14	00:50:14	00:02:57	1	00:50:14	00:02:57	Rock	150	Rock Extra 7	Español	Banda Rock X8	Álbum Rock X8		0	0	TEST1	3	2025-10-31	28	514	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:00:33.603531+00
3898	t	General	00:00:00	00:00:00	00:03:20	1	00:00:00	00:03:20	Jazz	2	Canción 2	Español	Artista 2	Album 2		0	0	TEST1	3	2025-10-31	28	500	11	2025-10-31 19:00:33.603531+00	2025-10-31 19:47:53.450785+00
\.


--
-- Data for Name: reglas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reglas (id, politica_id, tipo_regla, caracteristica, tipo_separacion, horario, solo_verificar_dia, habilitada, created_at, updated_at, descripcion) FROM stdin;
1	1	Separación Mínima	Artista	Número de Eventos	f	f	t	2025-10-29 17:32:01.005892+00	2025-10-29 17:32:01.005892+00	\N
2	1	Separación Mínima	Artista	Tiempo - Segundos	f	f	t	2025-10-29 19:35:20.6613+00	2025-10-29 19:35:20.6613+00	\N
3	1	Separación Mínima	ID de Canción	Tiempo - Segundos	f	f	t	2025-10-29 19:36:18.470454+00	2025-10-29 19:36:18.470454+00	\N
6	3	Separación Mínima	id_cancion	numero_canciones	f	f	t	2025-10-29 19:52:41.470977+00	2025-10-29 19:52:41.470977+00	\N
7	3	Máxima Diferencia Permitida	artista	numero_canciones	f	f	t	2025-10-29 20:02:25.840467+00	2025-10-29 20:02:25.840467+00	\N
8	3	Máximo de Canciones en Hilera	artista	numero_canciones	f	f	t	2025-10-29 20:06:16.264039+00	2025-10-29 20:06:16.264039+00	\N
9	3	Separación Mínima	artista	tiempo_segundos	f	f	t	2025-10-29 20:15:10.118818+00	2025-10-29 20:15:10.118818+00	Regla de prueba con descripción
10	3	Protección de Días Anteriores	titulo	numero_canciones	f	f	t	2025-10-29 20:16:49.984233+00	2025-10-29 20:16:49.984233+00	asdasdas
4	3	Separación Mínima	id_cancion	numero_eventos	f	f	f	2025-10-29 19:50:31.092593+00	2025-10-31 18:23:42.794262+00	\N
5	3	Separación Mínima	id_cancion	numero_eventos	f	f	f	2025-10-29 19:51:10.895055+00	2025-10-31 18:23:44.164856+00	\N
\.


--
-- Data for Name: relojes_dia_modelo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relojes_dia_modelo (id, dia_modelo_id, reloj_id, orden, created_at, updated_at) FROM stdin;
1	1	2	1	2025-10-17 22:27:07.980834+00	\N
2	1	3	2	2025-10-17 22:27:07.980834+00	\N
3	2	1	1	2025-10-17 22:27:07.980834+00	\N
4	3	1	1	2025-10-17 22:27:07.980834+00	\N
5	3	2	2	2025-10-17 22:27:07.980834+00	\N
6	3	3	3	2025-10-17 22:27:07.980834+00	\N
148	9	32	\N	2025-10-30 21:21:52.115228+00	\N
149	9	28	\N	2025-10-30 21:21:52.115228+00	\N
150	10	28	\N	2025-10-30 21:36:32.726251+00	\N
151	10	32	\N	2025-10-30 21:36:32.726251+00	\N
157	11	28	\N	2025-10-31 03:48:55.603+00	\N
158	11	32	\N	2025-10-31 03:48:55.603+00	\N
159	11	33	\N	2025-10-31 03:48:55.603+00	\N
109	5	6	1	2025-10-17 22:42:24.506751+00	\N
110	5	7	2	2025-10-17 22:42:24.506751+00	\N
111	5	8	3	2025-10-17 22:42:24.506751+00	\N
112	5	9	4	2025-10-17 22:42:24.506751+00	\N
113	5	10	5	2025-10-17 22:42:24.506751+00	\N
114	5	11	6	2025-10-17 22:42:24.506751+00	\N
115	5	12	7	2025-10-17 22:42:24.506751+00	\N
116	5	13	8	2025-10-17 22:42:24.506751+00	\N
117	5	14	9	2025-10-17 22:42:24.506751+00	\N
118	5	15	10	2025-10-17 22:42:24.506751+00	\N
119	5	16	11	2025-10-17 22:42:24.506751+00	\N
120	5	17	12	2025-10-17 22:42:24.506751+00	\N
121	5	18	13	2025-10-17 22:42:24.506751+00	\N
122	6	8	1	2025-10-17 22:42:24.512787+00	\N
123	6	9	2	2025-10-17 22:42:24.512787+00	\N
124	6	10	3	2025-10-17 22:42:24.512787+00	\N
125	6	11	4	2025-10-17 22:42:24.512787+00	\N
126	6	12	5	2025-10-17 22:42:24.512787+00	\N
127	6	13	6	2025-10-17 22:42:24.512787+00	\N
128	6	14	7	2025-10-17 22:42:24.512787+00	\N
129	6	15	8	2025-10-17 22:42:24.512787+00	\N
130	6	16	9	2025-10-17 22:42:24.512787+00	\N
131	6	17	10	2025-10-17 22:42:24.512787+00	\N
132	6	18	11	2025-10-17 22:42:24.512787+00	\N
133	6	19	12	2025-10-17 22:42:24.512787+00	\N
134	6	20	13	2025-10-17 22:42:24.512787+00	\N
135	6	21	14	2025-10-17 22:42:24.512787+00	\N
136	6	22	15	2025-10-17 22:42:24.512787+00	\N
137	7	10	1	2025-10-17 22:42:24.51349+00	\N
138	7	11	2	2025-10-17 22:42:24.51349+00	\N
139	7	12	3	2025-10-17 22:42:24.51349+00	\N
140	7	13	4	2025-10-17 22:42:24.51349+00	\N
141	7	14	5	2025-10-17 22:42:24.51349+00	\N
142	7	15	6	2025-10-17 22:42:24.51349+00	\N
143	7	16	7	2025-10-17 22:42:24.51349+00	\N
144	7	17	8	2025-10-17 22:42:24.51349+00	\N
145	7	18	9	2025-10-17 22:42:24.51349+00	\N
146	7	19	10	2025-10-17 22:42:24.51349+00	\N
147	7	20	11	2025-10-17 22:42:24.51349+00	\N
\.


--
-- Data for Name: separaciones_regla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.separaciones_regla (id, regla_id, valor, separacion, created_at, updated_at) FROM stdin;
1	1	Todos los valores	3600	2025-10-29 17:32:01.026121+00	\N
2	4	artista_1	12	2025-10-29 19:50:31.100181+00	\N
3	5	todos	3600	2025-10-29 19:51:10.902362+00	\N
4	6	todos	20	2025-10-29 19:52:41.475404+00	\N
5	7	artista_4	1	2025-10-29 20:02:25.846421+00	\N
6	8	artista_7	12	2025-10-29 20:06:16.275428+00	\N
7	9	todos	3600	2025-10-29 20:15:10.131057+00	\N
8	10	todos	1	2025-10-29 20:16:49.997757+00	\N
\.


--
-- Name: canciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.canciones_id_seq', 633, true);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_seq', 10, true);


--
-- Name: conjuntos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conjuntos_id_seq', 2, true);


--
-- Name: cortes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cortes_id_seq', 7, true);


--
-- Name: dias_modelo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dias_modelo_id_seq', 11, true);


--
-- Name: difusoras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.difusoras_id_seq', 5, true);


--
-- Name: eventos_reloj_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eventos_reloj_id_seq', 644, true);


--
-- Name: politica_categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.politica_categorias_id_seq', 6, true);


--
-- Name: politicas_programacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.politicas_programacion_id_seq', 5, true);


--
-- Name: programacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.programacion_id_seq', 4001, true);


--
-- Name: reglas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reglas_id_seq', 10, true);


--
-- Name: relojes_dia_modelo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relojes_dia_modelo_id_seq', 159, true);


--
-- Name: relojes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relojes_id_seq', 33, true);


--
-- Name: separaciones_regla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.separaciones_regla_id_seq', 8, true);


--
-- PostgreSQL database dump complete
--

\unrestrict ebvk9jcfAD4igjentuttIwrLYxOAVOBe0WSnsVKpVoJoWfUj6jugYdDIIB2eeWt

