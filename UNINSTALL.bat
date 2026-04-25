@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title NotesMD CLI - Uninstaller
REM ================================================================
REM  NotesMD CLI - Safe Uninstaller  v13
REM  SAFE: Obsidian vaults and .md files are NEVER deleted
REM  Removes: bin\notesmd-cli.exe  Scoop install  PATH entry
REM  100%% ASCII  CRLF  no BOM  no goto-in-loop
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

set "INSTALL_DIR=%USERPROFILE%\bin"
set "NOTES_DIRECT=%INSTALL_DIR%\notesmd-cli.exe"
set "NOTES_SCOOP_DIR=%USERPROFILE%\scoop\apps\notesmd-cli"
set "SCOOP_SHIMS=%USERPROFILE%\scoop\shims"

echo.
echo =====================================================
echo     NotesMD CLI  -  Safe Uninstaller
echo =====================================================
echo.
echo  SAFE: Your Obsidian vaults and .md files will NOT
echo        be deleted. Only the CLI tool is removed.
echo.
echo  Will remove:
echo    Direct install: %NOTES_DIRECT%
echo    Scoop install : %NOTES_SCOOP_DIR% (if present)
echo    PATH entry    : %INSTALL_DIR%
echo.

set "HAS_DIRECT=0"
set "HAS_SCOOP=0"
if exist "%NOTES_DIRECT%"             set "HAS_DIRECT=1"
if exist "%NOTES_SCOOP_DIR%\current" set "HAS_SCOOP=1"

if "!HAS_DIRECT!"=="0" if "!HAS_SCOOP!"=="0" (
    where notesmd-cli >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [INFO] notesmd-cli is not installed. Nothing to do.
        echo.
        echo  Press any key to close...
        pause >nul
        endlocal
        exit /b 0
    )
)

set "CVER=unknown"
if exist "%NOTES_DIRECT%" (
    for /f "tokens=*" %%i in ('"%NOTES_DIRECT%" --version 2^>nul') do set "CVER=%%i"
)
echo  Installed version: !CVER!
echo.
echo [WARN] This will permanently remove notesmd-cli.
echo.
set "CF=" & set /p "CF=  Type uninstall to confirm (other = cancel): "
if /i "!CF!" NEQ "uninstall" (
    echo.
    echo [INFO] Cancelled. No changes made.
    echo.
    echo  Press any key to close...
    pause >nul
    endlocal
    exit /b 0
)
echo.

REM ---- [1/4] Direct install ----
echo [1/4] Removing direct install...
if exist "%NOTES_DIRECT%" (
    del /f /q "%NOTES_DIRECT%" >nul 2>&1
    if not exist "%NOTES_DIRECT%" (
        echo [OK]   Removed: %NOTES_DIRECT%
    ) else (
        echo [WARN] Could not delete (file in use?): %NOTES_DIRECT%
    )
) else (
    echo [OK]   Not found (skipped).
)

REM ---- [2/4] Scoop install ----
echo.
echo [2/4] Checking Scoop install...
if exist "%NOTES_SCOOP_DIR%" (
    echo  Found: %NOTES_SCOOP_DIR%
    set "DS=" & set /p "DS=  Remove Scoop install? [yes/no]: "
    if /i "!DS!"=="yes" (
        rd /s /q "%NOTES_SCOOP_DIR%" >nul 2>&1
        if not exist "%NOTES_SCOOP_DIR%" (
            echo [OK]   Removed.
        ) else echo [WARN] Could not fully remove.
    ) else echo [SKIP] Kept.
    if exist "%SCOOP_SHIMS%\notesmd-cli.exe" del /f /q "%SCOOP_SHIMS%\notesmd-cli.exe" >nul 2>&1
    if exist "%SCOOP_SHIMS%\notesmd-cli.cmd" del /f /q "%SCOOP_SHIMS%\notesmd-cli.cmd" >nul 2>&1
) else (
    echo [OK]   Not found (skipped).
)

