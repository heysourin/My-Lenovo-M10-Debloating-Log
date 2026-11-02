#!/usr/bin/env bash
# Lenovo Tab M10 (TB-X505X) Round 2 Debloat Script

ADB="/opt/homebrew/bin/adb"

# Try connecting over Wi-Fi if needed
$ADB connect 192.168.34.170:5555 >/dev/null 2>&1

TARGET_DEVICE=""
if $ADB devices | grep -q "192.168.34.170:5555[[:space:]]*device"; then
    TARGET_DEVICE="192.168.34.170:5555"
elif $ADB devices | grep -q "HGAMG2AR[[:space:]]*device"; then
    TARGET_DEVICE="HGAMG2AR"
else
    TARGET_DEVICE=$($ADB devices | grep -v "List" | grep "device$" | head -n 1 | awk '{print $1}')
fi

if [ -z "$TARGET_DEVICE" ]; then
    echo "❌ No connected device found!"
    exit 1
fi

echo "Connected to tablet: $TARGET_DEVICE"

PACKAGES=(
    "com.dsi.ant.server"
    "com.google.android.tag"
    "com.qualcomm.qti.qms.service.telemetry"
    "com.android.traceur"
    "com.tblenovo.setup"
    "com.android.egg"
    "com.android.dreams.phototable"
    "com.android.dreams.basic"
    "com.android.wallpaper.livepicker"
    "com.android.bips"
    "com.android.printspooler"
    "com.android.smspush"
    "com.android.calllogbackup"
    "com.google.android.marvin.talkback"
    "com.google.android.apps.photos"
    "com.google.android.apps.restore"
    "com.google.android.onetimeinitializer"
    "com.google.android.partnersetup"
)

echo "Disabling extra bloatware and background telemetry..."
for pkg in "${PACKAGES[@]}"; do
    printf "Disabling %-50s ... " "$pkg"
    out=$($ADB -s "$TARGET_DEVICE" shell pm disable-user --user 0 "$pkg" 2>&1)
    echo "$out"
done

echo ""
echo "✅ Round 2 debloat completed successfully!"

