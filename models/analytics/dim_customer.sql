WITH dim_customer__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
  SELECT
    customer_id
    , customer_name
    , is_on_credit_hold AS is_on_credit_hold_boolean
    , customer_category_id
    , buying_group_id
    , delivery_method_id
  FROM dim_customer__source
)

, dim_cusomer__cast_type AS (
  SELECT
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(is_on_credit_hold_boolean AS BOOLEAN) as is_on_credit_hold_boolean
    , CAST(customer_category_id AS INTEGER) AS customer_category_id
    , CAST(buying_group_id AS INTEGER) AS buying_group_id
    , CAST(delivery_method_id AS INTEGER) AS delivery_method_id
  FROM dim_customer__rename_column 
)

, dim_customer__handle_null AS (
  SELECT
    customer_id
    , customer_name
    , is_on_credit_hold_boolean
    , COALESCE(customer_category_id, 0) AS customer_category_id
    , COALESCE(buying_group_id, 0) AS buying_group_id
    , COALESCE(delivery_method_id, 0) AS delivery_method_id
  FROM dim_cusomer__cast_type
)

, dim_customer__convert_boolean AS (
  SELECT
    *
    , CASE 
    WHEN is_on_credit_hold_boolean IS TRUE THEN 'On Credit Hold'
    WHEN is_on_credit_hold_boolean IS FALSE THEN 'Not On Credit Hold'
    ELSE 'Undefined'
    END
    AS is_on_credit_hold
  FROM dim_customer__handle_null
)

, dim_customer__add_undefinded_record AS (
  SELECT
    customer_id
    , customer_name
    , is_on_credit_hold
    , customer_category_id
    , buying_group_id
    , delivery_method_id
  FROM dim_customer__convert_boolean

  UNION ALL
  SELECT
    0 AS customer_id
    , 'Undefined' AS customer_name
    , 'Undefined' AS is_on_credit_hold
    , 0 AS customer_category_id
    , 0 AS buying_group_id
    , 0 AS delivery_method_id
)

SELECT 
  dim_customer.customer_id
  , dim_customer.customer_name
  , dim_customer.customer_category_id
  , COALESCE(stg_fact_customers_category.customer_category_name,'Undefined') AS customer_category_name
  , dim_customer.buying_group_id
  , COALESCE(stg_fact_buying_groups.buying_group_name ,'Undefined') AS buying_group_name
  , dim_customer.delivery_method_id
  , COALESCE(stg_fact_delivery_methods.delivery_method_name, 'Undefined') AS delivery_method_name
FROM dim_cusomer__cast_type AS dim_customer
LEFT JOIN {{ref('stg_fact_customers_category')}} AS stg_fact_customers_category
ON dim_customer.customer_category_id = stg_fact_customers_category.customer_category_id
LEFT JOIN {{ref('stg_fact_buying_groups')}} AS stg_fact_buying_groups
ON dim_customer.buying_group_id = stg_fact_buying_groups.buying_group_id
LEFT JOIN {{ref('stg_fact_delivery_methods')}} AS stg_fact_delivery_methods
ON dim_customer.delivery_method_id = stg_fact_delivery_methods.delivery_method_id