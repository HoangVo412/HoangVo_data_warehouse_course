WITH stg_fact_sales_order__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__orders`
)

, stg_fact_sales_order__rename_column AS (
  SELECT
    order_id AS sales_order_id
    , customer_id AS customer_id
    , picked_by_person_id AS picked_by_person_id
  FROM stg_fact_sales_order__source
)

, stg_fact_sales_order__cast_type AS (
  SELECT
    CAST(sales_order_id AS INTEGER) AS sales_order_id
    , CAST(customer_id AS INTEGER) AS customer_id
    , CAST(picked_by_person_id AS INTEGER) AS picked_by_person_id
  FROM stg_fact_sales_order__rename_column
)

SELECT *
FROM stg_fact_sales_order__cast_type
