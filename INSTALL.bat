@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title NotesMD CLI - Installer
REM ================================================================
REM  NotesMD CLI - One-Click Installer  v14
REM  GitHub: https://github.com/Yakitrak/notesmd-cli
REM  Method: certutil decode (safe base64 chunks)
REM  v14 FIX: MZ header validation + PS tar.gz fallback
REM  100%% ASCII  CRLF  no BOM  no goto-in-loop
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

set "INSTALL_DIR=%USERPROFILE%\bin"
set "NOTES_EXE=%INSTALL_DIR%\notesmd-cli.exe"

echo.
echo =====================================================
echo     NotesMD CLI - One-Click Installer
echo     Obsidian Terminal Tool  (Direct Download)
echo =====================================================
echo  Script      : %SCRIPT_DIR%
echo  Install dir : %INSTALL_DIR%
echo  User        : %USERPROFILE%
echo.

REM ---- [1/4] PowerShell ----
echo [1/4] Checking PowerShell...
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell not found.
    echo  Press any key to close...
    pause >nul & endlocal & exit /b 1
)
set "PSVER=5"
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$PSVersionTable.PSVersion.Major" 2^>nul') do set "PSVER=%%i"
echo [OK]    PowerShell v!PSVER! found.

REM ---- [2/4] certutil + install dir ----
echo.
echo [2/4] Checking prerequisites...
where certutil >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] certutil not found. Built into all Windows versions.
    echo  Press any key to close...
    pause >nul & endlocal & exit /b 1
)
echo [OK]    certutil found.
where tar >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO]  tar.exe not found. PS fallback will be used.
) else (
    echo [OK]    tar.exe found.
)
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Cannot create: %INSTALL_DIR%
        echo  Press any key to close...
        pause >nul & endlocal & exit /b 1
    )
    echo [OK]    Created: %INSTALL_DIR%
) else (
    echo [OK]    Install dir: %INSTALL_DIR%
)

REM ---- [3/4] Existing install ----
echo.
echo [3/4] Checking existing installation...
if exist "%NOTES_EXE%" (
    set "OV=unknown"
    for /f "tokens=*" %%i in ('"%NOTES_EXE%" --version 2^>nul') do set "OV=%%i"
    echo [INFO]  Installed: !OV!
) else (
    echo [INFO]  Not installed yet.
)
if exist "%USERPROFILE%\scoop\apps\notesmd-cli\current\notesmd-cli.exe" (
    echo [INFO]  Also found via Scoop.
)

REM ---- [4/4] Download + install (certutil -> PS1) ----
echo.
echo [4/4] Downloading from GitHub Releases...
echo       v14: MZ validation + PS tar.gz fallback included
echo       Please wait (30-120 seconds)...
echo.
set "NOTESMD_INSTALL_DIR=%INSTALL_DIR%"

