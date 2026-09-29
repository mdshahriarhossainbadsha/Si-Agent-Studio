@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - Add API Key
color 0B

set "ROOT=%~dp0"
set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
set "API_KEYS_FILE=%OPENCLAW_DIR%\api-keys.env"
set "LOG_DIR=%ROOT%logs"
set "SETUP_LOG=%LOG_DIR%\setup.log"

cd /d "%ROOT%"

echo.
echo ============================================================
echo            Si-Agent-Studio - Add OpenAI API Key
echo ============================================================
echo.

REM Create .openclaw directory if not exists
if not exist "%OPENCLAW_DIR%" (
    mkdir "%OPENCLAW_DIR%"
    echo Created %OPENCLAW_DIR% directory
    echo [%date% %time%] Created .openclaw directory >> "%SETUP_LOG%"
)

echo.
echo Enter your OpenAI API Key
echo (Get it from: https://platform.openai.com/api-keys)
echo.
set /p OPENAI_KEY="Enter API Key: "

if "%OPENAI_KEY%"=="" (
    echo.
    echo [ERROR] API Key cannot be empty.
    echo.
    pause
    exit /b 1
)

REM Save to ~/.openclaw/api-keys.env
echo OPENAI_API_KEY=%OPENAI_KEY% > "%API_KEYS_FILE%"

echo.
echo ============================================================
echo            API Key Saved Successfully
echo ============================================================
echo.
echo Location: %API_KEYS_FILE%
echo [%date% %time%] API key saved to %API_KEYS_FILE% >> "%SETUP_LOG%"
echo.
echo Next: Run "Start Si Agent.bat"
echo.
pause
exit /b 0
