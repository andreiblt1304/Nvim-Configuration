---@diagnostic disable: undefined-global
return {

  -- ─────────────  CORE DAP CLIENT  ─────────────
  {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client

    opts = {}, -- keep the keymaps you already added
    config = function()
      local dap = require 'dap'

      -- 1.  SIGN DEFINITIONS ───────────────────────────────────────────────────
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })

      -- 2.  HIGHLIGHTS  (adapt the colours if you like) ────────────────────────
      --  NOTE: these are One Dark colours; change to match your colourscheme.
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#E06C75' }) -- red
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98C379' }) -- green
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { link = 'Visual' }) -- highlight whole line
    end,
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = '∙ Start / Continue',
      },
      {
        '<F9>',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '∙ Toggle Breakpoint',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = '∙ Step Over',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = '∙ Step Into',
      },
      {
        '<F12>',
        function()
          require('dap').step_out()
        end,
        desc = '∙ Step Out',
      },
    },
  },

  -- ─────────────  NICE UI & INLINE VALUES  ─────────────
  {
    'rcarriga/nvim-dap-ui',
    opts = {},
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_auto'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_auto'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_auto'] = function()
        dapui.close()
      end
    end,
  },
  { 'theHamsta/nvim-dap-virtual-text', opts = {} },

  -- ─────────────  AUTO-INSTALL CODELLDB  ─────────────
  { 'williamboman/mason.nvim' }, -- already in Kickstart, keep for order
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'mfussenegger/nvim-dap', 'williamboman/mason.nvim' },
    opts = { ensure_installed = { 'codelldb' }, automatic_setup = true },
  },

  -- ─────────────  RUST INTEGRATION  ─────────────
  {
    'mrcjkb/rustaceanvim', -- use this OR rust-tools (uncomment below if you prefer)
    version = '^4',
    ft = 'rust',
    config = function()
      local mason = require 'mason-registry'
      local codelldb_pkg = mason.get_package 'codelldb'
      local ext = codelldb_pkg:get_install_path() .. '/extension/'
      vim.g.rustaceanvim = {
        dap = {
          adapter = {
            type = 'server',
            port = '${port}',
            executable = { command = ext .. 'adapter/codelldb', args = { '--port', '${port}' } },
          },
        },
      }
    end,
  },

  --[[  -- Uncomment if you’d rather stay on rust-tools.nvim
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
    config = function()
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
      require("rust-tools").setup({
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(
            mason_path .. "adapter/codelldb",
            mason_path .. "lldb/lib/liblldb.so"   -- change to .dylib / .dll for macOS / Windows
          ),
        },
      })
    end,
  },
  --]]

  -- ─────────────  (OPTIONAL) Telescope picker for sessions  ─────────────
  {
    'nvim-telescope/telescope-dap.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
}
