CREATE OR REPLACE FUNCTION s_psql_dds.fn_etl_data_load(start_date DATE, end_date DATE)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    temp_date DATE;
BEGIN
    INSERT INTO s_psql_dds.t_sql_source_structured (
        user_id, name, email, status, region, product_type, 
        order_date, delivery_date, payment_method, price
    )
    SELECT DISTINCT ON (user_id)
        user_id::BIGINT,
        name,
        email,
        CASE
            WHEN status ~* 'активен' THEN
                'Активен'
            WHEN status ~* 'ожидает подтверждения' THEN
                'Ожидает подтверждения'
            WHEN status ~* 'удалён' THEN
                'Удалён'
            WHEN status ~* 'неактивен' THEN
                'Неактивен'
            ELSE 'Приостановлен'
        END AS status,
        region,
        product_type,
        order_date::DATE AS order_date,
        CASE
            WHEN delivery_date ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
                delivery_date::DATE
            WHEN delivery_date ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN
                TO_DATE(delivery_date, 'DD/MM/YYYY')
            ELSE
                null
        END AS delivery_date,
        payment_method,
        ABS(price::NUMERIC) AS price
    from s_psql_dds.t_sql_source_unstructured
    WHERE
        (LENGTH(NAME) > 0)
        AND
        (   
            email ~* '@example.com$'
        )
        AND
        (   
            status ~* 'активен' 
            or status ~* 'ожидает подтверждения' 
            or status ~* 'удалён'
            or status ~* 'неактивен'
            or status ~* 'приостановлен'
        )
        AND
        (region is not NULL)
        AND
        (
            delivery_date ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            OR delivery_date ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        )
        AND (
            CASE
                WHEN delivery_date ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN 
                    delivery_date::DATE
                WHEN delivery_date ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN 
                    TO_DATE(delivery_date, 'DD/MM/YYYY')
            END
        ) BETWEEN start_date AND end_date
        AND
        (payment_method is not null)
    ORDER BY user_id, order_date DESC;
END;
$$;