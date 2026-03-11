-- ============================================================================
-- INSERT DATA INTO SILVER SCHEMA DIMENSION TABLES AND FACT TABLE
-- ============================================================================

-- ============================================================================
-- 1. LOAD DIMENSION TABLES (SCD Type 1)
-- ============================================================================

-- Table: silver.cnae_secao
-- Extracts unique CNAE section codes from stg.scr_raw_data
INSERT INTO silver.cnae_secao (codigo)
SELECT DISTINCT cnae_secao AS codigo
FROM stg.scr_raw_data
WHERE cnae_secao IS NOT NULL
  AND cnae_secao != ''
ON CONFLICT (codigo) DO NOTHING;


-- Table: silver.cnae_subclasse
-- Extracts unique CNAE subclass codes from stg.scr_raw_data
INSERT INTO silver.cnae_subclasse (codigo)
SELECT DISTINCT cnae_subclasse AS codigo
FROM stg.scr_raw_data
WHERE cnae_subclasse IS NOT NULL
  AND cnae_subclasse != ''
ON CONFLICT (codigo) DO NOTHING;


-- Table: silver.ocupacao
-- Extracts unique occupation names from stg.scr_raw_data
INSERT INTO silver.ocupacao (nome)
SELECT DISTINCT ocupacao AS nome
FROM stg.scr_raw_data
WHERE ocupacao IS NOT NULL
  AND ocupacao != ''
ON CONFLICT (nome) DO NOTHING;


-- Table: silver.indexador
-- Extracts unique indexer names from stg.scr_raw_data
INSERT INTO silver.indexador (nome)
SELECT DISTINCT indexador AS nome
FROM stg.scr_raw_data
WHERE indexador IS NOT NULL
  AND indexador != ''
ON CONFLICT (nome) DO NOTHING;


-- Table: silver.modalidade
-- Extracts unique modality names from stg.scr_raw_data
INSERT INTO silver.modalidade (nome)
SELECT DISTINCT modalidade AS nome
FROM stg.scr_raw_data
WHERE modalidade IS NOT NULL
  AND modalidade != ''
ON CONFLICT (nome) DO NOTHING;


-- Table: silver.origem
-- Extracts unique origin names from stg.scr_raw_data
INSERT INTO silver.origem (nome)
SELECT DISTINCT origem AS nome
FROM stg.scr_raw_data
WHERE origem IS NOT NULL
  AND origem != ''
ON CONFLICT (nome) DO NOTHING;


-- Table: silver.porte
-- Extracts unique company size (porte) from stg.scr_raw_data
INSERT INTO silver.porte (tipo)
SELECT DISTINCT porte AS tipo
FROM stg.scr_raw_data
WHERE porte IS NOT NULL
  AND porte != ''
ON CONFLICT (tipo) DO NOTHING;


-- ============================================================================
-- 2. LOAD FACT TABLE - silver.scr_data_normalized
-- ============================================================================

