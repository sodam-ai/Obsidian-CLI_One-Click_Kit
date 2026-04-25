@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title NotesMD CLI
REM ================================================================
REM  NotesMD CLI - Full Operations Menu  v13
REM  Update uses certutil decode method (no long lines)
REM  100%% ASCII  CRLF  no BOM  no goto-in-loop
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

set "INSTALL_DIR=%USERPROFILE%\bin"
set "NOTES_DIRECT=%INSTALL_DIR%\notesmd-cli.exe"
set "NOTES_SCOOP=%USERPROFILE%\scoop\apps\notesmd-cli\current\notesmd-cli.exe"

if exist "%INSTALL_DIR%" set "PATH=%INSTALL_DIR%;%PATH%"
if exist "%USERPROFILE%\scoop\shims" set "PATH=%USERPROFILE%\scoop\shims;%PATH%"

set "NOTES_CMD="
if exist "%NOTES_DIRECT%" set "NOTES_CMD=%NOTES_DIRECT%"
if "!NOTES_CMD!"=="" if exist "%NOTES_SCOOP%" set "NOTES_CMD=%NOTES_SCOOP%"
if "!NOTES_CMD!"=="" (
    where notesmd-cli >nul 2>&1
    if %ERRORLEVEL% EQU 0 set "NOTES_CMD=notesmd-cli"
)
if "!NOTES_CMD!"=="" (
    echo.
    echo =====================================================
    echo     notesmd-cli NOT FOUND
    echo =====================================================
    echo.
    echo  Fix:
    echo    1. Run INSTALL.bat
    echo    2. Close this window
    echo    3. Open a NEW terminal window
    echo    4. Run RUN.bat again
    echo.
    echo  Press any key to close...
    pause >nul
    endlocal
    exit /b 2
)

set "CVER=unknown"
for /f "tokens=*" %%i in ('"!NOTES_CMD!" --version 2^>nul') do set "CVER=%%i"
set "CVAULT=(not set - use option 1)"
for /f "tokens=*" %%i in ('"!NOTES_CMD!" print-default 2^>nul') do set "CVAULT=%%i"
set "CPATH=(unknown)"
for /f "tokens=*" %%i in ('"!NOTES_CMD!" print-default --path-only 2^>nul') do set "CPATH=%%i"
title NotesMD CLI  v%CVER%

:MENU
cls
echo.
echo =====================================================
echo     NotesMD CLI  -  Operations Menu
echo =====================================================
echo   Version : %CVER%
echo   Vault   : !CVAULT!
echo   Path    : !CPATH!
echo =====================================================
echo.
echo   -- VAULT --
echo    [1]  Set Default Vault
echo    [2]  Show Vault Info
echo.
echo   -- NOTE OPERATIONS --
echo    [3]  Open Note
echo    [4]  Daily Note
echo    [5]  Fuzzy Search
echo    [6]  Search Content
echo    [7]  List Vault
echo    [8]  Print Note
echo    [9]  Create / Update Note
echo    [10] Move / Rename Note
echo    [11] Delete Note
echo.
echo   -- FRONTMATTER (YAML) --
echo    [12] Frontmatter Manager
echo.
echo   -- SYSTEM --
echo    [13] Check Version
echo    [14] Update notesmd-cli
echo    [15] Full Help
echo    [0]  Exit
echo.
echo =====================================================
set "C=" & set /p "C=  Choice [0-15]: "
if "!C!"=="1"  goto :OP1
if "!C!"=="2"  goto :OP2
if "!C!"=="3"  goto :OP3
if "!C!"=="4"  goto :OP4
if "!C!"=="5"  goto :OP5
if "!C!"=="6"  goto :OP6
if "!C!"=="7"  goto :OP7
if "!C!"=="8"  goto :OP8
if "!C!"=="9"  goto :OP9
if "!C!"=="10"  goto :OP10
if "!C!"=="11"  goto :OP11
if "!C!"=="12"  goto :OP12
if "!C!"=="13"  goto :OP13
if "!C!"=="14"  goto :OP14
if "!C!"=="15"  goto :OP15
if "!C!"=="0"  goto :EXIT
echo   Invalid. Enter 0-15.
timeout /t 2 >nul
goto :MENU

