-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/py3nvim/bin/python")

-- Ansible ships templates as .j2; map them onto the jinja filetype so the
-- treesitter parser and jinja_lsp below both engage.
vim.filetype.add({ extension = { j2 = "jinja" } })
