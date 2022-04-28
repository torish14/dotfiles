" 'cursorline' を必要なときだけ有効する
"" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  setlocal cursorline
  hi clear CursorLine

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      " hi CursorLine term=underline cterm=underline gui=underline guibg=NONE " ADD
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
      " hi clear CursorLine " ADD
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          " hi clear CursorLine " ADD
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      " hi CursorLine term=underline cterm=underline gui=underline guibg=NONE " ADD
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END

" Undo の永続化
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' .. undo_path
  set undofile
endif

" カーソル位置の記憶
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

" スムーズスクロール
let s:stop_time = 10
nnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
nnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>
vnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
vnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>

function! s:down(timer) abort
  execute "normal! 3\<C-e>3j"
endfunction

function! s:up(timer) abort
  execute "normal! 3\<C-y>3k"
endfunction

function! s:smooth_scroll(fn) abort
  let working_timer = get(s:, 'smooth_scroll_timer', 0)
  if !empty(timer_info(working_timer))
    call timer_stop(working_timer)
  endif
  if (a:fn ==# 'down' && line('$') == line('w$')) ||
        \ (a:fn ==# 'up' && line('w0') == 1)
    return
  endif
  let s:smooth_scroll_timer = timer_start(s:stop_time, function('s:' . a:fn), {'repeat' : &scroll/3})
endfunction

"" ヤンクした箇所をハイライト
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" プラグイン
call plug#begin()

"" 見た目
"" テーマ
" Plug 'EdenEast/nightfox.nvim'
Plug 'baliestri/aura-theme', { 'branch': 'feat/neovim-port', 'rtp': 'packages/neovim' }
"" ハイライト強化
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
"" アイコンを表示
Plug 'kyazdani42/nvim-web-devicons'
"" ステータスバーの表示
Plug 'nvim-lualine/lualine.nvim'
"" 括弧に色付け
if !exists('g:vscode')
  Plug 'luochen1990/rainbow'
endif
"" git の差分表示
if !exists('g:vscode')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
endif
"" git下の隠しファイルの表示
if !exists('g:vscode')
  Plug 'rhysd/git-messenger.vim'
endif
"" markdown のプレビュー
Plug 'shime/vim-livedown', { 'on': [] }
"" カーソル下の単語を移動するたびにハイライト
Plug 'osyo-manga/vim-brightest', { 'on': [] }

"" 言語
"" html
if !exists('g:vscode')
  Plug 'norcalli/nvim-colorizer.lua'
endif
Plug 'mattn/emmet-vim', { 'on': [] }

"" 補完機能
"" 強力な補完機能
Plug 'neoclide/coc.nvim', { 'on': [], 'branch': 'release' }
"" 自動で閉じタグを補完
if !exists('g:vscode')
  Plug 'alvan/vim-closetag'
endif
"" 括弧を自動的に閉じる
if !exists('g:vscode')
  Plug 'windwp/nvim-autopairs'
endif
"" github copilot
if !exists('g:vscode')
  Plug 'github/copilot.vim'
endif

"" モーション移動
"" 高速なカーソル移動
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
"" カーソル位置の単語で検索
Plug 'thinca/vim-visualstar'
"" モーション移動の拡張
Plug 'haya14busa/vim-asterisk', { 'on': [] }
"" テキストオブジェクト拡張
Plug 'wellle/targets.vim', { 'on': [] }
"" fキーの拡張
Plug 'rhysd/clever-f.vim', { 'on': [] }
"" ripgrep の使用
Plug 'jremmen/vim-ripgrep', { 'on': [] }
"" 括弧の移動を高度に
Plug 'andymass/vim-matchup', { 'on': [] }
"" fzf であいまい検索
Plug 'junegunn/fzf', { 'on': [], 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"" 縦方向のスキップ移動
Plug 'tyru/columnskip.vim'
"" ワイルドメニュー
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"" 編集機能
"" 文字列を括弧などで囲む
Plug 'machakann/vim-sandwich', { 'on': [] }
"" コメントアウトをラクに
Plug 'preservim/nerdcommenter', { 'on': [] }
"" git を使う
Plug 'lambdalisue/gina.vim'
"" 行移動
Plug 'matze/vim-move'

"" その他
"" エラー検知
if !exists('g:vscode')
  Plug 'w0rp/ale', { 'on': [] }
endif
"" vim-doc を日本語化
Plug 'vim-jp/vimdoc-ja'
"" nvim 起動時に管理画面を表示
Plug 'glepnir/dashboard-nvim'
"" wakatime
Plug 'wakatime/vim-wakatime', { 'on': [] }
"" 異なるエディタ間で設定を共有
Plug 'editorconfig/editorconfig-vim'
"" ファイルタイプを検知
Plug 'nathom/filetype.nvim'
"" 翻訳
Plug 'voldikss/vim-translator'

call plug#end()

"" プラグインをタイマーで遅延読み込み
function! s:lazyLoadPlugs(timer) abort
  call plug#load (
        \ 'coc.nvim',
        \ 'ale',
        \ 'vim-sandwich',
        \ 'nerdcommenter',
        \ 'targets.vim',
        \ 'vim-asterisk',
        \ 'clever-f.vim',
        \ 'vim-ripgrep',
        \ 'vim-matchup',
        \ 'fzf',
        \ 'vim-brightest',
        \ 'vim-wakatime',
        \ )
endfunction

call timer_start(20, function("s:lazyLoadPlugs"))

"" プラグインをインサートモードで遅延読み込み
augroup load_us_insert
  autocmd!
  autocmd InsertEnter * call plug#load(
        \ 'emmet-vim',
        \ 'vim-livedown',
        \ )| autocmd! load_us_insert
augroup END

"" プラグインの設定
"" デフォルトのプラグイン読み込みをスキップ
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

"" 見た目
"" nvim-treesitter
if !exists('g:vscode')
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",

  sync_install = false,

  ignore_install = {},

  highlight = {
  enable = true,
  disable = {},
  additional_vim_regex_highlighting = false,
  },
}
EOF

