function zsh-completion {
  case $1 in
    git-flow)
      [ -f /usr/share/zsh/site-functions/git-flow-completion.zsh ] \
        && source /usr/share/zsh/site-functions/git-flow-completion.zsh
      ;;
    minikube)
      [ -x "$(which minikube)" ] && source <(minikube completion zsh)
      ;;
  esac
}

function _source-zsh-compl {
  local program=

  case "$BUFFER" in
    git\ flow*)
      program=git-flow
      ;;
    minikube*)
      program=minikube
      ;;
  esac

  if [[ -n "$program" ]]; then
    local OLD_BUFFER=$BUFFER
    zle kill-whole-line
    zle -U "zsh-completion $program$OLD_BUFFER"
  fi
}

zle -N _source-zsh-compl

bindkey "^k" _source-zsh-compl
