with cte1 as (
select 
    cast(date_trunc(transaction_occurred_when, MONTH) as date) as month
    , product_id 
    , sum(quantity) as net_change_quantity
  from `main-363923.wide_world_importers_dwh.fact_stock_item_transaction`
  group by month, product_id
)

, cte2 as (
  select 
  cast(date_trunc(order_date, MONTH) as date) as month
  , product_id
  , sum(quantity) as sold_quantity
from `main-363923.wide_world_importers_dwh.fact_sales_order_line`
group by month, product_id
)

, cte3 as (
select distinct
  year_month as month
  , product_id
from `main-363923.wide_world_importers_dwh.dim_date`
cross join `main-363923.wide_world_importers_dwh.fact_stock_item_transaction`
)

, cte4 as (
select
  cte3.month
  , cte3.product_id
  , coalesce(cte1.net_change_quantity, 0) as net_change_quantity
  , coalesce(cte2.sold_quantity, 0) as sold_quantity
from cte3
left join cte1
  on cte3.month = cte1.month
  and cte3.product_id = cte1.product_id
left join cte2
  on cte3.month = cte2.month
  and cte3.product_id = cte2.product_id
)

select
  *
  , sum(cte4.net_change_quantity) over (partition by cte4.product_id order by cte4.month) as closing_on_hand
from cte4
