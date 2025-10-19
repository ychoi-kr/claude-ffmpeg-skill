#!/usr/bin/env python3
"""
FFmpeg Toolkit Skill - Validation Script
Checks if ffmpeg is installed and provides system information
"""

import subprocess
import sys
import platform
import json
from pathlib import Path

# ANSI color codes
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_header():
    """Print validation header"""
    print(f"\n{Colors.BLUE}{Colors.BOLD}{'='*50}{Colors.END}")
    print(f"{Colors.BLUE}{Colors.BOLD}  FFmpeg Toolkit - System Validation{Colors.END}")
    print(f"{Colors.BLUE}{Colors.BOLD}{'='*50}{Colors.END}\n")

def print_success(message):
    """Print success message"""
    print(f"{Colors.GREEN}✓{Colors.END} {message}")

def print_warning(message):
    """Print warning message"""
    print(f"{Colors.YELLOW}⚠{Colors.END} {message}")

def print_error(message):
    """Print error message"""
    print(f"{Colors.RED}✗{Colors.END} {message}")

def print_info(message):
    """Print info message"""
    print(f"{Colors.BLUE}ℹ{Colors.END} {message}")

def check_ffmpeg_installed():
    """Check if ffmpeg is installed"""
    try:
        result = subprocess.run(
            ['ffmpeg', '-version'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            version_line = result.stdout.split('\n')[0]
            print_success(f"ffmpeg installed: {version_line}")
            return True, version_line
        else:
            print_error("ffmpeg command failed")
            return False, None
    except FileNotFoundError:
        print_error("ffmpeg not found in PATH")
        return False, None
    except subprocess.TimeoutExpired:
        print_error("ffmpeg command timed out")
        return False, None
    except Exception as e:
        print_error(f"Error checking ffmpeg: {str(e)}")
        return False, None

def check_ffprobe_installed():
    """Check if ffprobe is installed"""
    try:
        result = subprocess.run(
            ['ffprobe', '-version'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print_success("ffprobe installed")
            return True
        else:
            print_warning("ffprobe command failed")
            return False
    except FileNotFoundError:
        print_warning("ffprobe not found (optional but recommended)")
        return False
    except Exception:
        return False

def get_supported_codecs():
    """Get list of supported codecs"""
    try:
        result = subprocess.run(
            ['ffmpeg', '-codecs'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            codecs = result.stdout
            
            # Check for important codecs
            important_codecs = {
                'h264': 'H.264/AVC',
                'hevc': 'H.265/HEVC',
                'vp9': 'VP9',
                'av1': 'AV1',
                'aac': 'AAC',
                'mp3': 'MP3',
                'opus': 'Opus',
            }
            
            found_codecs = []
            missing_codecs = []
            
            for codec_id, codec_name in important_codecs.items():
                if codec_id in codecs.lower():
                    found_codecs.append(codec_name)
                else:
                    missing_codecs.append(codec_name)
            
            print_info(f"Supported codecs: {', '.join(found_codecs)}")
            
            if missing_codecs:
                print_warning(f"Missing codecs: {', '.join(missing_codecs)}")
            
            return True
        else:
            print_warning("Could not retrieve codec information")
            return False
    except Exception as e:
        print_warning(f"Error checking codecs: {str(e)}")
        return False

def get_supported_formats():
    """Get list of supported formats"""
    try:
        result = subprocess.run(
            ['ffmpeg', '-formats'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            formats = result.stdout
            
            # Check for important formats
            important_formats = ['mp4', 'webm', 'mov', 'avi', 'mkv', 'gif']
            found = [f for f in important_formats if f in formats.lower()]
            
            print_info(f"Supported formats: {', '.join(found)}")
            return True
        else:
            print_warning("Could not retrieve format information")
            return False
    except Exception as e:
        print_warning(f"Error checking formats: {str(e)}")
        return False

def check_hardware_acceleration():
    """Check for hardware acceleration support"""
    hw_accels = []
    
    # Common hardware acceleration methods
    accel_methods = {
        'videotoolbox': 'VideoToolbox (macOS)',
        'cuda': 'NVIDIA CUDA',
        'qsv': 'Intel Quick Sync',
        'vaapi': 'VA-API (Linux)',
        'dxva2': 'DXVA2 (Windows)',
        'd3d11va': 'Direct3D 11 (Windows)',
    }
    
    try:
        result = subprocess.run(
            ['ffmpeg', '-hwaccels'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            output = result.stdout.lower()
            
            for method, name in accel_methods.items():
                if method in output:
                    hw_accels.append(name)
            
            if hw_accels:
                print_success(f"Hardware acceleration: {', '.join(hw_accels)}")
            else:
                print_info("No hardware acceleration detected")
            
            return True
        else:
            return False
    except Exception:
        return False

def get_system_info():
    """Get system information"""
    print_info(f"Operating System: {platform.system()} {platform.release()}")
    print_info(f"Architecture: {platform.machine()}")
    print_info(f"Python: {platform.python_version()}")

def check_skill_installation():
    """Check if the skill is properly installed"""
    skills_dir = Path.home() / '.claude' / 'skills' / 'ffmpeg-toolkit'
    skill_file = skills_dir / 'SKILL.md'
    
    if skills_dir.exists():
        print_success(f"Skill directory found: {skills_dir}")
        
        if skill_file.exists():
            print_success("SKILL.md file found")
            
            # Check file size
            size = skill_file.stat().st_size
            if size > 0:
                print_success(f"SKILL.md size: {size:,} bytes")
            else:
                print_error("SKILL.md is empty")
                return False
            
            return True
        else:
            print_error("SKILL.md not found")
            return False
    else:
        print_warning("Skill not installed in ~/.claude/skills/ffmpeg-toolkit")
        print_info("Run install.sh to install the skill")
        return False

def suggest_installation():
    """Suggest installation method based on OS"""
    print(f"\n{Colors.BOLD}Installation Instructions:{Colors.END}\n")
    
    os_type = platform.system()
    
    if os_type == 'Darwin':  # macOS
        print("macOS detected:")
        print("  brew install ffmpeg")
    elif os_type == 'Linux':
        print("Linux detected:")
        print("  Ubuntu/Debian: sudo apt-get install ffmpeg")
        print("  Fedora:        sudo dnf install ffmpeg")
        print("  Arch:          sudo pacman -S ffmpeg")
    elif os_type == 'Windows':
        print("Windows detected:")
        print("  choco install ffmpeg")
        print("  or download from: https://ffmpeg.org/download.html")
    else:
        print(f"Unknown OS: {os_type}")
        print("  Visit: https://ffmpeg.org/download.html")
    
    print()

def run_test_command():
    """Run a simple test command"""
    print(f"\n{Colors.BOLD}Running Test Command:{Colors.END}\n")
    
    try:
        # Test creating a 1-second video from color
        result = subprocess.run(
            [
                'ffmpeg',
                '-f', 'lavfi',
                '-i', 'color=c=blue:s=320x240:d=1',
                '-f', 'null',
                '-'
            ],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode == 0:
            print_success("Test command executed successfully")
            return True
        else:
            print_error("Test command failed")
            print(f"  Error: {result.stderr[:200]}")
            return False
    except subprocess.TimeoutExpired:
        print_error("Test command timed out")
        return False
    except Exception as e:
        print_error(f"Test command error: {str(e)}")
        return False

def generate_report(results):
    """Generate JSON report"""
    report = {
        'ffmpeg_installed': results.get('ffmpeg', False),
        'ffprobe_installed': results.get('ffprobe', False),
        'skill_installed': results.get('skill', False),
        'test_passed': results.get('test', False),
        'system': {
            'os': platform.system(),
            'release': platform.release(),
            'architecture': platform.machine(),
        }
    }
    
    report_file = Path('validation_report.json')
    with open(report_file, 'w') as f:
        json.dump(report, indent=2, fp=f)
    
    print_info(f"Report saved to: {report_file}")

def main():
    """Main validation flow"""
    print_header()
    
    results = {}
    
    # System info
    print(f"{Colors.BOLD}System Information:{Colors.END}\n")
    get_system_info()
    
    # Check ffmpeg
    print(f"\n{Colors.BOLD}FFmpeg Installation:{Colors.END}\n")
    ffmpeg_ok, _ = check_ffmpeg_installed()
    results['ffmpeg'] = ffmpeg_ok
    
    if not ffmpeg_ok:
        suggest_installation()
        print_error("FFmpeg validation failed")
        sys.exit(1)
    
    # Check ffprobe
    ffprobe_ok = check_ffprobe_installed()
    results['ffprobe'] = ffprobe_ok
    
    # Check capabilities
    print(f"\n{Colors.BOLD}FFmpeg Capabilities:{Colors.END}\n")
    get_supported_codecs()
    get_supported_formats()
    check_hardware_acceleration()
    
    # Check skill installation
    print(f"\n{Colors.BOLD}Skill Installation:{Colors.END}\n")
    skill_ok = check_skill_installation()
    results['skill'] = skill_ok
    
    # Run test
    test_ok = run_test_command()
    results['test'] = test_ok
    
    # Generate report
    print()
    generate_report(results)
    
    # Summary
    print(f"\n{Colors.BOLD}Validation Summary:{Colors.END}\n")
    
    all_ok = all([ffmpeg_ok, skill_ok, test_ok])
    
    if all_ok:
        print_success("All checks passed! ✨")
        print_info("You're ready to use the FFmpeg Toolkit skill")
    else:
        print_warning("Some checks failed")
        if not skill_ok:
            print_info("Install the skill with: ./install.sh")
    
    print()
    
    return 0 if all_ok else 1

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Validation cancelled{Colors.END}")
        sys.exit(1)
    except Exception as e:
        print(f"\n{Colors.RED}Unexpected error: {str(e)}{Colors.END}")
        sys.exit(1)
