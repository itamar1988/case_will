CREATE TABLE will_db_gold.dbo.pix_detalhado (
    id_transaction VARCHAR(255) NOT NULL,
    dt_transacao DATE,
    mes_transacao DATE,
    vl_transaction FLOAT,
    surrogate_key INT,
    nm_cliente VARCHAR(255),
    estado VARCHAR(255),
    pix_valido_regulador VARCHAR(10),
    PRIMARY KEY (id_transaction)
);
