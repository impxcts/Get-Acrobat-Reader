@echo off
REM Double-click launcher for Install-AcrobatReader.ps1
REM Self-elevates to admin, then runs the PowerShell installer.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Install-AcrobatReader.ps1"
pause
