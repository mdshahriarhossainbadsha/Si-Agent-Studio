@echo off
setlocal

title Si-Agent-Studio - Live Logs
color 0E

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo ============================================================
echo                  Si-Agent-Studio Logs
echo ============================================================
echo.
echo [1] OpenClaw log
echo [2] OpenWebUI log
echo [3] Setup log
echo [Q] Quit
echo.

choice /c 123Q /n /m "Select log: "

if errorlevel 4 exit /b 0
if errorlevel 3 set "LOG_FILE=%LOG_DIR%\setup.log"
if errorlevel 2 set "LOG_FILE=%LOG_DIR%\openwebui.log"
if errorlevel 1 set "LOG_FILE=%LOG_DIR%\openclaw.log"

if not exist "%LOG_FILE%" (
    echo.
    echo Log file does not exist yet:
    echo %LOG_FILE%
    pause
    exit /b 0
)

cls
echo Showing live log:
echo %LOG_FILE%
echo Press CTRL+C to stop.
echo.

powershell -NoProfile -Command ^
 "Get-Content -Path '%LOG_FILE%' -Wait -Tail 40"
