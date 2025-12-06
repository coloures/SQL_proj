CREATE OR REPLACE VIEW s_psql_dds.v_dm_task AS
SELECT
    user_id,
    name,
    email,
    status_id,
    status,
    region_id,
    region,
    product_type_id,
    product_type,
    order_date,
    delivery_date,
    payment_method_id,
    payment_method,
    price
FROM s_psql_dds.t_dm_task;