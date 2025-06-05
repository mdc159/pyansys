# PyAnsys UV Project - Troubleshooting Guide

## ❌ Common Issues and Solutions

### 1. Virtual Environment Path Issues

**Problem**: 
```
error: Project virtual environment directory `D:\Users\Mike\Documents\GitHub\pyansys\.venv` cannot be used because it is not a valid Python environment (no Python executable was found)
```

**Root Cause**: 
- The virtual environment is being created in the parent directory instead of the project directory
- Corrupted or incomplete virtual environment installation
- Missing Python executable in the venv

**Solutions**:

#### Option A: Use Fixed Scripts (Recommended)
```bash
# Use the fixed startup scripts that handle this automatically
start-fixed.bat           # Windows
launcher-fixed.py         # Cross-platform
```

#### Option B: Manual Fix
```bash
# 1. Navigate to the project directory
cd pyansys-uv-project

# 2. Remove corrupted virtual environment
rmdir /s /q .venv         # Windows
# rm -rf .venv            # Linux/Mac

# 3. Create fresh virtual environment in project directory
uv venv .venv --python 3.11

# 4. Verify Python executable exists
dir .venv\Scripts\        # Windows - should show python.exe
# ls .venv/bin/           # Linux/Mac - should show python

# 5. Install PyAnsys
uv add "pyansys[all]"
```

### 2. UV Version Compatibility

**Problem**: Different UV versions behave differently

**Current Working Versions**:
- ✅ `uv 0.7.8` (Linux) - Working
- ❌ `uv 0.6.12` (Windows) - Path issues

**Solution**: Update UV
```bash
# Update UV to latest version
pip install --upgrade uv
# or
curl -LsSf https://astral.sh/uv/install.sh | sh  # Linux/Mac
```

### 3. Windows-Specific Issues

**Common Windows Problems**:

#### Path Separators
- Use `\` for Windows paths in batch files
- Use `/` or `Path()` objects in Python scripts

#### Permissions
- Run Command Prompt as Administrator if needed
- Check antivirus isn't blocking UV operations

#### Long Path Names
- Enable long path support in Windows if paths exceed 260 characters

### 4. Python Executable Not Found

**Diagnosis**:
```bash
# Check if virtual environment was created properly
dir .venv\Scripts\        # Windows
ls .venv/bin/             # Linux/Mac

# Should contain:
# - python.exe (Windows) or python (Linux/Mac)
# - pip.exe/pip
# - activate script
```

**Fix**:
```bash
# Recreate virtual environment with explicit Python path
uv venv .venv --python C:\Python311\python.exe  # Windows
uv venv .venv --python /usr/bin/python3.11      # Linux
```

### 5. Package Installation Failures

**Problem**: PyAnsys installation fails or times out

**Solutions**:

#### Increase Timeout
```bash
# Set longer timeout for large packages
uv add "pyansys[all]" --timeout 600
```

#### Install in Stages
```bash
# Install core first, then optional
uv add pyansys
uv add "pyansys[mapdl-all]"
uv add "pyansys[fluent-all]"
uv add "pyansys[tools]"
```

#### Use Different Index
```bash
# Try different package index if default fails
uv add pyansys --index-url https://pypi.org/simple/
```

### 6. Import Errors During Verification

**Problem**: Packages install but imports fail

**Common Causes**:
- NumPy import warnings (usually harmless)
- Missing system dependencies
- Conflicting package versions

**Example Warning (Normal)**:
```
Error importing numpy: you should not try to import...
```

**This is typically harmless** - packages still work for actual use.

### 7. Environment Variable Issues

**Problem**: Private repository authentication fails

**Debug Steps**:
```bash
# Check environment variables are loaded
echo %UV_EXTRA_INDEX_URL%        # Windows
echo $UV_EXTRA_INDEX_URL         # Linux/Mac

# Test authentication
uv add --dry-run some-package --extra-index-url https://user:token@repo.com/simple
```

### 8. Disk Space Issues

**Problem**: Installation fails due to insufficient space

**PyAnsys Full Installation Requirements**:
- **~2-3 GB** disk space
- **321 packages** including large ones (VTK, PySide6, NumPy, SciPy)

**Solution**:
```bash
# Check available space
dir                              # Windows
df -h .                         # Linux/Mac

# Install subset if space limited
uv add pyansys                  # Core only (~500MB)
```

## 🔧 Diagnostic Commands

### Check UV Installation
```bash
uv --version
uv python list
uv cache dir
```

### Check Virtual Environment
```bash
# Windows
dir .venv\Scripts\
.venv\Scripts\python.exe --version

# Linux/Mac  
ls .venv/bin/
.venv/bin/python --version
```

### Check PyAnsys Installation
```bash
uv run python -c "import pyansys; print(pyansys.__version__)"
uv pip list | findstr pyansys     # Windows
uv pip list | grep pyansys        # Linux/Mac
```

### Check Package Locations
```bash
uv run python -c "import sys; print('\n'.join(sys.path))"
```

## 🚀 Working Configurations

### Tested Working Setup (Linux)
- **OS**: Linux x86_64 (WSL2)
- **UV**: 0.7.8
- **Python**: 3.11.12
- **Location**: `/mnt/d/Users/Mike/Documents/GitHub/pyansys/pyansys-uv-project/.venv`
- **Status**: ✅ All scripts working

### Windows Setup (Fixed)
- **OS**: Windows 10/11
- **UV**: 0.6.12+ (recommend updating to 0.7.8+)
- **Python**: 3.11
- **Location**: `D:\path\to\project\.venv` (project-local)
- **Scripts**: Use `start-fixed.bat` or `launcher-fixed.py`

## 📞 Getting Help

If issues persist:

1. **Check UV Documentation**: https://docs.astral.sh/uv/
2. **Update UV**: Always try the latest version first
3. **Use Fixed Scripts**: `start-fixed.bat` or `launcher-fixed.py`
4. **Check Logs**: Run with verbose output: `uv -v add pyansys`
5. **Report Issues**: Include UV version, OS, and full error output