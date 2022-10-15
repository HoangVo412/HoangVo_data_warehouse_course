WITH dim_transaction_type__source AS(
  SELECT *
  FROM `duckdata-320210.wide_world_importers.application__transaction_types`
)

, dim_transaction__rename_column AS (
  SELECT
    transaction_type_id
    , transaction_type_name
      FROM dim_transaction_type__source
)

, dim_transaction__cast_type AS (
  SELECT
    CAST(transaction_type_id AS INTEGER) AS transaction_type_id
    , CAST(transaction_type_name AS STRING) AS transaction_type_name
  FROM dim_transaction__rename_column 
)

SELECT
*
FROM dim_transaction__cast_type