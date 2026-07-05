#!/bin/bash
# EXPENDABLE_ORCA v4.0.0 - Bash Installation Script
# Author: Ian Carter Kulani

set -e

echo "🦈 EXPENDABLE_ORCA v4.0.0 - Installation Script"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check Python version
check_python() {
    echo -e "${BLUE}[*] Checking Python version...${NC}"
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        if [[ $(echo "$PYTHON_VERSION >= 3.7" | bc) -eq 1 ]]; then
            echo -e "${GREEN}[✓] Python $PYTHON_VERSION detected${NC}"
            return 0
        else
            echo -e "${RED}[✗] Python 3.7+ required (found $PYTHON_VERSION)${NC}"
            return 1
        fi
    else
        echo -e "${RED}[✗] Python3 not found${NC}"
        return 1
    fi
}

# Install system dependencies
install_system_deps() {
    echo -e "${BLUE}[*] Installing system dependencies...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y python3-pip python3-dev build-essential \
                libssl-dev libffi-dev libxml2-dev libxslt1-dev \
                zlib1g-dev libjpeg-dev libpng-dev \
                nmap nikto whois dnsutils curl netcat-openbsd \
                traceroute iptables tcpdump wireshark \
                git vim tmux screen
        elif command -v yum &> /dev/null; then
            sudo yum install -y python3-pip python3-devel gcc \
                openssl-devel libffi-devel libxml2-devel \
                libxslt-devel zlib-devel libjpeg-devel \
                nmap nikto whois bind-utils curl nc \
                traceroute iptables tcpdump wireshark \
                git vim tmux screen
        elif command -v pacman &> /dev/null; then
            sudo pacman -S python-pip python python-virtualenv \
                base-devel openssl libffi libxml2 libxslt \
                zlib libjpeg-turbo nmap nikto whois \
                dnsutils curl netcat traceroute iptables \
                tcpdump wireshark-cli git vim tmux screen
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install python3 nmap nikto whois bind curl netcat \
                traceroute wireshark git vim tmux screen
        else
            echo -e "${YELLOW}[!] Homebrew not installed. Please install from https://brew.sh/${NC}"
        fi
    fi
}

# Install Python packages
install_python_packages() {
    echo -e "${BLUE}[*] Installing Python packages...${NC}"
    
    # Upgrade pip
    python3 -m pip install --upgrade pip
    
    # Install requirements
    if [ -f "requirements.txt" ]; then
        python3 -m pip install -r requirements.txt
    else
        echo -e "${YELLOW}[!] requirements.txt not found${NC}"
        python3 -m pip install \
            requests psutil cryptography \
            Flask Flask-SocketIO Flask-CORS \
            scapy paramiko dnspython python-whois \
            pynput pyautogui pyperclip pillow \
            discord.py slack-sdk telethon \
            matplotlib seaborn numpy \
            reportlab beautifulsoup4 \
            python-dotenv pyyaml colorama \
            tabulate tqdm schedule python-dateutil
    fi
}

# Install Signal CLI
install_signal_cli() {
    echo -e "${BLUE}[*] Installing Signal CLI...${NC}"
    
    if command -v signal-cli &> /dev/null; then
        echo -e "${GREEN}[✓] signal-cli already installed${NC}"
        return
    fi
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget -O signal-cli.tar.gz https://github.com/AsamK/signal-cli/releases/download/v0.11.8/signal-cli-0.11.8.tar.gz
        tar -xzf signal-cli.tar.gz
        sudo mv signal-cli-0.11.8 /opt/signal-cli
        sudo ln -s /opt/signal-cli/bin/signal-cli /usr/local/bin/signal-cli
        rm signal-cli.tar.gz
        echo -e "${GREEN}[✓] Signal CLI installed${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install signal-cli
    else
        echo -e "${YELLOW}[!] Signal CLI installation skipped (manual installation required)${NC}"
    fi
}

