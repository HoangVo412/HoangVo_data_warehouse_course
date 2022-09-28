WITH fact_sales_order_line__source AS(
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
  SELECT
    order_line_id AS sales_order_line_id
    , quantity AS quantity
    , unit_price AS unit_price
  FROM fact_sales_order_line__source
)

SELECT * 
FROM fact_sales_order_line__rename_column