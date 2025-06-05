#!/usr/bin/env python3
"""
PyAnsys UV Project - Cross-platform Python Launcher
This script provides a Python-based launcher that works on all platforms.
"""

import os
import sys
import subprocess
import platform
from pathlib import Path


def print_colored(message, color="blue"):
    """Print colored output (works on most terminals)."""
    colors = {
        "red": "\033[0;31m",
        "green": "\033[0;32m", 
        "blue": "\033[0;34m",
        "yellow": "\033[1;33m",
        "reset": "\033[0m"
    }
    
    if platform.system() == "Windows" and not os.environ.get("TERM"):
        # Basic Windows console without ANSI support
        print(f"[{color.upper()}] {message}")
    else:
        print(f"{colors.get(color, colors['blue'])}[{color.upper()}]{colors['reset']} {message}")


def run_command(cmd, cwd=None, check=True):
    """Run a command and return the result."""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            capture_output=True, 
            text=True, 
            cwd=cwd,
            check=check
        )
        return result
    except subprocess.CalledProcessError as e:
        print_colored(f"Command failed: {cmd}", "red")
        print_colored(f"Error: {e.stderr}", "red")
        return None


def check_uv_installed():
    """Check if uv is installed and accessible."""
    result = run_command("uv --version", check=False)
    if result and result.returncode == 0:
        version = result.stdout.strip()
        print_colored(f"Found uv: {version}", "green")
        return True
    else:
        print_colored("uv is not installed or not in PATH", "red")
        print_colored("Please install uv: https://docs.astral.sh/uv/getting-started/installation/", "yellow")
        return False


def setup_virtual_environment():
    """Create virtual environment if it doesn't exist."""
    venv_path = Path(".venv")
    
    if not venv_path.exists():
        print_colored("Virtual environment not found. Creating it...", "yellow")
        result = run_command("uv venv --python 3.11")
        if result:
            print_colored("Virtual environment created", "green")
            return True
        else:
            print_colored("Failed to create virtual environment", "red")
            return False
    else:
        print_colored("Virtual environment found", "blue")
        return True


def check_pyansys_installation():
    """Check if PyAnsys is installed and install if needed."""
    print_colored("Checking PyAnsys installation...", "blue")
    
    # Try to import PyAnsys
    result = run_command("uv run python -c \"import pyansys\"", check=False)
    
    if result and result.returncode == 0:
        # Get version
        version_result = run_command("uv run python -c \"import pyansys; print(pyansys.__version__)\"")
        if version_result:
            version = version_result.stdout.strip()
            print_colored(f"PyAnsys {version} is installed", "green")
            return True
    
    print_colored("PyAnsys not found. Installing...", "yellow")
    result = run_command("uv add \"pyansys[all]\"")
    if result:
        print_colored("PyAnsys installed successfully", "green")
        return True
    else:
        print_colored("Failed to install PyAnsys", "red")
        return False


def load_environment_variables():
    """Load environment variables from .env file if it exists."""
    env_file = Path(".env")
    if env_file.exists():
        print_colored("Loading environment variables from .env", "blue")
        try:
            with open(env_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#') and '=' in line:
                        key, value = line.split('=', 1)
                        os.environ[key.strip()] = value.strip()
        except Exception as e:
            print_colored(f"Warning: Could not load .env file: {e}", "yellow")


def launch_verification():
    """Launch the PyAnsys verification script."""
    print_colored("Launching PyAnsys verification...", "blue")
    print("=" * 60)
    
    # Run the main verification script
    result = run_command("uv run python main.py")
    
    print("=" * 60)
    
    if result:
        print_colored("Verification completed successfully!", "green")
        return True
    else:
        print_colored("Verification failed", "red")
        return False


def show_usage_info():
    """Display usage information."""
    print()
    print_colored("Usage Information:", "blue")
    print("  To manually activate the environment:")
    
    if platform.system() == "Windows":
        print("    .venv\\Scripts\\activate")
    else:
        print("    source .venv/bin/activate")
    
    print()
    print("  To run Python with uv (recommended):")
    print("    uv run python your_script.py")
    print()
    print("  To install additional packages:")
    print("    uv add package-name")
    print()


def main():
    """Main launcher function."""
    print("=" * 60)
    print("   PyAnsys UV Project - Environment Launcher")
    print(f"   Platform: {platform.system()} {platform.machine()}")
    print("=" * 60)
    print()
    
    # Change to script directory
    script_dir = Path(__file__).parent
    os.chdir(script_dir)
    print_colored(f"Working directory: {script_dir}", "blue")
    
    # Check prerequisites
    if not check_uv_installed():
        return 1
    
    # Setup environment
    if not setup_virtual_environment():
        return 1
    
    # Check/install PyAnsys
    if not check_pyansys_installation():
        return 1
    
    # Load environment variables
    load_environment_variables()
    
    # Launch verification
    success = launch_verification()
    
    # Show usage info
    show_usage_info()
    
    # Keep open if requested
    if "--keep-open" in sys.argv or os.environ.get("KEEP_TERMINAL_OPEN"):
        print_colored("Press Enter to exit...", "blue")
        input()
    
    return 0 if success else 1


if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print()
        print_colored("Interrupted by user", "yellow")
        sys.exit(1)
    except Exception as e:
        print_colored(f"Unexpected error: {e}", "red")
        sys.exit(1)