# NEWIN raw 자동 동기화 - G: 공유드라이브 raw 폴더를 이 스크립트 옆 'raw' 폴더로 미러
$ErrorActionPreference = "Continue"
# ▼ 구글드라이브 원본 폴더. 내 PC에서 경로가 다르면(드라이브 문자 등) 이 한 줄만 고치세요.
$SRC = "G:\공유 드라이브\DRIVE3. 운영\00_AX"
$DST = Join-Path $PSScriptRoot "raw"
$LOG = Join-Path $PSScriptRoot "sync_log.txt"

function Log($msg) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $msg"
    Write-Host "[NEWIN sync] $line"
    Add-Content -Path $LOG -Value $line -Encoding UTF8
}

Log "시작"

# G: 드라이브가 아직 안 붙었으면 최대 5분(30초 x 10회) 기다림
$tries = 0
while (-not (Test-Path "$SRC\A. raw input") -and $tries -lt 10) {
    $tries++
    Log "원본 폴더 없음 - 구글드라이브 연결 대기 ($tries/10)"
    Start-Sleep -Seconds 30
}
if (-not (Test-Path "$SRC\A. raw input")) {
    Log "실패: 원본 폴더를 찾을 수 없음 ($SRC). 구글드라이브 실행/로그인 확인 필요"
    exit 1
}

robocopy "$SRC\A. raw input"        "$DST\A. raw input"        /E /R:2 /W:2 /NFL /NDL /NP /XD "_backfill" | Out-Null
$rc1 = $LASTEXITCODE
robocopy "$SRC\A-1. raw input (MP)" "$DST\A-1. raw input (MP)" /E /R:2 /W:2 /NFL /NDL /NP | Out-Null
$rc2 = $LASTEXITCODE
robocopy "$SRC\d. new in"           "$DST\d. new in"           "발매정보.xlsx" /R:2 /W:2 /NFL /NDL /NP | Out-Null
$rc3 = $LASTEXITCODE

$n = (Get-ChildItem -Recurse -File $DST | Measure-Object).Count
$status = if ($rc1 -ge 8 -or $rc2 -ge 8 -or $rc3 -ge 8) { "일부 실패" } else { "완료" }
Log "$status (robocopy 코드 $rc1/$rc2/$rc3, 8 이상이면 오류) -> 파일 $($n)개"
