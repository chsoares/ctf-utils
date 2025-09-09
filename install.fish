#!/usr/bin/env fish

# CTF Utils Installation Script
# This script sets up the CTF utilities environment for Fish shell

set -l script_dir (dirname (realpath (status --current-filename)))

# Source color functions
source "$script_dir/functions/_ctf_colors.fish"

ctf_title "Installing CTF Utils..."

# Set CTF_HOME to current directory
ctf_info "Setting CTF_HOME environment variable..."
set -Ux CTF_HOME "$script_dir"
ctf_success "CTF_HOME set to: $CTF_HOME"

# Add functions directory to fish_function_path
ctf_info "Adding functions to Fish function path..."
if not contains "$CTF_HOME/functions" $fish_function_path
    set -U fish_function_path "$CTF_HOME/functions" $fish_function_path
    ctf_success "Functions directory added to fish_function_path"
else
    ctf_success "Functions directory already in fish_function_path"
end

# Add completions directory to fish_complete_path
ctf_info "Adding completions to Fish completion path..."
if not contains "$CTF_HOME/completions" $fish_complete_path
    set -U fish_complete_path "$CTF_HOME/completions" $fish_complete_path
    ctf_success "Completions directory added to fish_complete_path"
else
    ctf_success "Completions directory already in fish_complete_path"
end

# Check and add aliases.fish sourcing to Fish config
set -l fish_config "$HOME/.config/fish/config.fish"
set -l aliases_source_line "if test -f \$CTF_HOME/misc/aliases.fish\n    source \$CTF_HOME/misc/aliases.fish\nend"

ctf_info "Checking Fish config for aliases integration..."

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

# Check if aliases sourcing already exists
if grep -q "CTF_HOME/misc/aliases.fish" "$fish_config"
    ctf_success "Aliases integration already exists in Fish config"
else
    echo "" >> "$fish_config"
    echo "# CTF Utils aliases integration" >> "$fish_config"
    printf "%s\n" "$aliases_source_line" >> "$fish_config"
    ctf_success "Added aliases integration to Fish config"
end

echo ""
ctf_title "CTF Utils installation completed!"
echo ""
ctf_info "Please restart your Fish shell or run:"
ctf_cmd "source ~/.config/fish/config.fish"
echo ""
ctf_info "Then you can use the 'ctf' command to get started."