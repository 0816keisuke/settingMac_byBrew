#!/bin/bash

# Copyright (c) 2021 Keisuke.Fukada (0816keisuke)
# This software is released under the MIT License, see LICENSE.

# Check Homebrew
while read -p "Do You have Homebrew? y/n: " yn; do
    if [ $yn = "y" ]; then
        # Check the path of command "brew"
        which brew > /dev/null
        if [ $? != 0 ]; then
            echo "Command 'brew' is not find. Create path of 'brew'. Exit."
            exit
        fi
        break
    elif [ $yn = "n" ]; then
        echo "Install Homebrew and create path of 'brew' command first."
        echo "You can install from the following URL. Exit."
        echo "https://brew.sh"
        exit
    else
        echo "Enter y or n."
    fi
done

# Terminate execution when an error is occured
set -e -o pipefail
trap 'echo "ERROR: line $LINENO, exit status = $?." >&2; exit 1' ERR

# Read BrewList & delete blank line and comment-out line & make BrewList list
all_list=(`cat BrewList | grep -vE "^$|#"`)

# Check spelling "--formulae"
if [ ${all_list[0]} != "--formulae" ]; then
    echo "'--formulae' is NOT written. Exit."
    exit
fi

# Check spelling "--casks"
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

# Make installing formulae list
unset formulae_list[0]
for ((i=$idx; i<${#all_list[@]}; i++)); do
    unset formulae_list[$i]
done
formulae_list=(${formulae_list[@]})

# Make installing casks list
for ((i=0; i<=$idx; i++)); do
    unset cask_list[$i]
done
cask_list=(${cask_list[@]})

# echo "     all: ${all_list[@]}"
# echo "formulae: ${formulae_list[@]}"
# echo "    cask: ${cask_list[@]}"

# Install formulae
for formulae in ${formulae_list[@]}; do
    echo "\\nInstalling $formulae..."
    brew install $formulae
done

# Install casks
for cask in ${cask_list[@]}; do
    echo "\\nInstalling $cask..."
    brew install --cask $cask
done

# Install color-scheme of iTerm2 (iceberg)
curl -o ~/Downloads/iceberg.itermcolors -O https://raw.githubusercontent.com/aseom/dotfiles/master/osx/iterm2/iceberg.itermcolors

# Create file gitconfig
if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig
fi

read -p "Enter your user name on Git: " git_user_name
read -p "Enter your mail address on Git: " git_mail
git config --global user.name $git_user_name
git config --global user.email $git_mail

# .zshrc
cp ./.zshrc ~/.zshrc

# Create vimrc
if [ ! -e ~/.vimrc ]; then
    touch ~/.vimrc
fi

# Create lab directory
if [ ! -d ~/lab ]; then
    mkdir ~/lab
fi

# Create Python directory
if [ ! -d ~/python ]; then
    mkdir ~/python
fi

# Create C/C++ directory
if [ ! -d ~/c_cpp ]; then
    mkdir ~/c_cpp
fi

# unlink /usr/local/bin/gcc
# path=`find /usr/local/Cellar/gcc -name "gcc-10"`
# ln -s path /usr/local/bin/gcc
# unlink /usr/local/bin/g++
# path=`find /usr/local/Cellar/gcc -name "g++-10"`
# ln -s path /usr/local/bin/gcc

# Create Rust directory & install Rust
while read -p "Do You install Rust? y/n: " yn; do
    if [ $yn = "y" ]; then
        if  [ ! -d ~/rust ]; then
            mkdir ~/rust
        fi
        echo "Start to install Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        break
    elif [ $yn = "n" ]; then
        echo "Don't install Rust."
        break
    else
        echo "Enter y or n."
    fi
done

# SSH
if [ ! -d ~/.ssh ]; then
    chmod 755 ~
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    echo "Generate ssh-key RSA 4096-bit."
    ssh-keygen -b 4096 -t rsa
fi

echo "Setting Mac is DONE! Have a good Mac-life!!"