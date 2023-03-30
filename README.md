# Let's Set Your Macbook by Homebrew!

## Caution

Before you use this repository, you are required to install [Homebrew](https://brew.sh) and create a path of `brew` command.  

## How to Use

1. Install [Homebrew](https://brew.sh)
2. Create a path of command `brew`
3. Run the following commands:

```bash
$ cd ~
$ git clone https://github.com/0816keisuke/settingMac_byBrew.git
$ cd settingMac_byBrew

(Write down Homebrew formulae/casks to file "BrewList")

$ ./setup
```

## How to Write BrewList

Write down Homebrew formulae/casks to file `BrewList`.  
The head of formulae list has to be `--formulae`, and of casks list has to be `--casks`.  
If you want to comment-out a line in this file, use hash-tag `#`.  
  
The following is an example of `BrewList`.  

```text
# Last edited on 2023/03/30.

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

-> In this case, `brew` will install `git`, `python@3.9`, `gcc`, `google-chrome`, `slack`, `visual-studio-code`.

## License

The source code is licensed MIT.  
The website content is licensed CC BY 4.0, see LICENSE.
