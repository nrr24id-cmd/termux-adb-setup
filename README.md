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
