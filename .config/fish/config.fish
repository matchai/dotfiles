source ~/.config/fish/alias.fish

# Load all saved ssh keys
/usr/bin/ssh-add -A ^/dev/null

# Setup Jump
status --is-interactive; and source (jump shell fish | psub)

# Setup Direnv
eval (direnv hook fish)

# Setup Starship
starship init fish | source
