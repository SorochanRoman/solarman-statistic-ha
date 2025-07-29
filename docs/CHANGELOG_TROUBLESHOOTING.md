# Changelog Troubleshooting Guide

This guide will help you resolve changelog issues in Home Assistant add-ons.

## 🚨 Common Errors

### 1. **"No changelog found for add-on"**

**Cause:** Home Assistant cannot find changelog for the add-on.

**Solution:**
```bash
# Add changelog to config.yaml
make update-changelog

# Or manually add to config.yaml
changelog: "Add user profile page with system information display"
```

### 2. **"Changelog is empty or invalid"**

**Cause:** Changelog has incorrect format or is empty.

**Solution:**
```bash
# Update changelog from git commits
./scripts/update-changelog.sh --git

# Or create manually
echo 'changelog: "Add new features and improvements"' >> solarman_statistic/config.yaml
```

### 3. **"Changelog not showing in Home Assistant"**

**Cause:** Home Assistant doesn't update add-on information.

**Solution:**
```bash
# Update repository in HA
ha addons repositories reload

# Restart add-on
ha addons restart local_solarman_statistic
```

## 🔧 Troubleshooting Tools

### **Automatic Fix:**
```bash
# Update changelog automatically
make update-changelog

# Show current changelog
./scripts/update-changelog.sh --show

# Create changelog from git commits
./scripts/update-changelog.sh --git
```

### **Manual Fix:**

#### 1. **Add changelog to config.yaml:**
```yaml
name: "Solarman Statistic"
description: "Add-on for Solarman statistics with user profile page"
version: "0.0.5"
slug: "solarman_statistic"
url: "https://github.com/SorochanRoman/solarman-statistic-ha"
changelog: "Add user profile page with system information display"
```

#### 2. **Create CHANGELOG.md file:**
```markdown
# Changelog for Solarman Statistic Add-on

## [0.0.5] - 2024-01-15

### Added
- ✨ **User Profile Page**: Beautiful web interface with system information
- ✨ **Flask Web Application**: Modern web server with REST API
- ✨ **Real-time Updates**: Auto-refresh system information every 30 seconds

### Changed
- ♻️ **Enhanced Configuration**: Updated add-on config for web panel support
- ♻️ **Improved Dockerfile**: Optimized for Alpine Linux with proper dependencies
```

## 📋 Структура changelog

### **В config.yaml:**
```yaml
changelog: "Add user profile page with system information display"
```

### **В CHANGELOG.md:**
```markdown
# Changelog for Solarman Statistic Add-on

## [0.0.5] - 2024-01-15

### Added
- ✨ New features

### Changed
- ♻️ Changes in existing functionality

### Fixed
- 🐛 Bug fixes

### Removed
- 🗑️ Removed features
```

## 🧪 Тестування changelog

### **Перевірка в config.yaml:**
```bash
# Показати поточний changelog
./scripts/update-changelog.sh --show

# Перевірити версію
./scripts/update-changelog.sh --version
```

### **Перевірка в Home Assistant:**
```bash
# Перевірити інформацію про add-on
ha addons info local_solarman_statistic

# Перезапустити add-on
ha addons restart local_solarman_statistic

# Оновити репозиторій
ha addons repositories reload
```

## 📋 Чек-лист вирішення проблем

### **Перед оновленням:**
- [ ] Перевірено версію в config.yaml
- [ ] Додано changelog до config.yaml
- [ ] Створено CHANGELOG.md файл
- [ ] Запушено зміни в репозиторій

### **Під час оновлення:**
- [ ] Оновлено репозиторій в Home Assistant
- [ ] Перезапущено add-on
- [ ] Перевірено відображення changelog

### **Після оновлення:**
- [ ] Перевірено changelog в інтерфейсі HA
- [ ] Протестовано функціональність add-on
- [ ] Перевірено логи на помилки

## 🔍 Діагностика

### **Перевірка config.yaml:**
```bash
# Перевірити наявність changelog
grep "changelog:" solarman_statistic/config.yaml

# Перевірити версію
grep "version:" solarman_statistic/config.yaml
```

### **Перевірка CHANGELOG.md:**
```bash
# Перевірити наявність файлу
ls -la solarman_statistic/CHANGELOG.md

# Показати вміст
cat solarman_statistic/CHANGELOG.md
```

### **Перевірка в Home Assistant:**
```bash
# Інформація про add-on
ha addons info local_solarman_statistic

# Логи add-on
ha addons logs local_solarman_statistic

# Статус репозиторіїв
ha addons repositories list
```

## 🛠️ Альтернативні підходи

### **1. Автоматичне оновлення changelog:**
```bash
# При кожному релізі
make release VERSION=0.0.6

# Це автоматично:
# - Оновить версію
# - Згенерує changelog
# - Оновить config.yaml
```

### **2. Ручне оновлення:**
```bash
# Оновити версію
sed -i '' 's/version: "0.0.5"/version: "0.0.6"/' solarman_statistic/config.yaml

# Оновити changelog
./scripts/update-changelog.sh

# Створити коміт та тег
git add .
git commit -m "chore: bump version to 0.0.6"
git tag -a v0.0.6 -m "Release version 0.0.6"
```

### **3. Використання GitHub Actions:**
```yaml
# Автоматичне оновлення changelog при створенні тегу
- name: Update Changelog
  run: |
    ./scripts/update-changelog.sh
    git add .
    git commit -m "docs: update changelog"
```

## 📚 Корисні команди

```bash
# Швидке виправлення
make update-changelog

# Тестування
./scripts/update-changelog.sh --show

# Очищення
make clean

# Перевірка версії
make version

# Оновлення add-on
make update-addon
```

## 🆘 Підтримка

Якщо проблеми залишаються:

1. **Перевірте config.yaml:** `grep "changelog:" solarman_statistic/config.yaml`
2. **Перевірте CHANGELOG.md:** `cat solarman_statistic/CHANGELOG.md`
3. **Оновіть репозиторій:** `ha addons repositories reload`
4. **Створіть issue** в репозиторії з деталями помилки

### **Корисні посилання:**
- [Home Assistant Add-on Development](https://developers.home-assistant.io/docs/add-ons/)
- [Add-on Configuration](https://developers.home-assistant.io/docs/add-ons/configuration/)
- [Changelog Format](https://keepachangelog.com/) 