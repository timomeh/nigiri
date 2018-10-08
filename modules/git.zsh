# The git module for nigiri uses snippets from an awesome article by Josh Dick:
# https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

function nigiri_module::git() {
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  local commitish=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  echo -n "%F{black}on %f"

  echo -n "%{%B%}"
  echo -n "%F{magenta}$commitish%f"
  echo -n " "
  nigiri_module::git:indicators
  nigiri_module::git:progress
  echo -n "%{%b%}"
  echo -n " "
}

function nigiri_module::git:indicators() {
  local indicators

  # untracked
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    indicators+="%{%F{red}%}■%f"
  fi

  # changed
  if ! git diff --quiet 2> /dev/null; then
    indicators+="%{%F{yellow}%}■%f"
  fi

  # staged
  if ! git diff --cached --quiet 2> /dev/null; then
    indicators+="%{%F{cyan}%}■%f"
  fi

  # detached
  if [[ -n $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | grep detached) ]]; then
    indicators="🔥"
  fi

  # unmodified
  if [ -z "$indicators" ]; then
    indicators="%{%F{green}%}■%f"
  fi

  echo -n "$indicators"
}

function nigiri_module::git:progress() {
  local git_dir="$(git rev-parse --git-dir 2> /dev/null)"

  if test -r "$git_dir/MERGE_HEAD"; then
    echo -n "%{%F{red}%}merging%f"
  fi

  if test -d $git_dir/rebase-merge -o -d $git_dir/rebase-apply; then
    echo -n "%{%F{red}%}rebasing%f"
  fi
}
