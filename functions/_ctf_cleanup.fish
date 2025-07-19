function _ctf_cleanup
    source "$CTF_HOME/functions/_ctf_colors.fish"

    # 0. Load global env if not already loaded
    if test -f ~/Lab/env.fish
        source ~/Lab/env.fish
    else
        ctf_error "No global env.fish found. Are you in a CTF session?"
        return 1
    end

    # 1. Backup /etc/hosts to box directory
    if test -d $boxpwd
        sudo cp /etc/hosts $boxpwd/hosts.bak
        ctf_info "Backed up /etc/hosts to $boxpwd/hosts.bak"
    else
        ctf_error "Box directory $boxpwd not found."
        return 1
    end

    # 2. Move box directory from 0_<box> to <box>
    set -l base_dir ~/Lab/labs
    set -l new_box_dir $base_dir/$box
    if test -d $boxpwd
        mv $boxpwd $new_box_dir
        ctf_info "Moved $boxpwd to $new_box_dir"
    else
        ctf_error "Box directory $boxpwd not found."
        return 1
    end

    # 3. Ensure env.fish is named correctly (should already be)
    if test -f $new_box_dir/env.fish
        ctf_info "env.fish is present in $new_box_dir"
    else
        ctf_warn "env.fish not found in $new_box_dir"
    end

    # 4. Reset /etc/hosts to default (localhost only)
    echo "127.0.0.1   localhost" | sudo tee /etc/hosts > /dev/null
    ctf_info "/etc/hosts reset to default (localhost only)"

    # 5. Remove global env file
    if test -f ~/Lab/env.fish
        rm ~/Lab/env.fish
        ctf_info "Removed global env.fish"
    end

    # 6. Sync time with public NTP
    ctf_info "Syncing time with pool.ntp.org"
    sudo ntpdate pool.ntp.org

    ctf_success "Cleanup complete!"
end