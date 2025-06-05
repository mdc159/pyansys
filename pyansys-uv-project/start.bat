@echo off
REM PyAnsys UV Project - Startup Script for Windows
REM This script activates the virtual environment and launches the verification

setlocal enabledelayedexpansion

REM Change to the directory where this script is located
cd /d "%~dp0"

echo ======================================================
echo    PyAnsys UV Project - Environment Launcher
echo ======================================================
echo.

REM Check if uv is installed
uv --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] uv is not installed or not in PATH
    echo Please install uv: https://docs.astral.sh/uv/getting-started/installation/
    goto :error_exit
)

for /f "tokens=*" %%i in ('uv --version') do set UV_VERSION=%%i
echo [INFO] Found uv: !UV_VERSION!

REM Check if virtual environment exists
if not exist ".venv" (
    echo [WARNING] Virtual environment not found. Creating it...
    uv venv --python 3.11
    if errorlevel 1 goto :error_exit
    echo [SUCCESS] Virtual environment created
) else (
    echo [INFO] Virtual environment found
)

REM Check if PyAnsys is installed
echo [INFO] Checking PyAnsys installation...
uv run python -c "import pyansys" >nul 2>&1
if errorlevel 1 (
    echo [WARNING] PyAnsys not found. Installing...
    uv add "pyansys[all]"
    if errorlevel 1 goto :error_exit
    echo [SUCCESS] PyAnsys installed
) else (
    for /f "tokens=*" %%i in ('uv run python -c "import pyansys; print(pyansys.__version__)"') do set PYANSYS_VERSION=%%i
    echo [SUCCESS] PyAnsys !PYANSYS_VERSION! is installed
)

echo.
echo [INFO] Activating virtual environment and launching verification...
echo.

REM Load environment variables if .env exists
if exist ".env" (
    echo [INFO] Loading environment variables from .env
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%a:~0,1%"=="#" (
            set "%%a=%%b"
        )
    )
)

REM Launch the verification script using uv run
echo ======================================================
uv run python main.py
if errorlevel 1 goto :error_exit
echo ======================================================

echo.
echo [SUCCESS] Script completed!
echo.
echo [INFO] To manually activate the environment, run:
echo   .venv\Scripts\activate
echo.
echo [INFO] To run Python with uv (recommended), use:
echo   uv run python your_script.py
echo.
echo [INFO] To install additional packages:
echo   uv add package-name
echo.

REM Keep the terminal open if requested
if "%1"=="--keep-open" goto :keep_open
if defined KEEP_TERMINAL_OPEN goto :keep_open
goto :end

:keep_open
echo [INFO] Press any key to exit...
pause >nul
goto :end

:error_exit
echo.
echo [ERROR] Script failed with an error!
echo Press any key to exit...
pause >nul
exit /b 1

:end
endlocal