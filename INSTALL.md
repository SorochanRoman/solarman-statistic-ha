# Installation Instructions

## Installation in Home Assistant

### Step 1: Adding Repository

1. Open Home Assistant
2. Go to **Settings** → **Add-ons** → **Add-on Store**
3. Click on the three dots (⋮) in the top right corner
4. Select **Repositories**
5. Add your repository URL:
   ```
   https://github.com/SorochanRoman/solarman-statistic-ha
   ```
   or for local testing:
   ```
   /config/addons/local/solarman-statistic-ha
   ```

### Step 2: Installing the Add-on

1. Return to **Add-on Store**
2. Find "Solarman Statistic" in the list
3. Click on the add-on
4. Click **Install**

### Step 3: Starting

1. After installation, click **Start**
2. Check the logs to confirm successful startup

## Local Testing

### Option 1: Through SSH Add-on

1. Install SSH & Web Terminal add-on
2. Connect to Home Assistant via SSH
3. Copy files to `/config/addons/local/solarman-statistic-ha/`
4. Restart Home Assistant

### Option 2: Through Samba Add-on

1. Install Samba share add-on
2. Connect to Home Assistant via network
3. Copy files to `/config/addons/local/solarman-statistic-ha/`
4. Restart Home Assistant

## File Structure

```
solarman-statistic-ha/
├── Dockerfile
├── run.sh
├── config.yaml
├── build.yaml
├── README.md
└── .gitignore
```

## Troubleshooting

### Error "not a valid add-on repository"

1. Check that all required files are present
2. Make sure `config.yaml` has the correct format
3. Check file permissions

### Add-on won't start

1. Check the add-on logs
2. Make sure `run.sh` has execution permissions
3. Check that the Dockerfile is correct

## Support

If you encounter problems, create an issue in the repository with a detailed description of the problem. 