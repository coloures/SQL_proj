from sqlalchemy import create_engine, text
from config import db_host, db_name, db_password, db_port, db_user

def run_dq_checks(start_date, end_date):
    engine = create_engine(
        f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
    )

    with engine.begin() as conn:
        conn.execute(
            text("SELECT s_psql_dds.fn_dq_checks_load(:start, :end);"),
            {"start": start_date, "end": end_date}
        )