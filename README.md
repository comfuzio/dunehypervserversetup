# Dune: Awakening Self-Hosted Server Setup

A Windows batch script that automates downloading and updating the **Dune: Awakening** self-hosted dedicated server using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD).

## What the script does

`Install_Update_Dune_Awakening_Server.bat` performs the following steps:

1. Creates the SteamCMD folder (`C:\SteamCMD`) and the server install folder (`C:\GameServers\DuneAwakeningServer`) if they do not already exist.
2. Downloads SteamCMD from the official Valve URL and extracts it with PowerShell, if `steamcmd.exe` is not already present.
3. Runs SteamCMD once to let it self-update.
4. Logs in anonymously and runs `app_update <APP_ID> validate` to install or update the Dune: Awakening server files into the server folder.
5. Reports success, or prints diagnostic guidance if SteamCMD returns a non-zero exit code.

The same script is used for both the initial install and subsequent updates &mdash; just run it again whenever a new server build is released.

## Requirements

- Windows 10 / 11 or Windows Server.
- An account with permission to create the configured folders (or run the script as Administrator).
- Internet access to `steamcdn-a.akamaihd.net` and the Steam content servers.
- PowerShell available on `PATH` (default on all supported Windows versions). It is used only to download and unzip SteamCMD.

## How to run it

1. Download or clone this repository.
2. (Optional) Open `Install_Update_Dune_Awakening_Server.bat` in a text editor and adjust the variables at the top &mdash; see [Configuration](#configuration) below.
3. Right-click the `.bat` file and choose **Run as administrator** (recommended, especially if installing under `C:\`).
4. Wait for SteamCMD to finish. The download is several GB and may take a while depending on your connection and disk speed.
5. When you see the `SUCCESS` banner, the server files are ready in the configured `SERVER_DIR`.

After a successful install, follow Funcom's official self-hosted server configuration / Hyper-V setup instructions to actually launch and configure the server &mdash; this script only handles the file install/update step.

## Configuration

The variables at the top of the script can be edited to suit your environment:

| Variable | Default | Purpose |
| --- | --- | --- |
| `APP_ID` | `3104830` | Steam app ID. `3104830` = Dune: Awakening Public Test Client (PTC) server. `1192040` = live server tool listing. |
| `STEAMCMD_DIR` | `C:\SteamCMD` | Where SteamCMD itself is installed. |
| `SERVER_DIR` | `C:\GameServers\DuneAwakeningServer` | Where the Dune: Awakening server files are installed. |
| `STEAMCMD_URL` | Valve's official URL | Source for the SteamCMD zip. |
| `PAUSE_ON_EXIT` | `1` | Set to `0` to skip the `pause` at the end (useful for unattended/scheduled runs). |

## Things to be aware of

- **PTC vs live app ID.** The script defaults to the Public Test Client server (`3104830`). If Funcom moves the self-hosted package to the live tool listing, change `APP_ID` to `1192040` (or whatever ID Funcom publishes at that time).
- **Anonymous login may not always work.** If SteamCMD reports `No subscription`, the package is not currently available for anonymous accounts. The script prints the manual command to run with your own Steam credentials:

  ```
  "C:\SteamCMD\steamcmd.exe" +force_install_dir "C:\GameServers\DuneAwakeningServer" +login YOUR_STEAM_USERNAME +app_update 3104830 validate +quit
  ```

- **Run as Administrator** if you keep the default `C:\` paths. Standard user accounts usually cannot create folders directly under the system drive. Alternatively, change `STEAMCMD_DIR` and `SERVER_DIR` to a folder your account already has write access to.
- **Antivirus / TLS inspection.** If the SteamCMD download step fails, antivirus, corporate TLS interception, or firewall rules are the most common causes. The script surfaces this as a `[ERROR] PowerShell failed to download or extract SteamCMD.` message.
- **Re-running is safe.** SteamCMD is content-addressed and the script uses `validate`, so running the batch file again will only download changed/missing files. Use it as your update routine.
- **Disk space.** Make sure the drive holding `SERVER_DIR` has enough free space for the server files plus headroom for updates (Steam typically needs roughly 2x the install size while patching).
- **Firewall / port forwarding.** This script does **not** open any firewall ports or configure the server. You still need to follow Funcom's instructions for ports, server config files, and (if applicable) Hyper-V setup.
- **No uninstaller.** To remove the server, simply delete the `SERVER_DIR` folder. SteamCMD itself can be removed by deleting `STEAMCMD_DIR`.

## Troubleshooting

| Symptom | Likely cause / fix |
| --- | --- |
| `Could not create one of the required folders.` | Run as Administrator, or change the paths at the top of the script to a writable location. |
| `PowerShell failed to download or extract SteamCMD.` | Check internet access, antivirus, TLS inspection, or firewall rules. |
| `SteamCMD returned exit code <N>.` | Run SteamCMD manually with the command printed by the script. If it says `No subscription`, log in with a Steam account that owns the entitlement instead of `anonymous`. |
| Script window closes immediately | Set `PAUSE_ON_EXIT=1` (the default) and run the file directly, or run it from an already-open `cmd` window so you can read the output. |

## License

No license is currently specified for this script. Treat it as provided as-is, with no warranty.
