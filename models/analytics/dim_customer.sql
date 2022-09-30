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

SELECT 
  dim_customer.customer_id
  , dim_customer.customer_name
  , dim_customer.customer_category_id
  , COALESCE(stg_fact_customers_category.customer_category_name,'No data') AS customer_category_name
  , dim_customer.buying_group_id
  , COALESCE(stg_fact_buying_groups.buying_group_name ,'No data') AS buying_group_name
  , dim_customer.delivery_method_id
  , COALESCE(stg_fact_delivery_methods.delivery_method_name, 'No data') AS delivery_method_name
FROM dim_cusomer__cast_type AS dim_customer
LEFT JOIN {{ref('stg_fact_customers_category')}} AS stg_fact_customers_category
ON dim_customer.customer_category_id = stg_fact_customers_category.customer_category_id
LEFT JOIN {{ref('stg_fact_buying_groups')}} AS stg_fact_buying_groups
ON dim_customer.buying_group_id = stg_fact_buying_groups.buying_group_id
LEFT JOIN {{ref('stg_fact_delivery_methods')}} AS stg_fact_delivery_methods
ON dim_customer.delivery_method_id = stg_fact_delivery_methods.delivery_method_id