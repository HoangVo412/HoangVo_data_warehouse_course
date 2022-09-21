WITH fact_sales_customer__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customer_categories`
)

, fact_sales_customer__cast_type AS (
  SELECT 
    CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(customer_category_name AS STRING) AS customer_category_name
  FROM fact_sales_customer__source
)

SELECT 
  customer_category_id
  , customer_category_name
FROM fact_sales_customer__cast_type