@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - View Logs
color 0B

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"
set "SETUP_LOG=%LOG_DIR%\setup.log"

cd /d "%ROOT%"

echo.
echo ============================================================
echo            Si-Agent-Studio - View Logs
echo ============================================================
echo.

if not exist "%SETUP_LOG%" (
    echo [ERROR] setup.log not found.
    echo Run "Setup.bat" first.
    echo.
    pause
    exit /b 1
)

echo Displaying setup logs...
echo.
type "%SETUP_LOG%"

echo.
echo.
echo ============================================================
echo.
echo To view gateway logs, open: %LOG_DIR%\gateway.log
echo To view docker logs, open: %LOG_DIR%\docker.log
echo.
pause
exit /b 0
