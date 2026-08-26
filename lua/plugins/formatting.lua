return {
  {
    -- conform.nvim comes from LazyVim; this only adds what it does not cover.
    --
    -- yaml is the filetype this config is built around -- ansible, kubernetes
    -- manifests, helm values and workflows are all yaml -- and it was the one
    -- with no formatter attached, while markdown had three. yamllint reports
    -- that indentation is wrong; nothing fixed it.
    --
    -- yamlfmt is installed by hansohn/mac-setup rather than mason, matching how
    -- yamllint is provided for nvim-lint.
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },
      },
    },
  },
}
