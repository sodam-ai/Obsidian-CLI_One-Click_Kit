# selfcheck.ps1 - NotesMD CLI 원클릭 키트 : 자가진단
# 이 파일은 UTF-8 (BOM) 로 저장됩니다.
# 설치 없이 환경을 점검하고, 결과를 바탕화면 텍스트 파일로 저장합니다.
. (Join-Path $PSScriptRoot 'common.ps1')
Set-Utf8Console

Clear-Host
Write-Host ''
Write-Host '  =====================================================' -ForegroundColor Cyan
Write-Host '      NotesMD CLI  -  자가진단' -ForegroundColor Cyan
Write-Host '  =====================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host '  점검 중입니다... 잠시만요.' -ForegroundColor DarkGray
Write-Host ''

$lines = @()
function Add-Result([string]$ok, [string]$label, [string]$detail) {
    # $ok : 'OK' / 'WARN' / 'FAIL'
    $mark = '[  ?  ]'
    $color = 'Gray'
    if ($ok -eq 'OK')   { $mark = '[ 정상 ]'; $color = 'Green' }
    if ($ok -eq 'WARN') { $mark = '[ 주의 ]'; $color = 'Yellow' }
    if ($ok -eq 'FAIL') { $mark = '[ 문제 ]'; $color = 'Red' }
    Write-Host ("  {0}  {1}" -f $mark, $label) -ForegroundColor $color
    if ($detail) { Write-Host ("           - {0}" -f $detail) -ForegroundColor DarkGray }
    $script:lines += ("{0}  {1}" -f $mark, $label)
    if ($detail) { $script:lines += ("           - {0}" -f $detail) }
}

# 1) PowerShell
$psv = $PSVersionTable.PSVersion.ToString()
Add-Result 'OK' ('PowerShell 버전: ' + $psv) ''

# 2) notesmd-cli 설치 여부
$cmd = Get-NotesCmd
if ($cmd) {
    $ver = Get-NotesVersion $cmd
    Add-Result 'OK' '도구 설치됨 (notesmd-cli)' ("버전 {0} / 위치 {1}" -f $ver, $cmd)
} else {
    Add-Result 'FAIL' '도구가 설치되어 있지 않음' '시작하기 -> 1) 설치하기 를 먼저 실행하세요.'
}

# 3) PATH 등록 여부
if (Test-PathRegistered) {
    Add-Result 'OK' 'PATH 등록됨 (어느 터미널에서나 인식)' $script:InstallDir
} else {
    if ($cmd) { Add-Result 'WARN' 'PATH 영구등록 안 됨' '새 터미널에서 명령이 안 되면 설치를 다시 실행하세요.' }
    else { Add-Result 'WARN' 'PATH 미등록 (설치 후 등록됩니다)' '' }
}

# 4) Obsidian / 볼트
$obs = Get-ObsidianInfo
if ($obs.Installed -and $obs.VaultCount -gt 0) {
    Add-Result 'OK' ('Obsidian 노트함 감지: ' + $obs.VaultCount + '개') (($obs.Vaults -join ', '))
} elseif ($obs.Installed) {
    Add-Result 'WARN' 'Obsidian 은 있으나 노트함(볼트)이 없음' 'Obsidian 에서 노트함을 1개 만드세요.'
} else {
    Add-Result 'WARN' 'Obsidian 안 보임' '노트함을 이름으로 쓰려면 https://obsidian.md 설치 권장 (실행 중일 필요는 없음).'
}

# 5) 기본 볼트 설정 여부
if ($cmd) {
    $vault = Get-DefaultVault $cmd
    if ($vault -and ($vault -notmatch 'not set')) {
        Add-Result 'OK' ('기본 볼트 정해짐: ' + $vault) ''
    } else {
        Add-Result 'WARN' '기본 볼트가 아직 안 정해짐' '사용하기 -> [1] 기본 볼트 정하기 에서 설정하세요.'
    }
}

# 6) 인터넷 (설치/업데이트에 필요)
if (Test-Internet) {
    Add-Result 'OK' '인터넷 연결됨 (GitHub 접속 가능)' ''
} else {
    Add-Result 'WARN' '인터넷 확인 실패' '설치/업데이트가 안 되면 네트워크/방화벽을 확인하세요.'
}

# ---- 결과 파일 저장 ----
Write-Host ''
$stamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
$desktop = [Environment]::GetFolderPath('Desktop')
$outFile = Join-Path $desktop 'NotesMD-CLI_진단결과.txt'
$header = @(
    '=====================================================',
    ' NotesMD CLI 원클릭 키트 - 자가진단 결과',
    (' 점검 시각: ' + $stamp),
    '=====================================================',
    ''
)
try {
    ($header + $script:lines) | Out-File -FilePath $outFile -Encoding UTF8
    Write-Host ("  결과를 저장했습니다: {0}" -f $outFile) -ForegroundColor Cyan
    Write-Host '  (막혔을 때 이 파일을 보여주면 원인 찾기가 쉽습니다)' -ForegroundColor DarkGray
} catch {
    Write-Host ("  [안내] 결과 파일 저장 실패: {0}" -f $_) -ForegroundColor Yellow
}

Pause-Kit
