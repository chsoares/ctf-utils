function _ctf_start
    source "$CTF_HOME/functions/_ctf_colors.fish"
    ctf_banner

    # === 2. Git pull repositories ===
    if set -q CTF_HOME; and test -d "$CTF_HOME/.git"
        ctf_header "Updating ctf-utils repository..."
        pushd "$CTF_HOME" > /dev/null
        git pull --quiet
        popd > /dev/null
        ctf_success "ctf-utils updated"
        echo
    end

    if set -q EZPZ_HOME; and test -d "$EZPZ_HOME/.git"
        ctf_header "Updating ezpz repository..."
        pushd "$EZPZ_HOME" > /dev/null
        git pull --quiet
        popd > /dev/null
        ctf_success "ezpz updated"
        echo
    end

    # === 3. Argument validation ===
    if test (count $argv) -ne 2
        ctf_error "Usage: start <boxname> <boxip>"
        return 1
    end

    set -l box $argv[1]
    set -l ip $argv[2]
    set -l base_dir $CTF_LAB/boxes
    set -l box_dir $base_dir/$box
    set -l box_dir_zero $base_dir/0_$box

    # === 4. IP validation ===
    if not string match -rq '^([0-9]{1,3}\.){3}[0-9]{1,3}$' -- $ip
        ctf_error "Invalid IP address: $ip"
        return 1
    end

    ctf_header "Setting up ctf environment..."

    # === 5. If box directory already exists ===
    if test -d $box_dir_zero
        ctf_info "Active box directory already exists: $box_dir_zero"
        cd $box_dir_zero
        
        if test -f env.fish
            ctf_header "Sourcing environment variables from env.fish"
            tee $CTF_LAB/env.fish < env.fish 
            source env.fish
        else
            ctf_warn "env.fish not found in $box_dir_zero"
        end
        
        echo ""
        ctf_header "Syncing time with target box"
        sudo systemctl stop systemd-timesyncd
        sudo ntpdate $ip
        echo ""
        
        ctf_success "Box '$box' environment restored! Happy hacking 😉"
        return 0
    else if test -d $box_dir
        ctf_info "Box directory already exists: $box_dir"
        cd $box_dir

        if test -f env.fish
            ctf_header "Sourcing environment variables from env.fish"
            tee $CTF_LAB/env.fish < env.fish 
            source env.fish
        else
            ctf_warn "env.fish not found in $box_dir"
        end

        if test -f hosts.bak
            ctf_header "Restoring /etc/hosts from hosts.bak"
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

        echo ""
        ctf_header "Syncing time with target box"
        sudo systemctl stop systemd-timesyncd
        sudo ntpdate $ip
        echo ""

        ctf_success "Box '$box' environment restored! Happy hacking 😉"
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

    # Sync time
    echo ""
    ctf_header "Syncing time with target box"
    sudo systemctl stop systemd-timesyncd
    sudo ntpdate $ip
    echo ""

    ctf_success "Box environment created! Happy hacking 😉"
    source $CTF_LAB/env.fish
end