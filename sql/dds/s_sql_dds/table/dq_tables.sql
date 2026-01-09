CREATE TABLE IF NOT EXISTS s_psql_dds.t_dq_check_results (
  check_id SERIAL PRIMARY KEY,
  check_type VARCHAR,
  table_name VARCHAR,
  execution_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR,
  error_message VARCHAR
);
