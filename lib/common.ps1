# common.ps1 - NotesMD CLI 원클릭 키트 공통 모듈
# 이 파일은 UTF-8 (BOM) 로 저장됩니다. 한글 UI 담당.
# .bat 런처는 영어(ASCII)만, 한글은 전부 이 PowerShell 계층에서 처리합니다.

# ---- 콘솔을 UTF-8 로 (한글 안 깨지게) ----
function Set-Utf8Console {
    try {
        $OutputEncoding = [System.Text.Encoding]::UTF8
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        try { [Console]::InputEncoding = [System.Text.Encoding]::UTF8 } catch {}
        chcp 65001 > $null 2>&1
    } catch {}
}

# ---- 경로 ----
$script:LibDir   = $PSScriptRoot
$script:KitRoot  = Split-Path $PSScriptRoot -Parent
$script:InstallDir = Join-Path $env:USERPROFILE 'bin'

# 이번 세션 PATH 에 설치 폴더 추가 (새 터미널 안 열어도 바로 인식)
if (Test-Path $script:InstallDir) { $env:PATH = "$script:InstallDir;$env:PATH" }
$script:ScoopShims = Join-Path $env:USERPROFILE 'scoop\shims'
if (Test-Path $script:ScoopShims) { $env:PATH = "$script:ScoopShims;$env:PATH" }

# ---- notesmd-cli 실행 파일 찾기 ----
function Get-NotesCmd {
    $direct = Join-Path $env:USERPROFILE 'bin\notesmd-cli.exe'
    $scoop  = Join-Path $env:USERPROFILE 'scoop\apps\notesmd-cli\current\notesmd-cli.exe'
    if (Test-Path $direct) { return $direct }
    if (Test-Path $scoop)  { return $scoop }
    $c = Get-Command notesmd-cli -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    return $null
}

function Get-NotesVersion([string]$cmd) {
    if (-not $cmd) { return $null }
    try { return (& $cmd --version 2>$null | Select-Object -First 1) } catch { return $null }
}

function Get-DefaultVault([string]$cmd) {
    if (-not $cmd) { return $null }
    try { return (& $cmd print-default 2>$null | Select-Object -First 1) } catch { return $null }
}

function Get-DefaultVaultPath([string]$cmd) {
    if (-not $cmd) { return $null }
    try { return (& $cmd print-default --path-only 2>$null | Select-Object -First 1) } catch { return $null }
}

# ---- Obsidian / 볼트 감지 ----
# 사실: notesmd-cli 는 Obsidian 이 "실행 중"일 필요는 없지만,
#       볼트를 '이름'으로 찾으려면 Obsidian 에 볼트가 등록돼 있어야 가장 쉽다.
function Get-ObsidianInfo {
    $cfg = Join-Path $env:APPDATA 'obsidian\obsidian.json'
    $info = [pscustomobject]@{ Installed = $false; VaultCount = 0; Vaults = @() }
    if (Test-Path $cfg) {
        $info.Installed = $true
        try {
            $j = Get-Content -Raw -Encoding UTF8 $cfg | ConvertFrom-Json
            if ($j.vaults) {
                $names = @()
                foreach ($p in $j.vaults.PSObject.Properties) {
                    $path = $p.Value.path
                    if ($path) { $names += (Split-Path $path -Leaf) }
                }
                $info.Vaults = $names
                $info.VaultCount = $names.Count
            }
        } catch {}
    }
    return $info
}

# ---- 인터넷 연결 확인 (빠른 타임아웃) ----
function Test-Internet {
    try {
        $req = [System.Net.WebRequest]::Create('https://api.github.com')
        $req.Method = 'HEAD'
        $req.Timeout = 6000
        $resp = $req.GetResponse()
        $resp.Close()
        return $true
    } catch { return $false }
}

# ---- 설치 폴더가 사용자 PATH 에 영구 등록돼 있는지 ----
function Test-PathRegistered {
    try {
        $p = [Environment]::GetEnvironmentVariable('PATH', 'User')
        if ($null -eq $p) { return $false }
        return ($p -split ';' | Where-Object { $_ -eq $script:InstallDir }).Count -gt 0
    } catch { return $false }
}

