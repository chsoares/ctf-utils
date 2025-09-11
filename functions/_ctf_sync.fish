function _ctf_sync
    source "$CTF_HOME/functions/_ctf_colors.fish"
    
    if test (count $argv) -eq 0
        ctf_error "Usage: ctf sync <ip> | ctf sync --off"
        echo ""
        echo "  ctf sync <ip>    - Sync time with target box"
        echo "  ctf sync --off   - Unsync and use public NTP"
        return 1
    end
    
    set -l target $argv[1]
    
    if test "$target" = "--off"
        ctf_header "Syncing time with pool.ntp.org"
        sudo systemctl start systemd-timesyncd
        sudo ntpdate pool.ntp.org
        ctf_success "Time synced with public NTP"
    else
        ctf_header "Syncing time with target box ($target)"
        sudo systemctl stop systemd-timesyncd
        sudo ntpdate $target
        ctf_success "Time synced with $target"
    end
end