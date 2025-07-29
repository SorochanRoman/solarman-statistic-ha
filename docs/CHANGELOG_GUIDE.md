# Changelog Generation Guide

This guide explains how to generate changelog for the Solarman Statistic HA Add-on project.

## 📋 What is Changelog?

Changelog is a document that records all important changes in the project for each version. It helps users and developers understand what has changed between versions.

## 🛠️ Generation Methods

### 1. Automatic changelog (recommended)

```bash
# Run full generator
./scripts/generate-changelog.sh
```

**Features:**
- Automatically categorizes commits by type
- Supports conventional commits
- Creates beautiful formatting with emojis
- Preserves version history

### 2. Quick changelog

```bash
# Simple commit list
./scripts/quick-changelog.sh

# With specified version and date
./scripts/quick-changelog.sh 0.0.3 2024-01-16
```

### 3. Manual creation

```bash
# View commits
git log --oneline

# View changes between tags
git log --oneline v0.0.1..v0.0.2

# View changes in files
git diff v0.0.1..v0.0.2
```

## 📝 Conventional Commits

For better automation, use conventional commits:

```bash
# Commit types
feat:     # New feature
fix:      # Bug fix
docs:     # Documentation
style:    # Code formatting
refactor: # Refactoring
test:     # Tests
chore:    # Maintenance

# Examples
git commit -m "feat: add user profile page"
git commit -m "fix: resolve Flask import error"
git commit -m "docs: update installation guide"
git commit -m "style: improve UI design"
```

## 🏷️ Working with Tags

### Creating a tag for version

```bash
# Create tag
git tag v0.0.2

# Create tag with message
git tag -a v0.0.2 -m "Release version 0.0.2"

# Push tag
git push origin v0.0.2
```

### Viewing tags

```bash
# List all tags
git tag -l

# Detailed tag information
git show v0.0.2
```

## 📊 Changelog Structure

```markdown
# Changelog

## [Unreleased]
- Future changes

## [0.0.2] - 2024-01-15

### Added
- ✨ New features

### Changed
- ♻️ Changes in existing functionality

### Fixed
- 🐛 Bug fixes

### Removed
- 🗑️ Removed features
```

## 🔄 Update Process

1. **Prepare changes:**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

2. **Update version:**
   ```bash
   # In solarman_statistic/config.yaml
   version: "0.0.3"
   ```

3. **Generate changelog:**
   ```bash
   ./scripts/generate-changelog.sh
   ```

4. **Create tag:**
   ```bash
   git tag -a v0.0.3 -m "Release version 0.0.3"
   git push origin v0.0.3
   ```

## 🎯 Best Practices

### ✅ Recommended
- Use conventional commits
- Regularly update changelog
- Add detailed change descriptions
- Use emojis for better readability
- Group changes by categories

### ❌ Not recommended
- Ignore changelog
- Add technical details without explanations
- Use generic descriptions
- Forget about versioning

## 🛠️ Tools

### Automatic generators
- **conventional-changelog**: npm package for automatic generation
- **git-changelog**: Python tool
- **github-changelog-generator**: Ruby gem

### Manual tools
- **GitHub Releases**: web interface for creating releases
- **GitLab Releases**: similar functionality in GitLab

## 📚 Useful Links

- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases) 