# peco であいまい検索
function peco_select_history_order
    if test (count $argv) = 0
        set peco_flags --layout=top-down
    else
        set peco_flags --layout=bottom-up --query "$argv"
    end

    history | peco $peco_flags | read foo

    if [ $foo ]
        commandline $foo
    else
        commandline ''
    end
end

# ghq + peco
function ghq_peco_repo
    set selected_repository (ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_repository" ]
        cd $selected_repository
        echo " $selected_repository "
        commandline -f repaint
    end
end

# ghq + fzf
function ghq_fzf_repo -d 'Repository search'
    ghq list --full-path | fzf --reverse --height=100% | read select
    [ -n "$select" ]; and cd "$select"
    echo " $select "
    commandline -f repaint
end

# github にリポジトリを作成して ghq で取得、vscode で開く
function ghcr
    gh repo create $argv
    ghq get git@github.com:torish14/{$argv[1]}.git
    code /Users/user/ghq/github.com/torish14/{$argv[1]}
end

# fish キーバインド
function fish_user_key_bindings
    # control + R
    bind \cr 'peco_select_history (commandline -b)'
    # control + X からの control + K
    bind \cx\ck peco_kill
    # control + ]
    bind \c] peco_select_ghq_repository
    bind \c] 'stty sane; peco_select_ghq_repository'
    bind /cg ghq_peco_repo
    # control + G
    bind \cg ghq_fzf_repo
    # control + X からの control + L
    bind \cx\cl peco_open_gh_repository
    # control + X からの control + R
    bind \cx\cr peco_recentdend
end

set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"
set -gx LDFLAGS "-L/usr/local/opt/python@3.8/lib"

# 日本語の使用
set -x LANG ja_JP.UTF-8
set -x LC_CTYPE ja_JP.UTF-8
set -x LC_ALL ja_JP.UTF-8

# abbr
abbr b brew
abbr bc 'brew cleanup'
abbr bi 'brew install'
abbr bls 'brew list'
abbr bud 'brew update'
abbr bug 'brew upgrade'

abbr c bat
abbr cat bat
abbr cafi 'caffeinate -i'
abbr co code
abbr cu curl

abbr du dust

abbr e emacs

abbr f fd

# git
abbr g git
abbr gs 'git status'
abbr gb 'git branch'
abbr gco 'git checkout'
# branch を作成 & 切り替え
abbr gcob 'git checkout -b'
abbr gc 'git commit'
abbr gcm 'git commit -m'
# 直前の commit の修正
abbr gca 'git commit --amend'
abbr gg 'git grep'
abbr gi 'git init'
abbr ga 'git add'
abbr gap 'git add -p'
abbr gaa 'git add -A'
# 直前の add を取り消し
abbr grh 'git reset HEAD'
# 直前の commit のみを取り消し
abbr grs 'git reset --soft HEAD^'
# 直前の commit をまるっと取り消し
abbr grhh 'git reset --hard HEAD^'
# git reset の取り消し
abbr grho 'git reset --hard ORIG_HEAD'
# コミットメッセージを修正
abbr grih 'git rebase -i HEAD~'
abbr grir 'git rebase -i --root'
abbr grc 'git rebase --continue'
abbr gra 'git remote add'
abbr grao 'git remote add origin'
abbr grv 'git remote -v'
abbr gd 'git diff'
abbr gdc 'git diff --cached'
abbr gl 'git log --graph --all --pretty=format:"%C(yellow reverse)%d%Creset%C(white reverse) %h% Creset %C(cyan reverse) %an %Creset %C(green)%ar%Creset%n%C(white)%w(80)%s%Creset%n%n%w(80,2,2)%b"'
abbr gln 'git log --name-status'
abbr gls "git log --stat"
abbr glo 'git log --oneline'
abbr gcma 'git checkout main'
abbr gf 'git fetch'
abbr gfu 'git fetch upstream'
abbr gfo 'git fetch origin'
abbr gmod 'git merge origin/develop'
abbr gmom 'git merge origin/main'
abbr gp 'git push'
abbr gpf 'git push --force-with-lease'
abbr gpo 'git push origin'
abbr gpom 'git push origin main'
abbr gpl 'git pull'
# 変更の退避
abbr gst 'git stash -u'
# 退避した作業を戻す
abbr gsta 'git stash apply'
# 退避した作業を消す
abbr gstd 'git stash drop'
# 退避した作業を戻す & stash のリストから消す
abbr gstp 'git stash pop'
# stash にコメントを追加する
abbr gsts 'git stath save'
# stash の一覧
abbr gstls 'git stash list'

abbr grep rg

abbr his history

abbr j jobs

abbr k 'kill -9'
abbr ka killall

abbr la 'exa -aF --icons'
abbr ls 'exa -h --icons'
abbr ll 'exa -laF --icons'

abbr mk 'mkdir -pv'

abbr ni 'npm install'
abbr nig 'npm install -g'
abbr nrd 'npm run dev'
abbr nrf 'npm run format'
abbr nrl 'npm run lint'
abbr nr 'npm remove'

abbr nsl nslookup

abbr op open
abbr opa 'open -a'

abbr p pnpm
abbr pa 'pnpm add'
abbr pad 'pnpm add -D'
abbr pd 'pnpm dev'
abbr pf 'pnpm format'
abbr pi 'pnpm install'
abbr pu 'pnpm up'
abbr pr 'pnpm remove'
abbr pl 'pnpm lint'
abbr pls 'pnpm list'
abbr ps 'procs --sortd cpu'

abbr ql 'qlmanage -p'

abbr r rg

abbr rmf 'rm -rfv'

abbr s sudo
abbr sp 'sudo purge'
abbr sr 'sudo reboot'
abbr ss 'sudo shutdown -h now'
abbr so source

# tigコマンド
abbr t tig
abbr ts 'tig status'
abbr tb 'tig blame'
abbr tg 'tig grep'

abbr tl tldr
abbr tm tmux
abbr to touch
abbr top glances
abbr tr tree
abbr trai 'tree -a -I ".git|node_modules|bower_components|.DS_Store" -L 3 -C'
abbr trl2 'tree -L 2 -C'
abbr trl3 'tree -L 3 -C'

abbr v nvim
abbr vi nvim
abbr vim nvim
abbr vf 'nvim ~/.config/fish/config.fish'
abbr vn 'nvim ~/.config/nvim/init.vim'
abbr vr 'nvim ~/.vimrc'
abbr vs 'nvim ~/.config/starship.toml'

abbr y yarn
abbr ya 'yarn add'
abbr yad 'yarn add -D'
abbr yd 'yarn dev'
abbr yu 'yarn upgrade'
abbr yf 'yarn format'
abbr yl 'yarn lint'
abbr yr 'yarn remove'

abbr ... cd ../..
abbr .... cd ../../..

# starship の読み込み
starship init fish | source