del /f /q "%TEMP%\nm_inst.b64" 2>nul
del /f /q "%TEMP%\nm_inst.ps1" 2>nul
echo -----BEGIN CERTIFICATE----- > "%TEMP%\nm_inst.b64"
echo JEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICJTdG9wIgokZCA9ICRlbnY6Tk9URVNN >> "%TEMP%\nm_inst.b64"
echo RF9JTlNUQUxMX0RJUgppZiAoLW5vdCAkZCkgeyAkZCA9ICIkZW52OlVTRVJQUk9G >> "%TEMP%\nm_inst.b64"
echo SUxFXGJpbiIgfQokeCA9IEpvaW4tUGF0aCAkZCAibm90ZXNtZC1jbGkuZXhlIgpb >> "%TEMP%\nm_inst.b64"
echo TmV0LlNlcnZpY2VQb2ludE1hbmFnZXJdOjpTZWN1cml0eVByb3RvY29sID0gW05l >> "%TEMP%\nm_inst.b64"
echo dC5TZWN1cml0eVByb3RvY29sVHlwZV06OlRsczEyCmlmICgtbm90IChUZXN0LVBh >> "%TEMP%\nm_inst.b64"
echo dGggJGQpKSB7IE5ldy1JdGVtIC1JdGVtVHlwZSBEaXJlY3RvcnkgLVBhdGggJGQg >> "%TEMP%\nm_inst.b64"
echo fCBPdXQtTnVsbCB9CgpmdW5jdGlvbiBUZXN0LU1aKCRwYXRoKSB7CiAgICB0cnkg >> "%TEMP%\nm_inst.b64"
echo ewogICAgICAgICRiID0gW1N5c3RlbS5JTy5GaWxlXTo6UmVhZEFsbEJ5dGVzKCRw >> "%TEMP%\nm_inst.b64"
echo YXRoKQogICAgICAgIHJldHVybiAoJGIuQ291bnQgLWd0IDIgLWFuZCAkYlswXSAt >> "%TEMP%\nm_inst.b64"
echo ZXEgMHg0RCAtYW5kICRiWzFdIC1lcSAweDVBKQogICAgfSBjYXRjaCB7IHJldHVy >> "%TEMP%\nm_inst.b64"
echo biAkZmFsc2UgfQp9CgpmdW5jdGlvbiBFeHRyYWN0LVRhckd6KCR0YXJHelBhdGgs >> "%TEMP%\nm_inst.b64"
echo ICRkZXN0RGlyKSB7CiAgICAjIE1ldGhvZCAxOiBXaW5kb3dzIGJ1aWx0LWluIHRh >> "%TEMP%\nm_inst.b64"
echo ci5leGUKICAgIFdyaXRlLUhvc3QgIltJTkZPXSBUcnlpbmcgdGFyLmV4ZS4uLiIK >> "%TEMP%\nm_inst.b64"
echo ICAgICR0YXJQYXRoID0gIiRlbnY6U3lzdGVtUm9vdFxTeXN0ZW0zMlx0YXIuZXhl >> "%TEMP%\nm_inst.b64"
echo IgogICAgaWYgKC1ub3QgKFRlc3QtUGF0aCAkdGFyUGF0aCkpIHsgJHRhclBhdGgg >> "%TEMP%\nm_inst.b64"
echo PSAidGFyLmV4ZSIgfQogICAgJG91dCA9ICYgJHRhclBhdGggLXh6ZiAkdGFyR3pQ >> "%TEMP%\nm_inst.b64"
echo YXRoIC1DICRkZXN0RGlyIDI+JjEKICAgIGlmICgkTEFTVEVYSVRDT0RFIC1lcSAw >> "%TEMP%\nm_inst.b64"
echo KSB7CiAgICAgICAgV3JpdGUtSG9zdCAiW09LXSAgIHRhci5leGUgZXh0cmFjdGlv >> "%TEMP%\nm_inst.b64"
echo biBzdWNjZWVkZWQuIgogICAgICAgIHJldHVybiAkdHJ1ZQogICAgfQogICAgV3Jp >> "%TEMP%\nm_inst.b64"
echo dGUtSG9zdCAiW1dBUk5dIHRhci5leGUgZmFpbGVkIChjb2RlICRMQVNURVhJVENP >> "%TEMP%\nm_inst.b64"
echo REUpOiAkb3V0IgogICAgV3JpdGUtSG9zdCAiW0lORk9dIFRyeWluZyBQb3dlclNo >> "%TEMP%\nm_inst.b64"
echo ZWxsIEdaaXArc3RyZWFtIGZhbGxiYWNrLi4uIgogICAgIyBNZXRob2QgMjogUHVy >> "%TEMP%\nm_inst.b64"
echo ZSBQb3dlclNoZWxsIEdaaXAgZGVjb21wcmVzcyB0aGVuIHRhciBwYXJzZQogICAg >> "%TEMP%\nm_inst.b64"
echo dHJ5IHsKICAgICAgICAkZ3pTdHJlYW0gPSBbU3lzdGVtLklPLkZpbGVdOjpPcGVu >> "%TEMP%\nm_inst.b64"
echo UmVhZCgkdGFyR3pQYXRoKQogICAgICAgICRnekRlYyA9IE5ldy1PYmplY3QgU3lz >> "%TEMP%\nm_inst.b64"
echo dGVtLklPLkNvbXByZXNzaW9uLkdaaXBTdHJlYW0oJGd6U3RyZWFtLCBbU3lzdGVt >> "%TEMP%\nm_inst.b64"
echo LklPLkNvbXByZXNzaW9uLkNvbXByZXNzaW9uTW9kZV06OkRlY29tcHJlc3MpCiAg >> "%TEMP%\nm_inst.b64"
echo ICAgICAgJHRhckJ5dGVzID0gTmV3LU9iamVjdCBTeXN0ZW0uQ29sbGVjdGlvbnMu >> "%TEMP%\nm_inst.b64"
echo R2VuZXJpYy5MaXN0W2J5dGVdCiAgICAgICAgJGJ1ZiA9IE5ldy1PYmplY3QgYnl0 >> "%TEMP%\nm_inst.b64"
echo ZVtdIDY1NTM2CiAgICAgICAgZG8gewogICAgICAgICAgICAkcmVhZCA9ICRnekRl >> "%TEMP%\nm_inst.b64"
echo Yy5SZWFkKCRidWYsIDAsICRidWYuTGVuZ3RoKQogICAgICAgICAgICBpZiAoJHJl >> "%TEMP%\nm_inst.b64"
echo YWQgLWd0IDApIHsgJHRhckJ5dGVzLkFkZFJhbmdlKCRidWZbMC4uKCRyZWFkLTEp >> "%TEMP%\nm_inst.b64"
echo XSkgfQogICAgICAgIH0gd2hpbGUgKCRyZWFkIC1ndCAwKQogICAgICAgICRnekRl >> "%TEMP%\nm_inst.b64"
echo Yy5DbG9zZSgpOyAkZ3pTdHJlYW0uQ2xvc2UoKQogICAgICAgICRhcnIgPSAkdGFy >> "%TEMP%\nm_inst.b64"
echo Qnl0ZXMuVG9BcnJheSgpCiAgICAgICAgJHBvcyA9IDAKICAgICAgICB3aGlsZSAo >> "%TEMP%\nm_inst.b64"
echo JHBvcyArIDUxMiAtbGUgJGFyci5MZW5ndGgpIHsKICAgICAgICAgICAgJGhkciA9 >> "%TEMP%\nm_inst.b64"
echo ICRhcnJbJHBvcy4uKCRwb3MrNTExKV0KICAgICAgICAgICAgJG5hbWVCeXRlcyA9 >> "%TEMP%\nm_inst.b64"
echo ICRoZHJbMC4uOTldCiAgICAgICAgICAgICRudWxsSWR4ID0gW0FycmF5XTo6SW5k >> "%TEMP%\nm_inst.b64"
echo ZXhPZigkbmFtZUJ5dGVzLCBbYnl0ZV0wKQogICAgICAgICAgICBpZiAoJG51bGxJ >> "%TEMP%\nm_inst.b64"
echo ZHggLWVxIDApIHsgYnJlYWsgfQogICAgICAgICAgICBpZiAoJG51bGxJZHggLWd0 >> "%TEMP%\nm_inst.b64"
echo IDApIHsgJG5hbWVCeXRlcyA9ICRuYW1lQnl0ZXNbMC4uKCRudWxsSWR4LTEpXSB9 >> "%TEMP%\nm_inst.b64"
echo CiAgICAgICAgICAgICRuYW1lID0gW1N5c3RlbS5UZXh0LkVuY29kaW5nXTo6QVND >> "%TEMP%\nm_inst.b64"
echo SUkuR2V0U3RyaW5nKCRuYW1lQnl0ZXMpCiAgICAgICAgICAgICRzaXplT2N0YWwg >> "%TEMP%\nm_inst.b64"
echo PSBbU3lzdGVtLlRleHQuRW5jb2RpbmddOjpBU0NJSS5HZXRTdHJpbmcoJGhkclsx >> "%TEMP%\nm_inst.b64"
echo MjQuLjEzNF0pLlRyaW0oKS5UcmltKFtjaGFyXTApCiAgICAgICAgICAgICRzaXpl >> "%TEMP%\nm_inst.b64"
echo ID0gMAogICAgICAgICAgICBpZiAoJHNpemVPY3RhbCAtbWF0Y2ggIl5bMC03XSsk >> "%TEMP%\nm_inst.b64"
echo IikgeyAkc2l6ZSA9IFtDb252ZXJ0XTo6VG9JbnQ2NCgkc2l6ZU9jdGFsLCA4KSB9 >> "%TEMP%\nm_inst.b64"
echo CiAgICAgICAgICAgICRwb3MgKz0gNTEyCiAgICAgICAgICAgIGlmICgkc2l6ZSAt >> "%TEMP%\nm_inst.b64"
echo Z3QgMCkgewogICAgICAgICAgICAgICAgJGZpbGVEYXRhID0gJGFyclskcG9zLi4o >> "%TEMP%\nm_inst.b64"
echo JHBvcyskc2l6ZS0xKV0KICAgICAgICAgICAgICAgICRvdXRQYXRoID0gSm9pbi1Q >> "%TEMP%\nm_inst.b64"
echo YXRoICRkZXN0RGlyICRuYW1lCiAgICAgICAgICAgICAgICAkb3V0RGlyID0gU3Bs >> "%TEMP%\nm_inst.b64"
echo aXQtUGF0aCAkb3V0UGF0aCAtUGFyZW50CiAgICAgICAgICAgICAgICBpZiAoLW5v >> "%TEMP%\nm_inst.b64"
echo dCAoVGVzdC1QYXRoICRvdXREaXIpKSB7IE5ldy1JdGVtIC1JdGVtVHlwZSBEaXJl >> "%TEMP%\nm_inst.b64"
echo Y3RvcnkgLVBhdGggJG91dERpciAtRm9yY2UgfCBPdXQtTnVsbCB9CiAgICAgICAg >> "%TEMP%\nm_inst.b64"
echo ICAgICAgICBpZiAoLW5vdCAkbmFtZS5FbmRzV2l0aCgiLyIpKSB7CiAgICAgICAg >> "%TEMP%\nm_inst.b64"
echo ICAgICAgICAgICAgW1N5c3RlbS5JTy5GaWxlXTo6V3JpdGVBbGxCeXRlcygkb3V0 >> "%TEMP%\nm_inst.b64"
echo UGF0aCwgJGZpbGVEYXRhKQogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAg >> "%TEMP%\nm_inst.b64"
echo ICAgJHBvcyArPSBbTWF0aF06OkNlaWxpbmcoJHNpemUgLyA1MTIpICogNTEyCiAg >> "%TEMP%\nm_inst.b64"
echo ICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgV3JpdGUtSG9zdCAiW09LXSAg >> "%TEMP%\nm_inst.b64"
echo IFBvd2VyU2hlbGwgdGFyIGV4dHJhY3Rpb24gc3VjY2VlZGVkLiIKICAgICAgICBy >> "%TEMP%\nm_inst.b64"
echo ZXR1cm4gJHRydWUKICAgIH0gY2F0Y2ggewogICAgICAgIFdyaXRlLUhvc3QgIltX >> "%TEMP%\nm_inst.b64"
echo QVJOXSBQUyB0YXIgZmFsbGJhY2sgYWxzbyBmYWlsZWQ6ICRfIgogICAgICAgIHJl >> "%TEMP%\nm_inst.b64"
echo dHVybiAkZmFsc2UKICAgIH0KfQoKV3JpdGUtSG9zdCAiW0lORk9dIFF1ZXJ5aW5n >> "%TEMP%\nm_inst.b64"
echo IEdpdEh1YiBBUEkuLi4iCnRyeSB7CiAgICAkciA9IEludm9rZS1SZXN0TWV0aG9k >> "%TEMP%\nm_inst.b64"
echo IC1VcmkgImh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvWWFraXRyYWsvbm90 >> "%TEMP%\nm_inst.b64"
echo ZXNtZC1jbGkvcmVsZWFzZXMvbGF0ZXN0IiAtVGltZW91dFNlYyAzMAp9IGNhdGNo >> "%TEMP%\nm_inst.b64"
echo IHsgV3JpdGUtSG9zdCAiW0VSUk9SXSBHaXRIdWIgQVBJOiAkXyI7IGV4aXQgMSB9 >> "%TEMP%\nm_inst.b64"
echo CldyaXRlLUhvc3QgIltJTkZPXSBMYXRlc3Q6ICQoJHIudGFnX25hbWUpIgoKJGEg >> "%TEMP%\nm_inst.b64"
echo PSAkci5hc3NldHMgfCBXaGVyZS1PYmplY3QgeyAkXy5uYW1lIC1tYXRjaCAid2lu >> "%TEMP%\nm_inst.b64"
echo ZG93cyIgLWFuZCAkXy5uYW1lIC1tYXRjaCAiYW1kNjQiIH0gfCBTZWxlY3QtT2Jq >> "%TEMP%\nm_inst.b64"
echo ZWN0IC1GaXJzdCAxCmlmICgtbm90ICRhKSB7ICRhID0gJHIuYXNzZXRzIHwgV2hl >> "%TEMP%\nm_inst.b64"
echo cmUtT2JqZWN0IHsgJF8ubmFtZSAtbWF0Y2ggIndpbmRvd3MiIH0gfCBTZWxlY3Qt >> "%TEMP%\nm_inst.b64"
echo T2JqZWN0IC1GaXJzdCAxIH0KaWYgKC1ub3QgJGEpIHsKICAgIFdyaXRlLUhvc3Qg >> "%TEMP%\nm_inst.b64"
echo IltFUlJPUl0gTm8gV2luZG93cyBhc3NldC4gQXZhaWxhYmxlOiIKICAgICRyLmFz >> "%TEMP%\nm_inst.b64"
echo c2V0cyB8IEZvckVhY2gtT2JqZWN0IHsgV3JpdGUtSG9zdCAiICAkKCRfLm5hbWUp >> "%TEMP%\nm_inst.b64"
echo IiB9CiAgICBleGl0IDEKfQpXcml0ZS1Ib3N0ICJbSU5GT10gQXNzZXQ6ICQoJGEu >> "%TEMP%\nm_inst.b64"
echo bmFtZSkiCldyaXRlLUhvc3QgIltJTkZPXSBVUkwgIDogJCgkYS5icm93c2VyX2Rv >> "%TEMP%\nm_inst.b64"
echo d25sb2FkX3VybCkiCgokdCA9IEpvaW4tUGF0aCAkZW52OlRFTVAgJGEubmFtZQok >> "%TEMP%\nm_inst.b64"
echo UHJvZ3Jlc3NQcmVmZXJlbmNlID0gIlNpbGVudGx5Q29udGludWUiCnRyeSB7IElu >> "%TEMP%\nm_inst.b64"
echo dm9rZS1XZWJSZXF1ZXN0IC1VcmkgJGEuYnJvd3Nlcl9kb3dubG9hZF91cmwgLU91 >> "%TEMP%\nm_inst.b64"
echo dEZpbGUgJHQgLVRpbWVvdXRTZWMgMTIwIH0KY2F0Y2ggeyBXcml0ZS1Ib3N0ICJb >> "%TEMP%\nm_inst.b64"
echo RVJST1JdIERvd25sb2FkIGZhaWxlZDogJF8iOyBleGl0IDEgfQpXcml0ZS1Ib3N0 >> "%TEMP%\nm_inst.b64"
echo ICJbT0tdICAgRG93bmxvYWRlZDogJHQiCgokZSA9IEpvaW4tUGF0aCAkZW52OlRF >> "%TEMP%\nm_inst.b64"
echo TVAgIm5tX2V4dHJhY3RfdjE0IgppZiAoVGVzdC1QYXRoICRlKSB7IFJlbW92ZS1J >> "%TEMP%\nm_inst.b64"
echo dGVtICRlIC1SZWN1cnNlIC1Gb3JjZSB9Ck5ldy1JdGVtIC1JdGVtVHlwZSBEaXJl >> "%TEMP%\nm_inst.b64"
echo Y3RvcnkgLVBhdGggJGUgfCBPdXQtTnVsbAoKaWYgKCRhLm5hbWUgLW1hdGNoICJc >> "%TEMP%\nm_inst.b64"
echo LmV4ZSQiKSB7CiAgICBXcml0ZS1Ib3N0ICJbSU5GT10gRGlyZWN0IC5leGUgYXNz >> "%TEMP%\nm_inst.b64"
echo ZXQuIgogICAgQ29weS1JdGVtICR0ICR4IC1Gb3JjZQogICAgUmVtb3ZlLUl0ZW0g >> "%TEMP%\nm_inst.b64"
echo JHQgLUZvcmNlIC1FcnJvckFjdGlvbiBTaWxlbnRseUNvbnRpbnVlCiAgICBSZW1v >> "%TEMP%\nm_inst.b64"
echo dmUtSXRlbSAkZSAtUmVjdXJzZSAtRm9yY2UgLUVycm9yQWN0aW9uIFNpbGVudGx5 >> "%TEMP%\nm_inst.b64"
echo Q29udGludWUKfSBlbHNlaWYgKCRhLm5hbWUgLW1hdGNoICJcLnppcCQiKSB7CiAg >> "%TEMP%\nm_inst.b64"
echo ICBXcml0ZS1Ib3N0ICJbSU5GT10gRXh0cmFjdGluZyAuemlwLi4uIgogICAgdHJ5 >> "%TEMP%\nm_inst.b64"
echo IHsgRXhwYW5kLUFyY2hpdmUgLVBhdGggJHQgLURlc3RpbmF0aW9uUGF0aCAkZSAt >> "%TEMP%\nm_inst.b64"
echo Rm9yY2UgfQogICAgY2F0Y2ggeyBXcml0ZS1Ib3N0ICJbRVJST1JdIEV4cGFuZC1B >> "%TEMP%\nm_inst.b64"
echo cmNoaXZlOiAkXyI7IFJlbW92ZS1JdGVtICR0IC1Gb3JjZSAtRUEgU2lsZW50bHlD >> "%TEMP%\nm_inst.b64"
echo b250aW51ZTsgZXhpdCAxIH0KICAgICRmID0gR2V0LUNoaWxkSXRlbSAkZSAtUmVj >> "%TEMP%\nm_inst.b64"
echo dXJzZSB8IFdoZXJlLU9iamVjdCB7ICRfLk5hbWUgLWVxICJub3Rlc21kLWNsaS5l >> "%TEMP%\nm_inst.b64"
echo eGUiIH0gfCBTZWxlY3QtT2JqZWN0IC1GaXJzdCAxCiAgICBpZiAoLW5vdCAkZikg >> "%TEMP%\nm_inst.b64"
echo eyAkZiA9IEdldC1DaGlsZEl0ZW0gJGUgLVJlY3Vyc2UgfCBXaGVyZS1PYmplY3Qg >> "%TEMP%\nm_inst.b64"
echo eyAkXy5FeHRlbnNpb24gLWVxICIuZXhlIiAtYW5kIC1ub3QgJF8uUFNJc0NvbnRh >> "%TEMP%\nm_inst.b64"
echo aW5lciB9IHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMSB9CiAgICBpZiAoLW5vdCAk >> "%TEMP%\nm_inst.b64"
echo ZikgeyBXcml0ZS1Ib3N0ICJbRVJST1JdIG5vdGVzbWQtY2xpLmV4ZSBub3QgZm91 >> "%TEMP%\nm_inst.b64"
echo bmQgaW4gemlwLiI7IGV4aXQgMSB9CiAgICBDb3B5LUl0ZW0gJGYuRnVsbE5hbWUg >> "%TEMP%\nm_inst.b64"
echo JHggLUZvcmNlCiAgICBSZW1vdmUtSXRlbSAkdCAtRm9yY2UgLUVBIFNpbGVudGx5 >> "%TEMP%\nm_inst.b64"
echo Q29udGludWU7IFJlbW92ZS1JdGVtICRlIC1SZWN1cnNlIC1Gb3JjZSAtRUEgU2ls >> "%TEMP%\nm_inst.b64"
echo ZW50bHlDb250aW51ZQp9IGVsc2VpZiAoJGEubmFtZSAtbWF0Y2ggIlwudGFyXC5n >> "%TEMP%\nm_inst.b64"
echo eiQiKSB7CiAgICBXcml0ZS1Ib3N0ICJbSU5GT10gRXh0cmFjdGluZyAudGFyLmd6 >> "%TEMP%\nm_inst.b64"
echo Li4uIgogICAgJG9rID0gRXh0cmFjdC1UYXJHeiAkdCAkZQogICAgaWYgKC1ub3Qg >> "%TEMP%\nm_inst.b64"
echo JG9rKSB7IFdyaXRlLUhvc3QgIltFUlJPUl0gQWxsIGV4dHJhY3Rpb24gbWV0aG9k >> "%TEMP%\nm_inst.b64"
echo cyBmYWlsZWQuIjsgZXhpdCAxIH0KICAgICRmID0gR2V0LUNoaWxkSXRlbSAkZSAt >> "%TEMP%\nm_inst.b64"
echo UmVjdXJzZSB8IFdoZXJlLU9iamVjdCB7ICRfLk5hbWUgLWVxICJub3Rlc21kLWNs >> "%TEMP%\nm_inst.b64"
echo aS5leGUiIH0gfCBTZWxlY3QtT2JqZWN0IC1GaXJzdCAxCiAgICBpZiAoLW5vdCAk >> "%TEMP%\nm_inst.b64"
echo ZikgeyAkZiA9IEdldC1DaGlsZEl0ZW0gJGUgLVJlY3Vyc2UgfCBXaGVyZS1PYmpl >> "%TEMP%\nm_inst.b64"
echo Y3QgeyAkXy5FeHRlbnNpb24gLWVxICIuZXhlIiAtYW5kIC1ub3QgJF8uUFNJc0Nv >> "%TEMP%\nm_inst.b64"
echo bnRhaW5lciB9IHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMSB9CiAgICBpZiAoLW5v >> "%TEMP%\nm_inst.b64"
echo dCAkZikgewogICAgICAgIFdyaXRlLUhvc3QgIltFUlJPUl0gbm90ZXNtZC1jbGku >> "%TEMP%\nm_inst.b64"
echo ZXhlIG5vdCBmb3VuZC4gRXh0cmFjdGVkIGNvbnRlbnRzOiIKICAgICAgICBHZXQt >> "%TEMP%\nm_inst.b64"
echo Q2hpbGRJdGVtICRlIC1SZWN1cnNlIHwgRm9yRWFjaC1PYmplY3QgeyBXcml0ZS1I >> "%TEMP%\nm_inst.b64"
echo b3N0ICIgICQoJF8uRnVsbE5hbWUpIiB9CiAgICAgICAgZXhpdCAxCiAgICB9CiAg >> "%TEMP%\nm_inst.b64"
echo ICBXcml0ZS1Ib3N0ICJbSU5GT10gRm91bmQ6ICQoJGYuRnVsbE5hbWUpIgogICAg >> "%TEMP%\nm_inst.b64"
echo Q29weS1JdGVtICRmLkZ1bGxOYW1lICR4IC1Gb3JjZQogICAgUmVtb3ZlLUl0ZW0g >> "%TEMP%\nm_inst.b64"
echo JHQgLUZvcmNlIC1FQSBTaWxlbnRseUNvbnRpbnVlOyBSZW1vdmUtSXRlbSAkZSAt >> "%TEMP%\nm_inst.b64"
echo UmVjdXJzZSAtRm9yY2UgLUVBIFNpbGVudGx5Q29udGludWUKfSBlbHNlIHsKICAg >> "%TEMP%\nm_inst.b64"
echo IFdyaXRlLUhvc3QgIltFUlJPUl0gVW5rbm93biBhcmNoaXZlIHR5cGU6ICQoJGEu >> "%TEMP%\nm_inst.b64"
echo bmFtZSkiOyBleGl0IDEKfQoKIyBNWiBoZWFkZXIgdmFsaWRhdGlvbgpXcml0ZS1I >> "%TEMP%\nm_inst.b64"
echo b3N0ICJbSU5GT10gVmFsaWRhdGluZyBiaW5hcnkuLi4iCmlmICgtbm90IChUZXN0 >> "%TEMP%\nm_inst.b64"
echo LU1aICR4KSkgewogICAgV3JpdGUtSG9zdCAiW0VSUk9SXSBGaWxlIGlzIE5PVCBh >> "%TEMP%\nm_inst.b64"
echo IHZhbGlkIFdpbmRvd3MgZXhlY3V0YWJsZSAobWlzc2luZyBNWiBoZWFkZXIpLiIK >> "%TEMP%\nm_inst.b64"
echo ICAgIFdyaXRlLUhvc3QgIiAgICAgICAgVGhlIGRvd25sb2FkZWQvZXh0cmFjdGVk >> "%TEMP%\nm_inst.b64"
echo IGZpbGUgaXMgY29ycnVwdCBvciB3cm9uZyBhcmNoaXRlY3R1cmUuIgogICAgV3Jp >> "%TEMP%\nm_inst.b64"
echo dGUtSG9zdCAiICAgICAgICBGaWxlIHNpemU6ICQoKEdldC1JdGVtICR4KS5MZW5n >> "%TEMP%\nm_inst.b64"
echo dGgpIGJ5dGVzIgogICAgV3JpdGUtSG9zdCAiICAgICAgICBGaXJzdCBieXRlczog >> "%TEMP%\nm_inst.b64"
echo JChbU3lzdGVtLklPLkZpbGVdOjpSZWFkQWxsQnl0ZXMoJHgpWzAuLjNdKSIKICAg >> "%TEMP%\nm_inst.b64"
echo IFJlbW92ZS1JdGVtICR4IC1Gb3JjZSAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250 >> "%TEMP%\nm_inst.b64"
echo aW51ZQogICAgZXhpdCAxCn0KV3JpdGUtSG9zdCAiW09LXSAgIEJpbmFyeSB2YWxp >> "%TEMP%\nm_inst.b64"
echo ZGF0ZWQgKE1aIGhlYWRlciBPSykuIgoKJEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9 >> "%TEMP%\nm_inst.b64"
echo ICJDb250aW51ZSIKJHYgPSB0cnkgeyAmICR4IC0tdmVyc2lvbiAyPiRudWxsIH0g >> "%TEMP%\nm_inst.b64"
echo Y2F0Y2ggeyAiKHZlcnNpb24gdW5rbm93bikiIH0KV3JpdGUtSG9zdCAiW09LXSAg >> "%TEMP%\nm_inst.b64"
echo IFZlcnNpb246ICR2IgoKJHAgPSBbRW52aXJvbm1lbnRdOjpHZXRFbnZpcm9ubWVu >> "%TEMP%\nm_inst.b64"
echo dFZhcmlhYmxlKCJQQVRIIiwgIlVzZXIiKQppZiAoJHAgLW5vdGxpa2UgIiokZCoi >> "%TEMP%\nm_inst.b64"
echo KSB7CiAgICBbRW52aXJvbm1lbnRdOjpTZXRFbnZpcm9ubWVudFZhcmlhYmxlKCJQ >> "%TEMP%\nm_inst.b64"
echo QVRIIiwgJHAgKyAiOyIgKyAkZCwgIlVzZXIiKQogICAgV3JpdGUtSG9zdCAiW09L >> "%TEMP%\nm_inst.b64"
echo XSAgIFBBVEg6IGFkZGVkICRkIgogICAgV3JpdGUtSG9zdCAiW0lORk9dIE9wZW4g >> "%TEMP%\nm_inst.b64"
echo YSBORVcgdGVybWluYWwgZm9yIFBBVEggdG8gdGFrZSBlZmZlY3QuIgp9IGVsc2Ug >> "%TEMP%\nm_inst.b64"
echo ewogICAgV3JpdGUtSG9zdCAiW09LXSAgIFBBVEg6IGFscmVhZHkgY29udGFpbnMg >> "%TEMP%\nm_inst.b64"
echo JGQiCn0K >> "%TEMP%\nm_inst.b64"
echo -----END CERTIFICATE----- >> "%TEMP%\nm_inst.b64"
certutil -decode "%TEMP%\nm_inst.b64" "%TEMP%\nm_inst.ps1" >nul 2>&1
del /f /q "%TEMP%\nm_inst.b64" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] certutil decode failed.
    echo  Press any key to close...
    pause >nul & endlocal & exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\nm_inst.ps1"
