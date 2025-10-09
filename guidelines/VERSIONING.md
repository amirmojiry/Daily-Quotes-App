# Versioning System

This document explains the versioning system used in the Daily Quotes App.

## Version Format

The app uses **Semantic Versioning (SemVer)** format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## Version Code System

Android version codes are automatically calculated from the semantic version:
```
versionCode = MAJOR * 10000 + MINOR * 100 + PATCH
```

### Examples:
- `1.0.1` → `10001`
- `1.1.0` → `10100`
- `2.0.0` → `20000`

## Automated Versioning

### Available Commands

```bash
# Patch version (bug fixes)
npm run version:patch

# Minor version (new features)
npm run version:minor

# Major version (breaking changes)
npm run version:major

# Build release
npm run build:release
```

### Manual Versioning

You can also use the script directly:
```bash
./scripts/version.sh [patch|minor|major]
```

## What Gets Updated

When you run a version command, the following files are automatically updated:

1. **package.json** - `version` field
2. **android/app/build.gradle** - `versionCode` and `versionName`
3. **src/views/AboutView.vue** - Version display (if exists)

## Git Workflow

### Creating a Release

1. **Bump version**:
   ```bash
   npm run version:patch  # or minor/major
   ```

2. **Build release**:
   ```bash
   npm run build:release
   ```

3. **Push changes**:
   ```bash
   git push origin main
   git push origin v1.0.1  # replace with actual version
   ```

### Version Tags

Each release is tagged in Git:
```bash
git tag -a "v1.0.1" -m "Release version 1.0.1"
```

## Release Process

### For Google Play Console

1. **Update version**:
   ```bash
   npm run version:patch
   ```

2. **Build release**:
   ```bash
   npm run build:release
   ```

3. **Upload files**:
   - Upload `android/app/build/outputs/bundle/release/app-release.aab`
   - Upload `android/app/build/outputs/mapping/release/mapping.txt` for crash reporting

4. **Commit and tag**:
   ```bash
   git add .
   git commit -m "Release v1.0.1"
   git tag -a "v1.0.1" -m "Release version 1.0.1"
   git push origin main
   git push origin v1.0.1
   ```

## Version History

| Version | Version Code | Release Date | Changes |
|---------|--------------|--------------|---------|
| 1.0.1   | 10001        | 2024-10-09   | Fixed version code conflict, added versioning system |
| 1.0.0   | 10000        | 2024-10-08   | Initial release |

## Best Practices

1. **Always bump version** before releasing to Google Play
2. **Use semantic versioning** appropriately
3. **Tag releases** in Git for easy reference
4. **Test builds** before uploading to Google Play
5. **Upload mapping files** for better crash reporting

## Troubleshooting

### Version Code Already Used
If you get "Version code X has already been used":
1. Run `npm run version:patch` to increment version
2. Rebuild and upload the new version

### Build Failures
If the build fails after version bump:
1. Check that all files were updated correctly
2. Run `npm run build:release` to see detailed error messages
3. Ensure all dependencies are installed

## Scripts Reference

### version.sh
- Updates version in all relevant files
- Creates Git commit and tag
- Interactive confirmation

### build-release.sh
- Builds web assets
- Copies to Android
- Builds Android release
- Shows output file locations and sizes
