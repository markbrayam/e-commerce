{% macro normalize_text(column_name) %}
    -- Macro para normalizar texto (trim, lower) - Requerimiento 1.3
    lower(trim({{ column_name }}))
{% endmacro %}

{% macro get_customer_segment(revenue, order_count) %}
    -- Macro para calcular segmento de cliente - Requerimiento 1.3
    case 
        when {{ revenue }} > 5000 then 'VIP'
        when {{ revenue }} > 500 then 'Regular'
        when {{ order_count }} < 2 then 'Nuevo'
        else 'Regular'
    end
{% endmacro %}
