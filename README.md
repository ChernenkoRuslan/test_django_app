# 🚀 Django CI/CD Pipeline with Docker & GitHub Actions

[![CI](https://github.com/ChernenkoRuslan/test_django_app/actions/workflows/ci.yml/badge.svg)](https://github.com/ChernenkoRuslan/test_django_app/actions/workflows/ci.yml)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-public-blue)](https://hub.docker.com/r/chernenkoruslan/myapp)

Это учебный проект, демонстрирующий построение современного конвейера непрерывной интеграции и доставки (CI/CD) для Django-приложения.  
Цель: автоматизировать тестирование, сборку Docker-образа и деплой на VPS-сервер при каждом пуше в ветку `main`.

> **Статус:** полностью рабочий пайплайн, приложение доступно по IP-адресу, обновляется по `git push`.

---

## 🧱 Стек технологий

| Компонент         | Инструменты                          |
| ----------------- | ------------------------------------ |
| Язык / Фреймворк  | Python 3.11, Django 4.2              |
| База данных       | PostgreSQL 15 (продакшен), SQLite (локально) |
| Контейнеризация   | Docker, Docker Compose               |
| CI/CD             | GitHub Actions                       |
| Веб-сервер        | Nginx (reverse proxy)                |
| WSGI-сервер       | Gunicorn                             |
| Хостинг           | VPS (Ubuntu 22.04)                   |
| Мониторинг образа | Docker Hub (публичный репозиторий)   |

---

## 🔁 Как работает CI/CD

1. **Разработчик** вносит изменения в код и пушит в `main`.
2. **GitHub Actions** запускает workflow:
   - **Тестирование**: линтеры (`flake8`), unit-тесты (`pytest`) с временной PostgreSQL.
   - **Сборка**: создаётся Docker-образ приложения.
   - **Пуш образа**: образ отправляется в публичный Docker Hub.
   - **Деплой на VPS**: через SSH выполняется скачивание нового образа, перезапуск контейнеров, миграция БД и сбор статики.
3. **VPS** обновляется автоматически – без ручного вмешательства.

---

## 📁 Структура проекта
.
├── .github/
│ └── workflows/
│ └── ci.yml # Конфигурация GitHub Actions
├── myapp/ # Django проект
│ ├── settings.py
│ ├── ...
├── Dockerfile # Инструкция сборки образа
├── docker-compose.yml # Локальное окружение
├── docker-compose.prod.yml # Продакшен-окружение (только на VPS)
├── requirements.txt
├── pytest.ini
├── tests.py # Тесты
└── .env.example # Пример переменных окружения (не коммитить!)

---

## 🛠 Локальная разработка

### Предварительные требования
- Docker и Docker Compose
- Git

### Запуск
1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/ChernenkoRuslan/test_django_app.git
   cd test_django_app

Создайте файл .env на основе .env.example и задайте секреты.

2. Запустите сервисы:

   ```bash
   docker compose up -d
3. Выполните миграции:

   ```bash
   docker compose exec app python manage.py migrate
Приложение будет доступно по адресу http://localhost:8000.

4. Запуск тестов

   ```bash
   docker compose exec app pytest

Приложение будет доступно по адресу http://localhost:8000.

---
## 🚢 Продакшен-деплой
На VPS (Ubuntu 22.04) используются:

- /opt/myapp/docker-compose.prod.yml – конфигурация сервисов
- /opt/myapp/.env – переменные окружения (секреты)
- /opt/myapp/nginx.conf – конфигурация Nginx

### Автоматический деплой
При пуше в main GitHub Actions автоматически обновляет контейнеры на VPS.
Требуются секреты репозитория:

- DOCKER_USERNAME, DOCKER_PASSWORD (Docker Hub)
- SSH_HOST, SSH_USERNAME, SSH_KEY, SSH_PORT (доступ к VPS)

Все чувствительные данные хранятся в переменных окружения и не попадают в образ.

---
## 🔒 Безопасность
- Файл .env не включён в образ (добавлен в .dockerignore).
- Секреты передаются через GitHub Secrets.
- Для учебных целей Docker-образ публичный, но код не содержит реальных паролей.
- Для реального проекта образ и репозиторий должны быть приватными.
- На VPS открыты только порты 80 (HTTP) и 22 (SSH).

---
## ✅ Что улучшить в будущем
- Подключить HTTPS через Let's Encrypt (Caddy или Certbot)
- Добавить healthcheck-и для контейнеров
- Настроить мониторинг и бэкапы БД
- Внедрить откат (rollback) с использованием уникальных тегов образов
- Перейти на частный Docker-репозиторий

---
## 👨‍💻 Автор
[ChernenkoRuslan](https://github.com/ChernenkoRuslan) – проект создан в рамках освоения CI/CD для Django.

---
## 📄 Лицензия
MIT