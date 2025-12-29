#!/bin/bash
# =========================================================
# BugiScann - Automated Installer Script
# Author : Anex | Hacker No Rule
# Tested : Kali Linux / Debian
# =========================================================

set -e

echo "==========================================="
echo " 🛠 BugiScann Toolchain Installer"
echo "==========================================="

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run as root (sudo ./install.sh)"
  exit 1
fi

echo "[+] Updating system..."
apt update -y

echo "[+] Installing system dependencies..."
apt install -y \
  git \
  python3 \
  python3-pip \
  golang \
  snapd

echo "[+] Installing Subdomain Enumeration tools..."
apt install -y subfinder assetfinder amass

echo "[+] Installing HTTP probing tool..."
apt install -y httpx-toolkit

echo "[+] Installing SQLMap..."
apt install -y sqlmap

echo "[+] Installing Arjun..."
apt install -y arjun

echo "[+] Installing Nuclei..."
apt install -y nuclei
nuclei -update-templates

echo "[+] Installing S3Scanner..."
apt install -y s3scanner

# Go environment
echo "[+] Setting up Go environment..."
export PATH=$PATH:/root/go/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> /root/.bashrc

echo "[+] Installing Go-based tools..."

sudo -u root go install github.com/tomnomnom/waybackurls@latest
sudo -u root go install github.com/projectdiscovery/katana/cmd/katana@latest
sudo -u root go install github.com/hahwul/dalfox/v2@latest

echo "[+] Installing ParamSpider..."
if [ ! -d "/opt/paramspider" ]; then
  git clone https://github.com/devanshbatham/paramspider /opt/paramspider
  cd /opt/paramspider
  pip3 install .
else
  echo "[*] ParamSpider already installed"
fi

echo ""
echo "==========================================="
echo " ✅ Installation Completed Successfully"
echo "==========================================="

echo "[+] Verifying tools..."
tools=(
  subfinder
  assetfinder
  amass
  httpx
  waybackurls
  katana
  paramspider
  arjun
  nuclei
  dalfox
  sqlmap
  s3scanner
)

for tool in "${tools[@]}"; do
  if command -v $tool >/dev/null 2>&1; then
    echo "[✓] $tool installed"
  else
    echo "[✗] $tool NOT found"
  fi
done

echo ""
echo "🚀 BugiScann setup is ready!"
