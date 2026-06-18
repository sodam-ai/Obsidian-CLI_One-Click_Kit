# menu.ps1 - NotesMD CLI 원클릭 키트 : 사용하기(한국어 메뉴)
# 이 파일은 UTF-8 (BOM) 로 저장됩니다.
# 실제 명령(notesmd-cli ...)과 인자는 기존 RUN.bat 의 검증된 구성을 그대로 따릅니다.
# 선택은 Show-SelectMenu(화살표+Enter, 추천 하이라이트, 위험 빨강)로 통일합니다.
. (Join-Path $PSScriptRoot 'common.ps1')
Set-Utf8Console

$NotesCmd = Get-NotesCmd
if (-not $NotesCmd) {
    Clear-Host
    Write-Host ''
    Write-Host '  =====================================================' -ForegroundColor Yellow
    Write-Host '      도구가 아직 없습니다 (notesmd-cli 미설치)' -ForegroundColor Yellow
    Write-Host '  =====================================================' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '  해결 방법 :'
    Write-Host '   1) 시작하기 화면으로 돌아가 "설치하기" 를 먼저 누르세요.'
    Write-Host '   2) 설치가 끝나면 다시 "사용하기" 로 오세요.'
    Pause-Kit
    return
}

function Invoke-Notes {
    param([string[]]$Arguments)
    try { & $NotesCmd @Arguments }
    catch { Write-Host ("  [오류] 명령 실행 중 문제: {0}" -f $_) -ForegroundColor Red }
}

function Read-Req([string]$prompt) { return (Read-Host ('  ' + $prompt)) }

# 세부 방식 선택 헬퍼 (제목에 입력값을 같이 보여줘 "확실하게" 선택)
function Pick-Mode([string]$title, [array]$items, [string]$rec) {
    return (Show-SelectMenu -Title $title -Items $items -RecommendKey $rec)
}