:OP1
cls & echo.
echo -- [1] Set Default Vault --
echo.
echo  Current vault: !CVAULT!
echo  Enter vault NAME only (e.g. MyNotes).
echo  Must match Obsidian vault folder name exactly.
echo.
set "VN=" & set /p "VN=  Vault name: "
if "!VN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
"!NOTES_CMD!" set-default "!VN!"
if %ERRORLEVEL% EQU 0 (
    set "CVAULT=!VN!"
    for /f "tokens=*" %%i in ('"!NOTES_CMD!" print-default --path-only 2^>nul') do set "CPATH=%%i"
    echo [OK] Vault set: !CVAULT!
) else echo [ERROR] Failed. Vault name must match exactly.
echo. & pause & goto :MENU

:OP2
cls & echo.
echo -- [2] Vault Info --
echo.
"!NOTES_CMD!" print-default
echo.
"!NOTES_CMD!" print-default --path-only
echo. & pause & goto :MENU

:OP3
cls & echo.
echo -- [3] Open Note --
echo.
set "NN=" & set /p "NN=  Note name (e.g. MyNote.md): "
if "!NN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Obsidian  [B] Editor  [C] Heading  [D] Other vault  [E] Vault+heading
echo.
set "M=A" & set /p "M=  Mode [A-E, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" open "!NN!"
if /i "!M!"=="B" "!NOTES_CMD!" open "!NN!" --editor
if /i "!M!"=="C" ( set "S=" & set /p "S=  Heading: " & "!NOTES_CMD!" open "!NN!" --section "!S!" )
if /i "!M!"=="D" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" open "!NN!" --vault "!V!" )
if /i "!M!"=="E" ( set "V=" & set "S=" & set /p "V=  Vault: " & set /p "S=  Heading: " & "!NOTES_CMD!" open "!NN!" --vault "!V!" --section "!S!" )
echo. & pause & goto :MENU

:OP4
cls & echo.
echo -- [4] Daily Note --
echo.
echo  [A] Default vault  [B] Other vault
echo.
set "M=A" & set /p "M=  Mode [A/B, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" daily
if /i "!M!"=="B" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" daily --vault "!V!" )
echo. & pause & goto :MENU

:OP5
cls & echo.
echo -- [5] Fuzzy Search --
echo.
echo  [A] Default vault  [B] Other vault  [C] Open in editor
echo.
set "M=A" & set /p "M=  Mode [A/B/C, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" search
if /i "!M!"=="B" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" search --vault "!V!" )
if /i "!M!"=="C" "!NOTES_CMD!" search --editor
echo. & pause & goto :MENU

:OP6
cls & echo.
echo -- [6] Search Content --
echo.
set "T=" & set /p "T=  Search term: "
if "!T!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Default vault  [B] Other vault  [C] Open in editor
echo.
set "M=A" & set /p "M=  Mode [A/B/C, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" search-content "!T!"
if /i "!M!"=="B" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" search-content "!T!" --vault "!V!" )
if /i "!M!"=="C" "!NOTES_CMD!" search-content "!T!" --editor
echo. & pause & goto :MENU

:OP7
cls & echo.
echo -- [7] List Vault --
echo.
echo  [A] Root  [B] Subfolder  [C] Other vault  [D] Vault+subfolder
echo.
set "M=A" & set /p "M=  Mode [A-D, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" list
if /i "!M!"=="B" ( set "F=" & set /p "F=  Subfolder: " & "!NOTES_CMD!" list "!F!" )
if /i "!M!"=="C" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" list --vault "!V!" )
if /i "!M!"=="D" ( set "V=" & set "F=" & set /p "V=  Vault: " & set /p "F=  Subfolder: " & "!NOTES_CMD!" list "!F!" --vault "!V!" )
echo. & pause & goto :MENU

:OP8
cls & echo.
echo -- [8] Print Note --
echo.
set "NN=" & set /p "NN=  Note name: "
if "!NN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Default vault  [B] Other vault
echo.
set "M=A" & set /p "M=  Mode [A/B, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" print "!NN!"
if /i "!M!"=="B" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" print "!NN!" --vault "!V!" )
echo. & pause & goto :MENU

