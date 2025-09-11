#!/bin/bash

set -e

BINBAG_DIR="./binbag"

# Check for required tools
for tool in wget tar unzip; do
    if ! command -v $tool &>/dev/null; then
        echo "[!] $tool is required but not installed. Aborting."
        exit 1
    fi
done

# Create binbag directory if it doesn't exist
if [ ! -d "$BINBAG_DIR" ]; then
    echo "[*] Creating $BINBAG_DIR"
    mkdir "$BINBAG_DIR"
else
    echo "[*] $BINBAG_DIR already exists"
fi

# Download function
download() {
    url="$1"
    outfile="$2"
    echo "[*] Downloading $outfile"
    wget -q --show-progress -O "$BINBAG_DIR/$outfile" "$url"
    chmod +x "$BINBAG_DIR/$outfile" 2>/dev/null || true
}

# Hardlink function
hardlink() {
    src="$1"
    dest="$2"
    if [ -f "$src" ]; then
        ln -f "$src" "$BINBAG_DIR/$dest"
        echo "[*] Hardlink created: $dest"
    else
        echo "[!] Source not found: $src"
    fi
}

# Ligolo (Linux)
LIGOLO_LINUX_URL="https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_linux_amd64.tar.gz"
LIGOLO_LINUX_TAR="$BINBAG_DIR/ligolo-ng_agent_linux.tar.gz"
echo "[*] Downloading Ligolo agent (Linux)"
wget -q --show-progress -O "$LIGOLO_LINUX_TAR" "$LIGOLO_LINUX_URL"
tar -xzf "$LIGOLO_LINUX_TAR" -C "$BINBAG_DIR"
mv -f "$BINBAG_DIR/agent" "$BINBAG_DIR/ligolo-agent"
rm "$LIGOLO_LINUX_TAR"
chmod +x "$BINBAG_DIR/ligolo-agent"

# Ligolo (Windows)
LIGOLO_WIN_URL="https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip"
LIGOLO_WIN_ZIP="$BINBAG_DIR/ligolo-ng_agent_windows.zip"
echo "[*] Downloading Ligolo agent (Windows)"
wget -q --show-progress -O "$LIGOLO_WIN_ZIP" "$LIGOLO_WIN_URL"
unzip -o -d "$BINBAG_DIR" "$LIGOLO_WIN_ZIP"
mv -f "$BINBAG_DIR/agent.exe" "$BINBAG_DIR/ligolo-agent.exe"
rm "$LIGOLO_WIN_ZIP"

# Linux privesc
download "https://github.com/peass-ng/PEASS-ng/releases/download/20250701-bdcab634/linpeas.sh" "linpeas.sh"
download "https://github.com/chsoares/linux-smart-enumeration/raw/refs/heads/master/lse.sh" "lse.sh"
download "https://github.com/stealthcopter/deepce/raw/refs/heads/main/deepce.sh" "deepce.sh"

# Windows privesc
download "https://github.com/PowerShellMafia/PowerSploit/raw/refs/heads/master/Privesc/PowerUp.ps1" "powerup.ps1"
download "https://github.com/PowerShellMafia/PowerSploit/raw/refs/heads/master/Recon/PowerView.ps1" "powerview.ps1"
download "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Seatbelt.exe" "seatbelt.exe"
download "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Rubeus.exe" "rubeus.exe"
download "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/SharpUp.exe" "sharpup.exe"
download "https://github.com/ParrotSec/mimikatz/raw/refs/heads/master/x64/mimikatz.exe" "mimikatz.exe"
download "https://github.com/peass-ng/PEASS-ng/releases/download/20250701-bdcab634/winPEASany.exe" "winpeas.exe"

# Potato
download "https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe" "printspoofer.exe"
download "https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe" "juicypotato.exe"
download "https://github.com/BeichenDream/GodPotato/releases/download/V1.20/GodPotato-NET4.exe" "godpotato.exe"

# Etc
download "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc.exe" "nc.exe"
download "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc64.exe" "nc64.exe"
hardlink "$EZPZ_HOME/utils/loot.sh" "loot.sh"

echo "[*] Binbag is ready! Happy pwning :)"
