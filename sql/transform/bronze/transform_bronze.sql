

---------------------------  Core Pix --------------------

SELECT 
    id_transaction,
    CAST(dt_transaction AS DATE) AS dt_transaction, 
    CONVERT(DATE, CAST(SUBSTRING(dt_month, 1, 4) + '-' + SUBSTRING(dt_month, 5, 2) + '-01' AS DATE)) AS dt_month, 
    CAST(CAST(cd_seqlan AS FLOAT) AS INTEGER) AS cd_seqlan, 
    ds_transaction_type, 
    ROUND(CAST(vl_transaction AS FLOAT),2) AS vl_transaction
FROM will_db_raw.dbo.core_pix_raw;



---------------------------  core_account --------------------


SELECT 
	id_transaction,
	CAST(dt_transaction as date) as dt_transaction, 
	CONVERT(DATE,CAST(SUBSTRING(dt_month, 1, 4) + '-' + SUBSTRING(dt_month, 5, 2) + '-01' AS DATE)) as dt_month, 
	CAST(surrogate_key as INTEGER) as surrogate_key, 
	CAST(CAST(cd_seqlan AS FLOAT) AS INTEGER) as cd_seqlan, 
	ds_transaction_type,
ROUND(CAST(vl_transaction AS FLOAT), 2) as vl_transaction
FROM will_db_raw.dbo.core_account_raw;




--------------------------- custome --------------------



INSERT INTO will_db_bronze.dbo.customer_bronze (surrogate_key, entry_date,  full_name, birth_date, uf_name, uf, street_name)
SELECT 
    CAST(surrogate_key as INTEGER) as surrogate_key, 
	CAST(entry_date as date) as entry_date, 
	full_name, 
	CAST(birth_date as date) as birth_date,
	uf_name, 
	uf, 
	street_name
FROM will_db_raw.dbo.customer_raw;












