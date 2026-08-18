MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := default
.DELETE_ON_ERROR:
.SUFFIXES:

# include makefiles
export SELF ?= $(MAKE)
PROJECT_PATH ?= $(shell pwd)
include $(PROJECT_PATH)/Makefile.*

REPO_NAME ?= $(shell basename $(CURDIR))

NVIM ?= nvim
NVIM_DATA ?= $(HOME)/.local/share/nvim
NVIM_STATE ?= $(HOME)/.local/state/nvim
NVIM_CACHE ?= $(HOME)/.cache/nvim

# mason installs asynchronously and keeps working after neovim is told to quit,
# so a bare '+qa' aborts packages mid-download. Any target that installs
# something waits for mason to go idle first. Timeout is in milliseconds.
MASON_TIMEOUT ?= 600000
MASON_SETTLE = -c "lua local r = require('mason-registry') if not vim.wait($(MASON_TIMEOUT), function() for _, p in ipairs(r.get_all_packages()) do if p:is_installing() then return false end end return true end, 1000) then vim.cmd('cquit 1') end"

#-------------------------------------------------------------------------------
# requirements
#-------------------------------------------------------------------------------

# Internal guards -- deliberately no '##' comment, so they stay out of help.
nvim/require:
	@command -v $(NVIM) >/dev/null 2>&1 || (echo "[ERROR] Neovim is not installed. See https://neovim.io" && exit 1)
.PHONY: nvim/require

selene/require:
	@command -v selene >/dev/null 2>&1 || (echo "[ERROR] selene is not installed. Run 'brew install selene'." && exit 1)
.PHONY: selene/require

stylua/require:
	@command -v stylua >/dev/null 2>&1 || (echo "[ERROR] stylua is not installed. Run 'brew install stylua'." && exit 1)
.PHONY: stylua/require

#-------------------------------------------------------------------------------
# lint
#-------------------------------------------------------------------------------

## Lint lua with selene
lint/selene: selene/require
	@echo "[INFO] Linting lua with selene."
	@selene .
.PHONY: lint/selene

## Check lua formatting without writing anything
lint/stylua: stylua/require
	@echo "[INFO] Checking lua formatting with stylua."
	@stylua --check .
.PHONY: lint/stylua

## Reformat lua in place with stylua
lint/format: stylua/require
	@echo "[INFO] Reformatting lua with stylua."
	@stylua .
.PHONY: lint/format

## Run every linter
lint: lint/selene lint/stylua
.PHONY: lint

#-------------------------------------------------------------------------------
# lazy
#-------------------------------------------------------------------------------

## Install and update plugins, then refresh the lockfile
lazy/sync: nvim/require
	@echo "[INFO] Syncing plugins."
	@$(NVIM) --headless "+Lazy! sync" $(MASON_SETTLE) -c 'qa'
.PHONY: lazy/sync

## Remove plugins that are no longer declared
lazy/clean: nvim/require
	@echo "[INFO] Removing undeclared plugins."
	@$(NVIM) --headless "+Lazy! clean" -c 'qa'
.PHONY: lazy/clean

## Pin every installed plugin to its current commit
lazy/lock: nvim/require
	@echo "[INFO] Refreshing 'lazy-lock.json'."
	@$(NVIM) --headless "+Lazy! lock" -c 'qa'
	@echo "[INFO] Commit the lockfile on its own, as a 'chore:' change."
.PHONY: lazy/lock

#-------------------------------------------------------------------------------
# mason
#-------------------------------------------------------------------------------

## Install every tool listed in ensure_installed
mason/install: nvim/require
	@echo "[INFO] Installing mason packages."
	@$(NVIM) --headless $(MASON_SETTLE) -c 'qa'
.PHONY: mason/install

## List the tools mason has installed
mason/list: nvim/require
	@echo "[INFO] Packages mason has installed:"
	@ls -1 "$(NVIM_DATA)/mason/packages" 2>/dev/null | sed 's/^/  /' || echo "  none"
.PHONY: mason/list

#-------------------------------------------------------------------------------
# validate
#-------------------------------------------------------------------------------

# Mirrors the 'load' job in .github/workflows/lint.yml: a config is only useful
# if neovim can actually start with it. Note that neovim exits 0 even when the
# config throws, so the exit status proves nothing -- a startup error only shows
# up on stderr, which is what this checks. mason's abort notice is teardown
# noise rather than a config error, and real errors are emitted before it, so
# everything from that notice onward is dropped.
## Load the config headlessly and fail if it errors
validate/load: nvim/require
	@echo "[INFO] Loading the config headlessly."
	@err="$$($(NVIM) --headless -c 'qa' 2>&1 >/dev/null | sed '/packages are still installing/,$$d')"; \
	  if [ -n "$$err" ]; then \
	    echo "[ERROR] Neovim reported errors while loading the config:"; \
	    echo "$$err" | sed 's/^/         /'; \
	    exit 1; \
	  fi
	@echo "[INFO] Config loaded cleanly."
.PHONY: validate/load

## Run every check that CI runs
validate: lint validate/load
	@echo "[INFO] All checks passed."
.PHONY: validate

#-------------------------------------------------------------------------------
# health
#-------------------------------------------------------------------------------

## Print neovim's health report
health: nvim/require
	@$(NVIM) --headless -c 'checkhealth' -c 'w! /dev/stdout' -c 'qa!'
.PHONY: health

#-------------------------------------------------------------------------------
# clean
#-------------------------------------------------------------------------------

## Delete downloaded plugins and tools, so the next start is a fresh clone
clean:
	@echo "[WARN] About to delete:"
	@echo "         $(NVIM_DATA)"
	@echo "         $(NVIM_STATE)"
	@echo "         $(NVIM_CACHE)"
	@read -r -p "[WARN] This cannot be undone. Continue? [y/N] " reply; \
	  case "$$reply" in [yY]*) ;; *) echo "[INFO] Aborted."; exit 0 ;; esac; \
	  rm -rf "$(NVIM_DATA)" "$(NVIM_STATE)" "$(NVIM_CACHE)"; \
	  echo "[INFO] Removed. The next 'nvim' start will bootstrap from scratch."
.PHONY: clean