function Op-SetVault {
    Clear-Host; Write-Host ''
    Write-Host '  -- 기본 볼트 정하기 --' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '  볼트(노트함) "폴더 이름"만 입력하세요. 예: MyNotes'
    Write-Host '  Obsidian 노트함 폴더 이름과 똑같아야 합니다.' -ForegroundColor DarkGray
    Write-Host ''
    $vn = Read-Req '볼트 이름: '
    if ([string]::IsNullOrWhiteSpace($vn)) { Write-Host '  [안내] 입력이 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    Invoke-Notes @('set-default', $vn)
    if ($LASTEXITCODE -eq 0) { Write-Host ("  [완료] 기본 볼트: {0}" -f $vn) -ForegroundColor Green }
    else { Write-Host '  [오류] 실패. 볼트 이름이 폴더 이름과 정확히 같은지 확인하세요.' -ForegroundColor Red }
    Pause-Kit
}

function Op-VaultInfo {
    Clear-Host; Write-Host ''
    Write-Host '  -- 볼트 정보 --' -ForegroundColor Cyan; Write-Host ''
    Invoke-Notes @('print-default')
    Invoke-Notes @('print-default', '--path-only')
    Pause-Kit
}

function Op-Open {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 열기 --' -ForegroundColor Cyan; Write-Host ''
    $nn = Read-Req '노트 이름 (예: MyNote.md): '
    if ([string]::IsNullOrWhiteSpace($nn)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='Obsidian 에서 열기'; Hint='가장 일반적';        Danger=$false; Recommend=$true },
        @{ Key='2'; Label='편집기에서 열기';     Hint='기본 텍스트 편집기'; Danger=$false; Recommend=$false },
        @{ Key='3'; Label='특정 제목으로';       Hint='문서 안 heading';    Danger=$false; Recommend=$false },
        @{ Key='4'; Label='다른 볼트에서';       Hint='';                   Danger=$false; Recommend=$false },
        @{ Key='5'; Label='다른 볼트+제목';      Hint='';                   Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("노트 열기 : " + $nn) $modes '1'
    switch ($m) {
        '1' { Invoke-Notes @('open', $nn) }
        '2' { Invoke-Notes @('open', $nn, '--editor') }
        '3' { $s = Read-Req '제목(heading): '; Invoke-Notes @('open', $nn, '--section', $s) }
        '4' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('open', $nn, '--vault', $v) }
        '5' { $v = Read-Req '볼트 이름: '; $s = Read-Req '제목(heading): '; Invoke-Notes @('open', $nn, '--vault', $v, '--section', $s) }
    }
    Pause-Kit
}

function Op-Daily {
    $modes = @(
        @{ Key='1'; Label='기본 볼트'; Hint='지금 정한 볼트'; Danger=$false; Recommend=$true },
        @{ Key='2'; Label='다른 볼트'; Hint='';               Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode '오늘 일기(데일리 노트)' $modes '1'
    if ($m -eq '2') { $v = Read-Req '볼트 이름: '; Invoke-Notes @('daily', '--vault', $v) }
    else { Invoke-Notes @('daily') }
    Pause-Kit
}

function Op-Search {
    $modes = @(
        @{ Key='1'; Label='기본 볼트';        Hint='';               Danger=$false; Recommend=$true },
        @{ Key='2'; Label='다른 볼트';        Hint='';               Danger=$false; Recommend=$false },
        @{ Key='3'; Label='편집기에서 열기';  Hint='';               Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode '빠른 검색(파일명)' $modes '1'
    switch ($m) {
        '2' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('search', '--vault', $v) }
        '3' { Invoke-Notes @('search', '--editor') }
        default { Invoke-Notes @('search') }
    }
    Pause-Kit
}

function Op-SearchContent {
    Clear-Host; Write-Host ''
    Write-Host '  -- 내용 검색(글자) --' -ForegroundColor Cyan; Write-Host ''
    $t = Read-Req '찾을 글자: '
    if ([string]::IsNullOrWhiteSpace($t)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='기본 볼트';       Hint=''; Danger=$false; Recommend=$true },
        @{ Key='2'; Label='다른 볼트';       Hint=''; Danger=$false; Recommend=$false },
        @{ Key='3'; Label='편집기에서 열기'; Hint=''; Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("내용 검색 : " + $t) $modes '1'
    switch ($m) {
        '2' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('search-content', $t, '--vault', $v) }
        '3' { Invoke-Notes @('search-content', $t, '--editor') }
        default { Invoke-Notes @('search-content', $t) }
    }
    Pause-Kit
}

function Op-List {
    $modes = @(
        @{ Key='1'; Label='전체';               Hint='볼트 루트';       Danger=$false; Recommend=$true },
        @{ Key='2'; Label='하위폴더';           Hint='폴더 안만';       Danger=$false; Recommend=$false },
        @{ Key='3'; Label='다른 볼트';          Hint='';                Danger=$false; Recommend=$false },
        @{ Key='4'; Label='다른 볼트+하위폴더'; Hint='';                Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode '목록 보기' $modes '1'
    switch ($m) {
        '2' { $f = Read-Req '하위폴더: '; Invoke-Notes @('list', $f) }
        '3' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('list', '--vault', $v) }
        '4' { $v = Read-Req '볼트 이름: '; $f = Read-Req '하위폴더: '; Invoke-Notes @('list', $f, '--vault', $v) }
        default { Invoke-Notes @('list') }
    }
    Pause-Kit
}

function Op-Print {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 내용 출력 --' -ForegroundColor Cyan; Write-Host ''
    $nn = Read-Req '노트 이름: '
    if ([string]::IsNullOrWhiteSpace($nn)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='기본 볼트'; Hint=''; Danger=$false; Recommend=$true },
        @{ Key='2'; Label='다른 볼트'; Hint=''; Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("노트 출력 : " + $nn) $modes '1'
    if ($m -eq '2') { $v = Read-Req '볼트 이름: '; Invoke-Notes @('print', $nn, '--vault', $v) }
    else { Invoke-Notes @('print', $nn) }
    Pause-Kit
}

function Op-Create {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 만들기 / 수정 --' -ForegroundColor Cyan; Write-Host ''
    $nn = Read-Req '노트 이름 (예: MyNote.md): '
    if ([string]::IsNullOrWhiteSpace($nn)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='빈 노트 만들기';     Hint='내용 없이';            Danger=$false; Recommend=$true },
        @{ Key='2'; Label='내용 넣어 만들기';   Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='3'; Label='내용+편집기 열기';   Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='4'; Label='덮어쓰기';           Hint='기존 내용이 사라짐';   Danger=$true;  Recommend=$false },
        @{ Key='5'; Label='뒤에 덧붙이기';      Hint='기존 내용 보존';       Danger=$false; Recommend=$false },
        @{ Key='6'; Label='다른 볼트에 만들기'; Hint='';                     Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("노트 만들기 : " + $nn) $modes '1'
    switch ($m) {
        '1' { Invoke-Notes @('create', $nn) }
        '2' { $ct = Read-Req '내용: '; Invoke-Notes @('create', $nn, '--content', $ct) }
        '3' { $ct = Read-Req '내용: '; Invoke-Notes @('create', $nn, '--content', $ct, '--open', '--editor') }
        '4' {
            Write-Host '  [주의] 덮어쓰기는 기존 내용을 지웁니다.' -ForegroundColor Red
            if (-not (Confirm-YesNo '정말 덮어쓸까요?' $false)) { Write-Host '  [취소]' -ForegroundColor Green; Pause-Kit; return }
            $ct = Read-Req '새 내용: '; Invoke-Notes @('create', $nn, '--content', $ct, '--overwrite')
        }
        '5' { $ct = Read-Req '덧붙일 내용: '; Invoke-Notes @('create', $nn, '--content', $ct, '--append') }
        '6' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('create', $nn, '--vault', $v) }
    }
    Pause-Kit
}

function Op-Move {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 이동 / 이름변경 --' -ForegroundColor Cyan; Write-Host ''
    Write-Host '  (볼트 안의 링크는 자동으로 함께 수정됩니다)' -ForegroundColor DarkGray
    Write-Host ''
    $old = Read-Req '현재 경로: '
    if ([string]::IsNullOrWhiteSpace($old)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $new = Read-Req '새 경로: '
    if ([string]::IsNullOrWhiteSpace($new)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='그냥 이동';        Hint=''; Danger=$false; Recommend=$true },
        @{ Key='2'; Label='이동 후 열기';     Hint=''; Danger=$false; Recommend=$false },
        @{ Key='3'; Label='편집기에서 열기';  Hint=''; Danger=$false; Recommend=$false },
        @{ Key='4'; Label='다른 볼트';        Hint=''; Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("이동 : " + $old + " -> " + $new) $modes '1'
    switch ($m) {
        '2' { Invoke-Notes @('move', $old, $new, '--open') }
        '3' { Invoke-Notes @('move', $old, $new, '--open', '--editor') }
        '4' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('move', $old, $new, '--vault', $v) }
        default { Invoke-Notes @('move', $old, $new) }
    }
    Pause-Kit
}

function Op-Delete {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 삭제 --' -ForegroundColor Red; Write-Host ''
    Write-Host '  [주의] 영구 삭제입니다. 되돌릴 수 없습니다.' -ForegroundColor Red
    Write-Host ''
    $nn = Read-Req '삭제할 노트 경로: '
    if ([string]::IsNullOrWhiteSpace($nn)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='기본 볼트'; Hint=''; Danger=$true; Recommend=$true },
        @{ Key='2'; Label='다른 볼트'; Hint=''; Danger=$true; Recommend=$false }
    )
    $m = Pick-Mode ("삭제 대상 : " + $nn) $modes '1'
    Write-Host ''
    Write-Host ("  정말 삭제할 대상: {0}" -f $nn) -ForegroundColor Yellow
    $cf = Read-Req '삭제하려면 YES 를 입력 (다른 글자=취소): '
    if ($cf -ne 'YES') { Write-Host '  [취소] 아무것도 지우지 않았습니다.' -ForegroundColor Green; Pause-Kit; return }
    if ($m -eq '2') { $v = Read-Req '볼트 이름: '; Invoke-Notes @('delete', $nn, '--vault', $v) }
    else { Invoke-Notes @('delete', $nn) }
    Pause-Kit
}

function Op-Frontmatter {
    Clear-Host; Write-Host ''
    Write-Host '  -- 노트 속성(프론트매터) 관리 --' -ForegroundColor Cyan; Write-Host ''
    $nn = Read-Req '노트 이름: '
    if ([string]::IsNullOrWhiteSpace($nn)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
    $modes = @(
        @{ Key='1'; Label='전체 보기';      Hint='';            Danger=$false; Recommend=$true },
        @{ Key='2'; Label='항목 추가/수정'; Hint='';            Danger=$false; Recommend=$false },
        @{ Key='3'; Label='항목 삭제';      Hint='되돌릴 수 없음'; Danger=$true;  Recommend=$false },
        @{ Key='4'; Label='다른 볼트에서 보기'; Hint='';         Danger=$false; Recommend=$false }
    )
    $m = Pick-Mode ("속성 관리 : " + $nn) $modes '1'
    switch ($m) {
        '1' { Invoke-Notes @('frontmatter', $nn, '--print') }
        '2' {
            $fk = Read-Req '항목 이름(예: status): '
            if ([string]::IsNullOrWhiteSpace($fk)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
            $fv = Read-Req '값: '
            Invoke-Notes @('frontmatter', $nn, '--edit', '--key', $fk, '--value', $fv)
        }
        '3' {
            $fk = Read-Req '삭제할 항목 이름: '
            if ([string]::IsNullOrWhiteSpace($fk)) { Write-Host '  [안내] 비었습니다.' -ForegroundColor Yellow; Pause-Kit; return }
            Invoke-Notes @('frontmatter', $nn, '--delete', '--key', $fk)
        }
        '4' { $v = Read-Req '볼트 이름: '; Invoke-Notes @('frontmatter', $nn, '--print', '--vault', $v) }
    }
    Pause-Kit
}

function Op-Version {
    Clear-Host; Write-Host ''
    Write-Host '  -- 버전 확인 --' -ForegroundColor Cyan; Write-Host ''
    Invoke-Notes @('--version')
    Write-Host ''
    Write-Host ("  실행 파일 : {0}" -f $NotesCmd)
    Write-Host ("  설치 폴더 : {0}" -f $script:InstallDir)
    Write-Host '  공식 GitHub : https://github.com/Yakitrak/notesmd-cli/releases'
    Pause-Kit
}

function Op-Update {
    Clear-Host; Write-Host ''
    Write-Host '  -- 최신 버전으로 업데이트 --' -ForegroundColor Cyan; Write-Host ''
    Write-Host '  현재 버전:'
    Invoke-Notes @('--version')
    Write-Host ''
    Write-Host '  검증된 설치 엔진(INSTALL.bat)을 다시 실행해 최신 버전으로 덮어씁니다.'
    Write-Host '  (노트는 건드리지 않습니다)' -ForegroundColor DarkGray
    if (Confirm-YesNo '진행할까요?' $true) {
        Invoke-KitBat 'INSTALL.bat'
        $script:NotesCmd = Get-NotesCmd
    } else { Write-Host '  [취소]' -ForegroundColor Green; Pause-Kit }
}

function Op-Help {
    Clear-Host; Write-Host ''
    Write-Host '  -- 전체 도움말 (영어 원문) --' -ForegroundColor Cyan; Write-Host ''
    Invoke-Notes @('--help')
    Pause-Kit
}

# ---- 메인 루프 ----
while ($true) {
    $ver   = Get-NotesVersion $NotesCmd
    $vault = Get-DefaultVault $NotesCmd
    $path  = Get-DefaultVaultPath $NotesCmd

    $headers = @(("버전   : {0}" -f $ver))
    if ($vault -and ($vault -notmatch 'not set')) { $headers += ("볼트   : {0}" -f $vault) }
    else { $headers += "볼트   : 아직 안 정함 ( [1] 에서 정하세요 )" }
    if ($path) { $headers += ("위치   : {0}" -f $path) }

    $novault = (-not $vault) -or ($vault -match 'not set')
    $rec = $null; if ($novault) { $rec = '1' }

    $items = @(
        @{ Key='1';  Label='기본 볼트 정하기'; Hint='맨 처음 한 번';        Danger=$false; Recommend=($rec -eq '1') },
        @{ Key='2';  Label='볼트 정보 보기';   Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='3';  Label='노트 열기';        Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='4';  Label='오늘 일기';        Hint='데일리 노트';          Danger=$false; Recommend=$false },
        @{ Key='5';  Label='빠른 검색';        Hint='파일명으로';           Danger=$false; Recommend=$false },
        @{ Key='6';  Label='내용 검색';        Hint='글자로';               Danger=$false; Recommend=$false },
        @{ Key='7';  Label='목록 보기';        Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='8';  Label='노트 내용 출력';   Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='9';  Label='노트 만들기/수정'; Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='10'; Label='노트 이동/이름변경'; Hint='';                   Danger=$false; Recommend=$false },
        @{ Key='11'; Label='노트 삭제';        Hint='영구 - 주의';          Danger=$true;  Recommend=$false },
        @{ Key='12'; Label='노트 속성 관리';   Hint='프론트매터';           Danger=$false; Recommend=$false },
        @{ Key='13'; Label='버전 확인';        Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='14'; Label='최신 업데이트';    Hint='';                     Danger=$false; Recommend=$false },
        @{ Key='15'; Label='전체 도움말';      Hint='영어 원문';            Danger=$false; Recommend=$false },
        @{ Key='0';  Label='뒤로(시작 화면)';  Hint='';                     Danger=$false; Recommend=$false }
    )

    $c = Show-SelectMenu -Title 'NotesMD CLI - 사용하기 메뉴' -Items $items -HeaderLines $headers -RecommendKey $rec
    switch ($c) {
        '1'  { Op-SetVault }
        '2'  { Op-VaultInfo }
        '3'  { Op-Open }
        '4'  { Op-Daily }
        '5'  { Op-Search }
        '6'  { Op-SearchContent }
        '7'  { Op-List }
        '8'  { Op-Print }
        '9'  { Op-Create }
        '10' { Op-Move }
        '11' { Op-Delete }
        '12' { Op-Frontmatter }
        '13' { Op-Version }
        '14' { Op-Update }
        '15' { Op-Help }
        '0'  { break }
        default { }
    }
    if ($c -eq '0') { break }
}
