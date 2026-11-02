#!/usr/bin/env bash
# Lenovo Tab M10 (TB-X505X) Complete Master Restoration Script

# 1. Locate ADB binary
if [ -x "/opt/homebrew/bin/adb" ]; then
    ADB="/opt/homebrew/bin/adb"
elif command -v adb >/dev/null 2>&1; then
    ADB=$(command -v adb)
else
    echo "❌ Error: 'adb' was not found on this Mac."
    echo "To reinstall it, run this command in Terminal:"
    echo "    brew install --cask android-platform-tools"
    exit 1
fi

# 2. Try connecting over Wi-Fi first if not already connected
$ADB connect 192.168.34.170:5555 >/dev/null 2>&1

# 3. Detect available device (Wi-Fi or USB)
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
    echo "Please make sure:"
    echo "  1. The tablet is on the same Wi-Fi, OR"
    echo "  2. The tablet is plugged into your Mac via USB cable with USB Debugging enabled."
    exit 1
fi

echo "Connected to tablet: $TARGET_DEVICE"
echo "Restoring all packages to stock..."

PACKAGES=(
    # Round 1 packages
    "com.lenovo.ue.device"
    "com.tblenovo.lenovotips"
    "com.tblenovo.whatsnewclient"
    "com.lenovo.dsa"
    "com.lenovo.lsf"
    "com.lenovo.lsf.device"
    "com.lenovo.ocpl"
    "cn.sinoangel.monsterclass"
    "com.motorola.demo"
    "com.longcheertel.midtest"
    "com.focaltech.ft_terminal_test"
    "com.android.wantjoin.childmode.ctrl"
    "com.android.wantjoin.settings"
    "com.android.partnerbrowsercustomizations.example"
    "com.android.providers.partnerbookmarks"
    "com.android.bookmarkprovider"
    "com.tblenovo.smartiot"
    "com.lenovo.screenassistant"
    "com.google.android.projection.gearhead"
    "com.google.android.apps.wellbeing"
    "com.google.android.feedback"
    "com.google.android.printservice.recommendation"
    "com.caf.fmradio"

    # Round 2 packages
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

    # Dolby packages
    "com.dolby.daxappui"
    "com.dolby.daxservice"
)

for pkg in "${PACKAGES[@]}"; do
    printf "Restoring %-50s ... " "$pkg"
    out=$($ADB -s "$TARGET_DEVICE" shell pm enable "$pkg" 2>&1)
    echo "$out"
done

echo ""
echo "✅ All packages have been successfully restored!"
