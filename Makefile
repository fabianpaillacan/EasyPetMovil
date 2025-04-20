# Name of your virtual environment folder
VENV_NAME = venv

# Python binary (edit if you want python3.11 etc)
PYTHON = python

.PHONY: install run clean

install:
	$(PYTHON) -m venv $(VENV_NAME)
	$(VENV_NAME)/Scripts/pip install --upgrade pip
	$(VENV_NAME)/Scripts/pip install -r requirements_back_end.txt

run:
	$(VENV_NAME)/Scripts/activate && uvicorn app.main:app --reload

clean:
	rd /s /q $(VENV_NAME)
