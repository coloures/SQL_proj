Create table s_psql_dds.t_sql_cat_product_type (
    product_type_id int generated always as identity primary key,
    product_type Varchar(100) not null
);