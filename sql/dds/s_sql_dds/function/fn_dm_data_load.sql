CREATE OR REPLACE FUNCTION s_psql_dds.fn_dm_data_load(start_date DATE, end_date DATE)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    cnt integer;
BEGIN
    DELETE FROM s_psql_dds.t_dm_task
    WHERE order_date BETWEEN start_date AND end_date;
    
    INSERT INTO s_psql_dds.t_sql_cat_payment_method (payment_method)
    SELECT DISTINCT s.payment_method
    FROM s_psql_dds.t_sql_source_structured s
    WHERE NOT EXISTS (
        SELECT 1
        FROM s_psql_dds.t_sql_cat_payment_method c
        WHERE c.payment_method = s.payment_method
    );
    
    INSERT INTO s_psql_dds.t_sql_cat_product_type (product_type)
    SELECT DISTINCT s.product_type
    FROM s_psql_dds.t_sql_source_structured s
    WHERE NOT EXISTS (
        SELECT 1
        FROM s_psql_dds.t_sql_cat_product_type c
        WHERE c.product_type = s.product_type
    );

    INSERT INTO s_psql_dds.t_sql_cat_region (region)
    SELECT DISTINCT s.region
    FROM s_psql_dds.t_sql_source_structured s
    WHERE NOT EXISTS (
        SELECT 1
        FROM s_psql_dds.t_sql_cat_region c
        WHERE c.region = s.region
    );
    
    INSERT INTO s_psql_dds.t_sql_cat_status (status)
    SELECT DISTINCT s.status
    FROM s_psql_dds.t_sql_source_structured s
    WHERE NOT EXISTS (
        SELECT 1
        FROM s_psql_dds.t_sql_cat_status c
        WHERE c.status = s.status
    );

    with cte (user_id, name, email, status_id, status, 
    region_id, region, product_type_id, product_type, 
    order_date, delivery_date, payment_method_id, 
    payment_method, price) as (
        select t1.user_id, t1.name, t1.email, 
        t2.status_id, t1.status, t3.region_id, 
        t1.region, t4.product_type_id, t1.product_type,
        t1.order_date, t1.delivery_date, t5.payment_method_id,
        t1.payment_method, t1.price
        from s_psql_dds.t_sql_source_structured t1 
        join s_psql_dds.t_sql_cat_status t2 
        on t1.status = t2.status 
        join s_psql_dds.t_sql_cat_region t3
        on t1.region = t3.region
        join s_psql_dds.t_sql_cat_product_type t4
        on t1.product_type = t4.product_type
        join s_psql_dds.t_sql_cat_payment_method t5
        on t1.payment_method = t5.payment_method 
        where t1.order_date between start_date and end_date
    )
    INSERT into s_psql_dds.t_dm_task
    select * from cte;
END;
$$;