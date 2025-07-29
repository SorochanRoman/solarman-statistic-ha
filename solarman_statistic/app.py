#!/usr/bin/env python3
"""
Solarman Statistic HA Add-on Web Application
"""

import os
import json
import subprocess
import logging
from datetime import datetime
from flask import Flask, render_template, jsonify, request

# Налаштування логування
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

def get_system_info():
    """Get basic system information"""
    try:
        # Get hostname
        hostname = subprocess.check_output(['hostname'], text=True).strip()
        
        # Get OS info
        with open('/etc/os-release', 'r') as f:
            os_info = {}
            for line in f:
                if '=' in line:
                    key, value = line.strip().split('=', 1)
                    os_info[key] = value.strip('"')
        
        # Get uptime
        uptime_seconds = float(subprocess.check_output(['cat', '/proc/uptime'], text=True).split()[0])
        uptime_hours = uptime_seconds / 3600
        
        return {
            'hostname': hostname,
            'os_name': os_info.get('PRETTY_NAME', 'Unknown'),
            'uptime_hours': round(uptime_hours, 2),
            'current_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
    except Exception as e:
        logger.error(f"Error getting system info: {e}")
        return {
            'hostname': 'Unknown',
            'os_name': 'Unknown',
            'uptime_hours': 0,
            'current_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }

def get_home_assistant_info():
    """Get Home Assistant related information"""
    try:
        # Get HA version from environment
        ha_version = os.environ.get('SUPERVISOR_VERSION', 'Unknown')
        
        # Get add-on info
        addon_info = {
            'name': 'Solarman Statistic',
            'version': '0.0.2',
            'slug': 'solarman_statistic'
        }
        
        return {
            'ha_version': ha_version,
            'addon_info': addon_info
        }
    except Exception as e:
        logger.error(f"Error getting HA info: {e}")
        return {
            'ha_version': 'Unknown',
            'addon_info': {
                'name': 'Solarman Statistic',
                'version': '0.0.2',
                'slug': 'solarman_statistic'
            }
        }

@app.route('/')
def index():
    """Main page with user information"""
    logger.info("Main page requested")
    return render_template('index.html')

@app.route('/api/user-info')
def user_info():
    """API endpoint for user information"""
    logger.info("User info API requested")
    system_info = get_system_info()
    ha_info = get_home_assistant_info()
    
    user_info = {
        'system': system_info,
        'home_assistant': ha_info,
        'addon_status': 'running',
        'last_updated': datetime.now().isoformat()
    }
    
    return jsonify(user_info)

@app.route('/api/health')
def health():
    """Health check endpoint"""
    logger.info("Health check requested")
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

if __name__ == '__main__':
    logger.info("Starting Solarman Statistic Web Application")
    app.run(host='0.0.0.0', port=8099, debug=False) 