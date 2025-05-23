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
  -- {
  --   'mrcjkb/rustaceanvim',
  --   version = '^5', -- Recommended
  --   lazy = false, -- This plugin is already lazy
  -- },
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
        ensure_installed = { 'rust_analyzer', 'gopls' }, -- Add other LSP servers here
      }

      local lspconfig = require 'lspconfig'

      -- Key mapping to toggle inlay_hints.enabled
      -- vim.keymap.set('n', '<leader>ti', ToggleInlayHintsEnabled, { desc = 'Toggle Inlay Hints' })

      -- Enable inlay hints for Rust Analyzer

      require('lsp-inlayhints').setup()
      lspconfig.rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              enabled = true,
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = 'never',
              },
              lifetimeElisionHints = {
                enable = 'never',
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = 'never',
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      }
    end,
  },
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'LspAttach',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('inlay-hints').setup()
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
  { 'nvim-neotest/nvim-nio' },
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
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require('window-picker').setup()
    end,
    {
      'iamcco/markdown-preview.nvim',
      build = 'cd app && npm install',
      ft = 'markdown',
      config = function()
        vim.g.mkdp_auto_start = 1
      end,
    },
    {
      'f-person/git-blame.nvim',
      -- load the plugin at startup
      event = 'VeryLazy',
      -- Because of the keys part, you will be lazy loading this plugin.
      -- The plugin will only load once one of the keys is used.
      -- If you want to load the plugin at startup, add something like event = "VeryLazy",
      -- or lazy = false. One of both options will work.
      opts = {
        -- your configuration comes here
        -- for example
        enabled = true, -- if you want to enable the plugin
        message_template = ' <summary> • <date> • <author> • <<sha>>', -- template for the blame message, check the Message template section for more options
        date_format = '%m-%d-%Y %H:%M:%S', -- template for the date, check Date format section for more options
        virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
      },
    },
  },
}
