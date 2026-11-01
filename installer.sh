#!/data/data/com.termux/files/usr/bin/bash
# installer.sh - Full provisioning in one run: Termux + termux-adb setup, download
# hmdm.apk (MDM agent) from this repo, install it on the connected target device,
# and set it as Device Owner.
#
# curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/installer.sh -o installer.sh
# bash installer.sh
#
# WARNING: step 6 (set-device-owner) is sensitive and hard to reverse. Only run this
# against a device you are authorized to enroll, with USB debugging already connected
# and authorized (termux-adb devices shows it as "device", not "unauthorized").

set -euo pipefail

echo "== 1/6: Updating Termux packages =="
pkg update -y
pkg upgrade -y

echo "== 2/6: Installing termux-adb build/runtime deps =="
pkg install -y curl coreutils gnupg wget

echo "== 3/6: Adding the termux-adb apt repo and installing it =="
if [ ! -f "$PREFIX/etc/apt/sources.list.d/termux-adb.list" ]; then
  mkdir -p "$PREFIX/etc/apt/sources.list.d"
  echo "deb https://nohajc.github.io termux extras" > "$PREFIX/etc/apt/sources.list.d/termux-adb.list"
  wget -qP "$PREFIX/etc/apt/trusted.gpg.d" https://nohajc.github.io/nohajc.gpg
  pkg update -y
else
  echo "Repo already installed"
fi
pkg install -y termux-adb

echo "== 4/6: Checking for a connected & authorized device =="
termux-adb devices

echo "== 5/6: Downloading and installing hmdm.apk =="
curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/hmdm.apk -o ~/hmdm.apk
termux-adb install -r ~/hmdm.apk

echo "== 6/6: Setting hmdm as Device Owner =="
termux-adb shell dpm set-device-owner com.hmdm.launcher/.AdminReceiver

echo "All done. Continue Headwind POS enrollment per your org's SOP."
