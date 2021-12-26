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
