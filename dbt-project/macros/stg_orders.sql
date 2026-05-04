WITH source AS (
    SELECT * FROM {{ source('raw', 'orders') }}
),
renamed AS (
    SELECT
        order_id,
        customer_id,
        CAST(order_date AS DATE) AS order_date,
        {{ normalize_text('status') }} AS order_status
    FROM source
    -- Eliminamos duplicados por order_id manteniendo el registro más reciente
    QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_date DESC) = 1
)
SELECT * FROM renamed