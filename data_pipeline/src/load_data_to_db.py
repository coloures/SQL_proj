import pandas as pd
import numpy as np
from sqlalchemy import create_engine, DATE
from config import db_host, db_name, db_password, db_port, db_user, schema, table_name

def load_data(data):

    # Создание строки подключения
    connection_string = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'

    # Создание движка SQLAlchemy
    engine = create_engine(connection_string)

    # Загрузка DataFrame в таблицу
    data.to_sql(
        name=table_name,
        con=engine,
        dtype={
            'order_date': DATE
        },
        schema = schema,
        if_exists='append',  # или 'replace', 'fail'
        index=False,         # не сохранять индекс как отдельный столбец
        method='multi'       # ускоряет вставку множества строк
    )