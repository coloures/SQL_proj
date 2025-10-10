from src.get_dataset import get_dataset
from src.load_data_to_db import load_data
from src.fill_structured_table import fill_structured_table

def running(start_date, end_date):
    # 1. Создание датасета с данными
    data = get_dataset(500_000)
    
    # 2. Загрузка данных в БД
    try: 
        load_data(data)
    except Exception as e: 
        print(e)
        print("Изначальная загрузка не очень")
        str_ = input()

    # 3. Чистка данных и их загрузка в структурированную таблицу
    try:
        fill_structured_table(start_date, end_date)
    except Exception as e: 
        print(e)
        print("Структурированная загрузка не очень")
        str_ = input()