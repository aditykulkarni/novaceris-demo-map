@echo off
rem One-time: lets this laptop serve the demo to other machines on port 8080 (asks for administrator rights).
net session >nul 2>&1
if errorlevel 1 (
  powershell -NoProfile -Command "Start-Process -Verb RunAs -FilePath '%~f0'"
  exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0network-setup.ps1"
