CREATE VIEW s_psql_dds.v_dq_dashboard AS
SELECT
    execution_date::date AS dt,
    check_type,
    COUNT(*) AS checks_cnt,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_cnt
FROM s_psql_dds.t_dq_check_results
GROUP BY 1,2;