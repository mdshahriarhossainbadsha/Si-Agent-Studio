@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Si-Agent-Studio - Setup
color 0B

set "ROOT=%~dp0"
set "LOG_DIR=%ROOT%logs"
set "CONFIG_DIR=%ROOT%config"
set "DATA_DIR=%ROOT%data"
set "NPM_LOG=%LOG_DIR%\npm-install.log"
set "NPM_DONE=%TEMP%\si-agent-npm-done-%RANDOM%.txt"
set "NPM_RUNNER=%TEMP%\si-agent-npm-runner-%RANDOM%.bat"

cd /d "%ROOT%"

echo.
echo ============================================================
echo              Si-Agent-Studio Setup
echo ============================================================
echo.
echo Each task shows a live 0%% to 100%% progress while running.
echo.

call :print_status 0 "Initializing environment"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOG_DIR%\setup.log" type nul > "%LOG_DIR%\setup.log"

call :print_status 20 "Checking Node.js"
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

call :print_status 40 "Checking Git"
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

call :print_status 60 "Creating folders and configuration"
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

if not exist "%ROOT%package.json" (
    echo [ERROR] package.json is missing.
    pause
    exit /b 1
)

call :print_status 80 "Installing Node.js dependencies"
(
    echo @echo off
    echo cd /d "%ROOT%"
    echo call npm install ^> "%NPM_LOG%" 2^>^&1
    echo echo done^> "%NPM_DONE%"
) > "%NPM_RUNNER%"

start "Si-Agent-Studio npm install" /b cmd /c "%NPM_RUNNER%"
set /a INSTALL_PROGRESS=0
:install_wait
if exist "%NPM_DONE%" goto install_done
set /a INSTALL_PROGRESS+=5
if %INSTALL_PROGRESS% gtr 95 set /a INSTALL_PROGRESS=95
call :print_task 80 "Installing Node.js dependencies" %INSTALL_PROGRESS%
powershell -NoProfile -Command "Start-Sleep -Milliseconds 250" >nul 2>&1
goto install_wait

:install_done
call :print_task 80 "Installing Node.js dependencies" 100
if not exist "%NPM_DONE%" (
    echo.
    echo [ERROR] npm install failed.
    echo Check: "%NPM_LOG%"
    pause
    exit /b 1
)

if exist "%NPM_DONE%" del /q "%NPM_DONE%" >nul 2>&1
if exist "%NPM_RUNNER%" del /q "%NPM_RUNNER%" >nul 2>&1

echo.
call :print_status 100 "Setup completed"
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

:print_status
set "BASE=%~1"
set "NAME=%~2"
set /a REMAIN=100-BASE
echo [ %BASE%%% complete ^| %REMAIN%%% remaining ] - %NAME%
exit /b 0

:print_task
set "BASE=%~1"
set "NAME=%~2"
set "PCT=%~3"
set /a REMAIN=100-BASE
set /a FILLED=PCT/5
set "BAR="
for /l %%b in (1,1,20) do (
    if %%b leq !FILLED! (set "BAR=!BAR!#") else (set "BAR=!BAR!-")
)
echo [ %BASE%%% complete ^| !REMAIN!%% remaining ] - %NAME% ^| Working: %PCT%%% [!BAR!]
exit /b 0
