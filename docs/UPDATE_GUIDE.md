# Solarman Statistic Add-on Update Guide

This guide explains how to update the add-on in Home Assistant to a new version.

## 🔄 Update Process

### 1. **Preparing New Version**

#### Automatic method (recommended):
```bash
# Create new release with automatic version update
make release VERSION=0.0.3

# This automatically:
# - Updates version in config.yaml
# - Generates changelog
# - Creates git commit and tag
```

#### Manual method:
```bash
# 1. Update version in config.yaml
sed -i '' 's/version: "0.0.2"/version: "0.0.3"/' solarman_statistic/config.yaml

# 2. Generate changelog
make changelog

# 3. Create commit
git add .
git commit -m "chore: bump version to 0.0.3"

# 4. Create tag
git tag -a v0.0.3 -m "Release version 0.0.3"
```

### 2. **Publishing Changes**

```bash
# Push changes to repository
git push origin main
git push origin v0.0.3
```

### 3. **Updating in Home Assistant**

#### For Users:

1. **Automatic update:**
   - Home Assistant will automatically check for updates
   - A notification will appear about available new version
   - Click "Update" in the add-on interface

2. **Manual update:**
   - Go to **Settings** → **Add-ons**
   - Find "Solarman Statistic"
   - Click **Update** if available

3. **Force update:**
   ```bash
   # In Home Assistant terminal
   ha addons update local_solarman_statistic
   ha addons restart local_solarman_statistic
   ```

#### For Developers:

1. **Check for updates:**
   ```bash
   # Check available updates
   ha addons update --all
   
   # Check specific add-on
   ha addons info local_solarman_statistic
   ```

2. **Update add-on:**
   ```bash
   # Update add-on
   ha addons update local_solarman_statistic
   
   # Restart add-on
   ha addons restart local_solarman_statistic
   
   # Or in one command
   ha addons update local_solarman_statistic && ha addons restart local_solarman_statistic
   ```

## 🔍 Update Verification

### 1. **Check Version in HA:**
- Go to **Settings** → **Add-ons** → **Solarman Statistic**
- Look at the version in the header

### 2. **Check via Terminal:**
```bash
# Add-on information
ha addons info local_solarman_statistic

# Add-on logs
ha addons logs local_solarman_statistic
```

### 3. **Check Web Interface:**
- Open the add-on web page
- Check version in the interface

## 🚨 Troubleshooting

### Add-on Won't Update:

1. **Check Repository:**
   ```bash
   # Check repository settings
   ha addons repositories list
   
   # Update repository
   ha addons repositories reload
   ```

2. **Force Update:**
   ```bash
   # Remove and reinstall
   ha addons uninstall local_solarman_statistic
   ha addons install local_solarman_statistic
   ```

3. **Check Logs:**
   ```bash
   # Home Assistant logs
   ha logs
   
   # Add-on logs
   ha addons logs local_solarman_statistic
   ```

### Web Interface Issues:

1. **Restart Add-on:**
   ```bash
   ha addons restart local_solarman_statistic
   ```

2. **Check Ports:**
   ```bash
   # Check if port 8099 is occupied
   netstat -tulpn | grep 8099
   ```

3. **Check Configuration:**
   - Check `config.yaml` file
   - Make sure port 8099 is open

## 📋 Update Checklist

### Before Update:
- [ ] Tested new version locally
- [ ] Updated version in `config.yaml`
- [ ] Generated changelog
- [ ] Created git tag
- [ ] Pushed changes to repository

### After Update:
- [ ] Verified version in Home Assistant
- [ ] Tested web interface
- [ ] Checked logs for errors
- [ ] Updated documentation if needed

## 🔧 Automation

### GitHub Actions:
When creating a tag automatically:
- Changelog is generated
- GitHub Release is created
- Documentation is updated

### Makefile Commands:
```bash
# Full update process
make release VERSION=0.0.3

# Only create tag
make tag VERSION=0.0.3

# Generate changelog
make changelog
```

## 📚 Useful Commands

```bash
# Check status
make status

# Current version
make version

# Clean temporary files
make clean

# Quick changelog
make quick-changelog
```

## 🆘 Support

If you have problems with updating:

1. Check logs: `ha addons logs local_solarman_statistic`
2. Restart add-on: `ha addons restart local_solarman_statistic`
3. Refer to documentation: [README.md](../README.md)
4. Create issue in repository 