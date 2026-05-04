with source as (
    select * from {{ source('raw', 'products') }}
)

select
    product_id,
    -- Usamos la macro de normalización para el nombre del producto
    {{ normalize_text('name') }} as product_name,
    price
from source
where product_id is not null