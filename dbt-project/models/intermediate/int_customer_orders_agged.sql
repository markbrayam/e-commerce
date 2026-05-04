with order_details as (
    select * from {{ ref('int_order_details') }}
)

select
    customer_id,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(distinct order_id) as total_orders,
    sum(line_item_revenue) as lifetime_revenue
from order_details
group by 1