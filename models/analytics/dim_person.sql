WITH dim_person__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.application__people`
)

, dim_person__rename_column AS (
  SELECT
    person_id AS person_id
    , full_name AS person_full_name
  FROM dim_person__source
)
, dim_person__cast_type AS (
  SELECT
    CAST(person_id AS INTEGER) AS person_id
    , CAST(person_full_name AS STRING) AS person_full_name
  FROM dim_person__rename_column
)

SELECT
  *
FROM dim_person__cast_type
UNION ALL
SELECT
  0 AS person_id
  , 'No data' AS person_full_name