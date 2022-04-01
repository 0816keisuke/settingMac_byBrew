# Setting Your Macbook by Homebrew!

## Caution
Before you use this repository, you are required to install Homebrew and create a path of "brew" command.  

Homebrew: [click here](https://brew.sh)

## How to Use
1. Install homebrew
2. Create a path of command "brew"
3. Run the following commands
```
$ cd ~
$ git clone https://github.com/0816keisuke/settingMac_byBrew.git
$ cd settingMac_byBrew

(Write down Homebrew formulae/casks to file "BrewList")

$ ./setup
```

## How to Write BrewList
Write down Homebrew formulae/casks to file "BrewList."  
The head of formulae list has to be "--formulae", and of casks list has to be "--casks."  
If you want to comment-out in this file, use hash-tag "#" if you want to comment out a line.  
  
The following is an example of BrewList.  
```
# Last edited on 2022/04/01.

--formulae
git
python@3.9
gcc
# vim

--casks
google-chrome
slack
visual-studio-code
# zoom
```
-> In this case, brew install `git`, `python@3.9`, `gcc`, `google-chrome`, `slack`, `visual-studio-code`.

## License
The source code is licensed MIT.  
The website content is licensed CC BY 4.0, see LICENSE.
