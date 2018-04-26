function fish_prompt
    set_color green; echo -n $USER
    set_color white; echo -n @
    set_color yellow; echo -n (hostname -s)
    set_color normal; __terlar_git_prompt
    set_color white; echo -n "> "
    set_color normal
end
