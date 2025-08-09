function _ctf_cleanup
    source "$CTF_HOME/functions/_ctf_colors.fish"

    # 0. Load global env if not already loaded
    if test -f ~/Lab/env.fish
        source ~/Lab/env.fish
    else
        ctf_error "No global env.fish found. Are you in a CTF session?"
        return 1
    end

    cd ~
    
    # 1. Backup /etc/hosts to box directory
    if test -d $boxpwd
        sudo cp /etc/hosts $boxpwd/hosts.bak
        sudo chown chsoares:chsoares $boxpwd/hosts.bak
        ctf_info "Backed up /etc/hosts to $boxpwd/hosts.bak"
    else
        ctf_error "Box directory $boxpwd not found."
        return 1
    end

    # 4. Reset /etc/hosts to default (localhost only)
    echo "127.0.0.1   localhost" | sudo tee /etc/hosts > /dev/null
    ctf_info "/etc/hosts reset to default (localhost only)"

    echo ""

    # 2. Move box directory from 0_<box> to <box>
    set -l base_dir ~/Lab/boxes
    set -l new_box_dir $base_dir/$box
    if test -d $boxpwd
        mv $boxpwd $new_box_dir
        ctf_info "Moved $boxpwd to $new_box_dir"
        echo ""
    else
        ctf_error "Box directory $boxpwd not found."
        return 1
    end

    # # 3. Ensure env.fish is named correctly (should already be)
    # if test -f $new_box_dir/env.fish
    #     ctf_info "env.fish is present in $new_box_dir"
    # else
    #     ctf_warn "env.fish not found in $new_box_dir"
    # end



    # 5. Clean up Obsidian integration
    if set -q OBSIDIAN; and test -e $OBSIDIAN/INFOSEC/Writeups/.context
        rm -rf $OBSIDIAN/INFOSEC/Writeups/.context
        ctf_info "Removed Obsidian context: $OBSIDIAN/INFOSEC/Writeups/.context"
        echo ""
    end

    # 6. Unset environment variables from global env.fish
    if test -f ~/Lab/env.fish
        ctf_info "Unsetting environment variables from global env.fish"
        
        # Read env.fish and extract variable names
        set -l env_vars (grep -E '^set -g[x]? ' ~/Lab/env.fish | sed -E 's/^set -g[x]? ([A-Za-z_][A-Za-z0-9_]*).*/\1/')
        
        # Unset each variable
        for var in $env_vars
            if set -q $var
                set -e $var
                ctf_info "Unset variable: $var"
            end
        end
        
        # Remove global env file
        rm ~/Lab/env.fish
        ctf_info "Removed global env.fish"
        echo ""
    end

    

    # 7. Sync time with public NTP
    ctf_info "Syncing time with pool.ntp.org"
    sudo ntpdate pool.ntp.org
    sudo systemctl start --now systemd-timesyncd

    echo ""
    ctf_success "Cleanup complete!"
end