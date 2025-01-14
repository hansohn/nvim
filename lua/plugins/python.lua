return {
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup(vim.g.python3_host_prog)
      require("dap-python").test_runner = "pytest"
    end,
  },

  -- {
  --   'linux-cultist/venv-selector.nvim',
  --   event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  --   dependencies = {
  --     'neovim/nvim-lspconfig',
  --     'nvim-telescope/telescope.nvim',
  --     'mfussenegger/nvim-dap-python'
  --   },
  --   opts = {
  --     -- Your options go here
  --     -- name = "venv",
  --     -- auto_refresh = false
  --   },
  --   keys = {
  --     -- Keymap to open VenvSelector to pick a venv.
  --     { '<leader>vs', '<cmd>VenvSelect<cr>' },
  --     -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
  --     { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
  --   },
  -- },

  -- {
  --   "linux-cultist/venv-selector.nvim",
  --     dependencies = {
  --       "neovim/nvim-lspconfig",
  --       "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
  --       { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  --     },
  --   lazy = false,
  --   branch = "regexp", -- This is the regexp branch, use this for the new version
  --   config = function()
  --       require("venv-selector").setup()
  --     end,
  --     keys = {
  --       { ",v", "<cmd>VenvSelect<cr>" },
  --     },
  -- },
}
