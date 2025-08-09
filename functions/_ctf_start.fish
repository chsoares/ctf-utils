function _ctf_start
    source "$CTF_HOME/functions/_ctf_colors.fish"

    # === 1. Dependency check ===
    set -l dependencies ntpd gnome-text-editor
    for dep in $dependencies
        if not type -q $dep
            ctf_error "Dependency '$dep' not found in PATH."
            return 1
        end
    end

    # === 2. Git pull repositories ===
    if set -q CTF_HOME; and test -d "$CTF_HOME/.git"
        ctf_info "Updating CTF repository..."
        pushd "$CTF_HOME" > /dev/null
        git pull --quiet
        popd > /dev/null
        ctf_success "CTF updated"
    end

    if set -q EZPZ_HOME; and test -d "$EZPZ_HOME/.git"
        ctf_info "Updating EZPZ repository..."
        pushd "$EZPZ_HOME" > /dev/null
        git pull --quiet
        popd > /dev/null
        ctf_success "EZPZ updated"
    end

    # === 3. Argument validation ===
    if test (count $argv) -ne 2
        ctf_error "Usage: start <boxname> <boxip>"
        return 1
    end

    set -l box $argv[1]
    set -l ip $argv[2]
    set -l base_dir ~/Lab/boxes
    set -l box_dir $base_dir/$box
    set -l box_dir_zero $base_dir/0_$box

    # === 4. IP validation ===
    if not string match -rq '^([0-9]{1,3}\.){3}[0-9]{1,3}$' -- $ip
        ctf_error "Invalid IP address: $ip"
        return 1
    end

    # === 5. If box directory already exists ===
    if test -d $box_dir
        ctf_info "Box directory already exists: $box_dir"
        cd $box_dir

        if test -f env.fish
            ctf_info "Sourcing environment variables from env.fish"
            cp env.fish ~/Lab/env.fish
            source env.fish
        else
            ctf_warn "env.fish not found in $box_dir"
        end

        if test -f hosts.bak
            ctf_info "Restoring /etc/hosts from hosts.bak"
            sudo tee /etc/hosts < hosts.bak
        else
            ctf_warn "hosts.bak not found in $box_dir"
        end

        # Move to 0_$box if not already there
        if not test -d $box_dir_zero
            mv $box_dir $box_dir_zero
            ctf_info "Moved $box_dir to $box_dir_zero"
            cd $box_dir_zero
        else
            cd $box_dir_zero
        end

        if set -q OBSIDIAN      
        # Create hardlink for context
        ln $boxpwd $OBSIDIAN/INFOSEC/Writeups/.context
        ctf_info "Created hardlink: $OBSIDIAN/INFOSEC/Writeups/.context -> $boxpwd"
    else
        ctf_warn "OBSIDIAN environment variable not set. Skipping Obsidian integration."
    end

        ctf_header "Box '$box' environment restored!"
        return 0
    end

    # === 6. If box directory does NOT exist ===
    set -l arch_ip (ip a | grep tun0 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -n1)
    set -l url "http://$box.htb"
    set -l boxpwd $box_dir_zero

    mkdir -p $boxpwd
    cd $boxpwd
    mkdir screenshots

    # Generate env.fish
    echo "set -gx arch $arch_ip" > env.fish
    echo "set -gx box $box" >> env.fish
    echo "set -gx ip $ip" >> env.fish
    echo "set -gx url $url" >> env.fish
    echo "set -gx boxpwd $boxpwd" >> env.fish

    # Export variables to session
    cp env.fish ~/Lab/env.fish

    ctf_info "Created directory at $boxpwd"
    echo ""
    ctf_info "\$arch is set to $arch"
    ctf_info "\$ip is set to $ip"
    ctf_info "\$box is set to $box"
    ctf_info "\$url is set to $url"
    echo ""

    # Add to /etc/hosts
    if grep -q "^$ip" /etc/hosts
        sudo sed -i "/^$ip/s/\$/ $box.htb/" /etc/hosts
        ctf_info "Appended $box.htb to existing entry for $ip in /etc/hosts"
    else
        echo "$ip    $box.htb" | sudo tee -a /etc/hosts > /dev/null
        ctf_info "Added new entry $ip $box.htb to /etc/hosts"
    end
    grep "^$ip" /etc/hosts --color=never

    # Obsidian integration
    if set -q OBSIDIAN
        echo ""
        ctf_info "Setting up Obsidian integration"
        
        # Create markdown file in box directory
        touch $boxpwd/$box.md
        
        # Create hardlink in Obsidian Writeups directory
        mkdir -p $OBSIDIAN/INFOSEC/Writeups
        ln $boxpwd/$box.md $OBSIDIAN/INFOSEC/Writeups/$box.md
        ctf_info "Created hardlink: $OBSIDIAN/INFOSEC/Writeups/$box.md"
        
        # Create hardlink for context
        ln $boxpwd $OBSIDIAN/INFOSEC/Writeups/.context
        ctf_info "Created hardlink: $OBSIDIAN/INFOSEC/Writeups/.context -> $boxpwd"
    else
        ctf_warn "OBSIDIAN environment variable not set. Skipping Obsidian integration."
    end

    # Sync time
    echo ""
    ctf_info "Syncing time with target box"
    sudo systemctl stop systemd-timesyncd
    sudo ntpdate $ip
    echo ""

    ctf_success "Happy hacking! 😉"
    source ~/Lab/env.fish
end