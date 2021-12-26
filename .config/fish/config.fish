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

# fish キーバインド
function fish_user_key_bindings
    # control + R
    bind \cr 'peco_select_history (commandline -b)'
    # control + X からの control + K
    bind \cx\ck peco_kill
    bind \c] peco_select_ghq_repository
    bind \c] 'stty sane; peco_select_ghq_repository'
    bind /cg ghq_peco_repo
    bind \cg ghq_fzf_repo
    bind \cx\cl peco_open_gh_repository
    bind \cx\cr peco_recentdend
end

set -U FZF_LEGACY_KEYBINDINGS 0
# "--reverse --height=100%"
set -U FZF_REVERSE_ISEARCH_OPTS

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
    ghq get $arvg[1]
    code (ghq list --full-path -e $argv[1])
end

# abbr
abbr b brew
abbr bc 'brew cleanup'
abbr bd 'brew doctor'
abbr bi 'brew install'
abbr bl 'brew list'
abbr bud 'brew update'
abbr bug 'brew upgrade'

abbr c bat
abbr cat bat
abbr cafi 'caffeinate -i'
abbr co code
abbr cu curl

abbr du ncdu

abbr e emacs

abbr f fd

# git
abbr g git
abbr gi 'git init'
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
abbr gaa 'git add .'
# 直前の add を取り消し
abbr grh 'git reset HEAD'
# 直前の commit のみを取り消し
abbr grs 'git reset --soft HEAD^'
# 直前の commit をまるっと取り消し
abbr grhh 'git reset --hard HEAD^'
# git reset の取り消し
abbr grho 'git reset --hard ORIG_HEAD'
# コミットメッセージを修正
abbr gri 'git rebase -i'
abbr grir 'git rebase -i --root'
abbr gra 'git remote add'
abbr grao 'git remote add origin'
abbr grv 'git remote -v'
abbr gd 'git diff'
abbr gdc 'git diff --cached'
abbr gl 'git log --graph'
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
abbr gpf 'git push -f'
abbr gpo 'git push origin'
abbr gpom 'git push origin main'
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
abbr gstl 'git stash list'

abbr grep rg

abbr his history

abbr j jobs

abbr k 'kill -9'

abbr ka killall

abbr la 'exa -aF --icons'
abbr ls 'exa -h --icons'
abbr ll 'exa -laF --icons'

abbr mk 'mkdir -pv'
