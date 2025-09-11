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
    echo (set_color magenta --bold)"  "$argv(set_color normal)
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

# gum spin --spinner minidot --title " running..." --spinner.foreground 6 --title.foreground 4 --show-stdout --
# gum style --foreground 5 --border-foreground 6 --border rounded --padding "0 4" '󰆧 ctf-utils v0.gumfish'

function ctf_banner
    gum style --foreground 5 --border-foreground 6 --border rounded --padding "0 4" '󰆧 ctf.fish - ctf environment helper'
end
function ctf_input
    gum input --prompt "❯  " --placeholder "$argv" --prompt.foreground 5 --cursor.foreground 6
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