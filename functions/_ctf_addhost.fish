function _ctf_addhost
    source "$CTF_HOME/functions/_ctf_colors.fish"

    # === 1. Argument validation ===
    # Argument validation
    if test (count $argv) -lt 2
        ctf_error "Usage: addhost <ip> <hostname> [hostname2] [hostname3] ..."
        return 1
    end

    set -l ip $argv[1]
    set -l hosts $argv[2..]

    # IP validation (simple)
    if not string match -rq '^([0-9]{1,3}\.){3}[0-9]{1,3}$' -- $ip
        ctf_error "Invalid IP address: $ip"
        return 1
    end

    # Hostname validation for all hosts
    for host in $hosts
        if not string match -rq '^[a-zA-Z0-9.-]+$' -- $host
            ctf_error "Invalid hostname: $host"
            return 1
        end
    end

    # Join all hostnames into a single string
    set -l hosts_string (string join ' ' $hosts)

    # Add or append hostnames to /etc/hosts
    if grep -q "^$ip" /etc/hosts
        sudo sed -i "/^$ip/s/\$/ $hosts_string/" /etc/hosts
        ctf_info "Appended \"$hosts_string\" to existing entry for \"$ip\" in /etc/hosts"
    else
        echo "$ip    $hosts_string" | sudo tee -a /etc/hosts > /dev/null
        ctf_info "Added new entry \"$ip $hosts_string\" to /etc/hosts"
    end

    # Show the resulting line(s)
    grep "^$ip" /etc/hosts --color=never
end