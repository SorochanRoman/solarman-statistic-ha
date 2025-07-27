#!/bin/bash

# Generate changelog script for Solarman Statistic HA Add-on

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="solarman-statistic-ha"
CHANGELOG_FILE="CHANGELOG.md"
TEMP_FILE="temp_changelog.md"

echo -e "${BLUE}🔧 Generating changelog for $REPO_NAME...${NC}"

# Function to get version from config.yaml
get_version() {
    grep "version:" solarman_statistic/config.yaml | sed 's/version: "\(.*\)"/\1/' | tr -d ' '
}

# Function to format commit messages
format_commit() {
    local commit_hash=$1
    local commit_msg=$2
    local author=$3
    local date=$4
    
    # Categorize commits
    if [[ $commit_msg =~ ^feat: ]]; then
        echo "  ✨ **Feature:** ${commit_msg#feat: }"
    elif [[ $commit_msg =~ ^fix: ]]; then
        echo "  🐛 **Fix:** ${commit_msg#fix: }"
    elif [[ $commit_msg =~ ^docs: ]]; then
        echo "  📚 **Docs:** ${commit_msg#docs: }"
    elif [[ $commit_msg =~ ^style: ]]; then
        echo "  💄 **Style:** ${commit_msg#style: }"
    elif [[ $commit_msg =~ ^refactor: ]]; then
        echo "  ♻️ **Refactor:** ${commit_msg#refactor: }"
    elif [[ $commit_msg =~ ^test: ]]; then
        echo "  🧪 **Test:** ${commit_msg#test: }"
    elif [[ $commit_msg =~ ^chore: ]]; then
        echo "  🔧 **Chore:** ${commit_msg#chore: }"
    else
        echo "  📝 **Other:** $commit_msg"
    fi
}

# Get current version
CURRENT_VERSION=$(get_version)
echo -e "${GREEN}📦 Current version: $CURRENT_VERSION${NC}"

# Create changelog header
cat > $TEMP_FILE << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New features and improvements

### Changed
- Changes in existing functionality

### Fixed
- Bug fixes

### Removed
- Removed features

---

EOF

# Get all commits since last tag (or all commits if no tags)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
    echo -e "${YELLOW}⚠️  No tags found, generating changelog for all commits${NC}"
    COMMITS=$(git log --pretty=format:"%H|%s|%an|%ad" --date=short --reverse)
else
    echo -e "${GREEN}📋 Generating changelog since tag: $LAST_TAG${NC}"
    COMMITS=$(git log --pretty=format:"%H|%s|%an|%ad" --date=short --reverse $LAST_TAG..HEAD)
fi

# Process commits and categorize them
if [ ! -z "$COMMITS" ]; then
    echo "## [$CURRENT_VERSION] - $(date +%Y-%m-%d)" >> $TEMP_FILE
    echo "" >> $TEMP_FILE
    
    # Initialize categories
    FEATURES=""
    FIXES=""
    DOCS=""
    STYLE=""
    REFACTOR=""
    TESTS=""
    CHORES=""
    OTHERS=""
    
    # Process each commit
    while IFS='|' read -r hash msg author date; do
        formatted=$(format_commit "$hash" "$msg" "$author" "$date")
        
        if [[ $msg =~ ^feat: ]]; then
            FEATURES+="$formatted"$'\n'
        elif [[ $msg =~ ^fix: ]]; then
            FIXES+="$formatted"$'\n'
        elif [[ $msg =~ ^docs: ]]; then
            DOCS+="$formatted"$'\n'
        elif [[ $msg =~ ^style: ]]; then
            STYLE+="$formatted"$'\n'
        elif [[ $msg =~ ^refactor: ]]; then
            REFACTOR+="$formatted"$'\n'
        elif [[ $msg =~ ^test: ]]; then
            TESTS+="$formatted"$'\n'
        elif [[ $msg =~ ^chore: ]]; then
            CHORES+="$formatted"$'\n'
        else
            OTHERS+="$formatted"$'\n'
        fi
    done <<< "$COMMITS"
    
    # Add categories to changelog
    if [ ! -z "$FEATURES" ]; then
        echo "### Added" >> $TEMP_FILE
        echo "$FEATURES" >> $TEMP_FILE
    fi
    
    if [ ! -z "$FIXES" ]; then
        echo "### Fixed" >> $TEMP_FILE
        echo "$FIXES" >> $TEMP_FILE
    fi
    
    if [ ! -z "$DOCS" ]; then
        echo "### Documentation" >> $TEMP_FILE
        echo "$DOCS" >> $TEMP_FILE
    fi
    
    if [ ! -z "$REFACTOR" ]; then
        echo "### Changed" >> $TEMP_FILE
        echo "$REFACTOR" >> $TEMP_FILE
    fi
    
    if [ ! -z "$STYLE" ]; then
        echo "### Style" >> $TEMP_FILE
        echo "$STYLE" >> $TEMP_FILE
    fi
    
    if [ ! -z "$TESTS" ]; then
        echo "### Tests" >> $TEMP_FILE
        echo "$TESTS" >> $TEMP_FILE
    fi
    
    if [ ! -z "$CHORES" ]; then
        echo "### Maintenance" >> $TEMP_FILE
        echo "$CHORES" >> $TEMP_FILE
    fi
    
    if [ ! -z "$OTHERS" ]; then
        echo "### Other" >> $TEMP_FILE
        echo "$OTHERS" >> $TEMP_FILE
    fi
    
    echo "" >> $TEMP_FILE
    echo "---" >> $TEMP_FILE
    echo "" >> $TEMP_FILE
fi

# Add previous changelog if exists
if [ -f "$CHANGELOG_FILE" ]; then
    echo -e "${YELLOW}📄 Appending to existing changelog...${NC}"
    # Skip the header and unreleased section
    tail -n +15 "$CHANGELOG_FILE" >> $TEMP_FILE
fi

# Move temp file to final location
mv $TEMP_FILE $CHANGELOG_FILE

echo -e "${GREEN}✅ Changelog generated successfully: $CHANGELOG_FILE${NC}"
echo -e "${BLUE}📊 Summary:${NC}"
echo -e "  📦 Version: $CURRENT_VERSION"
echo -e "  📝 Total commits processed: $(echo "$COMMITS" | wc -l | tr -d ' ')"
echo -e "  📄 Changelog file: $CHANGELOG_FILE"

# Show preview
echo -e "${BLUE}📋 Preview (first 20 lines):${NC}"
head -20 "$CHANGELOG_FILE" 