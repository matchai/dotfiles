source ~/.config/fish/alias.fish

# Configure Jump
status --is-interactive; and source (jump shell fish | psub)

# Load all saved ssh keys
/usr/bin/ssh-add -A ^/dev/null

# Install Starship
starship init fish | source
