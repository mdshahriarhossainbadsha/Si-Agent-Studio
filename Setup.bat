@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Si-Agent-Studio - Setup
color 0B

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"
set "CONFIG_DIR=%ROOT%config"
set "DATA_DIR=%ROOT%data"

cd /d "%ROOT%"

echo.
echo ============================================================
echo              Si-Agent-Studio Setup
echo ============================================================
echo.

call :progress 0 "Initializing environment"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"

if not exist "%LOG_DIR%\setup.log" type nul > "%LOG_DIR%\setup.log"

call :progress 20 "Checking Node.js"
where node >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] Node.js was not found.
    echo Download Node.js LTS from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('node --version') do set "NODE_VERSION=%%v"
echo Node.js !NODE_VERSION! detected.
echo Node.js !NODE_VERSION!>>"%LOG_DIR%\setup.log"

call :progress 40 "Checking Git"
where git >nul 2>&1
if errorlevel 1 (
    echo.
    echo [WARNING] Git was not found.
    echo Git is recommended for dependency management.
    echo Download Git from: https://git-scm.com/download/win
    echo.
    choice /c YN /n /m "Continue without Git? [Y/N]: "
    if errorlevel 2 exit /b 1
) else (
    for /f "tokens=*" %%v in ('git --version') do echo %%v
)

call :progress 60 "Creating folders and configuration"

if not exist "%CONFIG_DIR%\agent.env" (
    if exist "%CONFIG_DIR%\agent.env.example" (
        copy /y "%CONFIG_DIR%\agent.env.example" "%CONFIG_DIR%\agent.env" >nul
    ) else (
        (
            echo OPENCLAW_PORT=18789
            echo OPENWEBUI_PORT=3000
            echo OPENCLAW_START_COMMAND=npx openclaw gateway --port 18789
        ) > "%CONFIG_DIR%\agent.env"
    )
)

call :progress 80 "Installing Node.js dependencies"

if not exist "%ROOT%package.json" (
    echo [ERROR] package.json is missing.
    pause
    exit /b 1
)

call npm install >> "%LOG_DIR%\setup.log" 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] npm install failed.
    echo Check: "%LOG_DIR%\setup.log"
    pause
    exit /b 1
)

call :progress 100 "Setup completed"

echo.
echo ============================================================
echo                 SETUP COMPLETE! (100%%)
echo ============================================================
echo.
echo Next step:
echo   1. Run "Add API Key.bat"
echo   2. Run "Start Si Agent.bat"
echo.
pause
exit /b 0


:progress
set "PERCENT=%~1"
set "MESSAGE=%~2"
set "REMAINING=100"
set /a REMAINING=100-PERCENT
echo.
echo [ %PERCENT%%% complete ^| %REMAINING%%% remaining ] - %MESSAGE%
timeout /t 1 /nobreak >nul
exit /b 0
