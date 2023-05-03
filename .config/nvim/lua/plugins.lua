-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

vim.cmd [[
  augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
          \ exe "normal g`\"" | endif
    augroup END
]]

vim.cmd [[
  augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
  augroup END
]]

vim.cmd [[
  highlight Bookmark ctermfg=NONE ctermbg=160
  highlight BookmarkSign ctermfg=194 ctermbg=NONE
]]

vim.cmd [[
  function! TriggerFlutterHotReload() abort
    silent execute '!kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")'
  endfunction
  autocmd! BufWritePost *.dart call TriggerFlutterHotReload()
]]

local packer = nil
local function init()
  if packer == nil then
    packer = require 'packer'
    packer.init {
      max_jobs=50,
      disable_commands = true,
      display = {
        open_fn = function()
          local result, win, buf = require('packer.util').float {
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
          }
          vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
          return result, win, buf
        end,
      },
    }
  end

  local use = packer.use
  packer.reset()


  use { 'wbthomason/packer.nvim', opt = true }
  use { 'nvim-lua/popup.nvim' }
  use { 'nvim-lua/plenary.nvim' }
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require'nvim-web-devicons'.setup {
        default = true
      }
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
      -- ensure_installed = { 'http', 'json' },
      -- after = { colorscheme },
      config = function()
        require'nvim-treesitter.configs'.setup {
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
          },
          refactor = {
            highlight_definitions = {
              enable = true,
              clear_on_cursor_move = true,
            },
            highlight_current_scope = {
              enable = true,
              -- clear_on_cursor_move = true,
            },
            smart_rename = {
              enable = false
            },
            navigation = {
              enable = false
            }
          },
          context_commentstring = {
            enable = true,
            tree_setter = {
              enable = true
            }
          },
          autotag = {
            enable = true,
            -- filetypes = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'markdown', 'xml' },
            -- skip_tags = {
            --   'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
            --   'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
            -- }
          },
          pairs = {
            enable = false
          },
          rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 300,
            colors = {
              '#68a0b0',
              '#946ead',
              '#c7aa6d',
            },
            -- termcolors = {}
          },
          matchup = {
            enable = true,
            disable = { 'c', 'ruby' }
          },
          endwise = {
            enable = true
          },
          indent = {
            enable = false,
            disable = { 'python' }
          },
          yati = {
            enable = true,
            disable = { 'markdown' }
          }
        }
      end
  }
  use {
    'nvim-treesitter/nvim-treesitter-refactor',
    after = { 'nvim-treesitter' }
  }
  use {
    'nathom/filetype.nvim',
    config = function ()
      require('filetype').setup({
        overrides = {
        extensions = {
          -- Set the filetype of *.pn files to potion
          pn = "potion",
        },
        literal = {
          -- Set the filetype of files named "MyBackupFile" to lua
          MyBackupFile = "lua",
        },
        complex = {
          -- Set the filetype of any full filename matching the regex to gitconfig
          [".*git/config"] = "gitconfig", -- Included in the plugin
        },

        -- The same as the ones above except the keys map to functions
        function_extensions = {
          ["cpp"] = function()
            vim.bo.filetype = "cpp"
            -- Remove annoying indent jumping
            vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
          end,
          ["pdf"] = function()
            vim.bo.filetype = "pdf"
            -- Open in PDF viewer (Skim.app) automatically
            vim.fn.jobstart(
            "open -a skim " .. '"' .. vim.fn.expand("%") .. '"'
        )
    end,
  },
  function_literal = {
    Brewfile = function()
      vim.cmd("syntax off")
    end,
  },
  function_complex = {
    ["*.math_notes/%w+"] = function()
      vim.cmd("iabbrev $ $$")
    end,
  },

  shebang = {
    -- Set the filetype of files with a dash shebang to sh
    dash = "sh",
  },
  },
      })
    end
  }
  use { 'kkharji/sqlite.lua' }
  use {
    'nvim-lualine/lualine.nvim',
    -- after = colorscheme,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require'auto-session'.setup {
        log_level = 'error',
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"}
      }
    end
  }
  use {
    'akinsho/bufferline.nvim',
    tag = "v2.*",
    after = { 'aura-theme'},
    requires = 'kyazdani42/nvim-web-devicons',
    config = function ()
      require('bufferline').setup {
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
          right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
          left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon' -- 'icon' | 'underline' | 'none'
          },
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          --- name_formatter can be used to change the buffer's label in the bufferline.
          --- Please note some names can/will break the
          --- bufferline so use this at your discretion knowing that it has
          --- some limitations that will *NOT* be fixed.
          name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match('%.md') then
                return vim.fn.fnamemodify(buf.name, ':t:r')
            end
          end,
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          tab_size = 18,
          diagnostics = 'coc', -- false | "nvim_lsp" | "coc",
          diagnostics_update_in_insert = false,
          -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
          end,
                      -- NOTE: this will be called a lot so don't do any heavy processing here
          custom_filter = function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
              return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
              return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
              return true
            end
            -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
              return true
            end
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true
            }
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_buffer_default_icon = false, -- whether or not an unrecognised filetype should show a default icon
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          -- can also be a table containing 2 custom separators
          -- [focused and unfocused]. eg: { '|', '|' }
          separator_style = 'thin', -- "slant" | "thick" | "thin",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          sort_by = 'insert_after_current', -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
            -- add custom logic
            -- return buffer_a.modified > buffer_b.modified
          -- end
          highlights = {
            buffer_selected = {
              -- fg = '#5effca',
              -- bd = '#15141b'
            }
          }
        }
      }
    end
  }
  use {
    'famiu/bufdelete.nvim',
  }
  use {
    'AndrewRadev/linediff.vim',
    cmd = { 'Linediff' }
  }
  use {
    'petertriho/nvim-scrollbar',
    -- after = { colorscheme },
    config = function()
      require'scrollbar'.setup {
        show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
      max_lines = false, -- disables if no. of lines in buffer exceeds this
      handle = {
        text = " ",
        color = nil,
        cterm = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
      },
      marks = {
        Search = {
          text = { "-", "=" },
          priority = 0,
          color = nil,
          cterm = nil,
          highlight = "Search",
        },
        Error = {
          text = { "-", "=" },
          priority = 1,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextError",
      },
        Warn = {
          text = { "-", "=" },
          priority = 2,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 3,
          color = nil,
          cterm = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
            priority = 4,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 5,
          color = nil,
          cterm = nil,
          highlight = "Normal",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
        clear = {
          "BufWinLeave",
          "TabLeave",
          "TermLeave",
          "WinLeave",
        },
      },
      handlers = {
          diagnostic = true,
          search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
      },
      }
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    -- event = 'VimEnter',
    config = function()
      require'indent_blankline'.setup {
        show_current_context = true,
        show_current_context_start = true,
        show_end_of_line = true,
        space_char_blankline = ' ',
        -- char_highlight_list = {
        --     'IndentBlanklineIndent1',
        --     'IndentBlanklineIndent2',
        --     'IndentBlanklineIndent3',
        --     'IndentBlanklineIndent4',
        --     'IndentBlanklineIndent5',
        --     'IndentBlanklineIndent6'
        -- }
      }
    end
  }
  use {
    'nmac427/guess-indent.nvim',
    config = function()
      require'guess-indent'.setup {
        auto_cmd = true, -- Set to false to disable automatic execution
        filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
          'netrw',
          'tutor'
        },
        buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
          'help',
          'nofile',
          'terminal',
          'prompt'
        }
      }
    end
  }
  use {
    'yioneko/nvim-yati',
    requires = 'nvim-treesitter/nvim-treesitter',
  }
  use {
    'yamatsum/nvim-cursorline',
    config = function()
      require'nvim-cursorline'.setup {
        cursorline = {
          enable = true,
          timeout = 500,
          number = false
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true }
        }
      }
    end
  }
  use {
    'p00f/nvim-ts-rainbow',
  }
  use {
    'windwp/nvim-autopairs',
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
        -- ignored_next_char = [=[[%w%%%'%[%"%.]]=]
      })
    end
  }
  use {
    'kylechui/nvim-surround',
    -- event = 'VimEnter'
    tag = '*',
    config = function()
      require('nvim-surround').setup()
    end
  }
  -- use { 'alvan/vim-closetag' }
  use { 'gregsexton/MatchTag' }
  use {
  'mvllow/modes.nvim',
  -- after = 'VimEnter',
    config = function()
      require'modes'.setup {
        colors = {
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#9745be",
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
      }
    end
  }
  use { 'myusuf3/numbers.vim' }
  use {
    'folke/which-key.nvim',
    -- event = 'VimEnter'
    config = function ()
      require('which-key').setup({
        plugins = {
          presets = {
            operators = false
          }
        }
      })
    end
  }
  use { 'simeji/winresizer' }
  -- use { 'mrjones2014/legendary.nvim' }
  use {
    'folke/trouble.nvim',
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        auto_open = true,
        auto_close = true,
        auto_preview = true,
        use_diagnostic_signs = true
      }
    end
  }
  use {
    'EthanJWright/toolwindow.nvim',
    requires = {{ 'akinsho/toggleterm.nvim', event = 'VimEnter' }},
    -- after = { 'trouble.nvim', },
    config = function()
      require'toolwindow'
    end
  }
  use {
    'tyru/open-browser.vim',
    cmd = { 'OpenBrowser' }
  }
  use {
    'tyru/open-browser-github.vim',
    after = 'open-browser.vim'
  }
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }
  use { 'thinca/vim-ref' }
  -- use {
  --   'sindrets/diffview.nvim',
  --   requires = 'nvim-lua/plenary.nvim',
      -- event = 'VimEnter'
  -- }
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require'gitsigns'.setup {
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
          change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm = {
          enable = false
        }
      }
    end

  }
  use { 'rhysd/git-messenger.vim' }
  use {
    'akinsho/git-conflict.nvim',
    config = function()
      require'git-conflict'.setup{
        default_mappings = true,
        disable_diagnostics = false,
        highlights = {
          incoming = 'DiffText',
          current = 'DiffAdd'
        }
      }
    end
  }
  -- use {
  --   'pwntester/octo.nvim',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-telescope/telescope.nvim',
  --     'kyazdani42/nvim-web-devicons'
  --   },
  --   after = 'telescope.nvim',
  --   config = function()
  --     require'octo'.setup {
  --       default_remote = {"upstream", "origin"}; -- order to try remotes
  --       ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
  --       reaction_viewer_hint_icon = "";         -- marker for user reactions
  --       user_icon = " ";                        -- user icon
  --       timeline_marker = "";                   -- timeline marker
  --       timeline_indent = "2";                   -- timeline indentation
  --       right_bubble_delimiter = "";            -- Bubble delimiter
  --       left_bubble_delimiter = "";             -- Bubble delimiter
  --       github_hostname = "";                    -- GitHub Enterprise host
  --       snippet_context_lines = 4;               -- number or lines around commented lines
  --       file_panel = {
  --         size = 10,                             -- changed files panel rows
  --         use_icons = true
  --       }
  --     }
  --   end
  -- }
  use { 'mattn/emmet-vim' }
  use {
    'norcalli/nvim-colorizer.lua',
    -- event = 'VimEnter',
    config = function()
        require'colorizer'.setup()
        --     'css';
        --     'javascript';
        --     html = { mode = 'background' };
        -- }, { mode = 'foreground' })
    end
  }
  use {
    'windwp/nvim-ts-autotag',
    requires = {{ 'nvim-treesitter/nvim-treesitter', opt = true }},
    after = 'nvim-treesitter'
  }
  use {
    'm-demare/hlargs.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function ()
      require('hlargs').setup {
        color = '#ef9062',
        highlight = {},
        excluded_filetypes = {},
        -- disable = function(lang, bufnr)
        --   return vim.tbl_contains(opts.excluded_filetypes, lang)
        -- end,
        paint_arg_declarations = true,
        paint_arg_usages = true,
        paint_catch_blocks = {
          declarations = false,
          usages = false
        },
        hl_priority = 10000,
        excluded_argnames = {
          declarations = {},
          usages = {
            python = { 'self', 'cls' },
            lua = { 'self' }
          }
        },
        performance = {
          parse_delay = 1,
          slow_parse_delay = 50,
          max_iterations = 400,
          max_concurrent_partial_parses = 30,
          debounce = {
            partial_parse = 3,
            partial_insert_mode = 100,
            total_parse = 700,
            slow_parse = 5000
          }
        }
      }
      require('hlargs').enable()
    end
  }
  use {
    'MunifTanjim/nui.nvim',
  }
  use {
    'bennypowers/nvim-regexplainer',
    after = 'nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'MuniTanjim/nui.nvim'
    },
    config = function()
      require('regexplainer').setup()
    end
  }
  use {
    'alaviss/nim.nvim',
    ft = { 'nim' }
  }
  use { 'prabirshrestha/asyncomplete.vim' }
  use { 'jsborjesson/vim-uppercase-sql' }
  use {
    'iamcco/markdown-preview.nvim',
    run = "cd app && yarn install",
    cmd = 'MarkdownPreview',
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }
  }
  use {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModeEnable'
  }
  -- use {
  --   'steelsojka/headwind.nvim',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('headwind').setup {
  --       -- sort_tailwind_classes = require 'headwind.default_sort_order',
  --       -- class_regex = require 'headwind.class_regex',
  --       -- run_on_save = true,
  --       -- remove_duplicates = true,
  --       -- use_treesitter = true
  --     }
  --   end
  -- }
  use { 'delphinus/vim-firestore' }
  use { 'jparise/vim-graphql' }
  use {
    'MattesGroeger/vim-bookmarks',
    -- cmd = { 'BookmarkToggle' }
  }
  use {
    'tom-anders/telescope-vim-bookmarks.nvim',
    after = 'telescope.nvim',
    config = function ()
      require('telescope').load_extension('vim_bookmarks')
    end
  }
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup {

      }
      -- event = 'VimEnter'
    end
  }
  use {
    'nvim-telescope/telescope-file-browser.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('file_browser')
    end
  }
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    -- opt = true,
    -- cmd = 'ToggleTerm',
    config = function()
      require("toggleterm").setup{
        direction = 'float',
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        close_on_exit = true,
        -- shell = vim.o.fish,
        hidden = true
      }
    end
  }
  use {
    'baliestri/aura-theme',
    rtp = 'packages/neovim',
    after = 'nvim-treesitter',
    config = function()
      vim.cmd('colorscheme aura-soft-dark')
    end
  }
  use {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require'hop'.setup {
          -- keys = 'etovxqpdygfblzhckisuran'
      }
    end
  }
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {
        ignore_case = false,
        jump_to_unique_chars = { safety_timeout = 400 },
        safe_labels = {},
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = false,
        substitute_chars = { ['\r'] = '¬', },
        limit_ft_matches = 5,
        repeat_ft_with_target_char = false
      }
    end
  }
  use {
    'andymass/vim-matchup',
    after = 'nvim-treesitter'
  }
  use {
    'tyru/columnskip.vim',
    -- event = 'VimEnter'
  }
  use { 'matze/vim-move' }
  use {
    'bkad/CamelCaseMotion',
    -- event = 'VimEnter'
  }
  use { 'unblevable/quick-scope' }
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      'nvim-lua/plenary.nvim',
      -- 'nvim-telescope/telescope-ghq.nvim',
    },
    config = function()
      require'telescope'.setup {
        extensions = {
          file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
              },
              ["n"] = {
                -- your custom normal mode mappings
              },
            },
          },
          frecency = {
            -- db_root = "home/my_username/path/to/db_root",
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
            disable_devicons = false,
            workspaces = {
              ["conf"]    = "/home/my_username/.config",
              ["data"]    = "/home/my_username/.local/share",
              -- ["project"] = "/home/my_username/projects",
              -- ["wiki"]    = "/home/my_username/wiki"
            }
          },
          media_files = {
            filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
            find_cmd = 'rg'
          },
          command_palette = {
            {"File",
              { "entire selection (C-a)", ':call feedkeys("GVgg")' },
              { "save current file (C-s)", ':w' },
              { "save all files (C-A-s)", ':wa' },
              { "quit (C-q)", ':qa' },
              { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
              { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
              { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
              { "files (C-f)",     ":lua require('telescope.builtin').find_files()", 1 },
          },
            {"Help",
              { "tips", ":help tips" },
              { "cheatsheet", ":help index" },
              { "tutorial", ":help tutor" },
              { "summary", ":help summary" },
              { "quick reference", ":help quickref" },
              { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
            },
            {"Vim",
              { "reload vimrc", ":source $MYVIMRC" },
              { 'check health', ":checkhealth" },
              { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
              { "commands", ":lua require('telescope.builtin').commands()" },
              { "command history", ":lua require('telescope.builtin').command_history()" },
              { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
              { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
              { "vim options", ":lua require('telescope.builtin').vim_options()" },
              { "keymaps", ":lua require('telescope.builtin').keymaps()" },
              { "buffers", ":Telescope buffers" },
              { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
              { "paste mode", ':set paste!' },
              { 'cursor line', ':set cursorline!' },
              { 'cursor column', ':set cursorcolumn!' },
              { "spell checker", ':set spell!' },
              { "relative number", ':set relativenumber!' },
              { "search highlighting (F12)", ':set hlsearch!' },
            }
          }
        }
      }
        -- require'telescope'.load_extension 'ghq'
    end
  }
  -- use {
  --   'nvim-telescope/telescope-packer.nvim',
  --   after = 'telescope.nvim',
  --   config = function()
  --     require'telescope'.load_extension 'packer'
  --   end
  -- }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    after = 'telescope.nvim',
    config = function()
      require'telescope'.load_extension('frecency')
    end,
    requires = { 'tami5/sqlite.lua' }
  }
  use {
    'LinArcX/telescope-command-palette.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').setup {
        require('telescope').load_extension('command_palette')
      }
    end
  }
  -- use {
  --   'nvim-telescope/telescope-github.nvim',
  --   after = 'telescope.nvim',
  --   config = function()
  --     require('telescope').load_extension('gh')
  --   end
  -- }
  use {
    'nvim-telescope/telescope-media-files.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('media_files')
    end
  }
  use {
    'gelguy/wilder.nvim',
    -- keys = {
    --     { 'n', ':' },
    --     { 'n', '/' },
    --     { 'n', '?' },
    -- },
    config = function()
    end
  }
  use {
    'haya14busa/vim-asterisk',
  }
  use { 'thinca/vim-visualstar' }
  -- use { 'jremmen/vim-ripgrep' }
  use { 'vim-scripts/ReplaceWithRegister' }
  use {
    'numToStr/Comment.nvim',
    -- event = 'VimEnter',
    config = function()
      require'Comment'.setup {
          ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
          ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
          extended = false,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
              }
    end
  }
  use { 'vigoux/architext.nvim' }
  use { 'wellle/targets.vim' }
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = { 'nvim-treesitter' }
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { 'TSContextEnable' },
    after = { 'nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true,
      }
    end
  }
  use { 'LudoPinelli/comment-box.nvim' }
  use { 'terryma/vim-multiple-cursors' }
  use {
    'tversteeg/registers.nvim',
    keys = {
      { 'n', '"' },
      { 'i', '<leader>rp' },
    },
  }
  -- use {
  --   'nvim-neotest/neotest',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     'antoinemadec/FixCursorHold.nvim',
  --   },
  --   config = function ()
  --     require'neotest'.setup({
  --     })
  --   end
  -- }
  use { 'sentriz/vim-print-debug' }
  use {
    'mfussenegger/nvim-dap',
    -- event = 'VimEnter'
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    after = 'nvim-dap',
    config = function()
      require('dapui').setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7"),
        layouts = {
          {
            elements = {
            -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        }
      })
    end
  }
  use {
    'theHamsta/nvim-dap-virtual-text',
    after = 'nvim-dap',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end
  }
  use {
    'nvim-telescope/telescope-dap.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('dap')
    end
  }
  use { 'tpope/vim-repeat' }
  use {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function()
      require('luasnip/loaders/from_vscode').load()
    end,
    -- 'rafamadriz/friendly-snippets',
  }
  use { 'rafamadriz/friendly-snippets' }
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    run = 'yarn install --frozen-lockfile'
  }
  use { 'tsuyoshicho/vim-efm-langserver-settings' }
  use { 'github/copilot.vim' }
  use {
    'mizlan/iswap.nvim',
    config = function()
      require'iswap'.setup {
        -- The keys that will be used as a selection, in order
        -- ('asdfghjklqwertyuiopzxcvbnm' by default)
        keys = 'qwertyuiop',

        -- Grey out the rest of the text when making a selection
        -- (enabled by default)
        grey = 'disable',

        -- Highlight group for the sniping value (asdf etc.)
        -- default 'Search'
        hl_snipe = 'ErrorMsg',

        -- Highlight group for the visual selection of terms
        -- default 'Visual'
        hl_selection = 'WarningMsg',

        -- Highlight group for the greyed background
        -- default 'Comment'
        hl_grey = 'LineNr',

        -- Post-operation flashing highlight style,
        -- either 'simultaneous' or 'sequential', or false to disable
        -- default 'sequential'
        flash_style = false,

        -- Highlight group for flashing highlight afterward
        -- default 'IncSearch'
        hl_flash = 'ModeMsg',

        -- Move cursor to the other element in ISwap*With commands
        -- default false
        move_cursor = true,

        -- Automatically swap with only two arguments
        -- default nil
        autoswap = true,

        -- Other default options you probably should not change:
        debug = nil,
        hl_grey_priority = '1000',
      }
    end
  }
  use { 'heavenshell/vim-jsdoc' }
  use { 'pantharshit00/vim-prisma' }
  use { 'antoinemadec/FixCursorHold.nvim' }
  -- use {
  --   'ThePrimeagen/refactoring.nvim',
  --   config = function()
  --     require('refactoring').setup {
  --       requires = {
  --         { 'nvim-lua/plenary.nvim' },
  --         { 'nvim-treesitter/nvim-treesitter' },
  --       }
  --     }
  --   end
  -- }
  use {
    'NTBBloodbath/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'rest-nvim'.setup {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
              -- Encode URL before making request
              encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to nil if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          }
        },
          -- Jump to request line on run
          jump_to_request = false,
          env_file = '.env',
          custom_dynamic_variables = {},
          yank_dry_run = true,
        }
    end
  }
  -- use {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   after = 'plenary.nvim',
  --   config = function()
  --     require('null-ls').setup({
  --       sources = {
  --         require('null-ls').builtins.formatting.stylua,
  --         require('null-ls').builtins.formatting.eslint,
  --         require('null-ls').builtins.formatting.spell
  --       }
  --     })
  --   end
  -- }
  use { 'mhartington/formatter.nvim' }
  use { 'Pocco81/AbbrevMan.nvim' }
  use { 'editorconfig/editorconfig-vim' }
  use { 'wakatime/vim-wakatime' }
  use { 'vim-jp/vimdoc-ja' }
  use { 'is0n/jaq-nvim' }
  use {
    'jghauser/mkdir.nvim',
    -- event = 'VimEnter'
  }
  use { 'segeljakt/vim-silicon' }
  use { 'MTDL9/vim-log-highlighting' }
  use {
    'sudormrfbin/cheatsheet.nvim',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    after = 'telescope.nvim',
  }
  -- use { 'michaelb/sniprun' }
  use {
    'karb94/neoscroll.nvim',
    config = function()
      require'neoscroll'.setup {
        mappings = {
          '<C-u>',
          '<C-d>',
          -- '<C-b>',
          -- '<C-f>',
          -- 'zt',
          -- 'zz',
          -- 'zb',
        },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false
      }
    end
  }
  -- use {
  --   'cappyzawa/trim.nvim',
  --   config = function()
  --     require'trim'.setup {
  --       -- list of filetypes to ignore
  --       exclude = {},
  --
  --       -- list of filetypes to trim on save
  --       include = {},
  --
  --       -- list of patterns to trim
  --       patterns = {
  --         [[%s/\s\+$//e]],           -- remove unwanted spaces
  --         -- remove trailing whitespace
  --         [[\s+$]],
  --         [[%s/\%^\n\+//]],          -- trim first line
  --         -- remove empty lines at the end of the file
  --         [[\n+\%$]],
  --       },
  --     }
  --   end
  -- }
  use {
    'sQVe/sort.nvim',
    config = function()
      require('sort').setup({
      })
    end
  }
  -- use {
  --   'b0o/incline.nvim',
  --   config = function()
  --     require('incline').setup {
  --       debounce_threshold = {
  --         falling = 50,
  --         rising = 10
  --       },
  --       hide = {
  --         cursorline = false,
  --         focused_win = false,
  --         only_win = false
  --       },
  --       highlight = {
  --         groups = {
  --           InclineNormal = {
  --             default = true,
  --             group = 'NormalFloat'
  --           },
  --           InclineNormalNC = {
  --             default = true,
  --             group = 'NormalFloat'
  --           }
  --         }
  --       },
  --       ignore = {
  --         buftypes = 'special',
  --         filetypes = {},
  --         floating_wins = true,
  --         unlisted_buffers = true,
  --         wintypes = 'special'
  --       },
  --       render = 'basic',
  --       window = {
  --         margin = {
  --           horizontal = { left = 1, right = 1 },
  --           vertical = { bottom = 1, top = 1 },
  --         },
  --         options = {
  --           signcolumn = 'no',
  --           wrap = false
  --         },
  --         padding = { left = 1, right = 1 },
  --         padding_char = ' ',
  --         placement = {
  --           horizontal = 'right',
  --           vertical = 'top'
  --         },
  --         width = 'fit',
  --         winhighlight = {
  --           active = {
  --             EndOfBuffer = 'None',
  --             Normal = 'InclineNormal',
  --             Search = 'None'
  --           },
  --           inactive = {
  --             EndOfBuffer = 'None',
  --             Normal = 'InclineNormalNC',
  --             Search = 'None'
  --           }
  --         },
  --         zindex = 100
  --       }
  --     }
  --   end
  -- }
  use {
    'axieax/urlview.nvim',
    config = function()
      require('urlview').setup({
          -- Prompt title (`<context> <default_title>`, e.g. `Buffer Links:`)
        default_title = "Links:",
        -- Default picker to display links with
        -- Options: "native" (vim.ui.select) or "telescope"
        default_picker = "native",
        -- Set the default protocol for us to prefix URLs with if they don't start with http/https
        default_prefix = "https://",
        -- Command or method to open links with
        -- Options: "netrw", "system" (default OS browser); or "firefox", "chromium" etc.
        -- By default, this is "netrw", or "system" if netrw is disabled
        default_action = "netrw",
        -- Ensure links shown in the picker are unique (no duplicates)
        unique = true,
        -- Ensure links shown in the picker are sorted alphabetically
        sorted = true,
        log_level_min = "warn"
      })
    end
  }
  -- use {
  --   'Pocco81/auto-save.nvim',
  --   config = function()
  --     require('auto-save').setup({
  --       enabled = true,
  --       execution_message = 'AutoSave: saved at ' .. vim.fn.strftime("%H:%M:%S"),
  --       trigger_events = { "InsertLeave", "TextChanged" },
  --       conditions = {
  --         exists = true,
  --         filetype_is_not = {},
  --         modifiable = true
  --       },
  --       write_all_buffers = false,
  --       on_off_commands = true,
  --       clean_command_line_interval = 0,
  --       debounce_delay = 135
  --     })
  --   end
  -- }

end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

-- vim.cmd [[packadd packer.nvim]]

-- require'packer'.init({
--   max_jobs=50
-- })

-- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#e06c75 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#e5c07b gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98c379 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56b6c2 gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61afef gui=nocombine]]
-- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#c678dd gui=nocombine]]

-- vim.cmd([[ autocmd FileType * highlight rainbowcol1 guifg=#FF7B72 gui=bold ]])

-- vim.cmd [[
--   autocmd ColorScheme * hi Search guibg=#15141b guifg=#ffca85
--   autocmd ColorScheme * hi incSearch guibg=#a277ff guifg=#15141b
--   autocmd ColorScheme * hi menu guibg=#15141b guifg=#edecee
--   autocmd ColorScheme * hi PmenuSel guibg=#a277ff guifg=#15141b
--   autocmd ColorScheme * hi PmenuSbar guibg=#15141b guifg=#edecee
--   autocmd ColorScheme * hi PmenuThumb guibg=#15141b guifg=#edecee
--   autocmd ColorScheme * hi Wildmenu guibg=#a277ff guifg=#edecee
-- ]]

-- require('packer').startup(function(use)
--   -- Packer can manage itself
--   use { 'wbthomason/packer.nvim', opt = true }
--   use { 'nvim-lua/popup.nvim' }
--   use { 'nvim-lua/plenary.nvim' }
--   use {
-- 	  'kyazdani42/nvim-web-devicons',
-- 	  config = function()
-- 		  require'nvim-web-devicons'.setup {
-- 			  default = true
-- 		  }
-- 	  end
--   }
--   use {
-- 	  'nvim-treesitter/nvim-treesitter',
-- 	  run = ':TSUpdate',
--       -- ensure_installed = { 'http', 'json' },
--       -- after = { colorscheme },
--       config = function()
--         require'nvim-treesitter.configs'.setup {
--           auto_install = true,
--           highlight = {
--             enable = true
--           },
--           refactor = {
--             highlight_definitions = {
--               enable = true,
--               clear_on_cursor_move = true,
--             },
--             highlight_current_scope = {
--               enable = true,
--               -- clear_on_cursor_move = true,
--             },
--           },
--           context_commentstring = {
--             enable = true
--           },
--           autotag = {
--             enable = true,
--             -- filetypes = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'markdown', 'xml' },
--             -- skip_tags = {
--             --   'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
--             --   'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
--             -- }
--           },
--           rainbow = {
--             enable = true,
--             extended_mode = true,
--             max_file_lines = 300,
--             colors = {
--               '#68a0b0',
--               '#946ead',
--               '#c7aa6d',
--             },
--             -- termcolors = {}
--           },
--           matchup = {
--             enable = true,
--             disable = { 'c', 'ruby' }
--           }
--         }
--       end
--   }
--   use {
--     'nvim-treesitter/nvim-treesitter-refactor',
--     after = { 'nvim-treesitter' }
--   }
--   use {
--     'nathom/filetype.nvim',
--     config = function ()
--       require('filetype').setup({
--         overrides = {
--         extensions = {
--           -- Set the filetype of *.pn files to potion
--           pn = "potion",
--         },
--         literal = {
--           -- Set the filetype of files named "MyBackupFile" to lua
--           MyBackupFile = "lua",
--         },
--         complex = {
--           -- Set the filetype of any full filename matching the regex to gitconfig
--           [".*git/config"] = "gitconfig", -- Included in the plugin
--         },
--
--         -- The same as the ones above except the keys map to functions
--         function_extensions = {
--           ["cpp"] = function()
--               vim.bo.filetype = "cpp"
--               -- Remove annoying indent jumping
--               vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
--           end,
--           ["pdf"] = function()
--               vim.bo.filetype = "pdf"
--               -- Open in PDF viewer (Skim.app) automatically
--               vim.fn.jobstart(
--                   "open -a skim " .. '"' .. vim.fn.expand("%") .. '"'
--         )
--       end,
--   },
--   function_literal = {
--     Brewfile = function()
--       vim.cmd("syntax off")
--     end,
--   },
--   function_complex = {
--     ["*.math_notes/%w+"] = function()
--       vim.cmd("iabbrev $ $$")
--     end,
--   },
--
--   shebang = {
--     -- Set the filetype of files with a dash shebang to sh
--     dash = "sh",
--   },
--   },
--       })
--     end
--   }
--   use { 'kkharji/sqlite.lua' }
--   use {
-- 	  'nvim-lualine/lualine.nvim',
--     -- after = colorscheme,
-- 	  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
--   }
--   use {
--     'rmagatti/auto-session',
--     config = function()
--       require'auto-session'.setup {
--         log_level = 'error',
--         auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"}
--       }
--     end
--   }
--   use {
--     'akinsho/bufferline.nvim',
--     tag = "v2.*",
--     -- after = colorscheme,
--     requires = 'kyazdani42/nvim-web-devicons',
--     config = function ()
--       require('bufferline').setup {
--         options = {
--           mode = "buffers", -- set to "tabs" to only show tabpages instead
--           -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
--           close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
--           right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
--           left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
--           middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
--           indicator = {
--             icon = '▎', -- this should be omitted if indicator style is not 'icon'
--             style = 'icon' -- 'icon' | 'underline' | 'none'
--           },
--           buffer_close_icon = '',
--           modified_icon = '●',
--           close_icon = '',
--           left_trunc_marker = '',
--           right_trunc_marker = '',
--           --- name_formatter can be used to change the buffer's label in the bufferline.
--           --- Please note some names can/will break the
--           --- bufferline so use this at your discretion knowing that it has
--           --- some limitations that will *NOT* be fixed.
--           name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
--             -- remove extension from markdown files for example
--             if buf.name:match('%.md') then
--                 return vim.fn.fnamemodify(buf.name, ':t:r')
--             end
--           end,
--           max_name_length = 18,
--           max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
--           tab_size = 18,
--           diagnostics = 'coc', -- false | "nvim_lsp" | "coc",
--           diagnostics_update_in_insert = false,
--           -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
--           diagnostics_indicator = function(count, level, diagnostics_dict, context)
--             return "("..count..")"
--           end,
--                       -- NOTE: this will be called a lot so don't do any heavy processing here
--           custom_filter = function(buf_number, buf_numbers)
--             -- filter out filetypes you don't want to see
--             if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
--               return true
--             end
--             -- filter out by buffer name
--             if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
--               return true
--             end
--             -- filter out based on arbitrary rules
--             -- e.g. filter out vim wiki buffer from tabline in your work repo
--             if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
--               return true
--             end
--             -- filter out by it's index number in list (don't show first buffer)
--             if buf_numbers[1] ~= buf_number then
--               return true
--             end
--           end,
--           offsets = {
--             {
--               filetype = "NvimTree",
--               text = "File Explorer",
--               text_align = "left",
--               separator = true
--             }
--           },
--           color_icons = true,
--           show_buffer_icons = true,
--           show_buffer_close_icons = false,
--           show_buffer_default_icon = false, -- whether or not an unrecognised filetype should show a default icon
--           show_close_icon = false,
--           show_tab_indicators = true,
--           persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
--           -- can also be a table containing 2 custom separators
--           -- [focused and unfocused]. eg: { '|', '|' }
--           separator_style = 'thin', -- "slant" | "thick" | "thin",
--           enforce_regular_tabs = true,
--           always_show_bufferline = true,
--           sort_by = 'insert_after_current', -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
--             -- add custom logic
--             -- return buffer_a.modified > buffer_b.modified
--           -- end
--           highlights = {
--             buffer_selected = {
--               -- fg = '#5effca',
--               -- bd = '#15141b'
--             }
--           }
--         }
--       }
--     end
--   }
--   use {
--     'famiu/bufdelete.nvim',
--     -- event = 'VimEnter'
--   }
--   -- use {
--   --   'kwkarlwang/bufresize.nvim',
--   --   config = function ()
--   --     require('bufresize').setup()
--   --   end
--   -- }
--   use {
--     'AndrewRadev/linediff.vim'
--   }
--   use {
--     'petertriho/nvim-scrollbar',
--     -- after = { colorscheme },
--     config = function()
--       require'scrollbar'.setup {
--         show = true,
--       show_in_active_only = false,
--       set_highlights = true,
--       folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
--       max_lines = false, -- disables if no. of lines in buffer exceeds this
--       handle = {
--         text = " ",
--         color = nil,
--         cterm = nil,
--         highlight = "CursorColumn",
--         hide_if_all_visible = true, -- Hides handle if all lines are visible
--       },
--       marks = {
--           Search = {
--               text = { "-", "=" },
--               priority = 0,
--               color = nil,
--               cterm = nil,
--               highlight = "Search",
--           },
--           Error = {
--               text = { "-", "=" },
--               priority = 1,
--               color = nil,
--               cterm = nil,
--               highlight = "DiagnosticVirtualTextError",
--           },
--           Warn = {
--               text = { "-", "=" },
--               priority = 2,
--               color = nil,
--               cterm = nil,
--               highlight = "DiagnosticVirtualTextWarn",
--           },
--           Info = {
--               text = { "-", "=" },
--               priority = 3,
--               color = nil,
--               cterm = nil,
--               highlight = "DiagnosticVirtualTextInfo",
--           },
--           Hint = {
--             text = { "-", "=" },
--               priority = 4,
--               color = nil,
--               cterm = nil,
--               highlight = "DiagnosticVirtualTextHint",
--           },
--           Misc = {
--               text = { "-", "=" },
--               priority = 5,
--               color = nil,
--               cterm = nil,
--               highlight = "Normal",
--           },
--       },
--       excluded_buftypes = {
--           "terminal",
--       },
--       excluded_filetypes = {
--           "prompt",
--           "TelescopePrompt",
--       },
--       autocmd = {
--         render = {
--           "BufWinEnter",
--           "TabEnter",
--           "TermEnter",
--           "WinEnter",
--           "CmdwinLeave",
--           "TextChanged",
--           "VimResized",
--           "WinScrolled",
--         },
--         clear = {
--           "BufWinLeave",
--           "TabLeave",
--           "TermLeave",
--           "WinLeave",
--         },
--       },
--       handlers = {
--           diagnostic = true,
--           search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
--       },
--       }
--     end
--   }
--   use {
--     'lukas-reineke/indent-blankline.nvim',
--     -- event = 'VimEnter',
--     config = function()
--       require'indent_blankline'.setup {
--         show_current_context = true,
--         show_current_context_start = true,
--         show_end_of_line = true,
--         space_char_blankline = ' ',
--         -- char_highlight_list = {
--         --     'IndentBlanklineIndent1',
--         --     'IndentBlanklineIndent2',
--         --     'IndentBlanklineIndent3',
--         --     'IndentBlanklineIndent4',
--         --     'IndentBlanklineIndent5',
--         --     'IndentBlanklineIndent6'
--         -- }
--       }
--     end
--   }
--   -- use {
--   --   'nmac427/guess-indent.nvim',
--   --   config = function()
--   --     require'guess-indent'.setup {
--   --       auto_cmd = true, -- Set to false to disable automatic execution
--   --       filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
--   --         'netrw',
--   --         'tutor'
--   --       },
--   --       buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
--   --         'help',
--   --         'nofile',
--   --         'terminal',
--   --         'prompt'
--   --       }
--   --     }
--   --   end
--   -- }
--   -- use { 'xiyaowong/nvim-cursorword' }
--   use {
--     'yamatsum/nvim-cursorline',
--     config = function()
--       require'nvim-cursorline'.setup {
--         cursorline = {
--           enable = true,
--           timeout = 500,
--           number = false
--         },
--         cursorword = {
--           enable = true,
--           min_length = 3,
--           hl = { underline = true }
--         }
--       }
--     end
--   }
--   use {
--     'p00f/nvim-ts-rainbow',
--   }
--   use {
--       'windwp/nvim-autopairs',
--       tag = "*", -- Use for stability; omit to use `main` branch for the latest features
--       -- event = 'VimEnter',
--       config = function()
--         require("nvim-surround").setup({
--         -- Configuration here, or leave empty to use defaults
--           -- ignored_next_char = [=[[%w%%%'%[%"%.]]=]
--         })
--       end
--   }
--   use {
--     'kylechui/nvim-surround',
--     -- event = 'VimEnter'
--     tag = '*',
--     config = function()
--       require('nvim-surround').setup()
--     end
--   }
--   use { 'alvan/vim-closetag' }
--   use { 'gregsexton/MatchTag' }
--   use {
--   'mvllow/modes.nvim',
--   -- after = 'VimEnter',
--     config = function()
--       require'modes'.setup {
--         colors = {
--           copy = "#f5c359",
--           delete = "#c75c6a",
--           insert = "#78ccc5",
--           visual = "#9745be",
--         },
--
--         -- Set opacity for cursorline and number background
--         line_opacity = 0.15,
--
--         -- Enable cursor highlights
--         set_cursor = true,
--
--         -- Enable cursorline initially, and disable cursorline for inactive windows
--         -- or ignored filetypes
--         set_cursorline = true,
--
--         -- Enable line number highlights to match cursorline
--         set_number = true,
--
--         -- Disable modes highlights in specified filetypes
--         -- Please PR commonly ignored filetypes
--         ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
--       }
--     end
--   }
--   use { 'myusuf3/numbers.vim' }
--   use {
--     'folke/which-key.nvim',
--     -- event = 'VimEnter'
--     config = function ()
--       require('which-key').setup({
--         plugins = {
--           presets = {
--             operators = false
--           }
--         }
--       })
--     end
--   }
--   use { 'simeji/winresizer' }
--   use { 'mrjones2014/legendary.nvim' }
--   use {
--       'folke/trouble.nvim',
--       requires = "kyazdani42/nvim-web-devicons",
--       config = function()
--         require("trouble").setup {
--           -- your configuration comes here
--           -- or leave it empty to use the default settings
--           -- refer to the configuration section below
--           auto_open = true,
--           auto_close = true,
--           auto_preview = true,
--           use_diagnostic_signs = true
--         }
--       end
--   }
--   use {
--       'EthanJWright/toolwindow.nvim',
--       requires = {{ 'akinsho/toggleterm.nvim', event = 'VimEnter' }},
--       -- after = { 'trouble.nvim', },
--       config = function()
--         require'toolwindow'
--       end
--   }
--   -- use { 'rcarriga/nvim-notify' }
--   use { 'tyru/open-browser.vim' }
--   use {
--     'tyru/open-browser-github.vim',
--     after = 'open-browser.vim'
--   }
--   -- use {
--   --   'ray-x/web-tools.nvim',
--   --   config = function()
--   --     require'web-tools'.setup {
--   --       rename = '',
--   --       repeat_rename = '.'
--   --     }
--   --   end
--   -- }
--   use {
--       'glacambre/firenvim',
--       run = function() vim.fn['firenvim#install'](0) end
--   }
--   use { 'thinca/vim-ref' }
--   use {
--       'sindrets/diffview.nvim',
--       requires = 'nvim-lua/plenary.nvim',
--       -- event = 'VimEnter'
--   }
--   use {
--       'lewis6991/gitsigns.nvim',
--       requires = 'nvim-lua/plenary.nvim',
--       config = function()
--         require'gitsigns'.setup {
--           signs = {
--             add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
--             change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--             delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--             topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--             changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--           },
--           signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
--           numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
--           linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
--           word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
--           watch_gitdir = {
--             interval = 1000,
--             follow_files = true
--           },
--           attach_to_untracked = true,
--           current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
--           current_line_blame_opts = {
--             virt_text = true,
--             virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
--             delay = 1000,
--             ignore_whitespace = false,
--           },
--           current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
--           sign_priority = 6,
--           update_debounce = 100,
--           status_formatter = nil, -- Use default
--           max_file_length = 40000, -- Disable if file is longer than this (in lines)
--           preview_config = {
--             -- Options passed to nvim_open_win
--             border = 'single',
--             style = 'minimal',
--             relative = 'cursor',
--             row = 0,
--             col = 1
--           },
--           yadm = {
--             enable = false
--           }
--         }
--       end
--
--   }
--   use { 'rhysd/git-messenger.vim' }
--   use {
--       'akinsho/git-conflict.nvim',
--       config = function()
--         require'git-conflict'.setup{
--           default_mappings = true,
--           disable_diagnostics = false,
--           highlights = {
--               incoming = 'DiffText',
--               current = 'DiffAdd'
--           }
--         }
--       end
--   }
--   -- use {
--       -- 'TimUntersberger/neogit',
--       -- event = 'VimEnter',
--       -- requires = 'nvim-lua/plenary.nvim',
--       -- cmd = { 'Neogit' }
--   -- }
--   use {
--       'pwntester/octo.nvim',
--       requires = {
--         'nvim-lua/plenary.nvim',
--         'nvim-telescope/telescope.nvim',
--         'kyazdani42/nvim-web-devicons'
--       },
--       after = 'telescope.nvim',
--       config = function()
--         require'octo'.setup {
--           default_remote = {"upstream", "origin"}; -- order to try remotes
--           ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
--           reaction_viewer_hint_icon = "";         -- marker for user reactions
--           user_icon = " ";                        -- user icon
--           timeline_marker = "";                   -- timeline marker
--           timeline_indent = "2";                   -- timeline indentation
--           right_bubble_delimiter = "";            -- Bubble delimiter
--           left_bubble_delimiter = "";             -- Bubble delimiter
--           github_hostname = "";                    -- GitHub Enterprise host
--           snippet_context_lines = 4;               -- number or lines around commented lines
--           file_panel = {
--             size = 10,                             -- changed files panel rows
--             use_icons = true
--           }
--         }
--       end
--   }
--   use { 'mattn/emmet-vim' }
--   use {
--       'norcalli/nvim-colorizer.lua',
--       -- event = 'VimEnter',
--       config = function()
--           require'colorizer'.setup()
--           --     'css';
--           --     'javascript';
--           --     html = { mode = 'background' };
--           -- }, { mode = 'foreground' })
--       end
--   }
--   use {
--       'windwp/nvim-ts-autotag',
--       requires = {{ 'nvim-treesitter/nvim-treesitter', opt = true }},
--       -- after = 'nvim-treesitter'
--   }
--   use {
--     'm-demare/hlargs.nvim',
--     requires = { 'nvim-treesitter/nvim-treesitter' },
--     config = function ()
--       require('hlargs').setup {
--         color = '#ef9062',
--         highlight = {},
--         excluded_filetypes = {},
--         -- disable = function(lang, bufnr)
--         --   return vim.tbl_contains(opts.excluded_filetypes, lang)
--         -- end,
--         paint_arg_declarations = true,
--         paint_arg_usages = true,
--         paint_catch_blocks = {
--           declarations = false,
--           usages = false
--         },
--         hl_priority = 10000,
--         excluded_argnames = {
--           declarations = {},
--           usages = {
--             python = { 'self', 'cls' },
--             lua = { 'self' }
--           }
--         },
--         performance = {
--           parse_delay = 1,
--           slow_parse_delay = 50,
--           max_iterations = 400,
--           max_concurrent_partial_parses = 30,
--           debounce = {
--             partial_parse = 3,
--             partial_insert_mode = 100,
--             total_parse = 700,
--             slow_parse = 5000
--           }
--         }
--       }
--       require('hlargs').enable()
--     end
--   }
--   -- use {
--   --   'AcksID/nvim-anywise-reg.lua',
--   --   config = function ()
--   --     require('anywise_reg').setup({
--   --       operator = {'y', 'd', 'c'},
--   --       textobjects = {
--   --         { 'i', 'a' },
--   --         { 'w', 'W', 'f', 'c' }
--   --       },
--   --       paste_keys = {
--   --         ['p' ] = 'p',
--   --         ['P' ] = 'P'
--   --       },
--   --       register_print_cmd = true
--   --     })
--   --   end
--   -- }
--   -- use {
--   --     'vuki656/package-info.nvim',
--   --     -- event = 'VimEnter'
--   -- }
--   use {
--     'MunifTanjim/nui.nvim',
--   }
--   use {
--     'bennypowers/nvim-regexplainer',
--     after = 'nvim-treesitter',
--     requires = {
--       'nvim-treesitter/nvim-treesitter',
--       'MuniTanjim/nui.nvim'
--     },
--     config = function()
--       require('regexplainer').setup()
--     end
--   }
--   use { 'alaviss/nim.nvim' }
--   use { 'prabirshrestha/asyncomplete.vim' }
--   use { 'jsborjesson/vim-uppercase-sql' }
--   use {
--       'iamcco/markdown-preview.nvim',
--       run = "cd app && yarn install",
--       cmd = 'MarkdownPreview',
--       setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
--       ft = { "markdown" }
--   }
--   use {
--     'dhruvasagar/vim-table-mode',
--     cmd = 'TableModeEnable'
--   }
--   use {
--     'steelsojka/headwind.nvim',
--     config = function()
--       require('headwind').setup {}
--     end
--   }
--   use { 'delphinus/vim-firestore' }
--   use { 'jparise/vim-graphql' }
--   -- use {
--   --   'crusj/bookmarks.nvim',
--   --   branch = 'main',
--   --   requires = 'kyazdani42/nvim-web-devicons',
--   --   config = function ()
--   --     require('bookmarks').setup({
--   --       keymap = {
--   --         toggle = '<leader>bm',
--   --         order = '<leader>bo',
--   --         add = "\\z", -- add bookmarks
--   --         jump = "<CR>", -- jump from bookmarks
--   --         delete = "dd", -- delete bookmarks
--   --       },
--   --       width = 0.8,
--   --       height = 0.6,
--   --       preview_ratio = 0.4,
--   --       preview_ext_enable = true,
--   --       fix_enable = false,
--   --       hl_cursorline = 'guibg=#a277ff, guifg=#edecee'
--   --     })
--   --   end
--   -- }
--   use {
--     'MattesGroeger/vim-bookmarks',
--   }
--   use {
--     'tom-anders/telescope-vim-bookmarks.nvim',
--     after = 'telescope.nvim',
--     config = function ()
--       require('telescope').load_extension('vim_bookmarks')
--     end
--   }
--   use {
--       'folke/todo-comments.nvim',
--       requires = 'nvim-lua/plenary.nvim',
--       config = function()
--         require('todo-comments').setup {
--
--         }
--       -- event = 'VimEnter'
--     end
--   }
--   -- use {
--   --     'kyazdani42/nvim-tree.lua',
--   --     -- opt = true,
--   --     -- cmd = { 'NvimTreeToggle' },
--   --     requires = {
--   --       'kyazdani42/nvim-web-devicons'
--   --     },
--   --     tag = 'nightly',
--   --     config = function()
--   --         require'nvim-tree'.setup{
--   --             disable_netrw       = true,
--   --             hijack_netrw        = true,
--   --             open_on_setup       = false,
--   --             ignore_ft_on_setup  = {},
--   --             -- auto_close          = false,
--   --             open_on_tab         = false,
--   --             hijack_cursor       = false,
--   --             -- update_cwd          = false,
--   --             -- update_to_buf_dir   = {
--   --             --     enable = true,
--   --             --     auto_open = true,
--   --             -- },
--   --           diagnostics = {
--   --               enable = false,
--   --               icons = {
--   --                 hint = "",
--   --                 info = "",
--   --                 warning = "",
--   --                 error = "",
--   --               }
--   --           },
--   --           update_focused_file = {
--   --           enable      = false,
--   --           update_cwd  = false,
--   --           ignore_list = {}
--   --           },
--   --           system_open = {
--   --             cmd  = nil,
--   --             args = {}
--   --             },
--   --           filters = {
--   --             dotfiles = false,
--   --             custom = {}
--   --             },
--   --           git = {
--   --           enable = true,
--   --           ignore = true,
--   --           timeout = 100,
--   --           },
--   --           view = {
--   --             width = 30,
--   --             height = 30,
--   --             hide_root_folder = false,
--   --             side = 'left',
--   --             -- auto_resize = false,
--   --             mappings = {
--   --               custom_only = false,
--   --               list = {}
--   --               },
--   --             number = false,
--   --             relativenumber = false,
--   --             signcolumn = "yes"
--   --             },
--   --           trash = {
--   --             cmd = "trash",
--   --             require_confirm = true
--   --             }
--   --         }
--   --     end
--   -- }
--   use {
--       'nvim-telescope/telescope-file-browser.nvim',
--       after = 'telescope.nvim',
--       config = function()
--         require('telescope').load_extension('file_browser')
--       end
--   }
--   use {
--       'akinsho/toggleterm.nvim',
--       tag = '*',
--       -- opt = true,
--       -- cmd = 'ToggleTerm',
--       config = function()
--         require("toggleterm").setup{
--           direction = 'float',
--           hide_numbers = true,
--           shade_terminals = true,
--           start_in_insert = true,
--           insert_mappings = true,
--           terminal_mappings = true,
--           persist_size = true,
--           persist_mode = true,
--           close_on_exit = false,
--           -- shell = vim.o.fish,
--           hidden = true
--         }
--       end
--   }
--   use {
-- 	  'baliestri/aura-theme',
-- 	  rtp = 'packages/neovim',
--     -- opt = true,
-- 	  config = function()
-- 		  vim.cmd('colorscheme aura-soft-dark')
-- 	  end
--   }
--   use {
--       'phaazon/hop.nvim',
--       branch = 'v2',
--       config = function()
--         require'hop'.setup {
--             -- keys = 'etovxqpdygfblzhckisuran'
--         }
--       end
--   }
--   use {
--     'ggandor/lightspeed.nvim',
--     config = function()
--       require('lightspeed').setup {
--         ignore_case = false,
--         jump_to_unique_chars = { safety_timeout = 400 },
--         safe_labels = {},
--         match_only_the_start_of_same_char_seqs = true,
--         force_beacons_into_match_width = false,
--         substitute_chars = { ['\r'] = '¬', },
--         limit_ft_matches = 5,
--         repeat_ft_with_target_char = false
--       }
--     end
--   }
--   use {
--     'andymass/vim-matchup',
--     after = 'nvim-treesitter'
--   }
--   use {
--     'tyru/columnskip.vim',
--     -- event = 'VimEnter'
--   }
--   use { 'matze/vim-move' }
--   use {
--     'bkad/CamelCaseMotion',
--     -- event = 'VimEnter'
--   }
--   use { 'unblevable/quick-scope' }
--   use {
--     'nvim-telescope/telescope.nvim',
--     tag = '0.1.0',
--     requires = {
--         'nvim-lua/plenary.nvim',
-- --         'nvim-lua/popup.nvim',
-- --         -- 'telescope-frecency.nvim',
-- --         -- 'telescope-fzf-native.nvim',
--         'nvim-telescope/telescope-ghq.nvim',
--     },
--     config = function()
--       require'telescope'.setup {
--         extensions = {
--           file_browser = {
--             theme = "ivy",
--             -- disables netrw and use telescope-file-browser in its place
--             hijack_netrw = true,
--             mappings = {
--               ["i"] = {
--                 -- your custom insert mode mappings
--               },
--               ["n"] = {
--                 -- your custom normal mode mappings
--               },
--             },
--           },
--           frecency = {
--             -- db_root = "home/my_username/path/to/db_root",
--             show_scores = false,
--             show_unindexed = true,
--             ignore_patterns = {"*.git/*", "*/tmp/*"},
--             disable_devicons = false,
--             workspaces = {
--               ["conf"]    = "/home/my_username/.config",
--               ["data"]    = "/home/my_username/.local/share",
--               -- ["project"] = "/home/my_username/projects",
--               -- ["wiki"]    = "/home/my_username/wiki"
--             }
--           },
--           media_files = {
--             filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
--             find_cmd = 'rg'
--           },
--           command_palette = {
--             {"File",
--               { "entire selection (C-a)", ':call feedkeys("GVgg")' },
--               { "save current file (C-s)", ':w' },
--               { "save all files (C-A-s)", ':wa' },
--               { "quit (C-q)", ':qa' },
--               { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
--               { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
--               { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
--               { "files (C-f)",     ":lua require('telescope.builtin').find_files()", 1 },
--           },
--             {"Help",
--               { "tips", ":help tips" },
--               { "cheatsheet", ":help index" },
--               { "tutorial", ":help tutor" },
--               { "summary", ":help summary" },
--               { "quick reference", ":help quickref" },
--               { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
--             },
--             {"Vim",
--               { "reload vimrc", ":source $MYVIMRC" },
--               { 'check health', ":checkhealth" },
--               { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
--               { "commands", ":lua require('telescope.builtin').commands()" },
--               { "command history", ":lua require('telescope.builtin').command_history()" },
--               { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
--               { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
--               { "vim options", ":lua require('telescope.builtin').vim_options()" },
--               { "keymaps", ":lua require('telescope.builtin').keymaps()" },
--               { "buffers", ":Telescope buffers" },
--               { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
--               { "paste mode", ':set paste!' },
--               { 'cursor line', ':set cursorline!' },
--               { 'cursor column', ':set cursorcolumn!' },
--               { "spell checker", ':set spell!' },
--               { "relative number", ':set relativenumber!' },
--               { "search highlighting (F12)", ':set hlsearch!' },
--             }
--           }
--         }
--       }
--         require'telescope'.load_extension 'ghq'
--     end
--   }
--   use {
--       'nvim-telescope/telescope-packer.nvim',
--       after = 'telescope.nvim',
--       config = function()
--         require'telescope'.load_extension 'packer'
--       end
--   }
--   use {
--       'nvim-telescope/telescope-frecency.nvim',
--       after = 'telescope.nvim',
--       config = function()
--         require'telescope'.load_extension('frecency')
--       end,
--       requires = { 'tami5/sqlite.lua' }
--   }
--   -- use { 'nvim-telescope/telescope-symbols.nvim' }
--   use {
--       'LinArcX/telescope-command-palette.nvim',
--       after = 'telescope.nvim',
--       config = function()
--         require('telescope').setup {
--           require('telescope').load_extension('command_palette')
--         }
--       end
--   }
--   use {
--     'nvim-telescope/telescope-github.nvim',
--     after = 'telescope.nvim',
--     config = function()
--       require('telescope').load_extension('gh')
--     end
--   }
--   use {
--     'nvim-telescope/telescope-media-files.nvim',
--     after = 'telescope.nvim',
--     config = function()
--       require('telescope').load_extension('media_files')
--     end
--   }
--   use {
--       'gelguy/wilder.nvim',
--       -- keys = {
--       --     { 'n', ':' },
--       --     { 'n', '/' },
--       --     { 'n', '?' },
--       -- },
--       config = function()
--       end
--   }
--   use { 'haya14busa/vim-asterisk' }
--   use { 'thinca/vim-visualstar' }
--   use { 'jremmen/vim-ripgrep' }
--   use { 'vim-scripts/ReplaceWithRegister' }
--   use {
--       'numToStr/Comment.nvim',
--       -- event = 'VimEnter',
--       config = function()
--         require'Comment'.setup {
--             ---Add a space b/w comment and the line
--           padding = true,
--           ---Whether the cursor should stay at its position
--           sticky = true,
--           ---Lines to be ignored while (un)comment
--           ignore = nil,
--           ---LHS of toggle mappings in NORMAL mode
--           toggler = {
--             ---Line-comment toggle keymap
--             line = 'gcc',
--             ---Block-comment toggle keymap
--             block = 'gbc',
--           },
--           ---LHS of operator-pending mappings in NORMAL and VISUAL mode
--           opleader = {
--             ---Line-comment keymap
--             line = 'gc',
--             ---Block-comment keymap
--             block = 'gb',
--           },
--           ---LHS of extra mappings
--           extra = {
--             ---Add comment on the line above
--             above = 'gcO',
--             ---Add comment on the line below
--             below = 'gco',
--             ---Add comment at the end of line
--             eol = 'gcA',
--           },
--           ---Enable keybindings
--           ---NOTE: If given `false` then the plugin won't create any mappings
--           mappings = {
--             ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
--             basic = true,
--             ---Extra mapping; `gco`, `gcO`, `gcA`
--             extra = true,
--             ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
--             extended = false,
--           },
--           ---Function to call before (un)comment
--           pre_hook = nil,
--           ---Function to call after (un)comment
--           post_hook = nil,
--                 }
--       end
--   }
--   use { 'vigoux/architext.nvim' }
--   use { 'wellle/targets.vim' }
--   use {
--       'JoosepAlviste/nvim-ts-context-commentstring',
--       -- opt = true,
--       -- after = { 'nvim-treesitter' }
--   }
--   use { 'LudoPinelli/comment-box.nvim' }
--   use { 'terryma/vim-multiple-cursors' }
--   -- use {
--   --     'AckslD/nvim-neoclip.lua',
--   --     requires = {
--   --       { "nvim-telescope/telescope.nvim", opt = true }, { "kkharji/sqlite.lua", opt = true }
--   --     },
--   --     config = function ()
--   --       require('neoclip').setup{
--   --         history = 1000,
--   --         enable_persistent_history = false,
--   --         length_limit = 1048576,
--   --         continuous_sync = false,
--   --         filter = nil,
--   --         preview = true,
--   --         enable_macro_history = true,
--   --         content_spec_column = false
--   --       }
--   --     end
--   --     -- after = { 'telescope.nvim', 'sqlite.lua' }
--   -- }
--   use {
--     'tversteeg/registers.nvim',
--     keys = {
--       { 'n', '"' },
--       { 'i', '<leader>rp' },
--     },
--   }
--   -- use {
--   --   'kevinhwang91/nvim-bqf',
--   --   -- event = 'VimEnter'
--   -- }
--   -- use {
--   --   'gabrielpoca/replacer.nvim',
--   --   -- event = 'VimEnter'
--   -- }
--   -- use {
--   --   'klen/nvim-test',
--   --   config = function ()
--   --     require'nvim-test'.setup()
--   --   end
--   -- }
--   use {
--     'nvim-neotest/neotest',
--     requires = {
--       'nvim-lua/plenary.nvim',
--       'nvim-treesitter/nvim-treesitter',
--       'antoinemadec/FixCursorHold.nvim',
--     },
--     config = function ()
--       require'neotest'.setup({
--       })
--     end
--   }
--   -- use { 'David-Kunz/jester' }
--   use { 'sentriz/vim-print-debug' }
--   use {
--     'mfussenegger/nvim-dap',
--     -- event = 'VimEnter'
--   }
--   use {
--     'rcarriga/nvim-dap-ui',
--     requires = { 'mfussenegger/nvim-dap' },
--     after = 'nvim-dap',
--     config = function()
--       require('dapui').setup({
--         icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
--         mappings = {
--           -- Use a table to apply multiple mappings
--           expand = { "<CR>", "<2-LeftMouse>" },
--           open = "o",
--           remove = "d",
--           edit = "e",
--           repl = "r",
--           toggle = "t",
--         },
--         expand_lines = vim.fn.has("nvim-0.7"),
--         layouts = {
--           {
--             elements = {
--             -- Elements can be strings or table with id and size keys.
--               { id = "scopes", size = 0.25 },
--               "breakpoints",
--               "stacks",
--               "watches",
--             },
--             size = 40, -- 40 columns
--             position = "left",
--           },
--           {
--             elements = {
--               "repl",
--               "console",
--             },
--             size = 0.25, -- 25% of total lines
--             position = "bottom",
--           },
--         },
--         floating = {
--           max_height = nil, -- These can be integers or a float between 0 and 1.
--           max_width = nil, -- Floats will be treated as percentage of your screen.
--           border = "single", -- Border style. Can be "single", "double" or "rounded"
--           mappings = {
--             close = { "q", "<Esc>" },
--           },
--         },
--         windows = { indent = 1 },
--         render = {
--           max_type_length = nil, -- Can be integer or nil.
--           max_value_lines = 100, -- Can be integer or nil.
--         }
--       })
--     end
--   }
--   use {
--     'theHamsta/nvim-dap-virtual-text',
--     after = 'nvim-dap',
--     config = function()
--       require('nvim-dap-virtual-text').setup()
--     end
--   }
--   use {
--     'nvim-telescope/telescope-dap.nvim',
--     after = 'telescope.nvim',
--     config = function()
--       require('telescope').load_extension('dap')
--     end
--   }
--   -- use {
--   --   'gaelph/logsitter',
--   --   requires = { 'nvim-treesitter/nvim-treesitter' }
--   -- }
--   use { 'tpope/vim-repeat' }
--   use {
--     'L3MON4D3/LuaSnip',
--     event = 'InsertEnter',
--     config = function()
--       require('luasnip/loaders/from_vscode').load()
--     end,
--     -- 'rafamadriz/friendly-snippets',
--   }
--   use { 'rafamadriz/friendly-snippets' }
--   use {
--       'neoclide/coc.nvim',
--       branch = 'release',
--       run = 'yarn install --frozen-lockfile'
--   }
--   use { 'tsuyoshicho/vim-efm-langserver-settings' }
--   use { 'github/copilot.vim' }
--   -- use {
--   --  'zbirenbaum/copilot.lua',
--   --  event = 'IntertEnter',
--   --  config = function ()
--   --    vim.defer_fn(function ()
--   --      require('copilot').setup()
--   --    end, 100)
--   --    vim.schedule(function ()
--   --      require('copilot').setup {
--   --        cmp = {
--   --          enabled = true,
--   --          method = 'getCompletionsCycling'
--   --        }
--   --      }
--   --    end)
--   --  end
--   -- }
--   use {
--     'mizlan/iswap.nvim',
--     config = function()
--       require'iswap'.setup {
--         -- The keys that will be used as a selection, in order
--         -- ('asdfghjklqwertyuiopzxcvbnm' by default)
--         keys = 'qwertyuiop',
--
--         -- Grey out the rest of the text when making a selection
--         -- (enabled by default)
--         grey = 'disable',
--
--         -- Highlight group for the sniping value (asdf etc.)
--         -- default 'Search'
--         hl_snipe = 'ErrorMsg',
--
--         -- Highlight group for the visual selection of terms
--         -- default 'Visual'
--         hl_selection = 'WarningMsg',
--
--         -- Highlight group for the greyed background
--         -- default 'Comment'
--         hl_grey = 'LineNr',
--
--         -- Post-operation flashing highlight style,
--         -- either 'simultaneous' or 'sequential', or false to disable
--         -- default 'sequential'
--         flash_style = false,
--
--         -- Highlight group for flashing highlight afterward
--         -- default 'IncSearch'
--         hl_flash = 'ModeMsg',
--
--         -- Move cursor to the other element in ISwap*With commands
--         -- default false
--         move_cursor = true,
--
--         -- Automatically swap with only two arguments
--         -- default nil
--         autoswap = true,
--
--         -- Other default options you probably should not change:
--         debug = nil,
--         hl_grey_priority = '1000',
--       }
--     end
--   }
--   use { 'heavenshell/vim-jsdoc' }
--   use { 'pantharshit00/vim-prisma' }
--   use { 'antoinemadec/FixCursorHold.nvim' }
--   use {
--     'ThePrimeagen/refactoring.nvim',
--     config = function()
--       require('refactoring').setup {
--         requires = {
--           { 'nvim-lua/plenary.nvim' },
--           { 'nvim-treesitter/nvim-treesitter' },
--         }
--       }
--     end
--   }
--   use {
--     'NTBBloodbath/rest.nvim',
--     requires = { 'nvim-lua/plenary.nvim' },
--     config = function()
--       require'rest-nvim'.setup {
--         -- Open request results in a horizontal split
--         result_split_horizontal = false,
--         -- Keep the http file buffer above|left when split horizontal|vertical
--         result_split_in_place = false,
--         -- Skip SSL verification, useful for unknown certificates
--         skip_ssl_verification = false,
--               -- Encode URL before making request
--               encode_url = true,
--         -- Highlight request on run
--         highlight = {
--           enabled = true,
--           timeout = 150,
--         },
--         result = {
--           -- toggle showing URL, HTTP info, headers at top the of result window
--           show_url = true,
--           show_http_info = true,
--           show_headers = true,
--           -- executables or functions for formatting response body [optional]
--           -- set them to nil if you want to disable them
--           formatters = {
--             json = "jq",
--             html = function(body)
--               return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
--             end
--           }
--         },
--           -- Jump to request line on run
--           jump_to_request = false,
--           env_file = '.env',
--           custom_dynamic_variables = {},
--           yank_dry_run = true,
--         }
--     end
--   }
--   use {
--     'jose-elias-alvarez/null-ls.nvim',
--     after = 'plenary.nvim',
--     config = function()
--       require('null-ls').setup({
--         sources = {
--           require('null-ls').builtins.formatting.stylua,
--           require('null-ls').builtins.formatting.eslint,
--           require('null-ls').builtins.formatting.spell
--         }
--       })
--     end
--   }
--   use { 'mhartington/formatter.nvim' }
--   -- use {
--   --   'lewis6991/spellsitter.nvim',
--     -- after = 'nvim-treesitter'
--   -- }
--   use { 'Pocco81/AbbrevMan.nvim' }
--   use { 'editorconfig/editorconfig-vim' }
--   use { 'wakatime/vim-wakatime' }
--   -- use { 'glepnir/dashboard-nvim' }
--   use { 'vim-jp/vimdoc-ja' }
--   -- use {
--   --   'voldikss/vim-translator',
--   --   -- event = 'VimEnter'
--   -- }
--   use { 'is0n/jaq-nvim' }
--   use {
--     'jghauser/mkdir.nvim',
--     -- event = 'VimEnter'
--   }
--   use { 'segeljakt/vim-silicon' }
--   use { 'MTDL9/vim-log-highlighting' }
--   use {
--     'sudormrfbin/cheatsheet.nvim',
--     requires = {
--       { 'nvim-telescope/telescope.nvim' },
--       { 'nvim-lua/popup.nvim' },
--       { 'nvim-lua/plenary.nvim' },
--     },
--     after = 'telescope.nvim',
--   }
--   -- use {
--   --   'nvim-telescope/telescope-hop.nvim',
--   -- }
--   use { 'michaelb/sniprun' }
--   use {
--     'karb94/neoscroll.nvim',
--     config = function()
--       require'neoscroll'.setup {
--         mappings = {
--           '<C-u>',
--           '<C-d>',
--           -- '<C-b>',
--           -- '<C-f>',
--           -- 'zt',
--           -- 'zz',
--           -- 'zb',
--         },
--         hide_cursor = true,
--         stop_eof = true,
--         respect_scrolloff = false,
--         cursor_scrolls_alone = true,
--         easing_function = nil,
--         pre_hook = nil,
--         post_hook = nil,
--         performance_mode = false
--       }
--     end
--   }
--   -- use {
--   --   'filipdutescu/renamer.nvim',
--   --   branch = 'master',
--   --   requires = { {'nvim-lua/plenary.nvim'} }
--   -- }
--   use {
--     'cappyzawa/trim.nvim',
--     config = function()
--       require'trim'.setup {
--         -- list of filetypes to ignore
--         exclude = {},
--
--         -- list of filetypes to trim on save
--         include = {},
--
--         -- list of patterns to trim
--         patterns = {
--           [[%s/\s\+$//e]],           -- remove unwanted spaces
--           -- remove trailing whitespace
--           [[\s+$]],
--           [[%s/\%^\n\+//]],          -- trim first line
--           -- remove empty lines at the end of the file
--           [[\n+\%$]],
--         },
--       }
--     end
--   }
--   use {
--     'sQVe/sort.nvim',
--     config = function()
--       require('sort').setup({
--       })
--     end
--   }
--   -- use { 'folke/zen-mode.nvim' }
--   use {
--     'b0o/incline.nvim',
--     config = function()
--       require('incline').setup {
--         debounce_threshold = {
--           falling = 50,
--           rising = 10
--         },
--         hide = {
--           cursorline = false,
--           focused_win = false,
--           only_win = false
--         },
--         highlight = {
--           groups = {
--             InclineNormal = {
--               default = true,
--               group = 'NormalFloat'
--             },
--             InclineNormalNC = {
--               default = true,
--               group = 'NormalFloat'
--             }
--           }
--         },
--         ignore = {
--           buftypes = 'special',
--           filetypes = {},
--           floating_wins = true,
--           unlisted_buffers = true,
--           wintypes = 'special'
--         },
--         render = 'basic',
--         window = {
--           margin = {
--             horizontal = { left = 1, right = 1 },
--             vertical = { bottom = 1, top = 1 },
--           },
--           options = {
--             signcolumn = 'no',
--             wrap = false
--           },
--           padding = { left = 1, right = 1 },
--           padding_char = ' ',
--           placement = {
--             horizontal = 'right',
--             vertical = 'top'
--           },
--           width = 'fit',
--           winhighlight = {
--             active = {
--               EndOfBuffer = 'None',
--               Normal = 'InclineNormal',
--               Search = 'None'
--             },
--             inactive = {
--               EndOfBuffer = 'None',
--               Normal = 'InclineNormalNC',
--               Search = 'None'
--             }
--           },
--           zindex = 100
--         }
--       }
--     end
--   }
--   use {
--     'axieax/urlview.nvim',
--     config = function()
--       require('urlview').setup({
--           -- Prompt title (`<context> <default_title>`, e.g. `Buffer Links:`)
--         default_title = "Links:",
--         -- Default picker to display links with
--         -- Options: "native" (vim.ui.select) or "telescope"
--         default_picker = "native",
--         -- Set the default protocol for us to prefix URLs with if they don't start with http/https
--         default_prefix = "https://",
--         -- Command or method to open links with
--         -- Options: "netrw", "system" (default OS browser); or "firefox", "chromium" etc.
--         -- By default, this is "netrw", or "system" if netrw is disabled
--         navigate_method = "netrw",
--         -- Ensure links shown in the picker are unique (no duplicates)
--         unique = true,
--         -- Ensure links shown in the picker are sorted alphabetically
--         sorted = true,
--         -- Logs user warnings (recommended for error detection)
--         debug = true,
--         -- Custom search captures
--         -- NOTE: captures follow Lua pattern matching (https://riptutorial.com/lua/example/20315/lua-pattern-matching)
--         custom_searches = {
--           -- KEY: search source name
--           -- VALUE: custom search function or table (map with keys capture, format)
--           jira = {
--             capture = "AXIE%-%d+",
--             format = "https://jira.axieax.com/browse/%s",
--           },
--         },
--       })
--     end
--   }
--
-- end)

local lualine = require('lualine')

local colors = {
  bg       = '#15141b',
  fg       = '#edecee',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#61ffca',
  orange   = '#ffca85',
  violet   = '#a277ff',
  magenta  = '#f694ff',
  blue     = '#82e2ff',
  red      = '#ff6767',
  }

local conditions = {
  buffer_not_empty = function()
  return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end,
hide_in_width = function()
return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
  local filepath = vim.fn.expand('%:p:h')
  local gitdir = vim.fn.finddir('.git', filepath .. ';')
  return gitdir and #gitdir > 0 and #gitdir < #filepath
end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
    },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
    },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
    },
  }

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
function()
  return '▊'
end,
color = { fg = colors.blue }, -- Sets highlighting of component
padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
-- mode component
function()
  -- auto change color according to neovims mode
  local mode_color = {
    n = colors.red,
    i = colors.blue,
    v = colors.orange,
    [''] = colors.orange,
    V = colors.orange,
    c = colors.magenta,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    [''] = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!'] = colors.red,
    t = colors.red,
    }
  vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
  return ''
end,
color = 'LualineMode',
padding = { right = 1 },
})

ins_left({
-- filesize component
'filesize',
cond = conditions.buffer_not_empty,
})

ins_left({
'filename',
cond = conditions.buffer_not_empty,
color = { fg = colors.magenta, gui = 'bold' },
})

ins_left({ 'location' })

ins_left({ 'progress', color = { fg = colors.fg, gui = 'bold' } })

ins_left({
'diagnostics',
sources = { 'nvim_diagnostic' },
symbols = { error = ' ', warn = ' ', info = ' ' },
diagnostics_color = {
  color_error = { fg = colors.red },
  color_warn = { fg = colors.yellow },
  color_info = { fg = colors.cyan },
  },
})

-- Insert mid section. You can make any number of sections in neovim :)
ins_left({
function()
  return '%='
end,
})

-- Add components to right sections
ins_right({
'o:encoding', -- option component same as &encoding in viml
fmt = string.upper, -- I'm not sure why it's upper case either ;)
cond = conditions.hide_in_width,
color = { fg = colors.green, gui = 'bold' },
})

ins_right({
'fileformat',
fmt = string.upper,
icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
color = { fg = colors.green, gui = 'bold' },
})

ins_right({
'branch',
icon = '',
color = { fg = colors.violet, gui = 'bold' },
})

ins_right({
'diff',
-- Is it me or the symbol for modified us really weird
symbols = { added = ' ', modified = '柳 ', removed = ' ' },
diff_color = {
  added = { fg = colors.green },
  modified = { fg = colors.orange },
  removed = { fg = colors.red },
  },
cond = conditions.hide_in_width,
})

ins_right({
function()
  return '▊'
end,
color = { fg = colors.blue },
padding = { left = 1 },
})

lualine.setup(config)

local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
    javascript = {'template_string'},
    java = false,-- don't check treesitter on java
  }
})

local ts_conds = require('nvim-autopairs.ts-conds')


-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),
  Rule("$", "$", "lua")
    :with_pair(ts_conds.is_not_ts_node({'function'}))
})

local Terminal  = require('toggleterm.terminal').Terminal
local windows = require("toolwindow")
local function open_fn(plugin, args)
    _ = args
    plugin:open()
end

local function close_fn(plugin)
    plugin:close()
end

-- params: name, plugin, function to close window, function to open window
windows.register("term", Terminal:new({hidden = true}), close_fn, open_fn)

-- local plugin = "My Awesome Plugin"

-- vim.notify("", "error", {
--   title = plugin,
--   on_open = function()
--     vim.notify("Attempting recovery.", vim.log.levels.WARN, {
--       title = plugin,
--     })
--     local timer = vim.loop.new_timer()
--     timer:start(2000, 0, function()
--       vim.notify({ "Fixing problem.", "Please wait..." }, "info", {
--         title = plugin,
--         timeout = 2000,
--         on_close = function()
--           vim.notify("Problem solved", nil, { title = plugin })
--           vim.notify("Error code 0x0395AF", 1, { title = plugin })
--         end,
--       })
--     end)
--   end,
-- })

vim.cmd([[
    call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<Tab>',
      \ 'previous_key': '<S-Tab>',
      \ 'accept_key': '<Down>',
      \ 'reject_key': '<Up>',
      \ })

call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \       'set_pcre2_pattern': has('nvim'),
      \     }),
      \     wilder#python_search_pipeline({
      \       'pattern': 'fuzzy',
      \     }),
      \   ),
      \ ])

