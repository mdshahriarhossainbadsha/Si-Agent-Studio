@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Si-Agent-Studio - API Key Manager
color 0A

set "ROOT=%~dp0"
set "CONFIG_DIR=%ROOT%config"
set "ENV_FILE=%CONFIG_DIR%\agent.env"

if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%ENV_FILE%" type nul > "%ENV_FILE%"

:menu
cls
echo ============================================================
echo                 Si-Agent-Studio API Manager
echo ============================================================
echo.
echo  FREE
echo  [1] Google Gemini
echo.
echo  FREE CREDIT
echo  [2] OpenRouter
echo  [3] Groq
echo  [4] Mistral
echo  [5] Cohere
echo.
echo  PAID
echo  [6] OpenAI
echo  [7] Anthropic Claude
echo  [8] DeepSeek
echo.
echo  [M] More providers
echo  [I] API key status
echo  [Q] Quit
echo.

choice /c 12345678MIQ /n /m "Select an option: "

if errorlevel 11 goto quit
if errorlevel 10 goto info
if errorlevel 9 goto more
if errorlevel 8 call :setkey DEEPSEEK_API_KEY DeepSeek & goto menu
if errorlevel 7 call :setkey ANTHROPIC_API_KEY Anthropic-Claude & goto menu
if errorlevel 6 call :setkey OPENAI_API_KEY OpenAI & goto menu
if errorlevel 5 call :setkey COHERE_API_KEY Cohere & goto menu
if errorlevel 4 call :setkey MISTRAL_API_KEY Mistral & goto menu
if errorlevel 3 call :setkey GROQ_API_KEY Groq & goto menu
if errorlevel 2 call :setkey OPENROUTER_API_KEY OpenRouter & goto menu
if errorlevel 1 call :setkey GEMINI_API_KEY Google-Gemini & goto menu

goto menu


:setkey
set "KEY_NAME=%~1"
set "PROVIDER_NAME=%~2"

echo.
echo Provider: %PROVIDER_NAME%
echo Variable: %KEY_NAME%
echo.
set /p "API_VALUE=Enter API key: "

if "%API_VALUE%"=="" (
    echo.
    echo [WARNING] Empty key was not saved.
    timeout /t 2 /nobreak >nul
    exit /b 0
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$p='%ENV_FILE%'; $n='%KEY_NAME%'; $v=$env:API_VALUE; " ^
 "$lines=@(); if(Test-Path $p){$lines=Get-Content $p}; " ^
 "$found=$false; $out=foreach($line in $lines){ " ^
 "if($line -match ('^'+[regex]::Escape($n)+'=')){ $found=$true; $n+'='+$v } else {$line} }; " ^
 "if(-not $found){$out += $n+'='+$v}; " ^
 "$out | Set-Content -Path $p -Encoding UTF8" 

if errorlevel 1 (
    echo [ERROR] Failed to save API key.
) else (
    echo.
    echo [OK] %PROVIDER_NAME% API key saved.
)

set "API_VALUE="
timeout /t 2 /nobreak >nul
exit /b 0


:info
cls
echo ============================================================
echo                    API Key Status
echo ============================================================
echo.

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
    findstr /b /c:"%%K=" "%ENV_FILE%" >nul 2>&1
    if errorlevel 1 (
        echo [ NOT SET ] %%K
    ) else (
        for /f "tokens=1,* delims==" %%A in ('findstr /b /c:"%%K=" "%ENV_FILE%"') do (
            if "%%B"=="" (
                echo [ NOT SET ] %%K
            ) else (
                echo [ SET     ] %%K
            )
        )
    )
)

echo.
pause
goto menu


:more
cls
echo Additional provider variables can be added manually to:
echo.
echo %ENV_FILE%
echo.
echo Example:
echo HUGGINGFACE_API_KEY=your_key_here
echo PERPLEXITY_API_KEY=your_key_here
echo TOGETHER_API_KEY=your_key_here
echo.
pause
goto menu


:quit
echo.
echo API configuration closed.
echo Next step: run "Start Si Agent.bat"
pause
exit /b 0