endif

"" nvim-web-devicons
if !exists('g:vscode')
lua << EOF
require 'nvim-web-devicons'.setup {
  default = true
  }
EOF
endif

"" lualine
lua << END
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
END

"" rainbow
if !exists('g:vscode')
  let g:rainbow_active = 1
endif

"" vim-livedown
if !exists('g:vscode')
  let g:livedown_autorun = 0
  let g:livedown_port = 0803
endif
"" 言語
"" nvim-colorizer
lua << EOF
require'colorizer'.setup()
EOF

"" python
let g:python_host_prog = $PYENV_ROOT.'/versions/neovim-2/bin/python'
let g:python3_host_prog = '~/.pyenv/versions/3.10.1/bin/python3'

augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal
        \ formatoptions+=croq softtabstop=2
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

"" typescript
let g:typescript_indent_disable = 1

"" template
augroup templateGroup
  autocmd!
  autocmd BufNewFile *.html :0r ~/vim-template/t.html
  autocmd BufNewFile *.cpp :0r ~/vim-template/t.cpp
  autocmd BufNewFile *.py :0r ~/vim-template/t.py
augroup END

set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 12

"" emmet-vim
autocmd FileType html imap <buffer><expr><tab>
      \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" :
      \ "\<tab>"

"" 補完機能
"" vim-closetag
if !exists('g:vscode')
  let g:closetag_filenames = '*.html, *.xhtml, *.phthml, *.vue'
endif

"" モーション移動
"" vim-easymotion
"" Disable default mappings
let g:EasyMotion_do_mapping = 0 
let g:EasyMotion_smartcase = 1

" wilder.nvim
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

"" clever-f.vim
let g:clever_f_ignore_case = 1
let g:clever_f_use_migemo = 1

"" 編集機能
"" nerdcommenter
let g:NERDSpaceDelims = 1

"" vim-move
"" コントロールキー + k / j / h / l で行の移動
let g:move_key_modifier = 'C'

"" その他
" 保存時のみ ale を実行する
if !exists('g:vscode')
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
" 表示に関する設定
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEWarningSign StorageClass
highlight link ALEErrorSign Tag
endif

"" dashboard-nvim
let g:dashboard_default_executive ='fzf'
let g:dashboard_custom_header = [
      \'                                   ',
      \'                                   ',
      \'                                   ',
      \'   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ',
      \'    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
      \'          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ',
      \'           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
      \'          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
      \'   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
      \'  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
      \' ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
      \' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ',
      \'      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
      \'       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
      \'                                   ',
      \]

