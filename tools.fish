#!/usr/bin/env fish

# CTF Tools Installation Script
# This script installs CTF/pentest tools found in your current setup

set -l script_dir (dirname (realpath (status --current-filename)))

# Source color functions
source "$script_dir/functions/_ctf_colors.fish"

ctf_title "Installing CTF/Pentest Tools..."

# Function to install yay packages
function install_yay_packages
    set -l packages $argv
    
    if test (count $packages) -gt 0
        ctf_info "Installing yay packages..."
        for package in $packages
            ctf_cmd "yay -S --needed --noconfirm $package"
            yay -S --needed --noconfirm $package
            if test $status -eq 0
                ctf_success "✓ $package"
            else
                ctf_error "✗ Failed to install $package"
            end
        end
    end
end

# Function to install pipx packages
function install_pipx_packages
    set -l packages $argv
    
    if test (count $packages) -gt 0
        ctf_info "Installing pipx packages..."
        for package in $packages
            ctf_cmd "pipx install $package"
            pipx install $package
            if test $status -eq 0
                ctf_success "✓ $package"
            else
                ctf_error "✗ Failed to install $package"
            end
        end
    end
end

# CTF/Pentest tools from yay -Qe
ctf_header "Network & Web Tools via yay"
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
    ruby-evil-winrm \
    seclists \
    sqlmap \
    targetedkerberoast-git \
    tcpdump \
    ufw \
    whatweb \
    wireshark-qt \
    wpa_supplicant \
    wpscan \
    wscat \
    python-bloodhound-ce-git \
    python-bs4 \
    python-krb5 \
    python-pipx \
    python-pwntools

# CTF/Pentest tools from pipx list
ctf_header "Python Tools via pipx"
install_pipx_packages \
    bloodyad \
    certipy-ad \
    Devious-WinRM \
    donpapi \
    evil-winrm-py \
    gpp-decrypt \
    ldapdomaindump \
    mitm6 \
    netexec \
    sqlmap-websocket-proxy

echo ""
ctf_title "CTF Tools installation completed!"
echo ""
ctf_info "All CTF/pentest tools have been installed."
ctf_info "You may need to restart your shell for some tools to be available in PATH."