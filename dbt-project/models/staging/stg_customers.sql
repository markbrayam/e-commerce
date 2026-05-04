with source as (
    select * from {{ source('raw', 'customers') }}
)

select
    customer_id,
    -- Aplicamos limpieza básica (requerimiento 1.1)
    trim(name) as customer_name,
    lower(trim(email)) as email
from source
where customer_id is not null