#!/usr/bin/env bash
set -e

echo "Оновлення списку пакетів..."
sudo apt-get update -y

# 1. Docker
if command -v docker &> /dev/null; then
    echo "Docker вже встановлено: $(docker --version)"
else
    echo "Встановлення Docker..."
    sudo apt-get install -y docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
fi

# 2. Docker Compose
if docker compose version &> /dev/null || command -v docker-compose &> /dev/null; then
    echo "Docker Compose вже встановлено."
else
    echo "Встановлення Docker Compose..."
    sudo apt-get install -y docker-compose-plugin || sudo apt-get install -y docker-compose
fi

# 3. Python 3.9+
if command -v python3 &> /dev/null && python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)'; then
    echo "Python вже встановлено: $(python3 --version)"
else
    echo "Встановлення Python 3.9+..."
    sudo apt-get install -y python3 python3-pip
fi

# Перевірка pip окремо (на випадок, якщо Python вже був, а pip — ні)
if ! command -v pip3 &> /dev/null; then
    echo "Встановлення pip..."
    sudo apt-get install -y python3-pip
fi

# 4. Django через pip
if python3 -m django --version &> /dev/null; then
    echo "Django вже встановлено: $(python3 -m django --version)"
else
    echo "Встановлення Django через pip..."
    pip3 install --break-system-packages django || pip3 install django
fi

echo "Усі інструменти перевірено та встановлено!"