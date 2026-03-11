-- PROCEDURE: gold.carregar_dados_particionados()

-- DROP PROCEDURE IF EXISTS gold.carregar_dados_particionados();

CREATE OR REPLACE PROCEDURE gold.carregar_dados_particionados(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    r RECORD;
BEGIN
    -- Loop pelas datas únicas (assumindo partição por data)
    FOR r IN (SELECT DISTINCT data_base FROM silver.scr_data_normalized ORDER BY 1) LOOP
        
        RAISE NOTICE 'Processando partição: %', r.data_base;
        
        INSERT INTO gold.scr_agg_data
(
    data_base,
    uf,
    tcb,
    cliente,
    porte,
    modalidade,
    destinacao_esp,
    carteira_ativa,
    vencido_acima_de_15_dias,
    a_vencer_ate_90_dias,
    a_vencer_de_91_ate_360_dias,
    carteira_inadimplida_arrastada,
	ativo_problematico
)
SELECT 
    s.data_base,
    s.uf,
    s.tcb,
    s.cliente,
    porte.tipo AS porte,
    mo.nome AS modalidade,
    CASE 
        WHEN s.origem_id = 3 THEN 'Sim'
        WHEN s.origem_id = 4 THEN 'Não'
        ELSE 'n/a'
    END AS destinacao_esp,
	sum(carteira_ativa) as carteira_ativa,
    sum(vencido_acima_de_15_dias) as vencido_acima_de_15_dias,
    sum(a_vencer_ate_90_dias) as a_vencer_ate_90_dias,
    sum(a_vencer_de_91_ate_360_dias) as a_vencer_de_91_ate_360_dias,
    sum(carteira_inadimplida_arrastada) as carteira_inadimplida_arrastada,
	sum(s.ativo_problematico) as ativo_problematico
FROM 
    silver.scr_data_normalized s
	INNER JOIN silver.porte porte ON porte.id = s.porte_id
    INNER JOIN silver.modalidade mo ON mo.id = s.modalidade_id
WHERE 
	s.data_base = r.data_base
GROUP BY 
    s.data_base,
    s.uf,
    s.tcb,
    s.cliente,
    porte.tipo,
    mo.nome,
    s.origem_id 
ORDER BY 
	s.uf;
        
        COMMIT; -- Libera o WAL e os locks da partição processada
    END LOOP;
END;
$BODY$;
ALTER PROCEDURE gold.carregar_dados_particionados()
    OWNER TO postgres;

CALL gold.carregar_dados_particionados();

