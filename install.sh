#!/bin/bash

# ffmpeg Usage Skill - Installation Script
# This script installs the ffmpeg-usage skill for Claude

set -e

SKILL_NAME="ffmpeg-usage"
SKILLS_DIR="$HOME/.claude/skills"
INSTALL_DIR="$SKILLS_DIR/$SKILL_NAME"
REPO_URL="https://github.com/ychoi-kr/claude-ffmpeg-skill.git"
TEMP_DIR="/tmp/ffmpeg-skill-install"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   ffmpeg Usage Skill - Installer      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check ffmpeg installation
check_ffmpeg() {
    print_info "Checking for ffmpeg installation..."
    
    if command_exists ffmpeg; then
        FFMPEG_VERSION=$(ffmpeg -version | head -n1)
        print_success "ffmpeg found: $FFMPEG_VERSION"
        return 0
    else
        print_warning "ffmpeg not found"
        echo ""
        echo "  Please install ffmpeg first:"
        echo ""
        echo "  macOS:        brew install ffmpeg"
        echo "  Ubuntu:       sudo apt-get install ffmpeg"
        echo "  Windows:      choco install ffmpeg"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        return 1
    fi
}

# Create skills directory
create_skills_directory() {
    print_info "Setting up skills directory..."
    
    if [ ! -d "$SKILLS_DIR" ]; then
        mkdir -p "$SKILLS_DIR"
        print_success "Created $SKILLS_DIR"
    else
        print_success "Skills directory exists"
    fi
}

# Check for existing installation
check_existing() {
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "ffmpeg Usage skill is already installed"
        echo ""
        read -p "Overwrite existing installation? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$INSTALL_DIR"
            print_success "Removed existing installation"
        else
            print_error "Installation cancelled"
            exit 1
        fi
    fi
}

# Install from GitHub
install_from_github() {
    print_info "Downloading from GitHub..."
    
    # Clone to temp directory
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    
    if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
        print_success "Downloaded skill files"
        
        # Copy to skills directory
        cp -r "$TEMP_DIR" "$INSTALL_DIR"
        
        # Clean up
        rm -rf "$TEMP_DIR"
        
        print_success "Installed to $INSTALL_DIR"
        return 0
    else
        print_error "Failed to download from GitHub"
        return 1
    fi
}

# Install from local files
install_from_local() {
    print_info "Installing from current directory..."
    
    # Check if SKILL.md exists in current directory
    if [ ! -f "SKILL.md" ]; then
        print_error "SKILL.md not found in current directory"
        return 1
    fi
    
    # Copy current directory to skills
    mkdir -p "$INSTALL_DIR"
    cp -r ./* "$INSTALL_DIR/"
    
    print_success "Installed from local files"
    return 0
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    if [ -f "$INSTALL_DIR/SKILL.md" ]; then
        print_success "SKILL.md found"
    else
        print_error "SKILL.md not found - installation may be incomplete"
        return 1
    fi
    
    # Check file permissions
    if [ -r "$INSTALL_DIR/SKILL.md" ]; then
        print_success "Files are readable"
    else
        print_error "Permission issues detected"
        return 1
    fi
    
    return 0
}

# Print next steps
print_next_steps() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     Installation Complete! 🎉         ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Restart Claude Code to load the skill"
    echo "2. Try: 'Convert this video to MP4'"
    echo "3. Or: 'Create a GIF from this video'"
    echo ""
    echo "Documentation:"
    echo "  - Skill location: $INSTALL_DIR"
    echo "  - Full guide: $INSTALL_DIR/README.md"
    echo ""
    echo "Need help? Visit: https://github.com/ychoi-kr/claude-ffmpeg-skill"
    echo ""
}

# Main installation flow
main() {
    print_header
    
    # Check prerequisites
    check_ffmpeg
    
    # Setup
    create_skills_directory
    check_existing
    
    # Install
    echo ""
    if command_exists git; then
        print_info "Git detected - attempting GitHub installation..."
        if install_from_github; then
            :
        else
            print_warning "GitHub installation failed, trying local..."
            install_from_local || {
                print_error "Installation failed"
                exit 1
            }
        fi
    else
        print_warning "Git not found - installing from local files..."
        install_from_local || {
            print_error "Installation failed"
            exit 1
        }
    fi
    
    # Verify
    echo ""
    verify_installation || {
        print_error "Installation verification failed"
        exit 1
    }
    
    # Success
    print_next_steps
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "ffmpeg Usage Skill Installer"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --uninstall    Remove the skill"
        echo ""
        exit 0
        ;;
    --uninstall)
        if [ -d "$INSTALL_DIR" ]; then
            rm -rf "$INSTALL_DIR"
            print_success "ffmpeg Usage skill uninstalled"
        else
            print_warning "Skill not found"
        fi
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