let s:highlighters = [
      \ wilder#pcre2_highlighter(),
      \ wilder#basic_highlighter(),
      \ ]

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': wilder#popupmenu_renderer({
      \   'highlighter': s:highlighters,
      \ 'left': [
        \   ' ', wilder#popupmenu_devicons(),
        \ ],
        \ 'right': [
          \   ' ', wilder#popupmenu_scrollbar(),
          \ ],
          \ }),
          \ '/': wilder#wildmenu_renderer({
          \   'highlighter': s:highlighters,
          \ }),
          \ }))
]])

vim.cmd([[
    " let g:nvim_tree_quit_on_open = 1
    " let g:nvim_tree_indent_markers = 1
    " let g:nvim_tree_git_hl = 1
    " let g:nvim_tree_highlight_opened_files = 1
    " let g:nvim_tree_root_folder_modifier = ':~'
    " let g:nvim_tree_add_trailing = 1
    " let g:nvim_tree_group_empty = 1
    " let g:nvim_tree_disable_window_picker = 1
    " let g:nvim_tree_icon_padding = ' '
    " let g:nvim_tree_symlink_arrow = ' >> '
    " let g:nvim_tree_respect_buf_cwd = 1
    " let g:nvim_tree_create_in_closed_folder = 0
    let g:nvim_tree_refresh_wait = 100
    " let g:nvim_tree_window_picker_exclude = {
    "   \   'filetype': [
    "     \     'notify',
    "     \     'packer',
    "     \     'qf'
    "     \   ],
    "     \   'buftype': [
    "       \     'terminal'
    "       \   ]
    "       \ }

    " let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
    " let g:nvim_tree_show_icons = {
    "       \ 'git': 1,
    "       \ 'folders': 1,
    "       \ 'files': 1,
    "       \ 'folder_arrows': 0,
    "       \ }

      " let g:nvim_tree_icons = {
  " \ 'default': '',
  " \ 'symlink': '',
  " \ 'git': {
    " \   'unstaged': "✗",
    " \   'staged': "✓",
    " \   'unmerged': "",
    " \   'renamed': "➜",
    " \   'untracked': "★",
    " \   'deleted': "",
    " \   'ignored': "◌"
    " \   },
    " \ 'folder': {
      " \   'arrow_open': "",
      " \   'arrow_closed': "",
      " \   'default': "",
      " \   'open': "",
      " \   'empty': "",
      " \   'empty_open': "",
      " \   'symlink': "",
      " \   'symlink_open': "",
      " \   }
      " \ }
" ]])

-- local actions = require("diffview.actions")
--
-- require("diffview").setup({
--   diff_binaries = false,    -- Show diffs for binaries
--   enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
--   git_cmd = { "git" },      -- The git executable followed by default args.
--   use_icons = true,         -- Requires nvim-web-devicons
--   icons = {                 -- Only applies when use_icons is true.
--     folder_closed = "",
--     folder_open = "",
--   },
--   signs = {
--     fold_closed = "",
--     fold_open = "",
--   },
--   file_panel = {
--     listing_style = "tree",             -- One of 'list' or 'tree'
--     tree_options = {                    -- Only applies when listing_style is 'tree'
--       flatten_dirs = true,              -- Flatten dirs that only contain one single dir
--       folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
--     },
--     win_config = {                      -- See ':h diffview-config-win_config'
--       position = "left",
--       width = 35,
--     },
--   },
--   file_history_panel = {
--     log_options = {   -- See ':h diffview-config-log_options'
--       git = {
--         single_file = {
--           diff_merges = "combined",
--         },
--         multi_file = {
--           diff_merges = "first-parent",
--         },
--       }
--     },
--     win_config = {    -- See ':h diffview-config-win_config'
--       position = "bottom",
--       height = 16,
--     },
--   },
--   commit_log_panel = {
--     win_config = {},  -- See ':h diffview-config-win_config'
--   },
--   default_args = {    -- Default args prepended to the arg-list for the listed commands
--     DiffviewOpen = {},
--     DiffviewFileHistory = {},
--   },
--   hooks = {},         -- See ':h diffview-config-hooks'
--   keymaps = {
--     disable_defaults = false, -- Disable the default keymaps
--     view = {
--       -- The `view` bindings are active in the diff buffers, only when the current
--       -- tabpage is a Diffview.
--       ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
--       ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
--       ["gf"]         = actions.goto_file,         -- Open the file in a new split in the previous tabpage
--       ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
--       ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
--       ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
--       ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
--     },
--     file_panel = {
--       ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
--       ["<down>"]        = actions.next_entry,
--       ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
--       ["<up>"]          = actions.prev_entry,
--       ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
--       ["o"]             = actions.select_entry,
--       ["<2-LeftMouse>"] = actions.select_entry,
--       ["-"]             = actions.toggle_stage_entry, -- Stage /
--       ["S"]             = actions.stage_all,          -- Stage all entries.
--       ["U"]             = actions.unstage_all,        -- Unstage all entries.
--       ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
--       ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
--       ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
--       ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
--       ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
--       ["<tab>"]         = actions.select_next_entry,
--       ["<s-tab>"]       = actions.select_prev_entry,
--       ["gf"]            = actions.goto_file,
--       ["<C-w><C-f>"]    = actions.goto_file_split,
--       ["<C-w>gf"]       = actions.goto_file_tab,
--       ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
--       ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
--       ["<leader>e"]     = actions.focus_files,
--       ["<leader>b"]     = actions.toggle_files,
--     },
--     file_history_panel = {
--       ["g!"]            = actions.options,          -- Open the option panel
--       ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
--       ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
--       ["L"]             = actions.open_commit_log,
--       ["zR"]            = actions.open_all_folds,
--       ["zM"]            = actions.close_all_folds,
--       ["j"]             = actions.next_entry,
--       ["<down>"]        = actions.next_entry,
--       ["k"]             = actions.prev_entry,
--       ["<up>"]          = actions.prev_entry,
--       ["<cr>"]          = actions.select_entry,
--       ["o"]             = actions.select_entry,
--       ["<2-LeftMouse>"] = actions.select_entry,
--       ["<c-b>"]         = actions.scroll_view(-0.25),
--       ["<c-f>"]         = actions.scroll_view(0.25),
--       ["<tab>"]         = actions.select_next_entry,
--       ["<s-tab>"]       = actions.select_prev_entry,
--       ["gf"]            = actions.goto_file,
--       ["<C-w><C-f>"]    = actions.goto_file_split,
--       ["<C-w>gf"]       = actions.goto_file_tab,
--       ["<leader>e"]     = actions.focus_files,
--       ["<leader>b"]     = actions.toggle_files,
--     },
--     option_panel = {
--       ["<tab>"] = actions.select_entry,
--       ["q"]     = actions.close,
--     },
--   },
--
-- })

-- local Rule = require('nvim-autopairs.rule')
-- local npairs = require('nvim-autopairs')
--
-- npairs.add_rule(Rule("<>"))

require("todo-comments").setup({
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  }
})

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- You can also specify a list of valid jump keywords

-- vim.keymap.set("n", "]t", function()
--   require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
-- end, { desc = "Next error/warning todo comment" })

-- -- filter keymaps by current mode
-- require('legendary').find({ filters = require('legendary.filters').current_mode() })
-- -- filter keymaps by normal mode
-- require('legendary').find({ filters = require('legendary.filters').mode('n') })
-- -- show only keymaps and filter by normal mode
-- require('legendary').find({ kind = 'keymaps', filters = require('legendary.filters').mode('n') })
-- -- filter keymaps by normal mode and that start with <leader>
-- require('legendary').find({
--   filters = {
--     require('legendary.filters').mode('n'),
--     function(item)
--       if not string.find(item.kind, 'keymap') then
--         return true
--       end
--
--       return vim.startswith(item[1], '<leader>')
--     end
--   }
-- })
-- -- filter keymaps by current mode, and only display current mode in first column
-- require('legendary').find({
--   filters = { require('legendary.filters').current_mode() },
--   formatter = function(item, mode)
--     local values = require('legendary.formatter').get_default_format_values(item)
--     if string.find(item.kind 'keymap') then
--       values[1] = mode
--     end
--     return values
--   end
-- })

-- lua require('telescope').extensions.gh.issues()<cr>

-- vim.api.nvim_create_augroup('LogSitter', { clear = true})
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'Logsitter',
--   pattern = 'javascript,go,lua',
--   callback = function()
--     vim.keymap.set('n', '<localleader>lg', function ()
--       require('logsitter').log()
--     end)
--   end
-- })

