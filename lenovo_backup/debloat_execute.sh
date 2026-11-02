#!/usr/bin/env bash
DEVICE="192.168.34.170:5555"
ADB="/opt/homebrew/bin/adb"

PACKAGES=(
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
)

echo "Starting debloat process on $DEVICE..."
for pkg in "${PACKAGES[@]}"; do
    printf "Disabling %-50s ... " "$pkg"
    out=$($ADB -s "$DEVICE" shell pm disable-user --user 0 "$pkg" 2>&1)
    echo "$out"
done

echo "Debloat execution complete."

