#!/bin/bash

# Update changelog in config.yaml script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONFIG_FILE="solarman_statistic/config.yaml"
CHANGELOG_FILE="solarman_statistic/CHANGELOG.md"

echo -e "${BLUE}📝 Updating changelog in config.yaml${NC}"
echo ""

# Function to get current version
get_version() {
    grep "version:" $CONFIG_FILE | sed 's/version: "\(.*\)"/\1/' | tr -d ' '
}

# Function to get latest changelog entry
get_latest_changelog() {
    # Extract the latest version changelog from CHANGELOG.md
    if [ -f "$CHANGELOG_FILE" ]; then
        # Get the first version entry (most recent)
        awk '/^## \[/{p=1;next} /^## \[/{p=0} p' "$CHANGELOG_FILE" | head -20 | sed 's/^[[:space:]]*//' | tr '\n' ' ' | sed 's/^## \[.*\] - .*$//'
    else
        echo "Initial release"
    fi
}

# Function to update config.yaml with changelog
update_config() {
    local version=$1
    local changelog=$2
    
    echo -e "${BLUE}📋 Current version: $version${NC}"
    echo -e "${BLUE}📝 Latest changelog: $changelog${NC}"
    
    # Create backup
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    
    # Update changelog in config.yaml
    if grep -q "changelog:" "$CONFIG_FILE"; then
        # Update existing changelog
        sed -i.bak "s/changelog: \".*\"/changelog: \"$changelog\"/" "$CONFIG_FILE"
    else
        # Add changelog line after description
        sed -i.bak "/description:/a changelog: \"$changelog\"" "$CONFIG_FILE"
    fi
    
    echo -e "${GREEN}✅ Updated changelog in config.yaml${NC}"
}

# Function to show current changelog
show_current_changelog() {
    echo -e "${BLUE}📋 Current changelog in config.yaml:${NC}"
    if grep -q "changelog:" "$CONFIG_FILE"; then
        grep "changelog:" "$CONFIG_FILE" | sed 's/changelog: "\(.*\)"/\1/'
    else
        echo -e "${YELLOW}⚠️ No changelog found in config.yaml${NC}"
    fi
}

# Function to create changelog from git commits
create_changelog_from_git() {
    local version=$1
    
    echo -e "${BLUE}📝 Creating changelog from git commits...${NC}"
    
    # Get commits since last tag
    LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -z "$LAST_TAG" ]; then
        echo -e "${YELLOW}⚠️ No tags found, using all commits${NC}"
        COMMITS=$(git log --oneline --reverse | head -5)
    else
        echo -e "${GREEN}📋 Using commits since $LAST_TAG${NC}"
        COMMITS=$(git log --oneline --reverse $LAST_TAG..HEAD | head -5)
    fi
    
    # Create changelog summary
    CHANGELOG_SUMMARY=""
    while IFS= read -r commit; do
        if [ ! -z "$commit" ]; then
            # Extract commit message (remove hash)
            MSG=$(echo "$commit" | sed 's/^[a-f0-9]* //')
            CHANGELOG_SUMMARY="$CHANGELOG_SUMMARY $MSG;"
        fi
    done <<< "$COMMITS"
    
    # Clean up the summary
    CHANGELOG_SUMMARY=$(echo "$CHANGELOG_SUMMARY" | sed 's/^ *//; s/ *$//; s/; *$//')
    
    echo -e "${GREEN}✅ Created changelog: $CHANGELOG_SUMMARY${NC}"
    echo "$CHANGELOG_SUMMARY"
}

# Main script
main() {
    # Check if config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}❌ Config file not found: $CONFIG_FILE${NC}"
        exit 1
    fi
    
    # Get current version
    VERSION=$(get_version)
    if [ -z "$VERSION" ]; then
        echo -e "${RED}❌ Could not determine version from config.yaml${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}📦 Current version: $VERSION${NC}"
    echo ""
    
    # Show current changelog
    show_current_changelog
    echo ""
    
    # Get changelog from CHANGELOG.md or git
    if [ -f "$CHANGELOG_FILE" ]; then
        echo -e "${BLUE}📄 Using changelog from CHANGELOG.md${NC}"
        CHANGELOG=$(get_latest_changelog)
    else
        echo -e "${BLUE}📝 Creating changelog from git commits${NC}"
        CHANGELOG=$(create_changelog_from_git "$VERSION")
    fi
    
    # Escape quotes for sed
    CHANGELOG=$(echo "$CHANGELOG" | sed 's/"/\\"/g')
    
    # Update config
    update_config "$VERSION" "$CHANGELOG"
    
    echo ""
    echo -e "${GREEN}✅ Changelog updated successfully!${NC}"
    echo ""
    echo -e "${BLUE}📋 Updated config.yaml:${NC}"
    grep -A 5 -B 5 "changelog:" "$CONFIG_FILE"
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --show         Show current changelog"
        echo "  --git          Create changelog from git commits"
        echo "  --version      Show current version"
        echo ""
        echo "Examples:"
        echo "  $0              # Update changelog automatically"
        echo "  $0 --show       # Show current changelog"
        echo "  $0 --git        # Create changelog from git"
        ;;
    --show)
        show_current_changelog
        ;;
    --git)
        VERSION=$(get_version)
        create_changelog_from_git "$VERSION"
        ;;
    --version)
        get_version
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