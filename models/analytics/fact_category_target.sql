WITH fact_category_target__source AS (
  SELECT
    *
  FROM `duckdata-320210.wide_world_importers.external__category_target`
)

, fact_category_target__rename_column AS (
  SELECT
    year AS target_year
    , category_id
    , target_revenue
  FROM fact_category_target__source
)

, fact_category_target__cast_type AS (
  SELECT
    CAST(target_year AS DATE) AS target_year
    , CAST(category_id AS INTEGER) AS category_id
    , CAST(target_revenue AS NUMERIC) AS target_revenue
  FROM fact_category_target__rename_column
)

, fact_sales_order_line_snapshot__gross_amount AS (
  SELECT
    CAST(DATE_TRUNC(order_date, YEAR) AS DATE) AS actual_year
    , category_id
    , category_name
    , SUM(gross_amount) AS actual_revenue
  FROM `main-363923.wide_world_importers_dwh.fact_sales_order_line`
  GROUP BY actual_year, category_id, category_name
)

SELECT
  fact_category_target__cast_type.target_year
  , fact_category_target__cast_type.category_id
  , fact_sales_order_line_snapshot__gross_amount.category_name
  , fact_category_target__cast_type.target_revenue
  , fact_sales_order_line_snapshot__gross_amount.actual_revenue
FROM fact_category_target__cast_type
LEFT JOIN fact_sales_order_line_snapshot__gross_amount
  ON fact_category_target__cast_type.target_year = fact_sales_order_line_snapshot__gross_amount.actual_year
  AND fact_category_target__cast_type.category_id = fact_sales_order_line_snapshot__gross_amount.category_id