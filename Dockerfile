# Dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app/myapp

# Устанавливаем системные зависимости для psycopg2 и прочего
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

# Порт, который будет слушать Gunicorn
EXPOSE 8000

# Скрипт запуска Gunicorn (опционально – можно прописать в compose)
CMD ["gunicorn", "myapp.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]