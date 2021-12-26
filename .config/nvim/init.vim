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
      hi CursorLine term=underline cterm=underline gui=underline guibg=NONE " ADD
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
      hi clear CursorLine " ADD
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          " setlocal nocursorline
          hi clear CursorLine " ADD
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      " setlocal cursorline
      hi CursorLine term=underline cterm=underline gui=underline guibg=NONE " ADD
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

" プラグインを使用するためのおまじない
if !filereadable(expand('~/.vim/autoload/plug.vim'))
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

" プラグイン
call plug#begin('~/.vim/plugged')

"" 見た目
"" テーマ
Plug 'haishanh/night-owl.vim'
"" コードのハイライトを高度に
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
"" エクスプローラーを表示
Plug 'scrooloose/nerdtree', { 'on': [] }
Plug 'jistr/vim-nerdtree-tabs', { 'on': [] }
"" nerdtree に git の状態を表示
Plug 'preservim/nerdtree' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [] }
"" nerdtree にシンタックスハイライト
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': [] }
"" nerdtree のアイコンを表示
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
"" オプションバーの表示
Plug 'vim-airline/vim-airline', { 'on': [] }
Plug 'vim-airline/vim-airline-themes'
"" ヤンクした箇所をハイライト
Plug 'machakann/vim-highlightedyank'
"" 括弧に色付け
Plug 'luochen1990/rainbow'
"" git の差分表示
Plug 'airblade/vim-gitgutter'
"" git下の隠しファイルの表示
Plug 'rhysd/git-messenger.vim'
"" markdown のプレビュー
Plug 'shime/vim-livedown', { 'on': [] }
"" カーソル下の単語を移動するたびにハイライト
Plug 'osyo-manga/vim-brightest', { 'on': [] }

"" 言語
"" html
Plug 'hail2u/vim-css3-syntax', { 'on': [] }
Plug 'gorodinskiy/vim-coloresque', { 'on': [] }
Plug 'mattn/emmet-vim', { 'on': [] }
"" javascript
Plug 'jelera/vim-javascript-syntax', { 'on': [] }

"" 補完機能
"" 強力な補完機能
Plug 'neoclide/coc.nvim', { 'on': [], 'branch': 'release' }
"" 自動で閉じタグを補完
Plug 'alvan/vim-closetag'
"" 括弧を自動的に閉じる
Plug 'cohama/lexima.vim'
"" ワイルドメニュー
if has('nvim')
  Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'gelguy/wilder.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
"" github copilot
Plug 'github/copilot.vim'

"" モーション移動
"" 高速なカーソル移動
Plug 'easymotion/vim-easymotion', { 'on': [] }
"" カーソル位置の単語で検索
Plug 'thinca/vim-visualstar'
"" モーション移動の拡張
Plug 'haya14busa/vim-asterisk'
"" テキストオブジェクト拡張
Plug 'wellle/targets.vim'
"" fキーの拡張
Plug 'rhysd/clever-f.vim', { 'on': [] }
"" クイックスコープ
Plug 'unblevable/quick-scope', { 'on': [] }
"" grep の使用
Plug 'mhinz/vim-grepper'
"" 括弧の移動を高度に
Plug 'andymass/vim-matchup', { 'on': [] }
"" fzf であいまい検索
Plug 'junegunn/fzf', { 'on': [], 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"" 縦方向のスキップ移動
Plug 'tyru/columnskip.vim'

"" 編集機能
"" タブキーの拡張
Plug 'ervandew/supertab', { 'on': [] }
"" 文字列を括弧などで囲む
Plug 'machakann/vim-sandwich', { 'on': [] }
"" ヤンクしている内容で置換
Plug 'vim-scripts/ReplaceWithRegister'
"" 指定ファイルでの文字列の置換
Plug 'brooth/far.vim'
"" コメントアウトをラクに
Plug 'preservim/nerdcommenter', { 'on': [] }
"" . でのリピート機能の拡張
Plug 'tpope/vim-repeat'
"" git を使う
Plug 'tpope/vim-fugitive', { 'on': [] }
"" fugitive の拡張
Plug 'tpope/vim-rhubarb', { 'on': [] }
"" 一行のコードと複数行のコードの入れ替え
Plug 'AndrewRadev/splitjoin.vim', { 'on': [] }
"" 行移動
Plug 'matze/vim-move'

"" その他
"" エラー検知
Plug 'w0rp/ale', { 'on': [] }
"" vim-doc を日本語化
Plug 'vim-jp/vimdoc-ja'
"" nvim 起動時に管理画面を表示
Plug 'glepnir/dashboard-nvim'
"" wakatime
Plug 'wakatime/vim-wakatime'
"" 異なるエディタ間で設定を共有
Plug 'editorconfig/editorconfig-vim'
"" キーマップの表示
Plug 'folke/which-key.nvim'
call plug#end()

"" プラグインをタイマーで遅延読み込み
function! s:lazyLoadPlugs(timer)
  call plug#load (
        \ 'coc.nvim',
        \ 'nerdtree',
        \ 'vim-nerdtree-tabs',
        \ 'nerdtree-git-plugin',
        \ 'vim-airline',
        \ 'ale',
        \ 'vim-easymotion',
        \ 'vim-sandwich',
        \ 'nerdcommenter',
        \ 'clever-f.vim',
        \ 'quick-scope',
        \ 'vim-nerdtree-syntax-highlight',
        \ 'vim-matchup',
        \ 'fzf',
        \ 'splitjoin.vim',
        \ 'vim-fugitive',
        \ 'vim-rhubarb',
        \ 'vim-brightest',
        \ )
