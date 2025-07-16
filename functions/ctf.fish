
function ctf
    source "$CTF_HOME/functions/_ctf_colors.fish"
    set -l commands start cleanup addhost env

    if test (count $argv) -eq 0
        ctf_show_menu
        return 0
    end

    set -l subcmd $argv[1]
    set -e argv[1]

    if contains -- $subcmd $commands
        switch $subcmd
            case start
                _ctf_start $argv
            case cleanup
                _ctf_cleanup $argv
            case addhost
                _ctf_addhost $argv
            case env
                _ctf_env $argv
        end
        return $status
    else
        ctf_error "Unknown command: $subcmd"
        ctf_show_menu
        return 1
    end
end

function ctf_show_menu
    ctf_title "ctf.fish - ctf environment helper 🍥"
    echo ""
    echo "Available commands:"
    echo "  start <boxname> <ip>   - Start a new CTF box environment"
    echo "  cleanup                - Cleanup and reset environment"
    echo "  addhost <ip> <host>    - Add or update /etc/hosts entry"
    echo "  env [set|edit] ...     - Manage box environment variables"
    echo ""
    ctf_info "Usage: ctf <command> [options]"
end