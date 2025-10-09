#!/bin/bash

# Build release script for Daily Quotes App
# This script builds both web and Android versions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Building Daily Quotes App Release${NC}"

# Get current version
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo -e "${BLUE}Building version: ${CURRENT_VERSION}${NC}"

# Build web assets
echo -e "${YELLOW}📦 Building web assets...${NC}"
npm run build

# Copy to Android
echo -e "${YELLOW}📱 Copying to Android...${NC}"
npx cap copy

# Build Android release
echo -e "${YELLOW}🤖 Building Android release...${NC}"
cd android
./gradlew clean
./gradlew bundleRelease

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful!${NC}"
    
    # Show output files
    echo -e "${BLUE}📁 Output files:${NC}"
    echo -e "  AAB: android/app/build/outputs/bundle/release/app-release.aab"
    echo -e "  APK: android/app/build/outputs/apk/release/app-release.apk"
    echo -e "  Mapping: android/app/build/outputs/mapping/release/mapping.txt"
    
    # Show file sizes
    if [ -f "app/build/outputs/bundle/release/app-release.aab" ]; then
        AAB_SIZE=$(du -h app/build/outputs/bundle/release/app-release.aab | cut -f1)
        echo -e "  AAB size: ${AAB_SIZE}"
    fi
    
    if [ -f "app/build/outputs/apk/release/app-release.apk" ]; then
        APK_SIZE=$(du -h app/build/outputs/apk/release/app-release.apk | cut -f1)
        echo -e "  APK size: ${APK_SIZE}"
    fi
    
    echo -e "${GREEN}🎉 Release build complete!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Upload AAB to Google Play Console"
    echo -e "  2. Upload mapping.txt for crash reporting"
    echo -e "  3. Test the release build"
    
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi
