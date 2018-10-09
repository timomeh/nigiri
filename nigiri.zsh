NIGIRI_DIR="${0:a:h}"

if [ -z "$NIGIRI_PROMPT_MODULES" ]; then
  NIGIRI_PROMPT_MODULES=(
    newline
    cwd
    git
    node
    newline
    exit_status
  )
fi

PROMPT=""
PS2="%F{black}⣿%f  "

nigiri::setup() {
  setopt prompt_subst
  autoload -Uz vcs_info
  autoload -Uz async && async
  autoload -Uz add-zsh-hook

  async_init

  for module in ${(u)NIGIRI_PROMPT_MODULES}; do
    local modpath="$NIGIRI_DIR/modules/$module.zsh"
    [ -s $modpath ] && source $modpath
  done

  add-zsh-hook precmd nigiri::prompt
}

function nigiri::redraw() {
  PROMPT="$(nigiri::draw_prompt)"
  zle && zle reset-prompt
}

function nigiri::prompt() {
  PROMPT="$(nigiri::draw_prompt)"
}

function nigiri::draw_prompt() {
  # Call all loaded module functions in the specified order.
  for module in $NIGIRI_PROMPT_MODULES; do
    nigiri_module::$module
  done
}

nigiri::setup
