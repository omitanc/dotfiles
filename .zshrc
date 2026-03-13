export PYTHON_HOME="/Library/Frameworks/Python.framework/Version/3.11/bin"
export PATH="$PYTHON_HOME:$PATH"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

alias python='python3'
alias pip='pip3'
alias vi="nvim"

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

deploy-pobcha-www() {
  local default_repo repo_root build_root build_dir build_version rsync_status
  default_repo="/Volumes/2TB_SSD-D/CodeProjects/pobcha-net-www"
  build_root="${CODEX_TEMP_DIR:-$HOME/codex_temp}"
  build_version="$(date '+%Y%m%d%H%M%S')"

  if repo_root="$(git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null)" \
    && [[ "${repo_root:t}" == "pobcha-net-www" ]]; then
    :
  else
    repo_root="$default_repo"
  fi

  if [[ ! -d "$repo_root" ]]; then
    printf 'deploy-pobcha-www: repo not found: %s\n' "$repo_root" >&2
    return 1
  fi

  mkdir -p "$build_root" || return 1
  build_dir="$(mktemp -d "${build_root}/pobcha-net-www-build.XXXXXX")" || return 1
  rsync_status=0

  rsync -a --delete \
    --exclude '.git/' \
    --exclude '.claude/' \
    --exclude '.vscode/' \
    --exclude '.DS_Store' \
    --exclude 'private/' \
    "$repo_root/" \
    "$build_dir/"

  while IFS= read -r -d '' html_file; do
    LC_ALL=C BUILD_VERSION="$build_version" perl -0pi -e 's{((?:\.\./|\./|/)?assets/(?:css|js)/[^"'\''?]+)(?:\?v=[^"'\'' ]*)?}{$1?v=$ENV{BUILD_VERSION}}g' "$html_file"
  done < <(find "$build_dir/www" -type f -name '*.html' -print0)

  printf 'Deploying %s (asset version %s) -> %s\n' "$repo_root/" "$build_version" 'pobpos@192.168.100.104:/var/www/html/'
  rsync -av --inplace --delete --delete-excluded \
    --exclude '.git/' \
    --exclude '.claude/' \
    --exclude '.vscode/' \
    --exclude '.DS_Store' \
    --exclude 'private/' \
    "$build_dir/" \
    pobpos@192.168.100.104:/var/www/html/ || rsync_status=$?

  command rm -rf "$build_dir"
  return "$rsync_status"
}



# コマンドミスを修正
setopt correct


# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
