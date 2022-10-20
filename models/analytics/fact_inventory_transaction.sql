WITH fact_inventory_transaction__source AS(
  SELECT *
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_item_transactions`
)

, fact_inventory_transaction__rename_column AS (
  SELECT
    stock_item_transaction_id AS inventory_transaction_id
    , stock_item_id AS product_id
    , transaction_type_id
    , customer_id
    , invoice_id
    , supplier_id
    , purchase_order_id
    , transaction_occurred_when
    , quantity
    , last_edited_by 
  FROM fact_inventory_transaction__source
)

, fact_inventory_transaction__cast_type AS (
  SELECT
    CAST(inventory_transaction_id AS INTEGER) AS inventory_transaction_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(transaction_type_id AS INTEGER) AS transaction_type_id
    , CAST(customer_id AS INTEGER) AS customer_id
    , CAST(invoice_id AS INTEGER) AS invoice_id
    , CAST(supplier_id AS INTEGER) AS supplier_id
    , CAST(purchase_order_id AS INTEGER) AS purchase_order_id
    , CAST(transaction_occurred_when AS TIMESTAMP) AS transaction_occurred_when
    , CAST(quantity AS NUMERIC) AS quantity
    , CAST(last_edited_by AS INTEGER) AS last_edited_by
  FROM fact_inventory_transaction__rename_column 
)

SELECT
*
FROM fact_inventory_transaction__cast_type