-- local Utils = require "headwind.utils"
-- local ts = require "vim.treesitter"
-- local ts_query = require "vim.treesitter.query"
--
-- local M = {}
--
-- local default_options = {
--   sort_tailwind_classes = require "headwind.default_sort_order",
--   class_regex = require "headwind.class_regex",
--   run_on_save = true,
--   remove_duplicates = true,
--   prepend_custom_classes = false,
--   custom_tailwind_prefix = "",
--   use_treesitter = true
-- }
--
-- local global_options = {}
-- local is_bound = false
--
-- local function resolve_option(opts, name, is_bool)
--   if is_bool then
--     if opts[name] ~= nil then
--       return opts[name]
--     end
--
--     if global_options[name] ~= nil then
--       return global_options[name]
--     end
--
--     return default_options[name]
--   else
--     return opts[name]
--       or global_options[name]
--       or default_options[name]
--   end
-- end
--
-- local function make_options(opts)
--   opts = opts or {}
--   opts.sort_tailwind_classes = resolve_option(opts, "sort_tailwind_classes")
--   opts.class_regex = vim.tbl_extend("force", {},
--     default_options.class_regex,
--     global_options.class_regex or {},
--     opts.class_regex or {})
--   opts.custom_tailwind_prefix = resolve_option(opts, "custom_tailwind_prefix")
--   opts.prepend_custom_classes = resolve_option(opts, "prepend_custom_classes", true)
--   opts.remove_duplicates = resolve_option(opts, "remove_duplicates", true)
--   opts.run_on_save = resolve_option(opts, "run_on_save", true)
--   opts.use_treesitter = resolve_option(opts, "use_treesitter", true)
--
--   return opts
-- end
--
-- local function is_array_of_strings(value)
--   if type(value) == "table" and vim.tbl_islist(value) then
--     for _, v in ipairs(value) do
--       if type(v) ~= "string" then
--         return false
--       end
--     end
--
--     return true
--   end
--
--   return false
-- end
--
-- local function build_matcher(entry)
--   if type(entry) == "string" then
--     return { regex = { entry } }
--   elseif is_array_of_strings(entry) then
--     return { regex = entry }
--   elseif entry == nil then
--     return { regex = {} }
--   else
--     local regex = entry.regex
--     local separator = entry.separator
--
--     if type(regex) == "string" then
--       regex = { regex }
--     elseif regex == nil then
--       regex = {}
--     end
--
--     return {
--       regex = regex,
--       separator = separator,
--       replacement = entry.replacement or entry.separator
--     }
--   end
-- end
--
-- local function build_matchers(value)
--   if value == nil then
--     return {}
--   elseif type(value) == "table" and vim.tbl_islist(value) then
--     if #value == 0 then
--       return {}
--     elseif not is_array_of_strings(value) then
--       local result = {}
--
--       for _, v in ipairs(value) do
--         table.insert(result, build_matcher(v))
--       end
--
--       return result
--     end
--   end
--
--   return {build_matcher(value)}
-- end
--
-- local function sort_class_list(class_list, sort_order, prepend_custom_classes)
--   local pre_list = {}
--   local post_list = {}
--   local custom_list = prepend_custom_classes and pre_list or post_list
--   local tailwind_list = {}
--
--   for _, v in ipairs(class_list) do
--     if sort_order[v] == nil then
--       table.insert(custom_list, v)
--     else
--       table.insert(tailwind_list, v)
--     end
--   end
--
--   table.sort(tailwind_list, function(a, b)
--     return sort_order[a] < sort_order[b]
--   end)
--
--   return vim.list_extend(pre_list, vim.list_extend(tailwind_list, post_list))
-- end
--
-- local function sort_class_str(class_str, sort_order, opts)
--   local separator = opts.separator or "%s"
--   local class_list = Utils.split_pattern(class_str, separator)
--
--   if opts.remove_duplicates then
--     class_list = Utils.dedupe(class_list)
--   end
--
--   local sort_order_clone = vim.tbl_extend("force", {}, sort_order)
--
--   if opts.custom_tailwind_prefix then
--     local tbl = {}
--
--     for k, v in pairs(sort_order_clone) do
--       tbl[opts.custom_tailwind_prefix .. k] = v
--     end
--
--     sort_order_clone = tbl
--   end
--
--   class_list = sort_class_list(class_list, sort_order_clone, opts.prepend_custom_classes)
--
--   return Utils.trim_str(table.concat(class_list, opts.replacement or " "))
-- end
--
-- function M.setup(opts)
--   require "headwind.treesitter".init()
--
--   global_options = vim.tbl_extend("force", global_options, opts or {})
--   opts = make_options(opts)
--
--   if opts.run_on_save and not is_bound then
--     is_bound = true
--     vim.cmd [[augroup Headwind]]
--     vim.cmd [[autocmd Headwind BufWritePre * lua require "headwind"._on_buf_write()]]
--     vim.cmd [[augroup END]]
--   elseif not opts.run_on_save and is_bound then
--     is_bound = false
--     vim.cmd [[augroup! Headwind]]
--   end
-- end
--
-- local function sort_treesitter(bufnr, opts)
--   local root_lang_tree = ts.get_parser(bufnr, opts.ft)
--
--   if not root_lang_tree then return end
--
--   local ranges = {}
--   local sort_lookup_tbl = Utils.to_index_tbl(opts.sort_tailwind_classes)
--   local edits = {}
--
--   root_lang_tree:for_each_tree(function(tree, lang_tree)
--     local query = ts_query.get_query(lang_tree:lang(), "headwind")
--
--     for _, match, data in query:iter_matches(tree:root(), bufnr) do
--       if type(data.content) == "table" then
--         vim.list_extend(ranges, data.content)
--       else
--         for id, node in pairs(match) do
--           local name = query.captures[id]
--
--           if name == "classes" then
--             table.insert(ranges, {node:range()})
--           end
--         end
--       end
--     end
--   end)
--
--   for _, range in ipairs(ranges) do
--     local start_line, start_col, end_line, end_col = unpack(range)
--     local lines = Utils.get_buf_lines(bufnr, range)
--     local text = table.concat(lines, "\n")
--     local sorted_classes = sort_class_str(text, sort_lookup_tbl, opts)
--     local start_pos = { line = start_line, character = start_col }
--     local end_pos = { line = end_line, character = end_col }
--     local edit_range = {
--       start = start_pos
--     }
--
--     edit_range["end"] = end_pos
--
--     table.insert(edits, {
--       range = edit_range,
--       newText = sorted_classes
--     })
--   end
--
--   vim.lsp.util.apply_text_edits(edits, bufnr)
-- end
--
-- function M.visual_sort_tailwind_classes(opts)
--   local range = {Utils.get_visual_selection()}
--   local lines = Utils.get_buf_lines(0, range)
--   local str = table.concat(lines, "\n")
--   local result = M.string_sort_tailwind_classes(str, opts)
--   local edit = {
--     range = {
--       start = {
--         line = range[1],
--         character = range[2]
--       }
--     },
--     newText = result
--   }
--
--   edit.range["end"] = {
--     line = range[3],
--     character = range[4]
--   }
--
--   vim.lsp.util.apply_text_edits({edit}, 0)
-- end
--
-- function M.string_sort_tailwind_classes(str, opts)
--   opts = make_options(opts)
--
--   local sort_lookup_tbl = Utils.to_index_tbl(opts.sort_tailwind_classes)
--
--   return sort_class_str(str, sort_lookup_tbl, opts)
-- end
--
-- function M.buf_sort_tailwind_classes(bufnr, opts)
--   opts = make_options(opts)
--   bufnr = bufnr or vim.api.nvim_win_get_buf(0)
--
--   if opts.use_treesitter then
--     return sort_treesitter(bufnr, opts)
--   end
--
--   local ft = Utils.get_current_lang(bufnr, opts.ft)
--   local matchers = build_matchers(opts.class_regex[ft])
--
--   if #matchers == 0 then return end
--
--   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   local text = table.concat(lines, "\n")
--   local sort_lookup_tbl = Utils.to_index_tbl(opts.sort_tailwind_classes)
--   local edits = {}
--
--   for match_start, match_end, match in Utils.iter_matches(matchers, text) do
--     local adjusted = sort_class_str(
--       match,
--       sort_lookup_tbl,
--       vim.tbl_extend("keep", {
--         separator = match.separator,
--         replacement = match.relacement
--       }, opts))
--
--     local start_byte = vim.fn.byteidx(text, match_start)
--     local end_byte = vim.fn.byteidx(text, match_end)
--     local start_line = vim.fn.byte2line(start_byte)
--     local end_line = vim.fn.byte2line(end_byte)
--     local start_line_byte = vim.api.nvim_buf_get_offset(bufnr, start_line - 1)
--     local end_line_byte = vim.api.nvim_buf_get_offset(bufnr, end_line - 1)
--     local start_pos = { line = start_line - 1, character = start_byte - start_line_byte - 1 }
--     local end_pos = { line = end_line - 1, character = end_byte - end_line_byte - 1 }
--     local range = {
--       start = start_pos
--     }
--
--     range["end"] = end_pos
--
--     table.insert(edits, {
--       range = range,
--       newText = adjusted
--     })
--   end
--
--   vim.lsp.util.apply_text_edits(edits, bufnr)
-- end
--
-- function M._on_buf_write()
--   local cwd = vim.fn.getcwd()
--   local path = cwd .. "/tailwind.config.js"
--
--   if vim.fn.filereadable(path) == 1 then
--     M.buf_sort_tailwind_classes()
--   end
-- end
--
-- return M

return plugins
