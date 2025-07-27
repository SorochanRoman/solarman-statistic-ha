# Docker Troubleshooting Guide

Цей гайд допоможе вирішити проблеми з Docker збіркою для Solarman Statistic Add-on.

## 🚨 Поширені помилки

### 1. **ERROR: failed to build: failed to solve: process "/bin/ash -o pipefail -c pip3 install --no-cache-dir -r requirements.txt" did not complete successfully: exit code: 1**

**Причина:** Відсутні системні залежності для компіляції Python пакетів в Alpine Linux.

**Рішення:**
```bash
# Використати скрипт для автоматичного виправлення
make fix-deps

# Або вручну оновити Dockerfile
```

### 2. **ModuleNotFoundError: No module named 'flask'**

**Причина:** Flask не встановився через проблеми з залежностями.

**Рішення:**
```bash
# Перевірити requirements.txt
cat solarman_statistic/requirements.txt

# Використати альтернативні версії
cp solarman_statistic/requirements-alpine.txt solarman_statistic/requirements.txt
```

### 3. **Permission denied при запуску контейнера**

**Причина:** Проблеми з правами доступу до файлів.

**Рішення:**
```bash
# Перевірити права на файли
ls -la solarman_statistic/

# Виправити права
chmod +x solarman_statistic/run.sh
```

## 🔧 Інструменти для вирішення проблем

### **Автоматичне виправлення:**
```bash
# Виправити всі залежності автоматично
make fix-deps

# Тестувати збірку локально
make test-build
```

### **Ручне виправлення:**

#### 1. **Оновити Dockerfile:**
```dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Install Python and required system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev

# Upgrade pip and install wheel
RUN pip3 install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir --prefer-binary -r requirements.txt

# Remove build dependencies to reduce image size
RUN apk del gcc musl-dev python3-dev libffi-dev openssl-dev

# Copy application files
COPY app.py /
COPY templates/ /templates/
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port for web interface
EXPOSE 8099

# Set the default command
CMD [ "/run.sh" ]
```

#### 2. **Оновити requirements.txt:**
```txt
# Minimal Flask requirements for Alpine Linux
Flask>=2.2.0,<3.0.0
Werkzeug>=2.2.0,<3.0.0

# Alternative: Use specific versions
# Flask==2.2.5
# Werkzeug==2.2.3
```

## 🧪 Тестування збірки

### **Локальне тестування:**
```bash
# Повний тест (збірка + запуск)
make test-build

# Тільки збірка
./scripts/test-build.sh --build-only

# Очищення Docker ресурсів
./scripts/test-build.sh --clean
```

### **Тестування в Home Assistant:**
```bash
# Перевірити логи add-on
ha addons logs local_solarman_statistic

# Перезапустити add-on
ha addons restart local_solarman_statistic

# Перевірити статус
ha addons info local_solarman_statistic
```

## 📋 Чек-лист вирішення проблем

### **Перед збіркою:**
- [ ] Перевірено версію Python (3.9+)
- [ ] Встановлено системні залежності
- [ ] Оновлено pip та setuptools
- [ ] Використано --prefer-binary флаг

### **Під час збірки:**
- [ ] Встановлено build dependencies
- [ ] Використано --no-cache-dir для pip
- [ ] Видалено build dependencies після встановлення
- [ ] Перевірено права на файли

### **Після збірки:**
- [ ] Протестовано контейнер локально
- [ ] Перевірено веб-інтерфейс
- [ ] Перевірено логи на помилки
- [ ] Протестовано в Home Assistant

## 🔍 Діагностика

### **Перевірка середовища:**
```bash
# Версія Docker
docker --version

# Версія Python в базовому образі
docker run --rm alpine:3.18 python3 --version

# Доступні пакети в Alpine
docker run --rm alpine:3.18 apk list | grep python
```

### **Перевірка залежностей:**
```bash
# Тестування встановлення Flask
docker run --rm alpine:3.18 sh -c "
apk add --no-cache python3 py3-pip gcc musl-dev python3-dev &&
pip3 install --upgrade pip setuptools wheel &&
pip3 install Flask==2.2.5
"
```

### **Перевірка конфігурації:**
```bash
# Валідація Dockerfile
docker build --dry-run -f solarman_statistic/Dockerfile solarman_statistic/

# Перевірка розміру образу
docker images solarman-statistic-test
```

## 🛠️ Альтернативні підходи

### **1. Multi-stage builds:**
```dockerfile
# Build stage
FROM alpine:3.18 AS builder
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev
RUN pip3 install --upgrade pip setuptools wheel
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r requirements.txt

# Runtime stage
FROM alpine:3.18
RUN apk add --no-cache python3
COPY --from=builder /usr/lib/python3.*/site-packages /usr/lib/python3.*/site-packages
COPY app.py templates/ run.sh /
RUN chmod +x /run.sh
EXPOSE 8099
CMD [ "/run.sh" ]
```

### **2. Використання pre-built wheels:**
```dockerfile
RUN pip3 install --no-cache-dir --prefer-binary --only-binary=all -r requirements.txt
```

### **3. Використання іншого базового образу:**
```dockerfile
FROM python:3.9-alpine
# Менше проблем з залежностями
```

## 📚 Корисні команди

```bash
# Швидке виправлення
make fix-deps

# Тестування
make test-build

# Очищення
make clean

# Перевірка версії
make version

# Оновлення add-on
make update-addon
```

## 🆘 Підтримка

Якщо проблеми залишаються:

1. **Перевірте логи:** `docker logs <container>`
2. **Використайте альтернативні версії:** `requirements-alpine.txt`
3. **Тестуйте локально:** `make test-build`
4. **Створіть issue** в репозиторії з деталями помилки

### **Корисні посилання:**
- [Alpine Linux Python Guide](https://wiki.alpinelinux.org/wiki/Python)
- [Docker Multi-stage Builds](https://docs.docker.com/develop/dev-best-practices/multistage-build/)
- [Flask Installation Guide](https://flask.palletsprojects.com/en/2.3.x/installation/) 