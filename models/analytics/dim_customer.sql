WITH dim_customer__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_cusomer__cast_type AS (
  SELECT
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
  FROM dim_customer__source 
)

SELECT *
FROM dim_cusomer__cast_type