@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Powered by Workstation - by Shin
mode con: cols=73 lines=25
color 07

set "ROOT=%~dp0"
set "DATA_DIR=%ROOT%Data"
set "GAME_EXE=%DATA_DIR%\Warcraft_III_Launcher.exe"
set "LANG_FILE=%DATA_DIR%\PCMYJuegos_LauncherLanguage.cfg"

for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "RST=!ESC![0m"
set "CYAN=!ESC![96m"
set "GREEN=!ESC![92m"
set "YELLOW=!ESC![93m"
set "WHITE=!ESC![97m"
set "RED=!ESC![91m"
set "GRAY=!ESC![90m"

if not exist "%DATA_DIR%" mkdir "%DATA_DIR%" >nul 2>&1

call :LOAD_UI_LANG
if not defined UI_LANG goto UI_LANG_START
goto MAIN

:UI_LANG_START
cls
call :HEADER
echo.
echo !CYAN!LAUNCHER DISPLAY LANGUAGE / IDIOMA DEL LAUNCHER!RST!
echo !GRAY!---------------------------------------------------------------!RST!
echo.
echo !WHITE![ 1 ] Español!RST!
echo !WHITE![ 2 ] English!RST!
echo.
set /p "OPT=!CYAN!Selecciona / Select: !RST!"

if "%OPT%"=="1" (
    set "UI_LANG=ES"
    <NUL set /p "=ES" > "%LANG_FILE%"
    goto MAIN
)
if "%OPT%"=="2" (
    set "UI_LANG=EN"
    <NUL set /p "=EN" > "%LANG_FILE%"
    goto MAIN
)
goto UI_LANG_START

:MAIN
cls
call :HEADER
echo.
if /i "%UI_LANG%"=="ES" (
    echo !GRAY!OPCIONES PRINCIPALES!RST!
    echo !GRAY!---------------------------------------------------------------!RST!
    echo !GREEN![ 1 ] Ejecutar Warcraft III: Reforged!RST!
    echo !CYAN![ 2 ] Cambiar idioma del juego!RST!
    echo.
    echo !GRAY!ADMINISTRACIÓN Y HERRAMIENTAS!RST!
    echo !GRAY!---------------------------------------------------------------!RST!
    echo !WHITE![ 3 ] Cambiar idioma del Launcher!RST!
    echo !RED![ 4 ] Salir!RST!
    echo.
    set /p "OPT=!CYAN!Selecciona una opción: !RST!"
) else (
    echo !GRAY!MAIN OPTIONS!RST!
    echo !GRAY!---------------------------------------------------------------!RST!
    echo !GREEN![ 1 ] Launch Warcraft III: Reforged!RST!
    echo !CYAN![ 2 ] Change game language!RST!
    echo.
    echo !GRAY!ADMINISTRATION AND TOOLS!RST!
    echo !GRAY!---------------------------------------------------------------!RST!
    echo !WHITE![ 3 ] Change Launcher language!RST!
    echo !RED![ 4 ] Exit!RST!
    echo.
    set /p "OPT=!CYAN!Select an option: !RST!"
)

if "%OPT%"=="1" goto START_GAME
if "%OPT%"=="2" goto GAME_LANGUAGE
if "%OPT%"=="3" goto CHANGE_UI_LANG
if "%OPT%"=="4" exit /b
goto MAIN

:GAME_LANGUAGE
cls
call :HEADER
echo.
if /i "%UI_LANG%"=="ES" (
    echo !CYAN!IDIOMA DEL JUEGO!RST!
) else (
    echo !CYAN!GAME LANGUAGE!RST!
)
echo !GRAY!---------------------------------------------------------------!RST!
echo.
echo !WHITE![ 1 ] Español - España!RST!
echo !WHITE![ 2 ] Español - Latinoamérica!RST!
echo !WHITE![ 3 ] English!RST!
echo !WHITE![ 4 ] Português - Brasil!RST!
echo !GRAY![ 0 ] Volver / Back!RST!
echo.
set /p "OPT=!CYAN!Selecciona / Select: !RST!"

if "%OPT%"=="1" goto LANG_ESES
if "%OPT%"=="2" goto LANG_ESMX
if "%OPT%"=="3" goto LANG_ENUS
if "%OPT%"=="4" goto LANG_PTBR
if "%OPT%"=="0" goto MAIN
goto GAME_LANGUAGE

