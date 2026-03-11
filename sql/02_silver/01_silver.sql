-- Table: silver.cnae_secao

-- DROP TABLE IF EXISTS silver.cnae_secao;

CREATE TABLE IF NOT EXISTS silver.cnae_secao
(
    id integer NOT NULL DEFAULT nextval('silver.cnae_secao_id_seq'::regclass),
    codigo text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT cnae_secao_pkey PRIMARY KEY (id),
    CONSTRAINT cnae_secao_codigo_key UNIQUE (codigo)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.cnae_secao
    OWNER to postgres;

-- Table: silver.cnae_subclasse

-- DROP TABLE IF EXISTS silver.cnae_subclasse;

CREATE TABLE IF NOT EXISTS silver.cnae_subclasse
(
    id integer NOT NULL DEFAULT nextval('silver.cnae_subclasse_id_seq'::regclass),
    codigo text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT cnae_subclasse_pkey PRIMARY KEY (id),
    CONSTRAINT cnae_subclasse_codigo_key UNIQUE (codigo)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.cnae_subclasse
    OWNER to postgres;


-- Table: silver.indexador

-- DROP TABLE IF EXISTS silver.indexador;

CREATE TABLE IF NOT EXISTS silver.indexador
(
    id integer NOT NULL DEFAULT nextval('silver.indexador_id_seq'::regclass),
    nome character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT indexador_pkey PRIMARY KEY (id),
    CONSTRAINT indexador_nome_key UNIQUE (nome)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.indexador
    OWNER to postgres;

-- Table: silver.modalidade

-- DROP TABLE IF EXISTS silver.modalidade;

CREATE TABLE IF NOT EXISTS silver.modalidade
(
    id integer NOT NULL DEFAULT nextval('silver.modalidade_id_seq'::regclass),
    nome character varying(80) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT modalidade_pkey PRIMARY KEY (id),
    CONSTRAINT modalidade_nome_key UNIQUE (nome)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.modalidade
    OWNER to postgres;

-- Table: silver.ocupacao

-- DROP TABLE IF EXISTS silver.ocupacao;

CREATE TABLE IF NOT EXISTS silver.ocupacao
(
    id integer NOT NULL DEFAULT nextval('silver.ocupacao_id_seq'::regclass),
    nome character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT ocupacao_pkey PRIMARY KEY (id),
    CONSTRAINT ocupacao_nome_key UNIQUE (nome)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.ocupacao
    OWNER to postgres;

-- Table: silver.origem

-- DROP TABLE IF EXISTS silver.origem;

CREATE TABLE IF NOT EXISTS silver.origem
(
    id integer NOT NULL DEFAULT nextval('silver.origem_id_seq'::regclass),
    nome character varying(25) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT origem_pkey PRIMARY KEY (id),
    CONSTRAINT origem_nome_key UNIQUE (nome)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.origem
    OWNER to postgres;

-- Table: silver.porte

-- DROP TABLE IF EXISTS silver.porte;

CREATE TABLE IF NOT EXISTS silver.porte
(
    id integer NOT NULL DEFAULT nextval('silver.porte_id_seq'::regclass),
    tipo character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT porte_pkey PRIMARY KEY (id),
    CONSTRAINT porte_tipo_key UNIQUE (tipo)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.porte
    OWNER to postgres;