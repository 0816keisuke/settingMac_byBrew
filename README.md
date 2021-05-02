# README
## How to Use
```
$ cd ~
$ git clone https://github.com/0816keisuke/settingMac_byBrew.git
$ cd settingMac_byBrew

(Write down Homebrew formulae/casks to file "BrewList")

$ sh setup.sh
```

## How to Write BrewList
Write down Homebrew formulae/casks to file "BrewList."  
The head of formulae list has to be "--formulae", and of casks list has to be "--casks"  
In this file, use hash-tag "#" if you want to comment out a line.  
  
The following is an example of BrewList.  
```
# Last edited on 2021/04/04.

--formulae
git
python@3.8
gcc@10
# vim

--casks
google-chrome
slack
visual-studio-code
# skype
```

## Caution
Before you use this repository, you are required to install Homebrew and create a path of "brew" command.  
> Homebrew
>> https://brew.sh

## License
The source code is licensed MIT.  
The website content is licensed CC BY 4.0, see LICENSE.
