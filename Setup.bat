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

call :run_task "Initializing environment" 0 100
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"
if not exist "%LOG_DIR%\setup.log" type nul > "%LOG_DIR%\setup.log"

call :run_task "Checking Node.js" 0 100
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

call :run_task "Checking Git" 0 100
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

call :run_task "Creating folders and configuration" 0 100
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

call :run_task "Installing Node.js dependencies" 0 100
call npm install >> "%LOG_DIR%\setup.log" 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] npm install failed.
    echo Check: "%LOG_DIR%\setup.log"
    pause
    exit /b 1
)

call :run_task "Setup completed" 0 100

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

:run_task
set "TASK=%~1"
set "START=%~2"
set "END=%~3"

for /l %%i in (%START%,5,%END%) do (
    set /a FILLED=%%i/5
    set "BAR="
    for /l %%b in (1,1,%FILLED%) do set "BAR=!BAR!█"
    for /l %%c in (%FILLED%,1,20) do set "BAR=!BAR!░"
    cls
    echo.
    echo ============================================================
    echo              Si-Agent-Studio Setup
    echo ============================================================
    echo.
    echo %TASK%
    echo.
    echo %%i%% %BAR% 100%%
    echo.
    powershell -NoProfile -Command "Start-Sleep -Milliseconds 70" >nul 2>&1
)

cls
echo.
echo ============================================================
echo              Si-Agent-Studio Setup
echo ============================================================
echo.
echo %TASK%
echo.
echo 100% █████████████████████████████████████████████████████████████ 100%%
echo.
exit /b 0
