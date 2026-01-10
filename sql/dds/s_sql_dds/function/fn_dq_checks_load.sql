CREATE OR REPLACE FUNCTION s_psql_dds.fn_dq_checks_load(
    start_dt DATE,
    end_dt DATE
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_cnt INT;
BEGIN
    BEGIN
        SELECT
            ROUND(
                100.0 * SUM(
                    CASE
                        WHEN user_id IS NULL
                            OR price IS NULL
                            OR order_date IS NULL
                        THEN 1 ELSE 0
                    END
                ) / NULLIF(COUNT(*), 0),
                2
            )
        INTO v_cnt
        FROM s_psql_dds.v_dm_task;


        INSERT INTO s_psql_dds.t_dq_check_results
        (check_type, table_name, status, error_message)
        VALUES (
            'completeness',
            'v_dm_task',
            CASE WHEN v_cnt = 0 THEN 'passed' ELSE 'failed' END,
            'NULL percent = ' || v_cnt || '%'
        );
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO s_psql_dds.t_dq_check_results
        VALUES (DEFAULT, 'completeness', 'v_dm_task', DEFAULT, 'error', SQLERRM);
    END;

    BEGIN
        SELECT COUNT(*) - COUNT(DISTINCT (user_id, order_date))
        INTO v_cnt
        FROM s_psql_dds.v_dm_task;

        INSERT INTO s_psql_dds.t_dq_check_results
        VALUES (
            DEFAULT,
            'uniqueness',
            'v_dm_task',
            DEFAULT,
            CASE WHEN v_cnt = 0 THEN 'passed' ELSE 'failed' END,
            'duplicates = ' || v_cnt
        );
    END;

    BEGIN
        SELECT COUNT(*)
        INTO v_cnt
        FROM s_psql_dds.v_dm_task
        WHERE status NOT IN (
            'активен',
            'неактивен',
            'приостановлен',
            'удалён',
            'ожидает подтверждения'
        );

        INSERT INTO s_psql_dds.t_dq_check_results
        VALUES (
            DEFAULT,
            'validity',
            'v_dm_task',
            DEFAULT,
            CASE WHEN v_cnt = 0 THEN 'passed' ELSE 'failed' END,
            'invalid status rows = ' || v_cnt
        );
    END;

    BEGIN
        SELECT COUNT(*)
        INTO v_cnt
        FROM s_psql_dds.v_dm_task
        WHERE delivery_date < order_date;

        INSERT INTO s_psql_dds.t_dq_check_results
        VALUES (
            DEFAULT,
            'consistency',
            'v_dm_task',
            DEFAULT,
            CASE WHEN v_cnt = 0 THEN 'passed' ELSE 'failed' END,
            'delivery < order rows = ' || v_cnt
        );
    END;

    BEGIN
        SELECT
            ABS(
                (SELECT COUNT(*) FROM s_psql_dds.t_sql_source_structured
                    WHERE order_date BETWEEN start_dt AND end_dt)
                -
                (SELECT COUNT(*) FROM s_psql_dds.v_dm_task
                    WHERE order_date BETWEEN start_dt AND end_dt)
            )
        INTO v_cnt;

        INSERT INTO s_psql_dds.t_dq_check_results
        VALUES (
            DEFAULT,
            'accuracy',
            'v_dm_task',
            DEFAULT,
            CASE WHEN v_cnt = 0 THEN 'passed' ELSE 'failed' END,
            'row count diff = ' || v_cnt
        );
    END;


END;
$$;
