#!/bin/bash

# Test Docker build script for Solarman Statistic Add-on

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

IMAGE_NAME="solarman-statistic-test"
BUILD_CONTEXT="solarman_statistic"

echo -e "${BLUE}🔧 Testing Docker build for Solarman Statistic Add-on${NC}"
echo ""

# Function to check if Docker is available
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found!${NC}"
        echo -e "${YELLOW}Please install Docker first${NC}"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker daemon not running!${NC}"
        echo -e "${YELLOW}Please start Docker daemon${NC}"
        exit 1
    fi
}

# Function to clean up previous builds
cleanup() {
    echo -e "${BLUE}🧹 Cleaning up previous builds...${NC}"
    docker rmi $IMAGE_NAME 2>/dev/null || true
    docker system prune -f
}

# Function to test build
test_build() {
    echo -e "${BLUE}🏗️ Building Docker image...${NC}"
    
    # Use a base image that's similar to Home Assistant
    cat > $BUILD_CONTEXT/Dockerfile.test << EOF
FROM alpine:3.18

# Install Python and required system dependencies
RUN apk add --no-cache \\
    python3 \\
    py3-pip \\
    gcc \\
    musl-dev \\
    python3-dev \\
    libffi-dev \\
    openssl-dev

# Upgrade pip and install wheel
RUN pip3 install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
COPY requirements.txt /
RUN pip3 install --no-cache-dir --prefer-binary -r requirements.txt

# Remove build dependencies to reduce image size
RUN apk del gcc musl-dev python3-dev libffi-dev openssl-dev

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

    # Build the image
    if docker build -f $BUILD_CONTEXT/Dockerfile.test -t $IMAGE_NAME $BUILD_CONTEXT; then
        echo -e "${GREEN}✅ Docker build successful!${NC}"
        return 0
    else
        echo -e "${RED}❌ Docker build failed!${NC}"
        return 1
    fi
}

# Function to test run
test_run() {
    echo -e "${BLUE}🚀 Testing container run...${NC}"
    
    # Run container in background
    CONTAINER_ID=$(docker run -d -p 8099:8099 --name ${IMAGE_NAME}-test $IMAGE_NAME)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Container started successfully!${NC}"
        echo -e "${BLUE}📋 Container ID: $CONTAINER_ID${NC}"
        
        # Wait a bit for the application to start
        sleep 5
        
        # Test if the web interface is accessible
        if curl -s http://localhost:8099 > /dev/null; then
            echo -e "${GREEN}✅ Web interface is accessible!${NC}"
            echo -e "${BLUE}🌐 URL: http://localhost:8099${NC}"
        else
            echo -e "${YELLOW}⚠️ Web interface not accessible yet${NC}"
        fi
        
        # Show logs
        echo -e "${BLUE}📋 Container logs:${NC}"
        docker logs $CONTAINER_ID --tail 10
        
        # Stop and remove container
        echo -e "${BLUE}🛑 Stopping container...${NC}"
        docker stop $CONTAINER_ID
        docker rm $CONTAINER_ID
        
        return 0
    else
        echo -e "${RED}❌ Container failed to start!${NC}"
        return 1
    fi
}

# Function to show image info
show_info() {
    echo -e "${BLUE}📊 Image information:${NC}"
    docker images $IMAGE_NAME
    
    echo -e "${BLUE}📋 Image layers:${NC}"
    docker history $IMAGE_NAME
}

# Main script
main() {
    check_docker
    cleanup
    
    if test_build; then
        echo ""
        show_info
        echo ""
        
        read -p "Do you want to test running the container? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            test_run
        fi
        
        echo ""
        echo -e "${GREEN}🎉 Build test completed successfully!${NC}"
    else
        echo -e "${RED}❌ Build test failed!${NC}"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --build-only   Only test build, don't run container"
        echo "  --clean        Clean up Docker images and containers"
        echo ""
        echo "Examples:"
        echo "  $0              # Full test (build + run)"
        echo "  $0 --build-only # Only test build"
        echo "  $0 --clean      # Clean up Docker resources"
        ;;
    --build-only)
        check_docker
        cleanup
        test_build
        show_info
        ;;
    --clean)
        cleanup
        docker system prune -f
        echo -e "${GREEN}✅ Cleanup completed!${NC}"
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