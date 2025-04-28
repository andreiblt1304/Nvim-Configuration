return {
  {
    'mfussenegger/nvim-dap', -- Core debugging support for Neovim
  },
  {
    'leoluz/nvim-dap-go', -- Specific configuration and helpers for Go
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-go').setup {
        dap_configurations = {
          {
            type = 'go',
            name = 'Debug Test File',
            request = 'launch',
            mode = 'test',
            program = '${file}',
            dlvToolPath = vim.fn.exepath 'dlv',
          },
          {
            type = 'go',
            name = 'Debug Benchmark',
            request = 'launch',
            mode = 'test',
            program = '${file}',
            args = { '-bench', '.' },
            dlvToolPath = vim.fn.exepath 'dlv',
          },
        },
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui', -- User interface for DAP for a better visual experience
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup()
      local dap, dapui = require 'dap', require 'dapui'
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Set up debugging keybindings for Go
      vim.keymap.set('n', '<F5>', function()
        dap.continue()
      end, { noremap = true, silent = true }) -- Start/Continue
      vim.keymap.set('n', '<F10>', function()
        dap.step_over()
      end, { noremap = true, silent = true }) -- Step Over
      vim.keymap.set('n', '<F11>', function()
        dap.step_into()
      end, { noremap = true, silent = true }) -- Step Into
      vim.keymap.set('n', '<F12>', function()
        dap.step_out()
      end, { noremap = true, silent = true }) -- Step Out
      vim.keymap.set('n', '<leader>b', function()
        dap.toggle_breakpoint()
      end, { noremap = true, silent = true }) -- Toggle Breakpoint
      vim.keymap.set('n', '<leader>dr', function()
        dap.repl.open()
      end, { noremap = true, silent = true }) -- Open REPL
    end,
  },
}
