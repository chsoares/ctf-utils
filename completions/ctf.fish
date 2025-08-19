# Main subcommands
complete -c ctf -f -n '__fish_use_subcommand' -a "start"    -d "Start a new CTF box environment"
complete -c ctf -f -n '__fish_use_subcommand' -a "cleanup"  -d "Cleanup and reset environment"
complete -c ctf -f -n '__fish_use_subcommand' -a "addhost"  -d "Add or update /etc/hosts entry"
complete -c ctf -f -n '__fish_use_subcommand' -a "env"      -d "Manage box environment variables"
complete -c ctf -f -n '__fish_use_subcommand' -a "creds"    -d "Add credentials to creds.txt"

# ctf env subcommands
complete -c ctf -n '__fish_seen_subcommand_from env' -f -a "set"  -d "Set or update a variable"
complete -c ctf -n '__fish_seen_subcommand_from env' -f -a "edit" -d "Edit the box environment file"

# ctf addhost arguments (no < >)
complete -c ctf -n '__fish_seen_subcommand_from addhost' -f -a "IP"      -d "Target IP address"
complete -c ctf -n '__fish_seen_subcommand_from addhost' -f -a "HOST"    -d "Hostname to add"

# ctf start arguments (no < >)
complete -c ctf -n '__fish_seen_subcommand_from start' -f -a "BOX" -d "Box name"
complete -c ctf -n '__fish_seen_subcommand_from start' -f -a "IP"  -d "Box IP address"

# ctf creds arguments
complete -c ctf -n '__fish_seen_subcommand_from creds' -f -a "USER" -d "Username"
complete -c ctf -n '__fish_seen_subcommand_from creds' -f -a "PASS" -d "Password"