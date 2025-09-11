#!/usr/bin/env fish

# CTF Tools Installation Script
# This script installs CTF/pentest tools found in your current setup

set -l script_dir (dirname (realpath (status --current-filename)))

# Source color functions
source "$script_dir/functions/_ctf_colors.fish"
sudo -v > /dev/null

ctf_banner
ctf_title "ctf.fish curated ctf & pentest packages"

# Function to install yay packages
function install_yay_packages
    set -l packages $argv
    
    if test (count $packages) -gt 0
        ctf_header "Installing yay packages..."
        for package in $packages
            _ctf_spin yay -S --needed --noconfirm $package
            if test $status -eq 0
                ctf_success "$package"
            else
                ctf_error "Failed to install $package"
            end
        end
    end
end

# Function to install pipx packages
function install_pipx_packages
    set -l packages $argv
    
    if test (count $packages) -gt 0
        ctf_header "Installing pipx packages..."
        _ctf_spin pipx ensurepath
        for package in $packages
            _ctf_spin pipx install $package
            if test $status -eq 0
                ctf_success "$package"
            else
                ctf_error "Failed to install $package"
            end
        end
    end
end

install_yay_packages \
    bettercap \
    bind \
    ffuf \
    fping \
    gdb \
    gef \
    github-cli \
    gnu-netcat \
    hashcat \
    hydra \
    impacket \
    john \
    kerbrute-bin \
    ligolo \
    metasploit \
    nfs-utils \
    nmap \
    ntp \
    openssh \
    openvpn \
    pre2k-git \
    perl-image-exiftool \
    responder \
    seclists \
    sqlmap \
    targetedkerberoast-git \
    tcpdump \
    ufw \
    whatweb \
    wireshark-qt \
    wpscan \
    wscat \
    python-bloodhound-ce-git \
    python-bs4 \
    python-krb5 \
    python-pipx \
    python-pwntools

install_pipx_packages \
    git+https://github.com/Pennyw0rth/NetExec \
    git+https://github.com/login-securite/DonPAPI.git \
    bloodyad \
    certipy-ad \
    Devious-WinRM \
    evil-winrm-py \
    gpp-decrypt \
    ldapdomaindump \
    mitm6 \
    sqlmap-websocket-proxy

echo ""
ctf_title "󰆧 ctf.fish curated tools installation completed!"
echo ""
echo "All tools have been installed."
echo "You may need to restart your shell for some tools to be available in PATH."