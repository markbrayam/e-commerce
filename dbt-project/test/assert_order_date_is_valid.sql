-- Este test falla si hay pedidos con fechas imposibles
select
    order_id,
    order_date,
    shipping_date
from {{ ref('stg_orders') }}
where shipping_date < order_date 
   or order_date > current_date()