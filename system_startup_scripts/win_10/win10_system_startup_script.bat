@echo off

echo Upgrading Chocolatey packages...
choco upgrade all -y
if %ERRORLEVEL% EQU 0 (
    echo Chocolatey upgrade completed successfully.
) else (
    echo Chocolatey upgrade failed with error code %ERRORLEVEL%.
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