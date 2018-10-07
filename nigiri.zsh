NEWLINE="
"

NIGIRI_DIR="${0:a:h}"

NIGIRI_PROMPT_MODULES=(
  newline
  cwd
  git
  newline
  exit_status
)

nigiri::setup() {
  autoload -Uz vcs_info
  autoload -Uz async && async
  autoload -Uz add-zsh-hook

  for module in ${(u)NIGIRI_PROMPT_MODULES}; do
    local modpath="$NIGIRI_DIR/modules/$module.zsh"
    [ -s $modpath ] && source $modpath
  done

  add-zsh-hook precmd nigiri::prompt
}

nigiri::prompt() {
  PS1="$(nigiri::draw_prompt)"
}

nigiri::draw_prompt() {
  for module in $NIGIRI_PROMPT_MODULES; do
    nigiri_module::$module
  done
}

nigiri::setup
