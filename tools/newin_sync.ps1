# NEWIN raw 자동 동기화 - G: 공유드라이브 raw 폴더를 이 스크립트 옆 'raw' 폴더로 미러
$ErrorActionPreference = "Continue"
# ▼ 구글드라이브 원본 폴더. 내 PC에서 경로가 다르면(드라이브 문자 등) 이 한 줄만 고치세요.
$SRC = "G:\공유 드라이브\DRIVE3. 운영\00_AX"
$DST = Join-Path $PSScriptRoot "raw"

Write-Host "[NEWIN sync] 시작: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

robocopy "$SRC\A. raw input"        "$DST\A. raw input"        /E /R:2 /W:2 /NFL /NDL /NP /XD "_backfill" | Out-Null
robocopy "$SRC\A-1. raw input (MP)" "$DST\A-1. raw input (MP)" /E /R:2 /W:2 /NFL /NDL /NP | Out-Null
robocopy "$SRC\d. new in"           "$DST\d. new in"           "발매정보.xlsx" /R:2 /W:2 /NFL /NDL /NP | Out-Null

$n = (Get-ChildItem -Recurse -File $DST | Measure-Object).Count
Write-Host "[NEWIN sync] 완료 -> $DST  (파일 $($n)개)  $(Get-Date -Format 'HH:mm:ss')"
