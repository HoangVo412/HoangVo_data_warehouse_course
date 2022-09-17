{#
Yêu cầu #0104b:
- Chuyển đổi data type của bảng này

#}



SELECT 
  CAST(order_line_id AS INTEGER) AS sales_order_line_id
  , CAST(stock_item_id AS INTEGER) AS product_id
  , CAST(quantity AS NUMERIC) As quantity
  , CAST(unit_price AS NUMERIC) As unit_price
  , CAST(quantity AS NUMERIC) * CAST(unit_price AS NUMERIC) AS gross_amount
FROM `duckdata-320210.wide_world_importers.sales__order_lines`
