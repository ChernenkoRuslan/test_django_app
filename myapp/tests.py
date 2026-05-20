import pytest
from django.test import Client
from django.urls import reverse

# Самый простой тест — проверка, что приложение запускается и отвечает


def test_healthcheck():
    client = Client()
    response = client.get('/')
    # Главная страница пока не создана, может быть 404
    assert response.status_code in [200, 404]
