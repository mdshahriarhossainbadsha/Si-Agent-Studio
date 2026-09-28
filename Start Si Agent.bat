@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Si-Agent-Studio - Start
color 0B

set "ROOT=%~dp0"
set "ENV_FILE=%ROOT%config\agent.env"
set "LOG_DIR=%ROOT%logs"
set "OPENWEBUI_URL=http://localhost:3000"

cd /d "%ROOT%"

echo ============================================================
echo                Starting Si-Agent-Studio
echo ============================================================
echo.

if not exist "%ENV_FILE%" (
    echo [ERROR] Configuration file not found:
    echo %ENV_FILE%
    echo Run Setup.bat first.
    pause
    exit /b 1
)

call :load_env "%ENV_FILE%"

call :progress 0 "Initializing agent"
call :progress 25 "Validating files and ports"

where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed.
    pause
    exit /b 1
)

call :progress 50 "Checking API key configuration"

set "KEY_FOUND=0"
for %%K in (
    GEMINI_API_KEY
    OPENROUTER_API_KEY
    GROQ_API_KEY
    MISTRAL_API_KEY
    COHERE_API_KEY
    OPENAI_API_KEY
    ANTHROPIC_API_KEY
    DEEPSEEK_API_KEY
) do (
    if defined %%K set "KEY_FOUND=1"
)

if "%KEY_FOUND%"=="1" (
    echo API Key [ SET ] OK
) else (
    echo API Key [ NOT SET ]
    echo Run "Add API Key.bat" before continuing.
    choice /c YN /n /m "Continue anyway? [Y/N]: "
    if errorlevel 2 exit /b 1
)

call :progress 75 "Starting OpenClaw and OpenWebUI"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo Starting OpenClaw...
start "OpenClaw Gateway" /min cmd /c ^
 "cd /d ""%ROOT%"" && call :load_env ""%ENV_FILE%"" && %OPENCLAW_START_COMMAND% >> ""%LOG_DIR%\openclaw.log"" 2>&1"

echo Starting OpenWebUI...
where docker >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Docker was not found.
    echo OpenWebUI was not started.
    echo Install Docker Desktop, then run this file again.
) else (
    start "OpenWebUI" /min cmd /c ^
     "cd /d ""%ROOT%"" && docker compose up >> ""%LOG_DIR%\openwebui.log"" 2>&1"
)

call :progress 100 "All services started"

echo.
echo ============================================================
echo            ALL DONE - YOUR AI IS RUNNING
echo ============================================================
echo.
echo OpenWebUI URL: %OPENWEBUI_URL%
echo.
echo Choose browser:
echo [1] Google Chrome
echo [2] Microsoft Edge
echo [3] Default Browser
echo [4] Other Browser
echo [Q] Quit
echo.

choice /c 1234Q /n /m "Select browser: "

if errorlevel 5 goto finish
if errorlevel 4 goto other
if errorlevel 3 start "" "%OPENWEBUI_URL%" & goto finish
if errorlevel 2 start msedge "%OPENWEBUI_URL%" & goto finish
if errorlevel 1 start chrome "%OPENWEBUI_URL%" & goto finish

:other
set /p "BROWSER_PATH=Enter browser executable path: "
if exist "%BROWSER_PATH%" start "" "%BROWSER_PATH%" "%OPENWEBUI_URL%"

:finish
echo.
echo Services are running in background windows.
echo Use "View Log.bat" to monitor logs.
pause
exit /b 0


:load_env
for /f "usebackq tokens=1,* delims==" %%A in ("%~1") do (
    if not "%%A"=="" if not "%%A:~0,1%%"=="#" set "%%A=%%B"
)
exit /b 0


:progress
set "PERCENT=%~1"
set "MESSAGE=%~2"
set /a REMAINING=100-PERCENT
echo [ %PERCENT%%% complete ^| %REMAINING%%% remaining ] - %MESSAGE%
timeout /t 1 /nobreak >nul
exit /b 0
