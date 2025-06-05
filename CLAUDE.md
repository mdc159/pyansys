# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PyAnsys is a metapackage that provides a unified collection of 35+ Python libraries for interacting with Ansys simulation products. It serves as a compatibility-assured entry point to the entire PyAnsys ecosystem, spanning domains like structures, fluids, electronics, materials, and platform tools.

## Development Commands

### Installation and Setup
```bash
# Install core PyAnsys packages
pip install -e .

# Install with optional dependencies
pip install -e .[all]          # Everything
pip install -e .[mapdl-all]    # Includes PyMAPDL Reader
pip install -e .[fluent-all]   # Includes visualization tools
pip install -e .[tools]        # Includes utilities
```

### Code Quality
```bash
# Linting (configured for 100-char line length)
ruff check
ruff format

# Pre-commit hooks (runs ruff, codespell, pydocstyle, license headers)
pre-commit run --all-files
```

### Documentation
```bash
# Build documentation
cd doc
make clean
make html

# Build PDF documentation
make pdf
```

## Architecture

### Metapackage Structure
- **Minimal source**: Only `src/pyansys/__init__.py` with version metadata reading
- **Dependency coordination**: All 39 core packages pinned to specific versions in pyproject.toml
- **Release alignment**: Versioning follows Ansys product releases (YYYY.R.ZZ format)

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