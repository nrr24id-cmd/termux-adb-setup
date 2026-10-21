#!/data/data/com.termux/files/usr/bin/bash
# Full-auto installer: Termux setup + termux-adb (ADB/fastboot over USB in Termux)
# Combines the steps from the "Instal Termux di HP host" / "Instal ADB untuk Termux" guide
# into one unattended script. Run this INSIDE Termux on the Android device.
#
# Source of the third-party installer this script downloads and runs:
#   https://github.com/nohajc/termux-adb (raw install.sh, reviewed before use)
# That script adds the nohajc.github.io apt repo + GPG key and installs termux-adb.
# Review it yourself before running if you haven't: curl -fL <url> | less

set -euo pipefail

echo "== 1/5: Updating Termux packages =="
pkg update -y
pkg upgrade -y

echo "== 2/5: Installing curl =="
pkg install -y curl

echo "== 3/5: Downloading termux-adb installer =="
curl -fL https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh -o /tmp/termux-adb-install.sh
echo "---- install.sh content (review) ----"
cat /tmp/termux-adb-install.sh
echo "--------------------------------------"

echo "== 4/5: Running termux-adb installer =="
# 'yes' auto-confirms the upstream script's interactive "apt install" prompt
yes | bash /tmp/termux-adb-install.sh

echo "== 5/5: Verifying installation =="
termux-adb version
termux-fastboot --version

echo "All done."
