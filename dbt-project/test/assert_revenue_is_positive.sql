-- Este test debe fallar si encuentra registros que violen la regla de negativoss
select
    order_id,
    total_revenue
from {{ ref('mart_orders_summary') }}
where total_revenue <= 0