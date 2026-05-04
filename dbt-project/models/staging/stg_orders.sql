with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        -- Conversión de fecha (Requerimiento de calidad)
        safe.parse_date('%Y-%m-%d', cast(order_date as string)) as order_date,
        -- Uso de la macro para normalizar el status (Requerimiento 1.2 y 1.3)
        {{ normalize_text('status') }} as status
    from source
)

-- Eliminación de duplicados (Requerimiento de calidad)
select distinct * from renamed
where order_id is not null