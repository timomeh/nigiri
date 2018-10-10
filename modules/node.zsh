NIGIRI_MODULE_NODE_OUTPUT=""
add-zsh-hook preexec nigiri_module::node:preexec

function nigiri_module::node() {
  NIGIRI_MODULE_NODE_LASTDIR="$PWD"
  echo -n "$NIGIRI_MODULE_NODE_OUTPUT"
}

function nigiri_module::node:update() {
  NIGIRI_MODULE_NODE_OUTPUT="$1"
}

function nigiri_module::node:preexec() {
  NIGIRI_MODULE_NODE_OUTPUT=""
}

[[ -z "$NMOD_NODE_CMD" ]] && NMOD_NODE_CMD="node --version"
[[ -z "$NMOD_NODE_FORMAT" ]] && NMOD_NODE_FORMAT="%F{black}with%f %B%F{green}⬢ NODE%f%b"
function nigiri_module::node:job() {
  # Check if we're inside a node project (search package.json x dirs up),
  # abort if not.
  ! nigiri_module::node:find_package $PWD > /dev/null 2>&1 && return 1

  local result="$(eval $NMOD_NODE_CMD)"
  echo -n "${NMOD_NODE_FORMAT//NODE/$result} "
  return 0
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
