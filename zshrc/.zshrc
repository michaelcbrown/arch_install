# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
export PATH="/opt/miniconda3/bin:$PATH"
ZSH_THEME="gallifrey"

#plugins=(colored-man git history-substring-search sublime vagrant zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Set 256 Color
export TERM=xterm-256color


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mb/Other/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mb/Other/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mb/Other/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mb/Other/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(mcfly init zsh)"
eval "$(zoxide init zsh)"

alias light="xrandr --output eDP-1 --brightness"
alias sound="amixer set Master"
alias mute="amixer set Master toggle"

