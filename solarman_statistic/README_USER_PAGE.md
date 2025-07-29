# User Information Page

## Description

Added new functionality to Solarman Statistic add-on - a web page with basic user and system information.

## Features

### System Information
- **Host**: computer/server name
- **Operating System**: OS information
- **Uptime**: how many hours the system has been running
- **Current Time**: actual server time

### Home Assistant Information
- **HA Version**: Home Assistant version
- **Add-on Name**: Solarman Statistic
- **Add-on Version**: current version
- **Status**: whether the add-on is running

## Access

After installing and starting the add-on, the page will be available through:

1. **Home Assistant Panel**: find "Solarman Statistic" in the add-ons list
2. **Direct Access**: `http://your-ha-ip:8099`

## API Endpoints

### GET /api/user-info
Returns JSON with user and system information.

**Response example:**
```json
{
  "system": {
    "hostname": "homeassistant",
    "os_name": "Home Assistant OS 10.5",
    "uptime_hours": 72.5,
    "current_time": "2024-01-15 14:30:25"
  },
  "home_assistant": {
    "ha_version": "2024.1.0",
    "addon_info": {
      "name": "Solarman Statistic",
      "version": "0.0.2",
      "slug": "solarman_statistic"
    }
  },
  "addon_status": "running",
  "last_updated": "2024-01-15T14:30:25.123456"
}
```

### GET /api/health
Health check endpoint for monitoring.

**Response example:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T14:30:25.123456"
}
```

## Features

- **Auto-refresh**: information updates every 30 seconds
- **Responsive Design**: works on mobile devices
- **Modern UI**: gradients and animations
- **English Localization**: interface in English language

## Technical Details

- **Web Server**: Flask (Python)
- **Port**: 8099
- **Languages**: HTML, CSS, JavaScript
- **Styles**: CSS Grid, Flexbox, gradients

## Development

To add new features:

1. Update `app.py` for new API endpoints
2. Modify `templates/index.html` for UI changes
3. Update version in `config.yaml`
4. Rebuild Docker image

## Logging

All errors and important events are logged through:
- Flask application logs
- Home Assistant add-on logs
- System logs (via bashio) 