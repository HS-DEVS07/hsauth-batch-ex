@echo off
setlocal EnableDelayedExpansion
title HS DEVS AUTH - Shell Client
color 0b

:: Configuration
set "APP_NAME=YOUR_APP_NAME"
set "APP_SECRET=YOUR_APP_SECRET"
set "OWNER_ID=YOUR_OWNER_ID"
set "APP_VERSION=1.0"
set "API_URL=https://auth.hsdevs.pro/api/1.3/"

echo ========================================================
echo    HS DEVS AUTH - SECURE COMMAND-LINE CLIENT
echo ========================================================
echo.

:: Initialize Session
echo [*] Initializing session...
for /f "tokens=*" %%a in ('curl -s -X POST "!API_URL!" -d "type=init" -d "name=!APP_NAME!" -d "ownerid=!OWNER_ID!" -d "ver=!APP_VERSION!"') do set "RESPONSE=%%a"

echo !RESPONSE! | findstr /C:""success":true" >nul
if !errorlevel! neq 0 (
    echo [-] Initialization error: !RESPONSE!
    pause
    exit /b 1
)

:: Extract session ID
for /f "tokens=4 delims=:"," %%s in ('echo !RESPONSE! ^| findstr "sessionid"') do set "SESSION_ID=%%s"
echo [+] Connected! Session ID: !SESSION_ID!
echo.

set /p "KEY=Enter License Key: "

for /f "tokens=*" %%a in ('curl -s -X POST "!API_URL!" -d "type=license" -d "key=!KEY!" -d "sessionid=!SESSION_ID!" -d "name=!APP_NAME!" -d "ownerid=!OWNER_ID!"') do set "AUTH_RES=%%a"

echo !AUTH_RES! | findstr /C:""success":true" >nul
if !errorlevel! equ 0 (
    echo.
    echo ========================================================
    echo [+] ACCESS GRANTED! LICENSE VERIFIED.
    echo ========================================================
    echo.
) else (
    echo.
    echo [-] ACCESS DENIED: Invalid license.
    echo.
)
pause
