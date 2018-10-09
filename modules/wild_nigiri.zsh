NMODOUT_WILD_NIGIRI="$(( rand48() ))"

add-zsh-hook precmd nigiri_module::wild_nigiri:precmd

[[ -z "$NMOD_WILD_NIGIRI_CHANCE" ]] && NMOD_WILD_NIGIRI_CHANCE="0.005"
function nigiri_module::wild_nigiri() {
  [[ $NMODOUT_WILD_NIGIRI -le "$NMOD_WILD_NIGIRI_CHANCE" ]] && echo -n "🍣 "
}

function nigiri_module::wild_nigiri:precmd() {
  NMODOUT_WILD_NIGIRI="$(( rand48() ))"
}
