CREATE PROCEDURE InsertDataBronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedRecords INT;

    -- Insert into core_pix_bronze
    INSERT INTO will_db_bronze.dbo.core_pix_bronze  
        (id_transaction, dt_transaction, dt_month, cd_seqlan, ds_transaction_type, vl_transaction)
    SELECT 
        id_transaction,
        CAST(dt_transaction AS DATE) AS dt_transaction, 
        CONVERT(DATE, CAST(SUBSTRING(dt_month, 1, 4) + '-' + SUBSTRING(dt_month, 5, 2) + '-01' AS DATE)) AS dt_month, 
        CAST(CAST(cd_seqlan AS FLOAT) AS INTEGER) AS cd_seqlan, 
        ds_transaction_type, 
        ROUND(CAST(vl_transaction AS FLOAT), 2) AS vl_transaction
    FROM will_db_raw.dbo.core_pix_raw;

    -- Get linhas
    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Nummero de registros inseridos na tabela core_pix_bronze: ' + CAST(@InsertedRecords AS VARCHAR(10));

    -- Insert into core_account_bronze
    INSERT INTO will_db_bronze.dbo.core_account_bronze  
        (id_transaction, dt_transaction, dt_month, surrogate_key, cd_seqlan, ds_transaction_type, vl_transaction)
    SELECT 
        id_transaction,
        CAST(dt_transaction AS DATE) AS dt_transaction, 
        CONVERT(DATE, CAST(SUBSTRING(dt_month, 1, 4) + '-' + SUBSTRING(dt_month, 5, 2) + '-01' AS DATE)) AS dt_month, 
        CAST(surrogate_key AS INTEGER) AS surrogate_key, 
        CAST(CAST(cd_seqlan AS FLOAT) AS INTEGER) AS cd_seqlan, 
        ds_transaction_type,
        ROUND(CAST(vl_transaction AS FLOAT), 2) AS vl_transaction
    FROM will_db_raw.dbo.core_account_raw;

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Nummero de registros inseridos na tabela core_account_bronze: ' + CAST(@InsertedRecords AS VARCHAR(10));

    -- Insert into customer_bronze
    INSERT INTO will_db_bronze.dbo.customer_bronze 
        (surrogate_key, entry_date, full_name, birth_date, uf_name, uf, street_name)
    SELECT 
        CAST(surrogate_key AS INTEGER) AS surrogate_key, 
        CAST(entry_date AS DATE) AS entry_date, 
        full_name, 
        CAST(birth_date AS DATE) AS birth_date,
        uf_name, 
        uf, 
        street_name
    FROM will_db_raw.dbo.customer_raw;

    SET @InsertedRecords = @@ROWCOUNT;
    PRINT 'Nummero de registros inseridos na tabela customer_bronze: ' + CAST(@InsertedRecords AS VARCHAR(10));
END;













