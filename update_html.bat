@echo off
setlocal enabledelayedexpansion

:: Read the first argument provided to the script as the API Gateway URL
set API_URL=%1

:: Use the Windows built-in powershell tool to replace the placeholder with the API Gateway URL
powershell -command "(Get-Content index.html) -replace 'await fetch\(''PLACEHOLDER_API_URL', 'await fetch(''!API_URL!' | Set-Content index.html"

endlocal
