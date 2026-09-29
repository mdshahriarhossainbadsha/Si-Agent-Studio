@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - Starting Services
color 0B

set "ROOT=%~dp0"
set "CONFIG_DIR=%ROOT%config"
set "LOG_DIR=%ROOT%logs"
set "GATEWAY_LOG=%LOG_DIR%\gateway.log"
set "DOCKER_LOG=%LOG_DIR%\docker.log"

cd /d "%ROOT%"

echo.
echo ============================================================
echo           Si-Agent-Studio - Starting Services
echo ============================================================
echo.

REM Check if auth token exists
if not exist "%CONFIG_DIR%\auth-token.txt" (
    echo [ERROR] Authentication not configured.
    echo Please run "Configure Auth.bat" first.
    echo.
    pause
    exit /b 1
)

REM Check if API key exists
if not exist "%USERPROFILE%\.openclaw\api-keys.env" (
    echo [ERROR] API key not configured.
    echo Please run "Add API Key.bat" first.
    echo.
    pause
    exit /b 1
)

echo Starting OpenClaw Gateway on port 18789...
echo [%date% %time%] Starting OpenClaw Gateway >> "%GATEWAY_LOG%"
start "OpenClaw Gateway" cmd /k openclaw gateway --port 18789 >> "%GATEWAY_LOG%" 2>&1

echo Waiting for gateway to start...
timeout /t 3 /nobreak >nul

echo.
echo Starting OpenWebUI on port 3000...
echo [%date% %time%] Starting OpenWebUI with Docker >> "%DOCKER_LOG%"

REM Check if docker-compose.yml exists
if not exist "%ROOT%docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found.
    echo.
    pause
    exit /b 1
)

REM Start Docker container
cd /d "%ROOT%"
docker-compose --env-file "%CONFIG_DIR%\docker.env" up -d >> "%DOCKER_LOG%" 2>&1

if errorlevel 1 (
    echo [ERROR] Failed to start Docker container.
    echo Check: %DOCKER_LOG%
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo              Services Started Successfully!
echo ============================================================
echo.
echo OpenClaw Gateway:
    echo   URL: http://localhost:18789
    echo   Control UI: http://localhost:18789/ui
    echo.
echo OpenWebUI:
    echo   URL: http://localhost:3000
    echo   Chat Interface: http://localhost:3000/chat
    echo.
echo Logs:
    echo   Gateway: %GATEWAY_LOG%
    echo   Docker: %DOCKER_LOG%
    echo.
echo To stop services, run: "Stop Si Agent.bat"
echo.
pause
exit /b 0
