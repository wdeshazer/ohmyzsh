# github plugin

This plugin supports working with GitHub from the command line. It provides a few things:

* Sets up the `hub` wrapper and completions for the `git` command if you have [`hub`](https://github.com/github/hub) installed.
* Completion for the [`github` Ruby gem](https://github.com/defunkt/github-gem).
* Convenience functions for working with repos and URLs.

### Functions

* `empty_gh` - Creates a new empty repo (with a `README.md`) and pushes it to GitHub
* `new_gh` - Initializes an existing directory as a repo and pushes it to GitHub
* `exist_gh` - Takes an existing repo and pushes it to GitHub


## Installation

[Hub](https://github.com/github/hub) needs to be installed if you want to use it. On OS X with Homebrew, this can be done with `brew install hub`. The `hub` completion definition needs to be added to your `$FPATH` before initializing OMZ.

The [`github` Ruby gem](https://github.com/defunkt/github-gem) needs to be installed if you want to use it.

### Configuration

These settings affect `github`'s behavior.

#### Environment variables

* `$GITHUB_USER`
* `$GITHUB_PASSWORD`

#### Git configuration options

* `github.user` - GitHub username for repo operations

See `man hub` for more details.

### Homebrew installation note

If you have installed `hub` using Homebrew, its completions may not be on your `$FPATH` if you are using the system `zsh`. Homebrew installs `zsh` completion definitions to `/usr/local/share/zsh/site-functions`, which will be on `$FPATH` for the Homebrew-installed `zsh`, but not for the system `zsh`. If you want it to work with the system `zsh`, add this to your `${ZDOTDIR:-~}/.zshrc` before it sources `oh-my-zsh.sh`.

```zsh
if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi
```
