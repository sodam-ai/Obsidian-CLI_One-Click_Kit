@echo off
chcp 65001 >nul 2>&1
setlocal
title NotesMD CLI Kit - Self Check
REM ================================================================
REM  NotesMD CLI - One-Click Kit : Self Check (diagnosis launcher)
REM  ASCII-only launcher. Korean UI lives in lib\selfcheck.ps1 (UTF-8 BOM).
REM ================================================================
set "HERE=%~dp0"

where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!] PowerShell not found. This kit needs Windows PowerShell.
    echo     Press any key to close...
    pause >nul & endlocal & exit /b 1
)

if not exist "%HERE%lib\selfcheck.ps1" (
    echo.
    echo [!] Cannot find: lib\selfcheck.ps1
    echo     Keep ALL files together, and unzip the whole kit
    echo     INCLUDING the lib folder.
    echo.
    echo     Press any key to close...
    pause >nul & endlocal & exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%HERE%lib\selfcheck.ps1"
endlocal
exit /b 0
