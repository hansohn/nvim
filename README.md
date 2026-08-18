<div align="center">
  <h1>nvim</h1>
  <p>Neovim configuration built on LazyVim for infrastructure and platform engineering</p>
  <p>
    <!-- Github Tag -->
    <a href="https://github.com/hansohn/nvim/tags/"><img src="https://img.shields.io/github/v/tag/hansohn/nvim?style=for-the-badge&sort=semver"></a>
    <!-- License -->
    <a href="https://github.com/hansohn/nvim/blob/main/LICENSE"><img src="https://img.shields.io/github/license/hansohn/nvim.svg?style=for-the-badge"></a>
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