# Setup directories
setup_directories() {
    echo -e "${BLUE}[*] Setting up directories...${NC}"
    
    mkdir -p .expendable_orca
    mkdir -p .expendable_orca/payloads
    mkdir -p .expendable_orca/workspaces
    mkdir -p .expendable_orca/scans
    mkdir -p .expendable_orca/phishing_pages
    mkdir -p .expendable_orca/captured_credentials
    mkdir -p .expendable_orca/ssh_keys
    mkdir -p .expendable_orca/traffic_logs
    mkdir -p .expendable_orca/nikto_results
    mkdir -p .expendable_orca/web_templates
    mkdir -p .expendable_orca/sessions
    mkdir -p .expendable_orca/spear_phishing
    mkdir -p .expendable_orca/email_templates
    mkdir -p .expendable_orca/dos_logs
    mkdir -p .expendable_orca/agents
    mkdir -p .expendable_orca/c2_logs
    mkdir -p .expendable_orca/modules
    mkdir -p .expendable_orca/network_monitor
    mkdir -p .expendable_orca/keylog_exfil
    mkdir -p .expendable_orca/deployments
    mkdir -p .expendable_orca/domain_hosting
    mkdir -p expendable_orca_reports
    mkdir -p expendable_orca_reports/graphics
    
    echo -e "${GREEN}[✓] Directories created${NC}"
}

# Setup config
setup_config() {
    echo -e "${BLUE}[*] Setting up configuration...${NC}"
    
    if [ ! -f ".expendable_orca/config.json" ]; then
        cat > .expendable_orca/config.json << 'EOF'
{
    "version": "4.0.0",
    "auto_start": false,
    "auto_block_enabled": false,
    "auto_block_threshold": 5,
    "scan_timeout": 30,
    "report_format": "html",
    "generate_graphics": true,
    "web": {
        "enabled": false,
        "port": 5000,
        "host": "0.0.0.0",
        "require_auth": true
    },
    "monitoring": {
        "enabled": true,
        "port_scan_threshold": 10,
        "syn_flood_threshold": 100,
        "ddos_threshold": 1000
    },
    "keylogger": {
        "enabled": false,
        "hotkey": "f10",
        "upload_interval": 30,
        "screenshot_interval": 60,
        "exfil_methods": ["file", "email", "c2"]
    },
    "spear_phishing": {
        "enabled": true,
        "smtp_port": 587,
        "track_opens": true,
        "track_clicks": true
    },
    "dos": {
        "enabled": true,
        "max_threads": 100
    },
    "agent": {
        "enabled": false,
        "heartbeat_interval": 30
    },
    "domain_hosting": {
        "enabled": false,
        "base_domain": "localhost"
    }
}
EOF
        echo -e "${GREEN}[✓] Default configuration created${NC}"
    else
        echo -e "${YELLOW}[!] Configuration already exists${NC}"
    fi
}

# Main installation
main() {
    echo -e "${CYAN}🦈 EXPENDABLE_ORCA v4.0.0 Installation${NC}"
    echo ""
    
    # Check Python
    if ! check_python; then
        echo -e "${RED}[!] Please install Python 3.7+${NC}"
        exit 1
    fi
    
    # Install system dependencies
    install_system_deps
    
    # Install Python packages
    install_python_packages
    
    # Install Signal CLI
    install_signal_cli
    
    # Setup directories
    setup_directories
    
    # Setup config
    setup_config
    
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo -e "${CYAN}To run EXPENDABLE_ORCA:${NC}"
    echo -e "  python3 expendable_orca.py"
    echo ""
    echo -e "${YELLOW}⚠️ For full functionality:${NC}"
    echo -e "  - Run with sudo/root for packet generation"
    echo -e "  - Install additional tools: nmap, nikto, whois"
    echo -e "  - Configure platform bots as needed"
    echo ""
}

# Run main
main "$@"