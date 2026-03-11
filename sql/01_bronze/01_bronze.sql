-- Table: stg.scr_raw_data

-- DROP TABLE IF EXISTS stg.scr_raw_data;

CREATE TABLE IF NOT EXISTS stg.scr_raw_data
(
    data_base text COLLATE pg_catalog."default",
    uf text COLLATE pg_catalog."default",
    tcb text COLLATE pg_catalog."default",
    sr text COLLATE pg_catalog."default",
    cliente text COLLATE pg_catalog."default",
    ocupacao text COLLATE pg_catalog."default",
    cnae_secao text COLLATE pg_catalog."default",
    cnae_subclasse text COLLATE pg_catalog."default",
    porte text COLLATE pg_catalog."default",
    modalidade text COLLATE pg_catalog."default",
    origem text COLLATE pg_catalog."default",
    indexador text COLLATE pg_catalog."default",
    numero_de_operacoes text COLLATE pg_catalog."default",
    a_vencer_ate_90_dias text COLLATE pg_catalog."default",
    a_vencer_de_91_ate_360_dias text COLLATE pg_catalog."default",
    a_vencer_de_361_ate_1080_dias text COLLATE pg_catalog."default",
    a_vencer_de_1081_ate_1800_dias text COLLATE pg_catalog."default",
    a_vencer_de_1801_ate_5400_dias text COLLATE pg_catalog."default",
    a_vencer_acima_de_5400_dias text COLLATE pg_catalog."default",
    vencido_acima_de_15_dias text COLLATE pg_catalog."default",
    carteira_ativa text COLLATE pg_catalog."default",
    carteira_inadimplida_arrastada text COLLATE pg_catalog."default",
    ativo_problematico text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS stg.scr_raw_data
    OWNER to postgres;

-- Table: stg.extracao_log

-- DROP TABLE IF EXISTS stg.extracao_log;

CREATE TABLE IF NOT EXISTS stg.extracao_log
(
    ano integer NOT NULL,
    mes integer NOT NULL,
    status text COLLATE pg_catalog."default",
    data_execucao timestamp without time zone,
    CONSTRAINT extracao_log_pkey PRIMARY KEY (ano, mes)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS stg.extracao_log
    OWNER to postgres;