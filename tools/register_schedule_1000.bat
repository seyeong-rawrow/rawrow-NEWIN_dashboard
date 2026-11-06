@echo off
REM NEWIN raw sync - register weekday 10:00 auto-sync task (double-click once)
REM Runs hidden (no window), on battery too, and catches up if the PC was asleep at 10:00.
schtasks /Create /TN "NEWIN raw sync" /TR "conhost.exe --headless powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%~dp0newin_sync.ps1\"" /SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 10:00 /F
powershell -NoProfile -Command "$s = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1); Set-ScheduledTask -TaskName 'NEWIN raw sync' -Settings $s | Out-Null; Write-Host 'settings OK'"
echo.
echo [DONE] Weekday 10:00 auto-sync task registered (hidden).
pause
