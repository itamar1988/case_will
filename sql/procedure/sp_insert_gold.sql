ALTER PROCEDURE InsertDataGold
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedRecords INT;

    -- Inserir dados em relatorio_inconcistencias_pix
    INSERT INTO will_db_gold.dbo.relatorio_inconcistencias_pix (id_transaction, dt_transacao, vl_transacao, surrogate_key, nm_cliente, estado)
    SELECT 
        a.id_transaction,
        a.dt_transaction AS dt_transacao,
        a.vl_transaction AS vl_transacao,
        a.surrogate_key,
        c.full_name AS nm_cliente,
        c.uf_name AS estado
    FROM will_db_silver.dbo.core_account_silver a
    LEFT JOIN will_db_silver.dbo.core_pix_silver b ON a.id_transaction = b.id_transaction
    LEFT JOIN will_db_silver.dbo.customer_silver c ON a.surrogate_key = c.surrogate_key
    WHERE b.id_transaction IS NULL;

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela relatorio_inconcistencias_pix: ' + CAST(@InsertedRecords AS VARCHAR(10));

    -- Inserir dados em pix_agregado_ano
    INSERT INTO will_db_gold.dbo.pix_agregado_ano (nm_cliente, surrogate_key, qtd_transacao, ano_transacao, vl_total_transacao)
    SELECT DISTINCT 
        c.full_name AS nm_cliente,
        a.surrogate_key,
        COUNT(DISTINCT a.id_transaction) AS qtd_transacao,
        YEAR(a.dt_transaction) AS ano_transacao,
        SUM(a.vl_transaction) AS vl_total_transacao
    FROM will_db_silver.dbo.core_account_silver a
    LEFT JOIN will_db_silver.dbo.core_pix_silver b ON a.id_transaction = b.id_transaction
    LEFT JOIN will_db_silver.dbo.customer_silver c ON a.surrogate_key = c.surrogate_key
    WHERE b.id_transaction IS NULL
    GROUP BY 
        c.full_name,
        YEAR(a.dt_transaction),
        a.surrogate_key;

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela pix_agregado_ano: ' + CAST(@InsertedRecords AS VARCHAR(10));

    -- Inserir dados em pix_detalhado
    INSERT INTO will_db_gold.dbo.pix_detalhado (
        id_transaction,
        dt_transacao,
        mes_transacao,
        vl_transaction,
        surrogate_key,
        nm_cliente,
        estado,
        pix_valido_regulador
    )
    SELECT 
        a.id_transaction,
        a.dt_transaction AS dt_transacao,
        a.dt_month AS mes_transacao,
        a.vl_transaction, 
        a.surrogate_key,
        c.full_name AS nm_cliente,
        c.uf_name AS estado,
        CASE 
            WHEN b.id_transaction IS NULL THEN 'Nao'
            ELSE 'Sim'
        END AS pix_valido_regulador
    FROM will_db_silver.dbo.core_account_silver a
    LEFT JOIN will_db_silver.dbo.core_pix_silver b ON a.id_transaction = b.id_transaction
    LEFT JOIN will_db_silver.dbo.customer_silver c ON a.surrogate_key = c.surrogate_key;

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela pix_detalhado: ' + CAST(@InsertedRecords AS VARCHAR(10));

END;



