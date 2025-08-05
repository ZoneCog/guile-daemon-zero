#!/bin/bash
# setup-agent-zero.sh - GNU Agent-Zero Genesis Setup Script
# Copyright © 2024 GNU Agent-Zero Genesis Project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
AGENT_ZERO_VERSION="0.1.0"
GUIX_VERSION="1.4.0"

print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                GNU Agent-Zero Genesis Setup                  ║"
    echo "║        Hypergraphically-Encoded Cognitive OS Environment    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            echo "debian"
        elif command -v yum &> /dev/null; then
            echo "redhat"
        elif command -v pacman &> /dev/null; then
            echo "arch"
        elif command -v zypper &> /dev/null; then
            echo "opensuse"
        else
            echo "linux-unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "freebsd"
    else
        echo "unknown"
    fi
}

check_dependencies() {
    log_info "Checking system dependencies..."
    
    local missing_deps=()
    
    # Check for essential tools
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v wget >/dev/null 2>&1 || missing_deps+=("wget")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v gcc >/dev/null 2>&1 || missing_deps+=("gcc")
    command -v make >/dev/null 2>&1 || missing_deps+=("make")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Please install these dependencies and run the script again."
        exit 1
    fi
    
    log_info "All essential dependencies found."
}

install_guix_debian() {
    log_info "Installing Guix on Debian/Ubuntu..."
    
    # Download and run Guix install script
    cd /tmp
    wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh
    chmod +x guix-install.sh
    
    log_warn "Running Guix installer (requires sudo)..."
    sudo ./guix-install.sh
    
    # Source Guix environment
    if [ -f /etc/profile ]; then
        source /etc/profile
    fi
    
    # Enable Guix daemon
    sudo systemctl enable guix-daemon
    sudo systemctl start guix-daemon
}

install_guix_arch() {
    log_info "Installing Guix on Arch Linux..."
    
    # Install from AUR
    if command -v yay &> /dev/null; then
        yay -S guix
    elif command -v paru &> /dev/null; then
        paru -S guix
    else
        log_error "Please install an AUR helper (yay or paru) first"
        exit 1
    fi
    
    # Enable services
    sudo systemctl enable --now guix-daemon
    sudo systemctl enable --now gnu-store.mount
    
    # Add user to guixbuild group
    sudo usermod -a -G guixbuild $USER
    
    log_warn "Please log out and log back in for group changes to take effect"
}

install_guix_redhat() {
    log_info "Installing Guix on Red Hat/CentOS/Fedora..."
    
    # Install dependencies
    if command -v dnf &> /dev/null; then
        sudo dnf install -y curl wget git gcc make
    else
        sudo yum install -y curl wget git gcc make
    fi
    
    # Use standard Guix installer
    install_guix_debian
}

install_guix_macos() {
    log_info "Installing Guix on macOS..."
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is required for macOS installation"
        log_info "Install Homebrew from https://brew.sh/ and run again"
        exit 1
    fi
    
    # Install dependencies
    brew install curl wget git gcc make
    
    # Use standard Guix installer
    install_guix_debian
}

setup_guix_environment() {
    log_info "Setting up Guix environment..."
    
    # Authorize Guix substitute servers
    if command -v guix &> /dev/null; then
        guix archive --authorize < /etc/guix/signing-key.pub 2>/dev/null || true
    fi
    
    # Update Guix
    guix pull
    
    # Source the updated environment
    source ~/.config/guix/current/etc/profile
}

clone_agent_zero() {
    log_info "Cloning Agent-Zero Genesis repository..."
    
    local repo_dir="$HOME/agent-zero-genesis"
    
    if [ -d "$repo_dir" ]; then
        log_warn "Repository already exists at $repo_dir"
        cd "$repo_dir"
        git pull origin main
    else
        git clone https://github.com/ZoneCog/guile-daemon-zero.git "$repo_dir"
        cd "$repo_dir"
    fi
    
    export AGENT_ZERO_DIR="$repo_dir"
}

build_agent_zero() {
    log_info "Building Agent-Zero Genesis environment..."
    
    cd "$AGENT_ZERO_DIR"
    
    # Set environment variables
    export AGENT_ZERO_MANIFEST=1
    export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
    
    # Build using Guix
    log_info "Creating Guix environment..."
    guix environment -m guix.scm --ad-hoc autoconf automake texinfo -- bash -c "
        ./autogen.sh
        ./configure --enable-cognitive-extensions
        make
    "
    
    log_info "Agent-Zero Genesis build completed successfully!"
}

