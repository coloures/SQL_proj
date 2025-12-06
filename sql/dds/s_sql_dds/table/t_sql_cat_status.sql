Create table s_psql_dds.t_sql_cat_status (
    status_id int generated always as identity primary key,
    status Varchar(100) not null
);