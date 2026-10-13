@echo off
rem Starts the Novaceris demo on http://localhost:8080 and opens the browser. Close the window to stop it.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1"
if errorlevel 1 pause
