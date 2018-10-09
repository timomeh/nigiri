<div align="center">
  <img width="600" height="400" src=".github/nigiri.svg" alt="nigiri">
</div>

> nigiri is a fast, modular and customizable zsh prompt inspired by
> [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt/) and [pure](https://github.com/sindresorhus/pure).

<div align="center">
  <img width="752" src=".github/screenshot.png" alt="screenshot">
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

Use the variable `NIGIRI_PS2` to set the PS2. It defaults to `%F{black}⣿%f  `.

## git

| Variable | Description | Default |
| - | - | - |
| **`NMOD_GIT_FORMAT`** | Format of the module's output, where `GIT` will be replaced with the whole output. | `%F{black}on%f GIT` |
| **`NMOD_GIT_BRANCH_FORMAT`** | Format of the branch section, where `BRANCH` will be replaced with the branch name. | `%B%F{magenta}BRANCH%f%b` |
| **`NMOD_GIT_AHEAD_FORMAT`** | Format for the number of ahead commits, where `NUM` will be replaced with the number. | `%B%F{red}⇡NUM%f%b` |
| **`NMOD_GIT_BEHIND_FORMAT`** | Format for the number of behind commits, where `NUM` will be replaced with the number. | `%B%F{red}⇣NUM%f%b` |
| **`NMOD_GIT_UNTRACKED`** | String to print for untracked files. | `%F{red}■%f` |
| **`NMOD_GIT_CHANGED`** | String to print for changed files. | `%F{yellow}■%f` |
| **`NMOD_GIT_STAGED`** | String to print for staged files. | `%F{blue}■%f` |
| **`NMOD_GIT_DETACHED`** | String to print when HEAD is detached. | `%F{blue}■%f` |
| **`NMOD_GIT_CLEAN`** | String to print when working tree is clean. | `%F{green}■%f` |
| **`NMOD_GIT_MERGE`** | String to print while merging. | `%B%F{red}(merge)%f%b` |
| **`NMOD_GIT_REBASE`** | String to print while rebasing. | `%B%F{red}(rebase)%f%b` |

## node

| Variable | Description | Default |
| - | - | - |
| **`NMOD_NODE_CMD`** | Command to run to get the current node version. | `nvm current` |
| **`NMOD_NODE_FORMAT`** | Format of the module's output, where `NODE` will be replaced with the node version. | `%F{black}with%f %B%F{green}⬢ NODE%f%b` |

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
