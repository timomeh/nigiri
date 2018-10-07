<div align="center">
  <img width="600" height="400" src=".github/nigiri.svg" alt="nigiri">
</div>

> nigiri is an extendable zsh theme inspired by [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt/)
> and [pure](https://github.com/sindresorhus/pure).

Instead of having my zsh theme inside my [dotfiles](https://github.com/timomeh/dotfiles),
I extracted it into a zsh theme.

# Install

I'm using zplug, so that's everything I know.

```
zplug "mafredri/zsh-async"
zplug "timomeh/nigiri", as:theme
```

# How does it work?

nigiri consists of modules which compose the shell prompt. The order of the
modules is stored in `NIGIRI_PROMPT_MODULES`.

Each module is a function called `nigiri_module::my_module()`. The output of
this function (using `echo`) is added to the prompt.

# Attributions

The sushi-emoji is part of [Noto Color Emoji from Google](https://www.google.com/get/noto/help/emoji/)
and licensed under the [Apache License 2.0](https://github.com/googlei18n/noto-emoji/blob/master/LICENSE).

# LICENSE

MIT © Timo Mämecke
