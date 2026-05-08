@echo off
setlocal EnableExtensions

REM ============================================================
REM Dune: Awakening Self-Hosted Server Installer / Updater
REM Uses SteamCMD to download or update the server files.
REM
REM App IDs:
REM   3104830 = Dune: Awakening Public Test Client Server
REM   1192040 = Dune: Awakening Server / live server tool listing
REM
REM Leave this as 3104830 if you are installing the current PTC
REM self-hosted server package. Change to 1192040 later if Funcom
REM tells you to use the live server tool instead.
REM ============================================================

set "APP_ID=3104830"

REM Where SteamCMD itself will live:
set "STEAMCMD_DIR=C:\SteamCMD"

REM Where the Dune server files will be installed:
set "SERVER_DIR=C:\GameServers\DuneAwakeningServer"

REM Official SteamCMD Windows download:
set "STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
set "STEAMCMD_ZIP=%TEMP%\steamcmd.zip"

REM Set to 0 if you do not want the window to pause at the end.
set "PAUSE_ON_EXIT=1"

echo.
echo ============================================================
echo  Dune: Awakening Server Installer / Updater
echo ============================================================
echo  App ID:       %APP_ID%
echo  SteamCMD:     %STEAMCMD_DIR%
echo  Server Files: %SERVER_DIR%
echo ============================================================
echo.

if not exist "%STEAMCMD_DIR%" (
    echo Creating SteamCMD folder...
    mkdir "%STEAMCMD_DIR%"
    if errorlevel 1 goto folder_error
)

if not exist "%SERVER_DIR%" (
    echo Creating Dune server folder...
    mkdir "%SERVER_DIR%"
    if errorlevel 1 goto folder_error
)

if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
    echo SteamCMD not found. Downloading SteamCMD...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Invoke-WebRequest -Uri '%STEAMCMD_URL%' -OutFile '%STEAMCMD_ZIP%'; Expand-Archive -LiteralPath '%STEAMCMD_ZIP%' -DestinationPath '%STEAMCMD_DIR%' -Force"
    if errorlevel 1 goto steamcmd_download_error

    if not exist "%STEAMCMD_DIR%\steamcmd.exe" goto steamcmd_missing
) else (
    echo SteamCMD found.
)

echo.
echo Updating SteamCMD...
"%STEAMCMD_DIR%\steamcmd.exe" +quit

echo.
echo Installing / updating Dune: Awakening server files...
echo This may take a while depending on your connection and disk speed.
echo.

"%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update %APP_ID% validate +quit
set "STEAMCMD_RESULT=%ERRORLEVEL%"

if not "%STEAMCMD_RESULT%"=="0" goto install_error

echo.
echo ============================================================
echo  SUCCESS
echo ============================================================
echo  Dune server files should now be installed or updated here:
echo  %SERVER_DIR%
echo.
echo  Next step: open the install folder and follow Funcom's
echo  self-hosted server configuration / Hyper-V setup instructions.
echo ============================================================
echo.
goto done

:folder_error
echo.
echo [ERROR] Could not create one of the required folders.
echo Try running this batch file as Administrator, or change the paths
echo at the top of the script to a folder your account can write to.
echo.
goto fail

:steamcmd_download_error
echo.
echo [ERROR] PowerShell failed to download or extract SteamCMD.
echo Check internet access, TLS/SSL inspection, antivirus, or firewall rules.
echo.
goto fail

:steamcmd_missing
echo.
echo [ERROR] SteamCMD download/extract completed, but steamcmd.exe was not found.
echo Check this folder manually:
echo %STEAMCMD_DIR%
echo.
goto fail

:install_error
echo.
echo [ERROR] SteamCMD returned exit code %STEAMCMD_RESULT%.
echo.
echo Things to check:
echo  - If you see "No subscription", anonymous login may not have access yet.
echo    Try running SteamCMD manually and logging in with your Steam account:
echo.
echo    "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login YOUR_STEAM_USERNAME +app_update %APP_ID% validate +quit
echo.
echo  - If the PTC package closes or moves, try changing APP_ID at the top:
echo      3104830 = PTC server
echo      1192040 = live server tool listing
echo.
goto fail

:fail
if "%PAUSE_ON_EXIT%"=="1" pause
exit /b 1

:done
if "%PAUSE_ON_EXIT%"=="1" pause
exit /b 0
