export KERL_BUILD_DOCS=yes
export KERL_INSTALL_HTMLDOCS=no
export KERL_INSTALL_MANPAGES=no

alias mix.dg='mix deps.get'
alias mix.du='mix deps.update'
alias mix.c='mix compile'
alias mix.cf='mix compile --force'
alias mix.t='mix test'
alias mix.tf='mix test --failed'
alias mix.tint='mix test.interactive'
alias mix.tintf='mix test.interactive --failed'
