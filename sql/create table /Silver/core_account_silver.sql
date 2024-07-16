
CREATE TABLE will_db_silver.dbo.core_account_silver (
    id_transaction VARCHAR(255)      PRIMARY KEY,
    dt_transaction DATE              null,
    dt_month DATE                    null,
    surrogate_key INT                null,
    cd_seqlan INT                    null,
    ds_transaction_type VARCHAR(255) null,
    vl_transaction float             null
);