create_config() {
    log_info "Creating Agent-Zero configuration..."
    
    cat > "$AGENT_ZERO_DIR/agent-zero-config.scm" << 'EOF'
;; Agent-Zero Genesis Configuration

((kernel-specs . (((shape . (64 64))
                   (function . logical-reasoning)
                   (attention-weight . 0.8))
                  ((shape . (128 32))
                   (function . pattern-learning)
                   (attention-weight . 0.6))
                  ((shape . (32 16))
                   (function . attention-allocation)
                   (attention-weight . 0.7))
                  ((shape . (256 16))
                   (function . memory-consolidation)
                   (attention-weight . 0.5))))
 (goals . (reasoning learning attention memory))
 (meta-cognitive-level . 2)
 (hypergraph-persistence . #t)
 (attention-budget . 1000.0)
 (focus-boundary . 100.0)
 (selection-threshold . 50.0))
EOF

    log_info "Configuration created at $AGENT_ZERO_DIR/agent-zero-config.scm"
}

create_launchers() {
    log_info "Creating launcher scripts..."
    
    # Create agent-zero launcher
    cat > "$AGENT_ZERO_DIR/launch-agent-zero.sh" << 'EOF'
#!/bin/bash
# Agent-Zero Genesis Launcher

export AGENT_ZERO_MANIFEST=1
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

cd "$(dirname "$0")"

echo "Starting GNU Agent-Zero Genesis..."
echo "Cognitive kernels initializing..."

guix environment -m guix.scm -- ./pre-inst-env guile-daemon
EOF

    # Create client launcher
    cat > "$AGENT_ZERO_DIR/agent-zero-client.sh" << 'EOF'
#!/bin/bash
# Agent-Zero Genesis Client

cd "$(dirname "$0")"

# Send commands to Agent-Zero daemon
guix environment -m guix.scm -- ./pre-inst-env gdpipe "$@"
EOF

    chmod +x "$AGENT_ZERO_DIR/launch-agent-zero.sh"
    chmod +x "$AGENT_ZERO_DIR/agent-zero-client.sh"
    
    log_info "Launcher scripts created"
}

run_tests() {
    log_info "Running Agent-Zero Genesis tests..."
    
    cd "$AGENT_ZERO_DIR"
    
    # Create simple test
    cat > test-agent-zero.scm << 'EOF'
(use-modules (agent-zero)
             (agent-zero kernel)
             (agent-zero hypergraph)
             (agent-zero attention))

(display "Testing Agent-Zero Genesis modules...\n")

;; Test kernel creation
(let ((kernel (spawn-cognitive-kernel '(32 32) 'logical-reasoning 0.8)))
  (if kernel
      (display "✓ Cognitive kernel creation: PASS\n")
      (display "✗ Cognitive kernel creation: FAIL\n")))

;; Test hypergraph
(let ((atomspace (make-atomspace)))
  (atomspace-add-node! atomspace 'ConceptNode "test-concept")
  (display "✓ Hypergraph AtomSpace: PASS\n"))

;; Test attention network
(let ((network (make-attention-network)))
  (if network
      (display "✓ Attention network creation: PASS\n")
      (display "✗ Attention network creation: FAIL\n")))

(display "Agent-Zero Genesis test completed.\n")
EOF

    # Run test in Guix environment
    guix environment -m guix.scm -- ./pre-inst-env guile test-agent-zero.scm
    
    rm test-agent-zero.scm
}

setup_desktop_integration() {
    log_info "Setting up desktop integration..."
    
    # Create desktop entry
    mkdir -p "$HOME/.local/share/applications"
    
    cat > "$HOME/.local/share/applications/agent-zero-genesis.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Agent-Zero Genesis
Comment=GNU Agent-Zero Genesis Cognitive Computing Platform
Exec=$AGENT_ZERO_DIR/launch-agent-zero.sh
Icon=applications-science
Terminal=true
Categories=Science;Education;Development;
EOF

    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database "$HOME/.local/share/applications"
    fi
    
    log_info "Desktop integration completed"
}

print_success() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║             Agent-Zero Genesis Setup Complete!              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo "Quick start commands:"
    echo "  Start Agent-Zero: $AGENT_ZERO_DIR/launch-agent-zero.sh"
    echo "  Send commands:    $AGENT_ZERO_DIR/agent-zero-client.sh '(display \"Hello Agent-Zero!\")'"
    echo "  Configuration:    $AGENT_ZERO_DIR/agent-zero-config.scm"
    echo "  Documentation:    $AGENT_ZERO_DIR/AGENT-ZERO-GENESIS.md"
    echo ""
    echo "The gestalt tensor field sings the song of emergent intelligence!"
}

main() {
    print_banner
    
    local platform=$(detect_platform)
    log_info "Detected platform: $platform"
    
    check_dependencies
    
    # Install Guix based on platform
    case $platform in
        "debian")
            install_guix_debian
            ;;
        "arch")
            install_guix_arch
            ;;
        "redhat")
            install_guix_redhat
            ;;
        "macos")
            install_guix_macos
            ;;
        *)
            log_warn "Unsupported platform: $platform"
            log_info "Attempting generic installation..."
            install_guix_debian
            ;;
    esac
    
    setup_guix_environment
    clone_agent_zero
    build_agent_zero
    create_config
    create_launchers
    run_tests
    setup_desktop_integration
    print_success
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi