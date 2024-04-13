# Uncomment this and the last line for profiling ZSH
# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
  export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bullet-train"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "bullet-train" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
export DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

export SAVEHIST=50000

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Tmux plugin settings
export ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_AUTOQUIT=false
export ZSH_TMUX_AUTOCONNECT=false
export ZSH_TMUX_AUTONAME_SESSION=true

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  kubectl
  vi-mode
  tmux
  z
  forgit
  docker
  docker-compose
  nix-shell
)

fpath+=${ZSH_CUSTOM:-$ZSH/custom}/plugins/nix-zsh-completions

# Disable async prompt for git while it's fixed
# https://github.com/ohmyzsh/ohmyzsh/issues/12328
zstyle ':omz:alpha:lib:git' async-prompt no

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='nvim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_ed25519"

BULLETTRAIN_PROMPT_CHAR=\λ
BULLETTRAIN_PROMPT_ROOT=true
BULLETTRAIN_VIRTUALENV_PREFIX=env:
BULLETTRAIN_TIME_12HR=true

BULLETTRAIN_CUSTOM_MSG='$(prompt_nix_shell)'
BULLETTRAIN_CUSTOM_BG=yellow
BULLETTRAIN_CUSTOM_FG=black

export MANPAGER='nvim +Man!'

export KEYTIMEOUT=1
bindkey -v

bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward
bindkey -s ^f "tmux-sessionizer\n"

function set_title () {
    # Name the terminal after the basename of the current directory
    local terminal_title=${PWD##*/}
    # If the current directory is the home directory, name it 'home'
    [[ "$PWD" == "$HOME" ]] && terminal_title="home"

    print -Pn "\e]0;$terminal_title\a"
}

case $TERM in
    xterm*)
        chpwd () { set_title }
        set_title
        ;;
esac

[ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

[ -f ~/.local/bin/tmuxinator.zsh ] && source ~/.local/bin/tmuxinator.zsh

[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

[ -f /usr/share/zsh/site-functions/git-flow-completion.zsh ] \
    && source /usr/share/zsh/site-functions/git-flow-completion.zsh

[[ -e "$HOME/.fzf-extras/fzf-extras.zsh" ]] \
  && source "$HOME/.fzf-extras/fzf-extras.zsh"

[[ -e "$HOME/.asdf/asdf.sh" ]] \
    && source "$HOME/.asdf/asdf.sh"

[[ -e "/opt/asdf-vm/asdf.sh" ]] \
    && source "/opt/asdf-vm/asdf.sh"

[[ -e "$HOME/.asdf/completions/asdf.bash" ]] \
    && source "$HOME/.asdf/completions/asdf.bash"

[[ -e "$HOME/.asdf/plugins/java/set-java-home.zsh" ]] \
    && source "$HOME/.asdf/plugins/java/set-java-home.zsh"

[[ -e "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
    && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_DEFAULT_COMMAND='fd --type f'

export FZF_DEFAULT_OPTS="--preview 'fzf-preview path {}'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_OPTS="
  --preview 'fzf-preview path {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'ctrl-f:reload(eval "$FZF_DEFAULT_COMMAND")'
  --bind 'ctrl-d:reload(fd --type d)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -sel clip)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,deps,_build,.elixir_ls
  --preview 'fzf-preview path {}'"

export FLYCTL_INSTALL="$HOME/.fly"

export PATH=$HOME/private_dotfiles/bin:$HOME/dotfiles/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/go/bin:$(yarn global bin):$FLYCTL_INSTALL/bin:$PATH

[[ -e "$HOME/.config/asdf-direnv/zshrc" ]] \
  && source "$HOME/.config/asdf-direnv/zshrc"

# zprof
