#!/usr/bin/env python3
"""
Solarman Statistic HA Add-on Web Application
"""

import os
import json
import subprocess
import logging
import requests
from datetime import datetime
from flask import Flask, render_template, jsonify, request

# Налаштування логування
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

def get_ha_api_url():
    """Get Home Assistant API URL"""
    # В додатку Home Assistant API доступний через локальний хост
    return "http://supervisor/core/api"

def get_ha_token():
    """Get Home Assistant API token"""
    # Токен доступний через змінну середовища в додатку
    return os.environ.get('SUPERVISOR_TOKEN')

def get_entity_data(entity_id):
    """Get data from Home Assistant entity"""
    try:
        token = get_ha_token()
        api_url = get_ha_api_url()
        
        if not token:
            logger.error("No API token available")
            return None
            
        headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }
        
        # Отримуємо стан сутності
        response = requests.get(f'{api_url}/states/{entity_id}', headers=headers)
        
        if response.status_code == 200:
            return response.json()
        else:
            logger.error(f"Failed to get entity {entity_id}: {response.status_code}")
            return None
            
    except Exception as e:
        logger.error(f"Error getting entity data: {e}")
        return None

def get_all_entities():
    """Get all entities from Home Assistant"""
    try:
        token = get_ha_token()
        api_url = get_ha_api_url()
        
        if not token:
            logger.error("No API token available")
            return []
            
        headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }
        
        response = requests.get(f'{api_url}/states', headers=headers)
        
        if response.status_code == 200:
            return response.json()
        else:
            logger.error(f"Failed to get entities: {response.status_code}")
            return []
            
    except Exception as e:
        logger.error(f"Error getting all entities: {e}")
        return []

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

@app.route('/api/entity/<entity_id>')
def get_entity(entity_id):
    """Get specific entity data"""
    logger.info(f"Entity data requested for: {entity_id}")
    data = get_entity_data(entity_id)
    
    if data:
        return jsonify(data)
    else:
        return jsonify({'error': 'Entity not found or access denied'}), 404

@app.route('/api/entities')
def get_entities():
    """Get all entities"""
    logger.info("All entities requested")
    entities = get_all_entities()
    
    # Фільтруємо тільки активні сутності
    active_entities = [entity for entity in entities if entity.get('state') != 'unavailable']
    
    return jsonify({
        'total': len(entities),
        'active': len(active_entities),
        'entities': active_entities[:50]  # Обмежуємо до 50 для продуктивності
    })

@app.route('/api/entities/search')
def search_entities():
    """Search entities by domain or name"""
    query = request.args.get('q', '').lower()
    domain = request.args.get('domain', '').lower()
    
    logger.info(f"Search entities: query={query}, domain={domain}")
    
    entities = get_all_entities()
    results = []
    
    for entity in entities:
        entity_id = entity.get('entity_id', '').lower()
        friendly_name = entity.get('attributes', {}).get('friendly_name', '').lower()
        
        # Фільтруємо за доменом
        if domain and not entity_id.startswith(domain):
            continue
            
        # Фільтруємо за пошуковим запитом
        if query and query not in entity_id and query not in friendly_name:
            continue
            
        results.append(entity)
    
    return jsonify({
        'query': query,
        'domain': domain,
        'count': len(results),
        'entities': results[:20]  # Обмежуємо результати
    })

@app.route('/api/health')
def health():
    """Health check endpoint"""
    logger.info("Health check requested")
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

if __name__ == '__main__':
    logger.info("Starting Solarman Statistic Web Application")
    app.run(host='0.0.0.0', port=8099, debug=False) 