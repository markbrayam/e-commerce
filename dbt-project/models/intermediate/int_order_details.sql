with orders as (
    select * from {{ ref('stg_orders') }}
),
order_items as (
    select * from {{ ref('stg_order_items') }}
),
products as (
    select * from {{ ref('stg_products') }}
)

select
    oi.order_id,
    o.customer_id,
    o.order_date,
    oi.product_id,
    oi.quantity,
    p.price as unit_price,
    -- Calculamos el ingreso por linea (Requerimiento de logica de negocio)
    (oi.quantity * p.price) as line_item_revenue,
    o.status
from order_items oi
inner join orders o on oi.order_id = o.order_id
inner join products p on oi.product_id = p.product_id