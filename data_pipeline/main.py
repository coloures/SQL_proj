from src.get_dataset import get_dataset
from src.load_data_to_db import load_data
from src.fill_structured_table import fill_structured_table
from src.etl import running
from datetime import date

def run_pipeline():
    print("🚀 Запуск ETL-пайплайна...")
    
    running(date(2025, 1, 1),date(2025, 10, 10))
    
    print("🎉 Пайплайн завершён успешно!")

# Запуск при выполнении скрипта
if __name__ == "__main__":
    run_pipeline()