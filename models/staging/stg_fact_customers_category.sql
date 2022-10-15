WITH stg_fact_customers_category__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customer_categories`
)

, stg_fact_customers_category__cast_type AS (
  SELECT
    CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(customer_category_name AS STRING) AS customer_category_name
  FROM stg_fact_customers_category__source
)

SELECT *
FROM stg_fact_customers_category__cast_type