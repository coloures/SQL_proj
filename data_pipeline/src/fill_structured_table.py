from sqlalchemy import create_engine, text
from config import db_host, db_name, db_password, db_port, db_user

def fill_structured_table(start_date, end_date):
    connection_string = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
    engine = create_engine(connection_string)

    with engine.begin() as conn:
        conn.execute(
            text("SELECT s_psql_dds.fn_etl_data_load(:start_date, :end_date);"),
            {"start_date": start_date, "end_date": end_date}
        )