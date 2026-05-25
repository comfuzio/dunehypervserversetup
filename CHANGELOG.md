# Changelog

## 1.1.0 - 2026-05-25

### Added
- Interactive startup menu with two modes:
  - **Initial setup**: installs SteamCMD if needed, creates required folders, and installs/updates server files.
  - **Update only**: runs SteamCMD patch/update flow only, for regular dedicated server patching.

### Changed
- Updated default Steam App ID to **4754530**.
- Updated documentation to reflect new app ID and two-mode workflow.

### User Action
- No migration is needed.
- Run the script and choose option **1** once for first-time setup, then option **2** for regular patch updates.
