# Гайд по оновленню Solarman Statistic Add-on

Цей гайд пояснює, як оновити add-on в Home Assistant до нової версії.

## 🔄 Процес оновлення

### 1. **Підготовка нової версії**

#### Автоматичний спосіб (рекомендований):
```bash
# Створити новий реліз з автоматичним оновленням версії
make release VERSION=0.0.3

# Це автоматично:
# - Оновить версію в config.yaml
# - Згенерує changelog
# - Створить git коміт та тег
```

#### Ручний спосіб:
```bash
# 1. Оновити версію в config.yaml
sed -i '' 's/version: "0.0.2"/version: "0.0.3"/' solarman_statistic/config.yaml

# 2. Згенерувати changelog
make changelog

# 3. Створити коміт
git add .
git commit -m "chore: bump version to 0.0.3"

# 4. Створити тег
git tag -a v0.0.3 -m "Release version 0.0.3"
```

### 2. **Публікація змін**

```bash
# Запушити зміни в репозиторій
git push origin main
git push origin v0.0.3
```

### 3. **Оновлення в Home Assistant**

#### Для користувачів:

1. **Автоматичне оновлення:**
   - Home Assistant автоматично перевірить оновлення
   - З'явиться повідомлення про доступну нову версію
   - Натисніть "Update" в інтерфейсі add-on

2. **Ручне оновлення:**
   - Перейдіть в **Settings** → **Add-ons**
   - Знайдіть "Solarman Statistic"
   - Натисніть **Update** якщо доступно

3. **Примусове оновлення:**
   ```bash
   # В терміналі Home Assistant
   ha addons update local_solarman_statistic
   ha addons restart local_solarman_statistic
   ```

#### Для розробників:

1. **Перевірка оновлення:**
   ```bash
   # Перевірити доступні оновлення
   ha addons update --all
   
   # Перевірити конкретний add-on
   ha addons info local_solarman_statistic
   ```

2. **Оновлення add-on:**
   ```bash
   # Оновити add-on
   ha addons update local_solarman_statistic
   
   # Перезапустити add-on
   ha addons restart local_solarman_statistic
   
   # Або одною командою
   ha addons update local_solarman_statistic && ha addons restart local_solarman_statistic
   ```

## 🔍 Перевірка оновлення

### 1. **Перевірка версії в HA:**
- Перейдіть в **Settings** → **Add-ons** → **Solarman Statistic**
- Подивіться на версію в заголовку

### 2. **Перевірка через термінал:**
```bash
# Інформація про add-on
ha addons info local_solarman_statistic

# Логи add-on
ha addons logs local_solarman_statistic
```

### 3. **Перевірка веб-інтерфейсу:**
- Відкрийте веб-сторінку add-on
- Перевірте версію в інтерфейсі

## 🚨 Вирішення проблем

### Add-on не оновлюється:

1. **Перевірте репозиторій:**
   ```bash
   # Перевірити налаштування репозиторію
   ha addons repositories list
   
   # Оновити репозиторій
   ha addons repositories reload
   ```

2. **Примусове оновлення:**
   ```bash
   # Видалити та перевстановити
   ha addons uninstall local_solarman_statistic
   ha addons install local_solarman_statistic
   ```

3. **Перевірка логів:**
   ```bash
   # Логи Home Assistant
   ha logs
   
   # Логи add-on
   ha addons logs local_solarman_statistic
   ```

### Проблеми з веб-інтерфейсом:

1. **Перезапуск add-on:**
   ```bash
   ha addons restart local_solarman_statistic
   ```

2. **Перевірка портів:**
   ```bash
   # Перевірити чи зайнятий порт 8099
   netstat -tulpn | grep 8099
   ```

3. **Перевірка конфігурації:**
   - Перевірте файл `config.yaml`
   - Переконайтеся, що порт 8099 відкритий

## 📋 Чек-лист оновлення

### Перед оновленням:
- [ ] Протестовано нову версію локально
- [ ] Оновлено версію в `config.yaml`
- [ ] Згенеровано changelog
- [ ] Створено git тег
- [ ] Запушено зміни в репозиторій

### Після оновлення:
- [ ] Перевірено версію в Home Assistant
- [ ] Протестовано веб-інтерфейс
- [ ] Перевірено логи на помилки
- [ ] Оновлено документацію якщо потрібно

## 🔧 Автоматизація

### GitHub Actions:
При створенні тегу автоматично:
- Генерується changelog
- Створюється GitHub Release
- Оновлюється документація

### Makefile команди:
```bash
# Повний процес оновлення
make release VERSION=0.0.3

# Тільки створення тегу
make tag VERSION=0.0.3

# Генерація changelog
make changelog
```

## 📚 Корисні команди

```bash
# Перевірка статусу
make status

# Поточна версія
make version

# Очищення тимчасових файлів
make clean

# Швидкий changelog
make quick-changelog
```

## 🆘 Підтримка

Якщо виникли проблеми з оновленням:

1. Перевірте логи: `ha addons logs local_solarman_statistic`
2. Перезапустіть add-on: `ha addons restart local_solarman_statistic`
3. Зверніться до документації: [README.md](../README.md)
4. Створіть issue в репозиторії 