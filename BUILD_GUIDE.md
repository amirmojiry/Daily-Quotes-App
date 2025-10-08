# Daily Quotes App - Build Guide

## 📱 Overview
This guide provides step-by-step instructions for building the Daily Quotes Android app from source code.

## 🛠️ Prerequisites

### Required Software
- **Node.js** (v20.19+ or v22.12+)
- **Java** (OpenJDK 21)
- **Android Studio** (with Android SDK)
- **Git** (for version control)

### Environment Setup
1. **Install Node.js**
   ```bash
   # Check version
   node --version
   npm --version
   ```

2. **Install Java 21**
   ```bash
   # Ubuntu/WSL
   sudo apt update
   sudo apt install openjdk-21-jdk
   
   # Verify installation
   java -version
   javac -version
   ```

3. **Install Android Studio**
   - Download from: https://developer.android.com/studio
   - Install Android SDK (API 35 recommended)
   - Set up Android SDK environment variables

## 🚀 Build Process

### Step 1: Clone and Setup
```bash
# Clone the repository
git clone <your-repo-url>
cd Daily-Quotes-App

# Install dependencies
npm install
```

### Step 2: Environment Configuration
```bash
# Set Android SDK path (adjust path as needed)
export ANDROID_HOME=/mnt/c/Users/amoji/AppData/Local/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin

# Set Java home
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
```

### Step 3: Build Web Assets
```bash
# Build the Vue.js web application
npm run build
```

### Step 4: Sync with Capacitor
```bash
# Copy web assets to Android project
npx cap copy
```

### Step 5: Build Android APK
```bash
# Navigate to Android directory
cd android

# Clean previous builds
./gradlew clean

# Build debug APK
./gradlew assembleDebug --no-daemon

# Build release APK (unsigned)
./gradlew assembleRelease --no-daemon
```

### Step 6: Locate Generated Files
```bash
# Debug APK
android/app/build/outputs/apk/debug/app-debug.apk

# Release APK (unsigned)
android/app/build/outputs/apk/release/app-release-unsigned.apk
```

## 🔐 App Signing for Google Play Store

### Step 1: Generate Keystore
```bash
# Generate signing keystore
keytool -genkey -v -keystore daily-quotes-release-key.keystore -alias daily-quotes-key -keyalg RSA -keysize 2048 -validity 10000
```

### Step 2: Configure Signing
Create `android/keystore.properties`:
```properties
MYAPP_UPLOAD_STORE_FILE=daily-quotes-release-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=daily-quotes-key
MYAPP_UPLOAD_STORE_PASSWORD=your_store_password
MYAPP_UPLOAD_KEY_PASSWORD=your_key_password
```

### Step 3: Update Build Configuration
Add to `android/app/build.gradle`:
```gradle
android {
    signingConfigs {
        release {
            if (keystoreProperties['MYAPP_UPLOAD_STORE_FILE']) {
                storeFile file(keystoreProperties['MYAPP_UPLOAD_STORE_FILE'])
                storePassword keystoreProperties['MYAPP_UPLOAD_STORE_PASSWORD']
                keyAlias keystoreProperties['MYAPP_UPLOAD_KEY_ALIAS']
                keyPassword keystoreProperties['MYAPP_UPLOAD_KEY_PASSWORD']
            }
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
        }
    }
}
```

### Step 4: Build Signed APK and AAB
```bash
# Build signed release APK
./gradlew assembleRelease --no-daemon

# Build Android App Bundle (AAB) for Google Play
./gradlew bundleRelease --no-daemon
```

## 📦 Output Files

### For Testing
- `app-debug.apk` - Debug version for testing

### For Google Play Store
- `app-release.apk` - Signed release APK
- `app-release.aab` - Android App Bundle (recommended for Play Store)

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. Java Version Error
**Error**: `error: invalid source release: 21`
**Solution**:
```bash
# Ensure Java 21 is installed and set
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
java -version  # Should show Java 21
```

#### 2. Android SDK Not Found
**Error**: `SDK location not found`
**Solution**:
```bash
# Check if Android SDK exists
ls -la /mnt/c/Users/amoji/AppData/Local/Android/Sdk

# Create local.properties if missing
echo "sdk.dir=/mnt/c/Users/amoji/AppData/Local/Android/Sdk" > android/local.properties
```

#### 3. Gradle Build Fails
**Error**: Build process fails with various errors
**Solution**:
```bash
# Clean and rebuild
cd android
./gradlew clean
./gradlew assembleDebug --no-daemon --stacktrace
```

#### 4. Node.js Version Warning
**Error**: `Vite requires Node.js version 20.19+ or 22.12+`
**Solution**:
```bash
# Update Node.js to latest LTS version
# Using nvm (recommended)
nvm install --lts
nvm use --lts
```

#### 5. Capacitor Sync Issues
**Error**: Web assets not syncing to Android
**Solution**:
```bash
# Force sync
npx cap copy android
npx cap sync android
```

#### 6. Keystore Issues
**Error**: Signing configuration problems
**Solution**:
```bash
# Verify keystore file exists
ls -la android/daily-quotes-release-key.keystore

# Check keystore.properties format
cat android/keystore.properties
```

#### 7. Build Tools Version Mismatch
**Error**: Android Gradle Plugin compatibility issues
**Solution**:
```bash
# Update Gradle wrapper
cd android
./gradlew wrapper --gradle-version 8.11.1
```

### Environment-Specific Issues

#### WSL2 on Windows
- Use Windows Android Studio installation path
- Ensure proper file permissions for SDK access
- Use `--no-daemon` flag for Gradle builds

#### Linux
- Install Android SDK manually if needed
- Set proper JAVA_HOME environment variable
- Ensure Android SDK tools are in PATH

#### macOS
- Use Homebrew for Java installation
- Set ANDROID_HOME in shell profile
- Ensure Xcode command line tools are installed

## 📋 Build Checklist

Before building, ensure:
- [ ] Node.js v20.19+ installed
- [ ] Java 21 installed and configured
- [ ] Android SDK installed and configured
- [ ] Environment variables set correctly
- [ ] Dependencies installed (`npm install`)
- [ ] Web assets built (`npm run build`)
- [ ] Capacitor synced (`npx cap copy`)

## 🚀 Quick Build Commands

### Development Build
```bash
npm run build && npx cap copy && cd android && ./gradlew assembleDebug --no-daemon
```

### Production Build
```bash
npm run build && npx cap copy && cd android && ./gradlew assembleRelease --no-daemon
```

### Google Play Build
```bash
npm run build && npx cap copy && cd android && ./gradlew bundleRelease --no-daemon
```

## 📞 Support

If you encounter issues not covered in this guide:
1. Check the troubleshooting section above
2. Verify all prerequisites are installed correctly
3. Ensure environment variables are set properly
4. Try cleaning and rebuilding from scratch

## 📝 Notes

- Always use `--no-daemon` flag for Gradle builds in CI/CD environments
- Keep your keystore file secure and backed up
- Test debug builds before creating release builds
- AAB files are preferred over APK for Google Play Store uploads
