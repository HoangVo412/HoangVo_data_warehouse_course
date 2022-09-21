WITH fact_sales_order__source AS (
  SELECT order_id, customer_id
  FROM `duckdata-320210.wide_world_importers.sales__orders`
)

, fact_sales_order__cast_type AS (
  SELECT 
    CAST(order_id AS INTEGER) AS order_id
    , CAST(customer_id AS INTEGER) AS customer_id
  FROM fact_sales_order__source
)

SELECT *
FROM fact_sales_order__cast_type