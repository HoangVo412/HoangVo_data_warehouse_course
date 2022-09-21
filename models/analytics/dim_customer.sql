{#
Yêu cầu #0106b:
- Xem thông tin và dữ liệu của bảng "sales__customers"
- Sửa câu query SQL để lấy 2 cột: "customer_id", "customer_name"

#}


WITH dim_customer__source AS (
  SELECT 
    *
  FROM `duckdata-320210.wide_world_importers.sales__customers`
)

, dim_customer__cast_type AS (
  SELECt
    CAST(customer_id AS INTEGER) AS customer_id
    , CAST(customer_name AS STRING) AS customer_name
  FROM dim_customer__source
)

SELECT 
  *
FROM dim_customer__cast_type
