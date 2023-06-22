# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.0
# Case-sensitive completion must be off. _ and - will be interchangeable.\
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git thefuck python zoxide brew systemd colorize cp compleat dircycle dirpersist extract rsync screen safe-paste ssh-agent sprunge tmux lol tmuxinator urltools wakeonlan web-search aliases zsh-autosuggestions zsh-syntax-highlighting zoxide dirhistory history copypath copyfile sudo copybuffer colored-man-pages fancy-ctrl-z command-not-found)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias H="tail -n 100 ~/.zsh_history"
alias -g PASTE="| pastebinit"
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
PROMPT="${PROMPT/\%c/\%~}"
alias ENV="cat ~/ENVman.md"
alias Aliases="nano ~/.zshrc"
alias pbpaste="powershell.exe -command 'Get-Clipboard' | sed -e 's/\r\n$//g'"
alias xclip="xclip -selection c"
# usage: cheat bash/sed
cheat(){
    curl cht.sh/"$1" | less
}
alias K="~/kill.sh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#######################################
# Automated python virtual environment.
#######################################
# We export this string to tell pipenv that we want the venv files in the project dir (under .venv)
export PIPENV_VENV_IN_PROJECT=1
# Next we make the function that is based off of our current directory ($PWD)
VENV(){
if ! [ -x "$(command -v pipenv)" ]; then
     echo "pipenv not installed... installing it now!"
     sudo apt remove pipenv -y
     sudo pip install -U pip setuptools wheel
     sudo pip3 install --upgrade setuptools pip
     sudo apt install python-pip -y
     sudo pip install --upgrade pip wheel setuptools requests
     sudo pip3 install pipenv
     sudo apt install pipenv -y
     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py\
     sudo python3 get-pip.py --force-reinstall
     pip3 install pipenv --upgrade
     sudo apt install python-is-python3 -y
     echo "Installation complete!"
fi
if [ -n "$1" ]; then
        echo -e "Args detected, specifically using version $1 of python in this project!"
        version="$1"
else
        version=$(python -V)
        version=$(echo "$version" | sed -e 's/Python //')
        if [ -z "$version" ]; then
                version=$(python3 -V)
                if [ -z "$version" ]; then
                         echo "No python version installed... exiting."
                         return
                fi
        fi
fi
echo -e "\n===========\nCreate a Python $version virtual environment in $PWD/.venv [y/n]?\n==========="
read answer
case $answer in
    [yY][eE][sS]|[yY])
sudo pip install -U pip setuptools wheel
sudo pip3 install --upgrade setuptools pip
export PIPENV_VENV_IN_PROJECT=1
pipenv --python "$version"
pipenv install -r ./requirements.txt
sleep 2
clear
echo -e "Virtual python environment successfully created @ $PWD/.venv!\n"
echo -e "To run commands from this dir use 'pipenv run python ./main.py'"
echo -e "To enter a shell in this venv use 'pipenv shell'."
echo -e "To install from a requirements text file use 'pipenv install -r requirements.txt'"
echo -e "To update pip + all pip modules use 'pipenv update'!\n"
echo -e "Additional information can be found @ https://pipenv-fork.readthedocs.io/en/latest/basics.html"
;;
    [nN][oO]|[nN])
        echo "Fine then weirdo why did you run the command then, jeez."
;;
 *)
 echo "Invalid input..."
 ;;
 esac
}

# NOTE: Remember, you must use ls -a to see the .venv folder, since folders/files that start with a . are hidden by default!
# Since we are using pipenv for our python commands in the venv this is convenient and does not clutter standard directory view.

U(){
  sudo apt-get update -y
  sudo aptitude safe-upgrade -y 
  sudo apt-get autoclean -y
  sudo apt autoremove -y
}



NEWLINE='
'
commands=''
IFS="$NEWLINE"
appkill(){
        procs="$(pgrep -f "$kill")" 2>/dev/null
        commands=''
        for proc in $procs; do
                commandname="$proc: $(ps -p "$proc" -o command | sed -n '2 p')"

                if [[ "$commandname" != *"kill.sh"* ]]; then
                        sudo kill -9 "$proc" 2>/dev/null
                        result="$?"
                        commands="$commandname$NEWLINE$commands"
                fi
        done


        if [[ $result == 0 ]]; then
                echo -e "\n===================\nProcess(es) killed:\n==================="
                printf "%s\n" "$commands"
                commands=''
        else
                echo -e "** ! ERROR ! **\nNo processes containing '$kill' found.\n"
        fi
}
K(){
echo -e "===================================\n= YSG's ez app killer script 1.1 =\n===================================\n"
echo -e "***** ! WARNING ! *****"
echo -e "This script uses fuzzy matching.\nFor example, entering something like 'sh' will kil\\\\\\\\\\QA#Rw l every script on your system.\nUse wit>moar=1


if [ -n "$1" ]; then
        kill="$1"
        appkill
        if [ "$2" = "-s" ]; then
                exit 0
        fi
fi

while [ $moar != 0 ]; do
        echo "Enter portion of app name you want to kill (Q to exit):"
        read -r kill
        if [ -n "$kill" ]; then

                if [[ "$kill" == "Q" || "$kill" == "q" ]]; then
                        echo -e "\nExiting script...\n"
                        sleep 1
                        exit 0
                fi
                appkill
        else
                echo -e  "Please enter a valid app name..\n"
                continue
        fi
done
}