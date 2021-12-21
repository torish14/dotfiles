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
"" nerdtree に シンタックスハイライト
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': [] }
"" コードの整列
Plug 'junegunn/vim-easy-align'
"" オプションバーの表示
Plug 'vim-airline/vim-airline', { 'on': [] }
Plug 'vim-airline/vim-airline-themes'
"" オートフォーマット
Plug 'Chiel92/vim-autoformat', { 'on': [] }
"" nerdtree のアイコンを表示
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
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
"" 相対番号と絶対番号の入れ替え
Plug 'jeffkreeftmeijer/vim-numbertoggle'
"" ブックマーク
Plug 'MattesGroeger/vim-bookmarks'
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
"" ペーストした際に自動でインデント
Plug 'sickill/vim-pasta'
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
"" ビジュアルモードでの選択箇所を増やす
Plug 'terryma/vim-expand-region'
"" . でのリピート機能の拡張
Plug 'tpope/vim-repeat', { 'on': [] }
"" git を使う
Plug 'tpope/vim-fugitive', { 'on': [] }
"" fugitive の拡張
Plug 'tpope/vim-rhubarb', { 'on': [] }
"" 一行のコードと複数行のコードの入れ替え
Plug 'AndrewRadev/splitjoin.vim', { 'on': [] }
"" 行移動
Plug 'matze/vim-move'

"" それ以外
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

call plug#end()

" プラグインをタイマーで遅延読み込み
function! s:lazyLoadPlugs(timer)
  call plug#load (
        \ 'coc.nvim',
        \ 'nerdtree',
        \ 'vim-nerdtree-tabs',
        \ 'nerdtree-git-plugin',
        \ 'vim-airline',
        \ 'vim-autoformat',
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

" プラグインをインサートモードで遅延読み込み
augroup load_us_insert
  autocmd!
  autocmd InsertEnter * call plug#load(
        \ 'supertab',
        \ 'vim-css3-syntax',
        \ 'vim-coloresque',
        \ 'emmet-vim',
        \ 'vim-javascript-syntax',
        \ 'live-preview',
        \ )| autocmd! load_us_insert
augroup END

" 設定

"" 基本設定
"" 文字コードを UFT-8 に設定
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,sjis
"" バックアップファイルを作らない
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

"" 見た目系
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

"" Tab系
"" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
"" Tab文字を半角スペースにする
set expandtab
"" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
set softtabstop=2
"" 行頭でのTab文字の表示幅
set shiftwidth=2

"" 検索系
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
