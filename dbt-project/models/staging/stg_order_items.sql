with source as (
    select * from {{ source('raw', 'order_items') }}
)

select
    -- Generamos un surrogate key si fuera necesario, pero por ahora mantenemos los IDs
    order_id,
    product_id,
    quantity,
    -- Aquí podría renombrar/transformar columnas si fuera necesario
from source
-- Limpieza: El PDF muestra cantidades negativas en raw, las filtramos aquí
where quantity > 0 
  and order_id is not null
  and product_id is not null