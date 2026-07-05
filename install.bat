@echo off
REM EXPENDABLE_ORCA v4.0.0 - Windows Installation Script
REM Author: Ian Carter Kulani

echo 🦈 EXPENDABLE_ORCA v4.0.0 - Installation Script
echo ================================================
echo.

:: Check Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [✗] Python not found! Please install Python 3.7+ from python.org
    pause
    exit /b 1
)

:: Check Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [*] Python %PYTHON_VERSION% detected

:: Upgrade pip
echo [*] Upgrading pip...
python -m pip install --upgrade pip

:: Install requirements
echo [*] Installing Python packages...
if exist requirements.txt (
    pip install -r requirements.txt
) else (
    pip install requests psutil cryptography Flask Flask-SocketIO Flask-CORS scapy paramiko dnspython pynput pyautogui pyperclip pillow discord.py slack-sdk telethon matplotlib seaborn numpy reportlab beautifulsoup4 python-dotenv pyyaml colorama tabulate tqdm schedule python-dateutil
)

:: Create directories
echo [*] Creating directories...
mkdir .expendable_orca 2>nul
mkdir .expendable_orca\payloads 2>nul
mkdir .expendable_orca\workspaces 2>nul
mkdir .expendable_orca\scans 2>nul
mkdir .expendable_orca\phishing_pages 2>nul
mkdir .expendable_orca\captured_credentials 2>nul
mkdir .expendable_orca\ssh_keys 2>nul
mkdir .expendable_orca\traffic_logs 2>nul
mkdir .expendable_orca\nikto_results 2>nul
mkdir .expendable_orca\web_templates 2>nul
mkdir .expendable_orca\sessions 2>nul
mkdir .expendable_orca\spear_phishing 2>nul
mkdir .expendable_orca\email_templates 2>nul
mkdir .expendable_orca\dos_logs 2>nul
mkdir .expendable_orca\agents 2>nul
mkdir .expendable_orca\c2_logs 2>nul
mkdir .expendable_orca\modules 2>nul
mkdir .expendable_orca\network_monitor 2>nul
mkdir .expendable_orca\keylog_exfil 2>nul
mkdir .expendable_orca\deployments 2>nul
mkdir .expendable_orca\domain_hosting 2>nul
mkdir expendable_orca_reports 2>nul
mkdir expendable_orca_reports\graphics 2>nul

:: Create default config
echo [*] Creating default configuration...
if not exist .expendable_orca\config.json (
    echo { > .expendable_orca\config.json
    echo     "version": "4.0.0", >> .expendable_orca\config.json
    echo     "auto_start": false, >> .expendable_orca\config.json
    echo     "auto_block_enabled": false, >> .expendable_orca\config.json
    echo     "web": { >> .expendable_orca\config.json
    echo         "enabled": false, >> .expendable_orca\config.json
    echo         "port": 5000, >> .expendable_orca\config.json
    echo         "host": "0.0.0.0" >> .expendable_orca\config.json
    echo     }, >> .expendable_orca\config.json
    echo     "monitoring": { >> .expendable_orca\config.json
    echo         "enabled": true >> .expendable_orca\config.json
    echo     }, >> .expendable_orca\config.json
    echo     "keylogger": { >> .expendable_orca\config.json
    echo         "enabled": false, >> .expendable_orca\config.json
    echo         "hotkey": "f10" >> .expendable_orca\config.json
    echo     }, >> .expendable_orca\config.json
    echo     "spear_phishing": { >> .expendable_orca\config.json
    echo         "enabled": true, >> .expendable_orca\config.json
    echo         "smtp_port": 587 >> .expendable_orca\config.json
    echo     }, >> .expendable_orca\config.json
    echo     "dos": { >> .expendable_orca\config.json
    echo         "enabled": true, >> .expendable_orca\config.json
    echo         "max_threads": 100 >> .expendable_orca\config.json
    echo     }, >> .expendable_orca\config.json
    echo     "domain_hosting": { >> .expendable_orca\config.json
    echo         "enabled": false >> .expendable_orca\config.json
    echo     } >> .expendable_orca\config.json
    echo } >> .expendable_orca\config.json
)

echo.
echo ✅ Installation complete!
echo.
echo To run EXPENDABLE_ORCA:
echo   python expendable_orca.py
echo.
echo ⚠️ For full functionality, run as Administrator
echo.
pause