endfunction

call timer_start(100, function("s:lazyLoadPlugs"))

"" プラグインをインサートモードで遅延読み込み
augroup load_us_insert
  autocmd!
  autocmd InsertEnter * call plug#load(
        \ 'supertab',
        \ 'vim-css3-syntax',
        \ 'vim-coloresque',
        \ 'emmet-vim',
        \ 'vim-javascript-syntax',
        \ 'vim-livedown',
        \ )| autocmd! load_us_insert
augroup END

"" プラグインの設定
"" 見た目
"" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
ignore_install = { "haskell" }, -- List of parsers to ignore installing
highlight = {
enable = true,              -- false will disable the whole extension
disable = { "c", "ruby" },  -- list of language that will be disabled
},
  }
EOF

"" nerdtree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeShowHidden=1
let g:NERDTreeLimitedSyntax = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

"" vim-airline
let g:airline_theme = 'kolor'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'

"" rainbow
let g:rainbow_active = 1

"" vim-livedown
let g:livedown_autorun = 0
let g:livedown_port = 0803
let g:livedown_browser = "vivaldi"

"" 言語
"" python
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

"" syntax
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" emmet-vim
autocmd FileType html imap <buffer><expr><tab>
      \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" :
      \ "\<tab>"

"" 補完機能
"" coc.nvim
"" space 2回で CocList
nmap <silent> <space><space> :<C-u>CocList<cr>
"" space + gd で定義元へ移動
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" space + rn で Rename
nmap <silent> <space>rn <Plug>(coc-rename)
"" space + fm で Format
nmap <silent> <space>fm <Plug>(coc-format)

"" vim-closetag
let g:closetag_filenames = '*.html, *.xhtml, *.phthml, *.vue'

"" wilder.nvim
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

"" モーション移動
"" vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1

"" clever-f.vim
let g:clever_f_ignore_case = 1
let g:clever_f_use_migemo = 1

"" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
"" 遅延読み込み
let g:qs_lazy_highlight = 1
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline
augroup END

"" 編集機能
"" nerdcommenter
let g:NERDSpaceDelims = 1

"" vim-move
"" コントロールキー + k / j / h / l で行の移動
let g:move_key_modifier = 'C'

"" その他
" 保存時のみ ale を実行する
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
" 表示に関する設定
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass

"" dashboard-nvim
let g:dashboard_default_executive ='fzf'
let g:dashboard_custom_shortcut={
      \ 'last_session'       : 'SPC s l',
      \ 'find_history'       : 'SPC f h',
      \ 'find_file'          : 'SPC f f',
      \ 'new_file'           : 'SPC c n',
      \ 'change_colorscheme' : 'SPC t c',
      \ 'find_word'          : 'SPC f a',
      \ 'book_marks'         : 'SPC f b',
      \ }

"" which-key.nvim
lua << EOF
require("which-key").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  }
EOF

" 設定

"" 基本設定
"" 文字コードを UFT-8 に設定
set fenc=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set nobackup
"" スワップファイルを作らない
set noswapfile
set fileformats=unix,dos,mac
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
set showcmd
set modeline
set modelines=10
set scrolloff=3
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
"" ステータスラインを常に表示
set laststatus=2
"" 色の設定
set t_Co=256
"" コマンドラインの補完
set wildmode=list:longest
"" 新規ファイルを横に開く
set splitright
"" guiカラーの許可
set termguicolors
"" シンタックスハイライトの有効化
syntax enable
"" テーマ
colorscheme night-owl
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
set history=5000
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

" 意図しない挙動を防ぐ
filetype on
filetype plugin indent on

" leader を spaceキーに
let mapleader="\<Space>"

" キーマップ
"" ノーマルモード
"" 保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>qq :q!<CR>
nnoremap <Leader>e :e<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>nn :noh<CR>

"" プラグインの制御
nnoremap <leader>ii :PlugInstall<cr>
nnoremap <leader>iu :PlugUpdate<cr>
nnoremap <leader>ic :PlugClean<cr>
nnoremap <leader>ih :CheckHealth<cr>

"" 移動
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
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

"" nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

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
