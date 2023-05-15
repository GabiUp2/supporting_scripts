@echo off
:: Check if we have administrative privileges, prompt for them if not
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :gotAdmin
) else (
    goto :UACPrompt
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:gotAdmin

:: Check if Chocolatey is installed, install if not
choco --version >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Installing Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
)

echo Upgrading Chocolatey...
choco upgrade chocolatey -y
if %ERRORLEVEL% EQU 0 (
    echo Chocolatey upgrade completed successfully.
) else (
    echo Chocolatey upgrade failed with error code %ERRORLEVEL%.
)

echo Upgrading Chocolatey packages...
choco upgrade all -y
if %ERRORLEVEL% EQU 0 (
    echo Chocolatey upgrade completed successfully.
) else (
    echo Chocolatey upgrade failed with error code %ERRORLEVEL%.
)

:: Check if Python is installed, exit if not
python --version >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Python is not installed. Exiting.
    pause
    exit /B
)

echo Upgrading pip...
python -m pip install --upgrade pip
if %ERRORLEVEL% EQU 0 (
    echo Pip upgrade completed successfully.
) else (
    echo Pip upgrade failed with error code %ERRORLEVEL%.
)

echo Upgrading pip packages...
pip-review --auto
if %ERRORLEVEL% EQU 0 (
    echo Pip packages upgrade completed successfully.
) else (
    echo Pip packages upgrade failed with error code %ERRORLEVEL%.
)