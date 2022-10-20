WITH fact_inventory_snapshot__net_change_quantity AS (
  SELECT 
    CAST(DATE_TRUNC(transaction_occurred_when, MONTH) AS DATE) AS year_month
    , product_id 
    , SUM(quantity) AS net_change_quantity
  FROM `main-363923.wide_world_importers_dwh.fact_inventory_transaction`
  GROUP BY year_month, product_id
)

, fact_invetory_snapshot__sold_quantity AS (
  SELECT 
    CAST(DATE_TRUNC(order_date, MONTH) AS DATE) AS year_month
    , product_id
    , SUM(quantity) AS sold_quantity
  FROM `main-363923.wide_world_importers_dwh.fact_sales_order_line`
  GROUP BY year_month, product_id
)

, fact_inventory_snapshot__distinct_product_id AS (
  SELECT DISTINCT
    year_month
    , product_id
  FROM `main-363923.wide_world_importers_dwh.dim_date`
  CROSS JOIN `main-363923.wide_world_importers_dwh.fact_inventory_transaction`
)

, fact_inventory_snapshot__handle_null AS (
  SELECT
    fact_inventory_snapshot__distinct_product_id.year_month
    , fact_inventory_snapshot__distinct_product_id.product_id
    , COALESCE(fact_inventory_snapshot__net_change_quantity.net_change_quantity, 0) AS net_change_quantity
    , COALESCE(fact_invetory_snapshot__sold_quantity.sold_quantity, 0) AS sold_quantity
  FROM fact_inventory_snapshot__distinct_product_id
  LEFT JOIN fact_inventory_snapshot__net_change_quantity
    ON fact_inventory_snapshot__distinct_product_id.year_month = fact_inventory_snapshot__net_change_quantity.year_month
    AND fact_inventory_snapshot__distinct_product_id.product_id = fact_inventory_snapshot__net_change_quantity.product_id
  LEFT JOIN fact_invetory_snapshot__sold_quantity
    ON fact_inventory_snapshot__distinct_product_id.year_month = fact_invetory_snapshot__sold_quantity.year_month
    AND fact_inventory_snapshot__distinct_product_id.product_id = fact_invetory_snapshot__sold_quantity.product_id
)

SELECT
  *
  , SUM(fact_inventory_snapshot__handle_null.net_change_quantity) OVER (PARTITION BY fact_inventory_snapshot__handle_null.product_id ORDER BY     fact_inventory_snapshot__handle_null.year_month) AS closing_on_hand
FROM fact_inventory_snapshot__handle_null
