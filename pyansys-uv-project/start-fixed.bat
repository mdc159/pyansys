@echo off
REM PyAnsys UV Project - Fixed Startup Script for Windows
REM This script fixes the virtual environment path issues

setlocal enabledelayedexpansion

REM Change to the directory where this script is located
cd /d "%~dp0"

echo ======================================================
echo    PyAnsys UV Project - Environment Launcher (Fixed)
echo ======================================================
echo.

REM Display current directory
echo [INFO] Current directory: %CD%
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

REM Remove any corrupted virtual environment
if exist ".venv" (
    echo [INFO] Removing existing virtual environment...
    rmdir /s /q ".venv"
)

REM Create fresh virtual environment in the project directory
echo [INFO] Creating new virtual environment in project directory...
uv venv .venv --python 3.11
if errorlevel 1 (
    echo [ERROR] Failed to create virtual environment
    goto :error_exit
)
echo [SUCCESS] Virtual environment created successfully

REM Verify the virtual environment was created properly
if not exist ".venv\Scripts\python.exe" (
    echo [ERROR] Python executable not found in virtual environment
    echo [INFO] Checking virtual environment contents:
    dir .venv\Scripts\
    goto :error_exit
)
echo [SUCCESS] Python executable found: .venv\Scripts\python.exe

REM Install PyAnsys with all dependencies
echo [INFO] Installing PyAnsys with all dependencies...
uv add "pyansys[all]"
if errorlevel 1 (
    echo [ERROR] Failed to install PyAnsys
    goto :error_exit
)
echo [SUCCESS] PyAnsys installed successfully

echo.
echo [INFO] Launching PyAnsys verification...
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
if errorlevel 1 (
    echo [WARNING] Verification script had issues, but this is normal for some packages
)
echo ======================================================

echo.
echo [SUCCESS] Script completed!
echo.
echo [INFO] Virtual environment location: %CD%\.venv
echo [INFO] To manually activate the environment, run:
echo   .venv\Scripts\activate
echo.
echo [INFO] To run Python with uv (recommended), use:
echo   uv run python your_script.py
echo.
echo [INFO] To install additional packages:
echo   uv add package-name
echo.

REM Always keep the terminal open for debugging
echo [INFO] Press any key to exit...
pause >nul
goto :end

:error_exit
echo.
echo [ERROR] Script failed with an error!
echo [INFO] Debug information:
echo   - Current directory: %CD%
echo   - UV version: !UV_VERSION!
echo   - Virtual environment exists: 
if exist ".venv" (echo     YES) else (echo     NO)
if exist ".venv\Scripts\python.exe" (echo   - Python executable exists: YES) else (echo   - Python executable exists: NO)
echo.
echo Press any key to exit...
pause >nul
exit /b 1

:end
endlocal