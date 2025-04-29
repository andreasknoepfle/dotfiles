set -o PROMPT_SUBST

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
#  package       # Package version
#  node          # Node.js section
#  ruby          # Ruby section
#  elixir        # Elixir section
#  erlang         # Erlang section
  kubectl       # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_RPROMPT_ORDER=(
  time
)

# ~/.zshrc
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# FZF Shell integartion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fuzzy git checkout branch 
fgco() {
  local branches branch
	branches=$(git branch -vv) &&
	branch=$(echo "$branches" | fzf +m --query="$1") &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Default editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Set language
export LANG=en_US.UTF-8

# Git commit signing
export GPG_TTY=$(tty)

# Erlang history
export ERL_AFLAGS="-kernel shell_history enabled"
export ERL_EPMD_ADDRESS=127.0.0.1

# kerl options for asdf erlang
# https://github.com/erlang/otp/issues/4577#issuecomment-925962048
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
export KERL_BUILD_DOCS=yes
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

alias p=fzm
alias rechrome='open -n /Applications/Google\ Chrome.app'
alias opensearch='/opt/homebrew/opt/opensearch/bin/opensearch'

# aha autocomplete setup
eval 
AHA_AC_ZSH_SETUP_PATH=/Users/andi/Library/Caches/action-hero/autocomplete/zsh_setup && test -f $AHA_AC_ZSH_SETUP_PATH && source $AHA_AC_ZSH_SETUP_PATH;
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

. "$HOME/.cargo/env"
eval "$(uv generate-shell-completion zsh)"
