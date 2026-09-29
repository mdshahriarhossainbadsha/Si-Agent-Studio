@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Si-Agent-Studio - Configure Authentication
color 0B

set "ROOT=%~dp0"
set "CONFIG_DIR=%ROOT%config"
set "LOG_DIR=%ROOT%logs"
set "SETUP_LOG=%LOG_DIR%\setup.log"

cd /d "%ROOT%"

echo.
echo ============================================================
echo          Si-Agent-Studio - Configure Authentication
echo ============================================================
echo.

REM Generate random token if not exists
if not exist "%CONFIG_DIR%\auth-token.txt" (
    echo Generating secure authentication token...
    for /f "tokens=*" %%a in ('powershell -NoProfile -Command "[System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))"') do set "AUTH_TOKEN=%%a"
    echo !AUTH_TOKEN! > "%CONFIG_DIR%\auth-token.txt"
    echo [%date% %time%] Generated auth token >> "%SETUP_LOG%"
) else (
    set /p AUTH_TOKEN=<"%CONFIG_DIR%\auth-token.txt"
)

REM Set in agent.env
echo Setting OPENCLAW_GATEWAY_TOKEN in config...

if exist "%CONFIG_DIR%\agent.env" (
    setlocal EnableDelayedExpansion
    for /f "delims== tokens=1,*" %%a in ("%CONFIG_DIR%\agent.env") do (
        if /i "%%a"=="OPENCLAW_GATEWAY_TOKEN" (
            echo OPENCLAW_GATEWAY_TOKEN=!AUTH_TOKEN!
        ) else if /i "%%a"=="ENABLE_AUTH" (
            echo ENABLE_AUTH=true
        ) else (
            echo %%a=%%b
        )
    ) > "%CONFIG_DIR%\agent.env.tmp"
    move /y "%CONFIG_DIR%\agent.env.tmp" "%CONFIG_DIR%\agent.env" >nul
    endlocal
) else (
    (
        echo OPENCLAW_PORT=18789
        echo OPENCLAW_GATEWAY_TOKEN=!AUTH_TOKEN!
        echo OPENWEBUI_PORT=3000
        echo ENABLE_AUTH=true
    ) > "%CONFIG_DIR%\agent.env"
)

echo.
echo ============================================================
echo          Authentication Token Generated Successfully
echo ============================================================
echo.
echo Your authentication token has been set.
echo Token: !AUTH_TOKEN!
echo.
echo IMPORTANT: Keep this token safe. You'll need it to access:
echo   - Control UI: http://localhost:18789
echo.
echo Token saved in: %CONFIG_DIR%\auth-token.txt
echo.
echo Next: Run "Add API Key.bat"
echo.
pause
exit /b 0