:LANG_ESES
call :SET_GAME_LANG "esES" "Español - España"
goto GAME_LANGUAGE

:LANG_ESMX
call :SET_GAME_LANG "esMX" "Español - Latinoamérica"
goto GAME_LANGUAGE

:LANG_ENUS
call :SET_GAME_LANG "enUS" "English"
goto GAME_LANGUAGE

:LANG_PTBR
call :SET_GAME_LANG "ptBR" "Português - Brasil"
goto GAME_LANGUAGE

:SET_GAME_LANG
reg add "HKCU\Software\Blizzard Entertainment\Battle.net\Launch Options\W3" /v LOCALE /t REG_SZ /d "%~1" /f >nul 2>&1
reg add "HKCU\Software\Blizzard Entertainment\Battle.net\Launch Options\W3" /v LOCALE_AUDIO /t REG_SZ /d "%~1" /f >nul 2>&1
reg add "HKCU\Software\Blizzard Entertainment\Battle.net\Launch Options\W3" /v REGION /t REG_SZ /d "OFF" /f >nul 2>&1
reg add "HKCU\Software\Blizzard Entertainment\Battle.net\Launch Options\BNA" /v CONNECTION_STRING_OFF /t REG_SZ /d "0.0.0.0" /f >nul 2>&1

if errorlevel 1 (
    echo.
    if /i "%UI_LANG%"=="ES" (
        echo !RED!No se pudo aplicar el idioma.!RST!
    ) else (
        echo !RED!The language could not be applied.!RST!
    )
    timeout /t 2 /nobreak >nul
    exit /b
)

echo.
if /i "%UI_LANG%"=="ES" (
    echo !GREEN!Idioma del juego cambiado a: %~2!RST!
) else (
    echo !GREEN!Game language changed to: %~2!RST!
)
timeout /t 2 /nobreak >nul
exit /b

:START_GAME
cls
call :HEADER
echo.
if not exist "%GAME_EXE%" (
    if /i "%UI_LANG%"=="ES" (
        echo !RED!ERROR: No se encontró el ejecutable del juego.!RST!
    ) else (
        echo !RED!ERROR: The game executable was not found.!RST!
    )
    echo.
    echo !GRAY!%GAME_EXE%!RST!
    echo.
    pause
    goto MAIN
)

if /i "%UI_LANG%"=="ES" (
    echo !GREEN!Iniciando Warcraft III: Reforged...!RST!
) else (
    echo !GREEN!Launching Warcraft III: Reforged...!RST!
)
timeout /t 1 /nobreak >nul
start "" /d "%DATA_DIR%" "Warcraft_III_Launcher.exe"
exit /b

:CHANGE_UI_LANG
cls
call :HEADER
echo.
echo !CYAN!LAUNCHER DISPLAY LANGUAGE / IDIOMA DEL LAUNCHER!RST!
echo !GRAY!---------------------------------------------------------------!RST!
echo.
echo !WHITE![ 1 ] Español!RST!
echo !WHITE![ 2 ] English!RST!
echo !GRAY![ 0 ] Volver / Back!RST!
echo.
set /p "OPT=!CYAN!Selecciona / Select: !RST!"

if "%OPT%"=="1" (
    set "UI_LANG=ES"
    <NUL set /p "=ES" > "%LANG_FILE%"
    goto MAIN
)
if "%OPT%"=="2" (
    set "UI_LANG=EN"
    <NUL set /p "=EN" > "%LANG_FILE%"
    goto MAIN
)
if "%OPT%"=="0" goto MAIN
goto CHANGE_UI_LANG

:LOAD_UI_LANG
set "UI_LANG="
if exist "%LANG_FILE%" set /p UI_LANG=<"%LANG_FILE%"
if /i "%UI_LANG%"=="ES" exit /b
if /i "%UI_LANG%"=="EN" exit /b
set "UI_LANG="
exit /b

:HEADER
set "SPACES=                                                                        "
set "T1=Workstation"
set "T2=WARCRAFT III: REFORGED"
set "T3=LAN EDITION"
set /a "P1=(73-10)/2"
set /a "P2=(73-21)/2"
set /a "P3=(73-11)/2"
echo !GREEN!!SPACES:~0,%P1%!!T1!!RST!
echo !CYAN!!SPACES:~0,%P2%!!T2!!RST!
echo !GREEN!!SPACES:~0,%P3%!!T3!!RST!
echo !GRAY!-------------------------------------------------------------------------!RST!
exit /b
