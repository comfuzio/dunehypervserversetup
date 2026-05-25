# Dune: Awakening Self-Hosted Server Setup

Current version: **1.1.0**

A Windows batch script that automates downloading and updating the **Dune: Awakening** self-hosted dedicated server using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD).

## What the script does

`Install_Update_Dune_Awakening_Server.bat` now starts with a menu and supports two flows:

1. **Initial setup**
   - Creates the SteamCMD folder (`C:\SteamCMD`) and server install folder (`C:\GameServers\DuneAwakeningServer`) if needed.
   - Downloads SteamCMD if `steamcmd.exe` is not present.
   - Runs SteamCMD once to self-update.
   - Runs `app_update <APP_ID> validate` to install/update server files.
2. **Update only**
   - Skips setup and download steps.
   - Verifies SteamCMD and server install folder already exist.
   - Runs SteamCMD patch/update only (`app_update <APP_ID> validate`).

## Requirements

- Windows 10 / 11 or Windows Server.
- An account with permission to create the configured folders (or run the script as Administrator).
- Internet access to `steamcdn-a.akamaihd.net` and the Steam content servers.
- PowerShell available on `PATH` (default on all supported Windows versions). It is used only to download and unzip SteamCMD during initial setup.

## How to run it

1. Download or clone this repository.
2. (Optional) Open `Install_Update_Dune_Awakening_Server.bat` in a text editor and adjust the variables at the top &mdash; see [Configuration](#configuration).
3. Right-click the `.bat` file and choose **Run as administrator** (recommended, especially if installing under `C:\`).
4. Choose:
   - **1** for first-time setup.
   - **2** for regular server patch updates.
5. Wait for SteamCMD to finish.

## Configuration

The variables at the top of the script can be edited to suit your environment:

| Variable | Default | Purpose |
| --- | --- | --- |
| `APP_ID` | `4754530` | Steam app ID for the Dune: Awakening dedicated server. |
| `STEAMCMD_DIR` | `C:\SteamCMD` | Where SteamCMD itself is installed. |
| `SERVER_DIR` | `C:\GameServers\DuneAwakeningServer` | Where the Dune: Awakening server files are installed. |
| `STEAMCMD_URL` | Valve's official URL | Source for the SteamCMD zip. |
| `PAUSE_ON_EXIT` | `1` | Set to `0` to skip the `pause` at the end (useful for unattended/scheduled runs). |

## Things to be aware of

- **Use option 1 first.** Update-only mode requires existing SteamCMD and server install folders.
- **Anonymous login may not always work.** If SteamCMD reports `No subscription`, log in with a Steam account that has entitlement.
- **Run as Administrator** if you keep default `C:\` paths, or change paths to a writable location.
- **Re-running is safe.** SteamCMD plus `validate` only re-downloads changed/missing files.
- **This script only installs/updates files.** Server runtime configuration, firewall, ports, and Hyper-V setup are still separate.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

No license is currently specified for this script. Treat it as provided as-is, with no warranty.
