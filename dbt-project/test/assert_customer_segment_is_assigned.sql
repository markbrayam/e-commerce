-- Falla si un cliente con ventas no tiene un segmento asignado
select
    customer_id,
    total_spent,
    customer_segment
from {{ ref('mart_customer_ltv') }}
where total_spent > 0 
  and (customer_segment is null or customer_segment = 'Unknown')