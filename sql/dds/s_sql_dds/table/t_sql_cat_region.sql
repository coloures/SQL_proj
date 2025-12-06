Create table s_psql_dds.t_sql_cat_region (
    region_id int generated always as identity primary key,
    region Varchar(100) not null
);