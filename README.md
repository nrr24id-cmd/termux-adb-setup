# termux-adb-setup

One-shot script to set up Termux and install [termux-adb](https://github.com/nohajc/termux-adb) (ADB/fastboot over USB inside Termux), combining the manual steps from the setup guide into a single automated run.

Full step-by-step guide, including connecting to a SUNMI/DualPOS device, installing an MDM agent APK and the Device Owner step: [PANDUAN-TERMUX-ADB-SUNMI.md](PANDUAN-TERMUX-ADB-SUNMI.md).

## Usage

In Termux on the Android device:

```sh
curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/install-termux-adb.sh -o install-termux-adb.sh
bash install-termux-adb.sh
```

The script will:

1. `pkg update && pkg upgrade`
2. Install `curl`
3. Download `nohajc/termux-adb`'s `install.sh`, print it for review, then run it
4. Verify with `termux-adb version` and `termux-fastboot --version`

Review `install-termux-adb.sh` before running it, same as you would any script from the internet.

This covers steps 2–3 of the full guide above (Termux setup + ADB installer). Steps 4 onward — enabling USB debugging on the SUNMI, verifying the ADB connection, installing the MDM agent APK, and the Device Owner step — are manual and device/organization-specific; see the guide for those.
