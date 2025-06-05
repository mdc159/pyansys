"""PyAnsys UV Project - Installation Verification and Testing."""

import sys
from importlib import import_module


def verify_pyansys_installation():
    """Verify PyAnsys installation and print available packages."""
    print("=" * 60)
    print("PyAnsys UV Project - Installation Verification")
    print("=" * 60)
    
    try:
        import pyansys
        print(f"✅ PyAnsys successfully imported!")
        print(f"   Version: {pyansys.__version__}")
        print()
        
        # Test core PyAnsys packages
        core_packages = [
            ("ansys.mapdl.core", "PyMAPDL"),
            ("ansys.fluent.core", "PyFluent"), 
            ("ansys.dpf.core", "PyDPF Core"),
            ("ansys.mechanical.core", "PyMechanical"),
            ("pyaedt", "PyAEDT"),
            ("ansys.geometry.core", "PyAnsys Geometry"),
            ("pytwin", "PyTwin"),
        ]
        
        print("Testing core package imports:")
        print("-" * 40)
        
        imported_count = 0
        for package_name, display_name in core_packages:
            try:
                import_module(package_name)
                print(f"✅ {display_name:<20} - OK")
                imported_count += 1
            except ImportError as e:
                print(f"❌ {display_name:<20} - Failed: {str(e)[:50]}...")
            except Exception as e:
                print(f"⚠️  {display_name:<20} - Warning: {str(e)[:50]}...")
        
        print()
        print(f"Summary: {imported_count}/{len(core_packages)} packages imported successfully")
        
        # Test optional dependencies
        print("\nTesting optional dependencies:")
        print("-" * 40)
        
        optional_packages = [
            ("ansys.mapdl.reader", "PyMAPDL Reader (mapdl-all)"),
            ("ansys.fluent.visualization", "Fluent Visualization (fluent-all)"),
            ("ansys.materials.manager", "Materials Manager (tools)"),
            ("ansys.units", "Ansys Units (tools)"),
        ]
        
        optional_count = 0
        for package_name, display_name in optional_packages:
            try:
                import_module(package_name)
                print(f"✅ {display_name:<35} - OK")
                optional_count += 1
            except ImportError:
                print(f"❌ {display_name:<35} - Not installed")
            except Exception as e:
                print(f"⚠️  {display_name:<35} - Warning: {str(e)[:30]}...")
        
        print()
        print(f"Optional packages: {optional_count}/{len(optional_packages)} available")
        
    except ImportError as e:
        print(f"❌ Failed to import PyAnsys: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False
    
    print("\n" + "=" * 60)
    print("Installation verification complete!")
    print("=" * 60)
    return True


def test_virtual_environment():
    """Test that we're running in the correct virtual environment."""
    print(f"Python executable: {sys.executable}")
    print(f"Python version: {sys.version}")
    
    # Check if we're in a virtual environment
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("✅ Running in virtual environment")
        print(f"   Virtual env path: {sys.prefix}")
    else:
        print("⚠️  Not running in virtual environment")
    
    print()


def main():
    """Main function to run all tests."""
    test_virtual_environment()
    verify_pyansys_installation()


if __name__ == "__main__":
    main()
