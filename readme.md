<div align="center">
  <img width="600" height="400" src=".github/nigiri.svg" alt="nigiri">
</div>

> nigiri is a fast, modular and customizable zsh prompt inspired by
> [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt/) and [pure](https://github.com/sindresorhus/pure).

<div align="center">
  <img width="752" height="514" src=".github/screenshot.png" alt="screenshot">
</div>

# Install

I'm using zplug, so that's everything I know. [zsh-async](https://github.com/mafredri/zsh-async)
is a required dependency and needs to be loaded before nigiri.

```
zplug "mafredri/zsh-async"
zplug "timomeh/nigiri", as:theme
```

```
TODO: Add more installation guides
```

# Configuration

Use the variable `NIGIRI_PROMPT_MODULES` to define the order of the modules in
your prompt. Default is:

```
NIGIRI_PROMPT_MODULES=(
  newline
  cwd
  git
  node
  newline
  exit_status
)
```

# Add modules

nigiri consists of modules which compose the shell prompt. Each module is a
function, and the output of this function (using `echo`) will be added to the
prompt.

1. Create a new zsh file for your module, e.g. `ohai.zsh`. Define the
   function `nigiri_module::ohai` inside it:

   ```sh
   function nigiri_module::ohai() {
     echo -n "ohai marc."
   }
   ```

2. `source` the file before you load nigiri:

   ```sh
   source ohai.zsh
   ```

3. Add the module to `NIGIRI_PROMPT_MODULES`:

   ```sh
   NIGIRI_PROMPT_MODULES=(
     # ...
     ohai
     # ...
   )
   ```

Check out [`exit_status`](modules/exit_status.zsh) for a simple module example
or [`async_example`](modules/async_example.zsh) for a module utilizing async
functions.

# Attributions

The sushi-emoji is part of [Noto Color Emoji from Google](https://www.google.com/get/noto/help/emoji/)
and licensed under the [Apache License 2.0](https://github.com/googlei18n/noto-emoji/blob/master/LICENSE).

# License

MIT © Timo Mämecke
