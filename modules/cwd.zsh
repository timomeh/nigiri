function nigiri_module::cwd() {
  echo -n "%{%B%}%F{yellow}"
  echo -n %~
  echo -n " "
  echo -n "%{%b%}%f"
}
