-------------------------------------------------------Core Pix-------------------------------------------------------------------------------------

WITH temp_core_pix_silver AS (
    SELECT DISTINCT 
        id_transaction,
        dt_transaction, 
        dt_month, 
        cd_seqlan, 
        ds_transaction_type, 
        vl_transaction
    FROM will_db_bronze.dbo.core_pix_bronze
),
temp_core_pix_inc AS (
    SELECT DISTINCT 
        id_transaction,
        COUNT(*) AS qtd_duplicate
    FROM temp_core_pix_silver
    GROUP BY id_transaction
    HAVING COUNT(*) > 1
)

SELECT DISTINCT
    id_transaction,
    dt_transaction, 
    dt_month, 
    cd_seqlan, 
    ds_transaction_type, 
    vl_transaction
FROM will_db_bronze.dbo.core_pix_bronze 
WHERE id_transaction NOT IN (SELECT id_transaction FROM temp_core_pix_inc);








------------------------ Core Acount ----------------------------------------------



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
),
temp_core_account_inc AS (
    SELECT DISTINCT 
        id_transaction,
        COUNT(*) AS qtd_duplicate
    FROM temp_core_account_silver
    GROUP BY id_transaction
    HAVING COUNT(*) > 1
)

	id_transaction,
	dt_transaction, 
	dt_month, 
	surrogate_key, 
	cd_seqlan, 
	ds_transaction_type,
    vl_transaction
FROM will_db_bronze.dbo.core_account_bronze
WHERE id_transaction NOT IN (SELECT id_transaction FROM temp_core_account_inc);




-------------------------------------  customer ------------------------------------------------------

SELECT DISTINCT 
surrogate_key, 
entry_date, 
full_name, 
birth_date, 
uf_name, 
uf, 
street_name
FROM will_db_bronze.dbo.customer_bronze;

































