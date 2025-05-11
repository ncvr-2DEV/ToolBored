@echo off
PowerShell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass', '-File .\bin\TB.ps1' -NoNewWindow"