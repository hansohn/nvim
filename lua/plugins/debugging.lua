return {
  "mfussenegger/nvim-dap-python",
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}