set "PS_ERR=%ERRORLEVEL%"
del /f /q "%TEMP%\nm_inst.ps1" 2>nul

if %PS_ERR% NEQ 0 (
    echo.
    echo [ERROR] Install failed. Exit code: %PS_ERR%
    echo.
    echo  Manual steps:
    echo    1. https://github.com/Yakitrak/notesmd-cli/releases
    echo    2. Download: notesmd-cli_X.X.X_windows_amd64.tar.gz
    echo    3. Extract: tar -xzf archive.tar.gz
    echo    4. Copy notesmd-cli.exe to: %INSTALL_DIR%
    echo    5. Add %INSTALL_DIR% to Windows PATH
    echo.
    echo  Press any key to close...
    pause >nul & endlocal & exit /b 1
)

echo.
echo ---- Verification ----
if exist "%NOTES_EXE%" (
    set "VER=unknown"
    for /f "tokens=*" %%i in ('"%NOTES_EXE%" --version 2^>nul') do set "VER=%%i"
    echo [OK]    notesmd-cli !VER!
    echo         %NOTES_EXE%
) else (
    echo [INFO]  Available in NEW terminal after PATH refresh.
)

echo.
echo =====================================================
echo     INSTALLATION COMPLETE
echo =====================================================
echo.
echo   Next: Run RUN.bat
echo   First use: choose [1] to set your Obsidian vault.
echo.
echo   IMPORTANT: Close window, open NEW terminal, run RUN.bat.
echo              (One-time PATH refresh)
echo.
echo  Press any key to close...
pause >nul
endlocal
exit /b 0
