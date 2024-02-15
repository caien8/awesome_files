-- [[ plug.lua ]]

return require('packer').startup({
    function(use)
  -- [[ Plugins Go Here ]]

    ---------------------
    -- Package Manager --
    ---------------------

    use('wbthomason/packer.nvim') 

    ----------------------
    -- Required plugins --
    ---------------------

    use('nvim-lua/plenary.nvim')

    -----------------------
    -- Additional Colors --
    -----------------------

    use('RRethy/nvim-base16')

    -----------------------------
    -- Startup Screen, Cursor, Icons, Lualine --
    -----------------------------

    use('Mofiqul/dracula.nvim')                     -- colorscheme

    use('mhinz/vim-startify')                       -- start screen

    use('DanilaMihailov/beacon.nvim')               -- cursor jump

    use({
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup()
        end,
    })

    use({
        'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins.lualine')
        end,
    })

    ----------
    -- DEVS --
    ----------

    -------------------
    -- File Explorer --
    -------------------

    use({
        'nvim-tree/nvim-tree.lua',
        event = 'CursorHold',
        config = function()
            require('plugins.nvim-tree')
        end,
        })
   ------------------
   -- Fuzzy Finder --
   ------------------

    use({{
        'nvim-telescope/telescope.nvim',
        event = 'CursorHold',
        config = function()
            require('plugins.telescope')
        end,
        },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          after = 'telescope.nvim',
          run = 'make',
          config = function()
              require('telescope').load_extension('fzf')
          end,
        },
        {
          'nvim-telescope/telescope-symbols.nvim',
          after = 'telescope.nvim',
          },
        })

   --------------------
   -- Code Structure --
   --------------------

   use({'majutsushi/tagbar'})                      

   ------------------
   -- Indentations --
   ------------------

   use({'Yggdroot/indentLine'})                   

   ---------------------
   -- Git Integration --
   ---------------------
   use({'tpope/vim-fugitive'})                   

   --------------------
   -- Commit History --
   --------------------
   use({'junegunn/gv.vim'})                     


  -----------------------
  -- Floating Terminal --
  -----------------------
  
  use ({'voldikss/vim-floaterm'})

  -----------------------------------
  -- LSP, Completions and Snippets --
  -----------------------------------

  use({
      'neovim/nvim-lspconfig',
      event = 'BufRead',
      config = function()
          require('plugins.lsp.servers')
      end,
          requires = {{
                    'hrsh7th/cmp-nvim-lsp',
                },},
        })

  use({
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufRead',
      config = function()
          require('plugins.lsp.null-ls')
      end,
  })

  use({{
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      config = function()
          require('plugins.lsp.nvim-cmp')
      end,
          requires = {{
                'L3MON4D3/LuaSnip',
                event = 'InsertEnter',
                config = function()
                    require('plugins.lsp.luasnip')
                end,
                requires = {{
                    'rafamadriz/friendly-snippets',
                    event = 'CursorHold',
                            },
                        },
                    },
                },
            },
            { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        })

        -- NOTE: nvim-autopairs needs to be loaded after nvim-cmp, so that <CR> would work properly
  use({
      'windwp/nvim-autopairs',
      event = 'InsertCharPre',
      after = 'nvim-cmp',
      config = function()
          require('plugins.pairs')
      end,
      })

  use({
      'j-hui/fidget.nvim',
      config = function()
          require('fidget').setup()
      end,
      })

  use({'elkowar/yuck.vim'})

    end,
    config = {
        package_root = vim.fn.stdpath('config') .. '/site/pack'
    },
})
