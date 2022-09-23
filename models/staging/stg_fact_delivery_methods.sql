WITH fact_delivery_methods__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.application__delivery_methods`
)

, fact_delivery_methods__rename_column AS (
  SELECT 
    delivery_method_id
    , delivery_method_name
  FROM fact_delivery_methods__source
)

, fact_delivery_methods__cast_type AS (
  SELECT
    CAST(delivery_method_id AS INTEGER) AS delivery_method_id
    , CAST(delivery_method_name AS STRING) AS delivery_method_name
  FROM fact_delivery_methods__rename_column
)

SELECT
  delivery_method_id
  , delivery_method_name
FROM fact_delivery_methods__cast_type
