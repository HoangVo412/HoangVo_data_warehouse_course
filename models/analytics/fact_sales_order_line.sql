WITH fact_sales_order_line__source AS(
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  SELECT
    order_line_id AS sales_order_line_id
    , stock_item_id AS product_id
    , quantity AS quantity
    , unit_price AS unit_price
  FROM fact_sales_order_line__source
)

, fact_sales_order_line__calculate AS (
  SELECT 
    *
    , quantity * unit_price AS gross_amount
  FROM fact_sales_order_line__rename_column
)

SELECT * 
FROM fact_sales_order_line__calculate