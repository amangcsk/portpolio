@echo off
cd /d "%~dp0"
echo Scanning folders... please wait.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-portfolio.ps1"
echo.
pause
