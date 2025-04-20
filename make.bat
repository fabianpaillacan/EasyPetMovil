@echo off
SET VENV=venv

IF "%1"=="install" (
    echo Creating virtual environment...
    python -m venv %VENV%
    call %VENV%\Scripts\activate.bat
    echo Installing dependencies...
    pip install -r requirements_back_end.txt
    echo Done!
    goto end
)

IF "%1"=="run" (
    call %VENV%\Scripts\activate.bat
    uvicorn backend.app:app --reload
    goto end
)

IF "%1"=="clean" (
    echo Removing virtual environment...
    rmdir /s /q %VENV%
    goto end
)

:help
echo.
echo Usage: make.bat [install | run | clean]
echo.

:end
