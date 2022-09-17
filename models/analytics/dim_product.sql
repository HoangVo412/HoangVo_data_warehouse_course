{#
Trong thực tế, data source khi được đưa về data lake có thể không phải là data type (loại dữ liệu) đúng như mình nghĩ. Một ví dụ thường gặp đó là một cột dạng số (numeric) khi đưa về data lake bị chuyển thành dạng chữ (text). Do đó, để ĐẢM BẢO đúng data type, chúng ta cần phải chuyển đổi data type, dù hiện tại có thể nó đang đúng. 

Yêu cầu #0104a:
- Tìm syntax chuyển đổi data type
- Tìm đọc các loại data type của BigQuery
- Chuyển đổi data type của bảng này
#}


SELECT 
    CAST(stock_item_id AS INTEGER) AS product_id
    , CAST(stock_item_name AS STRING) AS product_name
    , CAST(brand AS STRING) AS brand_name
FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
