return {
  {
    -- nvim-lspconfig
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", version = "^1.0.0" },
      { "mason-org/mason-lspconfig.nvim", version = "^1.0.0", config = function() end },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          ansiblels = {
            settings = {
              ansible = {
                ansible = {
                  path = "ansible",
                },
                ansibleLint = {
                  path = "ansible-lint",
                },
              },
            },
          },
          bashls = {},
          dockerls = {},
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                },
              },
            },
          },
          ruff = {
            cmd_env = { RUFF_TRACE = "messages" },
            init_options = {
              settings = {
                logLevel = "error",
              },
            },
            keys = {
              {
                "<leader>co",
                LazyVim.lsp.action["source.organizeImports"],
                desc = "Organize Imports",
              },
            },
          },
          terraformls = {
            settings = {
              terraform = {
                path = "terraform",
              },
              tflint = {
                path = "tflint",
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
  },
  -- mason.nvim
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ensure_installed = {
        "debugpy",
        "gh-actions-language-server",
        "golangci-lint-langserver",
        "golangci-lint",
        "helm-ls",
        "json-lsp",
        "jsonlint",
        "kube-linter",
        "pylint",
        "selene",
        "typescript-language-server",
      },
    },
  },
  -- mason-lspconfig.nvim
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^1.0.0",
    dependencies = {
      { "mason-org/mason.nvim", version = "^1.0.0", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_installation = true,
    },
  },
}
