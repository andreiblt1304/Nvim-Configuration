-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
}
