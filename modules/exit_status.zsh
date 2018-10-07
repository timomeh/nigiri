function nigiri_module::exit_status() {
  echo -n "%(?.%F{green}.%F{red})"
  echo -n "● "
  echo -n "%f"
}