REM ---- [3/4] Config files ----
echo.
echo [3/4] Checking config files...
set "CFOUND=0"
if exist "%USERPROFILE%\.config\notesmd-cli" ( echo  Found: %USERPROFILE%\.config\notesmd-cli & set "CFOUND=1" )
if exist "%APPDATA%\notesmd-cli" ( echo  Found: %APPDATA%\notesmd-cli & set "CFOUND=1" )
if exist "%LOCALAPPDATA%\notesmd-cli" ( echo  Found: %LOCALAPPDATA%\notesmd-cli & set "CFOUND=1" )
if exist "%USERPROFILE%\.notesmd-cli" ( echo  Found: %USERPROFILE%\.notesmd-cli & set "CFOUND=1" )
if exist "%USERPROFILE%\.notesmd" ( echo  Found: %USERPROFILE%\.notesmd & set "CFOUND=1" )
if "!CFOUND!"=="0" (
    echo [OK]   No config files found.
) else (
    set "DC=" & set /p "DC=  Delete config files? [yes/no]: "
    if /i "!DC!"=="yes" (
        if exist "%USERPROFILE%\.config\notesmd-cli" rd /s /q "%USERPROFILE%\.config\notesmd-cli" >nul 2>&1
        if exist "%APPDATA%\notesmd-cli" rd /s /q "%APPDATA%\notesmd-cli" >nul 2>&1
        if exist "%LOCALAPPDATA%\notesmd-cli" rd /s /q "%LOCALAPPDATA%\notesmd-cli" >nul 2>&1
        if exist "%USERPROFILE%\.notesmd-cli" rd /s /q "%USERPROFILE%\.notesmd-cli" >nul 2>&1
        if exist "%USERPROFILE%\.notesmd" rd /s /q "%USERPROFILE%\.notesmd" >nul 2>&1
        echo [OK]   Deleted.
    ) else echo [SKIP] Kept.
)

REM ---- [4/4] PATH cleanup (certutil method) ----
echo.
echo [4/4] Removing from PATH...
set "NOTESMD_REMOVE_DIR=%INSTALL_DIR%"
del /f /q "%TEMP%\nm_path.b64" 2>nul
del /f /q "%TEMP%\nm_path.ps1" 2>nul
echo -----BEGIN CERTIFICATE----- > "%TEMP%\nm_path.b64"
echo JGQgPSAkZW52Ok5PVEVTTURfUkVNT1ZFX0RJUgokcCA9IFtFbnZpcm9ubWVudF06 >> "%TEMP%\nm_path.b64"
echo OkdldEVudmlyb25tZW50VmFyaWFibGUoJ1BBVEgnLCAnVXNlcicpCiRuID0gKCRw >> "%TEMP%\nm_path.b64"
echo IC1zcGxpdCAnOycgfCBXaGVyZS1PYmplY3QgeyAkXyAtbmUgJGQgfSkgLWpvaW4g >> "%TEMP%\nm_path.b64"
echo JzsnCltFbnZpcm9ubWVudF06OlNldEVudmlyb25tZW50VmFyaWFibGUoJ1BBVEgn >> "%TEMP%\nm_path.b64"
echo LCAkbiwgJ1VzZXInKQpXcml0ZS1Ib3N0ICdbT0tdIFBBVEggdXBkYXRlZC4nCg== >> "%TEMP%\nm_path.b64"
echo -----END CERTIFICATE----- >> "%TEMP%\nm_path.b64"
certutil -decode "%TEMP%\nm_path.b64" "%TEMP%\nm_path.ps1" >nul 2>&1
del /f /q "%TEMP%\nm_path.b64" 2>nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\nm_path.ps1"
del /f /q "%TEMP%\nm_path.ps1" 2>nul

echo.
echo ---- Final check ----
if not exist "%NOTES_DIRECT%" (
    where notesmd-cli >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [OK]   notesmd-cli fully removed.
    ) else (
        echo [INFO] Still in PATH. Open new terminal to confirm.
    )
) else (
    echo [WARN] Direct exe still present.
)

echo.
echo =====================================================
echo     UNINSTALL COMPLETE
echo =====================================================
echo.
echo  Your Obsidian vaults and notes are safe.
echo  Reinstall anytime: run INSTALL.bat.
echo.
echo  Press any key to close...
pause >nul
endlocal
exit /b 0
