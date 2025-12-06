from sqlalchemy import create_engine, text
from datetime import date
from config import db_host, db_name, db_password, db_port, db_user

def fill_dm_table(start_date: date, end_date: date):
    connection_string = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
    engine = create_engine(connection_string)
    try:
        with engine.begin() as conn:
            conn.execute(
                text("SELECT s_psql_dds.fn_dm_data_load(:start_date, :end_date);"),
                {"start_date": start_date, "end_date": end_date}
            )
    except Exception as e:
        print(f"Ошибка: {e}")
        input()