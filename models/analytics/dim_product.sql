WITH dim_product__source AS (
  SELECT *
  FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
)

, dim_product__rename_column AS (
  SELECT
    stock_item_id AS product_id
    , stock_item_name AS product_name
    , brand AS brand_name
    , supplier_id AS supplier_id
    , is_chiller_stock AS is_chiller_stock_boolean
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT
    CAST(product_id AS INTEGER) AS product_id
    , CAST(product_name AS STRING) AS product_name
    , CAST(brand_name AS STRING) AS brand_name
    , CAST(supplier_id AS INTEGER) AS supplier_id
    , CAST(is_chiller_stock_boolean AS BOOL) AS is_chiller_stock_boolean
  FROM dim_product__rename_column
)

, dim_product__convert_boolean AS (
  SELECT
    *
    , CASE
        WHEN is_chiller_stock_boolean IS TRUE THEN 'Chiller stock'
        WHEN is_chiller_stock_boolean IS FALSE THEN 'Not chiller stock'
        ELSE 'Undefined'
      END AS is_chiller_stock
  FROM dim_product__cast_type
)

, dim_product__add_category AS (
  SELECT
    CAST(dim_product__add_category_id.stock_item_id AS INTEGER) AS product_id
    , CAST(dim_product__add_category_id.category_id AS INTEGER) AS category_id
    , CAST(dim_product__add_category_name.category_name AS STRING) AS category_name
  FROM `duckdata-320210.wide_world_importers.external__stock_item_categories` AS dim_product__add_category_id
  LEFT JOIN `duckdata-320210.wide_world_importers.external__categories` AS dim_product__add_category_name
    ON dim_product__add_category_id.category_id = dim_product__add_category_name.category_id
)

SELECT 
  dim_product.product_id
  , dim_product.product_name
  , dim_product.brand_name
  , dim_product.supplier_id
  , COALESCE(dim_supplier.supplier_name, 'No data') AS supplier_name
  , dim_product__add_category.category_id
  , dim_product__add_category.category_name
FROM dim_product__convert_boolean AS dim_product
LEFT JOIN {{ref('dim_supplier')}} AS dim_supplier
  ON dim_product.supplier_id = dim_supplier.supplier_id
LEFT JOIN dim_product__add_category
  ON dim_product.product_id = dim_product__add_category.product_id