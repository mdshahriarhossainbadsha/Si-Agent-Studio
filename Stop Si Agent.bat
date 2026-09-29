@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - Stop Services
color 0B

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"

cd /d "%ROOT%"

echo.
echo ============================================================
echo           Si-Agent-Studio - Stopping Services
echo ============================================================
echo.

echo Stopping OpenClaw Gateway...
taskkill /FI "WINDOWTITLE eq OpenClaw*" /T /F >nul 2>&1

echo Stopping OpenWebUI Docker container...
docker-compose down >> "%LOG_DIR%\docker.log" 2>&1

echo.
echo ============================================================
echo              Services Stopped
echo ============================================================
echo.
pause
exit /b 0
