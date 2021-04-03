# Shell Scriptは半角スペーズが無視されないので気をつけること．
# デフォルト環境変数(5つ)
# export PATH="$PATH:/usr/local/bin"
# export PATH="$PATH:/usr/bin"
# export PATH="$PATH:/bin"
# export PATH="$PATH:/usr/local/sbin"
# export PATH="$PATH:/usr/sbin"
# export PATH="$PATH:/sbin"

# エイリアスの作成
# lsコマンドをexaにする
alias ls="exa -F"
alias la="exa -aF"
alias ll="exa -hlF --git"
alias lla="exa -ahlF --git"
alias lt="exa -FT"
alias lta="exa -FTa"
alias llt="exa -hlFT --git"
alias llta="exa -hlFTa --git"

# git ブランチ名を色付きで表示させるメソッド
function prompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # git 管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプト右側にメソッドの結果を表示させる
RPROMPT='`prompt-git-current-branch`'

# ターミナル上の表示をパスのみにし，コマンド実行後は改行する
PS1="
%B%F{cyan}%~%f%b $ "
# 下記の書き方でも同じ(改行の仕方が違う)($'\n'を使っている)
# PS1=""$'\n'"%B%F{cyan}%~%f%b $ "

# sourceコマンドは必ずファイルの最後に書くこと