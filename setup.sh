#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

PYTHON_EXE="python3"
VENV_DIR=".venv"

# Check if python is available
if ! command -v $PYTHON_EXE &> /dev/null
then
    echo "$PYTHON_EXE could not be found. Please install Python 3."
    exit 1
fi

# Check if venv directory already exists
if [ -d "$VENV_DIR" ]; then
  echo "Virtual environment '$VENV_DIR' already exists. Skipping creation."
else
  echo "Creating virtual environment in $VENV_DIR..."
  $PYTHON_EXE -m venv $VENV_DIR
fi

echo "Activating virtual environment for script..."
# Activate venv for the script's context
# Use . instead of source for POSIX compatibility
. "$VENV_DIR/bin/activate"

# Ensure pip is up-to-date
echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing pre-commit..."
pip install pre-commit

echo "Installing pre-commit hooks..."
pre-commit install --install-hooks

# Deactivate is not strictly necessary as the script exits, but good practice
deactivate

echo ""
echo "Setup complete!"
echo "To activate the virtual environment in your current shell, run:"
echo "source $VENV_DIR/bin/activate"
