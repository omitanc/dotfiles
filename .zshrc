export PYTHON_HOME="/Library/Frameworks/Python.framework/Version/3.11/bin"
export PATH="$PYTHON_HOME:$PATH"

alias python='python3'
alias pip='pip3'

alias ls='ls -G'
alias la='ls -a'
alias tree='tree -C'
alias ll='ls -l -a'

alias cdd="cd ~/Desktop"
alias cddl="cd ~/Downloads"
alias cdtemp="cd ~/Temporary"
alias cdv="cd /Volumes"
alias cdq="cd .."

alias eman='env LANG=C man'
alias man='env LANG=ja_JP.UTF-8 man'


# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# コマンドミスを修正
setopt correct

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# プロンプトの表示設定(好きなようにカスタマイズ可)
setopt PROMPT_SUBST ; PS1='%F{yellow}%n@%f: %F{yellow}%~%f %F{magenta}$(__git_ps1 "(%s)")%f
\$ '
