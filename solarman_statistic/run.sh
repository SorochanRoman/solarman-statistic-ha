#!/usr/bin/with-contenv bashio

# Log startup
bashio::log.info "Starting Solarman Statistic Add-on"

# Start Flask application
bashio::log.info "Starting Flask web application"
python3 /app.py &

# Keep the add-on running
bashio::log.info "Add-on started successfully"
while true; do
    sleep 30
done