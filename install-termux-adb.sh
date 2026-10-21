#!/data/data/com.termux/files/usr/bin/bash
# Full-auto installer: Termux setup + termux-adb (ADB/fastboot over USB in Termux)
# Combines the steps from the "Instal Termux di HP host" / "Instal ADB untuk Termux" guide
# into one unattended script. Run this INSIDE Termux on the Android device.
#
# The install steps below are vendored from github.com/nohajc/termux-adb's install.sh
# (reviewed 2026-10-22) so this script is fully self-contained in this repo — it does
# not fetch another script from a third-party URL at run time.
#
# Note: the termux-adb / termux-fastboot package itself is still an upstream apt
# repository (nohajc.github.io), the same way installing e.g. "curl" pulls from
# Termux's own package mirrors — that's where the compiled package is maintained,
# not something this repo can or should re-host.

set -euo pipefail

echo "== 1/4: Updating Termux packages =="
pkg update -y
pkg upgrade -y

echo "== 2/4: Installing termux-adb build/runtime deps =="
pkg install -y curl coreutils gnupg wget

echo "== 3/4: Adding the termux-adb apt repo and installing it =="
if [ ! -f "$PREFIX/etc/apt/sources.list.d/termux-adb.list" ]; then
  mkdir -p "$PREFIX/etc/apt/sources.list.d"
  echo "deb https://nohajc.github.io termux extras" > "$PREFIX/etc/apt/sources.list.d/termux-adb.list"
  wget -qP "$PREFIX/etc/apt/trusted.gpg.d" https://nohajc.github.io/nohajc.gpg
  pkg update -y
else
  echo "Repo already installed"
fi
pkg install -y termux-adb

echo "== 4/4: Verifying installation =="
termux-adb version
termux-fastboot --version

echo "All done."
