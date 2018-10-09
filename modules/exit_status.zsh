[[ -z "$NMOD_EXIT_STATUS_GOOD" ]] && NMOD_EXIT_STATUS_GOOD="%F{green}● %f"
[[ -z "$NMOD_EXIT_STATUS_BAD" ]] && NMOD_EXIT_STATUS_BAD="%F{red}● %f"
function nigiri_module::exit_status() {
  echo -n "%(?.$NMOD_EXIT_STATUS_GOOD.$NMOD_EXIT_STATUS_BAD)"
}
