#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/outputs/Qingti.app"

mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$ROOT/outputs/avocado-todo.html" "$APP/Contents/Resources/avocado-todo.html"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>Qingti</string>
  <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
  <key>CFBundleSignature</key><string>????</string>
  <key>CFBundleDevelopmentRegion</key><string>zh_CN</string>
  <key>CFBundleIdentifier</key><string>com.yundouzh.qingti</string>
  <key>CFBundleName</key><string>青提</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleSupportedPlatforms</key><array><string>MacOSX</string></array>
  <key>NSPrincipalClass</key><string>QingtiApplication</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST
printf 'APPL????' > "$APP/Contents/PkgInfo"

clang -fobjc-arc -arch arm64 -mmacosx-version-min=13.0 \
  -framework Cocoa -framework WebKit \
  "$ROOT/macos/QingtiMenuBar.m" \
  -o "$APP/Contents/MacOS/Qingti"

xattr -cr "$APP" 2>/dev/null || true
xattr -d com.apple.FinderInfo "$APP" 2>/dev/null || true
codesign --force --sign - "$APP"
xattr -d com.apple.FinderInfo "$APP" 2>/dev/null || true
codesign --verify --strict "$APP"
echo "Built $APP"
