alias ls="exa -F"
alias la="exa -aF"
alias ll="exa -hlF --git"
alias lla="exa -ahlF --git"
alias lt="exa -FT"
alias lta="exa -FTa"
alias llt="exa -hlFT --git"
alias llta="exa -hlFTa --git"

# An function to display colored git branch name
function prompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # Return nothing if an directory is not tracking
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # When all files is commited
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # When there is a file not tracking by git
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # When there is a file not adding
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # When there is a file not commited
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # When an conflict is occured
    echo "%F{red}!(no branch)"
    return
  else
    # Other
    branch_status="%F{blue}"
  fi
  # Display colored git branch name
  echo "${branch_status}[$branch_name]"
}

# Evaluate and replacement prompt strings every time prompt is displayed
setopt prompt_subst

# Dipslay the function result right side of the prompt
RPROMPT='`prompt-git-current-branch`'

# Display only path on prompt & start a new line after command execution
PS1=""$'\n'"%B%F{cyan}%~%f%b $ "
