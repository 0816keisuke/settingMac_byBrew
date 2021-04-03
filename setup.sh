#!/bin/bash

# Homebrewの確認
while read -p "Do You have \"Homebrew?\" y/n: " yn; do
    if [ $yn = "y" ]; then
        # brewコマンドのパス確認
        which brew > /dev/null
        if [ $? != 0 ]; then
            echo "Create path 'brew' command. Exit."
            exit
        fi
        echo "Continue process."
        break
    elif [ $yn = "n" ]; then
        echo "Please install Homebrew first. Exit."
        exit
    else
        echo "Please Input y or n."
    fi
done

# エラー発生時点で終了
set -e -o pipefail 
trap 'echo "ERROR: line no = $LINENO, exit status = $?" >&2; exit 1' ERR

# BrewListを読み込み後，改行とコメントアウト行を削除して各行を配列化
all_list=(`cat BrewList | grep -vE "^$|#"`)

# --formulaeのスペルチェック
if [ ${all_list[0]} != "--formulae" ]; then
    echo "'--formulae' is NOT written. Exit."
    exit
fi

# --casksのスペルチェック
flag=0
for ((idx=0; idx<${#all_list[@]}; idx++)); do
    if [ ${all_list[$idx]} == "--casks" ]; then
        flag=1
        break
    fi
done
if [ $flag -eq 0 ]; then
    echo "'--casks' is NOT written. Exit."
    exit
fi

formulae_list=("${all_list[@]}")
cask_list=("${all_list[@]}")

# インストールするformulaeをリスト化
unset formulae_list[0]
for ((i=$idx; i<${#all_list[@]}; i++)); do
    unset formulae_list[$i]
done
formulae_list=(${formulae_list[@]})

# インストールするcaskをリスト化
for ((i=0; i<=$idx; i++)); do
    unset cask_list[$i]
done
cask_list=(${cask_list[@]})

# echo "     all: ${all_list[@]}"
# echo "formulae: ${formulae_list[@]}"
# echo "    cask: ${cask_list[@]}"

# formulaeのインストール
for formulae in ${formulae_list[@]}; do
    echo "Installing $formulae..."
    brew install $formulae
done

# caskのインストール
for cask in ${cask_list[@]}; do
    echo "Installing $cask..."
    brew install --cask $cask
done

# iTerm2のカラースキーム(iceberg)のインストール
curl -o ~/Downloads/iceberg.itermcolors -O https://raw.githubusercontent.com/aseom/dotfiles/master/osx/iterm2/iceberg.itermcolors

# gitconfigの作成
if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig
fi

read -p "Enter your user name on Git: " git_user_name
read -p "Enter your email address on Git: " git_mail
git config --global user.name $git_user_name
git config --global user.email $git_mail

# .zshrc
cp ./.zshrc ~/.zshrc

# vimrcの作成
if [ ! -e ~/.vimrc ]; then
    touch ~/.vimrc
fi

# 研究室用ディレクトリの作成
if [ ! -d ~/lab/ ]; then
    mkdir ~/lab
fi

# Python用ディレクトリの作成
if [ ! -d ~/python/ ]; then
    mkdir ~/python
fi

# C/C++用ディレクトリの作成
if [ ! -d ~/c_cpp/ ]; then
    mkdir ~/c_cpp
fi

# gcc/g++はbrewでのインストール時に"gcc", "g++"で/usr/local/binにPATHが通らないのでシンボリックリンクを作成
# unlink /usr/local/bin/gcc
# path=`find /usr/local/Cellar/gcc -name "gcc-10"`
# ln -s path /usr/local/bin/gcc
# unlink /usr/local/bin/g++
# path=`find /usr/local/Cellar/gcc -name "g++-10"`
# ln -s path /usr/local/bin/gcc

# Rust用ディレクトリの作成 & Rustのインストール
while read -p "Do You install Rust? y/n: " yn; do
    if [ $yn = "y" ]; then
        if  [ ! -d ~/rust/ ]; then
            echo HELLO
            mkdir ~/rust
        fi
        echo "Start to install Rust..."
        # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        break
    elif [ $yn = "n" ]; then
        echo "Don't install Rust."
        break
    else
        echo "Please Input y or n."
    fi
done

# ssh関連
if [ ! -d ~/.ssh ]; then
    chmod 755 ~
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi