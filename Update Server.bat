@echo off
setlocal EnableExtensions

REM ============================================================
REM Dune: Awakening Dedicated Server Update-Only Script
REM Uses SteamCMD to update existing server files only.
REM
REM App IDs:
REM   4754530 = Dune: Awakening Dedicated Server
REM ============================================================

set "APP_ID=4754530"

REM Where SteamCMD itself will live:
set "STEAMCMD_DIR=C:\SteamCMD"

REM Where the Dune server files will be installed:
set "SERVER_DIR=C:\GameServers\DuneAwakeningServer"

REM Set to 0 if you do not want the window to pause at the end.
set "PAUSE_ON_EXIT=1"

set "OPERATION_NAME=Update"

echo.
echo ============================================================
echo  Dune: Awakening Server Update-Only
echo ============================================================
echo  App ID:       %APP_ID%
echo  SteamCMD:     %STEAMCMD_DIR%
echo  Server Files: %SERVER_DIR%
echo ============================================================
echo.

if not exist "%STEAMCMD_DIR%\steamcmd.exe" goto update_precheck_steamcmd_missing
if not exist "%SERVER_DIR%" goto update_precheck_server_missing

echo Updating SteamCMD...
"%STEAMCMD_DIR%\steamcmd.exe" +quit

echo.
echo Running normal server update (no validation)...
echo This may take a while depending on your connection and disk speed.
echo.

"%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login anonymous +app_update %APP_ID% +quit
set "STEAMCMD_RESULT=%ERRORLEVEL%"

if not "%STEAMCMD_RESULT%"=="0" goto install_error

goto success

:success
echo.
echo ============================================================
echo  SUCCESS
echo ============================================================
echo  %OPERATION_NAME% completed successfully.
echo  Dune server files are here:
echo  %SERVER_DIR%
echo ============================================================
echo.
goto done

:update_precheck_steamcmd_missing
echo.
echo [ERROR] Update-only mode requires an existing SteamCMD install.
echo steamcmd.exe was not found at:
echo  %STEAMCMD_DIR%\steamcmd.exe
echo.
echo Run Install_Update_Dune_Awakening_Server.bat and choose
echo option [1] Initial setup first.
echo.
goto fail

:update_precheck_server_missing
echo.
echo [ERROR] Update-only mode requires an existing server install folder.
echo Folder not found:
echo  %SERVER_DIR%
echo.
echo Run Install_Update_Dune_Awakening_Server.bat and choose
echo option [1] Initial setup first.
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
echo    "%STEAMCMD_DIR%\steamcmd.exe" +force_install_dir "%SERVER_DIR%" +login YOUR_STEAM_USERNAME +app_update %APP_ID% +quit
echo.
goto fail

:fail
if "%PAUSE_ON_EXIT%"=="1" pause
exit /b 1

:done
if "%PAUSE_ON_EXIT%"=="1" pause
exit /b 0
