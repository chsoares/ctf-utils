#!/usr/bin/env fish

# 󰆧 ctf.fish Binbag Script
# This script downloads curated CTF/pentest binaries

set -l script_dir (dirname (realpath (status --current-filename)))

# Source color functions
source "$script_dir/functions/_ctf_colors.fish"

# Check if CTF_LAB is set
if not set -q CTF_LAB; or test -z "$CTF_LAB"
    ctf_error "CTF_LAB environment variable not set or empty. Please run the installation script first."
    ctf_info "You can also set it manually: set -Ux CTF_LAB /path/to/your/lab"
    exit 1
end

# Set binbag directory
set -lx BINBAG_DIR "$CTF_LAB/binbag2"

ctf_banner
ctf_title "ctf.fish curated binbag collection"
ctf_info "Using CTF_LAB: $CTF_LAB"
echo ""

# Check for required tools
set -l required_tools wget tar unzip
for tool in $required_tools
    if not command -v $tool >/dev/null 2>&1
        ctf_error "$tool is required but not installed. Aborting."
        exit 1
    end
end

# Create binbag directory if it doesn't exist
if not test -d "$BINBAG_DIR"
    ctf_info "Creating $BINBAG_DIR"
    mkdir -p "$BINBAG_DIR"
end

# Download function
function download_tool
    set -l url "$argv[1]"
    set -l outfile "$argv[2]"
    set -l tool_name (basename "$outfile")
    
    gum spin --spinner minidot --title " downloading $tool_name..." --spinner.foreground 6 --title.foreground 4 -- wget -q -O "$BINBAG_DIR/$outfile" "$url"
    set -l download_status $status
    if test $download_status -eq 0
        chmod +x "$BINBAG_DIR/$outfile" 2>/dev/null || true
        ctf_success "$tool_name"
    else
        ctf_error "Failed to download $tool_name"
    end
end

# Hardlink function
function create_hardlink
    set -l src "$argv[1]"
    set -l dest "$argv[2]"
    set -l tool_name (basename "$dest")
    
    if test -f "$src"
        ln -f "$src" "$BINBAG_DIR/$dest"
        ctf_success "$tool_name (hardlinked)"
    else
        ctf_error "Source not found: $src"
    end
end

ctf_header "Downloading Ligolo agents..."

# Ligolo (Linux)
set -l LIGOLO_LINUX_URL "https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_linux_amd64.tar.gz"
set -l LIGOLO_LINUX_TAR "$BINBAG_DIR/ligolo-ng_agent_linux.tar.gz"

gum spin --spinner minidot --title " downloading ligolo agent (linux)..." --spinner.foreground 6 --title.foreground 4 -- wget -q -O "$LIGOLO_LINUX_TAR" "$LIGOLO_LINUX_URL"
if test $status -eq 0
    tar -xzf "$LIGOLO_LINUX_TAR" -C "$BINBAG_DIR" >/dev/null 2>&1
    mv -f "$BINBAG_DIR/agent" "$BINBAG_DIR/ligolo-agent"
    rm "$LIGOLO_LINUX_TAR"
    chmod +x "$BINBAG_DIR/ligolo-agent"
    ctf_success "ligolo-agent (linux)"
else
    ctf_error "Failed to download ligolo agent (linux)"
end

# Ligolo (Windows)
set -l LIGOLO_WIN_URL "https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.2/ligolo-ng_agent_0.8.2_windows_amd64.zip"
set -l LIGOLO_WIN_ZIP "$BINBAG_DIR/ligolo-ng_agent_windows.zip"

gum spin --spinner minidot --title " downloading ligolo agent (windows)..." --spinner.foreground 6 --title.foreground 4 -- wget -q -O "$LIGOLO_WIN_ZIP" "$LIGOLO_WIN_URL"
if test $status -eq 0
    unzip -o -d "$BINBAG_DIR" "$LIGOLO_WIN_ZIP" >/dev/null 2>&1
    mv -f "$BINBAG_DIR/agent.exe" "$BINBAG_DIR/ligolo-agent.exe"
    rm "$LIGOLO_WIN_ZIP" "$BINBAG_DIR/LICENSE" "$BINBAG_DIR/README.md" 2>/dev/null
    ctf_success "ligolo-agent (windows)"
