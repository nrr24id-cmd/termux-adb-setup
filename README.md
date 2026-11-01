# termux-adb-setup

One-shot script to set up Termux and install termux-adb (ADB/fastboot over USB inside Termux), combining the manual steps from the setup guide into a single automated run, hosted entirely in this repo.

Full step-by-step guide: [PANDUAN-TERMUX-ADB.md](PANDUAN-TERMUX-ADB.md).

## Usage

In Termux on the Android device:

```sh
curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/install-termux-adb.sh -o install-termux-adb.sh
bash install-termux-adb.sh
```

The script will:

1. `pkg update && pkg upgrade`
2. Install `curl coreutils gnupg wget`
3. Add the termux-adb apt repo + GPG key and install `termux-adb`
4. Verify with `termux-adb version` and `termux-fastboot --version`

Review `install-termux-adb.sh` before running it, same as you would any script from the internet.

Everything the script runs is inlined in this repo — it no longer downloads a second script from a third party at run time. One thing that can't be moved: the actual `termux-adb`/`termux-fastboot` package is still published from its upstream apt repo (`nohajc.github.io`, the [nohajc/termux-adb](https://github.com/nohajc/termux-adb) project), the same way installing `curl` pulls from Termux's own package mirrors — that's where the compiled package is maintained, not something this repo re-hosts.

This covers steps 2–3 of the full guide above (Termux setup + ADB installer). Step 4 (verifying the ADB connection) is manual; see the guide for that.

## Pinned Termux / Termux:API APKs

[Release `termux-v118`](https://github.com/nrr24id-cmd/termux-adb-setup/releases/tag/termux-v118) has the exact Termux + Termux:API versions tested to work with this setup:

- [com.termux_118.apk](https://github.com/nrr24id-cmd/termux-adb-setup/releases/download/termux-v118/com.termux_118.apk)
- [com.termux.api_51.apk](https://github.com/nrr24id-cmd/termux-adb-setup/releases/download/termux-v118/com.termux.api_51.apk)

Use these instead of F-Droid when you want everyone on the same tested version. See [PANDUAN-TERMUX-ADB.md](PANDUAN-TERMUX-ADB.md) for install + permission steps.

## installer.sh — full provisioning (Termux + ADB + MDM agent + Device Owner)

```sh
curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/installer.sh -o installer.sh
bash installer.sh
```

In addition to everything `install-termux-adb.sh` does, this also downloads `hmdm.apk` from this repo, installs it on the connected target device, and runs `dpm set-device-owner` on it — all in one run.

> **This is a sensitive, hard-to-reverse operation.** `set-device-owner` only works correctly if the target device is in the right provisioning state and you are authorized to enroll it into your organization's MDM. Only run this against a device you own or manage, with USB debugging already connected and authorized (`termux-adb devices` shows `device`, not `unauthorized`). If it fails, do not re-run blindly or factory-reset — check the error and your org's MDM/IT process first.
