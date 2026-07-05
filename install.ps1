# EXPENDABLE_ORCA v4.0.0 - PowerShell Installation Script
# Author: Ian Carter Kulani

Write-Host "🦈 EXPENDABLE_ORCA v4.0.0 - Installation Script" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "[*] $pythonVersion detected" -ForegroundColor Green
} catch {
    Write-Host "[✗] Python not found! Please install Python 3.7+ from python.org" -ForegroundColor Red
    exit 1
}

# Check Python version
$version = [regex]::Match($pythonVersion, "\d+\.\d+\.\d+").Value
if ($version) {
    $major = [int]($version.Split('.')[0])
    $minor = [int]($version.Split('.')[1])
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 7)) {
        Write-Host "[✗] Python 3.7+ required (found $version)" -ForegroundColor Red
        exit 1
    }
    Write-Host "[✓] Python version OK" -ForegroundColor Green
}

# Upgrade pip
Write-Host "[*] Upgrading pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip

# Install requirements
Write-Host "[*] Installing Python packages..." -ForegroundColor Cyan
if (Test-Path "requirements.txt") {
    pip install -r requirements.txt
} else {
    pip install requests psutil cryptography Flask Flask-SocketIO Flask-CORS scapy paramiko dnspython pynput pyautogui pyperclip pillow discord.py slack-sdk telethon matplotlib seaborn numpy reportlab beautifulsoup4 python-dotenv pyyaml colorama tabulate tqdm schedule python-dateutil
}

# Create directories
Write-Host "[*] Creating directories..." -ForegroundColor Cyan
$directories = @(
    ".expendable_orca",
    ".expendable_orca\payloads",
    ".expendable_orca\workspaces",
    ".expendable_orca\scans",
    ".expendable_orca\phishing_pages",
    ".expendable_orca\captured_credentials",
    ".expendable_orca\ssh_keys",
    ".expendable_orca\traffic_logs",
    ".expendable_orca\nikto_results",
    ".expendable_orca\web_templates",
    ".expendable_orca\sessions",
    ".expendable_orca\spear_phishing",
    ".expendable_orca\email_templates",
    ".expendable_orca\dos_logs",
    ".expendable_orca\agents",
    ".expendable_orca\c2_logs",
    ".expendable_orca\modules",
    ".expendable_orca\network_monitor",
    ".expendable_orca\keylog_exfil",
    ".expendable_orca\deployments",
    ".expendable_orca\domain_hosting",
    "expendable_orca_reports",
    "expendable_orca_reports\graphics"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Create default config
Write-Host "[*] Creating default configuration..." -ForegroundColor Cyan
if (-not (Test-Path ".expendable_orca\config.json")) {
    $config = @'
{
    "version": "4.0.0",
    "auto_start": false,
    "auto_block_enabled": false,
    "web": {
        "enabled": false,
        "port": 5000,
        "host": "0.0.0.0"
    },
    "monitoring": {
        "enabled": true
    },
    "keylogger": {
        "enabled": false,
        "hotkey": "f10"
    },
    "spear_phishing": {
        "enabled": true,
        "smtp_port": 587
    },
    "dos": {
        "enabled": true,
        "max_threads": 100
    },
    "domain_hosting": {
        "enabled": false
    }
}
'@
    $config | Out-File -FilePath ".expendable_orca\config.json" -Encoding UTF8
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To run EXPENDABLE_ORCA:" -ForegroundColor Cyan
Write-Host "  python expendable_orca.py" -ForegroundColor White
Write-Host ""
Write-Host "⚠️ For full functionality, run PowerShell as Administrator" -ForegroundColor Yellow
Write-Host ""