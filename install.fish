#!/usr/bin/env fish

# 󰆧 ctf.fish Installation Script
# This script sets up the CTF utilities environment for Fish shell

set -l script_dir (dirname (realpath (status --current-filename)))

# Source color functions
source "$script_dir/functions/_ctf_colors.fish"

# Check for required dependencies
if not command -v gum >/dev/null 2>&1; or not command -v ntpdate >/dev/null 2>&1
    if command -v pacman >/dev/null 2>&1
        ctf_header "Installing required dependencies (gum, ntp)..."
        sudo pacman -S --needed gum ntp
        if test $status -eq 0
            ctf_success "Dependencies installed successfully"
            ctf_header "Please run the installation script again"
            exit 0
        else
            ctf_error "Failed to install dependencies"
            exit 1
        end
    else
        ctf_warn "This installation script is designed for Arch Linux. For other distributions, please install the 'gum' and 'ntp' packages manually before running this script."
        exit 1
    end
end

ctf_banner

# Set CTF_HOME to current directory
ctf_header "Setting CTF_HOME environment variable..."
set -Ux CTF_HOME "$script_dir"
ctf_success "CTF_HOME set to: $CTF_HOME"

# Add functions directory to fish_function_path
ctf_header "Adding functions to Fish function path..."
if not contains "$CTF_HOME/functions" $fish_function_path
    set -U fish_function_path "$CTF_HOME/functions" $fish_function_path
    ctf_success "Functions directory added to fish_function_path"
else
    ctf_success "Functions directory already in fish_function_path"
end

# Add completions directory to fish_complete_path
ctf_header "Adding completions to Fish completion path..."
if not contains "$CTF_HOME/completions" $fish_complete_path
    set -U fish_complete_path "$CTF_HOME/completions" $fish_complete_path
    ctf_success "Completions directory added to fish_complete_path"
else
    ctf_success "Completions directory already in fish_complete_path"
end

# Check and add aliases.fish sourcing to Fish config
set -l fish_config "$HOME/.config/fish/config.fish"
set -l fish_aliases "$HOME/.config/fish/aliases.fish"

ctf_header "Checking Fish config for aliases integration..."

# Create config directory if it doesn't exist
if not test -d (dirname "$fish_config")
    mkdir -p (dirname "$fish_config")
    ctf_success "Created Fish config directory"
end

# Create config file if it doesn't exist
if not test -f "$fish_config"
    touch "$fish_config"
    ctf_success "Created Fish config file"
end

# Check if aliases sourcing already exists in config.fish
if not grep -q "source ~/.config/fish/aliases.fish" "$fish_config"
    echo "" >> "$fish_config"
    echo "# Source aliases" >> "$fish_config"
    echo "source ~/.config/fish/aliases.fish" >> "$fish_config"
end

# Create or update aliases.fish
if not test -f "$fish_aliases"
    touch "$fish_aliases"
    ctf_success "Created Fish aliases file"
end

# Check if CTF aliases sourcing already exists in aliases.fish
if grep -q "CTF_HOME/misc/aliases.fish" "$fish_aliases"
    ctf_success "CTF aliases integration already exists"
else
    echo "" >> "$fish_aliases"
    echo "# CTF Utils aliases integration" >> "$fish_aliases"
    echo "if test -n \$CTF_HOME" >> "$fish_aliases"
    echo "    source \$CTF_HOME/misc/aliases.fish 2>/dev/null" >> "$fish_aliases"
    echo "end" >> "$fish_aliases"
    ctf_success "Added CTF aliases integration"
end

echo ""
ctf_header "Setting CTF_LAB environment variable..."
ctf_question "Choose CTF Lab directory:"
set -Ux CTF_LAB (ctf_input "$HOME/Lab")
echo $CTF_LAB

# Create CTF_LAB directory and subdirectories if they don't exist
if not test -d "$CTF_LAB"
    mkdir -p "$CTF_LAB"
    ctf_success "Created CTF Lab directory: $CTF_LAB"
end

# Create subdirectories
for subdir in boxes ovpn binbag
    if not test -d "$CTF_LAB/$subdir"
        mkdir -p "$CTF_LAB/$subdir"
        ctf_success "Created subdirectory: $CTF_LAB/$subdir"
    end
end

ctf_success "CTF_LAB set to: $CTF_LAB"
echo ""

ctf_title "󰆧 ctf.fish installation completed!"
echo 
echo "Please restart your Fish shell or run:"
ctf_cmd "source ~/.config/fish/config.fish"
echo
echo "Then you can use the 'ctf' command to get started."
echo "You can also run 'tools.fish' to install a selection of curated pentest and CTF packages."