:OP9
cls & echo.
echo -- [9] Create / Update Note --
echo.
set "NN=" & set /p "NN=  Note name (e.g. MyNote.md): "
if "!NN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Empty  [B] Content  [C] Content+editor  [D] Overwrite  [E] Append  [F] Other vault
echo.
set "M=A" & set /p "M=  Mode [A-F, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" create "!NN!"
if /i "!M!"=="B" ( set "CT=" & set /p "CT=  Content: " & "!NOTES_CMD!" create "!NN!" --content "!CT!" )
if /i "!M!"=="C" ( set "CT=" & set /p "CT=  Content: " & "!NOTES_CMD!" create "!NN!" --content "!CT!" --open --editor )
if /i "!M!"=="D" ( set "CT=" & set /p "CT=  New content: " & "!NOTES_CMD!" create "!NN!" --content "!CT!" --overwrite )
if /i "!M!"=="E" ( set "CT=" & set /p "CT=  Append: " & "!NOTES_CMD!" create "!NN!" --content "!CT!" --append )
if /i "!M!"=="F" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" create "!NN!" --vault "!V!" )
echo. & pause & goto :MENU

:OP10
cls & echo.
echo -- [10] Move / Rename Note --
echo.
echo  (All vault links updated automatically)
echo.
set "OLD=" & set /p "OLD=  Current path: "
if "!OLD!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
set "NEW=" & set /p "NEW=  New path: "
if "!NEW!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Default  [B] Open after  [C] Open in editor  [D] Other vault
echo.
set "M=A" & set /p "M=  Mode [A-D, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" move "!OLD!" "!NEW!"
if /i "!M!"=="B" "!NOTES_CMD!" move "!OLD!" "!NEW!" --open
if /i "!M!"=="C" "!NOTES_CMD!" move "!OLD!" "!NEW!" --open --editor
if /i "!M!"=="D" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" move "!OLD!" "!NEW!" --vault "!V!" )
echo. & pause & goto :MENU

:OP11
cls & echo.
echo -- [11] Delete Note --
echo.
echo  [WARN] PERMANENT. Cannot be undone.
echo.
set "NN=" & set /p "NN=  Note path: "
if "!NN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Default vault  [B] Other vault
echo.
set "M=A" & set /p "M=  Mode [A/B, Enter=A]: "
if "!M!"=="" set "M=A"
echo.
echo  About to delete: !NN!
set "CF=" & set /p "CF=  Type YES to confirm: "
if /i "!CF!" NEQ "YES" ( echo [INFO] Cancelled. & pause & goto :MENU )
if /i "!M!"=="A" "!NOTES_CMD!" delete "!NN!"
if /i "!M!"=="B" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" delete "!NN!" --vault "!V!" )
echo. & pause & goto :MENU

:OP12
cls & echo.
echo -- [12] Frontmatter Manager --
echo.
set "NN=" & set /p "NN=  Note name: "
if "!NN!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
echo.
echo  [A] Print all  [B] Edit/add field  [C] Delete field  [D] Other vault
echo.
set "M=A" & set /p "M=  Mode [A-D, Enter=A]: "
if "!M!"=="" set "M=A"
if /i "!M!"=="A" "!NOTES_CMD!" frontmatter "!NN!" --print
if /i "!M!"=="B" (
    set "FK=" & set /p "FK=  Key (e.g. status): "
    if "!FK!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
    set "FV=" & set /p "FV=  Value: "
    "!NOTES_CMD!" frontmatter "!NN!" --edit --key "!FK!" --value "!FV!"
)
if /i "!M!"=="C" (
    set "FK=" & set /p "FK=  Key to delete: "
    if "!FK!"=="" ( echo [WARN] Empty. & pause & goto :MENU )
    "!NOTES_CMD!" frontmatter "!NN!" --delete --key "!FK!"
)
if /i "!M!"=="D" ( set "V=" & set /p "V=  Vault: " & "!NOTES_CMD!" frontmatter "!NN!" --print --vault "!V!" )
echo. & pause & goto :MENU

