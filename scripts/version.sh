#!/bin/bash

# Version management script for Daily Quotes App
# Usage: ./scripts/version.sh [patch|minor|major]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current version from package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo -e "${BLUE}Current version: ${CURRENT_VERSION}${NC}"

# Parse version components
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

# Determine version bump type
BUMP_TYPE=${1:-patch}

case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo -e "${RED}Error: Invalid bump type. Use 'patch', 'minor', or 'major'${NC}"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo -e "${GREEN}New version: ${NEW_VERSION}${NC}"

# Update package.json
echo -e "${YELLOW}Updating package.json...${NC}"
npm version $NEW_VERSION --no-git-tag-version

# Update Android build.gradle
echo -e "${YELLOW}Updating Android build.gradle...${NC}"
# Extract version code from current version (major * 10000 + minor * 100 + patch)
VERSION_CODE=$((MAJOR * 10000 + MINOR * 100 + PATCH))

# Update versionName and versionCode in build.gradle
sed -i "s/versionCode [0-9]*/versionCode $VERSION_CODE/" android/app/build.gradle
sed -i "s/versionName \"[^\"]*\"/versionName \"$NEW_VERSION\"/" android/app/build.gradle

echo -e "${GREEN}Updated version code to: ${VERSION_CODE}${NC}"

# Update AboutView.vue if it exists
if [ -f "src/views/AboutView.vue" ]; then
    echo -e "${YELLOW}Updating AboutView.vue...${NC}"
    sed -i "s/Version [0-9]*\.[0-9]*\.[0-9]*/Version $NEW_VERSION/" src/views/AboutView.vue
fi

# Show git status
echo -e "${BLUE}Git status:${NC}"
git status

# Ask for confirmation before committing
echo -e "${YELLOW}Do you want to commit these changes? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Add changes
    git add package.json android/app/build.gradle src/views/AboutView.vue 2>/dev/null || true
    
    # Commit
    git commit -m "Bump version to $NEW_VERSION"
    
    # Create tag
    git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
    
    echo -e "${GREEN}Version $NEW_VERSION committed and tagged!${NC}"
    echo -e "${BLUE}To push changes and tags:${NC}"
    echo -e "  git push origin main"
    echo -e "  git push origin v$NEW_VERSION"
else
    echo -e "${YELLOW}Changes not committed. You can commit manually later.${NC}"
fi

echo -e "${GREEN}Version bump complete!${NC}"
