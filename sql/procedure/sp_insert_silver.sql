ALTER PROCEDURE InsertDataSilver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InconsistenciesCorePix INT;
    DECLARE @InconsistenciesCoreAccount INT;
    DECLARE @InconsistenciesCustomer INT;
    DECLARE @InsertedRecords INT;

    -- Core Pix Bronze to Silver
    WITH temp_core_pix_silver AS (
        SELECT DISTINCT 
            id_transaction,
            dt_transaction, 
            dt_month, 
            cd_seqlan, 
            ds_transaction_type, 
            vl_transaction
        FROM will_db_bronze.dbo.core_pix_bronze
    )
    SELECT 
        id_transaction,
        COUNT(*) AS qtd_duplicate
    INTO #temp_core_pix_inc
    FROM temp_core_pix_silver
    GROUP BY id_transaction
    HAVING COUNT(*) > 1;

    SELECT @InconsistenciesCorePix = sum(qtd_duplicate)
    FROM #temp_core_pix_inc;

    INSERT INTO will_db_silver.dbo.core_pix_silver 
        (id_transaction, dt_transaction, dt_month, cd_seqlan, ds_transaction_type, vl_transaction)
    SELECT DISTINCT
        id_transaction,
        dt_transaction, 
        dt_month, 
        cd_seqlan, 
        ds_transaction_type, 
        vl_transaction
    FROM will_db_bronze.dbo.core_pix_bronze 
    WHERE id_transaction NOT IN (SELECT id_transaction FROM #temp_core_pix_inc);

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela core_pix_silver: ' + CAST(@InsertedRecords AS VARCHAR(10));
    PRINT 'Numero de registros inconsistentes na tabela core_pix_bronze: ' + CAST(@InconsistenciesCorePix AS VARCHAR(10));

    -- Core Account Bronze to Silver
    WITH temp_core_account_silver AS (
        SELECT DISTINCT  
            id_transaction,
            dt_transaction, 
            dt_month, 
            surrogate_key, 
            cd_seqlan, 
            ds_transaction_type,
            vl_transaction
        FROM will_db_bronze.dbo.core_account_bronze
    )
    SELECT 
        id_transaction,
        COUNT(*) AS qtd_duplicate
    INTO #temp_core_account_inc
    FROM temp_core_account_silver
    GROUP BY id_transaction
    HAVING COUNT(*) > 1;

    SELECT @InconsistenciesCoreAccount = sum(qtd_duplicate)
    FROM #temp_core_account_inc;

    INSERT INTO will_db_silver.dbo.core_account_silver  
        (id_transaction, dt_transaction, dt_month, surrogate_key, cd_seqlan, ds_transaction_type, vl_transaction)
    SELECT DISTINCT
        id_transaction,
        dt_transaction, 
        dt_month, 
        surrogate_key, 
        cd_seqlan, 
        ds_transaction_type,
        vl_transaction
    FROM will_db_bronze.dbo.core_account_bronze
    WHERE id_transaction NOT IN (SELECT id_transaction FROM #temp_core_account_inc);

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela core_account_silver: ' + CAST(@InsertedRecords AS VARCHAR(10));
    PRINT 'Numero de registros inconsistentes na tabela core_account_bronze: ' + CAST(@InconsistenciesCoreAccount AS VARCHAR(10));

    -- Customer Bronze to Silver
    WITH temp_customer_silver AS (
        SELECT DISTINCT 
            surrogate_key, 
            entry_date, 
            full_name, 
            birth_date, 
            uf_name, 
            uf, 
            street_name
        FROM will_db_bronze.dbo.customer_bronze
    )
    SELECT 
        surrogate_key,
        COUNT(*) AS qtd_duplicate
    INTO #temp_customer_inc
    FROM temp_customer_silver
    GROUP BY surrogate_key
    HAVING COUNT(*) > 1;

    SELECT @InconsistenciesCustomer = sum(qtd_duplicate)
    FROM #temp_customer_inc;

    INSERT INTO will_db_silver.dbo.customer_silver 
        (surrogate_key, entry_date, full_name, birth_date, uf_name, uf, street_name)
    SELECT DISTINCT 
        surrogate_key, 
        entry_date, 
        full_name, 
        birth_date, 
        uf_name, 
        uf, 
        street_name
    FROM will_db_bronze.dbo.customer_bronze
    WHERE surrogate_key NOT IN (SELECT surrogate_key FROM #temp_customer_inc);

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Numero de registros inseridos na tabela customer_silver: ' + CAST(@InsertedRecords AS VARCHAR(10));
    PRINT 'Numero de registros inconsistentes na tabela customer_bronze: ' + CAST(@InconsistenciesCustomer AS VARCHAR(10));

    -- Drop temporary tables
    DROP TABLE #temp_core_pix_inc;
    DROP TABLE #temp_core_account_inc;
    DROP TABLE #temp_customer_inc;
END;




































