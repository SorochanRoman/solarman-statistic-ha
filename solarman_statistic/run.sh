#!/usr/bin/with-contenv bashio

# Log startup
bashio::log.info "Starting Solarman Statistic Add-on"

# Main logic
echo "Solarman Statistic HA Add-on is running!"
echo "Current time: $(date)"

# Keep the add-on running
bashio::log.info "Add-on started successfully"
while true; do
    sleep 30
done