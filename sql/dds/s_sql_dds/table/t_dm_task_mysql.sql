CREATE TABLE t_dm_task_mysql (
    user_id BIGINT,
    name VARCHAR(100),
    email VARCHAR(100),
    status_id INT,
    status VARCHAR(100),
    region_id INT,
    region VARCHAR(100),
    product_type_id INT,
    product_type VARCHAR(100),
    order_date DATE,
    delivery_date DATE,
    payment_method_id INT,
    payment_method VARCHAR(100),
    price INT
);