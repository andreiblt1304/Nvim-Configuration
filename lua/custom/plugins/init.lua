return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup {
        -- your config options here
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = 'open_default',
          use_libuv_file_watcher = true,
        },
        window = {
          position = 'float',
        },
      }
      vim.api.nvim_set_keymap(
        'n', -- normal mode
        '<Leader>ft', -- leader + f + t
        ':Neotree toggle<CR>', -- command to toggle Neo-tree
        { noremap = true, silent = true } -- options: no remapping, silent
      )
    end,
  },
  {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup { default = true }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'lvimuser/lsp-inlayhints.nvim',
    },
    config = function()
      -- Set up mason
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'rust_analyzer' }, -- Add other LSP servers here
      }
      local lspconfig = require 'lspconfig'
      local inlayhints = require 'lsp-inlayhints'
      -- Enable inlay hints for Rust Analyzer
      lspconfig.rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              enable = true,
              typeHints = true,
              parameterHints = true,
              chainingHints = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          inlayhints.on_attach(client, bufnr)
        end,
      }
      -- Add additional LSP server configurations here
      -- Enable inlay hints for other servers if supported
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(args.buf, true)
          end
          -- other lsp configurations you might want
        end,
      })
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- border characters
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- use neovim-remote if available
    end,
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- Adjust to your lldb-vscode path
        name = 'lldb',
      }
      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })

      -- Keybindings for nvim-dap
      vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require("dap").continue()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require("dap").step_over()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require("dap").step_into()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require("dap").step_out()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>b', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        'n',
        '<Leader>B',
        '<Cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<Leader>lp',
        '<Cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap('n', '<Leader>dr', '<Cmd>lua require("dap").repl.open()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>dl', '<Cmd>lua require("dap").run_last()<CR>', { noremap = true, silent = true })
    end,
  },
  { 'nvim-neotest/nvim-nio' },
  {
    'rcarriga/nvim-dap-ui',
    requires = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio', -- Add nvim-nio as a dependency
    },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    requires = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap' },
    config = function()
      local rt = require 'rust-tools'
      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
            vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(
            '/path/to/codelldb', -- Path to codelldb executable
            '/path/to/lldb/lib/liblldb.so' -- Path to liblldb shared library
          ),
        },
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.5
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.5
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = '1',
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'vertical',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      }
      vim.api.nvim_set_keymap('n', '<C-\\><C-n>', '<cmd>ToggleTerm direction=float<cr>', { noremap = true, silent = true })
    end,
  },
}
