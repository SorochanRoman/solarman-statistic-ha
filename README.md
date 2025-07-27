# Solarman Statistic HA Add-on

[![Install on my Home Assistant][install-badge]][install-url]

[install-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[install-url]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=local_solarman_statistic

## Description

This Home Assistant add-on allows you to retrieve and analyze statistics from Solarman devices.

## Installation

### Method 1: Add Repository (Recommended)

1. Add this repository to your Home Assistant:
   - Go to **Settings** → **Add-ons** → **Add-on Store**
   - Click on the three dots in the top right corner
   - Select **Repositories**
   - Add the URL: `https://github.com/SorochanRoman/solarman-statistic-ha`

2. Find "Solarman Statistic" in the add-ons list

3. Click **Install**

### Method 2: Local Installation

1. Copy the `solarman_statistic` folder to your Home Assistant:
   ```
   /config/addons/local/solarman_statistic/
   ```

2. Restart Home Assistant

3. Find "Solarman Statistic" in the Local Add-ons section

## Usage

1. After installation, click **Start**
2. The add-on will be running and ready to work
3. Check the logs for additional information

## Repository Structure

```
solarman-statistic-ha/
├── repository.yaml           # Repository configuration
├── solarman_statistic/       # Add-on folder
│   ├── config.yaml          # Add-on configuration
│   ├── Dockerfile           # Docker image
│   └── run.sh              # Startup script
├── README.md               # This file
└── INSTALL.md              # Detailed installation guide
```

## Supported Architectures

- aarch64
- amd64
- armhf
- armv7
- i386

## License

MIT License 