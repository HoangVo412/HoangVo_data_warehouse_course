WITH dim_customer__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_cusomer__cast_type AS (
  SELECT
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
  FROM dim_customer__source 
)

SELECT *
FROM dim_cusomer__cast_type AS dim_customer
LEFT JOIN {{ref('stg_factc')}}