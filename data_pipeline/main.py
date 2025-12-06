from src.etl import running
from src.fill_dm_table import fill_dm_table
from src.postgre_to_mysql import transfer_pg_to_mysql
from datetime import date

def run_pipeline():
    print("🚀 Запуск ETL-пайплайна...")
    
    running(date(2025, 1, 1),date(2025, 10, 10))

    print("Данные сформированы для stuctured")

    input()

    fill_dm_table(date(2025, 1, 1),date(2025, 10, 10))

    print("Звёздочка заполнена")

    input()

    transfer_pg_to_mysql()

    print("На MySQL данные перекинуты")

    input()
    
    print("🎉 Пайплайн завершён успешно!")

# Запуск при выполнении скрипта
if __name__ == "__main__":
    run_pipeline()