@echo off
if not "%1"=="h" start /min cmd /c "%~f0" h & exit
PowerShell -ExecutionPolicy Bypass -File .\bin\install.ps1
