#!/bin/bash

# PyAnsys UV Project - Startup Script for Linux/Mac
# This script activates the virtual environment and launches the verification

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "   PyAnsys UV Project - Environment Launcher"
echo "======================================================"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    print_error "uv is not installed or not in PATH"
    echo "Please install uv: https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
fi

print_status "Found uv: $(uv --version)"

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    print_warning "Virtual environment not found. Creating it..."
    uv venv --python 3.11
    print_success "Virtual environment created"
else
    print_status "Virtual environment found"
fi

# Check if PyAnsys is installed
print_status "Checking PyAnsys installation..."
if uv run python -c "import pyansys" 2>/dev/null; then
    PYANSYS_VERSION=$(uv run python -c "import pyansys; print(pyansys.__version__)")
    print_success "PyAnsys $PYANSYS_VERSION is installed"
else
    print_warning "PyAnsys not found. Installing..."
    uv add "pyansys[all]"
    print_success "PyAnsys installed"
fi

echo ""
print_status "Activating virtual environment and launching verification..."
echo ""

# Load environment variables if .env exists
if [ -f ".env" ]; then
    print_status "Loading environment variables from .env"
    set -a  # automatically export all variables
    source .env
    set +a  # disable automatic export
fi

# Launch the verification script using uv run
echo "======================================================"
uv run python main.py
echo "======================================================"

echo ""
print_success "Script completed!"
echo ""
print_status "To manually activate the environment, run:"
echo "  source .venv/bin/activate"
echo ""
print_status "To run Python with uv (recommended), use:"
echo "  uv run python your_script.py"
echo ""
print_status "To install additional packages:"
echo "  uv add package-name"
echo ""

# Keep the terminal open if running in certain environments
if [[ "$1" == "--keep-open" ]] || [[ -n "$KEEP_TERMINAL_OPEN" ]]; then
    print_status "Press any key to exit..."
    read -n 1 -s
fi