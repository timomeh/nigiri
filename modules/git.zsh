NIGIRI_MODULE_GIT_OUTPUT=""
add-zsh-hook preexec nigiri_module::git:preexec

# The git module for nigiri uses snippets from an awesome article by Josh Dick:
# https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html

function nigiri_module::git() {
  echo -n "$NIGIRI_MODULE_GIT_OUTPUT"
}

function nigiri_module::git:update() {
  NIGIRI_MODULE_GIT_OUTPUT=$1
}

function nigiri_module::git:preexec() {
  NIGIRI_MODULE_GIT_OUTPUT=""
}

[[ -z "$NMOD_GIT_FORMAT" ]] && NMOD_GIT_FORMAT="%F{black}on%f GIT"
function nigiri_module::git:job() {
  # Exit if no git directory
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return 1

  local result=""
  result+=$(nigiri_module::git:commitish)
  result+=$(nigiri_module::git:status)
  result+=$(nigiri_module::git:up_down)
  result+=$(nigiri_module::git:in_progress)
  echo -n "${NMOD_GIT_FORMAT//GIT/$result} "
}

[[ -z "$NMOD_GIT_BRANCH_FORMAT" ]] && NMOD_GIT_BRANCH_FORMAT="%B%F{magenta}BRANCH%f%b"
function nigiri_module::git:commitish() {
  local dir=$1
  local commitish=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  echo -n "${NMOD_GIT_BRANCH_FORMAT//BRANCH/$commitish} "
}

[[ -z "$NMOD_GIT_UNTRACKED" ]] && NMOD_GIT_UNTRACKED="%F{red}■%f"
[[ -z "$NMOD_GIT_CHANGED" ]] && NMOD_GIT_CHANGED="%F{yellow}■%f"
[[ -z "$NMOD_GIT_STAGED" ]] && NMOD_GIT_STAGED="%F{blue}■%f"
[[ -z "$NMOD_GIT_DETACHED" ]] && NMOD_GIT_DETACHED="🔥"
[[ -z "$NMOD_GIT_CLEAN" ]] && NMOD_GIT_CLEAN="%F{green}■%f"
function nigiri_module::git:status() {
  local dir=$1
  local indicators

  # untracked
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    indicators+="$NMOD_GIT_UNTRACKED"
  fi

  # changed
  if ! git diff --quiet 2> /dev/null; then
    indicators+="$NMOD_GIT_CHANGED"
  fi

  # staged
  if ! git diff --cached --quiet 2> /dev/null; then
    indicators+="$NMOD_GIT_STAGED"
  fi

  # detached
  if [[ -n $(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | grep detached) ]]; then
    indicators="$NMOD_GIT_DETACHED"
  fi

  # clean
  if [[ -z "$indicators" ]]; then
    indicators="$NMOD_GIT_CLEAN"
  fi

  echo -n "$indicators"
}

[[ -z "$NMOD_GIT_AHEAD_FORMAT" ]] && NMOD_GIT_AHEAD_FORMAT="%B%F{red}⇡NUM%f%b"
[[ -z "$NMOD_GIT_BEHIND_FORMAT" ]] && NMOD_GIT_BEHIND_FORMAT="%B%F{red}⇣NUM%f%b"
function nigiri_module::git:up_down() {
  local dir=$1
  local ahead="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  local behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"

  [[ "$ahead" > 0 || "$behind" > 0 ]] && echo -n " %B"
  [[ "$ahead" > 0 ]] && echo -n "${NMOD_GIT_AHEAD_FORMAT//NUM/$ahead}"
  [[ "$behind" > 0 ]] && echo -n "${NMOD_GIT_BEHIND_FORMAT//NUM/$behind}"
  [[ "$ahead" > 0 || "$behind" > 0 ]] && echo -n "%f"
}

[[ -z "$NMOD_GIT_MERGE" ]] && NMOD_GIT_MERGE="%B%F{red}(merge)%f%b"
[[ -z "$NMOD_GIT_REBASE" ]] && NMOD_GIT_REBASE="%B%F{red}(rebase)%f%b"
function nigiri_module::git:in_progress() {
  local dir=$1
  local git_dir="$(git rev-parse --git-dir 2> /dev/null)"

  if test -r "$git_dir/MERGE_HEAD"; then
    echo -n " $NMOD_GIT_MERGE"
  fi

  if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"; then
    echo -n " $NMOD_GIT_REBASE"
  fi
}
