WITH orders AS (
    SELECT * FROM {{ ref('mart_orders_summary') }}
),
customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),
customer_stats AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS total_orders,
        SUM(total_revenue) AS total_revenue
    FROM orders
    GROUP BY 1
)
SELECT
    c.customer_id,
    COALESCE(c.name, 'Sin Nombre') AS customer_name,
    c.email,
    s.first_order_date,
    s.last_order_date,
    s.total_orders,
    s.total_revenue,
    {{ get_customer_segment('s.total_revenue', 's.total_orders') }} AS customer_segment
FROM customers c
LEFT JOIN customer_stats s ON c.customer_id = s.customer_id