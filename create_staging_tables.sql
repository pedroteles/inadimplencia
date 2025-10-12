
CREATE SCHEMA IF NOT EXISTS stg;

-- Tabela de dados brutos
CREATE TABLE IF NOT EXISTS stg.scr_raw_data (
    id SERIAL PRIMARY KEY,
    data_base TEXT,
    uf TEXT,
    tcb TEXT,
    sr TEXT,
    cliente TEXT,
    ocupacao TEXT,
    cnae_secao TEXT,
    cnae_subclasse TEXT,
    porte TEXT,
    modalidade TEXT,
    origem TEXT,
    indexador TEXT,
    numero_de_operacoes TEXT,
    a_vencer_ate_90_dias TEXT,
    a_vencer_de_91_ate_360_dias TEXT,
    a_vencer_de_361_ate_1080_dias TEXT,
    a_vencer_de_1081_ate_1800_dias TEXT,
    a_vencer_de_1801_ate_5400_dias TEXT,
    a_vencer_acima_de_5400_dias TEXT,
    vencido_acima_de_15_dias TEXT,
    carteira_ativa TEXT,
    carteira_inadimplida_arrastada TEXT,
    ativo_problematico TEXT
);

-- Tabela de log de extração
CREATE TABLE IF NOT EXISTS stg.extracao_log (
    ano INT,
    mes INT,
    status TEXT,
    data_execucao TIMESTAMP,
    PRIMARY KEY (ano, mes)
);
