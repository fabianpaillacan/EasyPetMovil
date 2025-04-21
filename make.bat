@echo off
SET VENV=.venv

IF "%1"=="install" (
    echo Creating virtual environment...
    python -m venv %VENV%
    call %VENV%\Scripts\activate.bat
    echo Installing dependencies...
    pip install -r backend\requirements.txt
    echo Done!
    goto end
)


IF "%1"=="update" (
    call %VENV%\Scripts\activate.bat
    echo Updating dependencies...
    pip install --upgrade -r backend\requirements.txt
    echo Done!
    goto end
)

IF "%1"=="run" (
    echo Activating virtual environment...
    call %VENV%\Scripts\activate.bat
    echo Running Uvicorn...
    uvicorn backend.app:app --reload
    goto end
)

IF "%1"=="clean" (
    echo Removing virtual environment...
    rmdir /s /q %VENV%
    goto end
)


IF "%1"=="format" (
    call %VENV%\Scripts\activate.bat
    echo Formatting code...
    python -m black backend/ --line-length 79
    python -m isort backend/
    python -m flake8 backend/ --exit-zero
    dart format .
    dart fix --apply
    echo Done!
    goto end
)

:help
echo.
echo Usage: make.bat [install | run | clean]
echo.

:end
