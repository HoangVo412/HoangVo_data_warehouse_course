SELECT
  product_id
  , SUM(quantity) AS quantity_on_hand
FROM {{ref('fact_inventory_transaction')}}
GROUP BY product_id