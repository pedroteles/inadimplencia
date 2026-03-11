-- Table: silver.scr_data_normalized

-- DROP TABLE IF EXISTS silver.scr_data_normalized;

CREATE TABLE IF NOT EXISTS silver.scr_data_normalized
(
    id integer NOT NULL DEFAULT nextval('silver.scr_data_normalized_id_seq'::regclass),
    data_base date NOT NULL,
    uf character(2) COLLATE pg_catalog."default",
    tcb character varying(12) COLLATE pg_catalog."default",
    sr character(2) COLLATE pg_catalog."default",
    cliente character(2) COLLATE pg_catalog."default",
    ocupacao_id integer,
    cnae_secao_id integer,
    cnae_subclasse_id integer,
    porte_id integer,
    modalidade_id integer,
    origem_id integer,
    indexador_id integer,
    numero_de_operacoes text COLLATE pg_catalog."default",
    numero_de_operacoes_min integer,
    numero_de_operacoes_max integer,
    a_vencer_ate_90_dias numeric,
    a_vencer_de_91_ate_360_dias numeric,
    a_vencer_de_361_ate_1080_dias numeric,
    a_vencer_de_1081_ate_1800_dias numeric,
    a_vencer_de_1801_ate_5400_dias numeric,
    a_vencer_acima_de_5400_dias numeric,
    vencido_acima_de_15_dias numeric,
    carteira_ativa numeric,
    carteira_inadimplida_arrastada numeric,
    ativo_problematico numeric,
    CONSTRAINT scr_data_normalized_pkey PRIMARY KEY (id, data_base),
    CONSTRAINT scr_data_normalized_cnae_secao_id_fkey FOREIGN KEY (cnae_secao_id)
        REFERENCES silver.cnae_secao (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT scr_data_normalized_modalidade_id_fkey FOREIGN KEY (modalidade_id)
        REFERENCES silver.modalidade (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT scr_data_normalized_ocupacao_id_fkey FOREIGN KEY (ocupacao_id)
        REFERENCES silver.ocupacao (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT scr_data_normalized_porte_id_fkey FOREIGN KEY (porte_id)
        REFERENCES silver.porte (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) PARTITION BY RANGE (data_base);

ALTER TABLE IF EXISTS silver.scr_data_normalized
    OWNER to postgres;
-- Index: scr_data_normalized_uf_index

-- DROP INDEX IF EXISTS silver.scr_data_normalized_uf_index;

CREATE INDEX IF NOT EXISTS scr_data_normalized_uf_index
    ON silver.scr_data_normalized USING btree
    (uf COLLATE pg_catalog."default" ASC NULLS LAST, cliente COLLATE pg_catalog."default" ASC NULLS FIRST)
    INCLUDE(ocupacao_id, porte_id, a_vencer_ate_90_dias, a_vencer_de_91_ate_360_dias, a_vencer_de_361_ate_1080_dias, a_vencer_de_1081_ate_1800_dias, a_vencer_de_1801_ate_5400_dias, a_vencer_acima_de_5400_dias, vencido_acima_de_15_dias, carteira_ativa, carteira_inadimplida_arrastada, ativo_problematico)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

-- Partitions SQL

CREATE TABLE silver.scr_data_normalized_2012_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-01-01') TO ('2012-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-02-01') TO ('2012-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-03-01') TO ('2012-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-04-01') TO ('2012-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-05-01') TO ('2012-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-06-01') TO ('2012-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-07-01') TO ('2012-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-08-01') TO ('2012-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-09-01') TO ('2012-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-10-01') TO ('2012-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-11-01') TO ('2012-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2012_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2012-12-01') TO ('2013-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2012_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-01-01') TO ('2013-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-02-01') TO ('2013-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-03-01') TO ('2013-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-04-01') TO ('2013-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-05-01') TO ('2013-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-06-01') TO ('2013-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-07-01') TO ('2013-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-08-01') TO ('2013-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-09-01') TO ('2013-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-10-01') TO ('2013-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-11-01') TO ('2013-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2013_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2013-12-01') TO ('2014-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2013_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-01-01') TO ('2014-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-02-01') TO ('2014-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-03-01') TO ('2014-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-04-01') TO ('2014-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-05-01') TO ('2014-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-06-01') TO ('2014-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-07-01') TO ('2014-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-08-01') TO ('2014-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-09-01') TO ('2014-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-10-01') TO ('2014-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-11-01') TO ('2014-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2014_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2014-12-01') TO ('2015-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2014_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-01-01') TO ('2015-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-02-01') TO ('2015-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-03-01') TO ('2015-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-04-01') TO ('2015-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-05-01') TO ('2015-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-06-01') TO ('2015-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-07-01') TO ('2015-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-08-01') TO ('2015-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-09-01') TO ('2015-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-10-01') TO ('2015-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-11-01') TO ('2015-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2015_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2015-12-01') TO ('2016-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2015_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-01-01') TO ('2016-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-02-01') TO ('2016-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-03-01') TO ('2016-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-04-01') TO ('2016-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-05-01') TO ('2016-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-06-01') TO ('2016-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-07-01') TO ('2016-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-08-01') TO ('2016-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-09-01') TO ('2016-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-10-01') TO ('2016-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-11-01') TO ('2016-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2016_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2016-12-01') TO ('2017-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2016_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-01-01') TO ('2017-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-02-01') TO ('2017-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-03-01') TO ('2017-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-04-01') TO ('2017-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-05-01') TO ('2017-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-06-01') TO ('2017-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-07-01') TO ('2017-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-08-01') TO ('2017-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-09-01') TO ('2017-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-10-01') TO ('2017-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-11-01') TO ('2017-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2017_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2017-12-01') TO ('2018-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2017_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-01-01') TO ('2018-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-02-01') TO ('2018-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-03-01') TO ('2018-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-04-01') TO ('2018-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-05-01') TO ('2018-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-06-01') TO ('2018-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-07-01') TO ('2018-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-08-01') TO ('2018-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-09-01') TO ('2018-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-10-01') TO ('2018-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-11-01') TO ('2018-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2018_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2018-12-01') TO ('2019-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2018_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-01-01') TO ('2019-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-02-01') TO ('2019-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-03-01') TO ('2019-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-04-01') TO ('2019-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-05-01') TO ('2019-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-06-01') TO ('2019-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-07-01') TO ('2019-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-08-01') TO ('2019-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-09-01') TO ('2019-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-10-01') TO ('2019-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-11-01') TO ('2019-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2019_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2019-12-01') TO ('2020-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2019_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-01-01') TO ('2020-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-02-01') TO ('2020-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-03-01') TO ('2020-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-04-01') TO ('2020-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-05-01') TO ('2020-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-06-01') TO ('2020-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-07-01') TO ('2020-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-08-01') TO ('2020-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-09-01') TO ('2020-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-10-01') TO ('2020-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-11-01') TO ('2020-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2020_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2020-12-01') TO ('2021-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2020_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-01-01') TO ('2021-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-02-01') TO ('2021-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-03-01') TO ('2021-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-04-01') TO ('2021-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-05-01') TO ('2021-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-06-01') TO ('2021-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-07-01') TO ('2021-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-08-01') TO ('2021-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-09-01') TO ('2021-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-10-01') TO ('2021-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-11-01') TO ('2021-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2021_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2021-12-01') TO ('2022-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2021_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-01-01') TO ('2022-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-02-01') TO ('2022-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-03-01') TO ('2022-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-04-01') TO ('2022-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-05-01') TO ('2022-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-06-01') TO ('2022-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-07-01') TO ('2022-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-08-01') TO ('2022-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-09-01') TO ('2022-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-10-01') TO ('2022-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-11-01') TO ('2022-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2022_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2022-12-01') TO ('2023-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2022_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-03-01') TO ('2023-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-04-01') TO ('2023-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-05-01') TO ('2023-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-06-01') TO ('2023-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-07-01') TO ('2023-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-08-01') TO ('2023-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-09-01') TO ('2023-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-10-01') TO ('2023-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-11-01') TO ('2023-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2023_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2023-12-01') TO ('2024-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2023_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-05-01') TO ('2024-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-07-01') TO ('2024-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-08-01') TO ('2024-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-09-01') TO ('2024-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-10-01') TO ('2024-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_11 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-11-01') TO ('2024-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2024_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2024-12-01') TO ('2025-01-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2024_12
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_01 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_01
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_02 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_02
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_03 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-03-01') TO ('2025-04-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_03
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_04 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-04-01') TO ('2025-05-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_04
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_05 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-05-01') TO ('2025-06-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_05
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_06 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-06-01') TO ('2025-07-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_06
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_07 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-07-01') TO ('2025-08-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_07
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_08 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-08-01') TO ('2025-09-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_08
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_09 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-09-01') TO ('2025-10-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_09
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_10 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-10-01') TO ('2025-11-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_10
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_11 PARTITION OF silver.scr_data_normalized 
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01')
TABLESPACE pg_default;

ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_11
    OWNER to postgres;
CREATE TABLE silver.scr_data_normalized_2025_12 PARTITION OF silver.scr_data_normalized
    FOR VALUES FROM ('2025-12-01') TO ('2026-01-01')
TABLESPACE pg_default;
ALTER TABLE IF EXISTS silver.scr_data_normalized_2025_12
    OWNER to postgres;
    