"" filetype
lua << EOF
require("filetype").setup({
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
EOF

"" vim-translator
let g:translator_target_lang = 'ja'

" 設定

"" 基本設定
"" 文字コードを UFT-8 に設定
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set ttimeout
set ttimeoutlen=50
" バックアップを取らない
set nobackup
set nowritebackup
"" スワップファイルを作らない
set noswapfile
set nobomb
"" ヤンクをクリップボードへ繋ぐ
set clipboard=unnamed
"" 編集中のファイルが変更されたら自動で読み直す
set autoread
"" バッファが編集中でもその他のファイルを開けるように
set hidden

"" 見た目
"" 行番号を表示
set number
set ruler
" 常にサインカラムを表示
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
set showcmd
" メッセージの表示欄の高さを設定
set cmdheight=2
" メニューにメッセージを渡さない
set shortmess+=c
set modeline
set modelines=10
set scrolloff=3
"" 長いコードを折り返す
set wrap
"" 長いコードも表示する
set display=lastline
set mouse=a
set title
set titleold="Termminal"
"" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
"" インデントはスマートインデント
set smartindent
"" ビープ音を可視化
set visualbell
"" 括弧入力時の対応する括弧を表示
set showmatch
set matchtime=1
"" ステータスライン を 1 つにする
set laststatus=3
"" コマンドラインの補完
set wildmode=list:longest
"" 新規ファイルを横に開く
set splitright
"" guiカラーの許可
set termguicolors
"" シンタックスハイライトの有効化
syntax enable
"" カラーテーマ
" colorscheme nightfox
colorscheme aura-soft-dark

"" 検索ハイライトの色を変更
autocmd ColorScheme * hi Search guibg=#a277ff guifg=#15141b
autocmd ColorScheme * hi incSearch guibg=#a277ff guifg=#15141b
"" 補完のポップアップの色を変更
autocmd ColorScheme * hi menu guibg=#15141b guifg=#edecee
autocmd ColorScheme * hi PmenuSel guibg=#a277ff guifg=#15141b
autocmd ColorScheme * hi PmenuSbar guibg=#15141b guifg=#edecee
autocmd ColorScheme * hi PmenuThumb guibg=#15141b guifg=#edecee
"" ワイルドメニューの色を変更
autocmd ColorScheme * hi Wildmenu guibg=#a277ff guifg=#15141b

"" Tab
"" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
"" Tab文字を半角space にする
set expandtab
"" 行頭以外のTab文字の表示幅（space いくつ分）
set tabstop=2
set softtabstop=2
"" 行頭でのTab文字の表示幅
set shiftwidth=2

"" 検索
"" 履歴
set history=1000
"" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"" 検索語をハイライト表示
set hlsearch
"" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
"" 検索時に最後まで行ったら最初に戻る
set wrapscan
"" 一括置換するときファイルを分割して編集箇所を見やすくする
set inccommand=split
"" 補完数を10個にする
set pumheight=10
"" ESC 連打でハイライト解除
nmap <ESC><Esc> :nohlsearch<CR><Esc>
set backspace=indent,eol,start
"" help を日本語化
set helplang=ja
"" 行数の相対表示
set relativenumber
"" 新しい行のインデントを現在行と同じにする
set autoindent
"" 背景色に合わせて色を修正
set background=dark
"" 遅延読み込み
set updatetime=100
set re=1
set ttyfast
set lazyredraw

" leader を spaceキーに
let mapleader="\<Space>"

" キーマップ

"" ノーマルモード
"" 保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qq :q!<CR>
nnoremap <Leader>e :e<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>x :x<CR>

"" プラグインの制御
nnoremap <leader>pi :PlugInstall<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <leader>pc :PlugClean<cr>
nnoremap <leader>ch :CheckHealth<cr>

"" 移動
if !exists('g:vscode')
  nnoremap j gj
  nnoremap k gk
  nnoremap <Down> gj
  nnoremap <Up> gk
else
  nmap j gj
  nmap k gk
  nmap <Down> gj
  nmap <Up> gk
endif
nnoremap <C-;> g;
nnoremap <C-,> g,
"" 行頭、行末に移動
nnoremap <C-a> <Esc>^i
nnoremap 0 ^
nnoremap ^ 0
nnoremap <C-e> <Esc>$a
"" タブの移動
nnoremap <silent> <C-g> <Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>
nnoremap <silent> <C-s> <Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>
"" インデントに合わせてペースト
nnoremap p ]p
nnoremap P ]P
"" Y で行末までヤンク
nnoremap Y y$
"" + で数値 up
nnoremap + <C-a>
"" - で数値 down
nnoremap - <C-x>
"" カーソル下の単語を置換後の文字列の入力待ちにする
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;
"" space + , で .init.vim を開く
nnoremap <Leader>, :vertical new ~/.config/nvim/init.vim<CR>
"" Enter を押すと改行
nnoremap <CR> i<Return><Esc>^k
"" `i` の省略
nmap cw ciw
nmap ct cit
nmap c( ci(
nmap c{ ci{
nmap c[ ci[
nmap c< ci<
nmap c' ci'
nmap c" ci"
nmap c` ci`

nmap dw diw
nmap dt dit
nmap d( di(
nmap d{ di{
nmap d[ di[
nmap d< di<
nmap d' di'
nmap d" di"
nmap d` di`

nmap vw viw
nmap vt vit
nmap v( vi(
nmap v{ vi{
nmap v[ vi[
nmap v< vi<
nmap v' vi'
nmap v" vi"
nmap v` vi`

nmap yw yiw
nmap yt yit
nmap y( yi(
nmap y{ yi{
nmap y[ yi[
nmap y< yi<
nmap y' yi'
nmap y" yi"
nmap y` yi`

"" terminal
nnoremap <Leader>sh :vertical terminal<CR>
:tnoremap <Esc> <C-\><C-n>
command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
autocmd TermOpen * startinsert

"" split（画面分割）
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l
nnoremap <Leader>s :<C-u>split<CR>
nnoremap <Leader>v :<C-u>vsplit<CR>

" 画面サイズの制御
function! s:manageEditorSize(...)
  let count = a:1
  let to = a:2
  for i in range(1, count ? count : 1)
    call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
  endfor
endfunction

if exists('g:vscode')
  nnoremap <C-w>> <Cmd>call <SID>manageEditorSize(v:count, 'increase')<CR>
  xnoremap <C-w>> <Cmd>call <SID>manageEditorSize(v:count, 'increase')<CR>
  nnoremap <C-w>+ <Cmd>call <SID>manageEditorSize(v:count, 'increase')<CR>
  xnoremap <C-w>+ <Cmd>call <SID>manageEditorSize(v:count, 'increase')<CR>
  nnoremap <C-w>< <Cmd>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  xnoremap <C-w>< <Cmd>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  nnoremap <C-w>- <Cmd>call <SID>manageEditorSize(v:count, 'decrease')<CR>
  xnoremap <C-w>- <Cmd>call <SID>manageEditorSize(v:count, 'decrease')<CR>
endif

"" gitsigns.nvim
if !exists('g:vscode')
lua << EOF
require('gitsigns').setup()
EOF
endif

"" coc.nvim
if !exists('g:vscode')
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
  endfunction

  augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  "" space 2回で CocList
  nmap <silent> <Leader><space> :<C-u>CocList<cr>
  "" space + gd で定義元へ移動
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  "" space + rn で Rename
  nmap <silent> <Leader>rn <Plug>(coc-rename)
  "" space + fm で Format
  nmap <silent> <Leader>fm <Plug>(coc-format)
  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)
  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)
  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)
endif

"" nvim-autopairs
if !exists('g:vscode')
lua << EOF
require('nvim-autopairs').setup{}
EOF
endif

"" vim-easymotion
nmap <Leader>m <Plug>(easymotion-overwin-f)
nmap <Leader>m <Plug>(easymotion-overwin-f2)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

"" fzf
xmap <leader><tab> <plug>(fzf-maps-x)
nmap <leader><tab> <plug>(fzf-maps-n)
omap <leader><tab> <plug>(fzf-maps-o)

"" columnskip.vim
nmap <S-j> <Plug>(columnskip:nonblank:next)
omap <S-j> <Plug>(columnskip:nonblank:next)
xmap <S-j> <Plug>(columnskip:nonblank:next)
nmap <S-k> <Plug>(columnskip:nonblank:prev)
omap <S-k> <Plug>(columnskip:nonblank:prev)
xmap <S-k> <Plug>(columnskip:nonblank:prev)

"" keyboard-quickfix
nnoremap z= <Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>

"" dashboard-nvim
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

"" vim-translator
nmap <silent> <Leader>tl <Plug>Translate
vmap <silent> <Leader>tl <Plug>TranslateV
" Display translation in a window
nmap <silent> <Leader>tw <Plug>TranslateW
vmap <silent> <Leader>tw <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <Leader>tr <Plug>TranslateR
vmap <silent> <Leader>tr <Plug>TranslateRV
" Translate the text in clipboard
nmap <silent> <Leader>tx <Plug>TranslateX

"" インサートモード
"" Emacs のキーバインド使用
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-d> <Del>
inoremap <C-h> <BS>
inoremap <C-k> <C-r>=<SID>kill()<CR>
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
"" ctrlキーで行頭、行末に移動
inoremap <C-a> <Esc>^i
inoremap <C-e> <Esc>$a
"" ctrl + k でカーソル位置から行末まで削除
inoremap <C-K> <C-O>D
"" jキーを二度押しで ESCキー
inoremap <silent> jj <Esc>
inoremap <silent> っｊ <ESC>
"" 補完表示時の Enter で改行しない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
"" 補完表示時に ctrl + Enter で確定
inoremap <C-CR> <C-y>

"" fzf
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

"" coc.nvim
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
