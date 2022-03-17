alias open="xdg-open"
alias cls='clear'
alias aptg='sudo apt-get'
alias apt-update='sudo apt-get update'
alias sapt='sudo apt'
alias apti='sudo apt --assume-yes install'
alias aptr='sudo apt --assume-yes remove'
alias npmig='sudo npm install -g'
alias cvim='vim --clean'
alias cnvim='nvim --clean'
alias create-launcher='gnome-desktop-item-edit --create-new ~/.local/share/applications'
alias code='code-insiders'
alias xclipb='xclip -sel clip'
alias ports='netstat -ntlp'
alias l='exa -lgha --git'
alias la='exa -lghaa --git'
alias ll='exa -lgh --git'
alias debi='sudo dpkg -i'
alias pmi='sudo pacman -S --noconfirm --needed'
alias yai='yay -S --noconfirm --needed'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dst='docker start'
alias dstop='docker stop'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dclog='docker-compose logs'
alias dclogf='docker-compose logs -f'
alias docker-rm-none="docker images | grep none | awk '{print \$3}' | xargs docker rmi"
alias ghci='stack ghci'
alias gpl='git pull origin'
alias gpo='git push origin'
alias git='hub'
alias gsy='hub sync'
alias gwls='git worktree list'
alias gwco='git worktree add'
alias gwcb='git worktree add -b'
alias gwrm='git worktree remove'
alias gffs='git flow feature start'
alias gfff='git flow feature finish'
alias gffc='git flow feature checkout'
alias gpnoci='git push -o ci.skip'
alias gpfnoci='git push --force-with-lease -o ci.skip'
alias tm='tmux'
alias rusti="rustup run nightly-2016-08-01 ~/.cargo/bin/rusti"
alias ipy="ipython"
alias pipi="pip install --upgrade"
alias pipu="pip install --user --upgrade"
alias pip2i="pip2 install --upgrade"
alias pip2u="pip2 install --user --upgrade"
alias pip-upgrade="sudo pip install --upgrade pip"
alias pe="path-extractor"
alias -g PE='| pe | fzf | read filename; [ ! -z $filename ] && nvim $filename'
alias -g PEC='| pe | fzf | read filename; [ ! -z $filename ] && echo -n $filename | xclip -sel c'
alias lpassc="dmenu-lpass-nu"
alias age="ag --elixir"
alias rge="rg -telixir"
alias rgjs="rg -tjs"
alias lox="cargo run"

# Actually functions

function xrun() {
    (
        "$@" &
        disown
    ) &>/dev/null
}
