-- Table: gold.scr_agg_data

-- DROP TABLE IF EXISTS gold.scr_agg_data;

CREATE TABLE IF NOT EXISTS gold.scr_agg_data
(
    data_base date NOT NULL,
    uf character(2) COLLATE pg_catalog."default",
    tcb character varying(30) COLLATE pg_catalog."default",
    cliente character(2) COLLATE pg_catalog."default",
    categoria character varying(70) COLLATE pg_catalog."default",
    porte character varying(40) COLLATE pg_catalog."default",
    modalidade character varying(80) COLLATE pg_catalog."default",
    destinacao_esp character(3) COLLATE pg_catalog."default",
    carteira_ativa numeric,
    vencido_acima_de_15_dias numeric,
    a_vencer_ate_90_dias numeric,
    a_vencer_de_91_ate_360_dias numeric,
    carteira_inadimplida_arrastada numeric,
    ativo_problematico numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS gold.scr_agg_data
    OWNER to postgres;
-- Index: idx_scr_agg_data_cluster

-- DROP INDEX IF EXISTS gold.idx_scr_agg_data_cluster;

CREATE INDEX IF NOT EXISTS idx_scr_agg_data_cluster
    ON gold.scr_agg_data USING btree
    (data_base ASC NULLS LAST, uf COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

ALTER TABLE IF EXISTS gold.scr_agg_data
    CLUSTER ON idx_scr_agg_data_cluster;