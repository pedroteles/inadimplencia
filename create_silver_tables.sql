
CREATE SCHEMA IF NOT EXISTS silver;

-- Tabelas de referência
CREATE TABLE IF NOT EXISTS silver.uf (
    id SERIAL PRIMARY KEY,
    sigla VARCHAR(2) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.tcb (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.sr (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.cliente (
    id SERIAL PRIMARY KEY,
    tipo TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.ocupacao (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.cnae_secao (
    id SERIAL PRIMARY KEY,
    codigo TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.cnae_subclasse (
    id SERIAL PRIMARY KEY,
    codigo TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.porte (
    id SERIAL PRIMARY KEY,
    tipo TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.modalidade (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.origem (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.indexador (
    id SERIAL PRIMARY KEY,
    nome TEXT UNIQUE NOT NULL
);

-- Tabela de dados normalizados
CREATE TABLE IF NOT EXISTS silver.data_normalized (
    id SERIAL PRIMARY KEY,
    data_base DATE NOT NULL,
    uf_id INT REFERENCES silver.uf(id),
    tcb_id INT REFERENCES silver.tcb(id),
    sr_id INT REFERENCES silver.sr(id),
    cliente_id INT REFERENCES silver.cliente(id),
    ocupacao_id INT REFERENCES silver.ocupacao(id),
    cnae_secao_id INT REFERENCES silver.cnae_secao(id),
    cnae_subclasse_id INT REFERENCES silver.cnae_subclasse(id),
    porte_id INT REFERENCES silver.porte(id),
    modalidade_id INT REFERENCES silver.modalidade(id),
    origem_id INT REFERENCES silver.origem(id),
    indexador_id INT REFERENCES silver.indexador(id),
    numero_de_operacoes INT,
    a_vencer_ate_90_dias NUMERIC,
    a_vencer_de_91_ate_360_dias NUMERIC,
    a_vencer_de_361_ate_1080_dias NUMERIC,
    a_vencer_de_1081_ate_1800_dias NUMERIC,
    a_vencer_de_1801_ate_5400_dias NUMERIC,
    a_vencer_acima_de_5400_dias NUMERIC,
    vencido_acima_de_15_dias NUMERIC,
    carteira_ativa NUMERIC,
    carteira_inadimplida_arrastada NUMERIC,
    ativo_problematico TEXT
);