# ---- 형제 .bat(엔진) 실행 ----
function Invoke-KitBat([string]$batName) {
    $bat = Join-Path $script:KitRoot $batName
    if (-not (Test-Path $bat)) {
        Write-Host ("  [!] {0} 파일을 찾을 수 없습니다. 키트를 폴더째로 풀었는지 확인하세요." -f $batName) -ForegroundColor Red
        return
    }
    cmd /c "`"$bat`""
}

# ---- 공통 UI 헬퍼 ----
function Pause-Kit {
    Write-Host ''
    Write-Host '  계속하려면 Enter 키를 누르세요...' -NoNewline -ForegroundColor DarkGray
    [void](Read-Host)
}

function Write-Line([string]$text, [string]$color = 'Gray') {
    Write-Host $text -ForegroundColor $color
}

# =====================================================================
#  Show-SelectMenu : 화살표(↑↓)로 고르고 Enter로 실행하는 안전한 선택기
#  - 추천 항목은 ★ 표시 + 미리 하이라이트 (그냥 Enter = 추천 선택)
#  - 위험(Danger) 항목은 빨강 표시 (실수 방지)
#  - 번호/영문 키를 누르면 그 항목으로 이동(이동만, 실행은 Enter)
#  - 입력이 불가한 환경(리다이렉트 등)에선 자동으로 번호 타이핑으로 폴백
#  Items : @( @{ Key='1'; Label='설치하기'; Hint='...'; Danger=$false; Recommend=$true }, ... )
#  반환값 : 선택된 항목의 Key (문자열). 항목 없으면 $null.
# =====================================================================
function Show-SelectMenu {
    param(
        [string]$Title,
        [array]$Items,
        [string[]]$HeaderLines = @(),
        [string]$RecommendKey
    )
    if (-not $Items -or $Items.Count -eq 0) { return $null }

    # 기본 선택 위치 = 추천 항목 (없으면 첫 항목)
    $sel = 0
    for ($i = 0; $i -lt $Items.Count; $i++) {
        if ($RecommendKey -and ($Items[$i].Key -eq $RecommendKey)) { $sel = $i }
        elseif (-not $RecommendKey -and $Items[$i].Recommend) { $sel = $i }
    }

    # 화살표 입력 가능 여부 판단 (입력 리다이렉트면 타이핑 폴백)
    $interactive = $true
    try { if ([Console]::IsInputRedirected) { $interactive = $false } } catch { $interactive = $false }

    while ($true) {
        Clear-Host
        Write-Host ''
        if ($Title) { Write-Host ('  ' + $Title) -ForegroundColor Cyan; Write-Host '' }
        foreach ($h in $HeaderLines) { Write-Host ('  ' + $h) }
        if ($HeaderLines.Count -gt 0) { Write-Host '' }

        if ($interactive) {
            Write-Host '  [↑][↓] 화살표로 고르고, [Enter] 로 실행   (또는 번호 키)' -ForegroundColor DarkGray
        } else {
            Write-Host '  아래에서 번호를 입력하고 Enter 를 누르세요.' -ForegroundColor DarkGray
        }
        Write-Host ''

        for ($i = 0; $i -lt $Items.Count; $i++) {
            $it = $Items[$i]
            $mark = '  '
            if ($it.Recommend) { $mark = '★ ' }
            $label = ('{0}[{1}] {2}' -f $mark, $it.Key, $it.Label)

            if ($interactive -and ($i -eq $sel)) {
                $fg = 'Black'; $bg = 'White'
                if ($it.Danger) { $fg = 'White'; $bg = 'Red' }
                $text = ('  > ' + $label)
                if ($it.Hint) { $text = $text + '  - ' + $it.Hint }
                Write-Host $text -ForegroundColor $fg -BackgroundColor $bg
            } else {
                $fg = 'Gray'
                if ($it.Danger) { $fg = 'Red' }
                Write-Host ('    ' + $label) -ForegroundColor $fg -NoNewline
                if ($it.Hint) { Write-Host ('  - ' + $it.Hint) -ForegroundColor DarkGray } else { Write-Host '' }
            }
        }
        Write-Host ''

        if (-not $interactive) {
            $keys = (($Items | ForEach-Object { $_.Key }) -join '/')
            $ans = Read-Host ('  번호 선택 [' + $keys + ']')
            if ($null -ne $ans) { $ans = $ans.Trim() }
            if ([string]::IsNullOrEmpty($ans)) {
                if ($RecommendKey) { return $RecommendKey }
                return $Items[$sel].Key
            }
            $hit = $Items | Where-Object { $_.Key -eq $ans }
            if ($hit) { return $ans }
            continue
        }

        $key = [Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow'   { $sel--; if ($sel -lt 0) { $sel = $Items.Count - 1 } }
            'DownArrow' { $sel++; if ($sel -ge $Items.Count) { $sel = 0 } }
            'Enter'     { return $Items[$sel].Key }
            default {
                $ch = ''
                if ($key.KeyChar) { $ch = $key.KeyChar.ToString() }
                for ($i = 0; $i -lt $Items.Count; $i++) {
                    if ($Items[$i].Key -eq $ch) { $sel = $i; break }
                }
            }
        }
    }
}

# ---- 예/아니오 확인 (기본값 지원) ----
function Confirm-YesNo([string]$question, [bool]$defaultYes = $true) {
    $hint = '[Y/n]'; if (-not $defaultYes) { $hint = '[y/N]' }
    $ans = Read-Host ('  ' + $question + ' ' + $hint)
    if ($null -ne $ans) { $ans = $ans.Trim() }
    if ([string]::IsNullOrEmpty($ans)) { return $defaultYes }
    return ($ans.ToUpper() -eq 'Y')
}
