WITH dim_suppliers__source AS (
    SELECT *
    FROM `duckdata-320210.wide_world_importers.purchasing__suppliers`
)

, dim_suppliers__cast_type AS (
    SELECT
      CAST(supplier_id AS INTEGER) AS supplier_id
      , CAST(supplier_name AS STRING) AS supplier_name
    FROM dim_suppliers__source
)

SELECT *
FROM dim_suppliers__cast_type