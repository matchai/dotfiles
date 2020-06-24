# apps... but better
alias git=hub
alias vim=nvim
alias ls=lsd

# git
abbr -a gs  git status -sb
abbr -a ga  git add
abbr -a gc  git commit
abbr -a gcm git commit -m
abbr -a gca git commit --amend
abbr -a gcl git clone
abbr -a gco git checkout
abbr -a gp  git push
abbr -a gpl git pull
abbr -a gl  git l
abbr -a gd  git diff
abbr -a gds git diff --staged
abbr -a gr  git rebase -i HEAD~15
abbr -a gf  git fetch
abbr -a gfc git findcommit
abbr -a gfm git findmessage
abbr -a gco git checkout

# yadm
abbr -a ys  yadm status -s -b
abbr -a ya  yadm add
abbr -a yc  yadm commit
abbr -a ycm yadm commit -m
abbr -a yp  yadm push
abbr -a yl  yadm l
abbr -a yd  yadm diff
abbr -a yds yadm diff --staged

# ls
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# misc
alias reload='exec fish'
