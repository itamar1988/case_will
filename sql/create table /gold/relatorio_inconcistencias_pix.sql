CREATE TABLE will_db_gold.dbo.relatorio_inconcistencias_pix (
    id_transaction VARCHAR(255) NOT NULL,
    dt_transacao DATE,
    vl_transacao FLOAT,
    surrogate_key INT,
    nm_cliente VARCHAR(255),
    estado VARCHAR(255),
    PRIMARY KEY (id_transaction)
);