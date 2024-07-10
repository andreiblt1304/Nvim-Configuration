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
}
