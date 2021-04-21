# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# if the init scipt doesn't exist
if ! zgenom saved; then
  echo "Creating a zgenom save"

  zgenom oh-my-zsh
  zgenom oh-my-zsh plugins/git
  zgenom oh-my-zsh plugins/bundler
  zgenom oh-my-zsh plugins/gpg-agent
  zgenom oh-my-zsh plugins/asdf
  zgenom oh-my-zsh plugins/history-substring-search

  zgenom oh-my-zsh themes/robbyrussell
  
  zgenom load zsh-users/zsh-history-substring-search 
  zgenom load urbainvaes/fzf-marks

  # save all to init script
  zgenom save
fi

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
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"

alias p=fzm

# aha autocomplete setup
eval 
AHA_AC_ZSH_SETUP_PATH=/Users/andi/Library/Caches/action-hero/autocomplete/zsh_setup && test -f $AHA_AC_ZSH_SETUP_PATH && source $AHA_AC_ZSH_SETUP_PATH;
