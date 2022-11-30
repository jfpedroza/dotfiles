# Nix Install
alias ni='nix-env -iA'

# Nix Search
alias ns='nix-env -qaP'

function prompt_nix_shell {
  if [[ -n ${IN_NIX_SHELL} && ${IN_NIX_SHELL} != "0" || ${IN_NIX_RUN} && ${IN_NIX_RUN} != "0" ]]; then
    if [[ -n ${IN_WHICH_NIX_SHELL} ]] then
      NIX_SHELL_NAME=": ${IN_WHICH_NIX_SHELL}"
    fi
    if [[ -n ${IN_NIX_SHELL} && ${IN_NIX_SHELL} != "0" ]]; then
      NAME="nix-shell"
    else
      NAME="nix-run"
    fi
    echo "${NAME}${NIX_SHELL_NAME}"
  fi
}
