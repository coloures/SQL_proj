Create table s_psql_dds.t_sql_cat_payment_method (
    payment_method_id int generated always as identity primary key,
    payment_method Varchar(100)
);