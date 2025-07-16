function ctf_addhost
    source "$CTF_HOME/functions/ctf_colors.fish"

    # === 1. Argument validation ===
    # Argument validation
    if test (count $argv) -ne 2
        ctf_error "Usage: addhost <ip> <hostname>"
        return 1
    end

    set -l ip $argv[1]
    set -l host $argv[2]

    # IP validation (simple)
    if not string match -rq '^([0-9]{1,3}\.){3}[0-9]{1,3}$' -- $ip
        ctf_error "Invalid IP address: $ip"
        return 1
    end

    # Hostname validation (simple)
    if not string match -rq '^[a-zA-Z0-9.-]+$' -- $host
        ctf_error "Invalid hostname: $host"
        return 1
    end

    # Add or append hostname to /etc/hosts
    if grep -q "^$ip" /etc/hosts
        sudo sed -i "/^$ip/s/\$/ $host/" /etc/hosts
        ctf_info "Appended \"$host\" to existing entry for \"$ip\" in /etc/hosts"
    else
        echo "$ip    $host" | sudo tee -a /etc/hosts > /dev/null
        ctf_info "Added new entry \"$ip $host\" to /etc/hosts"
    end

    # Show the resulting line(s)
    grep "^$ip" /etc/hosts --color=never
end