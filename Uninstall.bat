@echo off
setlocal EnableExtensions

title Si-Agent-Studio - Uninstall
color 0C

set "ROOT=%~dp0"

echo ============================================================
echo                 Si-Agent-Studio Uninstall
echo ============================================================
echo.
echo This will:
echo - Stop Docker services
echo - Remove node_modules
echo - Remove local logs
echo - Remove local data
echo - Remove saved API keys
echo.
echo Project source files will not be deleted.
echo.

choice /c YN /n /m "Continue? [Y/N]: "
if errorlevel 2 exit /b 0

echo.
echo Stopping OpenWebUI Docker services...
where docker >nul 2>&1
if not errorlevel 1 (
    cd /d "%ROOT%"
    docker compose down >nul 2>&1
)

echo Removing node_modules...
if exist "%ROOT%node_modules" rmdir /s /q "%ROOT%node_modules"

echo Removing logs...
if exist "%ROOT%logs" rmdir /s /q "%ROOT%logs"

echo Removing local data...
if exist "%ROOT%data" rmdir /s /q "%ROOT%data"

echo Removing API key configuration...
if exist "%ROOT%config\agent.env" del /f /q "%ROOT%config\agent.env"

echo.
echo ============================================================
echo              UNINSTALL COMPLETE
echo ============================================================
pause
exit /b 0
