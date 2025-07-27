#!/bin/bash

# Quick changelog generator
# Usage: ./scripts/quick-changelog.sh [version] [date]

VERSION=${1:-$(grep "version:" solarman_statistic/config.yaml | sed 's/version: "\(.*\)"/\1/')}
DATE=${2:-$(date +%Y-%m-%d)}

echo "# Changelog for version $VERSION ($DATE)"
echo ""

# Get commits since last tag or all commits
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
    echo "## All commits:"
    git log --oneline --reverse
else
    echo "## Commits since $LAST_TAG:"
    git log --oneline --reverse $LAST_TAG..HEAD
fi

echo ""
echo "## Summary:"
echo "- Total commits: $(git log --oneline | wc -l | tr -d ' ')"
echo "- Version: $VERSION"
echo "- Date: $DATE" 