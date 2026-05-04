with order_details as (
    select * from {{ ref('int_order_details') }}
)

select
    order_id,
    customer_id,
    order_date,
    count(product_id) as total_items,
    sum(line_item_revenue) as total_revenue,
    -- El status ya viene normalizado desde staging gracias a la macro
    status as order_status
from order_details
group by 1, 2, 3, 6