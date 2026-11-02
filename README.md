# Sicheol Sung's dotfiles

## Requirements

sh (POSIX-compliant), curl (or wget), git, make

## Layout

*   `xdg-config-home/`: configurations for the user, linked into `XDG_CONFIG_HOME`
    *   `vim/`: runtime files that Vim and Neovim share, such as `colors/`,
        `after/`, and `pack/custom/`.
        Only `vimrc` and `vimrc.d/` are Vim-only,
        and `vimrc.d/neovim.vim` sets the Neovim defaults in Vim.
    *   `nvim/`: configuration that only Neovim uses
*   `xdg-templates-dir/`: templates for projects, linked into `XDG_TEMPLATES_DIR`

## Installation

```bash
git clone https://github.com/cdltlehf/dotfiles.git --depth 1 && cd dotfiles && make
```

Run `make check` to verify.

## References

* [POSIX.1-2024 Shell & Utilities](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/)
* [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
* [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
* [Modus Themes](https://protesilaos.com/emacs/modus-themes)
