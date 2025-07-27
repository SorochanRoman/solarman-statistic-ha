.PHONY: help changelog quick-changelog release tag clean update-addon

# Default target
help:
	@echo "Available commands:"
	@echo "  changelog      - Generate full changelog"
	@echo "  quick-changelog - Generate quick changelog"
	@echo "  release       - Create new release (version required)"
	@echo "  tag           - Create git tag (version required)"
	@echo "  update-addon  - Update add-on in Home Assistant"
	@echo "  clean         - Clean temporary files"
	@echo ""
	@echo "Examples:"
	@echo "  make changelog"
	@echo "  make release VERSION=0.0.3"
	@echo "  make tag VERSION=0.0.3"

# Generate full changelog
changelog:
	@echo "🔧 Generating full changelog..."
	@chmod +x scripts/generate-changelog.sh
	@./scripts/generate-changelog.sh

# Generate quick changelog
quick-changelog:
	@echo "⚡ Generating quick changelog..."
	@chmod +x scripts/quick-changelog.sh
	@./scripts/quick-changelog.sh

# Create new release
release:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ Error: VERSION is required"; \
		echo "Usage: make release VERSION=0.0.3"; \
		exit 1; \
	fi
	@echo "🚀 Creating release v$(VERSION)..."
	@# Update version in config
	@sed -i.bak 's/version: ".*"/version: "$(VERSION)"/' solarman_statistic/config.yaml
	@# Generate changelog
	@make changelog
	@# Create tag
	@git add .
	@git commit -m "chore: bump version to $(VERSION)"
	@git tag -a v$(VERSION) -m "Release version $(VERSION)"
	@echo "✅ Release v$(VERSION) created!"
	@echo "📝 Don't forget to push:"
	@echo "   git push origin main"
	@echo "   git push origin v$(VERSION)"

# Create git tag
tag:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ Error: VERSION is required"; \
		echo "Usage: make tag VERSION=0.0.3"; \
		exit 1; \
	fi
	@echo "🏷️ Creating tag v$(VERSION)..."
	@git tag -a v$(VERSION) -m "Release version $(VERSION)"
	@echo "✅ Tag v$(VERSION) created!"
	@echo "📝 Push with: git push origin v$(VERSION)"

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	@rm -f temp_changelog.md
	@rm -f solarman_statistic/config.yaml.bak
	@echo "✅ Cleaned!"

# Show current version
version:
	@echo "📦 Current version: $(shell grep 'version:' solarman_statistic/config.yaml | sed 's/version: "\(.*\)"/\1/' | tr -d ' ')"

# Show git status
status:
	@echo "📊 Git status:"
	@git status --short
	@echo ""
	@echo "🏷️ Recent tags:"
	@git tag -l --sort=-version:refname | head -5

# Update add-on in Home Assistant
update-addon:
	@echo "🔄 Updating add-on in Home Assistant..."
	@chmod +x scripts/update-addon.sh
	@./scripts/update-addon.sh 