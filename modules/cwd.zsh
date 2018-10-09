[[ -z "$NMOD_CWD_FORMAT" ]] && NMOD_CWD_FORMAT="%B%F{yellow}CWD %f%b"
function nigiri_module::cwd() {
  echo -n "${NMOD_CWD_FORMAT//CWD/%~}"
}
