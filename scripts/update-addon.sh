#!/bin/bash

# Update Solarman Statistic Add-on script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ADDON_NAME="local_solarman_statistic"
REPO_URL="https://github.com/SorochanRoman/solarman-statistic-ha"

echo -e "${BLUE}🔄 Solarman Statistic Add-on Update Script${NC}"
echo ""

# Function to check if ha command is available
check_ha_cli() {
    if ! command -v ha &> /dev/null; then
        echo -e "${RED}❌ Home Assistant CLI (ha) not found!${NC}"
        echo -e "${YELLOW}Please install Home Assistant CLI first:${NC}"
        echo "pip3 install homeassistant-cli"
        exit 1
    fi
}

# Function to check add-on status
check_addon_status() {
    echo -e "${BLUE}📊 Checking add-on status...${NC}"
    
    if ha addons info $ADDON_NAME &> /dev/null; then
        echo -e "${GREEN}✅ Add-on is installed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ Add-on is not installed${NC}"
        return 1
    fi
}

# Function to update add-on
update_addon() {
    echo -e "${BLUE}🔄 Updating add-on...${NC}"
    
    # Update add-on
    if ha addons update $ADDON_NAME; then
        echo -e "${GREEN}✅ Add-on updated successfully${NC}"
    else
        echo -e "${RED}❌ Failed to update add-on${NC}"
        return 1
    fi
    
    # Restart add-on
    echo -e "${BLUE}🔄 Restarting add-on...${NC}"
    if ha addons restart $ADDON_NAME; then
        echo -e "${GREEN}✅ Add-on restarted successfully${NC}"
    else
        echo -e "${RED}❌ Failed to restart add-on${NC}"
        return 1
    fi
}

# Function to install add-on
install_addon() {
    echo -e "${BLUE}📦 Installing add-on...${NC}"
    
    # Check if repository is added
    if ! ha addons repositories list | grep -q "$REPO_URL"; then
        echo -e "${YELLOW}⚠️ Repository not found, adding...${NC}"
        ha addons repositories add "$REPO_URL"
    fi
    
    # Install add-on
    if ha addons install $ADDON_NAME; then
        echo -e "${GREEN}✅ Add-on installed successfully${NC}"
    else
        echo -e "${RED}❌ Failed to install add-on${NC}"
        return 1
    fi
    
    # Start add-on
    echo -e "${BLUE}🔄 Starting add-on...${NC}"
    if ha addons start $ADDON_NAME; then
        echo -e "${GREEN}✅ Add-on started successfully${NC}"
    else
        echo -e "${RED}❌ Failed to start add-on${NC}"
        return 1
    fi
}

# Function to show add-on info
show_info() {
    echo -e "${BLUE}📋 Add-on information:${NC}"
    ha addons info $ADDON_NAME
}

# Function to show logs
show_logs() {
    echo -e "${BLUE}📋 Recent logs:${NC}"
    ha addons logs $ADDON_NAME --tail 20
}

# Function to open web interface
open_web() {
    echo -e "${BLUE}🌐 Opening web interface...${NC}"
    
    # Get HA URL
    HA_URL=$(ha info | grep "URL:" | awk '{print $2}')
    if [ -z "$HA_URL" ]; then
        echo -e "${YELLOW}⚠️ Could not determine HA URL${NC}"
        echo -e "${YELLOW}Please open manually: http://your-ha-ip:8099${NC}"
    else
        ADDON_URL="${HA_URL}:8099"
        echo -e "${GREEN}✅ Opening: $ADDON_URL${NC}"
        
        # Try to open in browser
        if command -v open &> /dev/null; then
            open "$ADDON_URL"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "$ADDON_URL"
        else
            echo -e "${YELLOW}⚠️ Please open manually: $ADDON_URL${NC}"
        fi
    fi
}

# Main script
main() {
    check_ha_cli
    
    echo -e "${BLUE}🔍 Checking Home Assistant status...${NC}"
    if ! ha info &> /dev/null; then
        echo -e "${RED}❌ Cannot connect to Home Assistant${NC}"
        echo -e "${YELLOW}Make sure Home Assistant is running and accessible${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Connected to Home Assistant${NC}"
    echo ""
    
    # Check if add-on is installed
    if check_addon_status; then
        # Add-on is installed, update it
        update_addon
    else
        # Add-on is not installed, install it
        install_addon
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Operation completed successfully!${NC}"
    echo ""
    
    # Show options
    echo -e "${BLUE}Available actions:${NC}"
    echo "1. Show add-on info"
    echo "2. Show logs"
    echo "3. Open web interface"
    echo "4. Exit"
    echo ""
    
    read -p "Choose action (1-4): " choice
    
    case $choice in
        1)
            show_info
            ;;
        2)
            show_logs
            ;;
        3)
            open_web
            ;;
        4)
            echo -e "${GREEN}👋 Goodbye!${NC}"
            ;;
        *)
            echo -e "${YELLOW}⚠️ Invalid choice${NC}"
            ;;
    esac
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --info         Show add-on information"
        echo "  --logs         Show add-on logs"
        echo "  --web          Open web interface"
        echo "  --update       Force update add-on"
        echo ""
        echo "Examples:"
        echo "  $0              # Interactive mode"
        echo "  $0 --info       # Show add-on info"
        echo "  $0 --logs       # Show logs"
        echo "  $0 --web        # Open web interface"
        ;;
    --info)
        check_ha_cli
        show_info
        ;;
    --logs)
        check_ha_cli
        show_logs
        ;;
    --web)
        check_ha_cli
        open_web
        ;;
    --update)
        check_ha_cli
        update_addon
        ;;
    "")
        main
        ;;
    *)
        echo -e "${RED}❌ Unknown option: $1${NC}"
        echo "Use --help for usage information"
        exit 1
        ;;
esac 