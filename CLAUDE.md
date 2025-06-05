# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PyAnsys is a metapackage that provides a unified collection of 35+ Python libraries for interacting with Ansys simulation products. It serves as a compatibility-assured entry point to the entire PyAnsys ecosystem, spanning domains like structures, fluids, electronics, materials, and platform tools.

## Development Commands

### Installation and Setup
```bash
# Development installation (editable)
pip install -e .

# Install with optional dependencies  
pip install -e .[all]          # Everything
pip install -e .[mapdl-all]    # Includes PyMAPDL Reader
pip install -e .[fluent-all]   # Includes visualization tools
pip install -e .[tools]        # Includes utilities

# Production installation (from PyPI)
pip install pyansys            # Core packages only
pip install pyansys[all]       # All extras
pip install pyansys==2024.2.0  # Specific version
```

### Code Quality and Testing
```bash
# Linting (configured for 100-char line length)
ruff check
ruff format

# Pre-commit hooks (runs ruff, codespell, pydocstyle, license headers)
pre-commit run --all-files

# Smoke testing (no traditional unit tests - minimal source code)
python -c "from pyansys import __version__; print(__version__)"
python pyansys-uv-project/main.py  # Comprehensive verification script

# Test extras installations (matches CI smoke tests)
pip install -e .[fluent-all]
pip install -e .[mapdl-all] 
pip install -e .[tools]
pip install -e .[all]
```

### Documentation
```bash
# Build documentation
cd doc
make clean
make html

# Build PDF documentation
make pdf

# Documentation dependencies are available in [doc] extra group
pip install -e .[doc]
```

## Architecture

### Metapackage Structure
- **Minimal source**: Only `src/pyansys/__init__.py` with version metadata reading
- **Dependency coordination**: All 39 core packages pinned to specific versions in pyproject.toml
- **Release alignment**: Versioning follows Ansys product releases (YYYY.R.ZZ format)
  - YYYY = Ansys product release year (e.g., 2024)
  - R = Release within year (1 for R1, 2 for R2)
  - ZZ = Patch version for metapackage fixes

### Documentation System
- **Sphinx-based** with Ansys theme
- **Dynamic content**: Package versions and metadata driven by `projects.yaml` (740 lines)
- **Landing page**: Custom CSS/JS for interactive project browser
- **Multi-version support**: Documentation across different PyAnsys releases

### Key Files
- `projects.yaml`: Central metadata for all PyAnsys packages (versions, descriptions, thumbnails)
- `pyproject.toml`: Dependency pinning and optional package groups
- `doc/source/conf.py`: Documentation configuration with custom extensions

### Package Organization
Libraries are categorized by domain:
- **Structures**: PyMAPDL, PyMechanical, PyDPF, PyDYNA, PyACP
- **Fluids**: PyFluent, PyEnSight, PyRocky, PyTurboGrid  
- **Electronics**: PyAEDT, PyEDB, PyMotorCAD, PySherlock
- **Materials**: PyGranta, PyMaterials Manager
- **Platform**: PyOptislang, PyHPS, PyWorkbench

## Development Notes

- This is a **coordination repository** - most development happens in individual PyAnsys libraries
- Changes typically involve updating version pins in pyproject.toml or documentation
- The `projects.yaml` file drives much of the documentation generation
- Thumbnail images should be 640x480 with white backgrounds
- Uses flit as build backend with minimal source code in `src/pyansys/__init__.py`
- CI runs smoke tests across Python 3.10-3.13 on Windows, Ubuntu, and macOS

### Utility Scripts
- `tools/links.py`: Updates documentation links for package releases
- `tools/milestone.py`: Creates GitHub milestones for releases
- `tools/catsitemap.py`: Generates documentation sitemap

### UV Project Integration
- Contains `pyansys-uv-project/` demonstrating uv-based installation
- Use `uv add "pyansys[all]"` for complete installation with uv
- Startup scripts available for cross-platform usage
- CI uses uv for dependency management and testing

### Pre-commit Configuration
- Configured with ruff (linting/formatting), codespell, pydocstyle, license headers
- Validates GitHub workflow files with JSON schema
- Auto-adds license headers to source files starting from 2022