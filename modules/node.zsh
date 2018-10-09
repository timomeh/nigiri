NMODOUT_NODE=""

add-zsh-hook precmd nigiri_module::node:precmd
add-zsh-hook preexec nigiri_module::node:preexec

function nigiri_module::node() {
  echo -n "$NMODOUT_NODE"
}

function nigiri_module::node:precmd() {
  async_job nigiri_node_worker nigiri_module::node:job $PWD
}

function nigiri_module::node:preexec() {
  NMODOUT_NODE=""
}

[[ -z "$NMOD_NODE_CMD" ]] && NMOD_NODE_CMD="nvm current"
function nigiri_module::node:job() {
  local dir=$1

  # Check if we're inside a node project (search package.json x dirs up),
  # abort if not.
  ! nigiri_module::node:find_package $dir > /dev/null 2>&1 && return 1

  echo -n "$(cd $dir && eval $NMOD_NODE_CMD)"
  return 0
}

[[ -z "$NMOD_NODE_FORMAT" ]] && NMOD_NODE_FORMAT="%F{black}with%f %B%F{green}⬢ NODE%f%b"
function nigiri_module::node:callback() {
  local exitcode="$2"
  [[ $exitcode -ne 0 ]] && return

  local node_version="$3"

  NMODOUT_NODE=""
  NMODOUT_GIT+="${NMOD_NODE_FORMAT//NODE/$node_version}"
  NMODOUT_NODE+=" "

  nigiri::redraw
}

function nigiri_module::node:find_package() {
  local cur_dir=$@
  local depth=5
  while [ "$cur_dir" != "/" ]; do
    if [ `find "$cur_dir" -maxdepth 1 -name package.json` ]; then
      return 0
    fi
    depth=$((depth - 1))
    if [[ depth -le 0 ]]; then break; fi
    x=`dirname "$cur_dir"`
  done
  return 1
}

async_start_worker nigiri_node_worker -u -n
async_register_callback nigiri_node_worker nigiri_module::node:callback
