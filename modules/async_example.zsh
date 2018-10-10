NIGIRI_MODULE_EXAMPLE_OUTPUT=""
add-zsh-hook preexec nigiri_module::async_example:preexec

# Will get called when prompt is initially drawn and redrawn.
function nigiri_module::async_example() {
  echo -n "$NIGIRI_MODULE_EXAMPLE_OUTPUT"
}

# The job to run in background when a new prompt is drawn.
# nigiri automatically detects if your module contains
# a job-function, if you use a function ending with :job.
function nigiri_module::async_example:job() {
  sleep 2 # do stuff in background
  echo -n "ohai marc"
}

# Will get called when the job is finished.
# $1 is the result of your job.
function nigiri_module::async_example:update() {
  NIGIRI_MODULE_EXAMPLE_OUTPUT=$1
}

# Most often you want to clear the output before the next
# prompt will be drawn. Reset it in this preexec hook.
function nigiri_module::async_example:preexec() {
  NIGIRI_MODULE_EXAMPLE_OUTPUT=""
}