INSERT INTO silver.scr_data_normalized (
    data_base,
    uf,
    tcb,
    sr,
    cliente,
    ocupacao_id,
    cnae_secao_id,
    cnae_subclasse_id,
    porte_id,
    modalidade_id,
    origem_id,
    indexador_id,
    numero_de_operacoes,
    numero_de_operacoes_min,
    numero_de_operacoes_max,
    a_vencer_ate_90_dias,
    a_vencer_de_91_ate_360_dias,
    a_vencer_de_361_ate_1080_dias,
    a_vencer_de_1081_ate_1800_dias,
    a_vencer_de_1801_ate_5400_dias,
    a_vencer_acima_de_5400_dias,
    vencido_acima_de_15_dias,
    carteira_ativa,
    carteira_inadimplida_arrastada,
    ativo_problematico
)
SELECT 
    TO_DATE(raw.data_base, 'YYYY-MM-DD') AS data_base,
    raw.uf::char(2) AS uf,
    raw.tcb::varchar(12) AS tcb,
    raw.sr::char(2) AS sr,
    raw.cliente::char(2) AS cliente,
    ocp.id AS ocupacao_id,
    cns.id AS cnae_secao_id,
    csub.id AS cnae_subclasse_id,
    p.id AS porte_id,
    m.id AS modalidade_id,
    o.id AS origem_id,
    idx.id AS indexador_id,
    raw.numero_de_operacoes,
    CASE 
        WHEN raw.numero_de_operacoes = '<= 15' THEN 1
		ELSE CAST(raw.numero_de_operacoes AS INTEGER)
    END AS numero_de_operacoes_min,
   CASE 
        WHEN raw.numero_de_operacoes = '<= 15' THEN 15
		ELSE CAST(raw.numero_de_operacoes AS INTEGER)
    END AS numero_de_operacoes_max,
    CAST(NULLIF(REPLACE(raw.a_vencer_ate_90_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_ate_90_dias,
    CAST(NULLIF(REPLACE(raw.a_vencer_de_91_ate_360_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_de_91_ate_360_dias,
    CAST(NULLIF(REPLACE(raw.a_vencer_de_361_ate_1080_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_de_361_ate_1080_dias,
    CAST(NULLIF(REPLACE(raw.a_vencer_de_1081_ate_1800_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_de_1081_ate_1800_dias,
    CAST(NULLIF(REPLACE(raw.a_vencer_de_1801_ate_5400_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_de_1801_ate_5400_dias,
    CAST(NULLIF(REPLACE(raw.a_vencer_acima_de_5400_dias, ',', '.'), '') AS NUMERIC) AS a_vencer_acima_de_5400_dias,
    CAST(NULLIF(REPLACE(raw.vencido_acima_de_15_dias, ',', '.'), '') AS NUMERIC) AS vencido_acima_de_15_dias,
    CAST(NULLIF(REPLACE(raw.carteira_ativa, ',', '.'), '') AS NUMERIC) AS carteira_ativa,
    CAST(NULLIF(REPLACE(raw.carteira_inadimplida_arrastada, ',', '.'), '') AS NUMERIC) AS carteira_inadimplida_arrastada,
    CAST(NULLIF(REPLACE(raw.ativo_problematico, ',', '.'), '') AS NUMERIC) AS ativo_problematico
FROM stg.scr_raw_data raw
LEFT JOIN silver.ocupacao ocp ON ocp.nome = raw.ocupacao
LEFT JOIN silver.cnae_secao cns ON cns.codigo = raw.cnae_secao
LEFT JOIN silver.cnae_subclasse csub ON csub.codigo = raw.cnae_subclasse
LEFT JOIN silver.porte p ON p.tipo = raw.porte
LEFT JOIN silver.modalidade m ON m.nome = raw.modalidade
LEFT JOIN silver.origem o ON o.nome = raw.origem
LEFT JOIN silver.indexador idx ON idx.nome = raw.indexador
WHERE raw.data_base IS NOT NULL;


-- ============================================================================
-- 3. DATA QUALITY CHECKS (Optional - Execute after inserts)
-- ============================================================================

-- Count records loaded
SELECT 'Fact Table Records' AS metric, COUNT(*) AS count FROM silver.scr_data_normalized
UNION ALL
SELECT 'CNAE Seção', COUNT(*) FROM silver.cnae_secao
UNION ALL
SELECT 'CNAE Subclasse', COUNT(*) FROM silver.cnae_subclasse
UNION ALL
SELECT 'Ocupação', COUNT(*) FROM silver.ocupacao
UNION ALL
SELECT 'Indexador', COUNT(*) FROM silver.indexador
UNION ALL
SELECT 'Modalidade', COUNT(*) FROM silver.modalidade
UNION ALL
SELECT 'Origem', COUNT(*) FROM silver.origem
UNION ALL
SELECT 'Porte', COUNT(*) FROM silver.porte;


-- Check for null foreign keys (potential data quality issues)
SELECT 
    'Null ocupacao_id' AS issue, COUNT(*) AS count 
FROM silver.scr_data_normalized 
WHERE ocupacao_id IS NULL
UNION ALL
SELECT 'Null cnae_secao_id', COUNT(*) FROM silver.scr_data_normalized WHERE cnae_secao_id IS NULL
UNION ALL
SELECT 'Null cnae_subclasse_id', COUNT(*) FROM silver.scr_data_normalized WHERE cnae_subclasse_id IS NULL
UNION ALL
SELECT 'Null porte_id', COUNT(*) FROM silver.scr_data_normalized WHERE porte_id IS NULL
UNION ALL
SELECT 'Null modalidade_id', COUNT(*) FROM silver.scr_data_normalized WHERE modalidade_id IS NULL
UNION ALL
SELECT 'Null origem_id', COUNT(*) FROM silver.scr_data_normalized WHERE origem_id IS NULL
UNION ALL
SELECT 'Null indexador_id', COUNT(*) FROM silver.scr_data_normalized WHERE indexador_id IS NULL;
