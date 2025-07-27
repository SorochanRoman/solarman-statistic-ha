# Changelog Generation Guide

Цей гайд пояснює, як генерувати changelog для проекту Solarman Statistic HA Add-on.

## 📋 Що таке Changelog?

Changelog - це документ, який записує всі важливі зміни в проекті для кожної версії. Він допомагає користувачам та розробникам розуміти, що змінилося між версіями.

## 🛠️ Способи генерації

### 1. Автоматичний changelog (рекомендований)

```bash
# Запустити повний генератор
./scripts/generate-changelog.sh
```

**Особливості:**
- Автоматично категорує коміти за типами
- Підтримує conventional commits
- Створює красиве форматування з емодзі
- Зберігає історію версій

### 2. Швидкий changelog

```bash
# Простий список комітів
./scripts/quick-changelog.sh

# З вказаною версією та датою
./scripts/quick-changelog.sh 0.0.3 2024-01-16
```

### 3. Ручне створення

```bash
# Подивитися коміти
git log --oneline

# Подивитися зміни між тегами
git log --oneline v0.0.1..v0.0.2

# Подивитися зміни в файлах
git diff v0.0.1..v0.0.2
```

## 📝 Conventional Commits

Для кращої автоматизації використовуйте conventional commits:

```bash
# Типи комітів
feat:     # Нова функція
fix:      # Виправлення багу
docs:     # Документація
style:    # Форматування коду
refactor: # Рефакторинг
test:     # Тести
chore:    # Обслуговування

# Приклади
git commit -m "feat: add user profile page"
git commit -m "fix: resolve Flask import error"
git commit -m "docs: update installation guide"
git commit -m "style: improve UI design"
```

## 🏷️ Робота з тегами

### Створення тегу для версії

```bash
# Створити тег
git tag v0.0.2

# Створити тег з повідомленням
git tag -a v0.0.2 -m "Release version 0.0.2"

# Запушити тег
git push origin v0.0.2
```

### Перегляд тегів

```bash
# Список всіх тегів
git tag -l

# Детальна інформація про тег
git show v0.0.2
```

## 📊 Структура Changelog

```markdown
# Changelog

## [Unreleased]
- Майбутні зміни

## [0.0.2] - 2024-01-15

### Added
- ✨ Нові функції

### Changed
- ♻️ Зміни в існуючому функціоналі

### Fixed
- 🐛 Виправлення багів

### Removed
- 🗑️ Видалені функції
```

## 🔄 Процес оновлення

1. **Підготувати зміни:**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

2. **Оновити версію:**
   ```bash
   # В solarman_statistic/config.yaml
   version: "0.0.3"
   ```

3. **Згенерувати changelog:**
   ```bash
   ./scripts/generate-changelog.sh
   ```

4. **Створити тег:**
   ```bash
   git tag -a v0.0.3 -m "Release version 0.0.3"
   git push origin v0.0.3
   ```

## 🎯 Best Practices

### ✅ Рекомендовано
- Використовувати conventional commits
- Регулярно оновлювати changelog
- Додавати детальні описи змін
- Використовувати емодзі для кращої читабельності
- Групувати зміни за категоріями

### ❌ Не рекомендується
- Ігнорувати changelog
- Додавати технічні деталі без пояснень
- Використовувати загальні описи
- Забувати про версіонування

## 🛠️ Інструменти

### Автоматичні генератори
- **conventional-changelog**: npm пакет для автоматичної генерації
- **git-changelog**: Python інструмент
- **github-changelog-generator**: Ruby гем

### Ручні інструменти
- **GitHub Releases**: веб-інтерфейс для створення релізів
- **GitLab Releases**: аналогічний функціонал в GitLab

## 📚 Корисні посилання

- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases) 