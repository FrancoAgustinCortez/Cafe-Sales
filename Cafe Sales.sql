DROP VIEW IF EXISTS vw_cafe_sales_clean;

CREATE VIEW vw_cafe_sales_clean AS
SELECT 
    -- 1. Item -> nome_produto
    INITCAP(TRIM("Item"::text)) AS nome_produto,

    -- 2. Quantity -> quantidade
    "Quantity"::numeric AS quantidade,

    -- 3. Price Per Unit -> preco_unitario
    "Price Per Unit"::numeric AS preco_unitario,

    -- 4. Total Gasto Corrigido (Cálculo)
    ("Quantity"::numeric * "Price Per Unit"::numeric) AS total_gasto_corrigido,

    -- 5. Payment Method -> metodo_pagamento
    INITCAP(TRIM("Payment Method"::text)) AS metodo_pagamento,

    -- 6. Location -> localizacao_loja
    INITCAP(TRIM("Location"::text)) AS localizacao_loja,

    -- 7. Transaction Date -> data_transacao
    "Transaction Date"::date AS data_transacao

FROM stg_cafe_sales

-- REMOVE AS LINHAS QUE TÊM ERROS, NULOS OU 'UNKNOWN'
WHERE 
    -- Filtra Location
    "Location" IS NOT NULL 
    AND TRIM("Location"::text) != '' 
    AND LOWER(TRIM("Location"::text)) NOT IN ('unknown', 'error', 'null', 'undefined')
    
    -- Filtra Item/Produto
    AND "Item" IS NOT NULL 
    AND TRIM("Item"::text) != '' 
    AND LOWER(TRIM("Item"::text)) NOT IN ('unknown', 'error', 'null', 'undefined')
    
    -- Filtra Método de Pagamento
    AND "Payment Method" IS NOT NULL 
    AND TRIM("Payment Method"::text) != '' 
    AND LOWER(TRIM("Payment Method"::text)) NOT IN ('unknown', 'error', 'null', 'undefined')
    
    -- Filtra valores numéricos e datas inválidas
    AND "Quantity" IS NOT NULL 
    AND LOWER(TRIM("Quantity"::text)) NOT IN ('unknown', 'error', '', 'null')
    AND "Price Per Unit" IS NOT NULL 
    AND LOWER(TRIM("Price Per Unit"::text)) NOT IN ('unknown', 'error', '', 'null')
    AND "Transaction Date" IS NOT NULL 
    AND LOWER(TRIM("Transaction Date"::text)) NOT IN ('unknown', 'error', '', 'null');