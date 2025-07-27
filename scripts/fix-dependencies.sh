#!/bin/bash

# Fix Python dependencies script for Solarman Statistic Add-on

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing Python dependencies for Solarman Statistic Add-on${NC}"
echo ""

# Function to create minimal requirements
create_minimal_requirements() {
    echo -e "${BLUE}📝 Creating minimal requirements.txt...${NC}"
    
    cat > solarman_statistic/requirements.txt << EOF
# Minimal Flask requirements for Alpine Linux
Flask>=2.2.0,<3.0.0
Werkzeug>=2.2.0,<3.0.0

# Alternative: Use specific versions known to work with Alpine
# Flask==2.2.5
# Werkzeug==2.2.3
EOF
    
    echo -e "${GREEN}✅ Created minimal requirements.txt${NC}"
}

# Function to create optimized Dockerfile
create_optimized_dockerfile() {
    echo -e "${BLUE}📝 Creating optimized Dockerfile...${NC}"
    
    cat > solarman_statistic/Dockerfile << EOF
ARG BUILD_FROM
FROM \$BUILD_FROM

# Install Python and minimal dependencies
RUN apk add --no-cache \\
    python3 \\
    py3-pip \\
    gcc \\
    musl-dev \\
    python3-dev

# Upgrade pip and install wheel for better compatibility
RUN pip3 install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir --prefer-binary -r requirements.txt

# Remove build dependencies to reduce image size
RUN apk del gcc musl-dev python3-dev

# Copy application files
COPY app.py /
COPY templates/ /templates/
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port for web interface
EXPOSE 8099

# Set the default command
CMD [ "/run.sh" ]
EOF
    
    echo -e "${GREEN}✅ Created optimized Dockerfile${NC}"
}

# Function to create alternative requirements
create_alternative_requirements() {
    echo -e "${BLUE}📝 Creating alternative requirements.txt...${NC}"
    
    cat > solarman_statistic/requirements-alpine.txt << EOF
# Alternative requirements for Alpine Linux
Flask==2.2.5
Werkzeug==2.2.3
MarkupSafe==2.1.3
Jinja2==3.1.2
itsdangerous==2.1.2
click==8.1.7
blinker==1.6.2
EOF
    
    echo -e "${GREEN}✅ Created alternative requirements-alpine.txt${NC}"
}

# Function to create build script
create_build_script() {
    echo -e "${BLUE}📝 Creating build script...${NC}"
    
    cat > solarman_statistic/build.sh << 'EOF'
#!/bin/bash

# Build script for Solarman Statistic Add-on

set -e

echo "🔧 Building Solarman Statistic Add-on..."

# Check if we're in a Home Assistant environment
if [ -f "/usr/bin/with-contenv" ]; then
    echo "✅ Running in Home Assistant environment"
    
    # Use Home Assistant base image
    docker build -t solarman-statistic .
else
    echo "⚠️ Not in Home Assistant environment, using Alpine base"
    
    # Create temporary Dockerfile for testing
    cat > Dockerfile.test << 'DOCKERFILE'
FROM alpine:3.18

# Install Python and minimal dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    gcc \
    musl-dev \
    python3-dev

# Upgrade pip and install wheel
RUN pip3 install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir --prefer-binary -r requirements.txt

# Remove build dependencies
RUN apk del gcc musl-dev python3-dev

# Copy application files
COPY app.py /
COPY templates/ /templates/
COPY run.sh /
RUN chmod a+x /run.sh

# Expose port for web interface
EXPOSE 8099

# Set the default command
CMD [ "/run.sh" ]
DOCKERFILE

    # Build with test Dockerfile
    docker build -f Dockerfile.test -t solarman-statistic .
    
    # Clean up
    rm Dockerfile.test
fi

echo "✅ Build completed successfully!"
EOF
    
    chmod +x solarman_statistic/build.sh
    echo -e "${GREEN}✅ Created build script${NC}"
}

# Function to show troubleshooting tips
show_troubleshooting() {
    echo -e "${BLUE}🔍 Troubleshooting tips:${NC}"
    echo ""
    echo "1. **Common Alpine Linux issues:**"
    echo "   - Missing build dependencies (gcc, musl-dev, python3-dev)"
    echo "   - Incompatible Python package versions"
    echo "   - Missing system libraries (libffi-dev, openssl-dev)"
    echo ""
    echo "2. **Solutions:**"
    echo "   - Use --prefer-binary flag with pip"
    echo "   - Install build dependencies before pip install"
    echo "   - Use specific package versions known to work with Alpine"
    echo "   - Remove build dependencies after installation"
    echo ""
    echo "3. **Alternative approaches:**"
    echo "   - Use multi-stage builds"
    echo "   - Use pre-built wheels"
    echo "   - Use different base images"
    echo ""
    echo "4. **Testing:**"
    echo "   - Run: ./scripts/test-build.sh"
    echo "   - Check logs: docker logs <container>"
    echo "   - Test locally: docker run -p 8099:8099 <image>"
}

# Main script
main() {
    echo -e "${YELLOW}⚠️ This script will modify your Dockerfile and requirements.txt${NC}"
    read -p "Continue? (y/n): " choice
    
    if [[ ! $choice =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⚠️ Operation cancelled${NC}"
        exit 0
    fi
    
    # Backup original files
    if [ -f "solarman_statistic/Dockerfile" ]; then
        cp solarman_statistic/Dockerfile solarman_statistic/Dockerfile.backup
        echo -e "${BLUE}📋 Backed up original Dockerfile${NC}"
    fi
    
    if [ -f "solarman_statistic/requirements.txt" ]; then
        cp solarman_statistic/requirements.txt solarman_statistic/requirements.txt.backup
        echo -e "${BLUE}📋 Backed up original requirements.txt${NC}"
    fi
    
    # Create fixed files
    create_minimal_requirements
    create_optimized_dockerfile
    create_alternative_requirements
    create_build_script
    
    echo ""
    echo -e "${GREEN}🎉 Dependencies fixed!${NC}"
    echo ""
    echo -e "${BLUE}📋 What was changed:${NC}"
    echo "  ✅ Updated requirements.txt with compatible versions"
    echo "  ✅ Optimized Dockerfile for Alpine Linux"
    echo "  ✅ Created alternative requirements for troubleshooting"
    echo "  ✅ Added build script for easier testing"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo "  1. Test build: ./scripts/test-build.sh"
    echo "  2. If issues persist, try: requirements-alpine.txt"
    echo "  3. Check logs for specific error messages"
    echo ""
    
    show_troubleshooting
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --minimal      Create minimal requirements only"
        echo "  --dockerfile   Create optimized Dockerfile only"
        echo "  --troubleshoot Show troubleshooting tips"
        echo ""
        echo "Examples:"
        echo "  $0              # Fix all dependencies"
        echo "  $0 --minimal    # Create minimal requirements only"
        echo "  $0 --troubleshoot # Show troubleshooting tips"
        ;;
    --minimal)
        create_minimal_requirements
        ;;
    --dockerfile)
        create_optimized_dockerfile
        ;;
    --troubleshoot)
        show_troubleshooting
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