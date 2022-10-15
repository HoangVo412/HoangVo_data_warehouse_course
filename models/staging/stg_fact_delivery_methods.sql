WITH stg_fact_delivery_methods__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.application__delivery_methods`
)

, stg_fact_delivery_methods__cast_type AS (
  SELECT
    CAST(delivery_method_id AS INTEGER) AS delivery_method_id
    , CAST(delivery_method_name AS STRING) AS delivery_method_name
  FROM stg_fact_delivery_methods__source
)

SELECT *
FROM stg_fact_delivery_methods__cast_type