#!/bin/bash

# Copyright (c) 2021 Keisuke.Fukada (0816keisuke)
# This software is released under the MIT License, see LICENSE.

# Check Homebrew
while read -p "Did you install Homebrew? y/n: " yn; do
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
# set -e -o pipefail
# trap 'echo "ERROR: line $LINENO, exit status = $?." >&2; exit 1' ERR

# Read BrewList & delete blank line and comment-out line & make BrewList list
all_list=(`cat BrewList | grep -vE "^$|#"`)

# Check spelling of "--formulae"
if [ ${all_list[0]} != "--formulae" ]; then
    echo "'--formulae' is NOT written. Exit."
    exit
fi

# Check spelling of "--casks"
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
    printf "\\nSearching $formulae... "
    brew search $formulae > /dev/null 2>&1
    if [ $? -eq 1 ]; then # If couldn't find formulae
        echo "We couldn't find '$formulae,' maybe '$formulae' is spelled wrong."
        while read -p "Continue(c) or Exit(e)? c/e: " ce; do
            if [ $ce = "c" ]; then
                break
            elif [ $ce = "e" ]; then
                exit
            else
                echo "Enter c or e."
            fi
        done
    else # If can find formulae
        printf "OK\\n"
        echo "Installing $formulae..."
        brew install $formulae
    fi
done

# Install casks
for cask in ${cask_list[@]}; do
    printf "\\nSearching $cask..."
    brew search $cask > /dev/null 2>&1
    if [ $? -eq 1 ]; then # If couldn't find cask
        echo "We couldn't find '$cask,' maybe '$cask' is spelled wrong."
        while read -p "Continue(c) or Exit(e)? c/e: " ce; do
            if [ $ce = "c" ]; then
                break
            elif [ $ce = "e" ]; then
                exit
            else
                echo "Enter c or e."
            fi
        done
    else # If can find cask
        printf "OK\\n"
        echo "Installing $cask..."
        brew install --cask $cask
    fi
done

# Install color-scheme of iTerm2 (iceberg)
curl -o ~/Downloads/iceberg.itermcolors -O https://raw.githubusercontent.com/aseom/dotfiles/master/osx/iterm2/iceberg.itermcolors

# SSH
if [ ! -d ~/.ssh ]; then
    chmod 755 ~
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi
while read -p "\\nDo you generate RSA-key for SSH? y/n: " yn; do
    if [ $yn = "y" ]; then
        cd ~/.ssh
        echo "Generate ssh-key RSA 4096-bit."
        ssh-keygen -b 4096 -t rsa
        break
    elif [ $yn = "n" ]; then
        echo "Don't generate RSA-key."
        break
    else
        echo "Enter y or n."
    fi
done

# Create file .gitconfig
if [ ! -e ~/.gitconfig ]; then
    touch ~/.gitconfig
fi

# Set .gitconfig
while read -p "Do you set .gitconfig? y/n: " yn; do
    if [ $yn = "y" ]; then
        echo
        read -p "Enter your user name on Git: " git_user_name
        read -p "Enter your mail address on Git: " git_mail
        git config --global user.name $git_user_name
        git config --global user.email $git_mail
        break
    elif [ $yn = "n" ]; then
        echo "Don't set .gitconfig."
        break
    else
        echo "Enter y or n."
    fi
done

# .zshrc
cp ./.zshrc ~/.zshrc

# Create .vimrc
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
echo
while read -p "Do you install Rust? y/n: " yn; do
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

echo "\\nSetting Mac is DONE! Have a good Mac-life!!"