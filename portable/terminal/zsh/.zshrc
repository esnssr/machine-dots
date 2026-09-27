eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


source ~/.antigen/antigen.zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle agkozak/zsh-z

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# nvm bash_completion uses Bash-only builtins (e.g. `complete`), so skip it in zsh.
[[ -n "$BASH_VERSION" && -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

export PROMPT_SP=' '


export PATH="$(brew --prefix ruby)/bin:$PATH"

alias git-purge-local='git fetch -p && git branch -vv | awk "/: gone]/{if (\$1 == \"*\") print \$2; else print \$1}" | while read branch; do git branch -d "$branch"; done'

# wut cli
# `wut init` emits a Bash-style `complete` call before its own zsh setup.
# Enable bash completion compatibility first so startup stays error-free.
autoload -U +X bashcompinit && bashcompinit
eval "$(wut init)"
export PATH="$HOME/.local/bin:$PATH"

# Default editor
export EDITOR=nano
export VISUAL=nano
