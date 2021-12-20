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

" カーソル位置の記憶
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

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

"" 強力な補完機能
Plug 'neoclide/coc.nvim'
"" コードのハイライトを高度に
Plug 'nvim-treesitter/nvim-treesitter'
"" エクスプローラーを表示
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
"" nerdtree に git の状態を表示
Plug 'preservim/nerdtree' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin'
"" nerdtree に シンタックスハイライト
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"" コードの整列
Plug 'junegunn/vim-easy-align'
"" オプションバーの表示
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"" オートフォーマット
Plug 'Chiel92/vim-autoformat'
"" エラー検知
Plug 'w0rp/ale'
"" タブの拡張
Plug 'ervandew/supertab'
"" html
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'mattn/emmet-vim'
"" javascript
Plug 'jelera/vim-javascript-syntax'
"" nerdtree のアイコンを表示
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
"" 自動で閉じタグを補完
Plug 'alvan/vim-closetag'
"" ヤンクした箇所をハイライト
Plug 'machakann/vim-highlightedyank'
"" vim-doc を日本語化
Plug 'vim-jp/vimdoc-ja'
"" 高速なカーソル移動
Plug 'easymotion/vim-easymotion'
"" 文字列を括弧などで囲む
Plug 'machakann/vim-sandwich'
"" カーソル位置の単語で検索
Plug 'thinca/vim-visualstar'
"" ヤンクしている内容で置換
Plug 'vim-scripts/ReplaceWithRegister'
"" モーション移動の拡張
Plug 'haya14busa/vim-asterisk'
"" テキストオブジェクト拡張
Plug 'wellle/targets.vim'
"" fキーの拡張
Plug 'rhysd/clever-f.vim'
"" クイックスコープ
Plug 'unblevable/quick-scope'
"" grep の使用
Plug 'mhinz/vim-grepper'
"" 括弧に色付け
Plug 'luochen1990/rainbow'
"" 括弧の移動を高度に
Plug 'andymass/vim-matchup'
"" コメントアウトをラクに
Plug 'preservim/nerdcommenter'
"" テーマ
Plug 'haishanh/night-owl.vim'
"" fzf であいまい検索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"" nvim 起動時に管理画面を表示
Plug 'glepnir/dashboard-nvim'
"" wakatime
Plug 'wakatime/vim-wakatime'
"" ビジュアルモードでの選択箇所を増やす
Plug 'terryma/vim-expand-region'

call plug#end()
