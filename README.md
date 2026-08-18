<div align="center">
  <h1>nvim</h1>
  <p>Neovim configuration built on LazyVim for infrastructure and platform engineering</p>
  <p>
    <!-- Build Status -->
    <a href="https://github.com/hansohn/nvim/actions/workflows/lint.yml"><img src="https://img.shields.io/github/actions/workflow/status/hansohn/nvim/lint.yml?style=for-the-badge"></a>
    <!-- Github Tag -->
    <a href="https://github.com/hansohn/nvim/tags/"><img src="https://img.shields.io/github/v/tag/hansohn/nvim?style=for-the-badge&sort=semver"></a>
    <!-- License -->
    <a href="https://github.com/hansohn/nvim/blob/main/LICENSE.md"><img src="https://img.shields.io/github/license/hansohn/nvim.svg?style=for-the-badge"></a>
  </p>
</div>

## Description

A [LazyVim](https://github.com/LazyVim/LazyVim) configuration tuned for infrastructure work — Ansible, Terraform, Docker, Helm and Kubernetes manifests — alongside Go, Python and Lua. Plugin versions are pinned in `lazy-lock.json` so a fresh clone reproduces a known-good setup.

What's Included
---------------

### Language support

| Area | Provided by |
|---|---|
| Infrastructure | `ansible`, `terraform`, `docker`, `helm`, `yaml` |
| Languages | `go`, `python`, `rust`, `json`, `markdown`, `toml` |
| Tooling | `git`, plus `mason` for LSP, DAP and linter installation |

Enabled through LazyVim extras, recorded in `lazyvim.json`.

### AI

Copilot, Copilot Chat and Claude Code, via the `lazyvim.plugins.extras.ai.*` extras.

### Customization

Local overrides live in [`lua/plugins/`](lua/plugins), one file per area — `colorscheme`, `editor`, `linting`, `lsp`, `treesitter`, `ui`, `util`. The files under [`lua/config/`](lua/config) are LazyVim's own entry points and are deliberately near-empty; `options.lua` carries only the Python provider path.

Prerequisites
-------------

[Neovim](https://neovim.io) 0.10.0 or later, plus `git`, a C compiler for treesitter, and a [Nerd Font](https://www.nerdfonts.com) for icons. On macOS these come from [hansohn/mac-setup](https://github.com/hansohn/mac-setup), which installs Neovim, the Lua toolchain and Hack Nerd Font.

Installation
------------

```bash
# back up any existing configuration
$ mv ~/.config/nvim{,.bak}

# clone the repo
$ git clone https://github.com/hansohn/nvim.git ~/.config/nvim

# start neovim; lazy.nvim bootstraps itself and installs plugins
$ nvim
```

Maintenance
-----------

The `Makefile` wraps the checks CI runs, plus the headless commands that are
easy to get wrong:

```bash
$ make validate       # everything CI runs: selene, stylua, and a clean load
$ make lint/format    # reformat lua in place
$ make lazy/sync      # update plugins and refresh the lockfile
$ make lazy/lock      # re-pin every plugin to its current commit
$ make mason/install  # install the tools listed in ensure_installed
$ make clean          # delete plugin and tool state, for a fresh-clone test
```

Running `make` on its own prints the full target list.

Two things the targets get right that a hand-typed command usually doesn't.
`lazy/sync` and `mason/install` wait for mason to go idle before quitting —
a bare `nvim --headless ... +qa` aborts downloads mid-flight, which is how a
package like `delve` ends up half-installed. And `validate` checks stderr
rather than the exit status, because Neovim exits `0` even when the config
throws on startup.
