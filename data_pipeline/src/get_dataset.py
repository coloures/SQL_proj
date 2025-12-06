import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta, date

def get_dataset(n_rows=100000):

    random.seed(42)
    np.random.seed(42)

    # Списки для генерации имён и категорий
    first_names = ['Алексей', 'Мария', 'Иван', 'Елена', 'Сергей', 'Ольга', 'Дмитрий', 'Анна', 'Андрей', 'Татьяна']
    last_names = ['Иванов', 'Петрова', 'Сидоров', 'Кузнецова', 'Смирнов', 'Попова', 'Лебедев', 'Новикова']
    statuses = ['активен', 'неактивен', 'приостановлен', 'удалён', 'ожидает подтверждения']
    regions = ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань', 'Нижний Новгород']
    product_types = ['Электроника', 'Одежда', 'Книги', 'Продукты', 'Бытовая техника', 'Игрушки']
    payment_methods = ['Карта', 'Наличные', 'PayPal', 'Apple Pay', 'Google Pay', 'Криптовалюта']

    # Диапазон дат: от 2020-01-01 до сегодня
    start_date = datetime(2000, 1, 1)
    today = datetime.today()
    total_days = (today - start_date).days
    user_id = 1
    # Собираем данные
    records = []
    for _ in range(n_rows):
        # Генерация имени
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        
        # Генерация email (простой шаблон)
        email = f"{name.replace(' ', '.').lower()}@example.com"
        
        # Категориальные признаки
        status = random.choice(statuses)
        region = random.choice(regions)
        product_type = random.choice(product_types)
        payment_method = random.choice(payment_methods)
        
        # Даты
        order_days_offset = random.randint(0, total_days)
        order_date = (start_date + timedelta(days=order_days_offset)).date()
        delivery_offset = random.randint(-5, 20)  # иногда до заказа, иногда через 3 недели
        delivery_date = order_date + timedelta(days=delivery_offset)
        
        # Цена
        price = round(random.uniform(50.0, 10000.0), 2)

        # 1. Иногда делаем email битым
        if random.random() < 0.03:
            if random.choice([True, False]):
                email = email.replace('@', '')  # убираем @
            else:
                email = "invalid-email"

        # 2. Опечатки или регистр в статусе
        if random.random() < 0.02:
            if random.choice([True, False]):
                status = status.upper()
            else:
                status = status + random.choice(['x', '1', ' '])

        # 3. Пропуски
        if random.random() < 0.02:
            region = None
        if random.random() < 0.015:
            payment_method = None
        if random.random() < 0.005:
            name = ""
        if random.random() < 0.005:
            email = None

        # 4. Дата доставки как строка в неправильном формате
        if random.random() < 0.01:
            delivery_date = delivery_date.strftime("%d/%m/%Y")

        # 5. Цена как строка или отрицательная
        if random.random() < 0.01:
            price = str(price)
        elif random.random() < 0.005:
            price = -abs(price)

        records.append({
            'user_id': user_id,
            'name': name,
            'email': email,
            'status': status,
            'region': region,
            'product_type': product_type,
            'order_date': order_date,
            'delivery_date': delivery_date,
            'payment_method': payment_method,
            'price': price
        })
        user_id += 1

    df = pd.DataFrame(records)

    # 6. Перемешиваем
    df = df.sample(frac=1, random_state=42).reset_index(drop=True)

    return df