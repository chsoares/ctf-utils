# special symbols

function ctf_header
    echo (set_color yellow --bold)"  "$argv(set_color normal)
end
function ctf_info
    echo (set_color cyan)"  "$argv(set_color normal)
end
function ctf_cmd
    echo (set_color blue)"  "$argv(set_color normal)
end
function ctf_error
    echo (set_color red --bold)"  "$argv(set_color normal)
end
function ctf_warn
    echo (set_color magenta)"  "$argv(set_color normal)
end
function ctf_success
    echo (set_color magenta --bold)"  "$argv(set_color normal)
end
function ctf_question
    echo (set_color cyan)"  "$argv(set_color normal)
end
function ctf_title
    echo (set_color magenta --bold)"  "$argv(set_color normal)
end


function ctf_banner
    gum style --foreground 5 --border-foreground 6 --border rounded --padding "0 4" '󰆧 ctf.fish - ctf environment helper'
end
function ctf_input
    gum input --prompt "❯  " --placeholder "$argv" --prompt.foreground 5 --cursor.foreground 6
end
function ctf_choose_one
    gum choose -limit=1 --cursor.foreground 6 --selected.foreground 5 --cursor "❯ " --header "" $argv
end
function ctf_choose_many
    gum choose --no-limit --cursor.foreground 6 --selected.foreground 5 --cursor "❯ " --header "" $argv
end

function ctf_confirm
    gum confirm "Select option" --prompt.foreground 240 --selected.background 5 --selected.foreground 255
end

function _ctf_spin
    set -l verbs "running" "executing" "processing" "computing" "pwning" "exploiting" "hacking" "cracking" "scanning" "enumerating" "fuzzing" "bruteforcing" "rooting" "escalating" "pivoting" "tunneling" "injecting" "dumping" "decrypting" "reverse-engineering" "brewing" "cooking" "dancing" "vibing" "contemplating" "procrastinating" "caffeinating" "debugging life" "yolo-ing" "memeing" "overthinking" "quantum-leaping" "time-traveling" "teleporting" "summoning chaos" "manifesting packets" "channeling energy" "consulting the void" "awakening the machine"
    set -l random_verb $verbs[(math (random) % (count $verbs) + 1)]
    gum spin --spinner minidot --title " $random_verb..." --spinner.foreground 6 --title.foreground 4 -- $argv
end




## no special symbols

# function ctf_header
#     echo (set_color yellow --bold)"[+] "$argv(set_color normal)
# end
# function ctf_info
#     echo (set_color cyan)"[*] "$argv(set_color normal)
# end
# function ctf_cmd
#     echo (set_color blue)"[>] "$argv(set_color normal)
# end
# function ctf_error
#     echo (set_color red --bold)"[!] "$argv(set_color normal)
# end
# function ctf_warn
#     echo (set_color magenta --bold)"[*] "$argv(set_color normal)
# end
# function ctf_success
#     echo (set_color magenta --bold)"[✓] "$argv(set_color normal)
# end
# function ctf_question
#     echo (set_color magenta)"[?] "$argv(set_color normal)
# end
# function ctf_title
#     echo (set_color magenta --bold)"[~] "$argv(set_color normal)
# end