function _ctf_env
    source "$CTF_HOME/functions/_ctf_colors.fish"
    
    # 0. Load global env if not already loaded
    if test -f ~/Lab/env.fish
        source ~/Lab/env.fish
    else
        ctf_error "No global env.fish found. Are you in a CTF session?"
        return 1
    end

    set -l boxenv $boxpwd/env.fish

    if test (count $argv) -eq 0
        if test -f ~/Lab/env.fish
            cat ~/Lab/env.fish
        else
            ctf_warn "No global env.fish found."
        end
        return
    end

    switch $argv[1]
        case set
            if test (count $argv) -ne 3
                ctf_error "Usage: ctfenv set <var> <value>"
                return 1
            end
            set -l var $argv[2]
            set -l value $argv[3]
            set -l line "set -gx $var $value"

            if grep -q "set -gx $var " $boxenv
                # Replace the line
                sed -i "s|set -gx $var .*|$line|" $boxenv
                ctf_info "Updated $var in $boxenv"
            else
                # Add the line
                echo $line >> $boxenv
                ctf_info "Added $var to $boxenv"
            end
            cp $boxenv ~/Lab/env.fish
            source ~/Lab/env.fish
            ctf_info "Updated global env.fish"
        case edit
            if test -f $boxenv
                gnome-text-editor $boxenv
                cp $boxenv ~/Lab/env.fish
                ctf_info "Edited $boxenv and updated global env."
            else
                ctf_error "$boxenv not found."
            end
        case '*'
            ctf_error "Invalid command. Use 'set', 'edit', or no arguments to print current env."
    end
end