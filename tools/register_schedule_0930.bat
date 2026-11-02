@echo off
REM NEWIN raw sync - register weekday 09:30 auto-sync task (double-click once)
schtasks /Create /TN "NEWIN raw sync" /TR "powershell -NoProfile -ExecutionPolicy Bypass -File \"%~dp0newin_sync.ps1\"" /SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 09:30 /F
echo.
echo [DONE] Weekday 09:30 auto-sync task registered.
pause
