@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - Complete Setup
color 0B

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"
set "CONFIG_DIR=%ROOT%config"
set "DATA_DIR=%ROOT%data"
set "GATEWAY_LOG=%LOG_DIR%\gateway.log"
set "SETUP_LOG=%LOG_DIR%\setup.log"

cd /d "%ROOT%"

echo.
echo ============================================================
echo              Si-Agent-Studio - Complete Setup
echo ============================================================
echo.

REM Create directories
call :run_task "Creating directories" 0 100
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
type nul > "%SETUP_LOG%"

echo [%date% %time%] Setup started >> "%SETUP_LOG%"

REM Check Node.js
call :run_task "Checking Node.js" 0 100
where node >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] Node.js was not found.
    echo Download Node.js LTS from: https://nodejs.org/
    echo [%date% %time%] Node.js not found >> "%SETUP_LOG%"
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do set "NODE_VERSION=%%v"
echo Node.js %NODE_VERSION% detected.
echo [%date% %time%] Node.js %NODE_VERSION% detected >> "%SETUP_LOG%"

REM Check npm
call :run_task "Checking npm" 0 100
where npm >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] npm was not found.
    echo [%date% %time%] npm not found >> "%SETUP_LOG%"
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('npm --version') do set "NPM_VERSION=%%v"
echo npm %NPM_VERSION% detected.
echo [%date% %time%] npm %NPM_VERSION% detected >> "%SETUP_LOG%"

REM Check Docker
call :run_task "Checking Docker" 0 100
where docker >nul 2>&1
if errorlevel 1 (
    echo.
    echo [WARNING] Docker was not found.
    echo OpenWebUI requires Docker. Download from: https://www.docker.com/products/docker-desktop
    echo [%date% %time%] Docker not found >> "%SETUP_LOG%"
    echo.
    choice /c YN /n /m "Continue without Docker? [Y/N]: "
    if errorlevel 2 exit /b 1
) else (
    for /f "tokens=*" %%v in ('docker --version') do set "DOCKER_VERSION=%%v"
    echo !DOCKER_VERSION!
    echo [%date% %time%] !DOCKER_VERSION! detected >> "%SETUP_LOG%"
)

REM Create config files
call :run_task "Creating configuration files" 0 100
if not exist "%CONFIG_DIR%\agent.env" (
    (
        echo # Si-Agent-Studio Configuration
        echo OPENCLAW_PORT=18789
        echo OPENWEBUI_PORT=3000
        echo OPENWEBUI_BASE_URL=http://localhost:3000
        echo OPENCLAW_GATEWAY_URL=http://localhost:18789
        echo ENABLE_AUTH=true
    ) > "%CONFIG_DIR%\agent.env"
    echo Created %CONFIG_DIR%\agent.env
    echo [%date% %time%] Created agent.env >> "%SETUP_LOG%"
)

if not exist "%CONFIG_DIR%\docker.env" (
    (
        echo # OpenWebUI Docker Configuration
        echo OPENAI_API_BASE_URL=http://host.docker.internal:18789/v1
        echo ENABLE_OPENAI_API=true
        echo WEBUI_SECRET_KEY=change-me-in-production
    ) > "%CONFIG_DIR%\docker.env"
    echo Created %CONFIG_DIR%\docker.env
    echo [%date% %time%] Created docker.env >> "%SETUP_LOG%"
)

REM Install OpenClaw globally
call :run_task "Installing OpenClaw globally" 0 100
echo Installing OpenClaw (this may take a minute)...
npm install -g openclaw >> "%SETUP_LOG%" 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] OpenClaw installation failed.
    echo Check: "%SETUP_LOG%"
    echo [%date% %time%] OpenClaw installation failed >> "%SETUP_LOG%"
    echo.
    pause
    exit /b 1
)
echo OpenClaw installed successfully.
echo [%date% %time%] OpenClaw installed successfully >> "%SETUP_LOG%"

echo.
call :run_task "Setup completed" 0 100

echo.
echo ============================================================
echo                 SETUP COMPLETE! (100%%)
echo ============================================================
echo.
echo Next steps:
echo   1. Run "Configure Auth.bat" (to set authentication token)
echo   2. Run "Add API Key.bat" (to add your OpenAI API key)
echo   3. Run "Start Si Agent.bat" (to start the services)
echo.
echo Log file: %SETUP_LOG%
echo.
pause
exit /b 0

:run_task
set "TASK=%~1"
set "START=%~2"
set "END=%~3"

for /l %%i in (%START%,5,%END%) do (
    set /a FILLED=%%i/5
    set "BAR="
    for /l %%b in (1,1,!FILLED!) do set "BAR=!BAR!█"
    for /l %%c in (!FILLED!,1,20) do set "BAR=!BAR!░"
    cls
    echo.
    echo ============================================================
    echo              Si-Agent-Studio - Setup
    echo ============================================================
    echo.
    echo %TASK%
    echo.
    echo %%i%% !BAR! 100%%
    echo.
    powershell -NoProfile -Command "Start-Sleep -Milliseconds 70" >nul 2>&1
)

cls
echo.
echo ============================================================
echo              Si-Agent-Studio - Setup
echo ============================================================
echo.
echo %TASK%
echo.
echo 100%% ████████████████████████████████████████████████████████████ 100%%
echo.
exit /b 0
