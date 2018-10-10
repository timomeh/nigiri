NIGIRI_DIR="${0:a:h}"

if [ -z "$NIGIRI_PROMPT_MODULES" ]; then
  NIGIRI_PROMPT_MODULES=(
    newline
    cwd
    git
    # node
    wild_nigiri
    newline
    exit_status
  )
fi

[[ -z "$NIGIRI_PS2" ]] && NIGIRI_PS2="%F{black}⣿%f  "

PROMPT=""
PS2="$NIGIRI_PS2"

function nigiri::setup() {
  setopt prompt_subst
  autoload -Uz vcs_info
  autoload -Uz async && async
  autoload -Uz add-zsh-hook
  zmodload -i zsh/mathfunc

  async_init
  add-zsh-hook precmd nigiri::precmd
  async_register_callback nigiri nigiri::async_callback

  for module in ${(u)NIGIRI_PROMPT_MODULES}; do
    local modpath="$NIGIRI_DIR/modules/$module.zsh"
    [ -s $modpath ] && source $modpath

    # Check if job function exists in module, then setup precmd hooks
    if type nigiri_module::$module:job &> /dev/null | grep -q 'function'; then
      function nigiri::module_precmd:${module}() {
        local funcname="$funcstack[1]"
        local module_name=${funcname//nigiri::module_precmd:/}

        async_job nigiri nigiri_module::$module_name:job
      }

      add-zsh-hook precmd nigiri::module_precmd:${module}
    fi
  done
}

function nigiri::async_callback() {
  local job_name="$1"
  local return_code="$2"
  local stdout="$3"
  local exec_time="$4"
  local stderr="$5"
  local has_next="$6"

  [[ "$job_name" == "[async/eval]" ]] && return
  [[ "$has_next" == "1" ]] && return
  [[ "$return_code" != "0" ]] && return

  local module_name=${job_name//nigiri_module::/}
  module_name=${module_name//:job/}

  nigiri_module::${module_name:l}:update "$stdout"

  nigiri::redraw
}

function nigiri::redraw() {
  PROMPT="$(nigiri::draw_prompt)"
  zle && zle reset-prompt
}

function nigiri::precmd() {
  async_start_worker nigiri -n
  async_worker_eval nigiri "cd '$PWD'"
  PROMPT="$(nigiri::draw_prompt)"
}

function nigiri::draw_prompt() {
  # Call all loaded module functions in the specified order.
  for module in $NIGIRI_PROMPT_MODULES; do
    nigiri_module::$module
  done
}

nigiri::setup
