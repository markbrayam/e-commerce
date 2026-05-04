with customers as (
    select * from {{ ref('stg_customers') }}
),
customer_aggs as (
    select * from {{ ref('int_customer_orders_agged') }}
)

select
    c.customer_id,
    c.customer_name,
    c.email,
    coalesce(a.first_order_date, null) as first_order_date,
    coalesce(a.last_order_date, null) as last_order_date,
    coalesce(a.total_orders, 0) as total_orders,
    coalesce(a.lifetime_revenue, 0) as total_revenue,
    -- Aplicamos la macro de segmentacion (Requerimiento 1.2 y 1.3)
    {{ get_customer_segment('a.lifetime_revenue', 'a.total_orders') }} as customer_segment
from customers c
left join customer_aggs a on c.customer_id = a.customer_id