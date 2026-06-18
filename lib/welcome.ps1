# welcome.ps1 - NotesMD CLI 원클릭 키트 : 시작하기(허브)
# 이 파일은 UTF-8 (BOM) 로 저장됩니다.
. (Join-Path $PSScriptRoot 'common.ps1')
Set-Utf8Console

function Show-Explain {
    Clear-Host
    Write-Host ''
    Write-Host '  -- 쉬운 설명 : 이게 다 뭔가요? --' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '  - Obsidian(옵시디언) : 글(노트)을 정리하는 무료 프로그램입니다.'
    Write-Host '    노트들은 "볼트(vault)"라는 한 폴더 안에 .md 파일로 저장됩니다.'
    Write-Host ''
    Write-Host '  - NotesMD CLI : 그 노트들을 "창을 안 열고" 명령으로 다루는 도구입니다.'
    Write-Host '    노트 만들기/검색/열기/이동을 빠르게 할 수 있습니다.'
    Write-Host ''
    Write-Host '  - 이 키트 : 위 도구를 비개발자도 원클릭으로 깔고 쓰게 도와줍니다.'
    Write-Host ''
    Write-Host '  [중요] 도구를 쓰려면 "노트함(볼트)"이 하나 있어야 합니다.' -ForegroundColor Yellow
    Write-Host '   - 가장 쉬운 방법 : Obsidian 을 깔고 노트함을 1개 만드세요.'
    Write-Host '     다운로드 : https://obsidian.md'
    Write-Host '   - 그 다음, 사용하기 메뉴에서 "기본 볼트 정하기"에 그'
    Write-Host '     노트함 "폴더 이름"을 똑같이 입력하면 됩니다.'
    Write-Host ''
    Write-Host '  - Obsidian 이 "실행 중"일 필요는 없습니다. 노트함만 있으면 됩니다.' -ForegroundColor DarkGray
    Pause-Kit
}

# ---- 메인 루프 ----
while ($true) {
    $cmd   = Get-NotesCmd
    $ver   = Get-NotesVersion $cmd
    $vault = $null
    if ($cmd) { $vault = Get-DefaultVault $cmd }
    $obs   = Get-ObsidianInfo

    # 상태 줄
    $headers = @()
    if ($cmd) { $headers += ("설치 상태 : 설치됨  ({0})" -f $ver) }
    else      { $headers += "설치 상태 : 아직 설치 안 됨" }
    if ($cmd -and $vault -and ($vault -notmatch 'not set')) { $headers += ("기본 볼트 : {0}" -f $vault) }
    elseif ($cmd) { $headers += "기본 볼트 : 아직 안 정함" }
    if ($obs.Installed) { $headers += ("Obsidian  : 감지됨 (노트함 {0}개)" -f $obs.VaultCount) }
    else { $headers += "Obsidian  : 안 보임 (노트함을 이름으로 쓰려면 설치 권장)" }

    # 지금 추천(=Enter 기본값) 동적 결정
    if (-not $cmd) { $rec = '1' }
    elseif (-not $obs.Installed) { $rec = '5' }
    elseif (-not $vault -or ($vault -match 'not set')) { $rec = '2' }
    else { $rec = '2' }

    $items = @(
        @{ Key='1'; Label='설치하기';  Hint='이 컴퓨터에 도구를 깝니다';            Danger=$false; Recommend=($rec -eq '1') },
        @{ Key='2'; Label='사용하기';  Hint='노트 만들기/검색/열기 (한국어 메뉴)';   Danger=$false; Recommend=($rec -eq '2') },
        @{ Key='3'; Label='자가진단';  Hint='무엇이 되고 안 되는지 점검 + 결과 저장'; Danger=$false; Recommend=($rec -eq '3') },
        @{ Key='4'; Label='제거하기';  Hint='도구만 삭제 (노트는 안 지움)';          Danger=$true;  Recommend=$false },
        @{ Key='5'; Label='쉬운 설명'; Hint='이게 다 뭔가요?';                       Danger=$false; Recommend=($rec -eq '5') },
        @{ Key='0'; Label='종료';      Hint='';                                      Danger=$false; Recommend=$false }
    )

    $choice = Show-SelectMenu -Title 'Obsidian 노트 도구 (NotesMD CLI) - 시작하기' -Items $items -HeaderLines $headers -RecommendKey $rec

    switch ($choice) {
        '1' { Invoke-KitBat 'INSTALL.bat' }
        '2' {
            $menu = Join-Path $script:LibDir 'menu.ps1'
            if (Test-Path $menu) { & $menu } else { Write-Host '  [!] menu.ps1 누락' -ForegroundColor Red; Pause-Kit }
        }
        '3' {
            $sc = Join-Path $script:LibDir 'selfcheck.ps1'
            if (Test-Path $sc) { & $sc } else { Write-Host '  [!] selfcheck.ps1 누락' -ForegroundColor Red; Pause-Kit }
        }
        '4' { Invoke-KitBat 'UNINSTALL.bat' }
        '5' { Show-Explain }
        '0' { Clear-Host; Write-Host ''; Write-Host '  안녕히 가세요.' -ForegroundColor Cyan; Write-Host ''; break }
        default { }
    }
    if ($choice -eq '0') { break }
}
