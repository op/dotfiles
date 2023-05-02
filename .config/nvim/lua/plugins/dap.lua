return {
  { import = "lazyvim.plugins.extras.dap.core" },

  {
    "leoluz/nvim-dap-go",

    -- stylua: ignore
    keys = {
      -- remap dt and move terminate to dT
      -- TODO: this works 50% of the time -- race condition?
      --{ "<leader>dt", function() require('dap-go').debug_test() end, desc = "Debug Test" },
      --{ "<leader>dT", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dT", function() require('dap-go').debug_test() end, desc = "Debug Test" },
    },

    opts = function()
      local dap = require("dap")

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- works with go.mod packages and sub packages
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }
    end,
  },
}
