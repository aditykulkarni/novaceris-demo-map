@echo off
rem Starts the Novaceris demo for other machines too: http://%COMPUTERNAME%:8080 (run "Network setup (admin).bat" once first).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" -Network
if errorlevel 1 pause
