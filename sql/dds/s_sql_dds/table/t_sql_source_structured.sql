create table s_psql_dds.t_sql_source_structured (
	user_id bigint primary key,
	name varchar(100) not null,
	email varchar(100) not null,
	status varchar(100) not null,
	region varchar(100) not null,
	product_type varchar(100) not null,
	order_date DATE not null,
	delivery_date DATE not null,
	payment_method varchar not null,
	price integer not null
)