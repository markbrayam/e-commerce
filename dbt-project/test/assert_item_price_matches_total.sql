-- Falla si la suma de los items no coincide con el total reportado en el resumen 
-- Inconsisetencia de los datos/Detección de fraudes...(lo comentado en la entrevista)
with order_details as (
    select 
        order_id,
        sum(item_price * quantity) as calculated_total
    from {{ ref('stg_order_items') }}
    group by 1
)

select 
    m.order_id,
    m.total_revenue,
    d.calculated_total
from {{ ref('mart_orders_summary') }} m
join order_details d on m.order_id = d.order_id
where abs(m.total_revenue - d.calculated_total) > 0.01 -- Tolerancia para decimales