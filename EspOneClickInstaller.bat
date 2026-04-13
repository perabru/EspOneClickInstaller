@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Instalador ESP32 Arduino IDE + Download de Drivers

echo ========================================
echo   CONFIGURANDO ESP32 NA ARDUINO IDE
echo ========================================
echo.

REM =====================================================
REM 1) DEFINIR CAMINHOS
REM =====================================================
set "ARDUINO_PREF=%LOCALAPPDATA%\Arduino15"
set "PREF_FILE=%ARDUINO_PREF%\preferences.txt"
set "ESP32_URL=https://dl.espressif.com/dl/package_esp32_index.json"

set "BASE_DIR=%~dp0"
set "DRIVER_DIR=%BASE_DIR%Drivers_ESP32"
set "CP210X_FILE=%DRIVER_DIR%\CP210x_Universal_Windows_Driver.zip"
set "CH341_FILE=%DRIVER_DIR%\CH341SER.ZIP"

set "CP210X_URL=https://www.silabs.com/documents/public/software/CP210x_Universal_Windows_Driver.zip"
set "CH341_URL=https://www.wch-ic.com/downloads/CH341SER.ZIP"

echo Verificando pasta de configuracao...

if not exist "%ARDUINO_PREF%" (
    mkdir "%ARDUINO_PREF%"
)

if not exist "%DRIVER_DIR%" (
    mkdir "%DRIVER_DIR%"
)

REM =====================================================
REM 2) CONFIGURAR URL DA ESP32
REM =====================================================
echo.
echo ========================================
echo   ETAPA 1 - CONFIGURANDO URL DA ESP32
echo ========================================

if exist "%PREF_FILE%" (
    findstr /C:"%ESP32_URL%" "%PREF_FILE%" >nul
    if errorlevel 1 (
        echo Adicionando URL ao arquivo existente...
        echo boardsmanager.additional.urls=%ESP32_URL%>>"%PREF_FILE%"
        echo [OK] URL adicionada com sucesso.
    ) else (
        echo [OK] URL da ESP32 ja estava configurada.
    )
) else (
    echo Criando arquivo de preferencias...
    echo boardsmanager.additional.urls=%ESP32_URL%>"%PREF_FILE%"
    echo [OK] URL adicionada com sucesso.
)

REM =====================================================
REM 3) DETECTAR ARDUINO IDE
REM =====================================================
echo.
echo ========================================
echo   ETAPA 2 - LOCALIZANDO ARDUINO IDE
echo ========================================

set "ARDUINO_PATH="

if exist "C:\Program Files\Arduino IDE\Arduino IDE.exe" set "ARDUINO_PATH=C:\Program Files\Arduino IDE\Arduino IDE.exe"
if exist "C:\Program Files (x86)\Arduino IDE\Arduino IDE.exe" set "ARDUINO_PATH=C:\Program Files (x86)\Arduino IDE\Arduino IDE.exe"
if exist "%LOCALAPPDATA%\Programs\Arduino IDE\Arduino IDE.exe" set "ARDUINO_PATH=%LOCALAPPDATA%\Programs\Arduino IDE\Arduino IDE.exe"

if defined ARDUINO_PATH (
    echo [OK] Arduino IDE encontrada:
    echo %ARDUINO_PATH%
) else (
    echo [AVISO] Arduino IDE nao encontrada automaticamente.
)

REM =====================================================
REM 4) DOWNLOAD DOS DRIVERS COM FEEDBACK VISUAL
REM =====================================================
echo.
echo ========================================
echo   ETAPA 3 - BAIXANDO DRIVERS USB
echo ========================================
echo.

echo [1/2] Baixando driver CP210x...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ProgressPreference = 'Continue'; Invoke-WebRequest -Uri '%CP210X_URL%' -OutFile '%CP210X_FILE%'"

if exist "%CP210X_FILE%" (
    echo [OK] Driver CP210x baixado com sucesso.
    echo     Salvo em: %CP210X_FILE%
) else (
    echo [ERRO] Falha ao baixar o driver CP210x.
)

echo.
echo [2/2] Baixando driver CH340 / CH341...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ProgressPreference = 'Continue'; Invoke-WebRequest -Uri '%CH341_URL%' -OutFile '%CH341_FILE%'"

if exist "%CH341_FILE%" (
    echo [OK] Driver CH340/CH341 baixado com sucesso.
    echo     Salvo em: %CH341_FILE%
) else (
    echo [ERRO] Falha ao baixar o driver CH340/CH341.
)

REM =====================================================
REM 5) ABRIR PASTA DOS DRIVERS
REM =====================================================
echo.
echo ========================================
echo   ETAPA 4 - ABRINDO PASTA DOS DRIVERS
echo ========================================
start "" "%DRIVER_DIR%"

REM =====================================================
REM 6) ABRIR ARDUINO IDE
REM =====================================================
echo.
echo ========================================
echo   ETAPA 5 - ABRINDO ARDUINO IDE
echo ========================================

if defined ARDUINO_PATH (
    start "" "%ARDUINO_PATH%"
    echo [OK] Arduino IDE aberta.
) else (
    echo [AVISO] Abra a Arduino IDE manualmente.
)

REM =====================================================
REM 7) INSTRUCOES FINAIS
REM =====================================================
echo.
echo ========================================
echo   PROXIMOS PASSOS
echo ========================================
echo   1. Instale o driver correto da sua placa:
echo      - CP210x = placas mais comuns
echo      - CH340/CH341 = comum em clones
echo.
echo   2. Na Arduino IDE va em:
echo      Ferramentas ^> Gerenciador de Placas
echo.
echo   3. Pesquise por ESP32
echo.
echo   4. Clique em INSTALAR
echo ========================================
echo.

pause
endlocal