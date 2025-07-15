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
    echo (set_color magenta --bold)"  "$argv(set_color normal)
end
function ctf_success
    echo (set_color magenta --bold)"  "$argv(set_color normal)
end
function ctf_question
    echo (set_color magenta)"  "$argv(set_color normal)
end