else
    ctf_error "Failed to download ligolo agent (windows)"
end

ctf_header "Downloading Linux privesc tools..."

# Linux privesc
download_tool "https://github.com/peass-ng/PEASS-ng/releases/download/20250701-bdcab634/linpeas.sh" "linpeas.sh"
download_tool "https://github.com/chsoares/linux-smart-enumeration/raw/refs/heads/master/lse.sh" "lse.sh"
download_tool "https://github.com/stealthcopter/deepce/raw/refs/heads/main/deepce.sh" "deepce.sh"
download_tool "https://github.com/liamg/traitor/releases/download/v0.0.14/traitor-amd64" "traitor"
download_tool "https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64" "pspy"

ctf_header "Downloading Windows privesc tools..."

# Windows privesc
download_tool "https://github.com/PowerShellMafia/PowerSploit/raw/refs/heads/master/Privesc/PowerUp.ps1" "powerup.ps1"
download_tool "https://github.com/PowerShellMafia/PowerSploit/raw/refs/heads/master/Recon/PowerView.ps1" "powerview.ps1"
download_tool "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Seatbelt.exe" "seatbelt.exe"
download_tool "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Rubeus.exe" "rubeus.exe"
download_tool "https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/SharpUp.exe" "sharpup.exe"
download_tool "https://github.com/ParrotSec/mimikatz/raw/refs/heads/master/x64/mimikatz.exe" "mimikatz.exe"
download_tool "https://github.com/peass-ng/PEASS-ng/releases/download/20250701-bdcab634/winPEASany.exe" "winpeas.exe"
download_tool "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe" "lazagne.exe"

# RunasCs (Windows)
set -l RUNASCS_URL "https://github.com/antonioCoco/RunasCs/releases/download/v1.5/RunasCs.zip"
set -l RUNASCS_ZIP "$BINBAG_DIR/RunasCs.zip"

gum spin --spinner minidot --title " downloading runascs..." --spinner.foreground 6 --title.foreground 4 -- wget -q -O "$RUNASCS_ZIP" "$RUNASCS_URL"
if test $status -eq 0
    unzip -o -d "$BINBAG_DIR" "$RUNASCS_ZIP" >/dev/null 2>&1
    mv -f "$BINBAG_DIR/RunasCs.exe" "$BINBAG_DIR/runas.exe"
    rm "$RUNASCS_ZIP" 2>/dev/null
    ctf_success "runas.exe"
else
    ctf_error "Failed to download runascs"
end

# Inveigh (Windows)
set -l INVEIGH_URL "https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.11/Inveigh-net4.6.2-v2.0.11.zip"
set -l INVEIGH_ZIP "$BINBAG_DIR/Inveigh.zip"

gum spin --spinner minidot --title " downloading inveigh..." --spinner.foreground 6 --title.foreground 4 -- wget -q -O "$INVEIGH_ZIP" "$INVEIGH_URL"
if test $status -eq 0
    unzip -o -d "$BINBAG_DIR" "$INVEIGH_ZIP" >/dev/null 2>&1
    mv -f "$BINBAG_DIR/Inveigh.exe" "$BINBAG_DIR/inveigh.exe"
    rm "$INVEIGH_ZIP" 2>/dev/null
    ctf_success "inveigh.exe"
else
    ctf_error "Failed to download inveigh"
end

ctf_header "Downloading Potato exploits..."

# Potato
download_tool "https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe" "printspoofer.exe"
download_tool "https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe" "juicypotato.exe"
download_tool "https://github.com/BeichenDream/GodPotato/releases/download/V1.20/GodPotato-NET4.exe" "godpotato.exe"

ctf_header "Downloading additional tools..."

# Etc
download_tool "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc.exe" "nc.exe"
download_tool "https://github.com/int0x33/nc.exe/raw/refs/heads/master/nc64.exe" "nc64.exe"

# Hardlink from EZPZ if available
if set -q EZPZ_HOME
    create_hardlink "$EZPZ_HOME/utils/loot.sh" "loot.sh"
end

echo ""
ctf_title "󰆧 ctf.fish binbag collection completed!"
echo "Binaries are available in: $BINBAG_DIR"
echo "Happy pwning! 😉"