:OP13
cls & echo.
echo -- [13] Version Info --
echo.
"!NOTES_CMD!" --version
echo.
echo  Binary : !NOTES_CMD!
echo  Dir    : %INSTALL_DIR%
echo  GitHub : https://github.com/Yakitrak/notesmd-cli/releases
echo. & pause & goto :MENU

:OP14
cls & echo.
echo -- [14] Update notesmd-cli --
echo  v14: MZ validation + PS tar.gz fallback
echo.
echo  Current version:
"!NOTES_CMD!" --version
echo.
echo  Checking GitHub...
set "NOTESMD_INSTALL_DIR=%INSTALL_DIR%"

del /f /q "%TEMP%\nm_upd.b64" 2>nul
del /f /q "%TEMP%\nm_upd.ps1" 2>nul
echo -----BEGIN CERTIFICATE----- > "%TEMP%\nm_upd.b64"
echo JEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICJTdG9wIgokZCA9ICRlbnY6Tk9URVNN >> "%TEMP%\nm_upd.b64"
echo RF9JTlNUQUxMX0RJUgppZiAoLW5vdCAkZCkgeyAkZCA9ICIkZW52OlVTRVJQUk9G >> "%TEMP%\nm_upd.b64"
echo SUxFXGJpbiIgfQokeCA9IEpvaW4tUGF0aCAkZCAibm90ZXNtZC1jbGkuZXhlIgpp >> "%TEMP%\nm_upd.b64"
echo ZiAoLW5vdCAoVGVzdC1QYXRoICRkKSkgeyBOZXctSXRlbSAtSXRlbVR5cGUgRGly >> "%TEMP%\nm_upd.b64"
echo ZWN0b3J5IC1QYXRoICRkIHwgT3V0LU51bGwgfQpbTmV0LlNlcnZpY2VQb2ludE1h >> "%TEMP%\nm_upd.b64"
echo bmFnZXJdOjpTZWN1cml0eVByb3RvY29sID0gW05ldC5TZWN1cml0eVByb3RvY29s >> "%TEMP%\nm_upd.b64"
echo VHlwZV06OlRsczEyCgpmdW5jdGlvbiBUZXN0LU1aKCRwYXRoKSB7CiAgICB0cnkg >> "%TEMP%\nm_upd.b64"
echo eyAkYiA9IFtTeXN0ZW0uSU8uRmlsZV06OlJlYWRBbGxCeXRlcygkcGF0aCk7IHJl >> "%TEMP%\nm_upd.b64"
echo dHVybiAoJGIuQ291bnQgLWd0IDIgLWFuZCAkYlswXSAtZXEgMHg0RCAtYW5kICRi >> "%TEMP%\nm_upd.b64"
echo WzFdIC1lcSAweDVBKSB9CiAgICBjYXRjaCB7IHJldHVybiAkZmFsc2UgfQp9CmZ1 >> "%TEMP%\nm_upd.b64"
echo bmN0aW9uIEV4dHJhY3QtVGFyR3ooJHRhckd6UGF0aCwgJGRlc3REaXIpIHsKICAg >> "%TEMP%\nm_upd.b64"
echo ICR0cCA9ICIkZW52OlN5c3RlbVJvb3RcU3lzdGVtMzJcdGFyLmV4ZSIKICAgIGlm >> "%TEMP%\nm_upd.b64"
echo ICgtbm90IChUZXN0LVBhdGggJHRwKSkgeyAkdHAgPSAidGFyLmV4ZSIgfQogICAg >> "%TEMP%\nm_upd.b64"
echo JG91dCA9ICYgJHRwIC14emYgJHRhckd6UGF0aCAtQyAkZGVzdERpciAyPiYxCiAg >> "%TEMP%\nm_upd.b64"
echo ICBpZiAoJExBU1RFWElUQ09ERSAtZXEgMCkgeyByZXR1cm4gJHRydWUgfQogICAg >> "%TEMP%\nm_upd.b64"
echo V3JpdGUtSG9zdCAiW1dBUk5dIHRhciBmYWlsZWQsIHVzaW5nIFBTIGZhbGxiYWNr >> "%TEMP%\nm_upd.b64"
echo Li4uIgogICAgdHJ5IHsKICAgICAgICAkZ3MgPSBbU3lzdGVtLklPLkZpbGVdOjpP >> "%TEMP%\nm_upd.b64"
echo cGVuUmVhZCgkdGFyR3pQYXRoKQogICAgICAgICRnZCA9IE5ldy1PYmplY3QgU3lz >> "%TEMP%\nm_upd.b64"
echo dGVtLklPLkNvbXByZXNzaW9uLkdaaXBTdHJlYW0oJGdzLCBbU3lzdGVtLklPLkNv >> "%TEMP%\nm_upd.b64"
echo bXByZXNzaW9uLkNvbXByZXNzaW9uTW9kZV06OkRlY29tcHJlc3MpCiAgICAgICAg >> "%TEMP%\nm_upd.b64"
echo JHRiID0gTmV3LU9iamVjdCBTeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5MaXN0 >> "%TEMP%\nm_upd.b64"
echo W2J5dGVdCiAgICAgICAgJGJ1ZiA9IE5ldy1PYmplY3QgYnl0ZVtdIDY1NTM2CiAg >> "%TEMP%\nm_upd.b64"
echo ICAgICAgZG8geyAkcjIgPSAkZ2QuUmVhZCgkYnVmLCAwLCAkYnVmLkxlbmd0aCk7 >> "%TEMP%\nm_upd.b64"
echo IGlmICgkcjIgLWd0IDApIHsgJHRiLkFkZFJhbmdlKCRidWZbMC4uKCRyMi0xKV0p >> "%TEMP%\nm_upd.b64"
echo IH0gfSB3aGlsZSAoJHIyIC1ndCAwKQogICAgICAgICRnZC5DbG9zZSgpOyAkZ3Mu >> "%TEMP%\nm_upd.b64"
echo Q2xvc2UoKQogICAgICAgICRhcnIgPSAkdGIuVG9BcnJheSgpOyAkcG9zID0gMAog >> "%TEMP%\nm_upd.b64"
echo ICAgICAgIHdoaWxlICgkcG9zICsgNTEyIC1sZSAkYXJyLkxlbmd0aCkgewogICAg >> "%TEMP%\nm_upd.b64"
echo ICAgICAgICAkaGRyID0gJGFyclskcG9zLi4oJHBvcys1MTEpXQogICAgICAgICAg >> "%TEMP%\nm_upd.b64"
echo ICAkbmIgPSAkaGRyWzAuLjk5XTsgJG5pID0gW0FycmF5XTo6SW5kZXhPZigkbmIs >> "%TEMP%\nm_upd.b64"
echo IFtieXRlXTApCiAgICAgICAgICAgIGlmICgkbmkgLWVxIDApIHsgYnJlYWsgfQog >> "%TEMP%\nm_upd.b64"
echo ICAgICAgICAgICBpZiAoJG5pIC1ndCAwKSB7ICRuYiA9ICRuYlswLi4oJG5pLTEp >> "%TEMP%\nm_upd.b64"
echo XSB9CiAgICAgICAgICAgICRubSA9IFtTeXN0ZW0uVGV4dC5FbmNvZGluZ106OkFT >> "%TEMP%\nm_upd.b64"
echo Q0lJLkdldFN0cmluZygkbmIpCiAgICAgICAgICAgICRzbyA9IFtTeXN0ZW0uVGV4 >> "%TEMP%\nm_upd.b64"
echo dC5FbmNvZGluZ106OkFTQ0lJLkdldFN0cmluZygkaGRyWzEyNC4uMTM0XSkuVHJp >> "%TEMP%\nm_upd.b64"
echo bSgpLlRyaW0oW2NoYXJdMCkKICAgICAgICAgICAgJHN6ID0gMDsgaWYgKCRzbyAt >> "%TEMP%\nm_upd.b64"
echo bWF0Y2ggIl5bMC03XSskIikgeyAkc3ogPSBbQ29udmVydF06OlRvSW50NjQoJHNv >> "%TEMP%\nm_upd.b64"
echo LCA4KSB9CiAgICAgICAgICAgICRwb3MgKz0gNTEyCiAgICAgICAgICAgIGlmICgk >> "%TEMP%\nm_upd.b64"
echo c3ogLWd0IDApIHsKICAgICAgICAgICAgICAgICRmZCA9ICRhcnJbJHBvcy4uKCRw >> "%TEMP%\nm_upd.b64"
echo b3MrJHN6LTEpXQogICAgICAgICAgICAgICAgJG9wID0gSm9pbi1QYXRoICRkZXN0 >> "%TEMP%\nm_upd.b64"
echo RGlyICRubTsgJG9kID0gU3BsaXQtUGF0aCAkb3AgLVBhcmVudAogICAgICAgICAg >> "%TEMP%\nm_upd.b64"
echo ICAgICAgaWYgKC1ub3QgKFRlc3QtUGF0aCAkb2QpKSB7IE5ldy1JdGVtIC1JdGVt >> "%TEMP%\nm_upd.b64"
echo VHlwZSBEaXJlY3RvcnkgLVBhdGggJG9kIC1Gb3JjZSB8IE91dC1OdWxsIH0KICAg >> "%TEMP%\nm_upd.b64"
echo ICAgICAgICAgICAgIGlmICgtbm90ICRubS5FbmRzV2l0aCgiLyIpKSB7IFtTeXN0 >> "%TEMP%\nm_upd.b64"
echo ZW0uSU8uRmlsZV06OldyaXRlQWxsQnl0ZXMoJG9wLCAkZmQpIH0KICAgICAgICAg >> "%TEMP%\nm_upd.b64"
echo ICAgICAgICRwb3MgKz0gW01hdGhdOjpDZWlsaW5nKCRzeiAvIDUxMikgKiA1MTIK >> "%TEMP%\nm_upd.b64"
echo ICAgICAgICAgICAgfQogICAgICAgIH0KICAgICAgICByZXR1cm4gJHRydWUKICAg >> "%TEMP%\nm_upd.b64"
echo IH0gY2F0Y2ggeyBXcml0ZS1Ib3N0ICJbV0FSTl0gUFMgdGFyIGZhbGxiYWNrOiAk >> "%TEMP%\nm_upd.b64"
echo XyI7IHJldHVybiAkZmFsc2UgfQp9Cgp0cnkgeyAkciA9IEludm9rZS1SZXN0TWV0 >> "%TEMP%\nm_upd.b64"
echo aG9kIC1VcmkgImh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvWWFraXRyYWsv >> "%TEMP%\nm_upd.b64"
echo bm90ZXNtZC1jbGkvcmVsZWFzZXMvbGF0ZXN0IiAtVGltZW91dFNlYyAzMCB9CmNh >> "%TEMP%\nm_upd.b64"
echo dGNoIHsgV3JpdGUtSG9zdCAiW0VSUk9SXSAkXyI7IGV4aXQgMSB9CldyaXRlLUhv >> "%TEMP%\nm_upd.b64"
echo c3QgIltJTkZPXSBMYXRlc3Q6ICQoJHIudGFnX25hbWUpIgokYSA9ICRyLmFzc2V0 >> "%TEMP%\nm_upd.b64"
echo cyB8IFdoZXJlLU9iamVjdCB7ICRfLm5hbWUgLW1hdGNoICJ3aW5kb3dzIiAtYW5k >> "%TEMP%\nm_upd.b64"
echo ICRfLm5hbWUgLW1hdGNoICJhbWQ2NCIgfSB8IFNlbGVjdC1PYmplY3QgLUZpcnN0 >> "%TEMP%\nm_upd.b64"
echo IDEKaWYgKC1ub3QgJGEpIHsgJGEgPSAkci5hc3NldHMgfCBXaGVyZS1PYmplY3Qg >> "%TEMP%\nm_upd.b64"
echo eyAkXy5uYW1lIC1tYXRjaCAid2luZG93cyIgfSB8IFNlbGVjdC1PYmplY3QgLUZp >> "%TEMP%\nm_upd.b64"
echo cnN0IDEgfQppZiAoLW5vdCAkYSkgeyBXcml0ZS1Ib3N0ICJbRVJST1JdIE5vIFdp >> "%TEMP%\nm_upd.b64"
echo bmRvd3MgYXNzZXQuIjsgZXhpdCAxIH0KV3JpdGUtSG9zdCAiW0lORk9dIERvd25s >> "%TEMP%\nm_upd.b64"
echo b2FkaW5nOiAkKCRhLm5hbWUpIgokdCA9IEpvaW4tUGF0aCAkZW52OlRFTVAgJGEu >> "%TEMP%\nm_upd.b64"
echo bmFtZQokUHJvZ3Jlc3NQcmVmZXJlbmNlID0gIlNpbGVudGx5Q29udGludWUiCnRy >> "%TEMP%\nm_upd.b64"
echo eSB7IEludm9rZS1XZWJSZXF1ZXN0IC1VcmkgJGEuYnJvd3Nlcl9kb3dubG9hZF91 >> "%TEMP%\nm_upd.b64"
echo cmwgLU91dEZpbGUgJHQgLVRpbWVvdXRTZWMgMTIwIH0KY2F0Y2ggeyBXcml0ZS1I >> "%TEMP%\nm_upd.b64"
echo b3N0ICJbRVJST1JdICRfIjsgZXhpdCAxIH0KJGUgPSBKb2luLVBhdGggJGVudjpU >> "%TEMP%\nm_upd.b64"
echo RU1QICJubV91cGRfdjE0IgppZiAoVGVzdC1QYXRoICRlKSB7IFJlbW92ZS1JdGVt >> "%TEMP%\nm_upd.b64"
echo ICRlIC1SZWN1cnNlIC1Gb3JjZSB9Ck5ldy1JdGVtIC1JdGVtVHlwZSBEaXJlY3Rv >> "%TEMP%\nm_upd.b64"
echo cnkgLVBhdGggJGUgfCBPdXQtTnVsbAppZiAoJGEubmFtZSAtbWF0Y2ggIlwuZXhl >> "%TEMP%\nm_upd.b64"
echo JCIpIHsgQ29weS1JdGVtICR0ICR4IC1Gb3JjZSB9CmVsc2VpZiAoJGEubmFtZSAt >> "%TEMP%\nm_upd.b64"
echo bWF0Y2ggIlwuemlwJCIpIHsgRXhwYW5kLUFyY2hpdmUgLVBhdGggJHQgLURlc3Rp >> "%TEMP%\nm_upd.b64"
echo bmF0aW9uUGF0aCAkZSAtRm9yY2U7ICRmID0gR2V0LUNoaWxkSXRlbSAkZSAtUmVj >> "%TEMP%\nm_upd.b64"
echo dXJzZSB8IFdoZXJlLU9iamVjdCB7ICRfLk5hbWUgLWVxICJub3Rlc21kLWNsaS5l >> "%TEMP%\nm_upd.b64"
echo eGUiIH0gfCBTZWxlY3QtT2JqZWN0IC1GaXJzdCAxOyBpZiAoJGYpIHsgQ29weS1J >> "%TEMP%\nm_upd.b64"
echo dGVtICRmLkZ1bGxOYW1lICR4IC1Gb3JjZSB9IH0KZWxzZWlmICgkYS5uYW1lIC1t >> "%TEMP%\nm_upd.b64"
echo YXRjaCAiXC50YXJcLmd6JCIpIHsKICAgICRvayA9IEV4dHJhY3QtVGFyR3ogJHQg >> "%TEMP%\nm_upd.b64"
echo JGUKICAgIGlmICgtbm90ICRvaykgeyBXcml0ZS1Ib3N0ICJbRVJST1JdIEV4dHJh >> "%TEMP%\nm_upd.b64"
echo Y3Rpb24gZmFpbGVkLiI7IGV4aXQgMSB9CiAgICAkZiA9IEdldC1DaGlsZEl0ZW0g >> "%TEMP%\nm_upd.b64"
echo JGUgLVJlY3Vyc2UgfCBXaGVyZS1PYmplY3QgeyAkXy5OYW1lIC1lcSAibm90ZXNt >> "%TEMP%\nm_upd.b64"
echo ZC1jbGkuZXhlIiB9IHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMQogICAgaWYgKC1u >> "%TEMP%\nm_upd.b64"
echo b3QgJGYpIHsgJGYgPSBHZXQtQ2hpbGRJdGVtICRlIC1SZWN1cnNlIHwgV2hlcmUt >> "%TEMP%\nm_upd.b64"
echo T2JqZWN0IHsgJF8uRXh0ZW5zaW9uIC1lcSAiLmV4ZSIgfSB8IFNlbGVjdC1PYmpl >> "%TEMP%\nm_upd.b64"
echo Y3QgLUZpcnN0IDEgfQogICAgaWYgKCRmKSB7IENvcHktSXRlbSAkZi5GdWxsTmFt >> "%TEMP%\nm_upd.b64"
echo ZSAkeCAtRm9yY2UgfSBlbHNlIHsgV3JpdGUtSG9zdCAiW0VSUk9SXSBleGUgbm90 >> "%TEMP%\nm_upd.b64"
echo IGZvdW5kLiI7IGV4aXQgMSB9Cn0gZWxzZSB7IFdyaXRlLUhvc3QgIltFUlJPUl0g >> "%TEMP%\nm_upd.b64"
echo VW5rbm93bjogJCgkYS5uYW1lKSI7IGV4aXQgMSB9ClJlbW92ZS1JdGVtICR0IC1G >> "%TEMP%\nm_upd.b64"
echo b3JjZSAtRUEgU2lsZW50bHlDb250aW51ZTsgUmVtb3ZlLUl0ZW0gJGUgLVJlY3Vy >> "%TEMP%\nm_upd.b64"
echo c2UgLUZvcmNlIC1FQSBTaWxlbnRseUNvbnRpbnVlCmlmICgtbm90IChUZXN0LU1a >> "%TEMP%\nm_upd.b64"
echo ICR4KSkgeyBXcml0ZS1Ib3N0ICJbRVJST1JdIEludmFsaWQgRVhFIGFmdGVyIHVw >> "%TEMP%\nm_upd.b64"
echo ZGF0ZS4gTVogaGVhZGVyIG1pc3NpbmcuIjsgZXhpdCAxIH0KJEVycm9yQWN0aW9u >> "%TEMP%\nm_upd.b64"
echo UHJlZmVyZW5jZSA9ICJDb250aW51ZSIKJHYgPSB0cnkgeyAmICR4IC0tdmVyc2lv >> "%TEMP%\nm_upd.b64"
echo biAyPiRudWxsIH0gY2F0Y2ggeyAidW5rbm93biIgfQpXcml0ZS1Ib3N0ICJbT0td >> "%TEMP%\nm_upd.b64"
echo IFVwZGF0ZWQ6ICR2Igo= >> "%TEMP%\nm_upd.b64"
echo -----END CERTIFICATE----- >> "%TEMP%\nm_upd.b64"
certutil -decode "%TEMP%\nm_upd.b64" "%TEMP%\nm_upd.ps1" >nul 2>&1
del /f /q "%TEMP%\nm_upd.b64" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] certutil decode failed.
    echo. & pause & goto :MENU
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\nm_upd.ps1"
del /f /q "%TEMP%\nm_upd.ps1" 2>nul
echo.
set "CVER=unknown"
for /f "tokens=*" %%i in ('"!NOTES_CMD!" --version 2^>nul') do set "CVER=%%i"
echo  Version now: !CVER!
title NotesMD CLI  v!CVER!
echo. & pause & goto :MENU

:OP15
cls & echo.
echo -- [15] Full Help --
echo.
"!NOTES_CMD!" --help
echo.
echo  Quick Reference:
echo    set-default VAULT
echo    print-default [--path-only]
echo    open NOTE [--vault V] [--section S] [--editor]
echo    daily [--vault V]
echo    search [--vault V] [--editor]
echo    search-content TERM [--vault V] [--editor]
echo    list [PATH] [--vault V]
echo    print NOTE [--vault V]
echo    create NOTE [--content C] [--overwrite^|--append] [--open] [--editor]
echo    move OLD NEW [--vault V] [--open] [--editor]
echo    delete NOTE [--vault V]
echo    frontmatter NOTE --print
echo    frontmatter NOTE --edit --key K --value V
echo    frontmatter NOTE --delete --key K
echo. & pause & goto :MENU

:EXIT
echo.
echo  Goodbye.
echo  Press any key to close...
pause >nul
endlocal
exit /b 0
