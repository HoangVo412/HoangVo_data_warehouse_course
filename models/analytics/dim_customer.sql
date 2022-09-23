{#
Yêu cầu #0107b:
- Flatten các dữ liệu sau cho bảng "dim_customer":
  - customer_category_id
  - customer_category_name
  - buying_group_id
  - buying_group_name
  - delivery_method_id
  - delivery_method_name

#}


WITH dim_customer__source AS (
  SELECT * 
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_customer__cast_type AS (
  SELECT 
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(customer_category_name AS STRING) AS customer_category_name
    , CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(buying_group_name AS STRING) AS buying_group_name
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
    , CAST(delivery_method_name AS STRING) AS delivery_method_name
  FROM dim_customer__source
)

SELECT
  dim_customer.customer_id
  , dim_customer.customer_name
  , dim_customer.customer_category_id
  , stg_fact_customer_categories.customer_category_name
  , dim_customer.buying_group_id
  , stg_fact_buying_groups.buying_group_name
  , dim_customer.delivery_method_id
  , stg_fact_delivery_methods.delivery_method_name
FROM dim_customer__cast_type AS dim_customer
LEFT JOIN {{ref('stg_fact_customer_categories')}} AS stg_fact_customer_categories
  ON dim_customer.customer_category_id  = stg_fact_customer_categories.customer_category_id
LEFT JOIN {{ref('stg_fact_buying_groups')}} AS stg_fact_buying_groups
  ON dim_customer.buying_group_id = stg_fact_buying_groups.buying_group_id
LEFT JOIN {{ ref('stg_fact_delivery_methods') }} AS stg_fact_delivery_methods
  ON dim_customer.delivery_method_id = stg_fact_delivery_methods.delivery_method_id
