return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      -- Install the conform formatter on VeryLazy
      LazyVim.on_very_lazy(function()
        LazyVim.format.register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            require("conform").format({ bufnr = buf })
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)
    end,
    opts = function()
      local plugin = require("lazy.core.config").plugins["conform.nvim"]
      if plugin.config ~= M.setup then
        LazyVim.error({
          "Don't set `plugin.config` for `conform.nvim`.\n",
          "This will break **LazyVim** formatting.\n",
          "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
        }, { title = "LazyVim" })
      end
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = "fallback", -- not recommended to change
        },
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          javascript = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier", "markdownlint-cli2" },
          python = { "isort", "ruff_format" },
          sh = { "shfmt" },
          terraform = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          toml = { "taplo" },
          typst = { "typstfmt" },
          yaml = { "yamlfmt" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
    end,
    -- config = M.setup,
  },

  -- {
  --   "stevearc/conform.nvim",
  --   event = { "BufReadPre", "BufNewFile", "InsertLeave" },
  --   opts = {
  --     format_on_save = function()
  --       -- Disable with a global variable
  --       if not vim.g.autoformat then
  --         return
  --       end
  --       return { async = false, timeout_ms = 500, lsp_fallback = false }
  --     end,
  --     -- log_level = vim.log.levels.TRACE,
  --     formatters_by_ft = {
  --       go = { "goimports", "gofmt" },
  --       javascript = { "prettier" },
  --       json = { "prettier" },
  --       lua = { "stylua" },
  --       markdown = { "prettier", "markdownlint-cli2" },
  --       python = { "isort", "ruff_format" },
  --       sh = { "shfmt" },
  --       terraform = { "terraform_fmt" },
  --       ["terraform-vars"] = { "terraform_fmt" },
  --       tex = { "latexindent" },
  --       toml = { "taplo" },
  --       typst = { "typstfmt" },
  --       yaml = { "yamlfmt" },
  --     },
  --   },
  --   config = function(_, opts)
  --     local conform = require("conform")
  --     conform.setup(opts)
  --     conform.formatters.shfmt = {
  --       prepend_args = { "-i", "2" }, -- 2 spaces instead of tab
  --     }
  --     conform.formatters.stylua = {
  --       prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" }, -- 2 spaces instead of tab
  --     }
  --     conform.formatters.yamlfmt = {
  --       prepend_args = { "-formatter", "indent=2,include_document_start=true,retain_line_breaks_single=true" },
  --     }
  --     vim.g.autoformat = vim.g.autoformat
  --     vim.api.nvim_create_user_command("ToggleAutoformat", function()
  --       vim.api.nvim_notify("Toggling autoformat", vim.log.levels.INFO, { title = "conform.nvim", timeout = 2000 })
  --       vim.g.autoformat = vim.g.autoformat == false and true or false
  --     end, { desc = "Toggling autoformat" })
  --     vim.keymap.set("n", "<leader>tF", "<cmd>ToggleAutoformat<cr>", { desc = "Toggle format on save" })
  --   end,
  -- },

  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      {
        "ss",
        mode = { "n", "x", "o" },
        -- Jump to any word
        function()
          ---@diagnostic disable: missing-fields
          require("flash").jump({
            pattern = ".", -- initialize pattern with any char
            search = {
              mode = function(pattern)
                -- remove leading dot
                if pattern:sub(1, 1) == "." then
                  pattern = pattern:sub(2)
                end
                -- return word pattern and proper skip pattern
                return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
              end,
            },
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  },

  {
    "echasnovski/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Number of lines within which surrounding is searched
      n_lines = 50,
    },
  },

  {
    "gbprod/substitute.nvim",
    keys = {
    -- stylua: ignore start
    { "s", function() require("substitute").operator() end, desc = "Substitute", },
    { "s", mode = "x", function() require("substitute").visual() end, desc = "Substitute", },
      -- stylua: ignore end
    },
    opts = {},
  },

  {
    {
      "folke/todo-comments.nvim",
      event = "BufReadPre", -- needed to highlight keywords
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
      keys = {
        {
          "<leader>sT",
          function()
            require("todo-comments.fzf").todo()
          end,
          desc = "TODOs",
        },
      },
    },
  },

  {
    "allaman/emoji.nvim",
    ft = "markdown",
    opts = {
      enable_cmp_integration = true,
    },
  },

  -- emoji blink.cmp integration
  {
    "saghen/blink.cmp",
    dependencies = { "allaman/emoji.nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "emoji" },
        providers = {
          emoji = {
            name = "emoji",
            module = "blink.compat.source",
            -- overwrite kind of suggestion
            transform_items = function(ctx, items)
              local kind = require("blink.cmp.types").CompletionItemKind.Text
              for i = 1, #items do
                items[i].kind = kind
              end
              return items
            end,
          },
        },
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      -- stylua: ignore start
      { "<leader>R", "", desc = "Search & Replace" },
      { "<leader>RG", "<cmd>GrugFar<cr>", desc = "Open" },
      { "<leader>Rg", "<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<cr>", desc = "Open (Limit to current file)"},
      { "<leader>Rw", "<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<cr>", desc = "Search word under cursor", },
      { "<leader>Rs", mode = "v", "<cmd>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand('%') } })<cr>", desc = "Search selection", },
      -- stylua: ignore end
    },
  },

  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "v" }, desc = "Align" },
      { "gA", mode = { "v" }, desc = "Align with Preview" },
    },
    opts = {},
  },
}
