# This is an example to show how

# store output of the module in a variable
NMODOUT_ASYNC_EXAMPLE=""

add-zsh-hook precmd nigiri_module::async_example:precmd
add-zsh-hook preexec nigiri_module::async_example:preexec

# will get called when prompt is initially drawn and redrawn
function nigiri_module::async_example() {
  echo -n "$NMODOUT_ASYNC_EXAMPLE"
}

# start job on precmd hook (before prompt is drawn)
function nigiri_module::async_example:precmd() {
  async_job nigiri_example_worker nigiri_module::async_example:job
}

# clear module output on preexec hook (after user executed a command)
function nigiri_module::async_example:preexec() {
  NMODOUT_ASYNC_EXAMPLE=""
}

# async job
function nigiri_module::async_example:job() {
  sleep 2 # do stuff in background
  echo -n "ohai marc"
}

# called when async job finished
function nigiri_module::async_example:callback() {
  NMODOUT_ASYNC_EXAMPLE="$3" # $3 is output of job
  nigiri::redraw # redraw the prompt to show the updated state.
}

# setup async, for details see https://github.com/mafredri/zsh-async
#   "nigiri_example_worker" is the name of your module's worker
#   and should be somewhat unique.
async_start_worker nigiri_example_worker -u -n
async_register_callback nigiri_example_worker nigiri_module::async_example:callback
