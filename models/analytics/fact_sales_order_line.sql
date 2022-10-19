WITH fact_sales_order_line__source AS(
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  SELECT
    order_line_id AS sales_order_line_id
    , order_id AS order_id
    , stock_item_id AS product_id
    , quantity AS quantity
    , unit_price AS unit_price  
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT
    CAST(sales_order_line_id AS INTEGER) AS sales_order_line_id
    , CAST(order_id AS INTEGER) AS order_id
    , CAST(product_id AS INTEGER) AS product_id
    , CAST(quantity AS NUMERIC) AS quantity
    , CAST(unit_price AS NUMERIC) AS unit_price
  FROM fact_sales_order_line__rename_column
)

, fact_sales_order_line__calculate AS (
  SELECT 
    *
    , quantity * unit_price AS gross_amount
  FROM fact_sales_order_line__cast_type
)

SELECT 
  fact_sales_order_line.sales_order_line_id
  , fact_sales_order_line.order_id
  , fact_sales_order_line.product_id
  , stg_fact_sales_order.customer_id
  , COALESCE(stg_fact_sales_order.picked_by_person_id, 0) AS picked_by_person_id
  , fact_sales_order_line.quantity
  , fact_sales_order_line.unit_price
  , fact_sales_order_line.gross_amount
  , stg_fact_sales_order.order_date
FROM fact_sales_order_line__calculate AS fact_sales_order_line
LEFT JOIN {{ref('stg_fact_sales_order')}} AS stg_fact_sales_order
ON fact_sales_order_line.order_id = stg_fact_sales_order.sales_order_id