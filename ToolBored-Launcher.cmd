@echo off
PowerShell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass', '-File .\TB.ps1' -NoNewWindow"